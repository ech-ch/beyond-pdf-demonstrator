# Entwurf: Baustein-IDs für Kap. 2–5 (eCH-0003 V11.1.0)

Quelle: Original-PDF eCH-0003 V11.1.0, Seiten 14–25, Rohtext in `original/text/kap02.txt` bis `kap05.txt` (AP26, Absatz für Absatz gegen das Word-Original geprüft). Regeln: [MVP-Spezifikation 3.2 und 3.6](mvp-spezifikation.md), ADR 0002, E50 (Kurzname mit der Antragsform vorne), E55, E56.
Status: **Freigegebene Liste** (Projektleitung, 9.11.2026; Umsetzung AP27, E55, E56). IDs werden mit der Veröffentlichung eingefroren (ADR 0002). Wie bei allen Bausteinen gilt E53: Zuschnitt, Darstellung und Namen sind ein initialer Vorschlag, für den MVP gedacht, nicht fixiert.

## Zuschnitt

- **Grobe Bausteine je Unterkapitel** (E55): jede Überschrift unter Kap. 2–5, wie im Original. Die Kapitelüberschriften 2–5 bleiben ohne Baustein, wie die von Kap. 1, 6 und 7.
- **Keine feinen Bausteine.** Die 38× MUSS, 15× SOLLTE und 1× DARF NICHT stehen im Text der groben Bausteine. Diese tragen die Klasse `.klauseln-im-text`; nur dort lässt `tools/pruefe.py` Kennzeichnungen ausserhalb eines feinen Bausteins zu. F26 (parametrisierte Bausteine, Mehrfachverwendung, abweichende Verbindlichkeiten) bleibt offen ([ausbau.md](ausbau.md) J).
- **Kurzname:** Antragsform vorne (`standard-`, `best-practice-`, `hilfsmittel-`, `white-paper-`), danach der Titel wie bei den Kurznamen in Kap. 1 (E50): `erarbeitung`, `formale-qualitaetssicherung-1`, `genehmigung-ablehnung` (2.3.7 heisst im Original «Genehmigung oder Ablehnung», 3.3.7, 4.3.4 und 5.3.7 «Genehmigung/Ablehnung»), `publikation`, `ueberpruefung`. «Öffentliche Konsultation und Einarbeitung Rückmeldungen» wird `konsultation-und-einarbeitung`, weil `best-practice-oeffentliche-konsultation-einarbeitung-rueckmeldungen` das Label über 50 Zeichen brächte (E38). Am Limit liegen `best-practice-inhaltliche-qualitaetssicherung-1` und `-2` (Label `bb:…` genau 50 Zeichen).
- **Typ:** Einleitung `descriptive` (wie 1.2 Anwendungsgebiet); 2.1.1–2.1.3 `concept` (die drei Arten von Standards, die 2.1 nennt; wie 1.2.1 Beschreibungsterminologie); 2.1.4 Datenschemata `rule` (wie 7.2, 7.3); Antragstellende `governance` (wer einen Antrag stellen darf; wie 7.6, 7.7); Prozess und die Prozessschritte `process` (wie 1.3.x).
- **Anker** `sec-<kurzname>`. Die Anker von 2.1.1–2.1.4 und 2.2 bestanden schon (AP26) und folgen bereits diesem Schema; die Querverweise darauf sind erzeugt.
- **Abbildungen 3–6** gehören zum groben Baustein «Prozess» der Antragsform; ihre Bildunterschrift steht im Wortlaut des Feedbacks (E56).

## Prüfung auf Kollisionen

- Die 49 neuen IDs kollidieren mit keiner der 153 IDs aus dem Stand `beac168` (31 grobe, 122 feine Bausteine); auch kein Kurzname ist gleich.
- Kein Label `bb:<kurzname>` ist länger als 50 Zeichen, keines ist gleich `bb:gesamt`, `bb:referenzen` oder `bb:unbekannt`.
- Von den Ankern bestanden nur die fünf aus AP26 (2.1.1–2.1.4, 2.2), für dieselben Überschriften.
- Die Kennungen der Kapitel aus AP26 (`ech-0003-kapitel-standard`, `-best-practice`, `-hilfsmittel`, `-white-paper`) entfallen; kein Issue verwendet sie (E55). Ein neues Issue mit einer davon erhielte `bb:unbekannt`.

## Liste

**2 Standard** (Kapitelüberschrift `sec-standard`, ohne Baustein)

| Kap. | Titel | Baustein-ID | Typ | Seite | Anker | Klauseln im Text |
|---|---|---|---|---|---|---|
| 2.1 | Einleitung | `ech-0003-bb-standard-einleitung` | `descriptive` | 14 | `sec-standard-einleitung` | 1× SOLLTE |
| 2.1.1 | Interoperabilitätsstandard | `ech-0003-bb-standard-interoperabilitaetsstandard` | `concept` | 14 | `sec-standard-interoperabilitaetsstandard` | 1× SOLLTE |
| 2.1.2 | Verfahrensstandard | `ech-0003-bb-standard-verfahrensstandard` | `concept` | 14 | `sec-standard-verfahrensstandard` | – |
| 2.1.3 | Referenzierter Fremdstandard | `ech-0003-bb-standard-referenzierter-fremdstandard` | `concept` | 14 | `sec-standard-referenzierter-fremdstandard` | 2× MUSS, 1× SOLLTE, 1× DARF NICHT |
| 2.1.4 | Datenschemata | `ech-0003-bb-standard-datenschemata` | `rule` | 15 | `sec-standard-datenschemata` | 1× MUSS, 2× SOLLTE |
| 2.2 | Antragstellende | `ech-0003-bb-standard-antragstellende` | `governance` | 15 | `sec-standard-antragstellende` | – |
| 2.3 | Prozess | `ech-0003-bb-standard-prozess` | `process` | 15 | `sec-standard-prozess` | – |
| 2.3.1 | Erarbeitung | `ech-0003-bb-standard-erarbeitung` | `process` | 15 | `sec-standard-erarbeitung` | 2× MUSS |
| 2.3.2 | Formale Qualitätssicherung 1 | `ech-0003-bb-standard-formale-qualitaetssicherung-1` | `process` | 16 | `sec-standard-formale-qualitaetssicherung-1` | 1× SOLLTE |
| 2.3.3 | Inhaltliche Qualitätssicherung 1 | `ech-0003-bb-standard-inhaltliche-qualitaetssicherung-1` | `process` | 16 | `sec-standard-inhaltliche-qualitaetssicherung-1` | 2× MUSS |
| 2.3.4 | Öffentliche Konsultation und Einarbeitung Rückmeldungen | `ech-0003-bb-standard-konsultation-und-einarbeitung` | `process` | 16 | `sec-standard-konsultation-und-einarbeitung` | – |
| 2.3.5 | Formale Qualitätssicherung 2 | `ech-0003-bb-standard-formale-qualitaetssicherung-2` | `process` | 16 | `sec-standard-formale-qualitaetssicherung-2` | – |
| 2.3.6 | Inhaltliche Qualitätssicherung 2 | `ech-0003-bb-standard-inhaltliche-qualitaetssicherung-2` | `process` | 16 | `sec-standard-inhaltliche-qualitaetssicherung-2` | 1× MUSS, 1× SOLLTE |
| 2.3.7 | Genehmigung oder Ablehnung | `ech-0003-bb-standard-genehmigung-ablehnung` | `process` | 16 | `sec-standard-genehmigung-ablehnung` | 1× MUSS, 2× SOLLTE |
| 2.3.8 | Publikation | `ech-0003-bb-standard-publikation` | `process` | 17 | `sec-standard-publikation` | 1× MUSS, 1× SOLLTE |
| 2.3.9 | Überprüfung | `ech-0003-bb-standard-ueberpruefung` | `process` | 17 | `sec-standard-ueberpruefung` | 1× MUSS |

**3 Best Practice** (Kapitelüberschrift `sec-best-practice`, ohne Baustein)

| Kap. | Titel | Baustein-ID | Typ | Seite | Anker | Klauseln im Text |
|---|---|---|---|---|---|---|
| 3.1 | Einleitung | `ech-0003-bb-best-practice-einleitung` | `descriptive` | 18 | `sec-best-practice-einleitung` | – |
| 3.2 | Antragstellende | `ech-0003-bb-best-practice-antragstellende` | `governance` | 18 | `sec-best-practice-antragstellende` | – |
| 3.3 | Prozess | `ech-0003-bb-best-practice-prozess` | `process` | 18 | `sec-best-practice-prozess` | – |
| 3.3.1 | Erarbeitung | `ech-0003-bb-best-practice-erarbeitung` | `process` | 18 | `sec-best-practice-erarbeitung` | 3× MUSS |
| 3.3.2 | Formale Qualitätssicherung 1 | `ech-0003-bb-best-practice-formale-qualitaetssicherung-1` | `process` | 19 | `sec-best-practice-formale-qualitaetssicherung-1` | – |
| 3.3.3 | Inhaltliche Qualitätssicherung 1 | `ech-0003-bb-best-practice-inhaltliche-qualitaetssicherung-1` | `process` | 19 | `sec-best-practice-inhaltliche-qualitaetssicherung-1` | 2× MUSS |
| 3.3.4 | Öffentliche Konsultation und Einarbeitung Rückmeldungen | `ech-0003-bb-best-practice-konsultation-und-einarbeitung` | `process` | 19 | `sec-best-practice-konsultation-und-einarbeitung` | – |
| 3.3.5 | Formale Qualitätssicherung 2 | `ech-0003-bb-best-practice-formale-qualitaetssicherung-2` | `process` | 19 | `sec-best-practice-formale-qualitaetssicherung-2` | – |
| 3.3.6 | Inhaltliche Qualitätssicherung 2 | `ech-0003-bb-best-practice-inhaltliche-qualitaetssicherung-2` | `process` | 19 | `sec-best-practice-inhaltliche-qualitaetssicherung-2` | 1× MUSS, 1× SOLLTE |
| 3.3.7 | Genehmigung/Ablehnung | `ech-0003-bb-best-practice-genehmigung-ablehnung` | `process` | 19 | `sec-best-practice-genehmigung-ablehnung` | 2× MUSS, 1× SOLLTE |
| 3.3.8 | Publikation | `ech-0003-bb-best-practice-publikation` | `process` | 20 | `sec-best-practice-publikation` | 1× MUSS |
| 3.3.9 | Überprüfung | `ech-0003-bb-best-practice-ueberpruefung` | `process` | 20 | `sec-best-practice-ueberpruefung` | 1× MUSS |

**4 Hilfsmittel** (Kapitelüberschrift `sec-hilfsmittel`, ohne Baustein)

| Kap. | Titel | Baustein-ID | Typ | Seite | Anker | Klauseln im Text |
|---|---|---|---|---|---|---|
| 4.1 | Einleitung | `ech-0003-bb-hilfsmittel-einleitung` | `descriptive` | 21 | `sec-hilfsmittel-einleitung` | – |
| 4.2 | Antragstellende | `ech-0003-bb-hilfsmittel-antragstellende` | `governance` | 21 | `sec-hilfsmittel-antragstellende` | – |
| 4.3 | Prozess | `ech-0003-bb-hilfsmittel-prozess` | `process` | 21 | `sec-hilfsmittel-prozess` | – |
| 4.3.1 | Erarbeitung | `ech-0003-bb-hilfsmittel-erarbeitung` | `process` | 21 | `sec-hilfsmittel-erarbeitung` | 2× MUSS |
| 4.3.2 | Formale Qualitätssicherung 1 | `ech-0003-bb-hilfsmittel-formale-qualitaetssicherung-1` | `process` | 21 | `sec-hilfsmittel-formale-qualitaetssicherung-1` | – |
| 4.3.3 | Inhaltliche Qualitätssicherung 1 | `ech-0003-bb-hilfsmittel-inhaltliche-qualitaetssicherung-1` | `process` | 21 | `sec-hilfsmittel-inhaltliche-qualitaetssicherung-1` | 1× MUSS, 1× SOLLTE |
| 4.3.4 | Genehmigung/Ablehnung | `ech-0003-bb-hilfsmittel-genehmigung-ablehnung` | `process` | 22 | `sec-hilfsmittel-genehmigung-ablehnung` | 2× MUSS |
| 4.3.5 | Publikation | `ech-0003-bb-hilfsmittel-publikation` | `process` | 22 | `sec-hilfsmittel-publikation` | 1× MUSS |
| 4.3.6 | Überprüfung | `ech-0003-bb-hilfsmittel-ueberpruefung` | `process` | 22 | `sec-hilfsmittel-ueberpruefung` | 1× MUSS |

**5 White Paper** (Kapitelüberschrift `sec-white-paper`, ohne Baustein)

| Kap. | Titel | Baustein-ID | Typ | Seite | Anker | Klauseln im Text |
|---|---|---|---|---|---|---|
| 5.1 | Einleitung | `ech-0003-bb-white-paper-einleitung` | `descriptive` | 23 | `sec-white-paper-einleitung` | – |
| 5.2 | Antragstellende | `ech-0003-bb-white-paper-antragstellende` | `governance` | 23 | `sec-white-paper-antragstellende` | 1× MUSS |
| 5.3 | Prozess | `ech-0003-bb-white-paper-prozess` | `process` | 23 | `sec-white-paper-prozess` | – |
| 5.3.1 | Erarbeitung | `ech-0003-bb-white-paper-erarbeitung` | `process` | 23 | `sec-white-paper-erarbeitung` | 2× MUSS |
| 5.3.2 | Formale Qualitätssicherung 1 | `ech-0003-bb-white-paper-formale-qualitaetssicherung-1` | `process` | 23 | `sec-white-paper-formale-qualitaetssicherung-1` | – |
| 5.3.3 | Inhaltliche Qualitätssicherung 1 | `ech-0003-bb-white-paper-inhaltliche-qualitaetssicherung-1` | `process` | 23 | `sec-white-paper-inhaltliche-qualitaetssicherung-1` | 2× MUSS |
| 5.3.4 | Öffentliche Konsultation und Einarbeitung Rückmeldungen | `ech-0003-bb-white-paper-konsultation-und-einarbeitung` | `process` | 24 | `sec-white-paper-konsultation-und-einarbeitung` | – |
| 5.3.5 | Formale Qualitätssicherung 2 | `ech-0003-bb-white-paper-formale-qualitaetssicherung-2` | `process` | 24 | `sec-white-paper-formale-qualitaetssicherung-2` | – |
| 5.3.6 | Inhaltliche Qualitätssicherung 2 | `ech-0003-bb-white-paper-inhaltliche-qualitaetssicherung-2` | `process` | 24 | `sec-white-paper-inhaltliche-qualitaetssicherung-2` | 1× MUSS, 1× SOLLTE |
| 5.3.7 | Genehmigung/Ablehnung | `ech-0003-bb-white-paper-genehmigung-ablehnung` | `process` | 24 | `sec-white-paper-genehmigung-ablehnung` | 2× MUSS, 1× SOLLTE |
| 5.3.8 | Publikation | `ech-0003-bb-white-paper-publikation` | `process` | 24 | `sec-white-paper-publikation` | 1× MUSS |
| 5.3.9 | Überprüfung | `ech-0003-bb-white-paper-ueberpruefung` | `process` | 25 | `sec-white-paper-ueberpruefung` | 1× MUSS |
