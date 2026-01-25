function overworld_new()
  local moving_dur = 0.5

  local voluntary_locations = {
    ["5,9"] = townsman,
    ["1,7"] = wizard,
    ["1,13"] = fairy1,
    ["11,13"] = fairy2,
    ["9,5"] = priestess,
    ["3,5"] = "tomb",
    ["11,3"] = bad_ending,
    ["13,9"] = fairy3,
    ["13,11"] = sage
  }

  local involuntary_locations = {
    ["11,9"] = dragon,
    ["13,7"] = good_ending
  }

  local side_frames = { 42, 43 }
  local up_frames = { 44, 45, 46 }
  local down_frames = { 60, 61, 62 }

  local state = { ready = true }
  local me = {}

  function me:load()
  end

  function me:update()
    if state.ready then
      local tx, ty = global.coord.tx, global.coord.ty
      if btnp(0) and mget(tx - 1, ty) == 114 and mget(tx - 2, ty) == 113 then
        global.coord.dx = -1
        global.coord.dy = 0
        state = { moving = true, tx = tx - 2, ty = ty, t0 = time() }
      elseif btnp(1) and mget(tx + 1, ty) == 114 and mget(tx + 2, ty) == 113 then
        global.coord.dx = 1
        global.coord.dy = 0
        state = { moving = true, tx = tx + 2, ty = ty, t0 = time() }
      elseif btnp(2) and mget(tx, ty - 1) == 165 and mget(tx, ty - 2) == 113 then
        global.coord.dx = 0
        global.coord.dy = -1
        state = { moving = true, tx = tx, ty = ty - 2, t0 = time() }
      elseif btnp(3) and mget(tx, ty + 1) == 165 and mget(tx, ty + 2) == 113 then
        global.coord.dx = 0
        global.coord.dy = 1
        state = { moving = true, tx = tx, ty = ty + 2, t0 = time() }
      elseif btnp(4) then
      end
    elseif state.moving then
      local done = time() - state.t0 > moving_dur

      if done then
        global.coord.tx = state.tx
        global.coord.ty = state.ty
        state = { enter = true }
      else
        global.coord.tx += global.coord.dx * 2 / (30 * moving_dur)
        global.coord.ty += global.coord.dy * 2 / (30 * moving_dur)
      end
    elseif state.enter then
      state = { ready = true }
    end
  end

  function me:draw()
    local coord = global.coord
    local coord_key = coord.tx .. "," .. coord.ty
    local player_x = coord.tx * 8
    local player_y = coord.ty * 8 - 4
    local player_flip_x = coord.dx > 0
    local loc = voluntary_locations[coord_key]

    local frames = global.coord.dx ~= 0 and side_frames
        or global.coord.dy < 0 and up_frames
        or global.coord.dy > 0 and down_frames

    rectfill(0, 0, 127, 27, 13)
    rectfill(0, 24, 127, 27, 14)
    circfill(91, 27, 8, 14)
    circfill(91, 27, 4, 8)
    rectfill(0, 28, 127, 127, 0)
    map()

    for tx = 0, 15 do
      for ty = 0, 15 do
        local tile = mget(tx, ty)
        if tile == 165 then
          rectfill(tx * 8 + 3, ty * 8 - 1, tx * 8 + 4, ty * 8 + 8, 15)
        end
      end
    end

    if state.ready or state.enter then
      spr_outline(frames[1], player_x, player_y, player_flip_x)
    elseif state.moving then
      local frame = flr(time() * 6) % #frames + 1
      spr_outline(frames[frame], player_x, player_y, player_flip_x)
    end

    if loc then
      local msg = "\142 enter"
      local x = player_x - (#msg * 2) + 2
      local y = player_y - 8
      tint_palette(0)
      for x = x - 1, x + 1 do
        for y = y - 1, y + 1 do
          print(msg, x, y, 7)
        end
      end
      pal()
      print(msg, x, y)
    end
  end

  return me
end