-- Deckblatt und Inhaltsverzeichnis im Word (E17, MVP-Spezifikation 4.2, D5).
--
-- Nur DOCX, läuft NACH `quarto`. Setzt vor den Text, in dieser Reihenfolge:
--
--   1. Titel «eCH-0003 – Leitfaden …» (Formatvorlage «Titel»)
--   2. Demonstrator-Hinweis (Metadatum `demonstrator-hinweis`, D5)
--   3. Tabelle: Beschriftungen und Reihenfolge aus der Vorlage-Fassung
--      (vorlage/<fassung>/deckblatt.yml), Werte aus den Metadaten; Zellen wie
--      in der eCH-Vorlage «Tabellentitel» (Beschriftung) und «Tabellentext»
--   4. «Zusammenfassung» («Nebentitel») und Text aus `abstract`
--   5. Seitenumbruch
--   6. «Inhaltsverzeichnis» (Vorlage «Titel Inhaltsverzeichnis») und das Feld TOC
--   7. Seitenumbruch
--
-- Die Fusszeile der eCH-Vorlage zeigt die Textmarken eCHNummer, eCHName,
-- Version, Status und Ausgabedatum (REF-Felder, Spike S3). Der Filter setzt
-- sie auf die Werte im Titel und in der Tabelle. Den Titelblock von Pandoc
-- unterdrückt er, indem er Titel und Zusammenfassung aus den Metadaten nimmt.
-- Word füllt das Inhaltsverzeichnis beim Öffnen, wenn danach
-- tools/aktualisiere_felder_beim_oeffnen.py gelaufen ist.

local common = dofile(quarto.utils.resolve_path("ech_common.lua"))
local stringify = pandoc.utils.stringify

-- Zeilen der Tabelle, deren Wert eine Textmarke der Fusszeile trägt
local TEXTMARKEN = { version = "Version", status = "Status", ausgabedatum = "Ausgabedatum" }

local function absatz(inlines, stil)
  return pandoc.Div({ pandoc.Para(inlines) }, pandoc.Attr("", {}, { ["custom-style"] = stil }))
end

local function seitenumbruch()
  return pandoc.RawBlock("openxml", '<w:p><w:r><w:br w:type="page"/></w:r></w:p>')
end

local function inhaltsverzeichnis_feld(tiefe, platzhalter)
  return pandoc.RawBlock("openxml", table.concat({
    "<w:p>",
    '<w:r><w:fldChar w:fldCharType="begin" w:dirty="true"/></w:r>',
    string.format('<w:r><w:instrText xml:space="preserve"> TOC \\o "1-%d" \\h \\z \\u </w:instrText></w:r>', tiefe),
    '<w:r><w:fldChar w:fldCharType="separate"/></w:r>',
    "<w:r><w:t>", platzhalter, "</w:t></w:r>",
    '<w:r><w:fldChar w:fldCharType="end"/></w:r>',
    "</w:p>",
  }))
end

local function textmarke(name, inlines)
  return pandoc.Inlines({ pandoc.Span(inlines, pandoc.Attr(name)) })
end

local function tabelle(rows)
  local body = {}
  for _, row in ipairs(rows) do
    local werte = {}
    for i, wert in ipairs(row.values) do
      local inlines = pandoc.Inlines(wert)
      if i == 1 and TEXTMARKEN[row.key] then inlines = textmarke(TEXTMARKEN[row.key], inlines) end
      table.insert(werte, absatz(inlines, "Tabellentext"))
    end
    table.insert(body, pandoc.Row({
      pandoc.Cell({ absatz(row.label, "Tabellentitel") }),
      pandoc.Cell(werte),
    }))
  end
  return pandoc.Table(
    pandoc.Caption(),
    { { pandoc.AlignLeft, 0.3 }, { pandoc.AlignLeft, 0.7 } },
    pandoc.TableHead(),
    { { attr = pandoc.Attr(), body = body, head = {}, row_head_columns = 0 } },
    pandoc.TableFoot()
  )
end

function Pandoc(doc)
  if not quarto.doc.is_format("docx") then return nil end
  local meta = doc.meta
  local display = common.display(meta, { include_name = true })
  if display == nil then return nil end
  if not meta.title then error("Deckblatt: `title` fehlt") end

  local titel = pandoc.Inlines({})
  titel:extend(textmarke("eCHNummer", display.number))
  titel:extend({ pandoc.Space(), pandoc.Str("–"), pandoc.Space() })
  titel:extend(textmarke("eCHName", common.to_inlines(meta.title)))

  -- Pandoc wählt Formatvorlagen über den Namen, nicht die ID. «Titel» ist
  -- eingebaut und heisst intern «Title»; sonst entsteht eine neue Vorlage.
  local deckblatt = pandoc.Blocks({ absatz(titel, "Title") })
  local hinweis = meta["demonstrator-hinweis"]
  if hinweis == nil then error("Deckblatt: `demonstrator-hinweis` fehlt (D5)") end
  if pandoc.utils.type(hinweis) == "Inlines" then
    deckblatt:insert(pandoc.Para(hinweis))
  else
    deckblatt:extend(hinweis)
  end
  deckblatt:insert(tabelle(display.rows))
  if meta.abstract then
    deckblatt:insert(absatz(display.summary, "Nebentitel"))
    deckblatt:extend(pandoc.utils.type(meta.abstract) == "Inlines" and { pandoc.Para(meta.abstract) } or meta.abstract)
  end
  deckblatt:insert(seitenumbruch())
  local tiefe = tonumber(stringify(meta["toc-depth"] or "3")) or 3
  local toc_titel = meta["toc-title"] and common.to_inlines(meta["toc-title"]) or pandoc.Inlines("Inhaltsverzeichnis")
  deckblatt:insert(absatz(toc_titel, "Titel Inhaltsverzeichnis"))
  deckblatt:insert(inhaltsverzeichnis_feld(tiefe, "Das Inhaltsverzeichnis erstellt Word beim Öffnen."))
  deckblatt:insert(seitenumbruch())

  doc.blocks = deckblatt .. doc.blocks
  -- Titelblock von Pandoc unterdrücken
  meta.title, meta.subtitle, meta.abstract, meta.author, meta.date = nil, nil, nil, nil, nil
  return doc
end
