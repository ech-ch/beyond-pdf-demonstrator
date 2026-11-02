-- Word nummeriert die Überschriften, nicht Quarto (Spike S3, Lösung A).
--
-- Ausgangspunkt: Spike S3 (docs/spikes/s3-querverweise/filters/ech_docx_nummern.lua),
-- ohne den Schalter `docx-nummern`.
--
-- Die eCH-Vorlage nummeriert «Überschrift 1–9» automatisch (w:numPr in
-- styles.xml). Quarto schreibt bei number-sections die Nummer zusätzlich als
-- Text in die Überschrift («7.3 Versionierung»). Dieser Filter (nur DOCX,
-- NACH `quarto`) entfernt die Textnummer wieder und überlässt die Nummer
-- Word. Die Verweise im Text («Kapitel 7.5») hat Quarto bereits gesetzt; sie
-- stimmen, weil Word und Quarto gleich zählen.
--
-- Unnummerierte Überschriften würden von Word mitgezählt. Sie werden deshalb
-- als Absatz in einer nicht nummerierten Formatvorlage der eCH-Vorlage
-- ausgegeben: Anhänge (Klasse `.ech-anhang`, gesetzt von ech_anhang.lua) in
-- «Anhang Überschrift», übrige in «Nebentitel». Die ID bleibt als Textmarke
-- erhalten (Div-ID).

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
  doc.blocks = doc.blocks:walk({
    Header = function(h)
      if h.classes:includes("unnumbered") then
        local style = h.classes:includes("ech-anhang") and "Anhang Überschrift" or "Nebentitel"
        return pandoc.Div({ pandoc.Para(h.content) },
          pandoc.Attr(h.identifier, {}, { ["custom-style"] = style }))
      end
      return strip_number(h)
    end,
  })
  return doc
end
