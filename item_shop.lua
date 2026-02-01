function item_shop_new()
  local x, y, w, h = 2, 58, 124, 66
  local index = 1

  local me = {}

  local function option_valid(i)
    local full = global.item_count >= global.max_item_count
    return i == 4 and full or i < 4 and not full
  end

  function me:load()
    global.items = { 0, 0, 0 }
    global.item_count = 0
    index = 1
  end

  function me:update()
    index = update_index(index, 4)

    if btnp(4) then
      if option_valid(index) then
        if index == 4 then
          return true
        else
          global.items[index] += 1
          global.item_count += 1
          sfx(23)
        end
      else
        sfx(22)
      end
    end
  end

  function me:draw()
    local x, y = x, y
    draw_hud()
    draw_background(background.town)
    draw_npcs(npc.townsman)
    draw_panel(1, x, y, w, h)
    x += 4
    y += 4
    print("item shop", x, y, 15)
    y += 10
    print("tAKE WHATEVER YOU NEED!", x, y, 7)
    y += 10

    for i = 1, 4 do
      local color = not option_valid(i) and 5
      if i < 4 then
        local item = item_data[i]
        print(item.name, x + 10, y, color or item.color)
        print("X" .. global.items[i], x + 36, y, color or 6)
      else
        print("cONTINUE", x + 10, y, color or 7)
      end
      if i == index then spr(16, x, y) end
      y += 10
    end
  end

  return me
end

function equipment_shop_new()
  local x, y, w, h = 2, 58, 124, 66
  local index = 1
  local me = {}

  local function option_valid(i)
    return i == 4
        or (not global.equipment[i]
          and global.money >= equipment_data[i].money_cost)
  end

  function me:load()
    index = 1
  end

  function me:update()
    index = update_index(index, 4)

    if btnp(4) then
      if option_valid(index) then
        if index == 4 then
          return true
        else
          global.equipment[index] = true
          global.money -= equipment_data[index].money_cost
          save_game()
          sfx(23)
        end
      else
        sfx(22)
      end
    end
  end

  function me:draw()
    local x, y = x, y
    draw_hud()
    draw_background(background.town)
    draw_npcs(npc.townsman)
    draw_panel(1, x, y, w, h)
    x += 4
    y += 4
    print("eQUIPMENT sHOP", x, y, 15)
    y += 10
    local x0 = print("i'LL TRADE", x, y, 7)
    x0 = print(" $ ", x0, y, 10)
    print("FOR EQUIPMENT!", x0, y, 7)
    y += 10

    for i = 1, 4 do
      local color = not option_valid(i) and 5

      if i < 4 then
        local equipment = equipment_data[i]
        print(equipment.name, x + 10, y, color or equipment.color)
        if global.equipment[i] then
          print("owned", x + 44, y, 5)
        else
          print("$" .. equipment.money_cost, x + 44, y, color or 10)
        end
      else
        print("cONTINUE", x + 10, y, color or 7)
      end
      if i == index then spr(16, x, y) end
      y += 10
    end
  end

  return me
end