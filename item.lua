item_shield = {
  id = 1,
  name = "sHIELD",
  color = 6,
  effect = { status = "armor", target = global.player, dur = 2 }
}

item_resin = {
  id = 2,
  name = "rESIN",
  color = 8,
  effect = { status = "strength", target = global.player, dur = 2 }
}

item_talisman = {
  id = 3,
  name = "sIGIL",
  color = 14,
  effect = { status = "dispel", target = global.player, dur = 1 }
}

item_data = { item_shield, item_resin, item_talisman }