-- Anhänge: Buchstaben vergeben und Verweise auflösen (E11, E15).
--
-- Ausgangspunkt: Spike S3 (docs/spikes/s3-querverweise/filters/ech_anhang.lua),
-- umgestellt vom ID-Präfix `sec-anhang-x` auf die Klasse `.appendix`.
--
-- Läuft VOR dem quarto-Filter. Überschriften der Ebene 1 mit der Klasse
-- `.appendix` tragen in der Quelle nur ihren Titel. Der Filter setzt in
-- Dokumentreihenfolge «Anhang A – », «Anhang B – » … davor und markiert sie
-- als unnummeriert. Verweise auf ihre Anker werden zu Links:
--
--   @sec-x              «Anhang F»
--   -@sec-x             «F»            (Quelle: «Anhang -@sec-x unten»)
--   [Anhang @sec-x]     «Anhang F»     (Präfix und Buchstabe)
--
-- Quarto selbst löst Anhänge nur in Book-Projekten als Verweisziel auf
-- (Spike S3). Die Klasse `.appendix` ersetzt der Filter durch `.ech-anhang`:
-- Mit `.appendix` verschiebt Quarto die Abschnitte auf der Website in einen
-- eigenen Anhangsbereich ohne Eintrag im Inhaltsverzeichnis, das Original
-- führt die Anhänge aber im Inhaltsverzeichnis. ech_docx_nummern.lua erkennt
-- Anhänge an `.ech-anhang`.

local PREFIX = { de = "Anhang", fr = "Annexe", en = "Appendix" }

function Pandoc(doc)
  local lang = doc.meta.lang and pandoc.utils.stringify(doc.meta.lang):sub(1, 2) or "de"
  local prefix = PREFIX[lang] or PREFIX.de
  local letters, n = {}, 0

  doc.blocks = doc.blocks:walk({
    Header = function(h)
      if h.level ~= 1 or not h.classes:includes("appendix") then return nil end
      n = n + 1
      local letter = string.char(64 + n)
      local content = pandoc.Inlines({ pandoc.Str(prefix), pandoc.Space(), pandoc.Str(letter),
        pandoc.Space(), pandoc.Str("–"), pandoc.Space() })
      content:extend(h.content)
      h.content = content
      h.classes = h.classes:filter(function(c) return c ~= "appendix" end)
      h.classes:insert("ech-anhang")
      if not h.classes:includes("unnumbered") then h.classes:insert("unnumbered") end
      if h.identifier ~= "" then letters[h.identifier] = letter end
      return h
    end,
  })
  if n == 0 then return doc end

  doc.blocks = doc.blocks:walk({
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
        text = pandoc.Inlines({ pandoc.Str(prefix), pandoc.Space(), pandoc.Str(letter) })
      end
      return pandoc.Link(text, "#" .. c.id)
    end,
  })
  return doc
end
