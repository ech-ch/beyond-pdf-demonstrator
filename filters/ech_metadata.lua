-- Quarto-Filter: Deckblatt der Website aus den eCH-Metadaten.
--
-- Herkunft: FOAG-Template blw-ofag-ufag/semantic-web-template,
-- docs/assets/ech_metadata.lua (CC BY 4.0, Stand Commit 659b85f).
-- Angepasst für den Demonstrator: Beschriftungen aus der Vorlage-Fassung
-- (ech_common.lua); ohne Typst-Werte (`ech-display`, PDF erst in Stufe 2).
--
-- Setzt `ech-rows` (Liste von { label, values, bullets }) für das Partial
-- assets/title-metadata.html. Auf der Website stellt der Filter dem Titel die
-- eCH-Nummer voran («eCH-0003 – Leitfaden …», wie im Original) und macht aus
-- der Zusammenfassung ein unnummeriertes, nicht gelistetes erstes Kapitel.
-- Das Deckblatt im Word erzeugt ein eigener Filter (E17, AP6).

local common = dofile(quarto.utils.resolve_path("ech_common.lua"))

function Pandoc(doc)
  local meta = doc.meta
  local display = common.display(meta, { include_name = not quarto.doc.is_format("html") })
  if display == nil then return doc end

  local rows = {}
  for _, row in ipairs(display.rows) do
    table.insert(rows, { label = row.label, values = row.values, bullets = row.bullets })
  end
  meta["ech-rows"] = rows
  if quarto.doc.is_format("html") and display.number and meta.title then
    local title = pandoc.Inlines({})
    title:extend(display.number)
    title:extend(pandoc.Inlines(pandoc.Str(" – ")))
    title:extend(pandoc.utils.type(meta.title) == "Inlines" and meta.title or pandoc.Inlines(pandoc.Str(pandoc.utils.stringify(meta.title))))
    meta.title = title
  end
  if quarto.doc.is_format("html") and meta.abstract then
    local abstract = meta.abstract
    if pandoc.utils.type(abstract) == "Inlines" then abstract = pandoc.Blocks(pandoc.Para(abstract)) end
    local heading = pandoc.Header(1, display.summary, pandoc.Attr("sec-zusammenfassung", { "unnumbered", "unlisted" }))
    doc.blocks = pandoc.Blocks({ heading }) .. abstract .. doc.blocks
    meta.abstract = nil
  end
  return doc
end
