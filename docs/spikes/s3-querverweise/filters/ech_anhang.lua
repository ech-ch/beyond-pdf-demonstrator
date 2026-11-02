-- Spike S3: Querverweise auf Anhänge («Anhang F»).
--
-- Läuft VOR dem quarto-Filter (in _quarto.yml vor `quarto` gelistet).
-- Sucht Überschriften der Ebene 1 mit Klasse .appendix und ID, liest den
-- Buchstaben aus dem Titel («Anhang F – …») oder vergibt A, B, C … in
-- Dokumentreihenfolge und ersetzt Zitate @id durch einen Link «Anhang F»
-- (bzw. nur «F» bei -@id, bzw. «<Präfix> F» bei [Präfix @id]).
-- Abschaltbar mit Metadatum `spike-filter: false`.

local stringify = pandoc.utils.stringify

function Pandoc(doc)
  if doc.meta["spike-filter"] == false then return nil end
  local letters, n = {}, 0
  for _, b in ipairs(doc.blocks) do
    if b.t == "Header" and b.level == 1 and b.classes:includes("appendix") and b.identifier ~= "" then
      n = n + 1
      local letter = stringify(b.content):match("^Anhang%s+(%u)") or string.char(64 + n)
      letters[b.identifier] = letter
    end
  end
  return doc:walk({
    Cite = function(cite)
      if #cite.citations ~= 1 then return nil end
      local c = cite.citations[1]
      local letter = letters[c.id]
      if not letter then return nil end
      local text
      if c.mode == "SuppressAuthor" then
        text = pandoc.Inlines({ pandoc.Str(letter) })
      elseif #c.prefix > 0 then
        text = pandoc.Inlines(c.prefix):clone()
        text:extend({ pandoc.Space(), pandoc.Str(letter) })
      else
        text = pandoc.Inlines({ pandoc.Str("Anhang"), pandoc.Space(), pandoc.Str(letter) })
      end
      return pandoc.Link(text, "#" .. c.id)
    end,
  })
end
