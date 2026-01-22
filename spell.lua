spell_candle = {
  id = 1,
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
  id = 2,
  name = "<c14>Dispel",
  mp_cost = 2,
  compile_effects = function(player, enemy)
    return {
      { animation = "poof", target = enemy },
      { status_remove = "undead", target = enemy },
      { status_remove = "enchanted", target = enemy },
      { status = "dispel", target = enemy, dur = 2 }
    }
  end
}

spell_death = {
  id = 3,
  name = "<c2>Curse",
  mp_cost = 3,
  compile_effects = function(player, enemy)
    return {
      { status = "undead", target = enemy, dur = 1 },
      { damage = 5, target = enemy }
    }
  end
}

spell_data = {
  [spell_candle.id] = spell_candle,
  [spell_dispel.id] = spell_dispel,
  [spell_death.id] = spell_death
}