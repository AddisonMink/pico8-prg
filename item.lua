item_shield = {
  id = 1,
  name = "<c6>Shield",
  desc = "S <i161>x2",
  compile_effects = function(player, enemy)
    return { { status = "armor", target = player, dur = 2 } }
  end
}

item_resin = {
  id = 2,
  name = "<c8>Resin",
  desc = "S <i160>x2",
  compile_effects = function(player, enemy)
    return { { status = "strength", target = player, dur = 2 } }
  end
}

item_talisman = {
  id = 3,
  name = "<c14>Sigil",
  desc = "S <i177>x1",
  compile_effects = function(player, enemy)
    return {
      { status = "dispel", target = player, dur = 1 },
      { status = "dispel", target = enemy, dur = 3 }
    }
  end
}