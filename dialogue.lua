function dialogue_new(load, string, tools)
  local x, y, w, h = 2, 58, 124, 66
  local transition_dur = 0.5
  local pages = {}
  local page_idx = 1
  local state = { normal = true }
  local me = {}

  local function initialize()
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
          option_idx = 1
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
        elseif sub(line, 1, 11) == "@background" then
          current_page.background = sub(line, 13)
        elseif sub(line, 1, 4) == "@npc" then
          current_page.npc = sub(line, 6)
        elseif sub(line, 1, 14) == "@state_machine" then
          current_page.state_machine = sub(line, 16)
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
      page.body = text_crawl_new(page.body, w - 10)

      if #page.options == 0 then
        add(page.options, "Continue")
      end

      for i = 1, #page.options do
        page.options[i] = rich_text_parse(page.options[i])
      end
    end
  end

  local function init_page()
    local page = pages[page_idx]
    page.body:load()
    page.text_crawl_done = false
    page.option_idx = 1
    page.state_machine_result = nil
    if page.state_machine then
      tools[page.state_machine]:load()
    end
  end

  function me:load()
    page_idx = load() or 1
    state = { normal = true }
    init_page()
  end

  local function advance_to_page(idx)
    local page = pages[page_idx]

    if page.screen_transition then
      state = { fade_out = time(), next_page_idx = idx }
    else
      page_idx = idx
      init_page()
    end
  end

  local function advance_to_next_page()
    local page = pages[page_idx]
    local callback_result = nil
    if page.callback then
      callback_result = tools[page.callback](page.option_idx)
    end

    if callback_result and callback_result.result then
      return callback_result.result
    elseif callback_result and callback_result.page then
      advance_to_page(callback_result.page)
    elseif page_idx < #pages then
      advance_to_page(page_idx + 1)
    else
      return page.option_idx
    end
  end

  function me:update()
    if #pages == 0 then return end
    local page = pages[page_idx]

    if page.state_machine and not page.state_machine_result then
      page.state_machine_result = tools[page.state_machine]:update()
    elseif page.state_machine and page.state_machine_result then
      return advance_to_next_page()
    elseif state.fade_in and time() - state.fade_in > transition_dur then
      state = { normal = true }
    elseif state.normal and page.text_crawl_done then
      if btnp(2) then
        page.option_idx = (page.option_idx - 2) % #page.options + 1
      elseif btnp(3) then
        page.option_idx = page.option_idx % #page.options + 1
      elseif btnp(4) then
        return advance_to_next_page()
      end
    elseif state.normal then
      page.text_crawl_done = page.body:update()
    elseif state.fade_out and time() - state.fade_out > transition_dur then
      page_idx = state.next_page_idx
      state = { fade_in = time() }
      init_page()
    end
  end

  local function draw_page()
    local page = pages[page_idx]

    if page.state_machine then
      tools[page.state_machine]:draw()
      return
    end

    local x, y = x, y
    local option_y = y + h - (#page.options * 10)

    if page.background then
      draw_background(background[page.background])
    end

    draw_npcs(npc[page.npc])

    draw_panel(1, x, y, w, h)
    x += 4
    y += 5
    rich_text_print(page.title, x, y)
    y += 10
    page.body:draw(x, y)

    if not page.text_crawl_done then return end

    local y = option_y
    for i, option in ipairs(page.options) do
      rich_text_print(option, x + 10, y)
      if i == page.option_idx then
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
    if state.fade_in then
      local progress = (time() - state.fade_in) / transition_dur
      screen_fade_in(draw_page, progress)
    elseif state.normal then
      draw_page()
    elseif state.fade_out then
      local progress = (time() - state.fade_out) / transition_dur
      screen_fade_out(draw_page, progress)
    end
  end

  initialize()
  return me
end