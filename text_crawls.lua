function big_text_crawl_new(text)
  local speed = 0.05
  local pages = {}
  local page_idx = 1
  local me = {}

  local function initialize()
    local page = nil
    for line in all(split(text, "\n")) do
      if sub(line, 1, 5) == "@page" then
        local page = { text = "" }
        add(pages, page)
      else
        pages[#pages].text = pages[#pages].text .. "\n" .. line
      end
    end

    for i, page in ipairs(pages) do
      pages[i] = text_crawl_new(page.text, 120)
    end
  end

  function me:load()
    page_idx = 1
    pages[page_idx]:load()
  end

  function me:update()
    local page = pages[page_idx]
    local done = page:update() and btnp(4)
    if done and page_idx < #pages then
      page_idx += 1
      pages[page_idx]:load()
    else
      return done
    end
  end

  function me:draw()
    pages[page_idx]:draw(4, 4)
  end

  initialize()
  return me
end

opening_text_crawl = big_text_crawl_new(
  [[
@page
<n>
Long ago, a <c13>SAGE<r> created an unchanging paradise in a dying world.
An idyllic <c11>FOREST<r>, tended by <c9>FAIRIES<r> and protected by a guardian <c12>DRAGON<r>.
<n>
The <c11>ELFS<r>, a small and child-like people, live here. For eons, the <c11>ELFS<r> lived in
comfort and safety, provided for by the <c9>FAIRIES<r> and the enchanted trees
they nurtured.
@page
<n>
Then, the <c13>DARK ELF<r> of the forest hinterlands conjured the brutish
<c3>GOBLINS<r> to beset the <c11>ELFS<r>. The <c9>FAIRIES<r> are vanishing, and the
<c11>FOREST<r> is dying.
<n><n>
YOU are an <c11>ELF<r>. You have set out to put things right. To defeat the
<c13>DARK ELF<r> and find the <c13>SAGE<r> who can heal the <c11>FOREST<r>.
]]
)

bad_ending_text_crawl = big_text_crawl_new([[
@page
<n><n>
You leave the dying <c11>FOREST<r> behind and set out into the <c5>STONEFIELD<r>.
The <c11>FOREST<r> and the <c11>ELFS<r> will die as you <c8>STRUGGLE<r> and <c8>FIGHT<r> through the
<c2>CURSED LANDS<r>.
<n><n>
Still, maybe there is something for you beyond the <c14>HORIZON<r>.
]])

good_ending_text_crawl = big_text_crawl_new(
  [[
@page
<n><n>
The <c13>SAGE<r> is gone, and the <c13>CORRUPTION<r> of the <c11>FOREST<r> has ceased. The
<c3>GOBLINS<r> and the <c2>CURSED BEINGS<r> will forever haunt your home, and the lost parts of the
<c11>FOREST<r> will never be restored.
<n><n>
Still, many <c9>FAIRIES<r> remain, and the gentle <c11>FOREST<r> of your youth can go on almost as it was.
]]
)