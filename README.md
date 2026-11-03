# Beyond PDF – Demonstrator

> **Demonstrator, kein offizieller eCH-Standard.** Dieses Repo und die daraus erzeugte Website und das Word-Dokument sind ein Versuch. Massgebend ist allein die auf [ech.ch](https://www.ech.ch) publizierte Fassung von eCH-0003.

## Zweck

Der Demonstrator zerlegt einen textbasierten eCH-Standard in **Bausteine** mit stabiler ID. Pilot ist eCH-0003 V11.1.0 «Leitfaden zur Genehmigung von Anträgen». Aus den Bausteinen entstehen wieder ein Word-Dokument (mit Deckblatt, Inhaltsverzeichnis und Querverweisen) und eine Website mit einem Feedback-Knopf je Baustein. Rückmeldungen landen so an einer festen Baustein-Adresse statt bei «Kapitel X, Seite Y».

Begriffe: [CONTEXT.md](CONTEXT.md). Umfang, Entscheide und Arbeitspakete: [docs/mvp-spezifikation.md](docs/mvp-spezifikation.md) und [docs/fragenlog.md](docs/fragenlog.md).

**Stellenwert der Regeln:** Wie der Demonstrator Bausteine bildet, IDs vergibt und Beziehungen ableitet, ist ein **Vorschlag und eine Diskussionsgrundlage**. Es ist keine verbindliche Regel. Wie Bausteine und IDs künftig geregelt werden, entscheiden die Fachgruppen, Fachleute und zuständigen Gremien des Vereins eCH, voraussichtlich in einem eigenen Standard oder einem Zusatz zu einem bestehenden.

## Stand

| Teil | Stand |
|---|---|
| Gerüst: alle 92 Überschriften des Originals, Nummerierung und Inhaltsverzeichnis wie im Original | vorhanden |
| Platzhalter mit Link auf die Seite im Original-PDF | vorhanden |
| 1.1 Status, erzeugt aus Status und Vorlage-Fassung 2022 | vorhanden |
| Rohtext aus dem PDF für 1.1–1.2.1, Kap. 7–10, Anhang A, C, F | vorhanden ([original/text/](original/text/README.md)) |
| Kap. 7 als Bausteine, Deckblatt im Word, Feedback, Registry | folgt (AP5–AP14) |

Das Original-PDF liegt unter [original/eCH-0003_V11.1.0_d.pdf](original/eCH-0003_V11.1.0_d.pdf). Kap. 10 des Standards erlaubt die Weiterverbreitung.

## Aufbau

```
_quarto.yml                 Website-Projekt; render-Liste explizit
index.qmd                   Startseite
ech-0003/v11.1.0/
  _metadata.yml             Ebene 0, sprachneutral (Codes, Vorlage-Fassung, Original)
  de/index.qmd              Gerüst; Kopfzeile mit sprachabhängiger Ebene 0
  de/bausteine/             eine Datei je grobem Baustein (ab AP5)
vorlage/
  2022/                     Vorlage-Fassung 2022: Statustexte, Deckblatt
  word/                     Word-Referenzdokument (eCH-Vorlage vom 28.11.2025, lokale Kopie)
original/
  eCH-0003_V11.1.0_d.pdf    Original
  text/                     Rohtext je Kapitel und Inhaltsverzeichnis (aus dem PDF extrahiert)
filters/                    Lua-Filter und Shortcodes
assets/                     SCSS, Logos, HTML-Partial
tools/                      Extraktion, Nachbearbeitung Word, CI-Prüfungen
.github/workflows/build.yml Prüfen -> Rendern -> Word nachbearbeiten -> Artefakt (Pages vorbereitet)
docs/                       Projektdokumentation (wird nicht gerendert)
```

## Lokal bauen

Voraussetzungen: Quarto 1.10.19 (enthält Pandoc und Typst), Python 3.11.

```bash
quarto render
```

```bash
py -3.11 tools/aktualisiere_felder_beim_oeffnen.py _site/ech-0003/v11.1.0/de/DEMO_eCH-0003_V11.1.0_de.docx
```

```bash
quarto preview
```

`quarto render` erzeugt HTML und Word in einem Aufruf nach `_site/`. Nicht `quarto render --to docx` verwenden: Im Website-Projekt löscht das die übrigen Formate (Spike S1). Das Word heisst bewusst `DEMO_eCH-0003_V11.1.0_de.docx` und nicht nach eCH-Konvention (E18). Das Skript `aktualisiere_felder_beim_oeffnen.py` sorgt dafür, dass Word beim Öffnen das Inhaltsverzeichnis füllt; Word fragt dabei einmal nach.

Den Rohtext erneut aus dem PDF ziehen (nur nötig, wenn sich das Skript ändert):

```bash
py -3.11 tools/extrahiere_rohtext.py
```

## CI und Veröffentlichung

Der Workflow [build.yml](.github/workflows/build.yml) läuft bei jedem Push auf `main`, bei Pull Requests und bei Tags `v*`. Er prüft, rendert alle Formate in einem Aufruf, bearbeitet das Word nach und legt `_site/` als Artefakt «website» ab. Bei einem Tag entsteht ein Release mit dem Word.

GitHub Pages ist vorbereitet, aber ausgeschaltet, bis die Freigabe zum Veröffentlichen vorliegt (E23). Die Schritte zum Einschalten stehen im Kopf des Workflows.

## Herkunft und Namensnennung

**FOAG-Template.** Teile stammen aus dem Template des Bundesamts für Landwirtschaft, [blw-ofag-ufag/semantic-web-template](https://github.com/blw-ofag-ufag/semantic-web-template), lizenziert unter [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), Stand Commit `659b85f`. Das Template dient als Steinbruch, nicht als Fork (ADR 0006). Übernommen wurden:

| Datei hier | Datei im FOAG-Template | Änderung |
|---|---|---|
| `assets/ech.scss` | `docs/assets/ech.scss` | Regel zum Ausblenden der Anhänge im Inhaltsverzeichnis entfernt; Stil für Platzhalter ergänzt |
| `assets/ech_dark.scss` | `docs/assets/ech_dark.scss` | keine |
| `assets/ech.svg`, `assets/favicon.svg` | `docs/assets/` | keine |
| `assets/title-metadata.html` | `docs/assets/title-metadata.html` | keine |
| `filters/ech_common.lua` | `docs/assets/ech_common.lua` | liest die Vorlage-Fassung statt `ech_vocabulary.yml`; deutsche Codes; Statustext |
| `filters/ech_metadata.lua` | `docs/assets/ech_metadata.lua` | ohne Typst-Werte |
| `filters/ech_shortcodes.lua` | `docs/assets/ech_shortcodes.lua` | nur noch `{{< statustext >}}` aus der Vorlage-Fassung |

**Abweichungen vom FOAG-Template** (für eine spätere Rückführung in ein gemeinsames eCH-Template, F16):

- Die Vokabulare und Beschriftungen des Deckblatts stammen aus einer **Vorlage-Fassung** (`vorlage/<fassung>/`, ADR 0005), nicht aus `ech_vocabulary.yml`. Die Metadaten tragen deutsche Codes (`genehmigt`, `verbreitet`) nach eCH-0003 V11.1.0.
- Das Word-Referenzdokument liegt als lokale Kopie im Repo, nicht als URL.
- Word nummeriert die Überschriften selbst; Quarto-Textnummern werden im Word entfernt (`filters/ech_docx_nummern.lua`, Spike S3, Lösung A).
- Anhänge tragen in der Quelle die Klasse `.appendix` und nur ihren Titel; die Buchstaben erzeugt `filters/ech_anhang.lua`. Auf der Website stehen sie wie im Original im Inhaltsverzeichnis.
- Nicht übernommen: RDF/SHACL/SPARQL, LINDAS, Python-Datenpipeline, R, Java, Makefile, Tests des Templates, `ech_vocabulary.yml`, `ech_captions.lua`, `ech_citations.lua` und CSL (noch nicht nötig), Typst-Vorlagen (Stufe 2).
- Veröffentlichung mit den GitHub-Pages-Actions statt über einen `gh-pages`-Branch.

**Weitere Quellen:**

- `filters/ech_anhang.lua`, `ech_titelref.lua`, `ech_docx_nummern.lua`: aus den eigenen Spikes ([docs/spikes/](docs/spikes/README.md)), angepasst.
- `vorlage/word/ech-vorlage-d-2025-11-28.docx`: eCH-Vorlage (Beilage zu eCH-0003, Stand 28.11.2025), unverändert.
- `original/eCH-0003_V11.1.0_d.pdf`: eCH-0003 V11.1.0, Verein eCH, unverändert.

## Lizenz

Noch offen (F36, Meeting vom 4.11.2026). Bis dahin gelten für übernommene Teile die oben genannten Lizenzen, für den Standardtext die Bestimmungen in Kap. 10 von eCH-0003.
