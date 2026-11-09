-- Darstellung der Beziehungen aus der Registry (E47, AP21). Modul, kein Filter.
--
-- Verwendet von filters/ech_registry.lua, für die Liste je Baustein auf der
-- Standardseite und für die Übersichtsseite «Beziehungen». Beide arbeiten mit
-- derselben Datenstruktur: der Registry, wie sie in bausteine.json steht
-- (pandoc.json.decode). Abgeleitet wird hier nichts.
--
-- Sichtbar sind Querverweise (refers_to, W1–W3) und Rückbezüge (depends_on,
-- E30), je in beiden Richtungen. Die Einbettung (is_part_of/has_part) zeigt die
-- Gliederung; sie zählt nicht.
--
-- Ziele ohne Baustein tragen ihre Art als Hinweis (CONTEXT.md): «noch kein
-- Baustein» nur für Platzhalter; «Vorlagentext» und «Statustext» für erzeugten
-- Inhalt aus der Vorlage-Fassung, der nie ein Baustein wird (ADR 0005, E50).

local M = {}

-- Echter Abbruch; `error()` schreibt in Quarto-Filtern nur eine Meldung (E48)
local function abbruch(text)
  assert(false, text)
end

-- Reihenfolge und Beschriftung (CONTEXT.md: Querverweis, Rückbezug)
M.ARTEN = {
  { typ = "refers_to", art = "Querverweis", richtung = "Querverweis auf", vorwaerts = true },
  { typ = "is_referenced_by", art = "Querverweis", richtung = "Querverweis von" },
  { typ = "depends_on", art = "Rückbezug", richtung = "Rückbezug auf", vorwaerts = true },
  { typ = "is_required_by", art = "Rückbezug", richtung = "Rückbezug von" },
}
local ART = {}
for _, a in ipairs(M.ARTEN) do ART[a.typ] = a end

-- Hinweis hinter einem Ziel ohne Baustein, je target_kind
M.ZIEL_HINWEIS = {
  noch_kein_baustein = "noch kein Baustein",
  vorlagentext = "Vorlagentext",
  statustext = "Statustext",
  literatur = "Literatur",
  standard = "anderer Standard",
}

function M.esc(s)
  return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end
local esc = M.esc

local function wert(x)
  if x == nil or x == pandoc.json.null then return nil end
  return x
end

function M.index(registry)
  local index = {}
  for _, e in ipairs(registry.bausteine) do index[e.id] = e end
  return index
end

-- «7.3 Versionierung», «Anhang F – Formale Syntax …»
function M.fundstelle_text(f)
  local nr = wert(f.section)
  if not nr then return f.title end
  if nr:match("^Anhang ") then return nr .. " – " .. f.title end
  return nr .. " " .. f.title
end

local function fundstellen_text(e)
  local teile = {}
  for _, f in ipairs(e.source_reference) do table.insert(teile, M.fundstelle_text(f)) end
  return table.concat(teile, ", ")
end

-- Sichtbare Beziehungen eines Bausteins, nach Art und Richtung gruppiert
function M.gruppen(e)
  local gruppen, n = {}, 0
  for _, a in ipairs(M.ARTEN) do
    local liste = {}
    for _, r in ipairs(e.relationships) do
      if r.type == a.typ then table.insert(liste, r) end
    end
    if #liste > 0 then
      table.insert(gruppen, { art = a, beziehungen = liste })
      n = n + #liste
    end
  end
  return gruppen, n
end

-- Ein Baustein als Link mit Name und ID; `basis` ist die Seite des Standards
-- («» auf der Standardseite selbst, «index.html» auf der Übersichtsseite).
function M.baustein_html(e, basis)
  local name
  if e.granularitaet == "grob" then
    name = M.fundstelle_text(e.source_reference[1])
  else
    local nr = {}
    for _, f in ipairs(e.source_reference) do table.insert(nr, wert(f.section) or f.title) end
    name = e.name .. " (" .. table.concat(nr, ", ") .. ")"
  end
  return string.format('<a href="%s#%s">%s</a> <code class="beziehung-id">%s</code>',
    esc(basis), esc(e.id), esc(name), esc(e.id))
end

-- Ziel einer Beziehung, verlinkt wie im Text
function M.ziel_html(r, index, basis)
  local art = r.target_kind
  if art == "baustein" then
    local e = index[r.target]
    if not e then abbruch("Beziehungen: Ziel «" .. r.target .. "» fehlt in der Registry") end
    return M.baustein_html(e, basis)
  end
  local hinweis = M.ZIEL_HINWEIS[art]
  if not hinweis then abbruch("Beziehungen: unbekannte Zielart «" .. tostring(art) .. "»") end
  hinweis = ' <span class="beziehung-hinweis">' .. esc(hinweis) .. "</span>"
  if art == "noch_kein_baustein" or art == "vorlagentext" or art == "statustext" then
    return string.format('<a href="%s#%s">%s</a>', esc(basis), esc(r.target), esc(wert(r.title) or r.target)) .. hinweis
  elseif art == "literatur" then
    return string.format('<a href="%s#ref-%s">[%s]</a>', esc(basis), esc(r.target), esc(r.target)) .. hinweis
  else   -- standard
    local url, titel = wert(r.url), wert(r.title) or r.target
    return (url and string.format('<a href="%s">%s</a>', esc(url), esc(titel)) or esc(titel)) .. hinweis
  end
end

-- «Beziehungen (n)» je Baustein, oder nil ohne Querverweis und Rückbezug
function M.details_html(e, index, basis)
  local gruppen, n = M.gruppen(e)
  if n == 0 then return nil end
  local teile = { string.format('<details class="baustein-beziehungen" data-beziehungen="%s" data-anzahl="%d"><summary>Beziehungen (%d)</summary>',
    esc(e.id), n, n) }
  for _, g in ipairs(gruppen) do
    table.insert(teile, string.format('<p class="beziehungen-richtung">%s</p><ul>', esc(g.art.richtung)))
    for _, r in ipairs(g.beziehungen) do
      table.insert(teile, string.format('<li data-typ="%s">%s</li>', esc(r.type), M.ziel_html(r, index, basis)))
    end
    table.insert(teile, "</ul>")
  end
  table.insert(teile, "</details>")
  return table.concat(teile)
end

-- Übersichtsseite -----------------------------------------------------------

-- Grobe Bausteine, zu denen ein Baustein gehört (sich selbst, wenn er grob ist)
local function grobe(e)
  if e.granularitaet == "grob" then return { e.id } end
  local liste = {}
  for _, r in ipairs(e.relationships) do
    if r.type == "is_part_of" then table.insert(liste, r.target) end
  end
  return liste
end

local function mermaid_text(s)
  return (s:gsub('"', "#quot;"))
end

-- Grober Baustein in einem Anhang («Anhang C» usw.)
function M.im_anhang(e)
  local nr = wert(e.source_reference[1].section)
  return nr ~= nil and nr:match("^Anhang ") ~= nil
end

-- Pfeile aus diesem groben Baustein stehen nur in der Tabelle: Anhänge (F56)
-- und grobe Bausteine, deren Klauseln noch keine feinen Bausteine sind (Kap.
-- 2–5, `klauseln_im_text`, AP27, E56); der Graph bleibt so lesbar.
function M.nur_tabelle(e)
  return M.im_anhang(e) or e.klauseln_im_text == true
end

-- Legende: nur, was im Graph vorkommt (Schlüssel wie `verwendet` in M.graph)
M.LEGENDE = {
  { "baustein", "Rechteck: grober Baustein" },
  { "nochkein", "Rechteck gestrichelt: Überschrift ohne Baustein («noch kein Baustein»)" },
  { "vorlage", "Rechteck gepunktet: Vorlagentext oder Statustext (erzeugter Inhalt, nie ein Baustein)" },
  { "standard", "abgerundet: anderer Standard" },
  { "literatur", "schräg: Literatureintrag (Anhang A)" },
  { "refers_to", "Pfeil durchgezogen: Querverweis" },
  { "depends_on", "Pfeil gestrichelt: Rückbezug" },
  { "doppelt", "Pfeil mit zwei Spitzen: Beziehungen in beide Richtungen" },
  { "anzahl", "Zahl am Pfeil: Anzahl der Beziehungen, wenn es mehr als eine ist" },
}

function M.legende_html(verwendet)
  local teile = { '<ul class="beziehungen-legende">' }
  for _, l in ipairs(M.LEGENDE) do
    if verwendet[l[1]] then
      table.insert(teile, string.format('<li data-legende="%s">%s</li>', esc(l[1]), esc(l[2])))
    end
  end
  table.insert(teile, "</ul>")
  return table.concat(teile)
end

-- Graph auf Ebene der groben Bausteine (Mermaid). Kanten fassen die
-- Vorwärtsbeziehungen der Bausteine je grobem Quell- und Zielbaustein zusammen;
-- Beziehungen innerhalb desselben groben Bausteins und die Einbettung fehlen,
-- ebenso Pfeile, die in einem Anhang beginnen (F56, Variante a): Glossar und
-- Änderungsübersicht sind Nachschlagestellen. Sie stehen in der Tabelle, wie
-- die Pfeile aus Kap. 2–5 (M.nur_tabelle, AP27).
-- Pfeile in einen Anhang hinein bleiben (7.3 -> Anhang F).
-- Gibt den Mermaid-Text und `verwendet` zurück (Knotenklassen und Pfeilarten
-- im Bild, für die Legende).
function M.graph(registry, index)
  local knoten, knoten_liste, kanten, kanten_liste, verwendet = {}, {}, {}, {}, {}
  local function knoten_von(schluessel, text, form, klasse)
    if not knoten[schluessel] then
      local id = "n" .. (#knoten_liste + 1)
      knoten[schluessel] = id
      verwendet[klasse] = true
      local links, rechts = form:match("^(.-)%%s(.-)$")
      table.insert(knoten_liste, string.format('  %s%s"%s"%s:::%s', id, links, mermaid_text(text), rechts, klasse))
    end
    return knoten[schluessel]
  end
  local function grob_knoten(bb)
    return knoten_von(bb, M.fundstelle_text(index[bb].source_reference[1]), "[%s]", "baustein")
  end
  local function ziel_knoten(r)
    if r.target_kind == "noch_kein_baustein" then
      return knoten_von("anker:" .. r.target, (wert(r.title) or r.target) .. " (noch kein Baustein)", "[%s]", "nochkein")
    elseif r.target_kind == "vorlagentext" or r.target_kind == "statustext" then
      return knoten_von("anker:" .. r.target, (wert(r.title) or r.target) .. " (" .. M.ZIEL_HINWEIS[r.target_kind] .. ")",
        "[%s]", "vorlage")
    elseif r.target_kind == "standard" then
      return knoten_von("standard:" .. r.target, r.target .. " (anderer Standard)", "([%s])", "standard")
    elseif r.target_kind == "literatur" then
      return knoten_von("literatur:" .. r.target, "[" .. r.target .. "] (Literatur)", "[/%s/]", "literatur")
    end
    abbruch("Beziehungen: unbekannte Zielart «" .. tostring(r.target_kind) .. "»")
  end

  for _, e in ipairs(registry.bausteine) do
    for _, r in ipairs(e.relationships) do
      local a = ART[r.type]
      if a and a.vorwaerts then
        local ziele = r.target_kind == "baustein" and grobe(index[r.target]) or { false }
        for _, q in ipairs(grobe(e)) do
          for _, z in ipairs(ziele) do
            if z ~= q and not M.nur_tabelle(index[q]) then
              local von = grob_knoten(q)
              local nach = z and grob_knoten(z) or ziel_knoten(r)
              local schluessel = von .. ">" .. nach .. ">" .. r.type
              if not kanten[schluessel] then
                kanten[schluessel] = { von = von, nach = nach, typ = r.type, anzahl = 0 }
                table.insert(kanten_liste, kanten[schluessel])
              end
              kanten[schluessel].anzahl = kanten[schluessel].anzahl + 1
            end
          end
        end
      end
    end
  end

  -- Gegenläufige Kanten gleicher Art und Anzahl als ein Doppelpfeil, sonst
  -- verdecken sie sich im Bild.
  local zeilen = { "flowchart LR" }
  for _, z in ipairs(knoten_liste) do table.insert(zeilen, z) end
  for _, k in ipairs(kanten_liste) do
    local gegen = kanten[k.nach .. ">" .. k.von .. ">" .. k.typ]
    local doppelt = gegen and gegen.anzahl == k.anzahl
    if not (doppelt and gegen.gezeichnet) then
      local pfeil = k.typ == "depends_on" and "-.->" or "-->"
      verwendet[k.typ] = true
      if doppelt then
        pfeil = "<" .. pfeil
        verwendet.doppelt = true
      end
      local beschriftung = ""
      if k.anzahl > 1 then
        beschriftung = "|" .. k.anzahl .. "|"
        verwendet.anzahl = true
      end
      table.insert(zeilen, string.format("  %s %s%s %s", k.von, pfeil, beschriftung, k.nach))
      k.gezeichnet = true
    end
  end
  table.insert(zeilen, "  classDef baustein stroke-width: 1px")
  table.insert(zeilen, "  classDef nochkein stroke-dasharray: 5 4")
  table.insert(zeilen, "  classDef vorlage stroke-dasharray: 1 3")
  table.insert(zeilen, "  classDef standard stroke-width: 2px")
  table.insert(zeilen, "  classDef literatur stroke-width: 1px")
  return table.concat(zeilen, "\n"), verwendet
end

-- Tabelle aller Beziehungen in Vorwärtsrichtung (Textalternative zum Graph)
function M.tabelle(registry, index, basis, pruefsumme)
  local zeilen, n = {}, 0
  for _, e in ipairs(registry.bausteine) do
    for _, r in ipairs(e.relationships) do
      local a = ART[r.type]
      if a and a.vorwaerts then
        n = n + 1
        table.insert(zeilen, string.format(
          '<tr data-von="%s" data-typ="%s" data-nach="%s"><td data-label="Von">%s</td><td data-label="Art">%s</td><td data-label="Nach">%s</td><td data-label="Fundstelle">%s</td></tr>',
          esc(e.id), esc(r.type), esc(r.target), M.baustein_html(e, basis), esc(a.art),
          M.ziel_html(r, index, basis), esc(fundstellen_text(e))))
      end
    end
  end
  local erzeugt = registry.erzeugt or {}
  return table.concat({
    string.format('<table class="table table-sm beziehungen-tabelle" data-registry-sha1="%s">', esc(pruefsumme)),
    string.format("<caption>%d Beziehungen, erzeugt aus bausteine.json (Build %s, %s)</caption>",
      n, esc(wert(erzeugt.datum) or "?"), esc(wert(erzeugt.commit) or "?")),
    '<thead><tr><th scope="col">Von</th><th scope="col">Art</th><th scope="col">Nach</th><th scope="col">Fundstelle</th></tr></thead>',
    "<tbody>", table.concat(zeilen, "\n"), "</tbody></table>",
  }, "\n"), n
end

return M
