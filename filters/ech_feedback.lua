-- Feedback je Baustein auf der Website (E21, E37, E39, MVP-Spezifikation 6).
--
-- Ausgangspunkt: Spike S4 (docs/spikes/s4-luafilter/filters/feedback.lua),
-- umgestellt von `.baustein` auf das Attribut `bb`.
--
-- Nur HTML, läuft NACH `quarto` und nach ech_anker.lua: Die Verweise im Text
-- sind dann aufgelöst, und die Anker stehen. Ohne JavaScript; die Darstellung
-- steht in assets/ech.scss, alles liegt in Elementen .baustein-bedienung, die
-- tools/pruefe.py vom Textvergleich ausnimmt.
--
--   grober Baustein     nach der Überschrift: Knopf «Feedback», Baustein-ID,
--                       «Alle Rückmeldungen»
--   feiner Baustein     am Anfang des Blocks: Symbol am Rand, ID und «Alle
--                       Rückmeldungen» beim Darüberfahren oder mit Tastatur
--   Mehrfachbaustein    an jeder Fundstelle dasselbe Symbol, dazu am Ende des
--                       Blocks «erscheint auch in 7.9» (E27)
--   Standard als Ganzes Knopf «Feedback zum Standard» beim Deckblatt, ohne
--                       Baustein-ID (Label bb:gesamt)
--   Überschrift mit     wie grober Baustein, für Inhalte ohne Baustein-ID:
--   feedback-id="…"     Anhang A mit `ech-0003-referenzen` (AP13, bb:referenzen)
--
-- Platzhalter, Vorlagentexte und das Word erhalten nichts. Labels stehen nie
-- in der URL (ohne Berechtigung führt das zu einer 404-Seite, E37); die Action
-- .github/workflows/feedback-label.yml setzt sie aus den Formularfeldern.
--
-- Nur explizite ASCII-Klassen: Unter Windows zählen %w und %s auch einzelne
-- Bytes von UTF-8-Zeichen, z.B. das zweite Byte von «à» als Leerraum (S4).

local common = dofile(quarto.utils.resolve_path("ech_common.lua"))
local stringify = pandoc.utils.stringify
local block_text, titel_ohne_nummer = common.block_text, common.titel_ohne_nummer

local WORTLAUT_MAX = 2000   -- Zeichen (E37)
local LEER = "[ \t\r\n]"

local function urlencode(s)
  return (s:gsub("[^A-Za-z0-9%-%._~]", function(c)
    return string.format("%%%02X", string.byte(c))
  end))
end

local function esc(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

-- Klartext ------------------------------------------------------------------

-- Wortlaut für das Formular; über WORTLAUT_MAX Zeichen an einer Wortgrenze
-- gekürzt. pandoc.text zählt Zeichen, nicht Bytes.
local function wortlaut(text)
  if pandoc.text.len(text) <= WORTLAUT_MAX then return text end
  local kurz = pandoc.text.sub(text, 1, WORTLAUT_MAX)
  return (kurz:gsub(LEER .. "+[^ \t\r\n]*$", "")) .. " …"
end

-- Kontext des Dokuments -----------------------------------------------------

local function seiten_pfad()
  local projekt, eingabe = quarto.project.directory, quarto.doc.input_file
  local pfad = pandoc.path.make_relative(eingabe, projekt):gsub("\\", "/")
  return (pfad:gsub("%.qmd$", ".html"))
end

local function kontext(meta)
  local function pflicht(wert, name)
    local text = wert and stringify(wert) or ""
    if text == "" then error("Feedback: Metadatum `" .. name .. "` fehlt") end
    return text
  end
  local nummer = pflicht(meta.ech.nummer, "ech.nummer")
  local sha = os.getenv("GITHUB_SHA") or ""
  local commit = sha ~= "" and sha:sub(1, 7) or "lokal"
  local version = pflicht(meta.ech.version, "ech.version")
  local basis = pflicht(meta["demonstrator-url"], "demonstrator-url"):gsub("/*$", "/")
  return {
    repo = pflicht(meta["demonstrator-repo"], "demonstrator-repo"):gsub("/*$", ""),
    standard = nummer:lower(),                       -- Standard-ID, z.B. ech-0003 (E38)
    bezeichnung = nummer .. " V" .. version,
    stand = string.format("%s V%s, Build %s (%s)", nummer, version, os.date("%Y-%m-%d"), commit),
    seite = basis .. seiten_pfad(),
  }
end

local function formular_url(k, felder)
  local teile = { "template=feedback.yml" }
  for _, feld in ipairs(felder) do
    if feld[2] and feld[2] ~= "" then
      table.insert(teile, feld[1] .. "=" .. urlencode(feld[2]))
    end
  end
  return k.repo .. "/issues/new?" .. table.concat(teile, "&")
end

local function alle_url(k, kurzname)
  local q = string.format('is:issue label:"standard:%s"', k.standard)
  if kurzname then q = q .. string.format(' label:"bb:%s"', kurzname) end
  return k.repo .. "/issues?q=" .. urlencode(q)
end

-- Bedienelemente ------------------------------------------------------------

local SYMBOL = '<i class="bi bi-chat-left-text" aria-hidden="true"></i>'

local function feedback_a(url, klassen, daten, label, inhalt)
  return string.format('<a class="baustein-feedback %s" %s href="%s" target="_blank" rel="noopener" aria-label="%s">%s</a>',
    klassen, daten, esc(url), esc(label), inhalt)
end

local function info_span(k, id, anker, kurzname)
  return string.format('<span class="baustein-info"><a class="baustein-id" href="#%s">%s</a> · <a class="baustein-alle" href="%s" target="_blank" rel="noopener">Alle Rückmeldungen</a></span>',
    esc(anker), esc(id), esc(alle_url(k, kurzname)))
end

-- Knopf auf der Zeile der Überschrift: grober Baustein, Anhang A
local function bedienung_ueberschrift(k, id, anker, kurzname, name)
  local url = formular_url(k, {
    { "title", string.format("Feedback zu %s (%s)", name, id) },
    { "standard", k.standard }, { "baustein", id }, { "stand", k.stand },
    { "stelle", k.seite .. "#" .. anker },
  })
  local knopf = feedback_a(url, "baustein-knopf", string.format('data-feedback-bb="%s"', esc(id)),
    string.format("Feedback zu %s (%s) geben", name, id),
    SYMBOL .. ' <span class="baustein-knopf-text">Feedback</span>')
  return pandoc.RawBlock("html", string.format(
    '<div class="baustein-bedienung baustein-grob" role="group" aria-label="%s">%s%s</div>',
    esc("Baustein " .. id), knopf, info_span(k, id, anker, kurzname)))
end

-- Symbol am Rand: feiner Baustein
local function bedienung_fein(k, id, kurzname, name, text)
  local url = formular_url(k, {
    { "title", string.format("Feedback zu %s (%s)", name, id) },
    { "standard", k.standard }, { "baustein", id }, { "stand", k.stand },
    { "stelle", k.seite .. "#" .. id }, { "wortlaut", wortlaut(text) },
  })
  local symbol = feedback_a(url, "baustein-symbol", string.format('data-feedback-bb="%s"', esc(id)),
    string.format("Feedback zu %s (%s) geben", name, id), SYMBOL)
  return pandoc.RawBlock("html", string.format(
    '<div class="baustein-bedienung baustein-fein" role="group" aria-label="%s">%s%s</div>',
    esc("Baustein " .. id), symbol, info_span(k, id, id, kurzname)))
end

local function bedienung_standard(k)
  local url = formular_url(k, {
    { "title", "Feedback zum Standard " .. k.bezeichnung },
    { "standard", k.standard }, { "stand", k.stand }, { "stelle", k.seite },
  })
  local knopf = feedback_a(url, "baustein-knopf", string.format('data-feedback-standard="%s"', esc(k.standard)),
    "Feedback zum Standard " .. k.bezeichnung .. " geben",
    SYMBOL .. ' <span class="baustein-knopf-text">Feedback zum Standard</span>')
  return pandoc.RawBlock("html", string.format(
    '<div class="baustein-bedienung baustein-standard" role="group" aria-label="%s">%s<a class="baustein-alle" href="%s" target="_blank" rel="noopener">Alle Rückmeldungen</a></div>',
    esc("Standard " .. k.bezeichnung), knopf, esc(alle_url(k, nil))))
end

-- Fundstellen ---------------------------------------------------------------

-- Merkt sich je Baustein die Überschriften, unter denen er steht (E27).
local function sammle_fundstellen(blocks, stelle, fundstellen)
  for _, b in ipairs(blocks) do
    if b.t == "Header" then
      stelle = { nummer = b.attributes["number"], anker = b.identifier, titel = titel_ohne_nummer(b) }
    elseif b.t == "Div" then
      local bb = b.attributes["bb"]
      if bb then
        fundstellen[bb] = fundstellen[bb] or {}
        table.insert(fundstellen[bb], stelle)
      end
      stelle = sammle_fundstellen(b.content, stelle, fundstellen)
    end
  end
  return stelle
end

local function hinweis_auch(fundstellen, hier)
  local links = {}
  for _, s in ipairs(fundstellen) do
    if not hier or s.anker ~= hier.anker then
      table.insert(links, string.format('<a href="#%s">%s</a>', esc(s.anker), esc(s.nummer or s.titel)))
    end
  end
  if #links == 0 then return nil end
  return pandoc.RawBlock("html", '<p class="baustein-bedienung baustein-auch">erscheint auch in ' .. table.concat(links, ", ") .. "</p>")
end

-- Dokument ------------------------------------------------------------------

function Pandoc(doc)
  if not quarto.doc.is_format("html") then
    -- Pandoc schriebe es sonst als Dokumenteigenschaft ins Word.
    doc.meta["demonstrator-repo"] = nil
    return doc
  end
  if not common.standardseite(doc.meta) then return nil end
  local k = kontext(doc.meta)
  local praefix = k.standard .. "-bb-"

  local function kurzname(bb)
    if bb:sub(1, #praefix) ~= praefix then
      error(string.format("Feedback: ID «%s» beginnt nicht mit «%s»", bb, praefix))
    end
    return bb:sub(#praefix + 1)
  end

  local fundstellen = {}
  sammle_fundstellen(doc.blocks, nil, fundstellen)

  local function bearbeite(blocks, stelle)
    local ergebnis = pandoc.Blocks({})
    for _, b in ipairs(blocks) do
      if b.t == "Header" then
        stelle = { nummer = b.attributes["number"], anker = b.identifier, titel = titel_ohne_nummer(b) }
        ergebnis:insert(b)
        local bb, fid = b.attributes["bb"], b.attributes["feedback-id"]
        if bb then
          ergebnis:insert(bedienung_ueberschrift(k, bb, bb, kurzname(bb), titel_ohne_nummer(b)))
        elseif fid and not b.classes:includes("platzhalter") then
          ergebnis:insert(bedienung_ueberschrift(k, fid, b.identifier, fid:sub(#k.standard + 2), titel_ohne_nummer(b)))
        end
      elseif b.t == "Div" and b.attributes["bb"] then
        local bb = b.attributes["bb"]
        local text = block_text(b)
        local name = common.baustein_name(b)
        local inhalt = pandoc.Blocks({ bedienung_fein(k, bb, kurzname(bb), name, text) })
        inhalt:extend(bearbeite(b.content, stelle))
        local auch = hinweis_auch(fundstellen[bb], stelle)
        if auch then inhalt:insert(auch) end
        b.content = inhalt
        ergebnis:insert(b)
      elseif b.t == "Div" then
        b.content = bearbeite(b.content, stelle)
        ergebnis:insert(b)
      else
        ergebnis:insert(b)
      end
    end
    return ergebnis
  end

  local blocks = pandoc.Blocks({ bedienung_standard(k) })
  blocks:extend(bearbeite(doc.blocks, nil))
  doc.blocks = blocks
  return doc
end
