global = {
  player = {
    hp = 10,
    max_hp = 10,
    status = {},
    sprite = npc.battle_player,
    offset_x = -6
  },
  max_hp = 10,
  mp = 0,
  max_mp = 0,
  item_count = 0,
  max_item_count = 3,
  money = 0,
  items = { 0, 0, 0 },
  spells = { false, false, false },
  equipment = { false, false, false },
  flags = {},
}

function draw_hud()
  local hp_str = "hp " .. global.player.hp .. "/" .. global.max_hp
  local mp_str = "mp " .. global.mp .. "/" .. global.max_mp
  local item_str = "item " .. global.item_count .. "/" .. global.max_item_count

  rectfill(0, 0, 127, 11, 0)
  print(hp_str, 4, 4, 8)
  print(mp_str, 64 - #mp_str * 2, 4, 12)
  print(item_str, 124 - #item_str * 4, 4, 15)
end