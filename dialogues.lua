townsman = dialogue_new(
  function() end,
  [[
@page
@background town
@npc townsman
@title <c15>TOWNSMAN<r>
@body
Welcome, <c11>FRIEND<r>! Rest and prepare yourself.
<n><n>
If you find any <c10>$<r>, I'll trade <c6>EQUIPMENT<r> for them.
@body
@option Rest and Save
@callback rest_and_save

@page
@state_machine item_shop

@page
@state_machine equipment_shop
@callback go_to_hint

@page
@background town
@npc townsman
@title <c15>TOWNSMAN<r>
@body
A kindly <c12>WIZARD<r> lives in the tower by the lake. He may know
the whereabouts of the missing <c9>FAIRIES<r>.
@body
@option Leave
@callback leave

@page
@background town
@npc townsman
@title <c15>TOWNSMAN<r>
@body
A <c14>PRIESTESS<r> lives out in the <c5>STONEFIELD<r> beyond the <c11>FOREST<r>. She knows how to break <c13>ENCHANTMENTS<r>.
@body
@option Continue

@page
@background town
@npc townsman
@title <c15>TOWNSMAN<r>
@body
If you go to visit her, beware of the <c2>CURSED BEINGS<r> that haunt the <c5>STONEFIELD<r>.
@body
@option Leave
@callback leave

@page
@background town
@npc townsman
@title <c15>TOWNSMAN<r>
@body
Good luck!
@body
@option Leave
@callback leave
]],
  {
    rest_and_save = function()
      save_game()
      reset_player()
    end,
    item_shop = item_shop_new(),
    equipment_shop = equipment_shop_new(),
    go_to_hint = function()
      local page = not global.flags[flag_id.wizard] and 4
          or not global.flags[flag_id.priestess] and 5
          or 7
      return { page = page }
    end,
    leave = function() return { result = true } end
  }
)

wizard = dialogue_new(
  function() return global.flags[flag_id.wizard] and 7 end,
  [[
@page
@background tower
@npc wizard
@title <c6>NARRATOR<r>
@body
You found the <c12>WIZARD'S TOWER<r>!
<n>
You also found <c10>$2<r>!
@body
@option Continue
@callback visit

@page
@background tower
@npc wizard
@title <c12>WIZARD<r>
@body
The <c13>SAGE<r> made the <c9>FAIRIES<r> to tend to the <c11>FOREST<r>. Without them, it will <c2>ROT<r>.
@body
@option Continue

@page
@background tower
@npc wizard
@title <c12>WIZARD<r>
@body
I will teach you to conjure a <c8>FIRE SPRITE<r>. He, too, seeks his <c9>MISSING FELLOWS<r>.
@body
@option Continue

@page
@background tower
@npc wizard
@title <c12>WIZARD<r>
@body
<c6>ARMOR<r> is no hindrance to him, but he is easily fooled by <c13>ILLUSIONS<r>.
@body
@option Continue

@page
@background tower
@npc wizard
@title <c6>NARRATOR<r>
@body
You learned the <c8>CANDLE<r> spell! (O <i176>x1)
<n><n>
You also gained <c12>1 MAX MP<r>!
@body
@option Continue
@callback learn
@screen_transition

@page
@background tower
@npc candle
@title <c8>CANDLE<r>
@body
The <c3>GOBLINS<r> have been hunting us, but some <c9>FAIRIES<r> still survive! I can sense them hiding in the <c11>HOLLOW TREES<r>.
@body
@option Continue
@screen_transition

@page
@background tower
@npc wizard
@title <c12>WIZARD<r>
@body
<c8>CANDLE<r> is my <c11>FRIEND<r>. Treat him with care.
@body
@option Continue
]],
  {
    visit = function()
      global.money += 2
      global.flags[flag_id.wizard] = true
    end,
    learn = function()
      global.max_mp += 1
      global.mp += 1
      global.spells[1] = true
    end
  }
)

fairy1 = dialogue_new(
  function() return global.flags[flag_id.fairy1] and 2 end,
  [[
@page
@background forest
@npc fairies
@title <c6>NARRATOR<r>
@body
You found a <c11>FAIRY TREE<r>!
<n><n>
You also found <c10>$2<r> and an <c15>ITEM POUCH<r>!
@body
@option Continue
@callback visit

@page
@background forest
@npc fairies
@title <c9>FAIRIES<r>
@body
We hide here from the <c3>GOBLINS<r>! They musn't find us.
<n>
We do not want to be changed!
@body
@option Continue
]],
  {
    visit = function()
      global.money += 2
      global.max_item_count += 1
      global.flags[flag_id.fairy1] = true
    end
  }
)

fairy2 = dialogue_new(
  function() return global.flags[flag_id.fairy2] and 2 end,
  [[
@page
@background forest
@npc fairies
@title <c6>NARRATOR<r>
@body
You found a <c11>FAIRY TREE<r>!
<n><n>
You also found <c10>$2<r> and an <c15>ITEM POUCH<r>!
@body
@option Continue
@callback visit

@page
@background forest
@npc fairies
@title <c9>FAIRIES<r>
@body
The guardian <c12>DRAGON<r> is <c13>ENSORCELLED<r>! It now protects only the <c13>DARK ELF<r>.
<n><n>
We cower in fear of it.
@body
@option Continue
]],
  {
    visit = function()
      global.money += 2
      global.max_item_count += 1
      global.flags[flag_id.fairy2] = true
    end
  }
)

fairy3 = dialogue_new(
  function() return global.flags[flag_id.fairy3] and 2 end,
  [[
@page
@background forest
@npc fairies
@title <c6>NARRATOR<r>
@body
You found a <c11>FAIRY TREE<r>!
<n><n>
You also found <c10>$2<r> and an <c15>ITEM POUCH<r>!
@body
@option Continue
@callback visit

@page
@background forest
@npc fairies
@title <c9>FAIRIES<r>
@body
Most of us are <c3>GOBLINS<r> now. Who will care for the <c11>TREES<r>?

The <c11>FOREST<r> will die.
@body
@option Continue
]],
  {
    visit = function()
      global.money += 2
      global.max_item_count += 1
      global.flags[flag_id.fairy3] = true
    end
  }
)

priestess = dialogue_new(
  function() return global.flags[flag_id.priestess] and 6 end,
  [[
@page
@background temple
@npc priestess
@title <c6>NARRATOR<r>
@body
You found the <c14>TEMPLE<r>!
<n><n>
You also found <c10>$2<r>!
@body
@option Continue
@callback visit

@page
@background temple
@npc priestess
@title <c14>PRIESTESS<r>
@body
The <c13>SAGE<r> built this <c14>TEMPLE<r> at the edge of the <c11>FOREST<r> to protect it from the <c2>CURSED BEINGS<r> of the <c5>STONEFIELD<r>.
@body
@option Continue

@page
@background temple
@npc priestess
@title <c14>PRIESTESS<r>
@body
He left for the <c13>EAST<r> some time ago, and the <c14>TEMPLE<r> has lost its power.
@body
@option Continue

@page
@background temple
@npc priestess
@title <c14>PRIESTESS<r>
@body
The <c2>CURSED BEINGS<r> cannot die, so I will teach you a <c14>PRAYER<r> to break <c2>CURSES<r> and <c13>ENCHANTMENTS<r>. Please give them rest!
@body
@option Continue

@page
@background temple
@npc priestess
@title <c6>NARRATOR<r>
@body
You learned the <c14>DISPEL<r> spell! (O <i177>x3, Remove <i162>, <i164>)
<n>
You also gained <c12>1 MAX MP<r>!
@body
@option Continue
@callback learn

@page
@background temple
@npc priestess
@title <c14>PRIESTESS<r>
@body
The <c14>PRAYER<r> I taught you can break all manner of foul <c13>ENCHANTMENTS<r>.
@body
@option Continue
]],
  {
    visit = function()
      global.money += 2
      global.flags[flag_id.priestess] = true
    end,
    learn = function()
      global.max_mp += 1
      global.mp += 1
      global.spells[2] = true
    end
  }
)

sage = dialogue_new(
  function() return global.flags[flag_id.sage] and 5 end,
  [[
@page
@npc sage
@title <c6>NARRATOR<r>
@body
The ancient <c13>SAGE<r> squats in his cave. He looks <c2>OLD<r> beyond imagining, and very tired.
@body
@option Continue
@callback visit

@page
@npc sage
@title <c13>SAGE<r>
@body
Long ago, I made this gentle <c11>FOREST<r> to be a home for <c11>ETERNAL CHILDREN<r>.
@body
@option Continue

@page
@npc sage
@title <c13>SAGE<r>
@body
But do you not tire of your childhood? Do your <c8>PETTY COMFORTS<r> not wrankle?
@body
@option Continue

@page
@npc sage
@title <c13>SAGE<r>
@body
Leave this <c3>DYING PLACE<r>! Go north, to the <c5>STONEFIELD<r>! You will grow <c8>STRONG<r>, if nothing else.
@body
@option Continue
@screen_transition

@page
@title <c6>NARRATOR<r>
@body
The <c13>SAGE<r> has left. The <c2>DARKNESS<r> of the <c11>FOREST<r> deepens.
@body
@option Continue
]],
  {
    visit = function()
      global.flags[flag_id.sage] = true
      mset(11, 4, 165)
      mset(13, 8, 165)
    end
  }
)

dragon = dialogue_new(
  function()
    return global.flags[flag_id.dragon_defeated] and 3
        or global.flags[flag_id.dragon_dead] and 5
  end,
  [[
@page
@background forest
@npc dragon
@title <c6>NARRATOR<r>
@body
A mighty <c12>DRAGON<r> confronts you! It has a <c12>TERRIBLE COUNTENANCE<r>, but its eyes are <c13>DULL<r> and <c13>POWERLESS<r>.
@body
@option Fight
@screen_transition

@page
@state_machine fight
@callback post_fight
@screen_transition

@page
@background forest
@title <c6>NARRATOR<r>
@body
The <c12>DRAGON<r> lies motionless on the ground.
@body
@option Leave
@callback leave

@page
@background forest
@title <c6>NARRATOR<r>
@body
The <c12>DRAGON<r>'s eyes clear, and it lumbers back to the <c6>MOUNTAINS<r>.
@body
@option Continue

@page
@background forest
@title <c6>NARRATOR<r>
@body
The <c12>DRAGON<r> is gone.
@body
@option Leave
@callback leave
]],
  {
    fight = battle_new(
      enemy_dragon,
      function(player, enemy) return not enemy.status.enchanted end
    ),
    post_fight = function(battle_result)
      if battle_result.defeat then
        return { result = "game_over" }
      elseif battle_result.victory then
        global.flags[flag_id.dragon_defeated] = true
        return { page = 3 }
      elseif battle_result.alt_victory then
        global.flags[flag_id.dragon_dead] = true
        return { page = 4 }
      end
    end,
    leave = function()
      return { result = true }
    end
  }
)

stonefield = dialogue_new(
  function() end,
  [[
@page
@background graveyard
@title <c6>NARRATOR<r>
@body
You approach the <c13>SPLIT GATE<r>. The <c5>STONEFIELD<r> extends to the horizon. Is there anything beyond it?
@body
@option Continue

@page
@background graveyard
@title <c6>NARRATOR<r>
@body
What will you do?
@body
@option Go through the gate.
@option Turn back.
@callback bad_ending
]],
  {
    bad_ending = function(idx)
      return idx == 1 and { result = "bad_ending" }
          or idx == 2 and { result = true }
    end
  }
)

dark_elf = dialogue_new(
  function() end,
  [[
@page
@background graveyard
@npc sage
@title <c6>NARRATOR<r>
@body
The <c13>SAGE<r> prances madly in the <c5>STONEFIELD<r>, cackling with glee.
@body
@option Continue

@page
@background graveyard
@npc sage
@title <c13>DARK ELF<r>
@body
I <c8>RENOUNCE<r> my stewardship of this land! This <c8>PATHETIC NURSERY<r> will gall me no longer!
@body
@option Continue

@page
@background graveyard
@npc sage
@title <c13>DARK ELF<r>
@body
When the <c9>FAIRIES<r> have all turned, there will be nothing left for you here!
<n>
@body
@option Continue

@page
@background graveyard
@npc sage
@title <c13>DARK ELF<r>
@body
You should have left for the <c5>STONEFIELD<r>! There may have been something beyond it!
<n>
Now, there is only <c8>DEATH<r>!
@body
@option Fight
@screen_transition

@page
@state_machine fight
@callback post_fight
@screen_transition

@page
@background graveyard
@npc sage
@title <c13>DARK ELF<r>
@body
You have grown <c8>STRONG<r>! Will you use your strength to buy back your <c8>PATHETIC LITTLE LIFE<r>?
@body
@option Continue

@page
@background graveyard
@npc sage
@title <c13>DARK ELF<r>
@body
Having tasted <c8>POWER<r>, do you not desire something <c8>GREATER<r>?
@body
@option Continue
@screen_transition

@page
@background graveyard
@title <c6>NARRATOR<r>
@body
The <c13>DARK ELF<r>'s ashen remains blow away on the wind, out over the <c5>STONEFIELD<r>.
@body
@option Leave
@callback good_ending
]],
  {
    fight = battle_new(enemy_dark_elf),
    post_fight = function(battle_result)
      return battle_result.defeat and { result = "game_over" }
    end,
    good_ending = function()
      return { result = "good_ending" }
    end
  }
)

tomb = dialogue_new(
  function() return global.flags[flag_id.tomb] and 5 end,
  [[
@page
@background tower
@title <c6>NARRATOR<r>
@body
You found the <c2>TOMB<r>!
<n><n>
You also found <c10>$3<r>!
@body
@option Continue
@callback visit

@page
@background tower
@title <c6>NARRATOR<r>
@body
You sense the presence of an ancient <c2>CURSE<r>.
<n><n>
An <c2>APPARITION<r> fades into view!
@body
@option Continue
@screen_transition

@page
@background tower
@npc ghost
@title <c2>CURSED BEING<r>
@body
I grant you the <c2>CURSE<r> that haunts the <c5>STONEFIELD<r>.
<n><n>
May it afflict the last of the <c13>OLD MASTERS<r>.
@body
@option Continue
@learn

@page
@background tower
@npc ghost
@title <c6>NARRATOR<r>
@body
You learned the <c2>CURSE<r> spell! (O <i162>x1, <i178>x5 )
<n><n>
You also gained <c12>1 MAX MP<r>!
@body
@option Continue
@callback learn
@screen_transition

@page
@background tower
@title <c6>NARRATOR<r>
@body
The <c2>TOMB<r> is silent.
@body
@option Leave
]],
  {
    visit = function()
      global.money += 3
      global.flags[flag_id.tomb] = true
    end,
    learn = function()
      global.spells[3] = true
      global.max_mp += 1
      global.mp += 1
    end
  }
)