function game_new()
  local fade_dur = 0.5
  local overworld = overworld_new()
  local title_screen = title_screen_new()
  local state = { title = title_screen }
  local me = {}

  local function fade_out(current, next, next_state)
    state = {
      fade_out = true,
      t0 = time(),
      draw = function() current:draw() end,
      draw2 = function() next:draw() end,
      next_state = next_state
    }
  end

  local function fade_in(draw2, next_state)
    state = {
      fade_in = true,
      t0 = time(),
      draw = draw2,
      next_state = next_state
    }
  end

  local function update_overworld()
    local result = overworld:update()
    if not result then return end

    if result.battle then
      music(0)
      fade_out(overworld, result.battle, { battle = result.battle })
    elseif result.location then
      if result.location == townsman then
        music(6)
      end
      result.location:load()
      fade_out(overworld, result.location, { location = result.location })
    end
  end

  local function update_battle()
    local result = state.battle:update()
    if not result then return end

    if result.victory then
      music(3)
      fade_out(state.battle, overworld, { overworld = overworld })
    elseif result.defeat then
      music(3)
      load_game()
      reset_player()
      fade_out(state.battle, overworld, { overworld = overworld })
    end
  end

  local function update_location()
    local result = state.location:update()
    if not result then return end

    if result == "game_over" then
      load_game()
      reset_player()
      fade_out(state.location, overworld, { overworld = overworld })
    elseif result == "bad_ending" then
      fade_out(state.location, bad_ending_text_crawl, { bad_ending = bad_ending_text_crawl })
    elseif result == "good_ending" then
      fade_out(state.location, good_ending_text_crawl, { good_ending = good_ending_text_crawl })
    else
      music(3)
      fade_out(state.location, overworld, { overworld = overworld })
    end
  end

  function me:update()
    if state.title then
      local result = state.title:update()
      if result == "new" then
        new_game()
        load_game()
        opening_text_crawl:load()
        fade_out(state.title, opening_text_crawl, { opening = opening_text_crawl })
      elseif result then
        load_game()
        reset_player()
        music(3)
        fade_out(state.title, overworld, { overworld = overworld })
      end
    elseif state.opening and state.opening.update() then
      music(3)
      fade_out(state.opening, overworld, { overworld = overworld })
    elseif state.overworld then
      update_overworld()
    elseif state.battle then
      update_battle()
    elseif state.location then
      update_location()
    elseif state.bad_ending and state.bad_ending.update() then
      fade_out(state.bad_ending, title_screen, { title = title_screen })
    elseif state.good_ending and state.good_ending.update() then
      fade_out(state.good_ending, title_screen, { title = title_screen })
    elseif state.fade_out and time() - state.t0 >= fade_dur then
      fade_in(state.draw2, state.next_state)
    elseif state.fade_in and time() - state.t0 >= fade_dur then
      state = state.next_state
    end
  end

  function me:draw()
    if state.fade_out then
      local progress = (time() - state.t0) / fade_dur
      screen_fade_out(state.draw, progress)
    elseif state.fade_in then
      local progress = (time() - state.t0) / fade_dur
      screen_fade_in(state.draw, progress)
    elseif state.title then
      state.title:draw()
    elseif state.opening then
      state.opening:draw()
    elseif state.bad_ending then
      state.bad_ending:draw()
    elseif state.good_ending then
      state.good_ending:draw()
    elseif state.overworld then
      overworld:draw()
    elseif state.battle then
      state.battle:draw()
    elseif state.location then
      state.location:draw()
    end
  end

  return me
end