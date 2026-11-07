-- Deckblatt und Inhaltsverzeichnis im Word (E17, MVP-Spezifikation 4.2, D5).
--
-- Nur DOCX, läuft NACH `quarto`. Setzt vor den Text, in dieser Reihenfolge:
--
--   1. Titel «eCH-0003 – Leitfaden …» (Formatvorlage «Titel»)
--   2. Demonstrator-Hinweis (Metadatum `demonstrator-hinweis`, D5)
--   3. Tabelle: Beschriftungen und Reihenfolge aus der Vorlage-Fassung
--      (vorlage/<fassung>/deckblatt.yml), Werte aus den Metadaten. Format wie
--      im Word-Original von V11.1.0: Rahmen 0,5 pt, Spalten 2622/6589 dxa,
--      Zellränder 70, senkrecht zentriert, «Standard» mit fetter Beschriftung,
--      Beilagen als «• Aufzählung», eine Leerzeile davor und zwei danach. Als
--      OpenXML, weil sich Rahmen und Abstände einer Pandoc-Tabelle nicht
--      steuern lassen; Links darin sind Felder HYPERLINK, weil OpenXML hier
--      keine Beziehungen anlegt
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
local BREITE = { 2622, 6589 }           -- dxa, wie im Original

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

local function xml(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

-- Inlines als Läufe; Links als Feld HYPERLINK mit der Zeichenvorlage «Hyperlink».
local function laeufe(inlines, fett)
  local fett_xml = fett and "<w:b/>" or ""
  local teile, text = {}, ""
  local function schreibe()
    if text ~= "" then
      table.insert(teile, string.format('<w:r>%s<w:t xml:space="preserve">%s</w:t></w:r>',
        fett and "<w:rPr><w:b/></w:rPr>" or "", xml(text)))
      text = ""
    end
  end
  for _, el in ipairs(inlines) do
    if el.t == "Str" then
      text = text .. el.text
    elseif el.t == "Space" or el.t == "SoftBreak" then
      text = text .. " "
    elseif el.t == "Link" then
      schreibe()
      table.insert(teile, string.format(
        '<w:fldSimple w:instr=" HYPERLINK &quot;%s&quot; "><w:r><w:rPr><w:rStyle w:val="Hyperlink"/>%s</w:rPr><w:t xml:space="preserve">%s</w:t></w:r></w:fldSimple>',
        xml(el.target), fett_xml, xml(stringify(el.content))))
    else
      text = text .. stringify(el)
    end
  end
  schreibe()
  return table.concat(teile)
end

local function zelle(breite, absaetze)
  return string.format('<w:tc><w:tcPr><w:tcW w:w="%d" w:type="dxa"/><w:vAlign w:val="center"/></w:tcPr>%s</w:tc>',
    breite, table.concat(absaetze))
end

local function tabelle(rows)
  local rahmen = {}
  for _, seite in ipairs({ "top", "left", "bottom", "right", "insideH", "insideV" }) do
    table.insert(rahmen, string.format('<w:%s w:val="single" w:sz="4" w:space="0" w:color="auto"/>', seite))
  end
  local zeilen, marke = {}, 9000   -- Textmarken-IDs ausserhalb der von Pandoc vergebenen
  for _, row in ipairs(rows) do
    local werte = {}
    for i, wert in ipairs(row.values) do
      local ppr = row.punkte[i] and '<w:pPr><w:pStyle w:val="Aufzhlung"/><w:ind w:left="563" w:hanging="203"/></w:pPr>' or ""
      local inhalt = laeufe(pandoc.Inlines(wert), false)
      if i == 1 and TEXTMARKEN[row.key] then
        marke = marke + 1
        inhalt = string.format('<w:bookmarkStart w:id="%d" w:name="%s"/>%s<w:bookmarkEnd w:id="%d"/>',
          marke, TEXTMARKEN[row.key], inhalt, marke)
      end
      table.insert(werte, "<w:p>" .. ppr .. inhalt .. "</w:p>")
    end
    table.insert(zeilen, "<w:tr>" .. zelle(BREITE[1], { "<w:p>" .. laeufe(row.label, true) .. "</w:p>" })
      .. zelle(BREITE[2], werte) .. "</w:tr>")
  end
  return pandoc.RawBlock("openxml", table.concat({
    "<w:p/>",   -- Leerzeilen wie im Original
    "<w:tbl><w:tblPr>",
    string.format('<w:tblW w:w="%d" w:type="dxa"/>', BREITE[1] + BREITE[2]),
    "<w:tblBorders>", table.concat(rahmen), "</w:tblBorders>",
    '<w:tblLayout w:type="fixed"/>',
    '<w:tblCellMar><w:left w:w="70" w:type="dxa"/><w:right w:w="70" w:type="dxa"/></w:tblCellMar>',
    '<w:tblLook w:val="0000" w:firstRow="0" w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:noHBand="0" w:noVBand="0"/>',
    "</w:tblPr>",
    string.format('<w:tblGrid><w:gridCol w:w="%d"/><w:gridCol w:w="%d"/></w:tblGrid>', BREITE[1], BREITE[2]),
    table.concat(zeilen),
    "</w:tbl>",
    "<w:p/><w:p/>",
  }))
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
