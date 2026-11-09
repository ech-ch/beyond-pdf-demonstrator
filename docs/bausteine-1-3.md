# Entwurf: Baustein-IDs für 1.3.4, 1.3.9 und 1.3.10 (eCH-0003 V11.1.0)

Quelle: Original-PDF eCH-0003 V11.1.0, Seiten 10 und 12, Rohtext in `original/text/kap01-1.3.4.txt`, `kap01-1.3.9.txt`, `kap01-1.3.10.txt`. Links nach dem Word-Original geprüft. Regeln: MVP-Spezifikation 3.2 und 3.6, ADR 0002 und ADR 0004, E11, E29, E30.
Status: **Freigegebene Liste (Projektleitung, 8.11.2026)**, Umsetzung AP23, E50. Der Rest von 1.3 und 1.4 steht in [bausteine-1-3-und-1-4.md](bausteine-1-3-und-1-4.md) (AP25, E52). IDs werden mit der Veröffentlichung eingefroren (ADR 0002); die Projektleitung prüft sie vor dem Push. Die `#`-Nummern (z.B. 1.3.4-3) sind nur Arbeitsnummern und nicht Teil der ID. Wie alle Bausteine ein initialer Vorschlag: für den MVP freigegeben, nicht fixiert (E53).

## Liste

**Grobe Bausteine** (Datei `bausteine/<kurzname>.md`; die Anker `sec-<kurzname>` bestanden schon und bleiben):

| Kap. | Baustein-ID | Typ | Einleitung beim groben Baustein (G2) |
|---|---|---|---|
| 1.3.4 | `ech-0003-bb-oeffentliche-konsultation` | `process` | «Bei der öffentlichen Konsultation werden die Anträge …» |
| 1.3.9 | `ech-0003-bb-publikation` | `process` | – |
| 1.3.10 | `ech-0003-bb-ueberpruefung` | `process` | – |

**Feine Bausteine** (Typ `requirement`, ausser 1.3.9-5; Verbindlichkeit aus der Kennzeichnung):

| # | Baustein-ID | Verbindlichkeit | Original-Seite | `bezug` (E30) | Wortanfang |
|---|---|---|---|---|---|
| 1.3.4-1 | `ech-0003-bb-konsultation-freigabe` | MUSS | 10 | – | «Die Freigabe zur öffentlichen Konsultation erfolgt …» |
| 1.3.4-2 | `ech-0003-bb-detaillierte-rueckmeldungen` | SOLLTE | 10 | – | «Detaillierte inhaltliche Rückmeldungen der Referentinnen und Referenten …» |
| 1.3.4-3 | `ech-0003-bb-entwurfsversion-publizieren` | MUSS | 10 | 1.3.4-1 | «Nach der Freigabe wird die Entwurfsversion …» |
| 1.3.4-4 | `ech-0003-bb-uebersicht-laufende-konsultationen` | MUSS | 10 | 1.3.4-3 | «Zusätzlich wird jeweils eine aktuelle Übersicht …» |
| 1.3.4-5 | `ech-0003-bb-minor-changes-im-paket` | SOLLTE | 10 | – | «Erfolgen aufgrund eines Antrags … Minor Changes …» |
| 1.3.4-6 | `ech-0003-bb-major-changes-separater-prozess` | MUSS | 10 | – | «Erfolgen aufgrund eines Antrags … Major Changes …» |
| 1.3.4-7 | `ech-0003-bb-einladung-zur-konsultation` | MUSS | 10 | – | «Die Mitglieder des Vereins eCH und Interessierte …» |
| 1.3.4-8 | `ech-0003-bb-sprachen-der-konsultation` | MUSS | 10 | – | «Die öffentliche Konsultation wird in der Originalsprache …» |
| 1.3.4-9 | `ech-0003-bb-dauer-der-konsultation` | MUSS | 10 | – | «Eine öffentliche Konsultation startet nach der Übersetzung …», dazu der Absatz «Während der öffentlichen Konsultation kann …» (G1) |
| 1.3.4-10 | `ech-0003-bb-entscheid-fristverlaengerung` | MUSS | 10 | 1.3.4-9 | «Die zuständige Fachgruppenleitung entscheidet abschliessend …» |
| 1.3.9-1 | `ech-0003-bb-publikation-nach-genehmigung` | MUSS | 12 | – | «Ist ein Antrag genehmigt, publiziert die Geschäftsstelle …» |
| 1.3.9-2 | `ech-0003-bb-sprachen-der-publikation` | MUSS | 12 | 1.3.9-1 | «Dies erfolgt in den geforderten Sprachen …» |
| 1.3.9-3 | `ech-0003-bb-originalsprache-kennzeichnen` | MUSS | 12 | – | «Die Originalsprache wird in den Dokumenten …» |
| 1.3.9-4 | `ech-0003-bb-qualitaetspruefung-uebersetzung` | SOLLTE | 12 | – | «Für übersetzte Dokumente erfolgt vorgängig …» |
| 1.3.9-5 | `ech-0003-bb-weitere-kommunikationsmassnahmen` | ohne Kennzeichnung (Typ `descriptive`, G4) | 12 | – | «Auf Wunsch der Antragstellenden …» |
| 1.3.10-1 | `ech-0003-bb-pruefung-aktualitaet-relevanz` | MUSS | 12 | – | «Standards, Best Practices, Hilfsmittel und White Paper werden …» |
| 1.3.10-2 | `ech-0003-bb-ueberpruefung-entscheid-protokollieren` | MUSS | 12 | 1.3.10-1 | «Der Entscheid der Referentinnen und Referenten …» |
| 1.3.10-3 | `ech-0003-bb-inaktive-verantwortliche` | SOLLTE | 12 | – | «Sind Fachgruppe beziehungsweise Antragstellende nicht mehr aktiv …» |

Zählung aus dem Rohtext: 1.3.4 8× MUSS, 2× SOLLTE; 1.3.9 3× MUSS, 1× SOLLTE; 1.3.10 2× MUSS, 1× SOLLTE. Das sind 17 Klauseln wie gezählt. Dazu kommt ein Absatz ohne Kennzeichnung als eigener feiner Baustein (1.3.9-5, Hinweis 6), zusammen also 18 feine Bausteine.

**Querverweise** (E11, erzeugt): 1.3.4-5 → 7.8, 1.3.4-6 → 7.9, 1.3.9-1 → 7.8 und 1.3.4. Im Word-Original sind es Felder (REF), also schon dort erzeugt.

**Links** (F53, wie im Word-Original): «Webseite» und «Newsübersicht» in 1.3.4 auf `https://www.ech.ch/`, «Webseite» in 1.3.9 auf `http://www.ech.ch`. 1.3.10 hat keine Links.

**Verweisziele, die damit Bausteine sind:** 1.3.4 (aus 7.3, 7.8, 1.3.9 und Anhang D), 1.3.9 (aus Anhang C und D), 1.3.10 (aus Anhang C). Als «noch kein Baustein» bleibt nur 2.1.4 (aus Anhang D).

## Hinweise und Grenzfälle

1. **Kurznamen ohne Antragsform.** 1.3 beschreibt die allgemeinen Prozessmodule. Ihre groben Bausteine erhalten die schlichten Namen der bestehenden Anker, wie vorgeschlagen. Die Antragsform als Präfix bleibt Kap. 2–6 vorbehalten, wie bei `fachgruppendokument-…` und `sec-standard-datenschemata`. Das passt auch zur Richtung der Verweise: Kap. 2–5 verweisen mit «gemäss Kapitel 1.3.4» und «gemäss Kapitel 1.3.10» auf diese Module, nicht umgekehrt. Folge: Die gleichlautenden Unterkapitel in Kap. 2–5 brauchen später die Antragsform, z.B. `standard-publikation` für 2.3.8 und `best-practice-ueberpruefung` für 3.3.9.
2. **1.3.4, Absatz ohne Kennzeichnung (G1).** «Während der öffentlichen Konsultation kann die laufende Frist individuell … verlängert werden.» steht zwischen zwei Klauseln. «Die laufende Frist» ist die Frist der Klausel davor; der Absatz gehört deshalb nach G1 zu 1.3.4-9. Die letzte Klausel 1.3.4-10 bezieht sich mit «einer individuellen Fristverlängerung» auf diesen Absatz zurück und erhält `bezug` auf 1.3.4-9 (E30). Alternative: Absatz als eigener feiner Baustein nach G4 (Typ `descriptive`); `bezug` zeigte dann auf ihn.
3. **1.3.4, weitere Rückbezüge.** «Nach der Freigabe» (1.3.4-3 → 1.3.4-1) und «Zusätzlich» (1.3.4-4 → 1.3.4-3) beziehen sich auf eine andere Klausel und erhalten `bezug`, wie «nach Abschluss der Frist» in 7.8. Nicht erfasst ist «nach der Übersetzung» in 1.3.4-9: Das ist der Prozessschritt, nicht die Übersetzung aus 1.3.4-8. Bezüge auf das Thema des eigenen groben Bausteins («zur Konsultation») erfasst E30 nicht.
4. **1.3.4, Einleitung.** «Die Resultate der Prüfung sollten als Rückmeldungen formuliert werden.» klingt normativ, hat aber keine Kennzeichnung. Der Satz bleibt Einleitung des groben Bausteins (G2); der Build interpretiert nichts (V3).
5. **1.3.9, Rückbezüge.** «Dies erfolgt …» (1.3.9-2) bezieht sich auf die Publikation in 1.3.9-1 und erhält `bezug`. 1.3.9-3 («Die Originalsprache wird … entsprechend gekennzeichnet») knüpft an 1.3.9-2 an, ist aber ohne Pronomen verständlich; nicht erfasst.
6. **1.3.9, letzter Absatz (G4), von der Projektleitung bestätigt (8.11.2026).** «Auf Wunsch der Antragstellenden … können weitere Kommunikationsmassnahmen … eingeleitet werden.» hat keine Kennzeichnung. Er bezieht sich nicht auf die Klausel davor (Qualitätsprüfung der Übersetzung), sondern auf die Publikation insgesamt. Nach G4 wird er deshalb ein eigener feiner Baustein mit Typ `descriptive`, ohne Verbindlichkeit und ohne `bezug`, weil die Publikation das Thema des eigenen groben Bausteins ist (E30). Es ist der erste G4-Fall im Demonstrator; E29 verlangt die Bestätigung durch die Projektleitung. Alternative: beim groben Baustein lassen, wie vor E29.
7. **1.3.10, Rückbezug.** «Der Entscheid der Referentinnen und Referenten auf den Verzicht zur Aktualisierung oder die Überweisung zur Überarbeitung» (1.3.10-2) meint den Entscheid aus 1.3.10-1 und erhält `bezug`. 1.3.10-3 knüpft an die Überweisung an Fachgruppe oder Antragstellende an, ohne Pronomen; nicht erfasst.
8. **Fast gleichlautende Stellen (festgehalten, nicht aufgelöst).** Verglichen mit 1.3 (übrige Unterkapitel), Kap. 2–5 (Rohtext nur zum Vergleich extrahiert, nicht im Repo), Kap. 6 und Kap. 7:
   - **1.3.10-2 und 7.7** `addendum-entscheid-protokollieren`: gleicher Satzbau («Der Entscheid der Referentinnen und Referenten … wird an der nächsten Sitzung des Expertenausschusses formal protokolliert»), anderer Gegenstand. Es bleiben zwei Bausteine; der Kurzname folgt dem Muster aus 7.7. Falls eine spätere Version die Regel zusammenfasst, ist das ein Kandidat für einen gemeinsamen Baustein (F51).
   - **1.3.9-1/-2 und 2.3.8, 3.3.8, 4.3.5, 5.3.8**: «[MUSS] Nach erfolgter Genehmigung werden allfällige Korrekturen übersetzt und das Standarddokument (bzw. die Best Practice, das Hilfsmittel, das White Paper) in der Originalsprache und in übersetzter Sprache auf der Webseite veröffentlicht.» Inhaltlich weitgehend dasselbe wie 1.3.9-1 und -2, je Antragsform wiederholt. Dort läge `publikation-nach-genehmigung` ebenfalls nahe; es braucht dann die Antragsform (Hinweis 1).
   - **1.3.4-8 und 2.3.8**: «Ausnahmsweise können öffentliche Konsultationen bei Dokumenten, welche ausschliesslich in englischer Sprache vorliegen, einsprachig durchgeführt werden.» (Teil einer MUSS-Klausel) und «[SOLLTE] Ausnahmsweise können Standards, welche ausschliesslich in englischer Sprache vorliegen, einsprachig publiziert werden.» Gleiche Ausnahme, einmal für die Konsultation, einmal für die Publikation, mit unterschiedlicher Verbindlichkeit. Die Kurznamen kollidieren nicht.
   - **1.3.10-1 und 2.3.9, 3.3.9, 4.3.6, 5.3.9**: «[MUSS] Standards mit dem Status «Genehmigt» werden fünf Jahre (bzw. drei Jahre) nach deren Genehmigung oder letzten Überprüfung gemäss Kapitel 1.3.10 überprüft.» Diese Klauseln legen die «pro Antragsform festgelegte Frist» aus 1.3.10-1 fest und verweisen darauf. Keine Kollision, künftig Querverweise nach 1.3.10.
   - **2.3.4, 3.3.4, 5.3.4** («Die öffentliche Konsultation findet gemäss Kapitel 1.3.4 … statt.») verweisen ohne Kennzeichnung auf 1.3.4; künftig Querverweise.
   - **Kap. 7**: 7.8 `konsultation-nicht-umgehen` und `behandlung-einsprachen` betreffen die Konsultation, sind aber nicht gleichlautend. Keiner der neuen Kurznamen kollidiert mit einer der 78 bestehenden IDs.
9. **«d. h.» in 1.3.9-2.** Pandoc setzt nach «d.» ein geschütztes Leerzeichen, weil «d.» in seiner Abkürzungsliste steht. Der Textvergleich meldet das als Abweichung (E11). In der Quelle steht deshalb `d\. h.`; der Text bleibt zeichengleich (E50).
10. **Labels** bleiben unter 50 Zeichen; das längste ist `bb:ueberpruefung-entscheid-protokollieren` (41).
