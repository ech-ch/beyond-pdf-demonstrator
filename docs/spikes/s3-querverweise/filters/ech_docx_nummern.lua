-- Spike S3, Lösung A gegen doppelte Nummerierung im DOCX.
--
-- Die eCH-Vorlage nummeriert «Überschrift 1-9» automatisch (w:numPr in
-- styles.xml). Quarto schreibt bei number-sections die Nummer zusätzlich als
-- Text in die Überschrift («7.3 Versionierung», Ebene 1 «7. Formales»).
-- Dieser Filter (nur DOCX, NACH `quarto`) entfernt die Textnummer wieder und
-- überlässt die Nummer Word. Unnummerierte Überschriften würden sonst von Word
-- mitgezählt; sie werden deshalb als Absatz mit einer nicht nummerierten
-- Formatvorlage der eCH-Vorlage ausgegeben (Anhänge: «Anhang Überschrift»,
-- übrige: «Nebentitel»). Die ID bleibt als Textmarke erhalten (Div-ID).
-- Aktiv nur mit Metadatum `docx-nummern: word`.

local stringify = pandoc.utils.stringify

local function strip_number(h)
  local num = h.attributes["number"]
  local c = h.content
  if num and c[1] and c[1].t == "Str" and c[1].text == num then
    c:remove(1)
    if c[1] and (c[1].t == "Space" or (c[1].t == "Str" and c[1].text == ". ")) then c:remove(1) end
  end
  return h
end

function Pandoc(doc)
  if not quarto.doc.is_format("docx") then return nil end
  if stringify(doc.meta["docx-nummern"] or "") ~= "word" then return nil end
  doc.blocks = doc.blocks:walk({
    Header = function(h)
      if h.classes:includes("unnumbered") then
        local style = h.classes:includes("appendix") and "Anhang Überschrift" or "Nebentitel"
        return pandoc.Div({ pandoc.Para(h.content) },
          pandoc.Attr(h.identifier, {}, { ["custom-style"] = style }))
      end
      return strip_number(h)
    end,
  })
  return doc
end
