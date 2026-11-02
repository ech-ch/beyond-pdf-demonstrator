# Rohtext aus dem Original

Text von eCH-0003 V11.1.0, aus [../eCH-0003_V11.1.0_d.pdf](../eCH-0003_V11.1.0_d.pdf) extrahiert mit [tools/extrahiere_rohtext.py](../../tools/extrahiere_rohtext.py) (Überführung, Schritt 1, E19). Die Dateien sind erzeugt; von Hand wird hier nichts geändert. Sie sind die Vorlage für das Strukturieren (Schritt 2) und die Referenz für den Textvergleich in der CI (Schritt 3).

| Datei | Inhalt | Seiten |
|---|---|---|
| `kap01-1.1-bis-1.2.1.txt` | 1 Einleitung, 1.1 Status, 1.2 Anwendungsgebiet, 1.2.1 Beschreibungsterminologie | 6 |
| `kap07.txt` | 7 Formales, 7.1–7.10 | 27–32 |
| `kap08.txt` | 8 Sicherheitsüberlegungen | 32 |
| `kap09.txt` | 9 Haftungsausschluss/Hinweise auf Rechte Dritter (Vorlagentext 2022) | 33 |
| `kap10.txt` | 10 Urheberrechte (Vorlagentext 2022) | 33 |
| `anhang-a.txt` | Anhang A – Referenzen & Bibliographie | 34 |
| `anhang-c.txt` | Anhang C – Glossar | 34–35 |
| `anhang-f.txt` | Anhang F – Formale Syntax für die Versionierung | 36 |
| `inhaltsverzeichnis.tsv` | alle 92 Überschriften des Inhaltsverzeichnisses: Ebene, Nummer, Titel, Seite, ob eigener Text darunter steht | 2–4 |

## Format

- Jede Überschrift steht als eigener Absatz mit ihrer Nummer wie im Original («7.3 Versionierung», «Anhang F – Formale Syntax …»).
- Absätze sind durch eine Leerzeile getrennt.
- Aufzählungspunkte beginnen mit `- ` und stehen ohne Leerzeile untereinander.
- Eine zweispaltige Tabelle ergibt eine Zeile je Tabellenzeile; die Zellen trennt ein Tabulator.
- Codeblöcke (EBNF in Anhang F) bleiben zeilengenau erhalten, mit dem Einzug aus dem PDF.
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

## Werkzeug

pdftotext 4.00 (Xpdf, in Git for Windows enthalten). Der Text stammt aus dem Modus `-simple`, weil er Tabellen zellenweise richtig liest; der Modus `-layout` liefert nur die Leerzeilen als Hinweis auf Absätze (E24). Poppler-pdftotext (Linux) kennt `-simple` nicht. Das Skript läuft deshalb nicht in der CI, die Ergebnisse sind committet.
