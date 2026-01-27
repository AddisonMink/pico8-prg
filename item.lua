item_shield = {
  id = 1,
  name = "sHIELD",
  color = 6,
  compile_effects = function(player, enemy)
    return { { status = "armor", target = player, dur = 2 } }
  end
}

item_resin = {
  id = 2,
  name = "rESIN",
  color = 8,
  compile_effects = function(player, enemy)
    return { { status = "strength", target = player, dur = 2 } }
  end
}

item_talisman = {
  id = 3,
  name = "sIGIL",
  color = 14,
  compile_effects = function(player, enemy)
    return {
      { status = "dispel", target = player, dur = 1 }
    }
  end
}

item_data = { item_shield, item_resin, item_talisman }