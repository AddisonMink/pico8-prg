function text_crawl_new(string, w, delay)
  delay = delay or 0.125
  local tokens = rich_text_parse(string, w)
  local t0 = 0
  local next_token_idx = 1
  local me = {}

  local function find_next_token_idx()
    next_token_idx = min(next_token_idx + 1, #tokens + 1)
    local token = tokens[next_token_idx]
    while next_token_idx <= #tokens and (token.set_color or token.reset_color) do
      next_token_idx += 1
      token = tokens[next_token_idx]
    end
  end

  function me:load()
    t0 = time()
    next_token_idx = 0
    find_next_token_idx()
  end

  function me:update()
    if next_token_idx > #tokens then
      return true
    elseif time() - t0 > delay then
      t0 = time()
      find_next_token_idx()
    end
  end

  function me:draw(x, y)
    local start_x, color = x, 7

    for i, token in ipairs(tokens) do
      local last = i == next_token_idx
      x, y, color = rich_text_draw_token(token, start_x, color, x, y, last and 5)
      if last then break end
    end
  end

  return me
end