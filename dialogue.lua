function dialogue_new(string, tools)
  local pages = {}
  local page_idx = 1
  local text_crawl_done = false
  local option_idx = 1
  local me = {}

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
        callback = nil
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
    page.body = text_crawl_new(page.body)

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
    if #pages > 0 then
      pages[page_idx].body:load()
    end
    text_crawl_done = false
  end

  function me:update()
    if #pages == 0 then return end

    local page = pages[page_idx]

    if text_crawl_done then
      if btnp(2) then
        option_idx = (option_idx - 2) % #page.options + 1
      elseif btnp(3) then
        option_idx = option_idx % #page.options + 1
      elseif btnp(4) then
        local next_page = nil
        if page.callback then
          next_page = tools[page.callback](option_idx)
        end
        if next_page == -1 then
          return option_idx
        elseif next_page then
          page_idx = next_page
          option_idx = 1
          pages[page_idx].body:load()
          text_crawl_done = false
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

  function me:draw()
    if #pages == 0 then return end

    local page = pages[page_idx]

    rich_text_print(page.title, 0, 0)
    page.body:draw(0, 10)

    if not text_crawl_done then return end

    local y = 128 - (#page.options * 10)
    for i, option in ipairs(page.options) do
      rich_text_print(option, 10, y)
      if i == option_idx then
        spr(16, 0, y)
      end
      y += 10
    end
  end

  return me
end