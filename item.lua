item_shield = {
  id = 1,
  name = "<c6>Shield",
  compile_effects = function(player, enemy)
    return { { status = "armor", target = player, dur = 2 } }
  end
}

item_resin = {
  id = 2,
  name = "<c8>Resin",
  compile_effects = function(player, enemy)
    return { { status = "strength", target = player, dur = 2 } }
  end
}

item_talisman = {
  id = 3,
  name = "<c14>Sigil",
  compile_effects = function(player, enemy)
    return {
      { status = "dispel", target = player, dur = 1 },
      { status = "dispel", target = enemy, dur = 3 }
    }
  end
}