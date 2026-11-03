-- Anker = Baustein-ID auf der Website (R6, E18, E27).
--
-- Nur HTML, läuft NACH `quarto`. Jeder Baustein ist danach unter
-- …/ech-0003/v11.1.0/de/#<baustein-id> erreichbar:
--
--   feiner Baustein (:::-Block mit bb)   der Block erhält id=<bb>
--   grober Baustein (Überschrift mit bb) ein leerer Anker mit id=<bb> direkt
--                                         vor der Überschrift; die Überschrift
--                                         behält ihren Anker sec-<kurzname>
--                                         für die Querverweise
--
-- Ein mehrfach verwendeter Baustein (E27) erhält den Anker nur an der ersten
-- Fundstelle. Im Word setzt der Filter nichts: Textmarken sind dort auf 40
-- Zeichen begrenzt, Baustein-IDs sind länger.
--
-- Vorstufe von feedback.lua (AP9), das an denselben Stellen den
-- Feedback-Link setzen wird.

function Pandoc(doc)
  if not quarto.doc.is_format("html") then return nil end
  local vergeben = {}

  local function neu(bb)
    if bb == nil or vergeben[bb] then return false end
    vergeben[bb] = true
    return true
  end

  doc.blocks = doc.blocks:walk({
    Div = function(div)
      local bb = div.attributes["bb"]
      if div.identifier == "" and neu(bb) then
        div.identifier = bb
        return div
      end
    end,
  })

  local blocks = pandoc.Blocks({})
  for _, block in ipairs(doc.blocks) do
    if block.t == "Header" and neu(block.attributes["bb"]) then
      blocks:insert(pandoc.Div({}, pandoc.Attr(block.attributes["bb"], { "baustein-anker" })))
    end
    blocks:insert(block)
  end
  doc.blocks = blocks
  return doc
end
