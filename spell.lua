spell_candle = {
  name = "<c8>Candle",
  mp_cost = 1,
  compile_effects = function(player, enemy)
    return {
      { animation = "fire", target = enemy },
      { status = "burn", target = enemy, dur = 1 }
    }
  end
}

spell_dispel = {
  name = "<c14>Dispel",
  mp_cost = 2,
  compile_effects = function(player, enemy)
    return {
      { animation = "poof", target = enemy },
      { status_remove = "undead", target = enemy },
      { status_remove = "enchanted", target = enemy },
      { status = "dispel", target = enemy, dur = 3 }
    }
  end
}

spell_curse = {
  name = "<c2>Curse",
  mp_cost = 3,
  compile_effects = function(player, enemy)
    return {
      { animation = "skull", target = enemy },
      { status = "undead", target = enemy, dur = 1 },
      { damage = 5, target = enemy }
    }
  end
}