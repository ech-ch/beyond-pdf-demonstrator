-- Platzhalter unter nicht überführten Überschriften des Gerüsts (E05).
--
-- Eine Überschrift mit der Klasse `.platzhalter` und dem Attribut
-- `original-seite` erhält darunter den Hinweis
--
--   Dieser Abschnitt ist im Demonstrator nicht in Bausteine überführt.
--   Massgebend ist das Original: eCH-0003 V11.1.0, Seite N.
--
-- «eCH-0003 V11.1.0, Seite N» verlinkt auf die Seite im Original-PDF
-- (Metadaten `original` und `original-pdf`, ech-0003/v11.1.0/_metadata.yml).
-- Website: grauer Hinweiskasten (Klasse .platzhalter-hinweis, assets/ech.scss),
-- Link relativ auf das mitveröffentlichte PDF. Word: kursiver Satz, Link
-- absolut auf die Website (`demonstrator-url` in _quarto.yml), weil das Word
-- heruntergeladen und ohne die Website geöffnet wird.
--
-- Läuft VOR dem quarto-Filter. Fehlen `original-seite` oder die Metadaten,
-- bricht der Build ab.

local stringify = pandoc.utils.stringify

-- Pfad vom Ausgabeordner des Dokuments zurück zum Projektordner, z.B. "../../../".
local function to_project_root()
  local project = quarto.project.directory
  local input = quarto.doc.input_file
  if not project or not input then return "" end
  local dir = pandoc.path.make_relative(pandoc.path.directory(input), project):gsub("\\", "/")
  if dir == "." or dir == "" then return "" end
  local _, depth = dir:gsub("[^/]+", "")
  return string.rep("../", depth)
end

local function site_url(meta)
  local url = meta["demonstrator-url"] and stringify(meta["demonstrator-url"]) or ""
  if url == "" then
    error("Platzhalter: `demonstrator-url` fehlt in _quarto.yml (Link im Word)")
  end
  return (url:gsub("/*$", "/"))
end

function Pandoc(doc)
  local meta = doc.meta
  local docx = quarto.doc.is_format("docx")
  local original = meta.original and stringify(meta.original) or nil
  local pdf = meta["original-pdf"] and stringify(meta["original-pdf"]) or nil

  local blocks = pandoc.Blocks({})
  for _, block in ipairs(doc.blocks) do
    blocks:insert(block)
    if block.t == "Header" and block.classes:includes("platzhalter") then
      local seite = block.attributes["original-seite"]
      if not (seite and original and pdf) then
        error(string.format("Platzhalter «%s»: `original-seite` an der Überschrift oder `original`/`original-pdf` in den Metadaten fehlt",
          stringify(block.content)))
      end
      local base = docx and site_url(meta) or to_project_root()
      local link = pandoc.Link(original .. ", Seite " .. seite, base .. pdf .. "#page=" .. seite)
      local text = pandoc.Inlines({
        pandoc.Str("Dieser Abschnitt ist im Demonstrator nicht in Bausteine überführt. Massgebend ist das Original:"),
        pandoc.Space(), link, pandoc.Str("."),
      })
      if docx then
        blocks:insert(pandoc.Para({ pandoc.Emph(text) }))
      else
        blocks:insert(pandoc.Div({ pandoc.Para(text) }, pandoc.Attr("", { "platzhalter-hinweis" })))
      end
    end
  end
  doc.blocks = blocks
  return doc
end
