global = {
  player = {
    hp = 10,
    max_hp = 10,
    status = {},
    sprite = npc.battle_player,
    offset_x = -6
  },
  mp = 0,
  max_mp = 0,
  item_count = 0,
  max_item_count = 3,
  money = 0,
  items = { 0, 0, 0 },
  spells = { false, false, false },
  equipment = { false, false, false },
  flags = {},
  coord = { tx = 5, ty = 9, dx = 1, dy = 0 },
  battle_locations_fought = {}
}

saved = {
  max_mp = 0,
  max_item_count = 3,
  money = 0,
  spells = { false, false, false },
  equipment = { false, false, false },
  flags = {}
}

function reset_player()
  global.player.hp = global.player.max_hp
  global.mp = global.max_mp
  global.coord = { tx = 5, ty = 9, dx = 1, dy = 0 }
  global.battle_locations_fought = {}
end

function save_game()
  saved.max_mp = global.max_mp
  saved.max_item_count = global.max_item_count
  saved.money = global.money

  for i = 1, #global.spells do
    saved.spells[i] = global.spells[i]
  end

  for i = 1, #global.equipment do
    saved.equipment[i] = global.equipment[i]
  end

  saved.flags = {}
  for k, v in pairs(global.flags) do
    saved.flags[k] = v
  end
end

function load_game()
  global.max_mp = saved.max_mp
  global.max_item_count = saved.max_item_count
  global.money = saved.money

  for i = 1, #saved.spells do
    global.spells[i] = saved.spells[i]
  end

  for i = 1, #saved.equipment do
    global.equipment[i] = saved.equipment[i]
  end

  global.flags = {}
  for k, v in pairs(saved.flags) do
    global.flags[k] = v
  end

  if global.flags.sage then
    mset(11, 4, 165)
    mset(13, 8, 165)
  else
    mset(11, 4, 180)
    mset(13, 8, 180)
  end
end

function draw_hud()
  local hp_str = "hp " .. global.player.hp .. "/" .. global.player.max_hp
  local mp_str = "mp " .. global.mp .. "/" .. global.max_mp
  local item_str = "item " .. global.item_count .. "/" .. global.max_item_count
  local money_str = "$" .. global.money

  rectfill(0, 0, 127, 11, 0)
  print(hp_str, 4, 4, 8)
  print(mp_str, 42, 4, 12)
  print(money_str, 74, 4, 10)
  print(item_str, 124 - #item_str * 4, 4, 15)
end