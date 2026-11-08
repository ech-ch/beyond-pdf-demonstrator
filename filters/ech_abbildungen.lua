-- Abbildungen (AP25, F10 vorläufig E52): Bildunterschrift wie im Original und
-- im Word die Form des Originals; Abbildungsverzeichnis (Anhang E, AP26).
--
-- Quelle (Baustein-Datei, Bild aus tools/schneide_abbildungen.py):
--   ![Genehmigungsprozess](abbildungen/genehmigungsprozess.png){#fig-genehmigungsprozess fig-alt="…"}
--
-- Quarto nummeriert die Abbildungen (crossref in _quarto.yml) und baut die
-- Bildunterschrift «Abbildung», geschütztes Leerzeichen, «1», «–», Leerzeichen,
-- Titel. Das Original hat «Abbildung 1 – Genehmigungsprozess» mit gewöhnlichen
-- Leerzeichen; der Textvergleich mit dem Rohtext zählt ein geschütztes
-- Leerzeichen als Abweichung (E11), und `title-delim` verliert ein Leerzeichen
-- davor. Der Filter setzt deshalb die Leerzeichen.
--
-- Nur DOCX: Quarto setzt die Abbildung in eine Tabelle mit einer Zelle.
-- Der Filter löst sie auf, wie im Original: ein Absatz mit dem Bild, darunter
-- die Bildunterschrift in der Formatvorlage «Beschriftung» der eCH-Vorlage
-- (statt «ImageCaption» von Pandoc, als rohes w:pPr). Das Bild wird mit der
-- Bildunterschrift zusammengehalten. Den Alternativtext schreibt
-- Pandoc nur aus dem Inhalt des Bildes ins Word (descr), nicht aus dem
-- Attribut `alt`; der Filter überträgt ihn.
--
-- Abbildungsverzeichnis (AP26): Unter der Überschrift mit der Klasse
-- `.abbildungsverzeichnis` (Anhang E) steht je Abbildung ihre Bildunterschrift
-- in Reihenfolge. Website: Liste ohne Seitenzahlen, verlinkt auf die
-- Abbildung. Word: Absätze in der Formatvorlage «Abbildungsverzeichnis» der
-- eCH-Vorlage (Tabulator mit Punkten), Seitenzahl als Feld PAGEREF auf die
-- Textmarke der Abbildung, verlinkt (\h); Word füllt sie beim Öffnen
-- (tools/aktualisiere_felder_beim_oeffnen.py), wie das Inhaltsverzeichnis.
-- Fehlt die Überschrift oder eine Abbildung, bricht der Build ab.
--
-- Läuft NACH `quarto` (dann ist die Abbildung nummeriert) und vor
-- ech_docx_tabellen.lua. Erkennt er eine Abbildung nicht, bricht der Build ab
-- (common.abbruch, E48).

local common = dofile(quarto.utils.resolve_path("ech_common.lua"))

local DELIM = "–"

-- Abbildungen in Reihenfolge: { id = "fig-…", unterschrift = Inlines }
local abbildungen = {}
local function merke(id, inlines)
  local ohne = inlines:filter(function(el) return not (el.t == "RawInline") end)
  table.insert(abbildungen, { id = id, unterschrift = ohne })
end

-- «Abbildung», U+00A0, «1», «–» -> «Abbildung», Leerzeichen, «1», Leerzeichen, «–»
local function unterschrift(inlines)
  for i = 1, #inlines - 3 do
    local a, b, c, d = inlines[i], inlines[i + 1], inlines[i + 2], inlines[i + 3]
    if a.t == "Str" and b.t == "Str" and b.text == "\u{a0}" and c.t == "Str" and c.text:match("^%d+$")
        and d.t == "Str" and d.text == DELIM then
      inlines[i + 1] = pandoc.Space()
      inlines:insert(i + 3, pandoc.Space())
      return inlines, true
    end
  end
  return inlines, false
end

local function html(div)
  local gefunden = false
  div = div:walk({
    Plain = function(p)
      local neu, ok = unterschrift(p.content)
      if ok then
        gefunden = true
        p.content = neu
        merke(div.identifier, neu:clone())
        return p
      end
    end,
  })
  if not gefunden then
    common.abbruch("ech_abbildungen.lua: Bildunterschrift von «" .. div.identifier .. "» nicht erkannt")
  end
  return div
end

-- Tabelle mit einer Zelle, darin ein Div #fig-…: Bild (Plain) und Unterschrift (Para)
local function docx(tabelle)
  if #tabelle.bodies ~= 1 or #tabelle.bodies[1].body ~= 1 then return nil end
  local zellen = tabelle.bodies[1].body[1].cells
  if #zellen ~= 1 then return nil end
  local div = zellen[1].contents[1]
  if not (div and div.t == "Div" and div.identifier:match("^fig%-")) then return nil end
  local bild, unter
  for _, b in ipairs(div.content) do
    if b.t == "Plain" and b.content[1] and b.content[1].t == "Image" then
      bild = b
    elseif b.t == "Para" then
      unter = b
    end
  end
  if not (bild and unter) then
    common.abbruch("ech_abbildungen.lua: Abbildung «" .. div.identifier .. "» im Word nicht erkannt")
  end
  local img = bild.content[1]
  local alt = img.attributes["fig-alt"] or img.attributes["alt"]
  if alt then
    img.caption = pandoc.Inlines({ pandoc.Str(alt) })
  end
  local neu, ok = unterschrift(unter.content)
  if not ok then
    common.abbruch("ech_abbildungen.lua: Bildunterschrift von «" .. div.identifier .. "» nicht erkannt")
  end
  -- Quarto setzt die Formatvorlage als rohes w:pPr in den Absatz; Pandoc
  -- schreibt davor ein eigenes w:pPr. Stattdessen die Formatvorlage über
  -- custom-style (Name «caption» = «Beschriftung» der eCH-Vorlage).
  neu = neu:filter(function(el) return not (el.t == "RawInline" and el.format == "openxml") end)
  merke(div.identifier, neu:clone())
  local beschriftung = pandoc.Div({ pandoc.Para(neu) }, pandoc.Attr("", {}, { ["custom-style"] = "caption" }))
  -- Bild und Bildunterschrift auf derselben Seite (keepNext). Die eCH-Vorlage
  -- hat keine Formatvorlage für Bilder, und eine über custom-style neu
  -- angelegte hätte kein keepNext. Ein rohes w:pPr am Anfang des Absatzes
  -- ergibt ein zweites w:pPr nach dem von Pandoc, wie Quarto es selbst für
  -- Bildunterschriften macht; Word übernimmt beide (per COM geprüft, AP25).
  local bildabsatz = pandoc.Plain({ pandoc.RawInline("openxml", "<w:pPr><w:keepNext/></w:pPr>") })
  bildabsatz.content:extend(bild.content)
  return pandoc.Div({ bildabsatz, beschriftung }, pandoc.Attr(div.identifier))
end

-- Abbildungsverzeichnis -------------------------------------------------

local function seitenzahl(id)
  return pandoc.RawInline("openxml", table.concat({
    "<w:r><w:tab/></w:r>",
    '<w:r><w:fldChar w:fldCharType="begin" w:dirty="true"/></w:r>',
    '<w:r><w:instrText xml:space="preserve"> PAGEREF ', id, ' \\h </w:instrText></w:r>',
    '<w:r><w:fldChar w:fldCharType="separate"/></w:r>',
    "<w:r><w:t>?</w:t></w:r>",
    '<w:r><w:fldChar w:fldCharType="end"/></w:r>',
  }))
end

local function verzeichnis(doc)
  local docx = quarto.doc.is_format("docx")
  local bloecke, gefunden = pandoc.Blocks({}), false
  for _, b in ipairs(doc.blocks) do
    bloecke:insert(b)
    if b.t == "Header" and b.classes:includes("abbildungsverzeichnis") then
      if #abbildungen == 0 then common.abbruch("ech_abbildungen.lua: Abbildungsverzeichnis ohne Abbildungen") end
      gefunden = true
      if docx then
        for _, a in ipairs(abbildungen) do
          -- ohne Link-Formatierung wie im Original; die Seitenzahl verlinkt (PAGEREF \h)
          local inhalt = a.unterschrift:clone()
          inhalt:insert(seitenzahl(a.id))
          local p = pandoc.Para(inhalt)
          bloecke:insert(pandoc.Div({ p }, pandoc.Attr("", {}, { ["custom-style"] = "table of figures" })))
        end
      else
        local punkte = {}
        for _, a in ipairs(abbildungen) do
          table.insert(punkte, { pandoc.Plain({ pandoc.Link(a.unterschrift, "#" .. a.id) }) })
        end
        bloecke:insert(pandoc.Div({ pandoc.BulletList(punkte) }, pandoc.Attr("", { "abbildungsverzeichnis" })))
      end
    end
  end
  if #abbildungen > 0 and not gefunden then
    common.abbruch("ech_abbildungen.lua: Abbildungen, aber keine Überschrift .abbildungsverzeichnis (Anhang E)")
  end
  doc.blocks = bloecke
  return doc
end

if quarto.doc.is_format("html") then
  return { { Div = function(div)
    if div.classes:includes("quarto-float") and div.identifier:match("^fig%-") then return html(div) end
  end }, { Pandoc = verzeichnis } }
elseif quarto.doc.is_format("docx") then
  return { { Table = docx }, { Pandoc = verzeichnis } }
end
return {}
