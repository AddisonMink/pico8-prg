flag_id = {
  wizard = 1,
  fairy1 = 2,
  fairy2 = 3,
  fairy3 = 4,
  priestess = 5,
  sage = 6,
  dragon_defeated = 7,
  dragon_dead = 8,
  tomb = 9
}

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

function reset_player()
  global.player.hp = global.player.max_hp
  global.mp = global.max_mp
  global.coord = { tx = 5, ty = 9, dx = 1, dy = 0 }
  global.battle_locations_fought = {}
end

function new_game()
  dset(0, 1)
  dset(1, global.max_mp)
  dset(2, global.max_item_count)
  dset(3, global.money)

  -- spells
  dset(4, 0)
  dset(5, 0)
  dset(6, 0)

  -- equipment
  dset(7, 0)
  dset(8, 0)
  dset(9, 0)

  for i = 1, 9 do
    dset(9 + i, 0)
  end
end

function save_game()
  dset(1, global.max_mp)
  dset(2, global.max_item_count)
  dset(3, global.money)
  dset(4, bool_to_int(global.spells[1]))
  dset(5, bool_to_int(global.spells[2]))
  dset(6, bool_to_int(global.spells[3]))
  dset(7, bool_to_int(global.equipment[1]))
  dset(8, bool_to_int(global.equipment[2]))
  dset(9, bool_to_int(global.equipment[3]))

  for i = 1, 9 do
    dset(9 + i, bool_to_int(global.flags[i]))
  end
end

function load_game()
  global.max_mp = dget(1)
  global.max_item_count = dget(2)
  global.money = dget(3)
  global.spells[1] = int_to_bool(dget(4))
  global.spells[2] = int_to_bool(dget(5))
  global.spells[3] = int_to_bool(dget(6))
  global.equipment[1] = int_to_bool(dget(7))
  global.equipment[2] = int_to_bool(dget(8))
  global.equipment[3] = int_to_bool(dget(9))

  global.flags = {}
  for i = 1, 9 do
    global.flags[i] = int_to_bool(dget(9 + i))
  end

  if global.flags[flag_id.sage] then
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