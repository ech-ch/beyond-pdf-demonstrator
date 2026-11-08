-- Steckbrief eines Standards (AP24, E51; Option A in docs/ausbau.md). Modul,
-- kein Filter: verwendet von filters/ech_registry.lua für die Seite mit dem
-- Metadatum `steckbrief-aus`.
--
-- Quellen, nichts doppelt erfasst:
--   Raster       vorlage/steckbrief/<fassung>/raster.yml: Aufbau, Feldnamen,
--                Auswahllisten (Vokabular), Beschriftungen je Sprache
--   Angaben      <version>/steckbrief.yml: Raster-Fassung, Stand, Auswahlen
--                (Codes), offene und nicht zutreffende Felder, `vorschlag`
--   Texte        Kopfzeile der Sprachfassung (`steckbrief-texte`)
--   erzeugt      Standard, Status und Daten aus Ebene 0 (`ech`, Vorlage-Fassung);
--                Referenzen auf eCH-Standards und die inhaltliche Strukturierung
--                aus der Registry; Bezüge zu externen Standards aus Anhang A
--
-- Ein Code, der nicht im Raster steht, ein Feld ohne Angabe oder ein Text
-- ohne passende Auswahl bricht den Build ab. Solange `vorschlag: true` gilt,
-- trägt jeder Abschnitt mit Texten oder Auswahlen die Kennzeichnung
-- «Vorschlag, nicht geprüft».

local M = {}
local stringify = pandoc.utils.stringify

local function abbruch(text)
  assert(false, "Steckbrief: " .. text)   -- echter Abbruch (E48)
end

local function esc(s)
  return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

local function wert(x)
  if x == nil or x == pandoc.json.null then return nil end
  return x
end

local function text_von(x)
  if x == nil then return nil end
  local s = stringify(x)
  return s ~= "" and s or nil
end

local function codes(liste)
  local aus = {}
  for _, x in ipairs(liste or {}) do table.insert(aus, stringify(x)) end
  return aus
end

local function menge(liste)
  local m = {}
  for _, x in ipairs(liste) do m[x] = true end
  return m
end

-- Metadatenwert (Inlines oder Blocks) als HTML bzw. als Blöcke
local function html_von(x)
  local typ = pandoc.utils.type(x)
  local doc
  if typ == "Blocks" then
    doc = pandoc.Pandoc(x)
  elseif typ == "Inlines" then
    doc = pandoc.Pandoc({ pandoc.Plain(x) })
  else
    doc = pandoc.Pandoc({ pandoc.Plain(pandoc.Inlines(pandoc.Str(stringify(x)))) })
  end
  return (pandoc.write(doc, "html"):gsub("%s+$", ""))
end

local function bloecke_von(x)
  if pandoc.utils.type(x) == "Blocks" then return x end
  return pandoc.Blocks({ pandoc.Para(x) })
end

M.VORSCHLAG = "Vorschlag, nicht geprüft"
M.OFFEN = "offen"

-- Herkunft je Feld: Code (data-herkunft, steckbrief.json) und Beschriftung
M.HERKUNFT = {
  ebene0 = "erzeugt aus den Metadaten (Ebene 0)",
  registry = "erzeugt aus der Registry",
  ["anhang-a"] = "erzeugt aus Anhang A",
  erfasst = "erfasst",
  vorschlag = M.VORSCHLAG,
  offen = "offen",
  ["nicht-zutreffend"] = "nicht zutreffend",
}

-- Felder, die der Build erzeugt
local ERZEUGT = { standard = "ebene0", status = "ebene0", ["referenzen-ech"] = "registry",
  ["externe-standards"] = "anhang-a" }

-- Stand einer Überschrift in der inhaltlichen Strukturierung
M.STAND = {
  baustein = "Baustein",
  ["nicht-ueberfuehrt"] = "nicht überführt",
  vorlagentext = "Vorlagentext",
  statustext = "Statustext",
  daten = "Daten (Anhang A), kein Baustein",
  gliederung = "Kapitel ohne eigenen Text",
}

-- Steckbrief erzeugen. `a` enthält: meta (Seite), daten (steckbrief.yml),
-- raster (raster.yml), deckblatt (Vorlage-Fassung), registry (bausteine.json),
-- referenzen (common.referenzen()), pruefsumme (SHA-1 der Registry),
-- json ({ obj, liste, NULL } aus ech_registry.lua), basis (Standardseite).
-- Gibt Blöcke, das JSON-Objekt und den Untertitel zurück.
function M.erzeuge(a)
  local J = a.json
  local lang = a.meta.lang and stringify(a.meta.lang) or "de"
  local fassung = text_von(a.daten.raster) or abbruch("`raster` fehlt in steckbrief.yml")
  if text_von(a.raster.fassung) ~= fassung then
    abbruch("Raster-Fassung " .. fassung .. " verlangt, die Datei hat " .. tostring(text_von(a.raster.fassung)))
  end
  local de = a.raster[lang] or abbruch("Raster " .. fassung .. " hat keine Sprache " .. lang)
  local texte = a.meta["steckbrief-texte"] or abbruch("`steckbrief-texte` fehlt in der Kopfzeile der Seite")
  local vorschlag = a.daten.vorschlag
  if type(vorschlag) ~= "boolean" then abbruch("`vorschlag` in steckbrief.yml muss true oder false sein") end

  local function feldname(code)
    return text_von(de.felder[code]) or abbruch("Raster " .. fassung .. ": Feld «" .. code .. "» ohne Beschriftung")
  end

  -- Felder im Aufbau des Rasters
  local im_aufbau = {}
  for _, teil in ipairs(a.raster.aufbau) do
    for _, ab in ipairs(teil.abschnitte) do
      for _, f in ipairs(codes(ab.tabelle)) do im_aufbau[f] = "tabelle" end
      if ab.text then im_aufbau[stringify(ab.text)] = "text" end
    end
  end

  -- Auswahlen gegen das Vokabular
  local auswahl = a.daten.auswahl or abbruch("`auswahl` fehlt in steckbrief.yml")
  local vokabular = {}   -- feld -> code -> { gruppe, wert }
  for feld, gruppen in pairs(a.raster.auswahlen) do
    vokabular[feld] = {}
    for _, g in ipairs(gruppen) do
      for _, w in ipairs(g.werte) do vokabular[feld][stringify(w.code)] = { gruppe = g, wert = w } end
    end
    if auswahl[feld] == nil then abbruch("Auswahl «" .. feld .. "» fehlt in steckbrief.yml (leere Liste mit Begründung möglich)") end
  end
  local auswahl_texte = texte.auswahl or {}
  local gewaehlt = {}
  for feld, liste in pairs(auswahl) do
    if not vokabular[feld] then abbruch("«" .. feld .. "» ist im Raster " .. fassung .. " keine Auswahl") end
    gewaehlt[feld] = codes(liste)
    local frei = false
    for _, c in ipairs(gewaehlt[feld]) do
      local v = vokabular[feld][c]
      if not v then
        local erlaubt = {}
        for k in pairs(vokabular[feld]) do table.insert(erlaubt, k) end
        table.sort(erlaubt)
        abbruch(string.format("Code «%s» steht nicht im Vokabular «%s» des Rasters %s (erlaubt: %s)",
          c, feld, fassung, table.concat(erlaubt, ", ")))
      end
      frei = frei or v.wert.frei == true
    end
    local braucht_text = frei or #gewaehlt[feld] == 0
    if braucht_text and not text_von(auswahl_texte[feld]) then
      abbruch("Auswahl «" .. feld .. "»: Text für «Weitere/Andere» bzw. Begründung der leeren Auswahl fehlt")
    elseif not braucht_text and auswahl_texte[feld] then
      abbruch("Auswahl «" .. feld .. "»: Text ohne Wert mit freiem Text und ohne leere Auswahl")
    end
  end
  for feld in pairs(auswahl_texte) do
    if not vokabular[feld] then abbruch("Text zur Auswahl «" .. feld .. "», die es im Raster nicht gibt") end
  end

  local offen = menge(codes(a.daten.offen))
  local nicht_zutreffend = menge(codes(a.daten["nicht-zutreffend"]))
  local gruende = texte["nicht-zutreffend"] or {}
  for f in pairs(offen) do
    if not im_aufbau[f] then abbruch("offen: «" .. f .. "» ist kein Feld des Rasters") end
  end
  for f in pairs(nicht_zutreffend) do
    if not im_aufbau[f] then abbruch("nicht zutreffend: «" .. f .. "» ist kein Feld des Rasters") end
    if not text_von(gruende[f]) then abbruch("nicht zutreffend: Grund für «" .. f .. "» fehlt") end
  end
  for f in pairs(gruende) do
    if not nicht_zutreffend[f] then abbruch("Grund für «" .. f .. "», das nicht als nicht zutreffend markiert ist") end
  end

  -- Registry: Standard, Bausteine, Beziehungen, Gliederung
  local reg = a.registry
  local index = {}
  for _, e in ipairs(reg.bausteine) do index[e.id] = e end
  local function fundstellen(e)
    local teile = {}
    for _, f in ipairs(e.source_reference) do table.insert(teile, wert(f.section) or f.title) end
    return teile
  end

  -- Inhalte der Felder: { herkunft, html, json }
  local zeilen_json = {}
  local function vorschlag_oder(herkunft)
    if herkunft == "vorschlag" and not vorschlag then return "erfasst" end
    return herkunft
  end

  local function feld_auswahl(f)
    local liste = gewaehlt[f]
    local g_menge = menge(liste)
    local frei_text = text_von(auswahl_texte[f])
    local teile = {}
    for _, g in ipairs(a.raster.auswahlen[f]) do
      local werte = {}
      for _, w in ipairs(g.werte) do
        local c = stringify(w.code)
        local beschriftung = text_von(w[lang]) or abbruch("Raster: Wert «" .. c .. "» ohne Beschriftung")
        if g_menge[c] then
          local zusatz = (w.frei == true and frei_text) and (": " .. esc(frei_text)) or ""
          table.insert(werte, string.format('<span class="steckbrief-wert gewaehlt" data-code="%s" data-gewaehlt="ja">%s'
            .. '<span class="visually-hidden"> (ausgewählt)</span></span>%s', esc(c), esc(beschriftung), zusatz))
        else
          table.insert(werte, string.format('<span class="steckbrief-wert" data-code="%s">%s</span>', esc(c), esc(beschriftung)))
        end
      end
      local gruppe = text_von(g[lang])
      table.insert(teile, '<div class="steckbrief-gruppe">' .. (gruppe and (esc(gruppe) .. ": ") or "")
        .. table.concat(werte, " – ") .. "</div>")
    end
    if #liste == 0 then
      table.insert(teile, '<div class="steckbrief-keine">Keine Auswahl: ' .. esc(frei_text) .. "</div>")
    end
    return table.concat(teile), J.obj({ { "codes", J.liste(liste) }, { "text", frei_text } })
  end

  local function feld_standard()
    local s = reg.standard
    local titel = wert(s.titel) or abbruch("Registry ohne Titel des Standards")
    local text = string.format("%s V%s «%s»", s.nummer, s.version, titel)
    return string.format('<a href="%s">%s</a>', esc(a.basis), esc(text)),
      J.obj({ { "nummer", s.nummer }, { "version", s.version }, { "titel", titel } })
  end

  local function feld_status()
    local ech = a.meta.ech or abbruch("Metadaten `ech` fehlen (Ebene 0)")
    local code = text_von(ech.status) or abbruch("`ech.status` fehlt")
    local status = text_von(a.deckblatt.status and a.deckblatt.status[code])
      or abbruch("Status «" .. code .. "» fehlt in der Vorlage-Fassung")
    local b = a.deckblatt.beschriftungen
    local daten = {}
    for _, k in ipairs({ "beschluss-am", "ausgabedatum" }) do
      local d = text_von(ech[k])
      if d then table.insert(daten, esc(stringify(b[k])) .. ' <span class="text-nowrap">' .. esc(d) .. "</span>") end
    end
    local html = esc(status) .. (#daten > 0 and (" (" .. table.concat(daten, ", ") .. ")") or "")
    return html, J.obj({ { "status", code }, { "beschluss_am", text_von(ech["beschluss-am"]) },
      { "ausgabedatum", text_von(ech.ausgabedatum) } })
  end

  local function feld_referenzen_ech()
    local ziele, reihe = {}, {}
    for _, e in ipairs(reg.bausteine) do
      for _, r in ipairs(e.relationships) do
        if r.type == "refers_to" and r.target_kind == "standard" then
          if not ziele[r.target] then
            ziele[r.target] = { title = wert(r.title) or r.target, url = wert(r.url), fundstellen = {} }
            table.insert(reihe, r.target)
          end
          for _, f in ipairs(fundstellen(e)) do
            local z = ziele[r.target].fundstellen
            if z[#z] ~= f then table.insert(z, f) end
          end
        end
      end
    end
    local ja_nein = stringify(#reihe > 0 and de.ja or de.nein)
    if #reihe == 0 then return esc(ja_nein), J.obj({ { "ja", false }, { "standards", J.liste({}) } }) end
    local punkte, liste_json = {}, {}
    for _, nr in ipairs(reihe) do
      local z = ziele[nr]
      local titel = z.url and string.format('<a href="%s">%s</a>', esc(z.url), esc(z.title)) or esc(z.title)
      table.insert(punkte, string.format('<li data-standard="%s">%s (Querverweis aus %s)</li>', esc(nr), titel,
        esc(table.concat(z.fundstellen, ", "))))
      table.insert(liste_json, J.obj({ { "nummer", nr }, { "titel", z.title }, { "url", z.url },
        { "fundstellen", J.liste(z.fundstellen) } }))
    end
    return esc(ja_nein) .. ":<ul>" .. table.concat(punkte) .. "</ul>",
      J.obj({ { "ja", true }, { "standards", J.liste(liste_json) } })
  end

  local function feld_externe_standards()
    local zitiert = {}   -- Schlüssel -> Fundstellen der Zitate
    for _, e in ipairs(reg.bausteine) do
      for _, r in ipairs(e.relationships) do
        if r.type == "refers_to" and r.target_kind == "literatur" then
          zitiert[r.target] = zitiert[r.target] or {}
          for _, f in ipairs(fundstellen(e)) do table.insert(zitiert[r.target], f) end
        end
      end
    end
    local punkte, liste_json = {}, {}
    for _, r in ipairs(a.referenzen) do
      if not r.schluessel:match("^eCH%-") then
        local wo = zitiert[r.schluessel]
        local zusatz = wo and (" (zitiert in " .. esc(table.concat(wo, ", ")) .. ")") or " (nur in Anhang A aufgeführt)"
        table.insert(punkte, string.format('<li data-referenz="%s">%s %s%s</li>', esc(r.schluessel),
          html_von(r.kuerzel), html_von(r.text), zusatz))
        table.insert(liste_json, J.obj({ { "schluessel", r.schluessel }, { "text", stringify(r.text) },
          { "zitiert_in", J.liste(wo or {}) } }))
      end
    end
    local ja_nein = stringify(#punkte > 0 and de.ja or de.nein)
    if #punkte == 0 then return esc(ja_nein), J.liste({}) end
    return esc(ja_nein) .. ":<ul>" .. table.concat(punkte) .. "</ul>", J.liste(liste_json)
  end

  local function feld(f)
    local herkunft, html, js
    if offen[f] then
      herkunft, html = "offen", '<em class="steckbrief-offen">' .. esc(M.OFFEN) .. "</em>"
    elseif nicht_zutreffend[f] then
      herkunft = "nicht-zutreffend"
      html = '<em>nicht zutreffend</em>: ' .. html_von(gruende[f])
      js = stringify(gruende[f])
    elseif vokabular[f] then
      herkunft = "vorschlag"
      html, js = feld_auswahl(f)
    elseif f == "standard" then
      herkunft = ERZEUGT[f]
      html, js = feld_standard()
    elseif f == "status" then
      herkunft = ERZEUGT[f]
      html, js = feld_status()
    elseif f == "referenzen-ech" then
      herkunft = ERZEUGT[f]
      html, js = feld_referenzen_ech()
    elseif f == "externe-standards" then
      herkunft = ERZEUGT[f]
      html, js = feld_externe_standards()
    elseif f == "aktualisiert" then
      herkunft = "erfasst"
      js = text_von(a.daten.stand) or abbruch("`stand` fehlt in steckbrief.yml")
      html = esc(js)
    else
      local angabe = a.daten.angaben and a.daten.angaben[f]
      if not text_von(angabe) then
        abbruch("Feld «" .. f .. "» ohne Angabe: in steckbrief.yml unter `angaben`, `offen` oder `nicht-zutreffend` eintragen")
      end
      herkunft, html, js = "erfasst", html_von(angabe), stringify(angabe)
    end
    herkunft = vorschlag_oder(herkunft)
    return herkunft, html, js
  end

  -- Inhaltliche Strukturierung aus der Gliederung der Registry
  local function gliederung_html()
    local liste = reg.gliederung or abbruch("Registry ohne `gliederung`")
    local feine = {}
    for _, e in ipairs(reg.bausteine) do
      if e.granularitaet == "fein" then
        for _, r in ipairs(e.relationships) do
          if r.type == "is_part_of" then feine[r.target] = (feine[r.target] or 0) + 1 end
        end
      end
    end
    local ueberfuehrt = { baustein = true, vorlagentext = true, statustext = true, daten = true }
    local zeilen, js, i = {}, {}, 1
    while i <= #liste do
      local g = liste[i]
      local ende = i + 1
      while ende <= #liste and liste[ende].ebene > g.ebene do ende = ende + 1 end
      local etwas = false
      for k = i, ende - 1 do etwas = etwas or ueberfuehrt[liste[k].inhalt] == true end
      local stand, naechster = g.inhalt, i + 1
      if not etwas then
        stand, naechster = "nicht-ueberfuehrt", ende   -- ganzer Teilbaum in einer Zeile
      elseif g.inhalt == "platzhalter" then
        stand = "nicht-ueberfuehrt"
      elseif g.inhalt == "ohne_text" then
        stand = "gliederung"
      end
      if not M.STAND[stand] then abbruch("Registry: unbekannter Inhalt «" .. tostring(g.inhalt) .. "» bei " .. g.anker) end
      local nr = wert(g.section)
      local ziel = (stand == "baustein") and g.baustein or g.anker
      local name = string.format('%s<a href="%s#%s">%s</a>', nr and (esc(nr) .. " ") or "", esc(a.basis), esc(ziel), esc(g.title))
      local id = stand == "baustein" and string.format('<code class="beziehung-id">%s</code>', esc(g.baustein))
        or (stand == "gliederung" and "" or string.format('<span class="beziehung-hinweis">%s</span>', esc(M.STAND[stand])))
      local n = stand == "baustein" and tostring(feine[g.baustein] or 0) or "–"
      table.insert(zeilen, string.format(
        '<tr class="ebene-%d" data-anker="%s" data-stand="%s"%s%s><td data-label="%s">%s</td><td data-label="Baustein-ID / Stand">%s</td><td data-label="Feine Bausteine">%s</td></tr>',
        g.ebene, esc(g.anker), esc(stand),
        stand == "baustein" and string.format(' data-baustein="%s"', esc(g.baustein)) or "",
        stand == "baustein" and string.format(' data-feine="%s"', n) or "",
        esc(feldname("gliederung")), name, id, n))
      table.insert(js, J.obj({ { "section", nr }, { "title", g.title }, { "ebene", g.ebene }, { "anker", g.anker },
        { "stand", stand }, { "baustein", stand == "baustein" and g.baustein or nil },
        { "feine", stand == "baustein" and (feine[g.baustein] or 0) or nil } }))
      i = naechster
    end
    local erzeugt = reg.erzeugt or {}
    return table.concat({
      string.format('<table class="table table-sm steckbrief-gliederung" data-registry-sha1="%s">', esc(a.pruefsumme)),
      string.format("<caption>Erzeugt aus bausteine.json (Build %s, %s)</caption>",
        esc(wert(erzeugt.datum) or "?"), esc(wert(erzeugt.commit) or "?")),
      string.format('<thead><tr><th scope="col">%s</th><th scope="col">Baustein-ID / Stand</th><th scope="col">Feine Bausteine</th></tr></thead>',
        esc(feldname("gliederung"))),
      "<tbody>", table.concat(zeilen, "\n"), "</tbody></table>",
    }, "\n"), J.liste(js)
  end

  local function marke(abschnitt, was)
    return pandoc.RawBlock("html", string.format(
      '<p class="steckbrief-vorschlag" data-vorschlag="%s"><strong>%s.</strong> %s</p>',
      esc(abschnitt), esc(M.VORSCHLAG), esc(was)))
  end

  -- Seite in der Reihenfolge des Rasters
  local bloecke = pandoc.Blocks({})
  local abschnitte_json = {}
  for _, teil in ipairs(a.raster.aufbau) do
    local t = stringify(teil.teil)
    bloecke:insert(pandoc.Header(2, pandoc.Inlines(text_von(de.teile[t]) or abbruch("Teil «" .. t .. "» ohne Titel")),
      pandoc.Attr("steckbrief-" .. t)))
    for _, ab in ipairs(teil.abschnitte) do
      local name = stringify(ab.abschnitt)
      local titel = text_von(de.abschnitte and de.abschnitte[name])
      if titel then bloecke:insert(pandoc.Header(3, pandoc.Inlines(titel), pandoc.Attr("steckbrief-" .. name))) end
      local felder_json = {}
      if ab.tabelle then
        local zeilen, mit_vorschlag = {}, false
        for _, f in ipairs(codes(ab.tabelle)) do
          local herkunft, html, js = feld(f)
          mit_vorschlag = mit_vorschlag or herkunft == "vorschlag"
          table.insert(zeilen, string.format(
            '<tr data-feld="%s" data-herkunft="%s"><th scope="row" data-label="Feld">%s</th><td data-label="Angabe">%s</td><td data-label="Herkunft">%s</td></tr>',
            esc(f), esc(herkunft), esc(feldname(f)), html, esc(M.HERKUNFT[herkunft])))
          table.insert(felder_json, J.obj({ { "code", f }, { "name", feldname(f) }, { "herkunft", herkunft }, { "wert", js } }))
        end
        if mit_vorschlag then
          bloecke:insert(marke(name, "Die Auswahlen sind aus dem Text von eCH-0003 V11.1.0 abgeleitet und noch nicht durch die Projektleitung geprüft."))
        end
        bloecke:insert(pandoc.RawBlock("html", table.concat({
          string.format('<table class="table table-sm steckbrief-tabelle" data-abschnitt="%s">', esc(name)),
          '<thead><tr><th scope="col">Feld</th><th scope="col">Angabe</th><th scope="col">Herkunft</th></tr></thead>',
          "<tbody>", table.concat(zeilen, "\n"), "</tbody></table>" }, "\n")))
      elseif ab.text then
        local f = stringify(ab.text)
        local herkunft
        if offen[f] then
          herkunft = "offen"
          bloecke:insert(pandoc.RawBlock("html", '<p><em class="steckbrief-offen">' .. esc(M.OFFEN) .. "</em></p>"))
        else
          local x = texte[f] or abbruch("Text «" .. f .. "» fehlt in steckbrief-texte")
          herkunft = vorschlag_oder("vorschlag")
          if herkunft == "vorschlag" then
            bloecke:insert(marke(name, "Text aus dem publizierten Standard abgeleitet, noch nicht durch die Projektleitung geprüft."))
          end
          bloecke:extend(bloecke_von(x))
        end
        table.insert(felder_json, J.obj({ { "code", f }, { "name", text_von(de.abschnitte[name]) or f },
          { "herkunft", herkunft }, { "wert", texte[f] and stringify(texte[f]) or nil } }))
      elseif ab.gliederung then
        bloecke:insert(pandoc.Para(pandoc.Inlines("Das Raster nennt diesen Teil eine Hypothese, welche Kapitel bzw. "
          .. "Kernelemente im Sinn von «Building Blocks» geplant sind. Hier ist er aus den Bausteinen erzeugt: je grober "
          .. "Baustein eine Zeile mit Kapitel, Name, Baustein-ID und Zahl der feinen Bausteine. Teile, die noch nicht "
          .. "in Bausteine überführt sind, stehen als «nicht überführt», ein ganz unüberführter Teil in einer Zeile.")))
        local html, js = gliederung_html()
        bloecke:insert(pandoc.RawBlock("html", html))
        table.insert(felder_json, J.obj({ { "code", "gliederung" }, { "name", feldname("gliederung") },
          { "herkunft", "registry" }, { "wert", js } }))
      end
      table.insert(abschnitte_json, J.obj({ { "abschnitt", name }, { "felder", J.liste(felder_json) } }))
    end
  end

  local s = reg.standard
  local untertitel = string.format("%s V%s – %s", s.nummer, s.version, wert(s.titel) or "")
  local erzeugt = reg.erzeugt or {}
  local json = J.obj({
    { "hinweis", "Demonstrator «Beyond PDF», kein offizieller eCH-Steckbrief. Aufbau nach dem Raster «"
      .. (text_von(de.titel) or "") .. "» " .. fassung .. "; Vorschlag (E28)." },
    { "erzeugt", J.obj({ { "datum", wert(erzeugt.datum) }, { "commit", wert(erzeugt.commit) } }) },
    { "raster", J.obj({ { "titel", text_von(de.titel) }, { "fassung", fassung } }) },
    { "standard", J.obj({ { "id", s.id }, { "nummer", s.nummer }, { "version", s.version }, { "titel", wert(s.titel) },
      { "sprache", lang } }) },
    { "vorschlag", vorschlag },
    { "registry_sha1", a.pruefsumme },
    { "abschnitte", J.liste(abschnitte_json) },
  })
  return bloecke, json, untertitel
end

return M
