-- Tabellen im Word: Zellen in der Formatvorlage «Tabellentext» der eCH-Vorlage.
--
-- Nur DOCX, läuft NACH `quarto` und vor ech_deckblatt.lua, das seine Zellen
-- selbst gestaltet. Ohne den Filter stünden die Zellen in «Compact», einer
-- Formatvorlage von Pandoc, die die eCH-Vorlage nicht kennt (Spike S1).

local STIL = pandoc.Attr("", {}, { ["custom-style"] = "Tabellentext" })

local function zeilen(liste)
  for _, zeile in ipairs(liste) do
    for _, zelle in ipairs(zeile.cells) do
      -- Die Formatvorlage greift nur bei Para, Zellen enthalten aber Plain.
      local inhalt = pandoc.Blocks(zelle.contents):walk({
        Plain = function(p) return pandoc.Para(p.content) end,
      })
      zelle.contents = pandoc.Blocks({ pandoc.Div(inhalt, STIL) })
    end
  end
end

function Table(tabelle)
  if not quarto.doc.is_format("docx") then return nil end
  zeilen(tabelle.head.rows)
  for _, body in ipairs(tabelle.bodies) do
    zeilen(body.body)
  end
  return tabelle
end
