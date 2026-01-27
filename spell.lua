spell_candle = {
  name = "cANDLE",
  color = 8,
  mp_cost = 1,
  compile_effects = function(player, enemy)
    return {
      { animation = "fire", target = enemy },
      { status = "burn", target = enemy, dur = 1 }
    }
  end
}

spell_dispel = {
  name = "dISPEL",
  color = 14,
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
  name = "cURSE",
  color = 2,
  mp_cost = 3,
  compile_effects = function(player, enemy)
    return {
      { animation = "skull", target = enemy },
      { status = "undead", target = enemy, dur = 1 },
      { damage = 5, target = enemy }
    }
  end
}

spell_data = { spell_candle, spell_dispel, spell_curse }