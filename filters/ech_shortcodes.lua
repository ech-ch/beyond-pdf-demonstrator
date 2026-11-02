-- Quarto-Shortcodes für erzeugten Inhalt aus den eCH-Metadaten.
--
-- Herkunft: FOAG-Template blw-ofag-ufag/semantic-web-template,
-- docs/assets/ech_shortcodes.lua (CC BY 4.0, Stand Commit 659b85f).
-- Angepasst für den Demonstrator: `{{< ech status >}}` heisst hier
-- `{{< statustext >}}` und liest den Statustext aus der Vorlage-Fassung
-- (E14, ADR 0005); Titel und Verzeichnisse des FOAG-Shortcodes entfallen.
--
--   {{< statustext >}}   Statustext für 1.1 «Status», z.B. «Genehmigt: Das
--                        Dokument wurde vom Vorstand genehmigt. …»

local common = dofile(quarto.utils.resolve_path("ech_common.lua"))

return {
  ["statustext"] = function(args, kwargs, meta)
    return common.statustext(meta)
  end,
}
