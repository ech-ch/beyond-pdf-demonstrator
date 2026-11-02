# Spike-Quellen

Testprojekte der Spikes vom 2.11.2026. Kurzfassung der Ergebnisse: [../spikes.md](../spikes.md). Ausführliches Protokoll: [protokoll-detail.md](protokoll-detail.md).

Die Quellen sind Wegwerf-Code zur Klärung von Entscheiden, kein Teil des Builds. Die Lua-Filter dienen als Ausgangspunkt für die Umsetzung.

| Ordner | Inhalt |
|---|---|
| `s2-einbinden/` | Gerüst bindet Baustein-Dateien ein; Varianten YAML-Kopfzeile und ID ohne `sec-` |
| `s3-querverweise/` | Verweisformen des Originals; Filter `ech_anhang.lua`, `ech_titelref.lua`, `ech_docx_nummern.lua` |
| `s4-luafilter/` | Feedback-Link je Baustein (`feedback.lua`), Debug-Filter |
| `tools/` | Auswertung von DOCX-XML, Soll/Ist der Verweise, sichtbare Überschriftennummern in Word |

**Nicht enthalten:** Word-Vorlagen, Logs, Render-Ausgaben und der Spike S1 (Kopie des FOAG-Templates, Änderungen im Protokoll beschrieben).

**Vor dem Rendern:** Die eCH-Word-Vorlage (`XXXX_d_DRA_JJJJ-MM-TT_eCH-0XXX_Vx.x.x_Titel.docx`) muss als `vorlage/ech-vorlage.docx` in den jeweiligen Projektordner kopiert werden.

**Herkunft und Lizenzen:** `s3-querverweise/filters/ech_citations.lua` stammt aus dem FOAG-Template [blw-ofag-ufag/semantic-web-template](https://github.com/blw-ofag-ufag/semantic-web-template) (CC BY 4.0). `s3-querverweise/din_1505_2_alphanumeric.csl` steht unter CC BY-SA 3.0 (siehe Hinweis in der Datei).
