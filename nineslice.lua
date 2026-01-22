function draw_panel(id, x, y, w, h)
  local sx = (id % 16) * 8
  local sy = flr(id / 16) * 8

  spr(id, x, y)
  spr(id + 1, x + w - 8, y)
  spr(id + 16, x, y + h - 8)
  spr(id + 17, x + w - 8, y + h - 8)
  sspr(sx + 4, sy, 8, 8, x + 8, y, w - 16, 8)
  sspr(sx, sy + 4, 8, 8, x, y + 8, 8, h - 16)
  sspr(sx + 4, sy + 8, 8, 8, x + 8, y + h - 8, w - 16, 8)
  sspr(sx + 8, sy + 4, 8, 8, x + w - 8, y + 8, 8, h - 16)
  sspr(sx + 4, sy + 4, 8, 8, x + 8, y + 8, w - 16, h - 16)
end