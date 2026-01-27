function item_shop_new()
  local x, y, w, h = 2, 58, 124, 66
  local index = 1
  local title = rich_text_parse("<c15>ITEM SHOP")
  local text = rich_text_parse("Take whatever you need!")

  local options = {
    rich_text_parse(item_shield.name),
    rich_text_parse(item_resin.name),
    rich_text_parse(item_talisman.name),
    rich_text_parse("Continue")
  }

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
    if btnp(2) then
      index = (index - 2) % 4 + 1
    elseif btnp(3) then
      index = index % 4 + 1
    elseif btnp(4) and option_valid(index) then
      if index == 4 then
        return true
      else
        global.items[index] += 1
        global.item_count += 1
      end
    end
  end

  function me:draw()
    local x, y = x, y
    draw_background(background.town)
    draw_npcs(npc.townsman)
    draw_panel(1, x, y, w, h)
    x += 4
    y += 4
    rich_text_print(title, x, y)
    y += 10
    rich_text_print(text, x, y)
    y += 10

    for i, option in ipairs(options) do
      local invalid = not option_valid(i)
      rich_text_print(option, x + 10, y, invalid and 5)
      if i < 4 then
        print("X" .. global.items[i], x + 36, y, invalid and 5 or 6)
      end      
      if i == index then spr(16, x, y) end
      y += 10
    end
  end

  return me
end

function equipment_shop_new()
  local icon_map = {
    armor = 161,
    strength = 160,
    dispel = 177
  }

  local x, y, w, h = 2, 58, 124, 66
  local index = 1
  local title = rich_text_parse("<10>EQUIPMENT SHOP")
  local text = rich_text_parse("I'll trade <c10>$<r> for equipment!")

  local options = {
    rich_text_parse(equipment_armor.name),
    rich_text_parse(equipment_sword.name),
    rich_text_parse(equipment_helmet.name),
    rich_text_parse("Continue")
  }

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
    if btnp(2) then
      index = (index - 2) % 4 + 1
    elseif btnp(3) then
      index = index % 4 + 1
    elseif btnp(4) and option_valid(index) then
      if index == 4 then
        return true
      else
        global.equipment[index] = true
        global.money -= equipment_data[index].money_cost
      end
    end
  end

  function me:draw()
    local x, y = x, y
    draw_background(background.town)
    draw_npcs(npc.townsman)
    draw_panel(1, x, y, w, h)
    x += 4
    y += 4
    rich_text_print(title, x, y)
    y += 10
    rich_text_print(text, x, y)
    y += 10

    for i, option in ipairs(options) do
      local equipment = equipment_data[i]
      local color = not option_valid(i) and 5

      rich_text_print(option, x + 10, y, color)
      if i < 4 then
        if global.equipment[i] then
          print("owned", x + 44, y, 5)
        else
          print("$" .. equipment.money_cost, x + 44, y, color or 10)
        end
        if color then tint_palette(color) end
        spr(icon_map[equipment.status], x + 80, y)
        pal()
        print("x1", x + 89, y, color or 7)
      end
      if i == index then spr(16, x, y) end
      y += 10
    end
  end

  return me
end