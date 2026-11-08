# Beyond PDF – Demonstrator

> **Demonstrator, kein offizieller eCH-Standard.** Dieses Repo und die daraus erzeugte Website und das Word-Dokument sind ein Versuch. Massgebend ist allein die auf [ech.ch](https://www.ech.ch) publizierte Fassung von eCH-0003.

## Zweck

Der Demonstrator zerlegt einen textbasierten eCH-Standard in **Bausteine** mit stabiler ID. Pilot ist eCH-0003 V11.1.0 «Leitfaden zur Genehmigung von Anträgen». Aus den Bausteinen entstehen wieder ein Word-Dokument (mit Deckblatt, Inhaltsverzeichnis und Querverweisen) und eine Website mit einem Feedback-Knopf je Baustein. Rückmeldungen landen so an einer festen Baustein-Adresse statt bei «Kapitel X, Seite Y».

Begriffe: [CONTEXT.md](CONTEXT.md). Umfang, Entscheide und Arbeitspakete: [docs/mvp-spezifikation.md](docs/mvp-spezifikation.md) und [docs/fragenlog.md](docs/fragenlog.md).

**Stellenwert der Regeln:** Wie der Demonstrator Bausteine bildet, IDs vergibt und Beziehungen ableitet, ist ein **Vorschlag und eine Diskussionsgrundlage**. Es ist keine verbindliche Regel. Wie Bausteine und IDs künftig geregelt werden, entscheiden die Fachgruppen, Fachleute und zuständigen Gremien des Vereins eCH, voraussichtlich in einem eigenen Standard oder einem Zusatz zu einem bestehenden. Dasselbe gilt dafür, wie die einzelnen Bausteine und die allgemeinen Texte in allen Kapiteln aufgebaut, dargestellt und benannt sind: Das ist ein initialer Vorschlag, für den MVP freigegeben, aber nicht fixiert. Ein Ausbau oder eine Überarbeitung kann es ändern (E53 im [Fragenlog](docs/fragenlog.md)).

## Stand

| Teil | Stand |
|---|---|
| Gerüst: alle 92 Überschriften des Originals, Nummerierung und Inhaltsverzeichnis wie im Original | vorhanden |
| Platzhalter mit Link auf die Seite im Original-PDF | vorhanden, seit AP26 nicht mehr verwendet |
| 1.1 Status, erzeugt aus Status und Vorlage-Fassung 2022 | vorhanden |
| Rohtext aus dem PDF für Kap. 1–10, Anhänge A–D und F | vorhanden ([original/text/](original/text/README.md)) |
| Kap. 7 als 10 grobe und 54 feine Bausteine (55 Klauseln), Querverweise erzeugt | vorhanden |
| Word mit Deckblatt im Format des Word-Originals, Demonstrator-Hinweis, Inhaltsverzeichnis und Fusszeile | vorhanden |
| CI-Prüfungen für Quelle und Ausgabe (`tools/pruefe.py`) | vorhanden |
| Startseite mit Rundgang; jeder Baustein unter `#<baustein-id>` erreichbar | vorhanden |
| Feedback je Baustein: Knopf, Formular, Labels (`filters/ech_feedback.lua`, `.github/`) | vorhanden, live getestet (E42) |
| 1.2, 1.2.1, Kap. 8 und Anhang F als grobe Bausteine; Kap. 9 und 10 als Vorlagentexte 2022; Anhang A aus `referenzen.yml` | vorhanden |
| Links aus dem Word-Original in den überführten Teilen (E-Mail, Website, Statuten, Kontaktangaben) | vorhanden |
| Registry [`bausteine.json`](#registry): alle Bausteine mit Fundstellen, Herkunft, Verbindlichkeit und Beziehungen | vorhanden |
| Beziehungen auf der Website: «Beziehungen (n)» je Baustein, [Übersichtsseite](ech-0003/v11.1.0/de/beziehungen.qmd) mit Graph und Tabelle | vorhanden |
| Kap. 6 als 2 grobe und 4 feine Bausteine; Anhänge B, C, D als grobe Bausteine, Anhang C mit einer Klausel (IDs freigegeben: [docs/bausteine-kap6-anhaenge.md](docs/bausteine-kap6-anhaenge.md)) | vorhanden |
| 1.3.4, 1.3.9, 1.3.10 als 3 grobe und 18 feine Bausteine (IDs freigegeben: [docs/bausteine-1-3.md](docs/bausteine-1-3.md)) | vorhanden |
| Rest von 1.3 und 1.4 als 9 grobe und 45 feine Bausteine, Abbildung 1 und 2 als Bild aus dem Original-PDF mit Alternativtext; Kap. 1 damit vollständig (IDs freigegeben: [docs/bausteine-1-3-und-1-4.md](docs/bausteine-1-3-und-1-4.md)) | vorhanden |
| Kap. 2–5 als Text, überführt, noch nicht in Bausteine zerlegt: Wortlaut, Kennzeichnungen im Text, Querverweise erzeugt, Abbildungen 3–6 aus dem Original-PDF, Hinweis über jedem Kapitel, Feedback je Kapitel (E54); der ganze Standard ist damit abgebildet | vorhanden |
| Anhang E (Abbildungsverzeichnis) erzeugt aus den sechs Abbildungen; im Word mit Seitenzahlen (Feld PAGEREF) | vorhanden |
| [Steckbrief](ech-0003/v11.1.0/de/steckbrief.qmd) nach dem Raster «eCH Steckbrief Standardisierungsinhalte» (V0.9): Angaben in `steckbrief.yml`, Raster als Vokabular in `vorlage/steckbrief/`, Bezüge und Strukturierung erzeugt; Texte und Auswahlen als Vorschlag | vorhanden |

Das Original-PDF liegt unter [original/eCH-0003_V11.1.0_d.pdf](original/eCH-0003_V11.1.0_d.pdf). Kap. 10 des Standards erlaubt die Weiterverbreitung.

## Aufbau

```
_quarto.yml                 Website-Projekt; render-Liste explizit
index.qmd                   Startseite
ech-0003/v11.1.0/
  _metadata.yml             Ebene 0, sprachneutral (Codes, Vorlage-Fassung, Original, Kennzeichnungen)
  referenzen.yml            Daten für Anhang A
  steckbrief.yml            Steckbrief, sprachneutral (Raster-Fassung, Auswahlen, offene Felder)
  de/index.qmd              Gerüst; Kopfzeile mit sprachabhängiger Ebene 0
  de/bausteine/             eine Datei je grobem Baustein; mehrfach/ für Mehrfachbausteine
  de/text/                  Kap. 2–5 als Text, noch nicht in Bausteine zerlegt (E54)
  de/abbildungen/           Abbildungen aus dem Original-PDF (tools/schneide_abbildungen.py)
  de/beziehungen.qmd        Übersichtsseite «Beziehungen»; Graph und Tabelle aus bausteine.json
  de/steckbrief.qmd         Steckbrief; Texte in der Kopfzeile, Rest aus Daten und bausteine.json
vorlage/
  2022/                     Vorlage-Fassung 2022: Vorlagentexte, Statustexte, Deckblatt
  steckbrief/0.9/           Raster «eCH Steckbrief Standardisierungsinhalte» V0.9: Feldnamen, Auswahllisten
  word/                     Word-Referenzdokument (eCH-Vorlage vom 28.11.2025, lokale Kopie)
original/
  eCH-0003_V11.1.0_d.pdf    Original
  text/                     Rohtext je Kapitel und Inhaltsverzeichnis (aus dem PDF extrahiert)
filters/                    Lua-Filter und Shortcodes
assets/                     SCSS, Logos, HTML-Partial
tools/                      Extraktion (Text, Abbildungen), Nachbearbeitung Word, CI-Prüfungen
.github/workflows/build.yml Prüfen -> Rendern -> Word nachbearbeiten -> Artefakt (Pages vorbereitet)
.github/workflows/feedback-label.yml, .github/scripts/  Labels für Feedback-Issues, mit Tests
.github/ISSUE_TEMPLATE/    Feedback-Formular
docs/                       Projektdokumentation (wird nicht gerendert)
```

## Lokal bauen

Voraussetzungen: Quarto 1.10.19 (enthält Pandoc und Typst), Python 3.11.

```bash
py -3.11 tools/pruefe.py quelle
```

```bash
quarto render
```

```bash
py -3.11 tools/pruefe.py ausgabe
```

```bash
py -3.11 tools/aktualisiere_felder_beim_oeffnen.py _site/ech-0003/v11.1.0/de/DEMO_eCH-0003_V11.1.0_de.docx
```

```bash
quarto preview
```

`quarto render` erzeugt HTML und Word in einem Aufruf nach `_site/`. Nicht `quarto render --to docx` verwenden: Im Website-Projekt löscht das die übrigen Formate (Spike S1). Das Word heisst bewusst `DEMO_eCH-0003_V11.1.0_de.docx` und nicht nach eCH-Konvention (E18). Das Skript `aktualisiere_felder_beim_oeffnen.py` sorgt dafür, dass Word beim Öffnen das Inhaltsverzeichnis füllt; Word fragt dabei einmal nach.

`tools/pruefe.py` prüft vor dem Rendern die Quelle (IDs, Kennzeichnungen, Nummern von Hand, `bezug`) und nach dem Rendern die Ausgabe: Zählung, Textvergleich mit `original/text/`, unaufgelöste Verweise, Feedback-Links, Registry und Beziehungen. Mit `--log` liest sie zusätzlich die Ausgabe von `quarto render`: Jede Meldung «ERROR» ist ein Fehler, weil ein Fehler in einem Lua-Filter den Build in Quarto nicht abbricht (E48). Welche Kapitel verglichen werden, steht in `tools/pruefe.toml`.

Den Rohtext erneut aus dem PDF ziehen (nur nötig, wenn sich das Skript ändert):

```bash
py -3.11 tools/extrahiere_rohtext.py
```

Die Abbildungen erneut aus dem PDF schneiden (braucht `pdftoppm` aus Poppler und Pillow; die Ergebnisse sind committet):

```bash
py -3.11 tools/schneide_abbildungen.py
```

## Registry

`quarto render` schreibt zusätzlich `_site/ech-0003/v11.1.0/bausteine.json`. Die Datei enthält die Angaben zum Standard (Ebene 0) und je Baustein:

- ID, Name, Typ, Status
- Fundstellen und Seiten im Original
- Kennzeichnung und Verbindlichkeit
- Beziehungen: Einbettung, Verweise, Rückbezüge; jede mit Umkehrung

Dazu die Gliederung: jede Überschrift des Gerüsts mit ihrem Stand (Baustein, Text ohne Bausteine, Platzhalter, Vorlagentext, Statustext, Daten, Verzeichnis, ohne eigenen Text). Text ohne Bausteine (Kap. 2–5) ist keine Quelle von Beziehungen: Seine Querverweise erscheinen erst in der Registry, wenn er in Bausteine zerlegt ist (E54). Daneben schreibt der Build `steckbrief.json`, den Steckbrief als Daten.

Aufbau und Beispiel: [Spezifikation 3.3](docs/mvp-spezifikation.md#33-metadaten-e09-adr-0003). Die Registry ist von der Startseite und der Standardseite aus verlinkt. Wie bei den IDs gilt: Felder und Beziehungstypen sind ein Vorschlag.

Auf der Website zeigt «Beziehungen (n)» unter einem Baustein seine Querverweise und Rückbezüge; die Seite «Beziehungen» zeigt alle als Graph und Tabelle. Beides entsteht aus `bausteine.json`. Die Übersichtsseite liest die Datei der Standardseite aus demselben Lauf und steht deshalb in der render-Liste von `_quarto.yml` nach ihr; `tools/pruefe.py` prüft das.

## CI und Veröffentlichung

Der Workflow [build.yml](.github/workflows/build.yml) läuft bei jedem Push auf `main`, bei Pull Requests und bei Tags `v*`. Er prüft, rendert alle Formate in einem Aufruf, bearbeitet das Word nach und legt `_site/` als Artefakt «website» ab. Bei einem Tag entsteht ein Release mit dem Word.

GitHub Pages ist vorbereitet, aber ausgeschaltet, bis die Freigabe zum Veröffentlichen vorliegt (E23). Die Schritte zum Einschalten stehen im Kopf des Workflows.

## Herkunft und Namensnennung

**FOAG-Template.** Teile stammen aus dem Template des Bundesamts für Landwirtschaft, [blw-ofag-ufag/semantic-web-template](https://github.com/blw-ofag-ufag/semantic-web-template), lizenziert unter [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), Stand Commit `659b85f`. Das Template dient als Steinbruch, nicht als Fork (ADR 0006). Übernommen wurden:

| Datei hier | Datei im FOAG-Template | Änderung |
|---|---|---|
| `assets/ech.scss` | `docs/assets/ech.scss` | Regel zum Ausblenden der Anhänge im Inhaltsverzeichnis entfernt; Stile für Platzhalter und Sprungziele der Bausteine ergänzt; lange Werte im Deckblatt brechen auf dem Handy um; Stile für «Beziehungen (n)» und die Übersichtsseite |
| `assets/ech_dark.scss` | `docs/assets/ech_dark.scss` | keine |
| `assets/ech.svg`, `assets/favicon.svg` | `docs/assets/` | keine |
| `assets/title-metadata.html` | `docs/assets/title-metadata.html` | keine |
| `filters/ech_common.lua` | `docs/assets/ech_common.lua` | liest die Vorlage-Fassung statt `ech_vocabulary.yml`; deutsche Codes; Statustext; Beilagen mit Aufzählung; Namen der Bausteine; Erkennung der Standardseite; echter Abbruch (E48); YAML lesen für den Steckbrief |
| `filters/ech_metadata.lua` | `docs/assets/ech_metadata.lua` | ohne Typst-Werte; Titel ohne Nummer in `ech-titel` (für die Registry) |
| `filters/ech_shortcodes.lua` | `docs/assets/ech_shortcodes.lua` | nur noch `{{< statustext >}}` aus der Vorlage-Fassung; neu `{{< vorlagentext >}}` und `{{< referenzen >}}` |

**Abweichungen vom FOAG-Template** (für eine spätere Rückführung in ein gemeinsames eCH-Template, F16):

- Die Vokabulare und Beschriftungen des Deckblatts stammen aus einer **Vorlage-Fassung** (`vorlage/<fassung>/`, ADR 0005), nicht aus `ech_vocabulary.yml`. Die Metadaten tragen deutsche Codes (`genehmigt`, `verbreitet`) nach eCH-0003 V11.1.0.
- Das Word-Referenzdokument liegt als lokale Kopie im Repo, nicht als URL.
- Die Deckblatt-Tabelle im Word entsteht als OpenXML im Format des Word-Originals (Rahmen, Spaltenbreiten, Aufzählung), nicht als Pandoc-Tabelle. Codeblöcke stehen im Word in Consolas (`filters/ech_docx_code.lua`).
- Die Registry `bausteine.json` (`filters/ech_registry.lua`) ist neu; das FOAG-Template kennt keine Bausteine.
- Word nummeriert die Überschriften selbst; Quarto-Textnummern werden im Word entfernt (`filters/ech_docx_nummern.lua`, Spike S3, Lösung A).
- Anhänge tragen in der Quelle die Klasse `.appendix` und nur ihren Titel; die Buchstaben erzeugt `filters/ech_anhang.lua`. Auf der Website stehen sie wie im Original im Inhaltsverzeichnis.
- Nicht übernommen: RDF/SHACL/SPARQL, LINDAS, Python-Datenpipeline, R, Java, Makefile, Tests des Templates, `ech_vocabulary.yml`, `ech_captions.lua`, `ech_citations.lua` und CSL (noch nicht nötig), Typst-Vorlagen (Stufe 2).
- Veröffentlichung mit den GitHub-Pages-Actions statt über einen `gh-pages`-Branch.

**Weitere Quellen:**

- `filters/ech_anhang.lua`, `ech_titelref.lua`, `ech_docx_nummern.lua`: aus den eigenen Spikes ([docs/spikes/](docs/spikes/README.md)), angepasst.
- `vorlage/word/ech-vorlage-d-2025-11-28.docx`: eCH-Vorlage (Beilage zu eCH-0003, Stand 28.11.2025), unverändert.
- `original/eCH-0003_V11.1.0_d.pdf`: eCH-0003 V11.1.0, Verein eCH, unverändert.

## Lizenz

Für den Demonstrator ist noch keine Lizenz festgelegt (F36). Für übernommene Teile gelten die oben genannten Lizenzen, für den Standardtext die Bestimmungen in Kap. 10 von eCH-0003.
