function battle_new(enemy, alternate_win_test)
  animations = {
    slash = { sx = 24, sy = 48 },
    fire = { sx = 72, sy = 48 },
    poof = { sx = 0, sy = 64 },
    skull = { sx = 80, sy = 80 }
  }

  local status_sprites = {
    armor = 161,
    strength = 160,
    burn = 176,
    invisible = 163,
    undead = 162,
    dispel = 177,
    dragon_burn = 179,
    enchanted = 164
  }

  local attack_animation = { 16, 32, 56, 56 }

  local state = nil
  local me = {}

  local function dec_status(fighter)
    for status, dur in pairs(fighter.status) do
      dur -= 1
      if dur <= 0 then
        fighter.status[status] = nil
      else
        fighter.status[status] = dur
      end
    end
  end

  local function start_turn()
    local next_state = nil
    if state.actor == enemy then
      local message, effects = enemy.behavior(global.player, enemy)
      next_state = {
        enemy_turn = true,
        actor = enemy,
        t0 = time(),
        dur = 0.5,
        message = message,
        effects = effects
      }
    else
      next_state = { select_action = true, menu = battle_menu_new() }
    end

    local effects = {}
    if state.actor.status.burn then
      local damage = state.actor.status.invisible and 0 or 3
      add(effects, { animation = "fire", target = state.actor })
      add(effects, { damage = damage, target = state.actor })
      if state.actor.hp <= 3 then
        next_state = state.actor == enemy
            and { victory = true }
            or { defeat = true }
      end
    end

    if state.actor.status.dragon_burn then
      add(effects, { animation = "fire", target = state.actor })
      add(effects, { damage = 10, target = state.actor })
      if state.actor.hp <= 10 then
        next_state = state.actor == enemy
            and { victory = true }
            or { defeat = true }
      end
    end

    dec_status(state.actor)

    state = {
      exec = true,
      actor = state.actor,
      t0 = time(),
      dur = 0,
      effects = effects,
      next_state = next_state
    }
  end

  local function select_action()
    local result = state.menu:update()
    if not result then return end

    local effects = {}
    if result.attack then
      effects = { { attack = true, target = enemy } }
    elseif result.item then
      global.items[result.item.id] -= 1
      global.item_count -= 1
      effects = result.item.compile_effects(global.player, enemy)
    elseif result.spell then
      global.mp -= result.spell.mp_cost
      effects = result.spell.compile_effects(global.player, enemy)
    end

    state = {
      exec = true,
      actor = global.player,
      t0 = 0,
      dur = 0,
      effects = effects,
      next_state = { end_turn = true, actor = global.player }
    }
  end

  local function exec_effect()
    local effect = deli(state.effects, 1)

    if effect.attack then
      local i = 1

      local damage = 2
          - (effect.target.status.armor and 2 or 0)
          + (state.actor.status.strength and 2 or 0)
      damage = effect.target.status.invisible and 0 or damage

      if state.actor == global.player then
        add(state.effects, { player_attack = true }, i)
        i = 2
      end

      add(state.effects, { animation = "slash", target = effect.target }, i)
      if damage <= 0 then return end
      add(state.effects, { flash = 8, target = effect.target }, i + 1)
      add(state.effects, { damage = damage, target = effect.target }, i + 2)
    elseif effect.animation then
      local coord = animations[effect.animation]
      state.animation = { coord = coord, target = effect.target }
      state.t0 = time()
      state.dur = 0.3
    elseif effect.flash then
      state.flash = { color = effect.flash, target = effect.target }
      state.t0 = time()
      state.dur = 0.2
    elseif effect.damage then
      local damage = effect.target.status.invisible and 0 or effect.damage
      effect.target.hp -= damage
      if effect.target.hp <= 0 then
        if effect.target.status.undead then
          add(state.effects, { message = "undead" }, 1)
          add(state.effects, { heal = true, target = effect.target }, 2)
        else
          effect.target.state = "dead"
          add(state.effects, { flash = 1, target = effect.target }, 1)
        end
      end
    elseif effect.player_attack then
      state.player_attack_animation = true
      state.t0 = time()
      state.dur = 0.5
    elseif effect.status then
      if effect.target.status.dispel and (effect.status ~= "strength" and effect.status ~= "armor") then return end
      local dur = (effect.target.status[effect.status] or 0) + effect.dur
      effect.target.status[effect.status] = dur
    elseif effect.message then
      state.message = effect.message
      state.t0 = time()
      state.dur = 1
    elseif effect.heal then
      effect.target.hp = 1
      add(state.effects, { flash = 11, target = effect.target }, 1)
    elseif effect.status_remove then
      effect.target.status[effect.status_remove] = nil
    end
  end

  local function exec()
    local effect_ready = time() - state.t0 >= state.dur
    if not effect_ready then return end
    if #state.effects == 0 then
      state = state.next_state
      state.t0 = time()
      state.dur = 0.5
    else
      state.flash = nil
      state.animation = nil
      state.player_attack_animation = nil
      state.message = nil
      exec_effect()
    end
  end

  local function end_turn()
    local done = time() - state.t0 >= state.dur
    if not done then return end

    if global.player.hp <= 0 then
      state = { defeat = true }
    elseif enemy.hp <= 0 then
      state = { victory = true }
    elseif alternate_win_test and alternate_win_test(global.player, enemy) then
      state = { alt_victory = true }
    elseif state.actor == enemy then
      state = { start_turn = true, actor = global.player }
    elseif state.actor == global.player then
      state = { start_turn = true, actor = enemy }
    end
  end

  local function enemy_turn()
    local done = time() - state.t0 >= state.dur
    if not done then return end

    state = {
      exec = true,
      actor = enemy,
      t0 = 0,
      dur = 0,
      effects = state.effects,
      next_state = { end_turn = true, actor = enemy }
    }
  end

  local function draw_hp_bar(x, y, n)
    local width = n * 2 + n - 1
    local x = x - width / 2

    for i = 1, n do
      rectfill(x, y, x + 1, y + 1, 8)
      x += 3
    end
  end

  local function draw_status(x, y, i, n)
    local width = n + n - 1

    spr(i, x, y)
    y += 6
    x = x - width / 2 + 2
    for j = 1, n do
      rectfill(x, y, x, y, 7)
      x += 2
    end
  end

  local function draw_fighter(fighter, x)
    local sprite_x = x + fighter.offset_x
    local y = 64 - 26
    local hp_y = y + 34
    local status_y = hp_y + 4
    local flash = state.flash and state.flash.target == fighter and state.flash.color
    local animation = state.animation and state.animation.target == fighter and state.animation.coord
    local message = fighter == enemy and state.message
    local player_attack = state.player_attack_animation and fighter == global.player
    local size = 16

    if fighter.big then
      y -= 16
      x -= 8
      size = 24
    end

    if fighter.state == "dead" and not flash then return end

    if player_attack then
      local progress = (time() - state.t0) / state.dur
      local frame = min(3, flr(progress * 4)) + 1
      local offset_sx = attack_animation[frame]
      local sx = fighter.sprite.sx + offset_sx
      local x = sprite_x + (frame == 1 and 0 or -12)
      local w = frame == 1 and 16 or 24
      sspr(sx, fighter.sprite.sy, w, 16, x, y, w * 2, 32)
    else
      local tint = flash or fighter.status.invisible and 2
      local sx = fighter.sprite.sx
      local sy = fighter.sprite.sy

      if tint then
        tint_palette(tint)
      end

      sspr(sx, sy, size, size, sprite_x, y, size * 2, size * 2)
      pal()
    end

    if animation then
      local progress = (time() - state.t0) / state.dur
      local frame = min(2, flr(progress * 3))
      local sx = animation.sx + frame * 16
      sspr(sx, animation.sy, 16, 16, sprite_x, y, 32, 32)
    end

    if message then
      local progress = (time() - state.t0) / state.dur
      local color = progress < 0.1 and 5 or progress > 0.9 and 5 or 7
      print(message, x - #message * 2 + size, y - 8, color)
    end

    draw_hp_bar(x + size, hp_y, fighter.hp)

    local num_status = 0
    for _, dur in pairs(fighter.status) do
      num_status += 1
    end

    local status_width = num_status * 5
    local status_padding = max(0, num_status - 1) * 2

    local status_x = x + size - (status_width + status_padding) / 2

    for status, dur in pairs(fighter.status) do
      draw_status(status_x, status_y, status_sprites[status], dur)
      status_x += 7
    end
  end

  function me:load()
    enemy.hp = enemy.max_hp
    enemy.state = "alive"
    enemy.status = {}
    if enemy.init then enemy.init(enemy) end

    global.player.state = "alive"
    global.player.status = {}
    for i = 1, #global.equipment do
      if global.equipment[i] then
        local equipment = equipment_data[i]
        global.player.status[equipment.status] = 2
      end
    end

    state = { start_turn = true, actor = global.player }
  end

  function me:update()
    if state.start_turn then
      start_turn()
    elseif state.select_action then
      select_action()
    elseif state.exec then
      exec()
    elseif state.end_turn then
      end_turn()
    elseif state.enemy_turn then
      enemy_turn()
    elseif state.victory and btnp(4) then
      return { victory = true }
    elseif state.alt_victory then
      return { alt_victory = true }
    elseif state.defeat and btnp(4) then
      return { defeat = true }
    end
  end

  function me:draw()
    if enemy.background then
      draw_background(enemy.background)
    end
    draw_fighter(global.player, 64 + 12)
    draw_fighter(enemy, 64 - 32 - 12)

    if state.select_action then
      state.menu:draw()
    elseif state.victory then
      local string = "v i c t o r y !"
      print(string, 64 - #string * 2, 88, 7)
    elseif state.defeat then
      local string = "d e f e a t"
      print(string, 64 - #string * 2, 88, 8)
    end
    draw_hud()
  end

  me:load()
  return me
end