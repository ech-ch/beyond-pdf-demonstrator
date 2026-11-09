# Entwurf: Baustein-IDs für Kap. 6 und die Anhänge B, C, D (eCH-0003 V11.1.0)

Quelle: Original-PDF eCH-0003 V11.1.0, Seiten 26 und 34–36, Rohtext in `original/text/kap06.txt`, `anhang-b.txt`, `anhang-c.txt`, `anhang-d.txt`. Aufbau der Tabellen nach dem Word-Original geprüft. Regeln: MVP-Spezifikation 3.2 und 3.6, ADR 0002 und ADR 0004, E15, E29, E30.
Status: **Freigegebene Liste** (Projektleitung, 8.11.2026; Umsetzung AP22, E49). IDs werden mit der Veröffentlichung eingefroren (ADR 0002). Die `#`-Nummern (z.B. 6.2-1) sind nur Arbeitsnummern und nicht Teil der ID. Wie alle Bausteine ein initialer Vorschlag: für den MVP freigegeben, nicht fixiert (E53).

## Liste

**Grobe Bausteine** (Datei `bausteine/<kurzname>.md`, Anker `sec-<kurzname>`):

| Kap. | Baustein-ID | Typ | Einleitung beim groben Baustein (G2) |
|---|---|---|---|
| 6.1 | `ech-0003-bb-fachgruppendokument-einleitung` | `descriptive` | «Mit dem Fachgruppendokument soll den Fachgruppen …» |
| 6.2 | `ech-0003-bb-fachgruppendokument-publikation` | `process` | – |
| Anhang B | `ech-0003-bb-abkuerzungen` | `concept` | ganze Tabelle (8 Einträge) |
| Anhang C | `ech-0003-bb-glossar` | `concept` | beide Einleitungen und beide Tabellen (6 und 12 Einträge) |
| Anhang D | `ech-0003-bb-aenderungsuebersicht` | `descriptive` | «Dieser Anhang bezieht sich auf …» und die Tabelle |

**Feine Bausteine** (alle Typ `requirement`; Verbindlichkeit aus der Kennzeichnung):

| # | Baustein-ID | Verbindlichkeit | Original-Seite | `bezug` (E30) | Wortanfang |
|---|---|---|---|---|---|
| 6.1-1 | `ech-0003-bb-fachgruppendokument-ohne-normative-funktion` | DARF NICHT | 26 | – | «Fachgruppendokumente haben keinerlei normative Funktionen …» |
| 6.2-1 | `ech-0003-bb-fachgruppendokument-publikation-freigabe` | MUSS | 26 | – | «Die Publikation erfolgt in Absprache mit der Geschäftsstelle …» |
| 6.2-2 | `ech-0003-bb-fachgruppendokument-ohne-ech-nummer` | DARF NICHT | 26 | – | «Fachgruppendokumente erhalten keine eCH-Nummer …» |
| 6.2-3 | `ech-0003-bb-fachgruppendokument-publikationsort` | MUSS | 26 | – | «Fachgruppendokumente werden im Publikationsbereich …» |
| C-1 | `ech-0003-bb-reservierte-begriffe-anpassen` | MUSS | 35 | – | «Diese reservierten Begriffe dürfen in den Vorlagen nur …» |

Zählung aus dem Rohtext: Kap. 6 2× MUSS, 2× DARF NICHT; Anhang C 1× MUSS; Anhänge B und D ohne Kennzeichnung.

**Feste Anker ohne Baustein** (E05):

| Kap. | Anker | Grund |
|---|---|---|
| 6 | `sec-fachgruppendokument` | Kapitel ohne eigenen Text, wie `sec-formales` bei Kap. 7; Beginn des Textvergleichs |
| 2.1.4 | `sec-standard-datenschemata` | Verweisziel aus Anhang D; Antragsform im Anker (siehe Hinweis 1) |

Neue Verweisziele ohne Baustein (W2), Stand AP22: 1.1 (aus Anhang D), 1.3.4 (aus Anhang D, schon aus 7.3 und 7.8), 1.3.9 (aus Anhang C und D), 1.3.10 (aus Anhang C), 2.1.4 (aus Anhang D). Nachtrag AP23 (E50): 1.3.4, 1.3.9 und 1.3.10 sind jetzt Bausteine ([bausteine-1-3.md](bausteine-1-3.md)); 1.1 ist als «Statustext» markiert; «noch kein Baustein» bleibt nur 2.1.4.

## Hinweise und Grenzfälle

1. **Kurznamen mit Antragsform.** Kap. 2–6 haben gleichlautende Unterkapitel («Einleitung», «Publikation», «Erarbeitung» …). Die Kurznamen und Anker tragen deshalb die Antragsform (`fachgruppendokument-…`, `sec-standard-datenschemata`), auch wo heute noch keine Kollision besteht (Auffälligkeit 6 in [kap7-bausteine.md](kap7-bausteine.md)). Die Labels bleiben unter 50 Zeichen; das längste ist `bb:fachgruppendokument-ohne-normative-funktion` (46).
2. **6.1-1 ist ein Verbot ohne Handlung.** «[DARF NICHT] Fachgruppendokumente haben keinerlei normative Funktionen …» beschreibt eher eine Eigenschaft als ein Verbot. Der Baustein bildet die Kennzeichnung des Originals ab; der Build interpretiert nichts (V3).
3. **6.2-3 mit Link.** «Webseite» ist im Word-Original auf `http://www.ech.ch` verlinkt und wird nach F53 übernommen; der Text bleibt gleich.
4. **Anhang B als grober Baustein mit Tabelle in der Quelle** (wie Anhang F), nicht als Daten mit eigener Feedback-ID (wie Anhang A). Die Reihenfolge folgt dem Original, auch wo sie nicht alphabetisch ist (QS nach UML).
5. **Anhang C, Klausel und zweite Tabelle (G1).** Nach G1 reichte die Klausel C-1 bis zum Ende des Anhangs und umfasste damit die zweite Tabelle. Nach E15 gehören die Einträge aber zum groben Baustein; die Klausel umfasst nur ihren Absatz. Die Verweise in den Einträgen sind deshalb Beziehungen des groben Bausteins `glossar`, nicht der Klausel. «Diese reservierten Begriffe» bezieht sich auf die Einleitung des eigenen groben Bausteins zurück und wird nach E30 nicht als `bezug` erfasst.
6. **Anhang C, Verweise mit Titel.** «gemäss Kapitel 7.1 Zuteilung einer eCH-Nummer» und die übrigen acht Stellen sind erzeugte Querverweise mit Titel (`[-@sec-…]{.mit-titel}`, E11), «gemäss Kapitel 1.2.» nur mit Nummer. Der Text ist zeichengleich mit dem Original (HTML und Word geprüft).
7. **Anhang D, ID.** `aenderungsuebersicht` bezeichnet die Rolle des Anhangs (Übersicht der Änderungen gegenüber der Vorversion), nicht die Version, weil der Inhalt mit jeder Version wechselt. Sie unterscheidet sich klar vom Mehrfachbaustein `ech-0003-bb-aenderungen-vorversion`, der Klausel aus 7.8 und 7.9, die ein solches Kapitel verlangt. Erwogen: `aenderungsprotokoll` (Verwechslung mit dem «Protokoll in Textform» aus 7.3-7), `aenderungen-gegenueber-vorversion` (zu nahe an der Klausel), `aenderungsnachweis`.
8. **Anhang D, Tabelle.** Im Word-Original gibt es keine zusammengefassten Zellen. «1.3.4 / 1.3.9» steht in einer Zelle, die Seite bei «Beilage» ist leer, die graue Kopfzeile wiederholt sich auf Seite 36. Die Kapitelnummern sind erzeugte Querverweise, «Div.» und «Beilage» bleiben Text. Die Seitenangaben bleiben wörtlich; sie beziehen sich auf das Original (E49, F57).
9. **Anhang D, «Kapitel 1.1 Status».** Erzeugter Verweis mit Titel. 1.1 ist erzeugter Inhalt (Statustext) und wird nie ein Baustein. Das Ziel war deshalb falsch als «noch kein Baustein» markiert; seit AP23 trägt es die eigene Zielart `statustext` (E50).
