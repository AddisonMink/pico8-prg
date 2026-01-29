function tint_palette(color)
  for i = 0, 15 do
    pal(i, color)
  end
end

function draw_background(id)
  for i = 0, 8 do
    spr(id, i * 16, 12, 2, 2)
  end
end

function dither()
  for x = 0, 127 do
    for y = 0, 127 do
      local dark = y % 2 == 0 and x % 2 == 0
          or y % 2 == 1 and x % 2 == 1

      if dark then
        pset(x, y, 5)
      end
    end
  end
end

function spr_outline(id, x, y, flip_x)
  tint_palette(0)
  for x = x - 1, x + 1 do
    for y = y - 1, y + 1 do
      spr(id, x, y, 1, 1, flip_x)
    end
  end
  pal()
  spr(id, x, y, 1, 1, flip_x)
end

function draw_npc(npc_sprite, x, y, size)
  local sx, sy = npc_sprite.sx, npc_sprite.sy

  for i = 0, 15 do
    pal(i, 0)
  end

  for x = x - 2, x + 2 do
    for y = y - 2, y + 2 do
      sspr(sx, sy, size, size, x, y, size * 2, size * 2)
    end
  end
  pal()
  sspr(sx, sy, size, size, x, y, size * 2, size * 2)
end

function draw_npcs(npc_sprite)
  local npc_x = 64 - 40
  local player_x = 64 + 8
  local character_y = 24 - 2
  local player_sx, player_sy = npc.player.sx, npc.player.sy

  if npc_sprite then
    local npc_sx, npc_sy = npc_sprite.sx, npc_sprite.sy
    local npc_size = npc_sprite.size or 16
    local npc_x = npc_size == 24 and npc_x - 5 or npc_x
    local npc_y = npc_size == 24 and character_y - 14 or character_y
    draw_npc(npc_sprite, npc_x, npc_y, npc_size)
  end
  draw_npc(npc.player, player_x, character_y, 16)
end

function screen_fade_out(draw, progress)
  draw()
  local frontier = flr(progress * 32)
  for tx = 0, 15 do
    for ty = 0, 15 do
      if tx + ty < frontier then
        rectfill(tx * 8, ty * 8, tx * 8 + 7, ty * 8 + 7, 0)
      end
    end
  end
end

function screen_fade_in(draw, progress)
  draw()
  local frontier = flr(progress * 32)
  for tx = 0, 15 do
    for ty = 0, 15 do
      if tx + ty > frontier then
        rectfill(tx * 8, ty * 8, tx * 8 + 7, ty * 8 + 7, 0)
      end
    end
  end
end

function draw_map()
  rectfill(0, 0, 127, 27, 13)
  rectfill(0, 24, 127, 27, 14)
  circfill(91, 27, 8, 14)
  circfill(91, 27, 4, 8)
  rectfill(0, 28, 127, 127, 0)
  map()
end

function update_index(index, max)
  return btnp(2) and (index - 2) % max + 1
      or btnp(3) and index % max + 1
      or index
end

function bool_to_int(b)
  return b and 1 or 0
end

function int_to_bool(i)
  return i ~= 0
end