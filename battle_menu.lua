function battle_menu_new()
  local x, y, w, h = 10, 88, 108, 34
  local index_i, index_j = 1, 1

  local action_state = {
    title = rich_text_parse("ACTION"),
    options = {
      { name = rich_text_parse("Attack"), ok = true, result = { attack = true } },
      { name = rich_text_parse("<c15>Item"), ok = true, state = "item" },
      { name = rich_text_parse("<c12>Spell"), ok = true, state = "spell" },
      { name = rich_text_parse("<c6>Wait"), ok = true, result = { wait = true } }
    }
  }

  local spell_state = {
    title = rich_text_parse("<c12>SPELL"),
    options = {
      {
        name = rich_text_parse(spell_candle.name .. " <c12>" .. spell_candle.mp_cost .. "MP"),
        ok = global.spells[1] and global.mp >= spell_candle.mp_cost,
        result = { spell = spell_candle }
      },
      {
        name = rich_text_parse(spell_dispel.name .. " <c12>" .. spell_dispel.mp_cost .. "MP"),
        ok = global.spells[2] and global.mp >= spell_dispel.mp_cost,
        result = { spell = spell_dispel }
      },
      {
        name = rich_text_parse(spell_curse.name .. "  <c12>" .. spell_curse.mp_cost .. "MP"),
        ok = global.spells[3] and global.mp >= spell_curse.mp_cost,
        result = { spell = spell_curse }
      }
    }
  }

  local item_state = {
    title = rich_text_parse("<c15>ITEM"),
    options = {
      {
        name = rich_text_parse(item_shield.name .. " <r>x" .. global.items[1]),
        ok = global.items[1] > 0,
        result = { item = item_shield }
      },
      {
        name = rich_text_parse(item_resin.name .. " <r>x" .. global.items[2]),
        ok = global.items[2] > 0,
        result = { item = item_resin }
      },
      {
        name = rich_text_parse(item_talisman.name .. " <r>x" .. global.items[3]),
        ok = global.items[3] > 0,
        result = { item = item_talisman }
      }
    }
  }

  local states = {
    action = action_state,
    spell = spell_state,
    item = item_state
  }

  local state = action_state
  local me = {}

  function me:load()
    state = action_state
    index_i = 1
    index_j = 1
  end

  function me:update()
    if btnp(0) then
      index_i = (index_i - 2) % 2 + 1
    elseif btnp(1) then
      index_i = index_i % 2 + 1
    elseif btnp(2) then
      index_j = (index_j - 2) % 2 + 1
    elseif btnp(3) then
      index_j = index_j % 2 + 1
    elseif btnp(4) then
      local index = (index_j - 1) * 2 + index_i
      local option = state.options[index]
      if option and option.ok then
        if not option.ok then
          return
        elseif option.state then
          state = states[option.state]
          index_i = 1
          index_j = 1
        elseif option.result then
          return option.result
        end
      end
    elseif btnp(5) then
      state = action_state
    end
  end

  function me:draw()
    local x, y = x, y
    draw_panel(1, x, y, w, h)
    x += 4
    y += 4
    rich_text_print(state.title, x, y)
    y += 10
    for i = 1, 2 do
      for j = 1, 2 do
        local x = x + (i - 1) * 50 + 10
        local y = y + (j - 1) * 10
        local index = (j - 1) * 2 + i
        local option = state.options[index]

        if option then
          rich_text_print(option.name, x, y, not option.ok and 5)
        end

        if i == index_i and j == index_j then
          spr(16, x - 10, y)
        end
      end
    end
  end

  return me
end