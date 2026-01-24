enemy_goblin = {
  hp = 4,
  max_hp = 4,
  status = {},
  sprite = npc.goblin,
  offset_x = -2,
  background = background.forest,
  behavior = function(player, enemy)
    return "attack", { { attack = true, target = player } }
  end
}

enemy_goblin_warrior = {
  hp = 4,
  max_hp = 4,
  status = {},
  sprite = npc.goblin_warrior,
  offset_x = -2,
  background = background.forest,
  init = function(enemy)
    enemy.status.armor = 2
  end,
  behavior = function(player, enemy)
    return "attack", { { attack = true, target = player } }
  end
}

enemy_goblin_mage = {
  hp = 4,
  max_hp = 4,
  status = {},
  sprite = npc.goblin_mage,
  offset_x = -4,
  background = background.forest,
  init = function(enemy)
    enemy.status.invisible = 1
  end,
  behavior = function(player, enemy)
    if enemy.status.invisible then
      return "fire", {
        { animation = "fire", target = player },
        { status = "burn", target = player, dur = 1 }
      }
    else
      return "invisible", {
        { status = "invisible", target = enemy, dur = 1 }
      }
    end
  end
}

enemy_zombie = {
  hp = 1,
  max_hp = 1,
  status = {},
  sprite = npc.zombie,
  offset_x = -2,
  background = background.graveyard,
  init = function(enemy)
    enemy.status.undead = 4
  end,
  behavior = function(player, enemy)
    return "attack", { { attack = true, target = player } }
  end
}

enemy_ghost = {
  hp = 1,
  max_hp = 1,
  status = {},
  sprite = npc.ghost,
  offset_x = 0,
  background = background.graveyard,
  init = function(enemy)
    enemy.status.undead = 4
    enemy.status.invisible = 2
  end,
  behavior = function(player, enemy)
    if enemy.status.invisible then
      return "fire", {
        { animation = "fire", target = player },
        { status = "burn", target = player, dur = 1 }
      }
    else
      return "invisible", {
        { status = "invisible", target = enemy, dur = 1 }
      }
    end
  end
}

enemy_dragon = {
  hp = 10,
  max_hp = 10,
  status = {},
  offset_x = 0,
  background = background.forest,
  sprite = npc.dragon,
  init = function(enemy)
    enemy.status.enchanted = 4
  end,
  behavior = function(player, enemy)
    return "breath", {
      { animation = "fire", target = player },
      { status = "dragon_burn", target = player, dur = 1 }
    }
  end
}

enemy_dark_elf = {
  hp = 10,
  max_hp = 10,
  status = {},
  offset_x = -8,
  big = true,
  background = nil,
  sprite = npc.sage,
  init = function(enemy)
  end,
  behavior = function(player, enemy)
    if not enemy.status.invisible then
      return "black candle", {
        { animation = "fire", target = player },
        { status = "burn", target = player, dur = 1 },
        { status = "invisible", target = enemy, dur = 2 },
        { status = "strength", target = enemy, dur = 2 }
      }
    else
      return "shadow strike", {
        { attack = true, target = player }
      }
    end
  end
}