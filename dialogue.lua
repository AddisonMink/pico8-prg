function dialogue_new(string, tools)
  local x, y, w, h = 4, 44, 120, 80
  local pages = {}
  local page_idx = 1
  local text_crawl_done = false
  local option_idx = 1
  local me = {}

  -- Transition state
  local state = "normal"
  -- "normal", "fade_out", "fade_in"
  local transition_progress = 0
  local transition_duration = 1.0
  -- seconds for full fade

  local current_page = nil
  local in_body = false

  for line in all(split(string, "\n")) do
    if sub(line, 1, 5) == "@page" then
      if current_page then
        add(pages, current_page)
      end
      current_page = {
        title = "",
        body = "",
        options = {},
        callback = nil,
        screen_transition = false
      }
      in_body = false
    elseif current_page then
      if sub(line, 1, 6) == "@title" then
        current_page.title = sub(line, 8)
      elseif sub(line, 1, 5) == "@body" then
        in_body = not in_body
      elseif sub(line, 1, 7) == "@option" then
        add(current_page.options, sub(line, 9))
      elseif sub(line, 1, 9) == "@callback" then
        current_page.callback = sub(line, 11)
      elseif sub(line, 1, 18) == "@screen_transition" then
        current_page.screen_transition = true
      elseif in_body then
        if current_page.body == "" then
          current_page.body = line
        else
          current_page.body = current_page.body .. "\n" .. line
        end
      end
    end
  end

  if current_page then
    add(pages, current_page)
  end

  for page in all(pages) do
    page.title = rich_text_parse(page.title)
    page.body = text_crawl_new(page.body, w - 8)

    if #page.options == 0 then
      add(page.options, "Continue")
    end

    for i = 1, #page.options do
      page.options[i] = rich_text_parse(page.options[i])
    end
  end

  function me:load()
    page_idx = 1
    option_idx = 1
    state = "normal"
    transition_progress = 0
    if #pages > 0 then
      pages[page_idx].body:load()
    end
    text_crawl_done = false
  end

  local function advance_to_next_page()
    if page_idx < #pages then
      page_idx += 1
      option_idx = 1
      pages[page_idx].body:load()
      text_crawl_done = false
    else
      return true -- dialogue is complete
    end
    return false
  end

  local function start_transition()
    state = "fade_out"
    transition_progress = 0
  end

  function me:update()
    if #pages == 0 then return end

    local page = pages[page_idx]

    -- Handle transition states
    if state == "fade_out" then
      transition_progress += 1 / (transition_duration * 30) -- assuming 30 FPS
      if transition_progress >= 1 then
        transition_progress = 0
        state = "fade_in"
        local is_complete = advance_to_next_page()
        if is_complete then
          return option_idx
        end
      end
      return
    elseif state == "fade_in" then
      transition_progress += 1 / (transition_duration * 30)
      if transition_progress >= 1 then
        transition_progress = 0
        state = "normal"
      end
      return
    end

    -- Normal state handling
    if text_crawl_done then
      if btnp(2) then
        option_idx = (option_idx - 2) % #page.options + 1
      elseif btnp(3) then
        option_idx = option_idx % #page.options + 1
      elseif btnp(4) then
        local callback_result = nil
        if page.callback then
          callback_result = tools[page.callback](option_idx)
        end
        if callback_result and callback_result.result then
          return callback_result.result
        elseif callback_result and callback_result.page then
          page_idx = callback_result.page
          option_idx = 1
          pages[page_idx].body:load()
          text_crawl_done = false
        elseif page.screen_transition and page_idx < #pages then
          start_transition()
        elseif page_idx < #pages then
          page_idx += 1
          option_idx = 1
          pages[page_idx].body:load()
          text_crawl_done = false
        else
          return option_idx
        end
      end
    else
      text_crawl_done = page.body:update()
    end
  end

  local function draw_current_page()
    local page = pages[page_idx]
    local x, y = x, y
    local option_y = y + h - (#page.options * 10)

    draw_panel(1, x, y, w, h)
    x += 4
    y += 5
    rich_text_print(page.title, x, y)
    y += 10
    page.body:draw(x, y)

    if not text_crawl_done then return end

    local y = option_y
    for i, option in ipairs(page.options) do
      rich_text_print(option, x + 10, y)
      if i == option_idx then
        spr(16, x, y)
      end
      y += 10
    end
  end

  local function draw_next_page()
    local page = pages[page_idx]
    rich_text_print(page.title, 0, 0)
  end

  function me:draw()
    if #pages == 0 then return end

    if state == "fade_out" then
      screen_fade_out(function() draw_current_page() end, transition_progress)
    elseif state == "fade_in" then
      screen_fade_in(function() draw_next_page() end, transition_progress)
    else
      draw_current_page()
    end
  end

  return me
end