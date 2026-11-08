-- Registry `bausteine.json` (E09, E10, E27, E30; MVP-Spezifikation 3.3, 3.4).
--
-- Nur HTML, läuft NACH `quarto`: Die Nummern der Fundstellen und die Ziele
-- der Querverweise sind dann aufgelöst. Schreibt die Registry neben die
-- Sprachfassungen in den Ausgabeordner, z.B.
-- _site/ech-0003/v11.1.0/bausteine.json, und ändert das Dokument nicht.
--
-- Je Baustein (ZHAW-Feldnamen, wo es sie gibt):
--   id, name, standard, building_block_type, status, granularitaet
--   source_reference   Fundstellen im aktuellen Build (section, title); ein
--                      mehrfach verwendeter Baustein hat mehrere (E27)
--   herkunft           dokument, seite: eine Seite je Fundstelle (E09, F43)
--   kennzeichnung      feiner Baustein: MUSS, SOLLTE, DARF NICHT oder null
--   verbindlichkeit    Anzahl je Stufe; beim groben inkl. eingebetteter (V2)
--   relationships      is_part_of/has_part aus der Verschachtelung (E07),
--                      refers_to aus Querverweisen (W1–W3), depends_on aus
--                      `bezug` (E30), dazu die Umkehrungen is_referenced_by
--                      und is_required_by (W4). Selbstverweise und Verweise
--                      auf einen umschliessenden Baustein fehlen (W5).
--
-- Ziel eines Verweises (target_kind): baustein; noch_kein_baustein (Anker
-- einer Platzhalter-Überschrift, W2, mit `title`); vorlagentext oder
-- statustext (Anker einer Überschrift mit erzeugtem Inhalt aus der
-- Vorlage-Fassung, nie ein Baustein, ADR 0005, E50, mit `title`); literatur
-- (Eintrag in Anhang A) oder standard (W3, mit `title` und `url` wie im
-- Text). Ein Verweis auf eine andere Überschrift ohne Baustein bricht ab: Ihre
-- Art ist erst zu entscheiden. Links auf Seiten ausserhalb des Standards sind
-- keine Querverweise.
--
-- Darstellung (E47, AP21; filters/ech_beziehungen.lua): Auf der Standardseite
-- erhält jeder Baustein mit Querverweis oder Rückbezug ein «Beziehungen (n)»
-- in seinen Bedienelementen. Die Übersichtsseite (Metadatum `beziehungen-aus`)
-- liest bausteine.json und setzt Graph und Tabelle ein. Beide verwenden die
-- geschriebene Registry, keine zweite Ableitung. Die Übersicht braucht deshalb
-- die Registry aus demselben Lauf: In der render-Liste steht die Standardseite
-- vor ihr (prüft tools/pruefe.py); fehlt die Datei, bricht der Build ab.

local common = dofile(quarto.utils.resolve_path("ech_common.lua"))
local beziehungen = dofile(quarto.utils.resolve_path("ech_beziehungen.lua"))
local stringify = pandoc.utils.stringify

-- JSON mit fester Reihenfolge der Schlüssel ----------------------------------

local OBJEKT, LISTE, NULL = {}, {}, setmetatable({}, { __name = "null" })

local function obj(paare) return setmetatable({ paare = paare }, OBJEKT) end
local function liste(werte) return setmetatable({ werte = werte }, LISTE) end

local ERSATZ = { ['"'] = '\\"', ['\\'] = '\\\\', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t' }

local function json_text(s)
  return '"' .. s:gsub('[\0-\31"\\]', function(c)
    return ERSATZ[c] or string.format("\\u%04x", c:byte())
  end) .. '"'
end

local function kodiere(wert, einzug)
  local naechster = einzug .. "  "
  if wert == NULL or wert == nil then return "null" end
  local typ = type(wert)
  if typ == "boolean" then return tostring(wert) end
  if typ == "number" then return math.type(wert) == "integer" and string.format("%d", wert) or tostring(wert) end
  if typ == "string" then return json_text(wert) end
  local mt = getmetatable(wert)
  if mt == LISTE then
    if #wert.werte == 0 then return "[]" end
    local teile = {}
    for _, v in ipairs(wert.werte) do table.insert(teile, naechster .. kodiere(v, naechster)) end
    return "[\n" .. table.concat(teile, ",\n") .. "\n" .. einzug .. "]"
  end
  if mt == OBJEKT then
    local teile = {}
    for _, paar in ipairs(wert.paare) do
      if paar[2] ~= nil then
        table.insert(teile, naechster .. json_text(paar[1]) .. ": " .. kodiere(paar[2], naechster))
      end
    end
    return "{\n" .. table.concat(teile, ",\n") .. "\n" .. einzug .. "}"
  end
  common.abbruch("Registry: Wert ohne JSON-Darstellung: " .. tostring(wert))
end

-- Hilfen ------------------------------------------------------------------

-- Fundstelle einer Überschrift: Nummer und Titel; Anhänge «Anhang F – Titel».
local function fundstelle(h)
  local titel = common.titel_ohne_nummer(h)
  local nummer = h.attributes["number"]
  if not nummer then
    local buchstabe, rest = titel:match("^Anhang ([A-Z]) – (.+)$")
    if buchstabe then nummer, titel = "Anhang " .. buchstabe, rest end
  end
  return { section = nummer, title = titel, anker = h.identifier }
end

local function seiten(attr)
  local liste_ = {}
  for s in (attr or ""):gmatch("[0-9]+") do table.insert(liste_, tonumber(s)) end
  return liste_
end

local function ausgabe_pfad()
  local projekt, eingabe = quarto.project.directory, quarto.doc.input_file
  local ausgabe = quarto.project.output_directory or pandoc.path.join({ projekt, "_site" })
  local rel = pandoc.path.make_relative(eingabe, projekt)
  local version = pandoc.path.directory(pandoc.path.directory(rel))   -- ohne Sprachordner
  return pandoc.path.join({ ausgabe, version }), pandoc.path.join({ ausgabe, version, "bausteine.json" })
end

-- Darstellung ---------------------------------------------------------------

-- «Beziehungen (n)» in die Bedienelemente der Bausteine (ech_feedback.lua):
-- grob in die Zeile unter der Überschrift, fein ans Ende des Bausteins.
local function setze_listen(blocks, registry)
  local index = beziehungen.index(registry)
  local function details(id)
    return index[id] and beziehungen.details_html(index[id], index, "")
  end
  local function bearbeite(liste)
    local neu = pandoc.Blocks({})
    for _, b in ipairs(liste) do
      if b.t == "RawBlock" and b.format == "html" and b.text:find("baustein-bedienung baustein-grob", 1, true) then
        local d = details(b.text:match('data%-feedback%-bb="([^"]+)"') or "")
        if d then b.text = b.text:gsub("</div>$", function() return d .. "</div>" end) end
        neu:insert(b)
      elseif b.t == "Div" and b.attributes["bb"] then
        b.content = bearbeite(b.content)
        local d = details(b.attributes["bb"])
        if d then
          local block = pandoc.RawBlock("html", '<div class="baustein-bedienung baustein-beziehungen-fein">' .. d .. "</div>")
          local letzter = b.content[#b.content]
          if letzter and letzter.t == "RawBlock" and letzter.text:find("baustein-auch", 1, true) then
            b.content:insert(#b.content, block)
          else
            b.content:insert(block)
          end
        end
        neu:insert(b)
      elseif b.t == "Div" then
        b.content = bearbeite(b.content)
        neu:insert(b)
      else
        neu:insert(b)
      end
    end
    return neu
  end
  return bearbeite(blocks)
end

-- Löst «.» und «..» rein textlich auf. Linux verlangt sonst, dass jeder Ordner
-- im Pfad schon existiert; `_site/<version>/de/` legt Quarto aber erst am Ende
-- von `quarto render` an. Windows löst «..» selbst auf, deshalb lief es dort
-- (CI-Fehler bei e90d169).
local function ohne_punkte(pfad)
  local teile = {}
  for teil in pfad:gmatch("[^/\\]+") do
    if teil == ".." then
      if #teile == 0 then common.abbruch("Beziehungen: Pfad zeigt aus der Ausgabe hinaus: " .. pfad) end
      table.remove(teile)
    elseif teil ~= "." then
      table.insert(teile, teil)
    end
  end
  if #teile == 0 then common.abbruch("Beziehungen: leerer Pfad: " .. pfad) end
  return pandoc.path.join(teile)
end

-- Übersichtsseite: Graph in den Mermaid-Block, Tabelle in #beziehungen-tabelle
local function uebersicht(doc)
  local quelle = stringify(doc.meta["beziehungen-aus"])
  local projekt = quarto.project.directory
  local ausgabe = quarto.project.output_directory or pandoc.path.join({ projekt, "_site" })
  local seite = pandoc.path.directory(pandoc.path.make_relative(quarto.doc.input_file, projekt))
  local pfad = pandoc.path.join({ ausgabe, ohne_punkte(pandoc.path.join({ seite, quelle })) })
  local datei = io.open(pfad, "rb")
  if not datei then
    common.abbruch("Beziehungen: " .. pfad .. " fehlt. Die Standardseite muss in derselben `quarto render` "
      .. "vor dieser Seite stehen (render-Liste in _quarto.yml).")
  end
  local text = datei:read("a")
  datei:close()
  local registry = pandoc.json.decode(text, false)
  local index = beziehungen.index(registry)
  local graph, verwendet = beziehungen.graph(registry, index)
  local tabelle = beziehungen.tabelle(registry, index, "index.html", pandoc.utils.sha1(text))
  local graph_ok, tabelle_ok, legende_ok = false, false, false
  doc.blocks = doc.blocks:walk({
    RawBlock = function(b)
      if b.format == "html" and b.text:find('<pre class="mermaid mermaid-js"', 1, true) then
        local neu, n = b.text:gsub('(<pre class="mermaid mermaid%-js"[^>]*>).-(</pre>)', function(auf, zu)
          return auf .. beziehungen.esc(graph) .. zu
        end)
        if n == 1 then
          graph_ok = true
          b.text = neu
          return b
        end
      end
    end,
    Div = function(d)
      if d.identifier == "beziehungen-tabelle" then
        d.content = pandoc.Blocks({ pandoc.RawBlock("html", tabelle) })
        tabelle_ok = true
        return d
      elseif d.identifier == "beziehungen-legende" then
        d.content = pandoc.Blocks({ pandoc.RawBlock("html", beziehungen.legende_html(verwendet)) })
        legende_ok = true
        return d
      end
    end,
  })
  if not graph_ok then common.abbruch("Beziehungen: Mermaid-Block für den Graph nicht gefunden") end
  if not tabelle_ok then common.abbruch("Beziehungen: Div #beziehungen-tabelle nicht gefunden") end
  if not legende_ok then common.abbruch("Beziehungen: Div #beziehungen-legende nicht gefunden") end
  return doc
end

-- Dokument ------------------------------------------------------------------

function Pandoc(doc)
  if not quarto.doc.is_format("html") then return nil end
  if doc.meta["beziehungen-aus"] then return uebersicht(doc) end
  if not common.standardseite(doc.meta) then return nil end
  local meta = doc.meta
  local nummer = stringify(meta.ech.nummer)
  local standard = nummer:lower()
  local stufen = {}
  for _, k in ipairs(meta.kennzeichnungen or {}) do table.insert(stufen, stringify(k)) end
  if #stufen == 0 then common.abbruch("Registry: Metadatum `kennzeichnungen` fehlt (V4)") end
  local literatur = {}
  for _, e in ipairs(common.referenzen()) do literatur[e.schluessel] = true end

  -- Überschriften und alle IDs vorab, damit auch Verweise nach vorne passen
  local ueberschriften, bekannte = {}, {}
  doc.blocks:walk({
    Header = function(h)
      if h.identifier ~= "" then ueberschriften[h.identifier] = h end
      if h.attributes["bb"] then bekannte[h.attributes["bb"]] = true end
    end,
    Div = function(d)
      if d.attributes["bb"] then bekannte[d.attributes["bb"]] = true end
    end,
  })
  -- Überschriften mit erzeugtem Inhalt aus der Vorlage-Fassung (ADR 0005):
  -- Vorlagentext (Attribut aus ech_shortcodes.lua) oder Statustext (Span
  -- .statustext im Abschnitt darunter, 1.1)
  local vorlage_inhalt, abschnitt = {}, nil
  for _, b in ipairs(doc.blocks) do
    if b.t == "Header" then
      abschnitt = b.identifier ~= "" and b.identifier or nil
      if abschnitt and b.attributes["vorlagentext"] then vorlage_inhalt[abschnitt] = "vorlagentext" end
    elseif abschnitt then
      b:walk({ Span = function(s)
        if s.classes:includes("statustext") then vorlage_inhalt[abschnitt] = "statustext" end
      end })
    end
  end

  local eintraege, reihenfolge, vorlagentexte = {}, {}, {}

  local function eintrag(bb, element, art)
    local e = eintraege[bb]
    if not e then
      e = {
        id = bb, art = art, element = element, typ = element.attributes["typ"],
        status = element.attributes["status"] or "draft",
        seiten = seiten(element.attributes["original-seite"]),
        fundstellen = {}, teil_von = {}, verweise = {}, bezug = {},
      }
      for z in (element.attributes["bezug"] or ""):gmatch("[a-z0-9-]+") do table.insert(e.bezug, z) end
      eintraege[bb] = e
      table.insert(reihenfolge, bb)
    end
    return e
  end

  local function vorfahren(bb, menge)
    menge = menge or {}
    for _, eltern in ipairs(eintraege[bb] and eintraege[bb].teil_von or {}) do
      if not menge[eltern] then
        menge[eltern] = true
        vorfahren(eltern, menge)
      end
    end
    return menge
  end

  local function verweis(quelle, ziel, art, titel, url)
    local e = eintraege[quelle]
    if ziel == quelle or (art == "baustein" and vorfahren(quelle)[ziel]) then return end   -- W5
    for _, v in ipairs(e.verweise) do
      if v.ziel == ziel and v.art == art then return end
    end
    table.insert(e.verweise, { ziel = ziel, art = art, titel = titel, url = url })
  end

  local function sammle_verweise(block, quelle)
    block:walk({
      Span = function(s)
        local std = s.attributes["standard"]
        if std then
          local link = nil
          s:walk({ Link = function(l) link = link or l end })
          verweis(quelle, std, "standard", link and stringify(link.content), link and link.target)
        end
      end,
      Link = function(l)
        local anker = l.target:match("^#(.+)$")
        if not anker then return end   -- Seite ausserhalb des Standards
        local schluessel = anker:match("^ref%-(.+)$")
        if schluessel and literatur[schluessel] then
          verweis(quelle, schluessel, "literatur")
        elseif bekannte[anker] then
          verweis(quelle, anker, "baustein")
        elseif ueberschriften[anker] and ueberschriften[anker].attributes["bb"] then
          verweis(quelle, ueberschriften[anker].attributes["bb"], "baustein")
        elseif ueberschriften[anker] then
          local h = ueberschriften[anker]
          local f = fundstelle(h)
          local titel = (f.section and (f.section .. " ") or "") .. f.title
          local art = vorlage_inhalt[anker]
          if not art and h.classes:includes("platzhalter") then art = "noch_kein_baustein" end
          if not art then
            common.abbruch(string.format("Registry: «%s» verweist auf «%s» (%s), eine Überschrift ohne Baustein, "
              .. "Platzhalter oder Vorlagentext. Die Zielart ist erst zu entscheiden (E50).", quelle, anker, titel))
          end
          verweis(quelle, anker, art, titel)
        end
      end,
    })
  end

  local stapel = {}   -- Überschriften je Ebene
  local function innerster_grober(bis_ebene)
    for ebene = bis_ebene, 1, -1 do
      local h = stapel[ebene]
      if h and h.attributes["bb"] then return h.attributes["bb"] end
    end
    return nil
  end
  local function tiefste()
    for ebene = 6, 1, -1 do
      if stapel[ebene] then return stapel[ebene] end
    end
  end

  local function verarbeite(blocks, besitzer)
    for _, b in ipairs(blocks) do
      if b.t == "Header" then
        for ebene = b.level, 6 do stapel[ebene] = nil end
        local bb = b.attributes["bb"]
        if bb then
          local e = eintrag(bb, b, "grob")
          table.insert(e.fundstellen, fundstelle(b))
          local eltern = innerster_grober(b.level - 1)
          if eltern then table.insert(e.teil_von, eltern) end
        end
        if b.attributes["vorlagentext"] then
          local f = fundstelle(b)
          table.insert(vorlagentexte, obj({ { "name", b.attributes["vorlagentext"] },
            { "fassung", b.attributes["fassung"] }, { "section", f.section }, { "title", f.title } }))
        end
        stapel[b.level] = b
        besitzer = innerster_grober(6)
      elseif b.t == "Div" and b.attributes["bb"] then
        local bb = b.attributes["bb"]
        local e = eintrag(bb, b, "fein")
        local h = tiefste()
        if h then table.insert(e.fundstellen, fundstelle(h)) end
        if besitzer and besitzer ~= bb then
          local schon = false
          for _, t in ipairs(e.teil_von) do schon = schon or t == besitzer end
          if not schon then table.insert(e.teil_von, besitzer) end
        end
        if e.kennzeichnung == nil then
          e.kennzeichnung = false
          for _, absatz in ipairs(b.content) do
            if absatz.t == "Para" or absatz.t == "Plain" then
              local k = stringify(absatz):match("^%[([A-Z ]+)%]")
              for _, stufe in ipairs(stufen) do
                if k == stufe and not e.kennzeichnung then e.kennzeichnung = stufe end
              end
            end
          end
        end
        verarbeite(b.content, bb)
      elseif b.t == "Div" then
        verarbeite(b.content, besitzer)
      elseif b.t ~= "RawBlock" and besitzer then
        sammle_verweise(b, besitzer)
      end
    end
  end
  verarbeite(doc.blocks, nil)
  for _, bb in ipairs(reihenfolge) do
    for _, ziel in ipairs(eintraege[bb].bezug) do
      if not eintraege[ziel] then common.abbruch(string.format("Registry: bezug-Ziel «%s» von «%s» fehlt", ziel, bb)) end
    end
  end

  -- Umkehrungen (W4) und Verbindlichkeit (V2)
  local teile, referenziert, benoetigt = {}, {}, {}
  local function merke(t, schluessel, wert)
    t[schluessel] = t[schluessel] or {}
    table.insert(t[schluessel], wert)
  end
  for _, bb in ipairs(reihenfolge) do
    local e = eintraege[bb]
    for _, t in ipairs(e.teil_von) do merke(teile, t, bb) end
    for _, v in ipairs(e.verweise) do
      if v.art == "baustein" then merke(referenziert, v.ziel, bb) end
    end
    for _, z in ipairs(e.bezug) do merke(benoetigt, z, bb) end
  end
  local function zaehle(bb, zaehlung, gesehen)
    if gesehen[bb] then return end
    gesehen[bb] = true
    local e = eintraege[bb]
    if e.art == "fein" and e.kennzeichnung then zaehlung[e.kennzeichnung] = zaehlung[e.kennzeichnung] + 1 end
    for _, kind in ipairs(teile[bb] or {}) do zaehle(kind, zaehlung, gesehen) end
  end

  local original = meta.original and stringify(meta.original) or nil
  local bausteine, anzahl = {}, { grob = 0, fein = 0 }
  for _, bb in ipairs(reihenfolge) do
    local e = eintraege[bb]
    anzahl[e.art] = anzahl[e.art] + 1
    local zaehlung = {}
    for _, s in ipairs(stufen) do zaehlung[s] = 0 end
    zaehle(bb, zaehlung, {})
    local verbindlichkeit = {}
    for _, s in ipairs(stufen) do table.insert(verbindlichkeit, { s, zaehlung[s] }) end

    local fundstellen_ = {}
    for _, f in ipairs(e.fundstellen) do
      table.insert(fundstellen_, obj({ { "section", f.section or NULL }, { "title", f.title } }))
    end
    if original and #e.seiten ~= #e.fundstellen and #e.seiten ~= 1 then
      common.abbruch(string.format("Registry: «%s» hat %d Fundstellen, aber original-seite «%s»", bb, #e.fundstellen,
        e.element.attributes["original-seite"] or ""))
    end

    local beziehungen_ = {}
    local function beziehung(art, ziel, zielart, titel, url)
      table.insert(beziehungen_, obj({ { "type", art }, { "target", ziel }, { "target_kind", zielart },
        { "title", titel }, { "url", url } }))
    end
    for _, t in ipairs(e.teil_von) do beziehung("is_part_of", t, "baustein") end
    for _, t in ipairs(teile[bb] or {}) do beziehung("has_part", t, "baustein") end
    for _, v in ipairs(e.verweise) do beziehung("refers_to", v.ziel, v.art, v.titel, v.url) end
    for _, t in ipairs(referenziert[bb] or {}) do beziehung("is_referenced_by", t, "baustein") end
    for _, t in ipairs(e.bezug) do beziehung("depends_on", t, "baustein") end
    for _, t in ipairs(benoetigt[bb] or {}) do beziehung("is_required_by", t, "baustein") end

    table.insert(bausteine, obj({
      { "id", bb },
      -- grob: Überschrift der Quelle, ohne erzeugte Nummer oder «Anhang F – »
      { "name", e.art == "grob" and e.fundstellen[1].title or common.baustein_name(e.element) },
      { "standard", standard },
      { "building_block_type", e.typ or NULL },
      { "status", e.status },
      { "granularitaet", e.art },
      { "source_reference", liste(fundstellen_) },
      { "herkunft", original and obj({ { "dokument", original }, { "seite", liste(e.seiten) } }) or nil },
      { "kennzeichnung", e.art == "fein" and (e.kennzeichnung or NULL) or nil },
      { "verbindlichkeit", obj(verbindlichkeit) },
      { "relationships", liste(beziehungen_) },
    }))
  end

  local sha = os.getenv("GITHUB_SHA") or ""
  local stufen_json = {}
  for _, s in ipairs(stufen) do table.insert(stufen_json, s) end
  local registry = obj({
    { "hinweis", "Demonstrator «Beyond PDF», kein offizieller eCH-Standard. Die Regeln für Bausteine und IDs sind ein Vorschlag (E28)." },
    { "erzeugt", obj({ { "datum", os.date("%Y-%m-%d") }, { "commit", sha ~= "" and sha:sub(1, 7) or "lokal" } }) },
    { "standard", obj({
      { "id", standard },
      { "nummer", nummer },
      { "version", stringify(meta.ech.version) },
      { "sprache", meta.lang and stringify(meta.lang) or NULL },
      { "status", meta.ech.status and stringify(meta.ech.status) or NULL },
      { "vorlage", common.vorlage_fassung(meta) },
      { "vorlagentexte", liste(vorlagentexte) },
      { "original", original },
      { "kennzeichnungen", liste(stufen_json) },
    }) },
    { "anzahl", obj({ { "grob", anzahl.grob }, { "fein", anzahl.fein } }) },
    { "bausteine", liste(bausteine) },
  })

  local ordner, pfad = ausgabe_pfad()
  pandoc.system.make_directory(ordner, true)
  local json = kodiere(registry, "") .. "\n"
  local datei = assert(io.open(pfad, "wb"), "Registry: kann nicht schreiben: " .. pfad)
  datei:write(json)
  datei:close()

  -- Darstellung aus der geschriebenen Registry, nicht aus Zwischenwerten
  doc.blocks = setze_listen(doc.blocks, pandoc.json.decode(json, false))
  return doc
end
