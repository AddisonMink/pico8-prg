townsman = dialogue_new(
  function() return global.flags.fairy1 and 2 end,
  [[
@page
@background town
@npc townsman
@title <c15>TOWNSMAN<r>
@body
Please take whatever <c15>ITEMS<r> you can carry!
<n><n>
If you find any <c10>$<r>, I'll trade <c6>EQUIPMENT<r> for them.
@body
@option Continue
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
    go_to_hint = function()
      local page = not global.flags.wizard and 2
          or not global.flags.temple and 3
          or 5
      return { page = page }
    end,
    leave = function() return { result = true } end
  }
)

wizard = dialogue_new(
  function() return global.flags.wizard and 7 end,
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
You learned the <c8>CANDLE<r> spell!
<n>
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
      global.flags.wizard = true
    end,
    learn = function()
      global.max_mp += 1
      global.mp += 1
      global.spells[1] = true
    end
  }
)

fairy1 = dialogue_new(
  function() return global.flags.fairy1 and 2 end,
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
      global.flags.fairy1 = true
    end
  }
)

fairy2 = dialogue_new(
  function() return global.flags.fairy2 and 2 end,
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
      global.flags.fairy2 = true
    end
  }
)

fairy3 = dialogue_new(
  function() return global.flags.fairy3 and 2 end,
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
      global.flags.fairy3 = true
    end
  }
)

priestess = dialogue_new(
  function() return global.flags.temple and 6 end,
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
You learned the <c14>DISPEL<r> spell!
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
      global.max_item_count += 1
      global.flags.temple = true
    end,
    learn = function()
      global.max_mp += 1
      global.mp += 1
      global.spells[2] = true
    end
  }
)

sage = dialogue_new(
  function() return global.flags.sage and 5 end,
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
      global.flags.sage = true
    end
  }
)