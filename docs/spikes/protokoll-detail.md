# Spike-Protokoll: eCH-0003 aus Markdown-Bausteinen mit Quarto

Datum: 2026-11-02 · Quarto 1.10.19 (mit Pandoc und Typst) · Windows 11 · Word 16 (für die Sichtprüfung über COM, schreibgeschützt)

Spike-Ordner: ursprünglich ein lokaler Wegwerf-Ordner. Die Testquellen liegen jetzt unter `docs/spikes/` (ohne Word-Vorlagen, Logs und Render-Ausgaben, siehe [README](README.md)). Die Kurzfassung steht in [../spikes.md](../spikes.md).

| Ordner | Inhalt |
|---|---|
| `s1-foag/` | Kopie von `semantic-web-template/docs`, minimal angepasst (siehe S1) |
| `s2-einbinden/` | Minimalprojekt Gerüst + Bausteine (S2) |
| `s3-querverweise/` | Projekt mit Querverweisen, Bibliografie, 3 Lua-Filtern (S3) |
| `s4-luafilter/` | Projekt mit Feedback-Filter und Debug-Filtern (S4) |
| `tools/` | `docx_inspect.py` (DOCX-XML auswerten), `check_testfaelle.py` (Soll/Ist der Verweise), `word_headings.ps1` (Word berechnet die sichtbaren Überschriftennummern, optional PDF-Export) |
| `vorlagen/` | eCH-Word-Vorlage lokal und von der URL, eCH-0003-PDF (nur gelesen) |
| `logs/` | Render-Logs aller Läufe |

Kennzeichnung: **[getestet]** = durch Render und Auswertung von Ausgabe oder XML belegt; **[vermutet]** = abgeleitet, nicht ausgeführt.

---

## S1 – FOAG-Template rendern

### Frage

Lässt sich der Dokumentteil des FOAG-Templates lokal mit Quarto 1.10.19 als HTML, DOCX und Typst-PDF rendern, und wie sieht das Word aus (Referenzdokument von der URL, Deckblatt, doppelte Nummerierung)?

### Vorgehen

1. `semantic-web-template/docs` nach `s1-foag/` kopiert. Alle Änderungen:
   - `en/` und `fr/` gelöscht; in `_quarto.yml` die `render`-Liste auf `de/index.qmd` gekürzt.
   - In `_quarto.yml` `output-dir: ../build/docs/` durch `_build/` ersetzt, damit die Ausgabe im Spike-Ordner bleibt.
   - In `de/index.qmd` die vier Include-Zeilen auf generierte Fragmente (`namespaces.md`, `entities.md`, `codelists.md`, `glossary.md`) durch HTML-Kommentare ersetzt.
   - In `de/index.qmd` den R-Chunk `fig-r-example` entfernt.
   - Nicht geändert: die Daten-Beispiele `../data/example.rq` und `example.ttl` (liegen im Repo und funktionieren), das Bild von picsum.photos (braucht Netz) und die Schrift.
2. Gerendert wurde mit
   ```
   quarto render de/index.qmd --to html   # bzw. docx, typst (einzeln, mit Zeitmessung)
   quarto render                          # alle Formate in einem Aufruf
   quarto render de/index.qmd --to docx --reference-doc <spikes>/vorlagen/ech-vorlage-lokal.docx -o index-lokal.docx
   ```
3. Die Vorlagen-URL wurde mit `curl -sS -I -L <URL>` geprüft, heruntergeladen und per MD5 mit der lokalen Datei verglichen.
4. Ausgewertet wurde mit `py -I tools/docx_inspect.py <docx> styles|numbering|headings|body|fields` sowie mit `tools/word_headings.ps1 -Docx <docx> -Pdf <pdf>`. Das Skript fragt in Word `Range.ListFormat.ListString` ab, also die Nummer, die Word anzeigt.

### Ergebnis

**Rendern [getestet]**

| Format | Ergebnis | Dauer | Meldungen |
|---|---|---|---|
| html | OK | 15.9 s (Erstlauf inkl. SASS) | 2× `Unable to resolve crossref` (@fig-r-example, @tbl-namespaces: Textverweise auf die entfernten Inhalte, erwartet) |
| docx | OK | 3.3 s | dieselben 2 Warnungen |
| typst | OK | 8.0 s | dieselben 2 Warnungen; zusätzlich `warning: unknown font family: nimbus sans` (Ersatzschrift; die CI installiert `fonts-urw-base35`) |
| alle (`quarto render`, inkl. gfm) | OK | 10.4 s | wie oben |

Nebenbefund [getestet]: In einem Projekt vom Typ `website` löscht `quarto render <datei> --to <fmt>` die Ausgaben der anderen Formate. Nach drei Einzelläufen lag nur noch `index.pdf` in `_build/de/`. Deshalb immer alle Formate in einem Aufruf rendern.

Nebenbefund [getestet]: Quarto schreibt Metadatenwerte, die einem existierenden Pfad entsprechen, in einen relativen Pfad um (`languages.original: de` → `../de` im Log). Das FOAG-Template fängt das in `ech_common.lua` bereits ab (`language_code`).

**Referenzdokument [getestet]**

- Die URL antwortet mit `HTTP/1.1 200 OK`, `content-length: 92174`, `last-modified: Fri, 28 Nov 2025 12:45:20 GMT` und dem Content-Type `application/vnd.openxmlformats-officedocument.wordprocessingml.document`.
- Die Datei von der URL und die lokale Datei sind byteidentisch (MD5 `7b486e35d6c8a9a786406879b2030fd9`).
- Pandoc lädt die URL beim Rendern. Die Ausgabe enthält die eCH-Formatvorlagen sowie die Kopf- und Fusszeile mit eCH-Logo. Der Build hängt damit vom Netz ab.

**Inhalt des Word-Dokuments vor dem ersten Kapitel [getestet]** (Absätze aus `document.xml`):

```
0 [Titel]           'Quarto-Dokument als Vorlage'
1 [Date]            '2026-10-01'
2 [AbstractTitle]   'Zusammenfassung'
3 [Abstract]        'Kurze Zusammenfassung des Zwecks dieses Dokuments'
4 [TOCHeading]      'Inhaltsverzeichnis'   (+ TOC-Feld  TOC \o "1-2" \h \z \u)
6 [berschrift1]     'Hinweis'
8 [berschrift1]     '1. Einleitung'
```

- Es gibt **kein Deckblatt** und keine eCH-Metadatentabelle. Der Titel steht ohne eCH-Nummer, weil `ech_metadata.lua` das Präfix nur für HTML setzt. Das Deckblatt mit Metadatentabelle entsteht nur im Typst-PDF (geprüft: vollständige eCH-Titelseite mit Tabelle, Zusammenfassung und «PRE-RELEASE»-Band).
- Die **Fusszeile ist kaputt.** Die Vorlage enthält die Felder `REF Ausgabedatum`, `REF eCHNummer`, `REF eCHName`, `REF Version` und `REF Status`. Die zugehörigen Textmarken stehen im Körper der Vorlage, den Pandoc verwirft. Im Word-PDF-Export erscheint deshalb 5× «Fehler! Verweisquelle konnte nicht gefunden werden.»
- Elf in der Ausgabe verwendete Formatvorlagen fehlen in der eCH-Vorlage und kommen deshalb mit Pandoc-Standardaussehen: `Abstract, AbstractTitle, Bibliography, Compact, Date, FirstParagraph, FootnoteReference, ImageCaption, SourceCode, TOCHeading, VerbatimChar`.

**Doppelte Nummerierung [getestet]**

Die Vorlage (URL- und lokale Datei identisch) nummeriert die Überschriften automatisch. In `styles.xml` hängen Überschrift 1–9 an der Liste numId 1:
```
'berschrift1' name='heading 1' outline=0 numPr=<w:numId w:val="1"/>
'berschrift2' name='heading 2' outline=1 numPr=<w:ilvl w:val="1"/><w:numId w:val="1"/>
'berschrift3' name='heading 3' outline=2 numPr=<w:ilvl w:val="2"/><w:numId w:val="1"/>
abstractNum 0: ilvl0:berschrift1 text=%1; ilvl1:berschrift2 text=%1.%2; ilvl2:berschrift3 text=%1.%2.%3 …
'Anhangberschrift' name='Anhang Überschrift' basedOn=berschrift1 numPr=<w:numId w:val="0"/>
```

Quarto schreibt die Nummer zusätzlich als Text in die Überschrift. Laut `share/filters/main.lua` bekommt Ebene 1 in Nicht-HTML-Formaten die Form «`1. `», die übrigen Ebenen «`1.1 `». Pandoc ersetzt die `<w:num>`-Einträge der Vorlage durch eigene (IDs ab 1000), die Formatvorlagen behalten aber `numId 1`. Trotzdem nummeriert Word sichtbar mit (Word-COM, `ListString`):

```
Überschrift 1 | Liste='1'   | Text='Hinweis'               ← .unnumbered, trotzdem nummeriert
Überschrift 1 | Liste='2'   | Text='1. Einleitung'         → sichtbar «2  1. Einleitung»
Überschrift 2 | Liste='2.1' | Text='1.1 Status'            → sichtbar «2.1  1.1 Status»
Überschrift 1 | Liste='10'  | Text='Anhang A – Referenzen' → Anhänge werden 10 … 15
```

Im Word-PDF ist das so sichtbar: «2 1. Einleitung», «2.1 1.1 Status», «10 Anhang A – Referenzen». Mit der lokalen Vorlage als `reference-doc` ist das Ergebnis identisch. Es gibt also doppelte Nummern, und zusätzlich sind alle Nummern um 1 verschoben, sobald vor Kapitel 1 eine unnummerierte Überschrift steht.

### Konsequenz

- Das HTML- und das Typst-PDF-Format des FOAG-Templates sind ohne die RDF-Pipeline direkt nutzbar.
- **Die DOCX-Ausgabe ist mit der offiziellen Vorlage so nicht abgabefähig.** Es braucht:
  - eine Lösung für die Nummerierung (Lösung A aus S3 getestet);
  - ein eigenes Deckblatt mit Metadatentabelle für DOCX (fehlt heute, Lua-Filter oder OpenXML-Rohblock) [vermutet machbar];
  - die Textmarken `eCHNummer`, `eCHName`, `Version`, `Status` und `Ausgabedatum` für die Fusszeile. In S3 getestet: Spans mit IDs erzeugen sie, danach ist die Fusszeile korrekt;
  - eine abgeleitete Referenzvorlage, die zusätzlich die elf Pandoc-Formatvorlagen (FirstParagraph, Compact usw.) im eCH-Stil enthält [vermutet].
- Die Referenzvorlage sollte im Repo liegen, nicht als URL: Das macht den Build reproduzierbar und offline lauffähig, und die Datei ist ohnehin identisch.
- Im Build alle Formate in einem `quarto render`-Aufruf erzeugen.

---

## S2 – Einbinden mit Attributen

### Frage

Kommen IDs und Attribute von Überschriften und fenced divs aus eingebundenen Dateien in HTML und DOCX an? Was passiert mit einer YAML-Kopfzeile in einer eingebundenen Datei? Taugt eine Überschrift-ID ohne `sec-`-Präfix?

### Vorgehen

- Projekt `s2-einbinden/` mit `_quarto.yml` (`lang: de`, `number-sections: true`, html und docx, `reference-doc: vorlage/ech-vorlage.docx`).
- `geruest.qmd` enthält das Kapitelgerüst des Originals: Kapitel 1–6, darunter 1.3.1–1.3.4, sowie `# Formales {#sec-formales}` mit 7.1 und 7.2. Danach folgen `{{< include bausteine/versionierung.md >}}` (ergibt 7.3) und `{{< include bausteine/variante-b-id.md >}}` (ergibt 7.4), anschliessend 7.5 und Anhang F.
- `bausteine/versionierung.md` beginnt mit `## Versionierung {#sec-versionierung bb="ech-0003-bb-versionierung" typ="rule"}` und enthält vier Divs `::: {#bb-… .baustein typ="requirement"}` mit dem Originaltext.
- Variante A: `geruest-a.qmd` bindet `variante-a-yaml.md` ein, die mit `---\nbb: test\n---` beginnt, und gibt `{{< meta bb >}}` aus. `geruest-a2.qmd` bindet zusätzlich `variante-a2-yaml.md` ein (`bb: zweiter`, `title: "Titel aus Baustein"`).
- Variante B: `## Reifegrad eines Dokuments {#ech-0003-bb-reifegrad …}`, angesprochen mit `@ech-0003-bb-reifegrad` und mit `[Reifegrad](#ech-0003-bb-reifegrad)`.
- Befehle: `quarto render` (6.2 s für 2 Dokumente × 2 Formate), danach `docx_inspect.py … bookmarks|links|text` und `grep` im HTML.

### Ergebnis

**HTML [getestet]:** ID, Klassen und eigene Attribute kommen an. Eigene Attribute werden zu `data-*`. Bei Überschriften stehen sie doppelt, auf `<section>` und auf `<h2>` (Pandoc `section-divs`):

```html
<section id="sec-versionierung" class="level2" data-bb="ech-0003-bb-versionierung" data-typ="rule" data-number="7.3">
<h2 data-bb="ech-0003-bb-versionierung" data-typ="rule" data-number="7.3" class="anchored" data-anchor-id="sec-versionierung"><span class="header-section-number">7.3</span> Versionierung</h2>
<div id="bb-zielversion" class="baustein" data-typ="requirement">
```

Die Nummerierung über das Include hinweg stimmt (7.3, 7.4). Div-IDs ohne Crossref-Präfix (`bb-…`) erzeugen keine Warnungen; das Log ist leer.

**DOCX [getestet]:** Für Überschriften und Divs entstehen Textmarken mit dem ID-Namen. Die Textmarke umschliesst den ganzen Abschnitt bzw. den Div-Inhalt:

```xml
<w:bookmarkStart w:id="44" w:name="sec-versionierung" />
<w:p><w:pPr><w:pStyle w:val="berschrift2" /></w:pPr><w:r><w:t>7.3 Versionierung</w:t></w:r></w:p>
<w:bookmarkStart w:id="40" w:name="bb-zielversion" />
<w:p><w:pPr><w:pStyle w:val="FirstParagraph" /></w:pPr> … </w:p>
<w:bookmarkEnd w:id="40" />
```

Die Attribute `bb` und `typ` sowie die Klasse `.baustein` gehen im DOCX verloren; im XML gibt es keine Spur davon.

**Variante A – YAML-Kopfzeile im Baustein [getestet]:**

- Es gibt keinen Fehler, keine Warnung und keinen sichtbaren Text. Der YAML-Block wird geschluckt.
- Der Inhalt landet aber still in den Metadaten des **Gesamtdokuments**: `{{< meta bb >}}` im Gerüst ergibt «test».
- Bei zwei Bausteinen mit YAML gewinnt der letzte (`bb` = «zweiter»).
- Ein `title:` im Baustein **überschreibt den Dokumenttitel**: `<h1 class="title">Titel aus Baustein</h1>`.

**Variante B – ID ohne `sec-` [getestet]:**

- Als Anker funktioniert die ID. Im HTML gibt es `<section id="ech-0003-bb-reifegrad">`, im DOCX eine Textmarke, und `[Reifegrad](#ech-0003-bb-reifegrad)` wird im HTML zu `href`, im DOCX zu `w:hyperlink w:anchor`. Die Überschrift wird trotzdem nummeriert (7.4).
- Als Quarto-Querverweisziel funktioniert sie **nicht**. `@ech-0003-bb-reifegrad` wird als Literaturzitat behandelt:
  - ohne Bibliografie: Der Text bleibt wörtlich «@ech-0003-bb-reifegrad» stehen, **ohne Warnung**;
  - mit Bibliografie (S3): `[WARNING] Citeproc: citation ech-0003-bb-reifegrad not found`, die Ausgabe lautet «ech-0003-bb-reifegrad?».

### Konsequenz

- Das Quellmodell trägt: Überschrift mit ID und Attributen am Anfang der Baustein-Datei, feine Bausteine als fenced divs. Beides überlebt `{{< include >}}`, auch verschachtelt (Gerüst → `_skelett-anfang.md` → Baustein, getestet in S3).
- **Überschrift-IDs müssen mit `sec-` beginnen**, wenn sie Ziel von Quarto-Querverweisen sein sollen. Die stabile Baustein-ID gehört wie geplant in ein Attribut (`bb="ech-0003-bb-…"`). Divs (`bb-…`) sind nur als Linkziel nutzbar, haben aber keine Nummer.
- **YAML in Bausteinen muss per CI-Prüfung verboten werden**, denn Quarto schluckt es still und kann Dokument-Metadaten wie `title` überschreiben. Metadaten pro Baustein gehören in Attribute oder in eine separate Registry-Datei.
- Im DOCX sind von den Bausteinen nur die IDs als Textmarken vorhanden. Werden `bb` oder `typ` im Word gebraucht, muss ein Filter sie abbilden, z.B. als `custom-style` [vermutet].

---

## S3 – Querverweis-Varianten

### Frage

Kann der Build alle Verweisformen des Originals zeichengleich erzeugen, in HTML und DOCX? Stimmen die Nummern im DOCX mit der Überschriftennummerierung überein?

### Vorgehen

- Projekt `s3-querverweise/`. `geruest.qmd` bindet `_skelett-anfang.md` ein: Gliederung wie im Original, Kapitel 1–7.10, mit `# Hinweis {.unnumbered}` vorne wie in der eCH-Vorlage. Darin sind `bausteine/versionierung.md` (7.3) und `bausteine/minor-change.md` (7.8) eingebunden. `_skelett-ende.md` enthält Kapitel 8–10 und Anhang A–F; Anhang C (`bausteine/anhang-c.md`) ist eingebunden.
- Die Anhänge sind wie im FOAG-Template gesetzt: `# Anhang F – Formale Syntax für die Versionierung {#sec-anhang-f .appendix .unnumbered}`.
- Bibliografie `references.yaml` (`SemVer` mit `citation-label: SemVer`), CSL `din_1505_2_alphanumeric.csl` und `ech_citations.lua` aus dem FOAG-Template.
- Eigene Filter:
  - `filters/ech_anhang.lua` (vor `quarto`): `@sec-anhang-x` wird zu «Anhang X».
  - `filters/ech_titelref.lua` (nach `quarto`): `[@sec-x]{.mit-titel}` wird zu «Kapitel 7.1 Titel».
  - `filters/ech_docx_nummern.lua` (nach `quarto`, nur DOCX): Lösung A gegen die doppelte Nummerierung.
- Testfälle T1–T8 als Liste «Quelle: Ergebnis = Soll» in `geruest.qmd`, ausgewertet mit `py -I tools/check_testfaelle.py <html|docx>`.
- `geruest-ohne-filter.qmd` (Metadatum `spike-filter: false`) zeigt das Verhalten mit reinen Quarto-Bordmitteln.
- Nummernkonsistenz im Word: `tools/word_headings.ps1`.
  - Lösung A: `geruest-wordnummern.qmd` mit `docx-nummern: word`.
  - Lösung B: `quarto render geruest.qmd --to docx --reference-doc vorlage/ech-vorlage-ohne-numpr.docx -o geruest-textnummern.docx`. Die Vorlage ist eine Kopie, in der per Python `numPr` aus Überschrift 1–9 entfernt wurde.

### Ergebnis

**Verweise [getestet, HTML und DOCX identisch]**

| # | Original | Quelle im Baustein | Ergebnis | zeichengleich? |
|---|---|---|---|---|
| T1 | (siehe Kapitel 7.5) | `(siehe @sec-bearbeitungsstatus)` | «(siehe Kapitel 7.5)» | optisch ja; Quarto setzt zwischen Präfix und Nummer **U+00A0** (geschütztes Leerzeichen). Das Präfix «Kapitel» stammt aus der Sprachdatei (`crossref-sec-prefix: "Kapitel"`). |
| T2 | Anhang F unten | `@sec-anhang-f unten` | Bordmittel: «?@sec-anhang-f unten» + `WARNING Unable to resolve crossref @sec-anhang-f`. Mit `ech_anhang.lua`: «Anhang F unten» | mit Filter ja |
| T2b | Anhang F unten | `[Anhang F](#sec-anhang-f) unten` | «Anhang F unten» | ja (Buchstabe von Hand) |
| T3 | gemäss Unterkapitel 1.3.4 | `gemäss [Unterkapitel @sec-oeffentliche-konsultation]` | «gemäss Unterkapitel 1.3.4» | optisch ja (U+00A0); ganzer Text verlinkt |
| T3b | gemäss Unterkapitel 1.3.4 | `gemäss Unterkapitel -@sec-oeffentliche-konsultation` | «gemäss Unterkapitel 1.3.4» | **ja**; nur die Nummer ist verlinkt |
| T4 | (siehe 1.3.4) | `(siehe -@sec-oeffentliche-konsultation)` | «(siehe 1.3.4)» | **ja** |
| T5 | gemäss Kapitel 7.1 Zuteilung einer eCH-Nummer | `gemäss [@sec-zuteilung-ech-nummer]{.mit-titel}` | Bordmittel: nur «gemäss Kapitel 7.1». Mit `ech_titelref.lua`: «gemäss Kapitel 7.1 Zuteilung einer eCH-Nummer» | optisch ja (U+00A0) |
| T6 | «Semantic Versioning»[SemVer] | `«Semantic Versioning»[@SemVer]` | «Semantic Versioning»[SemVer] | **ja**, Link auf `#ref-SemVer` |
| T6b | «Versioning»[SemVer] | `«Versioning»[@SemVer]` | «Versioning»[SemVer] | **ja** |
| T6c | (FOAG-Fliesstextzitat) | `gemäss @SemVer` | «gemäss SemVer» (`ech_citations.lua`) | ja |
| T7 | – | `@ech-0003-bb-reifegrad` | «ech-0003-bb-reifegrad?» + Citeproc-Warnung | (siehe S2) |
| T8 | – | `@sec-anhang-c` (Anhang aus eingebundener Datei) | «Anhang C» (mit Filter) | ja |

**Anhänge [getestet]:** Die Klasse `.appendix` hilft für Querverweise nicht. Die Anhangslogik von Quarto (`crossref-apx-prefix: "Anhang"`, `appendix-title`, `appendix-delim`) hängt am Datei-Metadatum `appendix`, also an Book-Projekten (`share/filters/main.lua`, `indexNextChapter`). `.unnumbered`-Abschnitte sind keine auflösbaren Ziele. Der Filter `ech_anhang.lua` (rund 40 Zeilen, vor `quarto`) liest den Buchstaben aus dem Titel («Anhang F – …») und ersetzt den Verweis durch einen Link.

**«Nummer + Titel» [getestet]:** Mit Quarto-Bordmitteln geht das nicht. Der Filter `ech_titelref.lua` (nach `quarto`) sammelt die Titel der Überschriften und entfernt dabei die Nummer, die Quarto bereits eingefügt hat (HTML: `Span.header-section-number`, sonst Text «7.1 » bzw. «7. »). Dann hängt er den Titel an den aufgelösten Link an.

**Form der Verweise im DOCX [getestet]:** Alle Verweise sind **Text mit internem Hyperlink** (`<w:hyperlink w:anchor="sec-bearbeitungsstatus">`) auf die Textmarke der Überschrift. Es gibt keine REF-Felder. Der Text ist statisch und von Quarto berechnet. Zitate verlinken auf `ref-SemVer` im Literaturverzeichnis.

**Nummernkonsistenz im DOCX [getestet in Word]:**

- Standard (eCH-Vorlage + `number-sections`): **inkonsistent.** Im Text steht «Kapitel 7.5», Word zeigt die Überschrift aber als «8.5 7.5 Bearbeitungsstatus eines Dokuments» (`Liste='8.5' Text='7.5 Bearbeitungsstatus…'`), weil Word «Hinweis» mitzählt.
- **Lösung A** (`ech_docx_nummern.lua`, nur DOCX, nach `quarto`): Der Filter entfernt die Textnummer von Quarto. Unnummerierte Überschriften werden zu einem Absatz mit `custom-style` «Anhang Überschrift» (bei `.appendix`) bzw. «Nebentitel» (sonst), jeweils mit Div-ID als Textmarke. Ergebnis in Word: `Liste='7.5' Text='Bearbeitungsstatus eines Dokuments'`, die Anhänge haben `Liste=''`. Inhaltsverzeichnis im Word-PDF: «7 Formales», «7.3 Versionierung», «Anhang F – Formale Syntax …» ohne Nummer, also wie das Original. Die Querverweise («Kapitel 7.5», «1.3.4», «Anhang F») stimmen mit den sichtbaren Nummern überein.
- **Lösung B** (Vorlage ohne `numPr`): Word nummeriert nicht mehr, die Textnummern von Quarto bleiben (`Liste='' Text='7.5 Bearbeitungsstatus…'`). Die Nummern sind konsistent. Ebene 1 lautet aber «7. Formales» (mit Punkt, Quarto-Eigenheit), und die offizielle Vorlage muss verändert werden.
- Fusszeile (Befund S1): Mit `[eCH-0003]{#eCHNummer} – [Leitfaden …]{#eCHName} / [11.1.0]{#Version} / [Genehmigt]{#Status} / [2022-07-25]{#Ausgabedatum}` (nur DOCX) zeigt das Word-PDF «eCH-0003 – Leitfaden zur Genehmigung von Anträgen / 11.1.0 / Genehmigt / 2022-07-25».

### Konsequenz

- Mit drei kleinen Filtern lassen sich alle Verweisformen des Originals erzeugen, in HTML und DOCX. Vorschlag für die Schreibkonvention in Bausteinen:

  | Gewünschte Form | Quelle |
  |---|---|
  | «Kapitel 7.5» | `@sec-x` |
  | nur «1.3.4» | `-@sec-x` |
  | eigenes Präfix | `Unterkapitel -@sec-x` (normales Leerzeichen, nur Nummer verlinkt) oder `[Unterkapitel @sec-x]` (U+00A0, ganzer Text verlinkt) |
  | Nummer + Titel | `[@sec-x]{.mit-titel}` |
  | Anhänge | `@sec-anhang-x` |
  | Zitate | `«…»[@key]` |

- U+00A0: Es muss entschieden werden, ob «zeichengleich» auch Leerzeichen-Codepoints umfasst. Typografisch ist U+00A0 besser. Falls nötig, ersetzt ein Post-Filter es durch ein normales Leerzeichen [vermutet, trivial].
- DOCX: Lösung A übernehmen. Sie lässt die offizielle Vorlage unverändert, und die Nummern entsprechen dem eCH-Layout. Die Verweise bleiben statischer Text; das ist korrekt, solange Quarto und Word gleich zählen, was Lösung A sicherstellt. Echte Word-Felder (`REF sec-x \r \h`) wären per OpenXML-Rohinline denkbar [vermutet, nicht getestet].

---

## S4 – Attribute im Lua-Filter

### Frage

Kann ein Lua-Filter Baustein-Attribute lesen und formatabhängig einen Feedback-Link einsetzen (HTML ja, DOCX nein)? Welche Rolle spielt die Reihenfolge vor oder nach `quarto`? Verändert Quarto Attribute? Warnen Divs mit ID ohne Crossref-Präfix?

### Vorgehen

- Projekt `s4-luafilter/` (Gerüst und Bausteine aus S2).
- `filters/feedback.lua`:
  - Überschrift mit `bb`: danach ein `Div.feedback` mit Link «Feedback».
  - `Div.baustein`: Link am Ende des Divs.
  - Nur bei `quarto.doc.is_format("html")`.
  - URL: `https://github.com/ech-ch/beyond-pdf-demonstrator/issues/new?template=feedback.yml&title=<Feedback zu …>&baustein=<id>`, URL-kodiert.
- `filters/debug_pre.lua` und `filters/debug_post.lua` vor bzw. nach `quarto` schreiben die Header- und Div-Attribute nach stderr.
- Varianten:
  - Feedback-Filter nach `quarto` (`_quarto.yml`);
  - Feedback-Filter vor `quarto` (`varianten/_quarto-feedback-vor-quarto.yml`, Ausgabe nach `_out-pre/`);
  - Link in der Überschrift (`geruest-im-titel.qmd`, `feedback-pos: header`).
- Befehle: `quarto render`, `quarto render geruest.qmd --output-dir _out-pre` und `quarto pandoc lua logs/urltest.lua`.

### Ergebnis

**Links [getestet]:** Im HTML entstehen im ersten Lauf 6 Links (2 Überschriften mit `bb`, 4 Divs). Für den Umlaut-Test bekam 7.2 nachträglich ein `bb`-Attribut, seither sind es 7. Im DOCX steht 0× «Feedback» im XML und es gibt keine GitHub-Beziehung.

```html
<div class="feedback">
<p><a href="https://github.com/ech-ch/beyond-pdf-demonstrator/issues/new?template=feedback.yml&amp;title=Feedback%20zu%20Versionierung&amp;baustein=ech-0003-bb-versionierung" class="feedback-link" data-baustein="ech-0003-bb-versionierung">Feedback</a></p>
</div>
```

**Reihenfolge [getestet]:** Vor und nach `quarto` ergibt sich dasselbe HTML (h2-Tags identisch, gleiche URLs). Der einzige Unterschied: Nach `quarto` enthält der Überschrifteninhalt schon die Nummer. Wer den Titel aus der Überschrift ableitet, muss `Span.header-section-number` (HTML) bzw. die Textnummer (DOCX) entfernen.

**Was Quarto an den Attributen ändert [getestet, Debug-Log]:**

```
[S4-pre]  html Header L2 id=sec-versionierung classes=[] attrs={bb=ech-0003-bb-versionierung, typ=rule} text="Versionierung"
[S4-post] html Header L2 id=sec-versionierung classes=[] attrs={bb=ech-0003-bb-versionierung, number=7.3, typ=rule} text="7.3 Versionierung"
[S4-pre]  html Div id=bb-zielversion classes=[baustein] attrs={typ=requirement} blocks=1
[S4-post] html Div id=bb-zielversion classes=[baustein] attrs={typ=requirement} blocks=1
```

ID, Klassen, `bb` und `typ` bleiben erhalten. Quarto ergänzt nur `number=…` und setzt die Nummer vor den Inhalt. Divs bleiben unverändert. Erst der HTML-Writer fügt `data-number`, `class="anchored"` und `data-anchor-id` hinzu und kopiert die Attribute auf `<section>`.

**Warnungen [getestet]:** Für Div-IDs `bb-…` gibt es keine. [vermutet] IDs mit Präfixen wie `fig-`, `tbl-`, `lst-` oder `eq-` würde Quarto als Float- bzw. Crossref-Ziele interpretieren; das Präfix `bb-` ist sicher.

**Link in der Überschrift [getestet]:** Der Link landet im Inhaltsverzeichnis («7.3 Versionierung Feedback»). Er gehört deshalb in einen eigenen Block.

**Überraschung URL-Kodierung [getestet]:** Pandocs Lua läuft auch während `quarto render` mit `LC_CTYPE=German_Switzerland.1252`. Dadurch passt die Lua-Zeichenklasse `%w` auf das Byte 0xC3 (Log: `%w matcht Byte 0xC3: true`). Mit dem üblichen Muster `[^%w%-%._~]` werden Umlaute nur halb kodiert, «Zul\xC3%A4ssige», also ungültig. Die Korrektur mit der expliziten Klasse `[^A-Za-z0-9%-%._~]` liefert `title=Feedback%20zu%20Zul%C3%A4ssige%20Formate…&baustein=ech-0003-bb-zul%C3%A4ssige-formate`. [vermutet] Auf GitHub Actions (Linux, C/UTF-8-Locale) tritt das nicht auf, lokal unter Windows aber schon.

[nicht getestet] Ob GitHub das Feld `baustein` vorbefüllt, hängt davon ab, ob `feedback.yml` ein Feld mit `id: baustein` hat.

### Konsequenz

- Der Feedback-Filter ist machbar und klein (rund 50 Zeilen). Formatabhängigkeit über `quarto.doc.is_format("html")`, Ausgabe als eigener Block mit CSS-Klasse.
- Position: nach `quarto`, als einer der letzten Filter. Dort sind Nummern und Querverweise schon aufgelöst; beim Titel die Nummer abstreifen. Vor `quarto` funktioniert es ebenso.
- URL-Kodierung immer mit expliziter ASCII-Klasse, nie mit `%w`. Das gilt für alle Filter, die IDs oder Titel mit Umlauten verarbeiten.
- Baustein-IDs dürfen kein Quarto-Crossref-Präfix tragen. `bb-…` bzw. `ech-0003-bb-…` im Attribut ist unproblematisch.

---

## Gesamtbild

| Thema | Status |
|---|---|
| FOAG-Template HTML/Typst lokal | funktioniert [getestet] |
| DOCX mit offizieller Vorlage | doppelte und verschobene Nummern, kein Deckblatt, Fusszeilenfehler [getestet]; Nummern und Fusszeile mit Filter bzw. Textmarken lösbar [getestet], Deckblatt offen |
| Include + Attribute | funktioniert; YAML in Bausteinen gefährlich [getestet] |
| Verweisformen des Originals | alle erzeugbar, 2 kleine Filter nötig; U+00A0 statt Leerzeichen bei Präfix [getestet] |
| Feedback-Filter | funktioniert; Windows-Locale-Falle bei `%w` [getestet] |
