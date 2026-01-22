function rich_text_parse(string, w)
  local w = w or 128
  local whitespace = { [" "] = true, ["\n"] = true, ["\t"] = true }
  local punctuation = { ["."] = true, [","] = true, ["!"] = true, ["?"] = true }

  local buffer = ""
  local state = "text"
  local last_visible_token = nil
  local tokens = {}

  -- Flush the current buffer into a token of the given type.
  -- Also links visible tokens together via the `next` field.
  local function flush_buffer(type)
    if buffer ~= "" then
      local token = { [type] = buffer }
      add(tokens, token)

      if token.text or token.icon then
        if last_visible_token then
          last_visible_token.next = token
        end
        last_visible_token = token
      end

      buffer = ""
    end
  end

  -- Pico8 displays lower-case letters as upper-case, and upper-case as lower-case.
  -- So we need to reverse the capitalization of letters so they appear as the correct case.
  local function reverse_capitalization(c)
    local code = ord(c)
    return code >= 65 and code <= 90 and chr(code + 32)
        or code >= 97 and code <= 122 and chr(code - 32)
        or c
  end

  -- Parse the string into tokens, ignoring whitespace and separating punctuation into its own tokens.
  for c in all(string) do
    if c == "<" and state == "text" then
      flush_buffer("text")
      state = "tag"
    elseif c == ">" and state == "tag" then
      local t = buffer[1] == "c" and "set_color"
          or buffer[1] == "r" and "reset_color"
          or buffer[1] == "n" and "newline"
          or buffer[1] == "i" and "icon"
      flush_buffer(t)
      state = "text"
    elseif whitespace[c] and state == "text" then
      flush_buffer("text")
    elseif punctuation[c] and state == "text" then
      flush_buffer("text")
      buffer = c
      flush_buffer("text")
    else
      c = state == "tag" and c or reverse_capitalization(c)
      buffer = buffer .. c
    end
  end

  flush_buffer(state)

  -- Insert space tokens between visible tokens unless the next token is punctuation.
  local spaced_tokens = {}
  for token in all(tokens) do
    add(spaced_tokens, token)
    if token.text or token.icon then
      local punctuated = token.next and token.next.text and punctuation[token.next.text]
      if not punctuated and token.next then
        add(spaced_tokens, { space = true, next = token.next })
      end
    end
  end

  -- Perform word-wrapping based on the given width.
  local wrapped_tokens = {}
  local line_width = 0
  for token in all(spaced_tokens) do
    if token.text then
      add(wrapped_tokens, token)
      line_width += #token.text * 4
    elseif token.icon then
      add(wrapped_tokens, token)
      line_width += 5
    elseif token.newline then
      add(wrapped_tokens, token)
      line_width = 0
    elseif token.space then
      local next_width = token.next
          and (token.next.text and #token.next.text * 4
            or token.next.icon and 5 or 0)
          or 0

      local new_width = line_width + 4 + next_width
      if new_width > w then
        add(wrapped_tokens, { newline = true })
        line_width = 0
      else
        add(wrapped_tokens, token)
        line_width += 4
      end
    else
      add(wrapped_tokens, token)
    end
  end

  return wrapped_tokens
end

function rich_text_draw_token(token, start_x, color, x, y, color_override)
  if token.text then
    x = print(token.text, x, y, color_override or color)
  elseif token.space then
    x = x + 4
  elseif token.newline then
    x = start_x
    y += 8
  elseif token.set_color then
    color = sub(token.set_color, 2)
  elseif token.reset_color then
    color = 7
  elseif token.icon then
    if color_override then
      for i = 0, 15 do
        pal(i, color_override)
      end
    end
    spr(sub(token.icon, 2), x, y)
    if color_override then
      pal()
    end
    x += 5
  end
  return x, y, color
end

function rich_text_print(tokens, x, y, color_override)
  local start_x = x
  local color = 7

  for token in all(tokens) do
    x, y, color = rich_text_draw_token(token, start_x, color, x, y, color_override)
  end
end