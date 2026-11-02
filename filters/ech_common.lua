-- Gemeinsame Logik von Deckblatt, Statustext und Platzhalter.
--
-- Herkunft: FOAG-Template blw-ofag-ufag/semantic-web-template,
-- docs/assets/ech_common.lua (CC BY 4.0, Stand Commit 659b85f).
-- Angepasst für den Demonstrator (README, «Abweichungen vom FOAG-Template»):
-- Statt ech_vocabulary.yml liest das Modul die Vorlage-Fassung des Standards
-- (Metadatum `vorlage`, Dateien vorlage/<fassung>/deckblatt.yml und
-- statustexte.yml, ADR 0005). Die Metadaten unter `ech` tragen Codes
-- (ech-0003/v11.1.0/_metadata.yml). Sprachabhängige Werte (`title`,
-- `abstract`, `beilagen`, `autoren`) stehen in der Kopfzeile der Sprachfassung.

local M = {}

local stringify = pandoc.utils.stringify

-- Wandelt einen Metadatenwert (String, Zahl, Inlines, Blocks) in Inlines.
local function to_inlines(value)
  local kind = pandoc.utils.type(value)
  if kind == "Inlines" then
    return value
  elseif kind == "Blocks" then
    return pandoc.utils.blocks_to_inlines(value)
  elseif kind == "string" or kind == "number" then
    return pandoc.Inlines(pandoc.Str(tostring(value)))
  elseif kind == "List" and #value == 1 then
    return to_inlines(value[1])
  end
  error("eCH-Metadaten: Wert vom Typ " .. kind .. " nicht darstellbar")
end
M.to_inlines = to_inlines

-- Wandelt einen Metadatenwert in eine Liste von Inlines (ein Eintrag je Wert).
local function to_list(value)
  if value == nil then return {} end
  if pandoc.utils.type(value) == "List" then
    local result = {}
    for _, item in ipairs(value) do table.insert(result, to_inlines(item)) end
    return result
  end
  return { to_inlines(value) }
end

local function concat(...)
  local result = pandoc.Inlines({})
  for _, part in ipairs({ ... }) do
    if type(part) == "string" then
      result:extend(pandoc.Inlines(pandoc.Str(part)))
    else
      result:extend(part)
    end
  end
  return result
end

-- Schlägt `code` in der Tabelle `group` der Vorlage-Fassung nach; unbekannte
-- Codes brechen den Build ab.
local function lookup(vocabulary, group, code)
  local entry = vocabulary[group] and vocabulary[group][code]
  if entry == nil then
    local allowed = {}
    for key, _ in pairs(vocabulary[group] or {}) do table.insert(allowed, key) end
    table.sort(allowed)
    error(string.format("eCH-Metadaten: unbekannter Code %s '%s' (erlaubt: %s)",
      group, code, table.concat(allowed, ", ")))
  end
  return to_inlines(entry)
end

local yaml_cache = {}

local function read_yaml(path)
  if yaml_cache[path] == nil then
    local file = io.open(path, "r")
    if file == nil then error("eCH: Datei nicht gefunden: " .. path) end
    local yaml = file:read("a")
    file:close()
    yaml_cache[path] = pandoc.read("---\n" .. yaml .. "\n---\n", "markdown").meta
  end
  return yaml_cache[path]
end

-- Liest einen Teil der Vorlage-Fassung des Dokuments (z.B. "deckblatt") in
-- der Sprache des Dokuments. Gibt den Teil und den Namen der Fassung zurück.
function M.vorlage(meta, teil)
  local fassung = meta.vorlage and stringify(meta.vorlage) or ""
  if fassung == "" then
    error("eCH-Metadaten: `vorlage` (Vorlage-Fassung) fehlt, siehe ADR 0005")
  end
  local lang = meta.lang and stringify(meta.lang) or "de"
  local path = quarto.utils.resolve_path("../vorlage/" .. fassung .. "/" .. teil .. ".yml")
  local entry = read_yaml(path)[lang]
  if entry == nil then
    error(string.format("eCH: Vorlage-Fassung %s hat keine Sprache '%s' in %s.yml", fassung, lang, teil))
  end
  return entry, fassung
end

-- Gibt die Zeilen des Deckblatts zurück, oder nil ohne `ech`-Metadaten.
--
--   rows      geordnete Liste von { key, label, values, bullets }
--   summary   Beschriftung der Zusammenfassung
--   number    Inlines der eCH-Nummer
--
-- `options.include_name` legt fest, ob die Zeile «Name» dazugehört.
function M.display(meta, options)
  options = options or {}
  local ech = meta.ech
  if ech == nil then return nil end
  local voc = M.vorlage(meta, "deckblatt")

  local function code(value) return value and stringify(value) or nil end
  local values = {}

  values["name"] = meta.title and { to_inlines(meta.title) }
  values["nummer"] = ech.nummer and { to_inlines(ech.nummer) }
  for _, key in ipairs({ "kategorie", "reifegrad", "status" }) do
    values[key] = ech[key] and { lookup(voc, key, code(ech[key])) }
  end
  values["version"] = ech.version and { to_inlines(ech.version) }
  values["beschluss-am"] = ech["beschluss-am"] and { to_inlines(ech["beschluss-am"]) }
  values["ausgabedatum"] = ech.ausgabedatum and { to_inlines(ech.ausgabedatum) }

  local ersetzt = ech.ersetzt
  if ersetzt ~= nil and ersetzt.version ~= nil then
    local text = to_inlines(ersetzt.version)
    if ersetzt.aenderung then
      text = concat(text, " – ", lookup(voc, "aenderung", code(ersetzt.aenderung)))
    end
    values["ersetzt"] = { text }
  end

  values["voraussetzungen"] = to_list(ech.voraussetzungen)
  values["beilagen"] = to_list(meta.beilagen)   -- sprachabhängig, Kopfzeile der Sprachfassung
  values["autoren"] = to_list(meta.autoren)
  values["herausgeber"] = to_list(voc.herausgeber)

  local sprachen = ech.sprachen
  if sprachen ~= nil then
    -- Quarto schreibt Metadaten-Strings um, die einem vorhandenen Pfad
    -- entsprechen («de» -> «../de»): nur der letzte Pfadteil zählt.
    local function language_code(value) return stringify(value):match("([^/]+)$") end
    local parts = {}
    if sprachen.original then
      table.insert(parts, concat(lookup(voc, "sprache", language_code(sprachen.original)),
        " (", to_inlines(voc.original), ")"))
    end
    for _, item in ipairs(sprachen.uebersetzungen or {}) do
      table.insert(parts, concat(lookup(voc, "sprache", language_code(item)),
        " (", to_inlines(voc.uebersetzung), ")"))
    end
    local text = pandoc.Inlines({})
    for i, part in ipairs(parts) do
      if i > 1 then text:extend(pandoc.Inlines(pandoc.Str(", "))) end
      text:extend(part)
    end
    values["sprachen"] = { text }
  end

  local rows = {}
  for _, item in ipairs(voc.reihenfolge) do
    local key = stringify(item)
    if key ~= "name" or options.include_name ~= false then
      local list = values[key]
      if list == nil or #list == 0 then list = { to_inlines(voc.leer) } end
      table.insert(rows, {
        key = key,
        label = lookup(voc, "beschriftungen", key),
        -- explizite MetaList: pandoc machte aus einer leeren Lua-Tabelle `true`
        values = pandoc.MetaList(list),
        bullets = false,
      })
    end
  end

  return {
    rows = rows,
    number = ech.nummer and to_inlines(ech.nummer) or nil,
    summary = lookup(voc, "beschriftungen", "zusammenfassung"),
  }
end

-- Statustext für 1.1 «Status» aus Status und Vorlage-Fassung (E14). Ein
-- Status ohne Statustext in der Fassung bricht den Build ab.
function M.statustext(meta)
  local ech = meta.ech
  if ech == nil or ech.status == nil then
    error("eCH-Metadaten: `ech.status` fehlt")
  end
  local texte, fassung = M.vorlage(meta, "statustexte")
  local status = stringify(ech.status)
  if texte[status] == nil then
    error(string.format("eCH: Die Vorlage-Fassung %s hat keinen Statustext für den Status '%s'",
      fassung, status))
  end
  return to_inlines(texte[status])
end

return M
