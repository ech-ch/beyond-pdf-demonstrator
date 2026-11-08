# Rohtext aus dem Original

Text von eCH-0003 V11.1.0, aus [../eCH-0003_V11.1.0_d.pdf](../eCH-0003_V11.1.0_d.pdf) extrahiert mit [tools/extrahiere_rohtext.py](../../tools/extrahiere_rohtext.py) (Überführung, Schritt 1, E19). Die Dateien sind erzeugt; von Hand wird hier nichts geändert. Sie sind die Vorlage für das Strukturieren (Schritt 2) und die Referenz für den Textvergleich in der CI (Schritt 3).

| Datei | Inhalt | Seiten |
|---|---|---|
| `kap01-1.1-bis-1.2.1.txt` | 1 Einleitung, 1.1 Status, 1.2 Anwendungsgebiet, 1.2.1 Beschreibungsterminologie | 6 |
| `kap01-1.3.txt` | 1.3 Prozessmodule, mit der Bildunterschrift von Abbildung 1 | 6–7 |
| `kap01-1.3.1.txt` | 1.3.1 Erarbeitung | 7 |
| `kap01-1.3.2.txt` | 1.3.2 Formale Qualitätssicherung 1 | 7–8 |
| `kap01-1.3.3.txt` | 1.3.3 Inhaltliche Qualitätssicherung 1 | 8–9 |
| `kap01-1.3.4.txt` | 1.3.4 Öffentliche Konsultation | 10 |
| `kap01-1.3.5.txt` | 1.3.5 Einarbeitung Rückmeldungen | 10–11 |
| `kap01-1.3.6.txt` | 1.3.6 Formale Qualitätssicherung 2 | 11 |
| `kap01-1.3.7.txt` | 1.3.7 Inhaltliche Qualitätssicherung 2 | 11 |
| `kap01-1.3.8.txt` | 1.3.8 Genehmigung/Ablehnung | 11 |
| `kap01-1.3.9.txt` | 1.3.9 Publikation | 12 |
| `kap01-1.3.10.txt` | 1.3.10 Überprüfung | 12 |
| `kap01-1.4.txt` | 1.4 Fristen und Termine, mit der Bildunterschrift von Abbildung 2 | 13 |
| `kap06.txt` | 6 Fachgruppendokument, 6.1–6.2 | 26 |
| `kap07.txt` | 7 Formales, 7.1–7.10 | 27–32 |
| `kap08.txt` | 8 Sicherheitsüberlegungen | 32 |
| `kap09.txt` | 9 Haftungsausschluss/Hinweise auf Rechte Dritter (Vorlagentext 2022) | 33 |
| `kap10.txt` | 10 Urheberrechte (Vorlagentext 2022) | 33 |
| `anhang-a.txt` | Anhang A – Referenzen & Bibliographie | 34 |
| `anhang-b.txt` | Anhang B – Abkürzungen | 34 |
| `anhang-c.txt` | Anhang C – Glossar | 34–35 |
| `anhang-d.txt` | Anhang D – Änderungen gegenüber Vorversion | 35–36 |
| `anhang-f.txt` | Anhang F – Formale Syntax für die Versionierung | 36 |
| `inhaltsverzeichnis.tsv` | alle 92 Überschriften des Inhaltsverzeichnisses: Ebene, Nummer, Titel, Seite, ob eigener Text darunter steht | 2–4 |

## Format

- Jede Überschrift steht als eigener Absatz mit ihrer Nummer wie im Original («7.3 Versionierung», «Anhang F – Formale Syntax …»).
- Absätze sind durch eine Leerzeile getrennt.
- Aufzählungspunkte beginnen mit `- ` und stehen ohne Leerzeile untereinander.
- Eine Tabelle ergibt eine Zeile je Tabellenzeile; die Zellen trennt ein Tabulator, eine leere Zelle bleibt leer (Anhang D, «Beilage»).
- Eine Kopfzeile, die sich nach einem Seitenwechsel wiederholt, steht nur einmal (Anhang D, Seite 36).
- Codeblöcke (EBNF in Anhang F) bleiben zeilengenau erhalten, mit dem Einzug aus dem PDF.
- Ein Zwischentitel (1.3.2, 1.3.3; Formatvorlage «Untertitel» im Word-Original) steht als eigener Absatz, ohne Aufzählungszeichen.
- Von einer Abbildung steht nur die Bildunterschrift da («Abbildung 1 – Genehmigungsprozess»); der Text in der Abbildung fällt weg. Das Bild schneidet [tools/schneide_abbildungen.py](../../tools/schneide_abbildungen.py) aus dem PDF.
- `--- Seite N ---` steht vor dem ersten Absatz, der auf Seite N beginnt. Ein Absatz gehört also zur Seite der letzten Marke davor (Herkunft, `original-seite`).

## Was das Skript bereinigt, und was nicht

Bereinigt werden nur Artefakte der Extraktion (E06):

- Kopf- und Fusszeilen
- Silbentrennung am Zeilenende, einschliesslich der alten Trennung «k-k» («lük-kenlose» → «lückenlose»). Ein Bindestrich vor einem Grossbuchstaben bleibt («eCH-Nummer»).
- das Aufzählungszeichen (U+F0B7 → `- `)
- Zeilenumbrüche innerhalb eines Absatzes

Fehler des Originals bleiben zeichengleich stehen, etwa «Die Nummer sind» (7.3), «nummerisch» (7.9), «Er darf nicht mehr genutzt werden» (7.5) und das abschliessende «):» in Anhang F.

## Prüfung gegen das PDF (2.11.2026)

- Zählung Kap. 7: 36 × [MUSS], 11 × [SOLLTE], 8 × [DARF NICHT], alle am Absatzanfang.
- Alle 92 Überschriften des Inhaltsverzeichnisses wurden im Text gefunden.
- Unsichere Stellen aus dem Protokoll des Skripts wurden am gerenderten PDF geprüft:
  - S. 27: «… z.B. «3.7.1»» / «Die Nummer sind …» / «Hauptversionen (Major) …» sind im PDF drei Absätze mit kleinem Abstand. Das Skript trennt sie richtig.
  - S. 36: «… ohne optionale Ergänzungen» / «lautet wie folgt:» ist ein Satz. Das Skript übergeht den grösseren Zeilenabstand richtig.
  - S. 28: «lük-kenlose» → «lückenlose» ist die einzige alte Trennung «k-k» in diesen Kapiteln.
- Anhang C: Die Tabelle wurde zellenweise gelesen. «Referentinnen und Referenten» (Begriff) und «Referentinnen und Referenten des Expertenausschusses» (Bezeichnung) stehen in zwei Zellen. Die Lesart «Referentinnen und Referentinnen und Referenten» entsteht nur beim zeilenweisen Lesen über beide Zellen und ist kein Fehler des Originals (F39).
- Seite 27 (unterer Teil) und Seite 34 wurden zusätzlich als Bild mit dem Rohtext verglichen; Seite 6 (Tabelle 1.2.1) über die drei Lesemodi von pdftotext, die zellenweise übereinstimmen.

## Prüfung gegen das Word-Original (8.11.2026, AP22)

- Kap. 6, Anhang B und D wurden mit dem Word-Original von V11.1.0 verglichen (nur gelesen, nicht im Repo).
- Anhang D hat drei Spalten und keine zusammengefassten Zellen. «1.3.4 / 1.3.9» steht im Original mit Leerzeichen; das Skript verbindet «1.3.4 /» und «1.3.9» deshalb mit Leerzeichen. Bei «Beilage» ist die Seite leer. Die Kopfzeile wiederholt sich im Original auf Seite 36 (Tabellenkopf auf jeder Seite).
- Anhang B: Die Reihenfolge ist wie im Original nicht ganz alphabetisch (QS nach UML).
- Die schon vorhandenen Rohtexte sind nach dem erneuten Lauf unverändert.

## Prüfung gegen das Word-Original (8.11.2026, AP23)

- 1.3.4, 1.3.9 und 1.3.10 stimmen Absatz für Absatz mit dem Word-Original überein (12, 5 und 3 Absätze; nur gelesen, nicht im Repo). Das bestätigt auch die Absatzgrenzen der beiden Absätze ohne Kennzeichnung.
- Die Verweise auf 7.8, 7.9 und 1.3.4 sind im Word-Original Felder (REF). Verlinkt sind «Webseite» und «Newsübersicht» in 1.3.4 (`https://www.ech.ch/`) und «Webseite» in 1.3.9 (`http://www.ech.ch`).
- Die schon vorhandenen Rohtexte sind nach dem erneuten Lauf unverändert.

## Prüfung gegen das Word-Original (8.11.2026, AP25)

- Alle zwölf Unterkapitel von 1.3 und 1.4 stimmen Absatz für Absatz mit dem Word-Original überein (nur gelesen, nicht im Repo).
- Drei neue Fälle im Skript: Zwischentitel stehen im PDF mit Aufzählungszeichen am linken Rand und werden eigene Absätze; der Text in den Abbildungen 1 und 2 fällt weg; auf Seite 13 ist «… dauert mindestens sechs Wochen.» / «Die anschliessende Überarbeitung …» ein Zeilenumbruch und keine Absatzgrenze (im Word-Original ein Absatz; Ausnahmeliste `KEIN_ABSATZ`, weil die Zeilenlänge es nicht entscheidet: 7.3 hat echte Absatzgrenzen nach vollen Zeilen).
- Der Aufzählungspunkt «Deckblatt mit den Metadaten (vgl. 2. Teil von» / «Anhang C – Glossar)» in 1.3.2 ist im PDF und im Word-Original in zwei Punkte geteilt, weil das Feld REF eine Absatzmarke enthält. Der Rohtext folgt dem PDF.
- Im Word-Original beginnt die erste Klausel von 1.3.2 mit einem Leerzeichen; der Rohtext lässt es weg wie jeden Leerraum am Absatzanfang.
- Die schon vorhandenen Rohtexte sind nach dem erneuten Lauf unverändert.

## Werkzeug

pdftotext 4.00 (Xpdf, in Git for Windows enthalten). Der Text stammt aus dem Modus `-simple`, weil er Tabellen zellenweise richtig liest; der Modus `-layout` liefert nur die Leerzeilen als Hinweis auf Absätze (E24). Poppler-pdftotext (Linux) kennt `-simple` nicht. Das Skript läuft deshalb nicht in der CI, die Ergebnisse sind committet.
