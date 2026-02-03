function title_screen_new()
  local index = 1
  local me = {}

  function me:load()
    index = 1
  end

  function me:update()
    index = (btnp(2) or btnp(3)) and (index % 2 + 1) or index
    if btnp(4) then
      return index == 1 and "new"
          or dget(0) == 1 and "load"
    end
  end

  function me:draw()
    rectfill(0, 0, 127, 50, 13)
    rectfill(0, 50, 127, 53, 14)
    circfill(62, 50, 14, 14)
    rectfill(0, 53, 127, 127, 0)
    sspr(0, 56, 8, 8, 52, 36, 24, 24)
    camera(0, 128)
    map()
    camera()

    local x, y = 38, 64
    local load_color = dget(0) == 1 and 7 or 5
    draw_panel(1, x, y, 48, 24)
    x += 2
    y += 4
    spr(16, x, (index - 1) * 10 + y)
    print("nEW gAME", x + 10, y, 7)
    y += 10
    print("cONTINUE", x + 10, y, load_color)

    print("s a g e ' s  h o l l o w", 16, 24, 6)
  end
  return me
end