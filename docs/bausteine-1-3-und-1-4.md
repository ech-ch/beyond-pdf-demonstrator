# Entwurf: Baustein-IDs für 1.3 (Rest) und 1.4 (eCH-0003 V11.1.0)

Quelle: Original-PDF eCH-0003 V11.1.0, Seiten 6–13. Rohtext in `original/text/kap01-1.3.txt`, `kap01-1.3.1.txt`, `kap01-1.3.2.txt`, `kap01-1.3.3.txt`, `kap01-1.3.5.txt` bis `kap01-1.3.8.txt` und `kap01-1.4.txt`. Absatzgrenzen, Formatvorlagen, Querverweise (REF-Felder) und Links sind nach dem Word-Original geprüft. Regeln: MVP-Spezifikation 3.2 und 3.6, ADR 0002 und ADR 0004, E11, E29, E30.

Status: **Freigegebene Liste** (Projektleitung, 8.11.2026; Umsetzung AP25, Paket C, E52), für den MVP und als initialer Vorschlag, nicht fixiert (E53). Die IDs werden mit der Veröffentlichung eingefroren (ADR 0002). Die `#`-Nummern (z.B. 1.3.3-7) sind nur Arbeitsnummern und nicht Teil der ID. 1.3.4, 1.3.9 und 1.3.10 stehen in der freigegebenen Liste [bausteine-1-3.md](bausteine-1-3.md).

## Liste

**Grobe Bausteine** (Datei `bausteine/<kurzname>.md`, Anker `sec-<kurzname>`):

| Kap. | Baustein-ID | Typ | Einleitung beim groben Baustein (G2) |
|---|---|---|---|
| 1.3 | `ech-0003-bb-prozessmodule` | `process` | «Alle Antragsformen werden über dieselben Genehmigungs- und Freigabeprozesse …» und Abbildung 1 |
| 1.3.1 | `ech-0003-bb-erarbeitung` | `process` | «Dieser Schritt findet innerhalb der Fachgruppe statt …» (ganzer Text, keine Klausel) |
| 1.3.2 | `ech-0003-bb-formale-qualitaetssicherung-1` | `process` | «Diese formale Qualitätssicherung erfolgt durch die Geschäftsstelle.» |
| 1.3.3 | `ech-0003-bb-inhaltliche-qualitaetssicherung-1` | `process` | «Diese inhaltliche Qualitätssicherung wird durch die Referentinnen und Referenten …» |
| 1.3.5 | `ech-0003-bb-einarbeitung-rueckmeldungen` | `process` | – |
| 1.3.6 | `ech-0003-bb-formale-qualitaetssicherung-2` | `process` | «Bei dieser formalen Qualitätssicherung wird der Antrag wie bei 1.3.2 …» |
| 1.3.7 | `ech-0003-bb-inhaltliche-qualitaetssicherung-2` | `process` | «Diese inhaltliche Qualitätssicherung erfolgt durch die Referentinnen und Referenten.» |
| 1.3.8 | `ech-0003-bb-genehmigung-ablehnung` | `process` | – |
| 1.4 | `ech-0003-bb-fristen-und-termine` | `descriptive` | Abbildung 2 und die zwei Absätze «Von der Einreichung …» und «Diese Zeitangaben …» (Fall 4) |

Die Kurznamen tragen keine Antragsform, wie bei 1.3.4, 1.3.9 und 1.3.10 (E50): 1.3 beschreibt die allgemeinen Prozessmodule. Die gleichlautenden Unterkapitel in Kap. 2–5 brauchen später die Antragsform, z.B. `standard-erarbeitung` für 2.3.1. Typ von 1.4: `descriptive`, weil Abbildung und Zeitangaben nach dem Text «ausschliesslich illustrativen Zwecken» dienen; Alternative `process`.

**Feine Bausteine** (Typ `requirement`, ausser 1.4-2; Verbindlichkeit aus der Kennzeichnung):

| # | Baustein-ID | Verbindlichkeit | Seite | `bezug` (E30) | Wortanfang |
|---|---|---|---|---|---|
| 1.3.2-1 | `ech-0003-bb-vorlage-und-pflichtangaben` | MUSS | 7 | – | «Die zur Antragsform passende und aktuelle Vorlage …», mit Aufzählung |
| 1.3.2-2 | `ech-0003-bb-unterlagen-vollstaendig` | MUSS | 7 | – | «Die Antragstellenden stellen die … Unterlagen vollständig zur Verfügung.» |
| 1.3.2-3 | `ech-0003-bb-fristen-und-ablaeufe-einhalten` | MUSS | 7 | – | «Fristen, Termine und vorgegebene Abläufe werden eingehalten.» |
| 1.3.2-4 | `ech-0003-bb-geistiges-eigentum-konform` | MUSS | 8 | – | «Die Bedingungen bezüglich geistigen Eigentums …» |
| 1.3.2-5 | `ech-0003-bb-nachweis-reifegrad` | MUSS | 8 | – | «Der Antrag erfüllt die formalen Kriterien für den Reifegrad:», mit Aufzählung |
| 1.3.2-6 | `ech-0003-bb-qualitaetssicherung-in-fachgruppe` | MUSS | 8 | – | «Der Antrag hat die Qualitätssicherung in der Fachgruppe durchlaufen …» |
| 1.3.3-1 | `ech-0003-bb-beitrag-zur-standardisierung` | MUSS | 8 | – | «Der Antrag ist geeignet, die Standardisierung … zu unterstützen …» |
| 1.3.3-2 | `ech-0003-bb-kategorie-entspricht-inhalt` | MUSS | 8 | – | «Die Kategorie des Dokuments (vgl. Kapitel 1.2) …» |
| 1.3.3-3 | `ech-0003-bb-verstaendlich-und-nachvollziehbar` | SOLLTE | 8 | – | «Der Antrag ist nach Einschätzung … verständlich und nachvollziehbar.» |
| 1.3.3-4 | `ech-0003-bb-normativer-charakter-erkennbar` | MUSS | 8 | – | «Aus einem Standard geht klar hervor …» |
| 1.3.3-5 | `ech-0003-bb-zweck-hilfsmittel-erkennbar` | MUSS | 8 | – | «Aus einem Hilfsmittel geht klar hervor …» |
| 1.3.3-6 | `ech-0003-bb-ausrichtung-white-paper-erkennbar` | MUSS | 8 | – | «Aus einem White Paper geht klar hervor …» |
| 1.3.3-7 | `ech-0003-bb-muendliche-praesentation` | SOLLTE | 8 | 1.3.3-3 bis -6 | «Treffen diese Kriterien nicht zu, …» |
| 1.3.3-8 | `ech-0003-bb-abkuerzungen-erlaeutert` | MUSS | 8 | – | «Alle verwendeten Abkürzungen …» |
| 1.3.3-9 | `ech-0003-bb-begriffe-im-glossar` | MUSS | 8 | – | «Wiederholt verwendete, nicht selbstsprechende Begriffe …» |
| 1.3.3-10 | `ech-0003-bb-begriffe-konsistent` | MUSS | 8 | – | «Begriffe sind innerhalb des Antrags konsistent verwendet.» |
| 1.3.3-11 | `ech-0003-bb-unzulaessige-inhalte` | DARF NICHT | 8 | – | «Der Antrag enthält keine der folgenden Elemente:», mit Aufzählung |
| 1.3.3-12 | `ech-0003-bb-keine-ueberschneidung` | DARF NICHT | 9 | – | «Es ist keine Fachgruppe und kein bestehendes gültiges eCH-Dokument im Einsatz …» |
| 1.3.3-13 | `ech-0003-bb-vorgehen-bei-ueberschneidung` | SOLLTE | 9 | 1.3.3-12 | «Ist dieses Kriterium nicht erfüllt, …», mit Aufzählung |
| 1.3.3-14 | `ech-0003-bb-kein-widerspruch-zu-standards` | SOLLTE | 9 | – | «Das Ziel des Antrags steht nicht im Widerspruch …», dazu der Absatz «In Ausnahmefällen …» mit Aufzählung (G1, Fall 3) |
| 1.3.3-15 | `ech-0003-bb-begriffe-wie-in-ech-dokumenten` | SOLLTE | 9 | – | «Begriffe sind im Antrag gleicherweise wie in bestehenden … verwendet.» |
| 1.3.3-16 | `ech-0003-bb-keine-wiederholung-aus-ech-dokumenten` | DARF NICHT | 9 | – | «Der Antrag enthält keine Aussagen, Richtlinien und Empfehlungen, die in anderen …» |
| 1.3.3-17 | `ech-0003-bb-referenzen-nach-richtlinien` | MUSS | 9 | – | «Verwendete Referenzen folgen … gemäss Kapitel 7.10.» |
| 1.3.3-18 | `ech-0003-bb-inhaltspruefung-ohne-konsultation` | MUSS | 9 | – | «Bei Anträgen ohne öffentliche Konsultation …» |
| 1.3.3-19 | `ech-0003-bb-genuegende-spezifikation` | MUSS | 9 | – | «Der Standard ist formal genügend spezifiziert …» |
| 1.3.3-20 | `ech-0003-bb-test-dokumentiert` | SOLLTE | 9 | – | «Die Art und Weise des Tests ist dokumentiert …» |
| 1.3.3-21 | `ech-0003-bb-semantik-definiert` | MUSS | 9 | – | «Die Semantik der verwendeten Informationsobjekte …» |
| 1.3.3-22 | `ech-0003-bb-datenmodell-uml` | SOLLTE | 9 | – | «Zur Dokumentation der Semantik wird ein Datenmodell in UML-Notation verwendet.» |
| 1.3.5-1 | `ech-0003-bb-rueckmeldungen-zusammenfassen` | MUSS | 10 | 1.3.4-9 `dauer-der-konsultation` | «Nach Ablauf der Frist werden die … Rückmeldungen zusammengefasst …» |
| 1.3.5-2 | `ech-0003-bb-rueckmeldungen-behandeln` | MUSS | 10 | – | «Die Antragstellenden», mit Aufzählung (eCH-0150) |
| 1.3.5-3 | `ech-0003-bb-keine-allgemeinen-begruendungen` | DARF NICHT | 11 | 1.3.5-2 | «Allgemeine Begründungen werden nicht akzeptiert …» |
| 1.3.5-4 | `ech-0003-bb-geaendertes-dokument-einreichen` | MUSS | 11 | – | «Das geänderte Dokument wird mit den Antworten … wieder … eingereicht.» |
| 1.3.6-1 | `ech-0003-bb-rueckmeldungen-beantwortet` | MUSS | 11 | – | «Zusätzlich wird festgestellt, ob sämtliche Rückmeldungen … beantwortet wurden.» |
| 1.3.7-1 | `ech-0003-bb-keine-gesamtpruefung` | DARF NICHT | 11 | – | «Sie prüfen nicht das gesamte Dokument inhaltlich,» (Fall 2) |
| 1.3.7-2 | `ech-0003-bb-nur-einarbeitung-pruefen` | MUSS | 11 | 1.3.7-1 | «sondern ausschliesslich, ob die Rückmeldungen …» (Fall 2) |
| 1.3.7-3 | `ech-0003-bb-keine-korrespondenz` | MUSS | 11 | – | «Über die Einarbeitung der Rückmeldungen … wird in der Regel keine Korrespondenz geführt.» |
| 1.3.7-4 | `ech-0003-bb-stellungnahme-an-konsulenten` | SOLLTE | 11 | – | «Je nach Umfang oder Komplexität der Rückmeldungen …» |
| 1.3.7-5 | `ech-0003-bb-empfehlung-an-gremium` | MUSS | 11 | – | «Anschliessend empfehlen die Referentinnen und Referenten …» |
| 1.3.8-1 | `ech-0003-bb-beschluss-durch-gremium` | MUSS | 11 | – | «Das zuständige Gremium (Vorstand oder Expertenausschuss) beschliesst …» |
| 1.3.8-2 | `ech-0003-bb-offene-abstimmung` | MUSS | 11 | – | «Die Abstimmung erfolgt offen, …» |
| 1.3.8-3 | `ech-0003-bb-online-abstimmung` | SOLLTE | 11 | – | «Auf Antrag der Hauptreferentin … kann die Abstimmung online erfolgen …» |
| 1.3.8-4 | `ech-0003-bb-beschluss-ohne-diskussion` | MUSS | 11 | 1.3.8-3 | «Wird keine Diskussion verlangt und ist das einfache Mehr … erreicht, …» |
| 1.3.8-5 | `ech-0003-bb-genehmigung-unter-vorbehalt` | SOLLTE | 11 | – | «Um unnötige Prozessschritte zu vermeiden, kann ein Dokument unter Vorbehalt …» |
| 1.4-1 | `ech-0003-bb-keine-ansprueche-aus-zeitangaben` | DARF NICHT | 13 | – | «Es lassen sich daraus keinerlei Ansprüche ableiten.» (Fall 4) |
| 1.4-2 | `ech-0003-bb-genehmigung-online-oder-sitzung` | ohne Kennzeichnung (Typ `descriptive`, G4) | 13 | – | «Die Genehmigung selbst erfolgt entweder online oder an einer ordentlichen Sitzung …» (Fall 4) |

**Zählung aus dem Rohtext:** 1.3.2: 6× MUSS; 1.3.3: 12× MUSS, 7× SOLLTE, 3× DARF NICHT; 1.3.5: 3× MUSS, 1× DARF NICHT; 1.3.6: 1× MUSS; 1.3.7: 3× MUSS, 1× SOLLTE, 1× DARF NICHT; 1.3.8: 3× MUSS, 2× SOLLTE; 1.4: 1× DARF NICHT. 1.3, 1.3.1 ohne Kennzeichnung. Zusammen 44 Klauseln (28 MUSS, 10 SOLLTE, 6 DARF NICHT) in 44 feinen Bausteinen; dazu 1.4-2 nach G4, also 45 feine Bausteine. Mit 1.3.4, 1.3.9 und 1.3.10 ist Kap. 1 damit vollständig überführt.

**Querverweise** (E11, erzeugt; im Word-Original Felder REF):

| Stelle | Text | Ziel im Word-Original | Quelle im Demonstrator |
|---|---|---|---|
| 1.3.2-1 | «(vgl. 2. Teil von Anhang C – Glossar)» | Textmarke vor der Überschrift von Anhang C, Feld ohne `\r` (Überschriftentext) | `[@sec-glossar]{.mit-titel}`, Ergebnis «Anhang C – Glossar» (Fall 5) |
| 1.3.3-2 | «(vgl. Kapitel 1.2)» | Überschrift «Anwendungsgebiet» | `Kapitel -@sec-anwendungsgebiet` |
| 1.3.3-17 | «gemäss Kapitel 7.10» | Überschrift «Darstellung von Voraussetzungen und Abhängigkeiten» (= 7.10) | `Kapitel -@sec-voraussetzungen-abhaengigkeiten` |
| 1.3.3-18 | «gemäss Kapitel 7.8» | Überschrift «Minor Change» (dieselbe Textmarke wie in 1.3.4 und 1.3.9) | `Kapitel -@sec-minor-change` |
| 1.3.6, Einleitung | «wie bei 1.3.2» | Überschrift «Formale Qualitätssicherung 1» | `-@sec-formale-qualitaetssicherung-1` |

**Links** (F53, wie im Word-Original): «Webseite von eCH» in 1.3.2-1 auf `https://www.ech.ch/`; «www.ige.ch» in 1.3.2-4 auf `http://www.ige.ch`; «eCH-0150: Change und Releasemanagement von eCH-Standards» in 1.3.5-2 auf `http://www.ech.ch/vechweb/page?p=dossier&documentNumber=eCH-0150`. Der alte Link leitet heute auf die Seite von eCH-0150 V1.0 weiter (geprüft 8.11.2026); in 7.8 und 7.9 steht im Word-Original `https://www.ech.ch/ech/ech-0150`. Die Nennung von eCH-0150 ist wie dort als Standard ausgezeichnet (`standard="eCH-0150"`); die Registry führt sie als Referenz auf einen eCH-Standard, der Steckbrief zeigt sie mit.

**Abbildungen** (F10, vorläufig E52): Bilddatei aus dem Original-PDF, zugeschnitten mit `tools/schneide_abbildungen.py` (300 dpi). Bildunterschrift wie im Original, Nummer erzeugt. Alternativtext mit den Schritten in Reihenfolge und den Pfeilen, bei Abbildung 2 mit den Farben. Im Word-Original sind beide Abbildungen eingebettete Visio-Zeichnungen (OLE) mit Vorschaubild; dieses liegt nur im Word-Original, das nicht ins Repo kommt.

## Fälle für die Projektleitung

Entscheid der Projektleitung (8.11.2026): alle Vorschläge freigegeben, für den MVP und als initialer Vorschlag, nicht für die Zukunft fixiert (E53). Vor dem Push umbenannt: 1.4-1 heisst `keine-ansprueche-aus-zeitangaben` statt `keine-ansprueche-aus-fristen`, weil der Text von «Zeitangaben» spricht und Fristen nach 1.3.2-3 einzuhalten sind.

1. **Zwischenzeilen in 1.3.2 und 1.3.3.** Im Word-Original haben «Generelle Kriterien für alle Antragsformen», «Antrag auf Standard, Hilfsmittel und White Paper», «Materielle Eignung», «Verständlichkeit», «Überschneidungsfreiheit und Konsistenz mit anderen eCH-Dokumenten», «Inhalt» und «Genügende Spezifikationstiefe von Interoperabilitätsstandards» die Formatvorlage **«Untertitel»** (Name `Subtitle`, fett, mit Aufzählungszeichen). Sie stehen nicht im Inhaltsverzeichnis.
   **Vorschlag:** Sie bleiben Teil des groben Bausteins, wie eine Einleitung, und stehen zwischen den feinen Bausteinen. Sie sind keine Klausel und keine Aussage, also weder G1 noch G4. In der Quelle: `::: {.zwischentitel custom-style="Subtitle"}`. Im Word erhalten sie dieselbe Formatvorlage wie im Original (die Vorlage 2025 hat sie, mit Aufzählungszeichen), auf der Website fett, ohne Aufzählungszeichen und ohne Eintrag im Inhaltsverzeichnis. Kein Feedback-Knopf, keine ID.
   **Alternativen:** (a) Überschrift der Ebene 4, nicht nummeriert und nicht im Inhaltsverzeichnis: semantisch sauberer, aber neue Überschriften gegenüber dem Inhaltsverzeichnis des Originals, und die Gliederung der Registry hätte 99 statt 92 Einträge. (b) Eigene Gruppen-Bausteine zwischen grobem und feinem Baustein (z.B. `materielle-eignung`): erst sinnvoll, wenn jemand Rückmeldungen auf eine Kriteriengruppe geben will.
2. **1.3.7, ein Satz mit zwei Kennzeichnungen.** «[DARF NICHT] Sie prüfen nicht das gesamte Dokument inhaltlich,» und «[MUSS] sondern ausschliesslich, ob die Rückmeldungen …» sind im Word-Original zwei Absätze, im PDF ebenso.
   **Vorschlag:** zwei feine Bausteine wie im Original, 1.3.7-2 mit `bezug` auf 1.3.7-1, weil der Satz mit «sondern» weiterläuft. So bleibt die Regel «höchstens eine Kennzeichnung je feinem Baustein» (E29) und die Zählung stimmt (je 1×). Das Feedback auf 1.3.7-2 zeigt den Satzanfang nicht; über «Beziehungen (1)» ist er erreichbar.
   **Alternative:** ein feiner Baustein mit zwei Kennzeichnungen. Dafür müsste die CI-Prüfung eine Ausnahme kennen, und der Baustein hätte zwei Verbindlichkeiten.
3. **1.3.3, Absatz ohne Kennzeichnung nach einer SOLLTE-Klausel.** «In Ausnahmefällen können Standards genehmigt werden, welche dieses Kriterium nicht erfüllen, z.B.» mit drei Aufzählungspunkten folgt auf «[SOLLTE] Das Ziel des Antrags steht nicht im Widerspruch …».
   **Vorschlag:** G1, der Absatz gehört zu 1.3.3-14. «dieses Kriterium» bezieht sich ausdrücklich auf die Klausel davor; die Ausnahmen erläutern, wann von der Empfehlung abgewichen werden kann. Die Verbindlichkeit bleibt SOLLTE (G3).
   **Alternative:** G4, eigener feiner Baustein `ausnahmen-widerspruch` mit Typ `descriptive` und `bezug` auf 1.3.3-14. Das wäre nötig, wenn jemand Rückmeldungen gezielt auf die Ausnahmen geben soll. Nach G4 ist es aber nur für Absätze ohne Bezug vorgesehen.
4. **1.4, beschreibende Absätze und die DARF-NICHT-Klausel.**
   - «Von der Einreichung …» und «Diese Zeitangaben basieren auf Erfahrungswerten …» stehen vor der ersten Klausel und gehören mit Abbildung 2 nach **G2** zum groben Baustein.
   - «[DARF NICHT] Es lassen sich daraus keinerlei Ansprüche ableiten.» bezieht sich mit «daraus» auf die Zeitangaben der Einleitung, also auf das Thema des eigenen groben Bausteins. **Vorschlag:** kein `bezug`, wie bei «zur Konsultation» in 1.3.4 (E30 erfasst Bezüge auf den eigenen groben Baustein nicht). **Alternative:** die beiden Absätze als G4-Baustein `zeitangaben-erfahrungswerte` (Typ `descriptive`), die Klausel mit `bezug` darauf. Das widerspricht G2.
   - «Die Genehmigung selbst erfolgt entweder online oder an einer ordentlichen Sitzung des Expertenausschusses.» steht nach der Klausel und hat keinen Bezug auf sie. **Vorschlag:** **G4**, eigener feiner Baustein `genehmigung-online-oder-sitzung`, Typ `descriptive`, ohne `bezug` (zweiter G4-Fall nach 1.3.9). Inhaltlich wiederholt er 1.3.8 («Vorstand oder Expertenausschuss», Online-Abstimmung) und die Klauseln 2.3.7, 3.3.7, 4.3.4, 5.3.7; er nennt nur den Expertenausschuss. Festgehalten, nicht aufgelöst.
   - Im Word-Original und im PDF sind die Wörter «grün», «blau» und «rot» in ihrer Farbe gesetzt. Der Demonstrator setzt sie in der Textfarbe (Kontrast auf der Website, gleicher Wortlaut). Die Farben nennt der Alternativtext der Abbildung.
   - Fehler des Originals bleiben stehen: «Sie beinhaltet keine Verzögerungen … Sie dient …» (Singular nach «Diese Zeitangaben»).
5. **Verweise.**
   - **1.3.6 «wie bei 1.3.2»:** Feld REF mit `\r` auf «Formale Qualitätssicherung 1». Erzeugter Querverweis nur mit Nummer (`-@sec-…`), Text «wie bei 1.3.2» unverändert.
   - **1.3.3 «Kapitel 1.2»:** Feld REF auf «Anwendungsgebiet» (1.2). Erzeugt.
   - **1.3.3 «Kapitel 7.10»:** geprüft, das Feld REF `\r` zeigt im Word-Original auf die Überschrift «Darstellung von Voraussetzungen und Abhängigkeiten», und das ist 7.10. Dieselbe Textmarke verwendet Anhang C («Voraussetzungen … gemäss Kapitel 7.10 Darstellung von Voraussetzungen und Abhängigkeiten»). Inhaltlich passt 7.10 nur teilweise: «Verwendete Referenzen» meint wohl Verweise auf andere Dokumente, 7.10 regelt Voraussetzungen und Abhängigkeiten. Festgehalten, nicht geändert.
   - **1.3.3 «Kapitel 7.8»:** Feld REF auf «Minor Change». Erzeugt.
   - **1.3.2 «2. Teil von Anhang C – Glossar»:** Das Feld REF (ohne `\r`) zeigt auf eine Textmarke, die in einem leeren Absatz vor der Überschrift von Anhang C beginnt. Das Feldergebnis enthält deshalb eine Absatzmarke, und der Aufzählungspunkt «Deckblatt mit den Metadaten (vgl. 2. Teil von Anhang C – Glossar)» zerfällt im Original in zwei Punkte («… 2. Teil von» / «Anhang C – Glossar)»). Der Rohtext folgt dem PDF (zwei Zeilen). **Vorschlag:** ein Aufzählungspunkt mit erzeugtem Querverweis «Anhang C – Glossar»; der Wortlaut bleibt zeichengleich, nur der falsche Umbruch fällt weg. `ech_titelref.lua` kann dafür neu auch Anhänge mit Titel verweisen («Anhang C – Glossar»). «2. Teil» bleibt Text; der zweite Teil von Anhang C hat keinen eigenen Anker. **Alternative:** zwei Aufzählungspunkte wie im PDF.
   - **1.3.5 eCH-0150:** im Word-Original ein Link, kein Feld. Ausgezeichnet als Standard wie in 7.8 und 7.9 (siehe Links oben). Die Registry hat damit drei Stellen mit eCH-0150 (1.3.5, 7.8, 7.9).
6. **Wiederholungen mit Kap. 2–5 (F26) und innerhalb von 1.3, festgehalten, nicht aufgelöst.** Verglichen mit 1.3, Kap. 2–5 (Rohtext nur zum Vergleich extrahiert, nicht im Repo), Kap. 6 und 7:
   - **Verweise statt Wiederholungen:** Kap. 2–5 verweisen in ihren Prozess-Unterkapiteln auf 1.3.2, 1.3.3, 1.3.4, 1.3.5, 1.3.6, 1.3.7 und 1.3.10 («Die Geschäftsstelle prüft eingegangene Standardanträge gemäss Kapitel 1.3.2.», «… zur Begutachtung gemäss Kapitel 1.3.7 zugestellt.»). Nach dem Überführen von Kap. 2–5 werden das Querverweise auf die neuen Bausteine.
   - **1.3.7-5 und 2.3.6, 3.3.6, 4.3.3, 5.3.6:** «[MUSS] Anschliessend empfehlen die Referentinnen und Referenten die Genehmigung oder Ablehnung des Antrags zuhanden des zuständigen Gremiums.» und «[MUSS] Aufgrund dieser Angaben erarbeiten die Referentinnen und Referenten eine Empfehlung zuhanden des Expertenausschusses.» (je Antragsform wiederholt). Gleiche Regel, anderes Gremium, anderer Wortlaut.
   - **1.3.8-1/-3, 1.4-2 und 2.3.7, 3.3.7, 4.3.4, 5.3.7:** «Der Expertenausschuss beschliesst mittels Online-Abstimmung oder an einer ordentlichen Sitzung die Genehmigung oder Ablehnung …», in 2.3.7 als SOLLTE, in 3.3.7, 4.3.4 und 5.3.7 als MUSS. 1.3.8 nennt «Vorstand oder Expertenausschuss».
   - **1.3.2 und 2.3.2, 3.3.2, 4.3.2, 5.3.2:** «Eventuelle Unzulänglichkeiten werden den Antragstellenden direkt gemeldet und … eine Korrektur verlangt.», in 2.3.2 als SOLLTE, in 3.3.2, 4.3.2 und 5.3.2 ohne Kennzeichnung. In 1.3.2 steht das nicht.
   - **Innerhalb von 1.3:** Die Einleitungen von 1.3.2, 1.3.6 und 1.3.7 sind gleich gebaut («Diese formale/inhaltliche Qualitätssicherung erfolgt durch …»). 1.3.3-11 verbietet «Wiederholung von Aussagen, Richtlinien und Empfehlungen innerhalb des Antrags» und 1.3.3-16 Wiederholungen aus anderen eCH-Dokumenten; F26 hält fest, dass V11.1.0 selbst in Kap. 2–5 wiederholt.
   - Keine der neuen Klauseln ist zeichengleich mit einer bestehenden; Mehrfachverwendung (E27) ist nicht nötig. Keiner der 54 neuen Kurznamen kollidiert mit einer der 99 bestehenden IDs.

## Weitere Hinweise

7. **Rückbezüge (E30).**
   - 1.3.3-7 «Treffen diese Kriterien nicht zu» bezieht sich auf die vier Kriterien unter «Verständlichkeit» davor (1.3.3-3 bis -6). `bezug` hat vier Ziele. Ob «diese Kriterien» auch die Kriterien unter «Materielle Eignung» meint, lässt der Text offen.
   - 1.3.3-13 «Ist dieses Kriterium nicht erfüllt» → 1.3.3-12.
   - 1.3.5-1 «Nach Ablauf der Frist» meint die Frist der öffentlichen Konsultation aus 1.3.4 (`dauer-der-konsultation`). Das ist der erste `bezug` über einen groben Baustein hinaus; im Graph der Beziehungsseite wird er ein Pfeil von 1.3.5 nach 1.3.4.
   - 1.3.5-3 «Allgemeine Begründungen» meint die Begründung der Ablehnung im dritten Punkt von 1.3.5-2.
   - 1.3.7-2 «sondern ausschliesslich …» → 1.3.7-1 (Fall 2).
   - 1.3.8-4 «Wird keine Diskussion verlangt und ist das einfache Mehr zugunsten des Antrags der Hauptreferentin … erreicht» knüpft an die Online-Abstimmung in 1.3.8-3 an.
   - **Nicht erfasst**, weil sie sich auf das Thema des eigenen groben Bausteins beziehen oder ohne Pronomen verständlich sind: «Zusätzlich» in 1.3.6-1 (die Prüfung aus der Einleitung), «Anschliessend» in 1.3.7-5 (nach der Qualitätssicherung 2; Alternative `bezug` auf 1.3.7-2), «die Abstimmung» in 1.3.8-3, «Zur Dokumentation der Semantik» in 1.3.3-22 (Alternative `bezug` auf 1.3.3-21), «daraus» in 1.4-1 (Fall 4).
8. **Rohtext.** `tools/extrahiere_rohtext.py` kennt drei neue Fälle: Zwischentitel (Aufzählungszeichen am linken Rand) werden eigene Absätze; Text in Abbildungen fällt weg, die Bildunterschrift bleibt; ein Zeilenumbruch nach «sechs Wochen.» auf Seite 13 ist kein Absatz (Ausnahmeliste, gegen das Word-Original geprüft). Die bisherigen Rohtexte sind nach dem erneuten Lauf zeichengleich. Alle zwölf Unterkapitel von 1.3 und 1.4 stimmen Absatz für Absatz mit dem Word-Original überein. Im Word-Original beginnt die erste Klausel von 1.3.2 mit einem Leerzeichen (« [MUSS] …»), im PDF sichtbar als Einzug; der Rohtext lässt es weg wie jeden Leerraum am Absatzanfang.
9. **«d.h.» in 1.3.8-3** steht im Original ohne Leerzeichen. Der Textvergleich zeigt, ob Pandoc daraus etwas macht (vgl. «d. h.» in 1.3.9, E50).
10. **Labels** bleiben unter 50 Zeichen; das längste ist `bb:keine-wiederholung-aus-ech-dokumenten` (40).
