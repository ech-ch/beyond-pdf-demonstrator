-- Zitate auf Einträge von Anhang A auflösen (E15, E11).
--
-- Die Einträge stehen in referenzen.yml im Ordner der Version, eine Ebene
-- über der Sprachfassung (ech-0003/v11.1.0/referenzen.yml für
-- ech-0003/v11.1.0/de/index.qmd). Anhang A wird nicht per CSL erzeugt (E15);
-- die Tabelle setzt der Shortcode {{< referenzen >}} (ech_shortcodes.lua).
--
--   «Semantic Versioning»[@SemVer]   ->  «Semantic Versioning»[SemVer]
--   @SemVer                          ->  SemVer
--
-- Der Text ist das Anzeige-Kürzel (`kuerzel`), in eckigen Klammern wie im
-- Original; ein Kürzel mit eigenen Klammern («[ISO]») bleibt unverändert. Der
-- Link führt auf den Eintrag in Anhang A (#ref-<schlüssel>).
--
-- Läuft VOR dem quarto-Filter, nach ech_anhang.lua. Querverweise (@sec-… usw.)
-- bleiben für Quarto. Ein Zitat mit unbekanntem Schlüssel bricht den Build ab
-- (K3).

local common = dofile(quarto.utils.resolve_path("ech_common.lua"))
local stringify = pandoc.utils.stringify

local CROSSREF = { sec = true, fig = true, tbl = true, lst = true, eq = true, thm = true,
  lem = true, cor = true, prp = true, cnj = true, def = true, exm = true, exr = true,
  sol = true, rem = true }

function Pandoc(doc)
  local referenzen = {}
  for _, e in ipairs(common.referenzen()) do
    referenzen[e.schluessel] = stringify(e.kuerzel)
  end
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
        result:insert(pandoc.Link(kuerzel, "#ref-" .. c.id))
      end
      return result
    end,
  })
  return doc
end
