# Spike-Protokoll

Kurze technische Tests (≤ 15 Min. je Spike) zur Absicherung von Entscheiden. Format je Spike: Frage, Vorgehen, Ergebnis, Konsequenz. Kennzeichnung: **[getestet]** = durch Render und Auswertung belegt, **[vermutet]** = abgeleitet.

Umgebung: Quarto 1.10.19 (mit Pandoc und Typst), Windows 11, Word 16 für die Sichtprüfung. Durchgeführt am 2.11.2026. Testquellen und ausführliches Protokoll: [spikes/](spikes/README.md).

## S1 – FOAG-Template rendern

**Frage:** Lässt sich der Dokumentteil des FOAG-Templates ohne die RDF-Pipeline als HTML, DOCX und PDF rendern? Wie sieht das Word mit der offiziellen eCH-Vorlage aus?

**Vorgehen:**

- `semantic-web-template/docs` kopiert.
- Vier Includes auf generierte Fragmente und den R-Chunk entfernt, nur `de` gerendert.
- Das Word mit Word-COM ausgewertet. Abgefragt wurde, welche Nummern Word sichtbar anzeigt.
- Die Vorlagen-URL mit `curl` geprüft.

**Ergebnis:**

- HTML (16 s), DOCX (3 s) und Typst-PDF (8 s) rendern fehlerfrei. [getestet]
- Die Vorlage auf ech.ch (HTTP 200) und die lokale Vorlage sind byteidentisch. Ohne lokale Kopie hängt der Build vom Netz ab. [getestet]
- Das Word hat **kein Deckblatt**. Es enthält nur Titel, Datum, Zusammenfassung und Inhaltsverzeichnis. Ein Deckblatt mit Metadatentabelle gibt es nur im Typst-PDF. [getestet]
- **Doppelte Nummerierung:** Die eCH-Vorlage nummeriert «Überschrift 1–9» automatisch (`numPr` in `styles.xml`). Quarto schreibt die Nummer zusätzlich als Text. Zudem zählt Word das unnummerierte «Hinweis» mit. Sichtbar wird deshalb «2 1. Einleitung», und die Anhänge laufen als 10–15. [getestet]
- Die **Fusszeile** zeigt 5× «Fehler! Verweisquelle konnte nicht gefunden werden». Die Felder `REF eCHNummer`, `eCHName`, `Version`, `Status` und `Ausgabedatum` verweisen auf Textmarken im Körper der Vorlage, und diesen Körper verwirft Pandoc. [getestet]
- Elf von Pandoc verwendete Formatvorlagen fehlen in der eCH-Vorlage, etwa `FirstParagraph` und `Compact`. Sie erscheinen im Pandoc-Standardaussehen. [getestet]
- In einem Website-Projekt löscht `quarto render --to X` die Ausgaben der anderen Formate. [getestet]

**Konsequenz:**

- HTML und PDF aus dem FOAG-Template sind direkt nutzbar.
- Für DOCX braucht es:
  - eine Lösung für die Nummerierung (S3, Lösung A)
  - ein eigenes Deckblatt (offen, C3)
  - Textmarken für die Fusszeile (S3)
- Die Referenzvorlage gehört als Datei ins Repo.
- Alle Formate werden in einem einzigen `quarto render`-Aufruf erzeugt.

## S2 – Einbinden mit Attributen

**Frage:** Kommen IDs und Attribute von Überschriften und `:::`-Blöcken aus eingebundenen Dateien in HTML und DOCX an? Was passiert mit einer YAML-Kopfzeile in einer eingebundenen Datei? Taugt eine ID ohne `sec-` als Verweisziel?

**Vorgehen:** Minimalprojekt mit Gerüst und Baustein `versionierung.md`. Die Datei beginnt mit `## Versionierung {#sec-versionierung bb="ech-0003-bb-versionierung" typ="rule"}` und enthält vier `:::`-Blöcke. Getestet wurden zusätzlich die Varianten «YAML-Kopfzeile im Baustein» und «ID ohne `sec-`».

**Ergebnis:**

- IDs, Klassen und Attribute überleben `{{< include >}}`, auch verschachtelt. Die Nummerierung über die Einbindung hinweg stimmt (7.3, 7.4). [getestet]
- Im HTML werden eigene Attribute zu `data-bb` und `data-typ`. Im DOCX entstehen Textmarken mit dem ID-Namen. `bb`, `typ` und die Klasse `.baustein` gehen im DOCX verloren. [getestet]
- Eine **YAML-Kopfzeile im Baustein** erzeugt weder Fehler noch Warnung. Sie wird still in die Metadaten des Gesamtdokuments übernommen, wobei der letzte Baustein gewinnt. Ein `title:` darin **überschreibt den Dokumenttitel**. [getestet, nachgeprüft]
- Eine ID ohne `sec-` funktioniert als Anker und Linkziel, aber **nicht als Querverweisziel**. Quarto behandelt `@ech-0003-bb-…` als Literaturzitat. Ohne Literaturverzeichnis bleibt der Text ohne Warnung stehen, mit Literaturverzeichnis wird daraus «…?». [getestet]

**Konsequenz:**

- Das Quellmodell Gerüst mit Baustein-Dateien trägt.
- Überschriften-IDs, auf die verwiesen wird, müssen mit `sec-` beginnen. Die stabile Baustein-ID gehört in ein Attribut (B2, B3).
- YAML in Baustein-Dateien muss eine Prüfung in der CI verbieten.

## S3 – Querverweis-Varianten

**Frage:** Kann der Build alle Verweisformen des Originals zeichengleich erzeugen, in HTML und DOCX? Stimmen die Nummern im Word?

**Vorgehen:**

- Gerüst nach dem Original (Kap. 1–10, Anhang A–F), darin eingebunden 7.3, 7.8 und Anhang C.
- Acht Testfälle (T1–T8), automatisch mit Soll/Ist ausgewertet.
- Literaturverzeichnis mit FOAG-CSL und `ech_citations.lua`.
- Drei eigene Lua-Filter.

**Ergebnis:** [getestet, HTML und DOCX identisch]

| Original | Quelle im Baustein | zeichengleich? |
|---|---|---|
| (siehe Kapitel 7.5) | `(siehe @sec-x)` | optisch; Quarto setzt ein geschütztes Leerzeichen (U+00A0) zwischen «Kapitel» und Nummer |
| (siehe 1.3.4) | `(siehe -@sec-x)` | ja |
| gemäss Unterkapitel 1.3.4 | `gemäss Unterkapitel -@sec-x` | ja |
| Anhang F unten | `@sec-anhang-f unten` | nur mit Filter `ech_anhang.lua`; Quarto kann Anhänge ausserhalb von Book-Projekten nicht als Verweisziel auflösen |
| gemäss Kapitel 7.1 Zuteilung einer eCH-Nummer | `gemäss [@sec-x]{.mit-titel}` | nur mit Filter `ech_titelref.lua` (Nummer und Titel) |
| «Semantic Versioning»[SemVer] | `«Semantic Versioning»[@SemVer]` | ja (FOAG-CSL) |

- Im DOCX sind Verweise statischer Text mit internem Hyperlink auf die Textmarke, keine Word-Felder. [getestet]
- Mit Standardeinstellungen widersprechen die Verweise den sichtbaren Nummern: Der Text sagt «Kapitel 7.5», Word zeigt «8.5 7.5 Bearbeitungsstatus …». [getestet]
- **Lösung A** (Filter `ech_docx_nummern.lua`, nur DOCX) entfernt die Textnummern von Quarto und überlässt das Nummerieren Word. Unnummerierte Überschriften und Anhänge kommen in die nicht nummerierten Formatvorlagen der eCH-Vorlage, «Nebentitel» bzw. «Anhang Überschrift». In Word geprüft: Nummern und Verweise stimmen überein, die Anhänge haben keine Nummer, die Vorlage bleibt unverändert. [getestet]
- **Lösung B** (Vorlage ohne automatische Nummerierung) ist ebenfalls konsistent. Ebene 1 lautet dann aber «7. Formales» mit Punkt, und die offizielle Vorlage muss verändert werden. [getestet]
- Die Fusszeile wird korrekt, wenn im DOCX Spans mit den IDs `eCHNummer`, `eCHName`, `Version`, `Status` und `Ausgabedatum` stehen. [getestet]

**Konsequenz:**

- Alle Verweisformen sind erzeugbar, mit zwei kleinen Filtern für «Anhang X» und «Nummer + Titel».
- Für DOCX ist Lösung A zu bevorzugen (C3/F23).
- Offen für B7: Gilt «zeichengleich» auch für das geschützte Leerzeichen?

## S4 – Attribute im Lua-Filter

**Frage:** Kann ein Lua-Filter Baustein-Attribute lesen und nur in HTML einen Feedback-Link setzen?

**Vorgehen:** Filter `feedback.lua`.

- Nach jeder Überschrift mit `bb` und am Ende jedes `.baustein`-Blocks setzt er einen Link auf `…/issues/new?template=feedback.yml&title=…&baustein=<id>`, nur für HTML.
- Debug-Filter vor und nach `quarto` zeigen, was Quarto an den Attributen ändert.

**Ergebnis:**

- Im HTML entsteht ein Link je Baustein, im DOCX keiner. [getestet]
- Quarto lässt ID, Klassen, `bb` und `typ` stehen und ergänzt nur `number`. Ob der Filter vor oder nach `quarto` läuft, ergibt dasselbe HTML. Danach steht im Überschriftentext bereits die Nummer. [getestet]
- Steht der Link in der Überschrift, erscheint «Feedback» im Inhaltsverzeichnis. Er gehört deshalb in einen eigenen Block. [getestet]
- **Windows-Falle:** Lua-`%w` erkennt unter `German_Switzerland.1252` Umlaut-Bytes als Buchstaben, und die URL-Kodierung wird ungültig. Die explizite Klasse `[^A-Za-z0-9%-%._~]` löst das. [getestet]
- Ob GitHub das Feld `baustein` vorbefüllt, hängt vom Issue-Formular ab (Session 3). [nicht getestet]

**Konsequenz:**

- Der Feedback-Filter ist klein, etwa 50 Zeilen.
- Er läuft als später Filter nach `quarto` und setzt den Link als eigenen Block.
- Alle Filter kodieren URLs nur mit expliziter ASCII-Klasse.
- IDs von `:::`-Blöcken (feine Bausteine) dürfen nicht mit einem Querverweis-Präfix von Quarto beginnen, etwa `fig-`, `tbl-`, `lst-` oder `eq-`. `bb-…` ist sicher.
