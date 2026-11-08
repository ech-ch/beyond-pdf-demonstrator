-- Quarto-Shortcodes für erzeugten Inhalt aus den eCH-Metadaten.
--
-- Herkunft: FOAG-Template blw-ofag-ufag/semantic-web-template,
-- docs/assets/ech_shortcodes.lua (CC BY 4.0, Stand Commit 659b85f).
-- Angepasst für den Demonstrator: `{{< ech status >}}` heisst hier
-- `{{< statustext >}}` und liest den Statustext aus der Vorlage-Fassung
-- (E14, ADR 0005); Titel und Verzeichnisse des FOAG-Shortcodes entfallen.
-- Neu sind `{{< vorlagentext >}}` (E13) und `{{< referenzen >}}` (E15).
--
--   {{< statustext >}}     Statustext für 1.1 «Status», z.B. «Genehmigt: Das
--                          Dokument wurde vom Vorstand genehmigt. …»
--   {{< vorlagentext x >}} Vorlagentext vorlage/<fassung>/x.md mit Überschrift
--                          und Text; kein Baustein, kein Feedback. Auf der
--                          Website dezenter Hinweis unter der Überschrift
--   {{< referenzen >}}     Tabelle von Anhang A aus referenzen.yml, je Eintrag
--                          ein Anker #ref-<schlüssel> als Ziel der Zitate

local common = dofile(quarto.utils.resolve_path("ech_common.lua"))
local stringify = pandoc.utils.stringify

return {
  ["statustext"] = function(args, kwargs, meta)
    -- Span .statustext: Daran erkennt die Registry 1.1 als Ziel «Statustext» (E50)
    return pandoc.Inlines({ pandoc.Span(common.statustext(meta), pandoc.Attr("", { "statustext" })) })
  end,

  ["vorlagentext"] = function(args, kwargs, meta)
    local name = args[1] and stringify(args[1]) or ""
    if not name:match("^[a-z0-9-]+$") then
      error("{{< vorlagentext >}}: ungültiger Name '" .. name .. "'")
    end
    local fassung = common.vorlage_fassung(meta)
    local pfad = quarto.utils.resolve_path("../vorlage/" .. fassung .. "/" .. name .. ".md")
    local datei = io.open(pfad, "r")
    if datei == nil then
      error(string.format("{{< vorlagentext >}}: Die Vorlage-Fassung %s hat keinen Vorlagentext '%s'", fassung, name))
    end
    local text = datei:read("a")
    datei:close()
    local blocks = pandoc.read(text, "markdown").blocks
    -- Markierung für die Registry (verwendete Vorlagentexte, E13)
    if blocks[1] and blocks[1].t == "Header" then
      blocks[1].attributes["vorlagentext"] = name
      blocks[1].attributes["fassung"] = fassung
    end
    if quarto.doc.is_format("html") then
      local hinweis = pandoc.Div(
        { pandoc.Para({ pandoc.Str("Vorlagentext, zentral gepflegt, Fassung " .. fassung) }) },
        pandoc.Attr("", { "vorlagentext-hinweis" }))
      blocks:insert(2, hinweis)   -- direkt unter der Überschrift
    end
    return blocks
  end,

  ["referenzen"] = function(args, kwargs, meta)
    local zeilen = {}
    for _, e in ipairs(common.referenzen()) do
      local kuerzel = pandoc.Span(e.kuerzel, pandoc.Attr("ref-" .. e.schluessel))
      table.insert(zeilen, { { pandoc.Plain({ kuerzel }) }, { pandoc.Plain(e.text) } })
    end
    if #zeilen == 0 then error("{{< referenzen >}}: referenzen.yml fehlt oder ist leer") end
    return pandoc.utils.from_simple_table(pandoc.SimpleTable(
      pandoc.Inlines({}), { pandoc.AlignLeft, pandoc.AlignLeft }, { 0.18, 0.82 }, {}, zeilen))
  end,
}
