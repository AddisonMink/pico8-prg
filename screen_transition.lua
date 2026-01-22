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