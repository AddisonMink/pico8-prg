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