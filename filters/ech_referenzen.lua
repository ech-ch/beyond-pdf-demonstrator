-- Zitate auf Einträge von Anhang A auflösen (E15, E11).
--
-- Die Einträge stehen in referenzen.yml im Ordner der Version, eine Ebene
-- über der Sprachfassung (ech-0003/v11.1.0/referenzen.yml für
-- ech-0003/v11.1.0/de/index.qmd). Anhang A wird nicht per CSL erzeugt (E15).
--
--   «Semantic Versioning»[@SemVer]   ->  «Semantic Versioning»[SemVer]
--   @SemVer                          ->  SemVer
--
-- Der Text ist das Anzeige-Kürzel (`kuerzel`), in eckigen Klammern wie im
-- Original; ein Kürzel mit eigenen Klammern («[ISO]») bleibt unverändert. Der
-- Link führt vorerst auf Anhang A (#sec-referenzen); die Tabelle des Anhangs
-- mit einem Anker je Eintrag folgt mit AP13.
--
-- Läuft VOR dem quarto-Filter, nach ech_anhang.lua. Querverweise (@sec-… usw.)
-- bleiben für Quarto. Ein Zitat mit unbekanntem Schlüssel bricht den Build ab
-- (K3).

local stringify = pandoc.utils.stringify

local ANHANG_A = "#sec-referenzen"
local CROSSREF = { sec = true, fig = true, tbl = true, lst = true, eq = true, thm = true,
  lem = true, cor = true, prp = true, cnj = true, def = true, exm = true, exr = true,
  sol = true, rem = true }

local function lies_referenzen()
  local input = quarto.doc.input_file
  if not input then return {} end
  local pfad = pandoc.path.join({ pandoc.path.directory(input), "..", "referenzen.yml" })
  local datei = io.open(pfad, "r")
  if datei == nil then return {} end
  local yaml = datei:read("a")
  datei:close()
  local meta = pandoc.read("---\n" .. yaml .. "\n---\n", "markdown").meta
  local eintraege = {}
  for _, e in ipairs(meta.referenzen or {}) do
    eintraege[stringify(e.schluessel)] = stringify(e.kuerzel)
  end
  return eintraege
end

function Pandoc(doc)
  local referenzen = lies_referenzen()
  doc.blocks = doc.blocks:walk({
    Cite = function(cite)
      local bekannt = 0
      for _, c in ipairs(cite.citations) do
        if referenzen[c.id] then
          bekannt = bekannt + 1
        elseif not CROSSREF[c.id:match("^(%l+)%-") or ""] then
          error("Zitat ohne Eintrag in referenzen.yml: @" .. c.id)
        end
      end
      if bekannt == 0 then return nil end
      if bekannt < #cite.citations then
        error("Zitat mischt Literatur und Querverweise: " .. stringify(cite.content))
      end
      local result = pandoc.Inlines({})
      for i, c in ipairs(cite.citations) do
        if i > 1 then result:extend({ pandoc.Str(";"), pandoc.Space() }) end
        local kuerzel = referenzen[c.id]
        if c.mode ~= "AuthorInText" and kuerzel:sub(1, 1) ~= "[" then
          kuerzel = "[" .. kuerzel .. "]"
        end
        result:insert(pandoc.Link(kuerzel, ANHANG_A))
      end
      return result
    end,
  })
  return doc
end
