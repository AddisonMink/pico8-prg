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

  local battle_locations = {
    ["3,9"] = { enemy_goblin },
    ["1,9"] = { enemy_goblin_warrior, enemy_goblin },
    ["1,11"] = { enemy_goblin_mage, enemy_goblin_warrior },
    ["7,9"] = { enemy_goblin_warrior, enemy_goblin },
    ["9,9"] = { enemy_goblin_mage, enemy_goblin_warrior },
    ["9,11"] = { enemy_goblin_warrior, enemy_goblin },
    ["11,11"] = { enemy_goblin_mage, enemy_goblin_warrior },
    ["9,7"] = { enemy_zombie, enemy_zombie },
    ["7,5"] = { enemy_zombie, enemy_zombie },
    ["5,5"] = { enemy_ghost, enemy_zombie },
    ["11,5"] = { enemy_ghost, enemy_zombie }
  }

  local side_frames = { 42, 43 }
  local up_frames = { 44, 45, 46 }
  local down_frames = { 60, 61, 62 }

  local coord = { tx = 5, ty = 9, dx = 1, dy = 0 }
  local battles_locations_fought = {}
  local state = { ready = true }
  local me = {}

  function me:load()
    coord = { tx = 5, ty = 9, dx = 1, dy = 0 }
    battles_locations_fought = {}
  end

  function me:update()
    if state.ready then
      local tx, ty = coord.tx, coord.ty
      if btnp(0) and mget(tx - 1, ty) == 114 and mget(tx - 2, ty) == 113 then
        coord.dx = -1
        coord.dy = 0
        state = { moving = true, tx = tx - 2, ty = ty, t0 = time() }
      elseif btnp(1) and mget(tx + 1, ty) == 114 and mget(tx + 2, ty) == 113 then
        coord.dx = 1
        coord.dy = 0
        state = { moving = true, tx = tx + 2, ty = ty, t0 = time() }
      elseif btnp(2) and mget(tx, ty - 1) == 165 and mget(tx, ty - 2) == 113 then
        coord.dx = 0
        coord.dy = -1
        state = { moving = true, tx = tx, ty = ty - 2, t0 = time() }
      elseif btnp(3) and mget(tx, ty + 1) == 165 and mget(tx, ty + 2) == 113 then
        coord.dx = 0
        coord.dy = 1
        state = { moving = true, tx = tx, ty = ty + 2, t0 = time() }
      elseif btnp(4) then
        local key = tx .. "," .. ty
        local loc = voluntary_locations[key]
        if loc then
          return { location = loc }
        end
      end
    elseif state.moving then
      local done = time() - state.t0 > moving_dur

      if done then
        coord.tx = state.tx
        coord.ty = state.ty
        state = { enter = true }
      else
        coord.tx += coord.dx * 2 / (30 * moving_dur)
        coord.ty += coord.dy * 2 / (30 * moving_dur)
      end
    elseif state.enter then
      local coord_key = coord.tx .. "," .. coord.ty
      local loc = involuntary_locations[coord_key]
      local bat = battle_locations[coord_key]
      local bat_fought = bat and battles_locations_fought[coord_key]
      local enemy = bat and (bat_fought and bat[2] or bat[1])

      state = { ready = true }

      if loc then
        return { location = loc }
      elseif enemy then
        battles_locations_fought[coord_key] = true
        return { battle = battle_new(enemy) }
      end
    end
  end

  function me:draw()
    local coord_key = coord.tx .. "," .. coord.ty
    local player_x = coord.tx * 8
    local player_y = coord.ty * 8 - 4
    local player_flip_x = coord.dx > 0
    local loc = voluntary_locations[coord_key]

    local frames = coord.dx ~= 0 and side_frames
        or coord.dy < 0 and up_frames
        or coord.dy > 0 and down_frames

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