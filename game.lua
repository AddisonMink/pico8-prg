function game_new()
  local fade_dur = 0.5
  local overworld = overworld_new()
  local state = { opening = opening_text_crawl }
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
      fade_out(overworld, result.battle, { battle = result.battle })
    elseif result.location then
      fade_out(overworld, result.location, { location = result.location })
    end
  end

  local function update_battle()
    local result = state.battle:update()
    if not result then return end

    if result.victory then
      fade_out(state.battle, overworld, { overworld = overworld })
    elseif result.defeat then
      load_game()
      reset_player()
      fade_out(state.battle, overworld, { overworld = overworld })
    end
  end

  local function update_location()
    local result = state.location:update()
    if not result then return end

    if result then
      fade_out(state.location, overworld, { overworld = overworld })
    end
  end

  function me:update()
    if state.opening and state.opening.update() then
      state = { overworld = overworld }
    elseif state.overworld then
      update_overworld()
    elseif state.battle then
      update_battle()
    elseif state.location then
      update_location()
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
    elseif state.opening then
      overworld:draw()
      dither()
      state.opening:draw()
    elseif state.overworld then
      overworld:draw()
    elseif state.battle then
      state.battle:draw()
    elseif state.location then
      state.location:draw()
    end

    if not state.opening then
      draw_hud()
    end
  end

  return me
end