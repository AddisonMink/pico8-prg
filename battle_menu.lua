function battle_menu_new()
  local action_menu = {
    title = { "actions", 7 },
    num_options = 3,
    draw = function(x, y, i)
      _ = i == 1 and print("aTTACK", x, y, 7)
          or i == 2 and print("iTEM", x, y, 15)
          or i == 3 and print("sPELL", x, y, 12)
    end
  }

  local item_menu = {
    title = { "items", 15 },
    num_options = 3,
    draw = function(x, y, i)
      local item = item_data[i]
      local quant = global.items[i]
      local color = quant == 0 and 5
      print(item.name, x, y, color or item.color)
      print(" x" .. quant, x + 24, y, color or 6)
    end,
    choose = function(i)
      return i <= 3
          and global.items[i] > 0
          and { item = item_data[i] }
    end
  }

  local spell_menu = {
    title = { "spells", 12 },
    num_options = 3,
    draw = function(x, y, i)
      local spell = spell_data[i]
      local color = (not global.spells[i] or global.mp < spell.mp_cost) and 5
      print(spell.name, x, y, color or spell.color)
      print(spell.mp_cost .. "mp", x + 28, y, color or 12)
    end,
    choose = function(i)
      return i <= 3
          and global.spells[i]
          and global.mp >= spell_data[i].mp_cost
          and { spell = spell_data[i] }
    end
  }

  local x, y, w, h = 10, 88, 108, 34
  local index_i, index_j = 1, 1
  local menu = action_menu
  local state = "main"
  local me = {}

  function me:update()
    index_i = btnp(0) and (index_i - 2) % 2 + 1
        or btnp(1) and index_i % 2 + 1
        or index_i

    index_j = update_index(index_j, 2)
    local index = (index_j - 1) * 2 + index_i

    if state == "main" and btnp(4) then
      if index == 1 then
        return { attack = true }
      elseif index == 2 then
        state, menu, index_i, index_j = "sub", item_menu, 1, 1
      elseif index == 3 then
        state, menu, index_i, index_j = "sub", spell_menu, 1, 1
      end
    elseif state == "main" and btnp(5) then
      return { wait = true }
    elseif state == "sub" then
      if btnp(5) then
        state, menu, index_i, index_j = "main", action_menu, 1, 1
      elseif btnp(4) then
        return menu.choose(index)
      end
    end
  end

  function me:draw()
    local x, y = x, y
    draw_panel(1, x, y, w, h)
    x += 4
    local x0 = x
    y += 4
    print(menu.title[1], x, y, menu.title[2])
    y += 10
    for j = 1, 2 do
      x = x0
      for i = 1, 2 do
        local index = (j - 1) * 2 + i

        if index < 4 then
          menu.draw(x + 10, y, index)
        end
        if i == index_i and j == index_j then
          spr(16, x, y)
        end
        x += 48
      end
      y += 10
    end
  end

  return me
end