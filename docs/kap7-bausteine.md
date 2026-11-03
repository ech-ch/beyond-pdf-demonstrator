# Entwurf: Baustein-IDs für die normativen Klauseln in Kapitel 7 (eCH-0003 V11.1.0)

Quelle: Original-PDF eCH-0003 V11.1.0, Kap. 7, Seiten 27–32 (Text mit pdftotext extrahiert). Regeln: [MVP-Spezifikation 3.2 und 3.6](mvp-spezifikation.md), ADR 0002 und ADR 0004.
Status: **freigegeben** (Durchsicht der Projektleitung 3.11.2026, AP0d erledigt). Die `#`-Nummern (z.B. 7.3-2) sind nur Arbeitsnummern und nicht Teil der ID.

## Freigegebene Liste (Grundlage für AP5)

Stand 3.11.2026, nach Durchsicht der Projektleitung (AP0d) und den Entscheiden E27–E30. Die Abschnitte weiter unten sind die Herleitung (ursprünglicher Entwurf mit Auffälligkeiten).

**Grobe Bausteine** (Datei `bausteine/<kurzname>.md`, Anker `sec-<kurzname>`):

| Kap. | Baustein-ID | Typ | Einleitung beim groben Baustein (G2) |
|---|---|---|---|
| 7.1 | `ech-0003-bb-zuteilung-ech-nummer` | `process` | – |
| 7.2 | `ech-0003-bb-zulaessige-formate` | `rule` | – |
| 7.3 | `ech-0003-bb-versionierung` | `rule` | – |
| 7.4 | `ech-0003-bb-reifegrad` | `classification` | «Der Reifegrad gibt über die Erprobtheit …» |
| 7.5 | `ech-0003-bb-bearbeitungsstatus` | `classification` | «Der Bearbeitungsstatus dient dazu …» |
| 7.6 | `ech-0003-bb-formale-aenderungen` | `governance` | – |
| 7.7 | `ech-0003-bb-addendum` | `governance` | – |
| 7.8 | `ech-0003-bb-minor-change` | `process` | – |
| 7.9 | `ech-0003-bb-major-change` | `process` | – |
| 7.10 | `ech-0003-bb-voraussetzungen-abhaengigkeiten` | `rule` | – |

**Feine Bausteine** (alle Typ `requirement`; Verbindlichkeit aus der Kennzeichnung):

| # | Baustein-ID | Verbindlichkeit | Original-Seite | `bezug` (E30) | Hinweis |
|---|---|---|---|---|---|
| 7.1-1 | `ech-0003-bb-ech-nummer-vor-arbeitsbeginn` | MUSS | 27 | – | – |
| 7.1-2 | `ech-0003-bb-nummernvergabe-nach-eingang` | DARF NICHT | 27 | `ech-0003-bb-ech-nummer-vor-arbeitsbeginn` | – |
| 7.1-3 | `ech-0003-bb-nummernfreigabe-nach-18-monaten` | SOLLTE | 27 | – | – |
| 7.2-1 | `ech-0003-bb-nur-bearbeitbare-formate` | MUSS | 27 | – | – |
| 7.2-2 | `ech-0003-bb-grafiken-ursprungsformat-beilegen` | SOLLTE | 27 | – | – |
| 7.2-3 | `ech-0003-bb-grafiken-als-bilddatei` | MUSS | 27 | – | – |
| 7.2-4 | `ech-0003-bb-grafiken-uebersetzbarkeit` | MUSS | 27 | – | – |
| 7.3-1 | `ech-0003-bb-prinzip-zielversion` | MUSS | 27 | – | – |
| 7.3-2 | `ech-0003-bb-struktur-versionsschema-semver` | MUSS | 27 | – | angehängt (G1): 3 Absätze («Die einzelnen Nummern …», «Es ist nicht gestattet …», «Ein Vergleich …»), inkl. Verweis auf Anhang F |
| 7.3-3 | `ech-0003-bb-versionsstufe-dokument` | MUSS | 28 | – | – |
| 7.3-4 | `ech-0003-bb-schema-eigene-version` | MUSS | 28 | – | – |
| 7.3-5 | `ech-0003-bb-versionsstufe-datenschema` | MUSS | 28 | – | – |
| 7.3-6 | `ech-0003-bb-korrespondierende-schemaversion` | MUSS | 28 | – | – |
| 7.3-7 | `ech-0003-bb-externe-quelle-versionierung` | MUSS | 28 | – | – |
| 7.4-1 | `ech-0003-bb-definition-reifegrade` | MUSS | 28 | – | – |
| 7.4-2 | `ech-0003-bb-jaehrliche-reifegradpruefung` | SOLLTE | 29 | – | – |
| 7.5-1 | `ech-0003-bb-definition-bearbeitungsstatus` | MUSS | 29 | – | – |
| 7.5-2 | `ech-0003-bb-aufhebung-ohne-nachfolgeversion` | MUSS | 29 | – | – |
| 7.6-1 | `ech-0003-bb-korrekturen-durch-geschaeftsstelle` | SOLLTE | 29 | – | – |
| 7.6-2 | `ech-0003-bb-formale-nebenversion-erhoehen` | MUSS | 30 | `ech-0003-bb-korrekturen-durch-geschaeftsstelle` | – |
| 7.7-1 | `ech-0003-bb-anlass-fuer-addendum` | SOLLTE | 30 | – | – |
| 7.7-2 | `ech-0003-bb-addendum-nur-fuer-standards` | MUSS | 30 | – | – |
| 7.7-3 | `ech-0003-bb-addendum-praezisierung-schemakorrektur` | MUSS | 30 | – | – |
| 7.7-4 | `ech-0003-bb-addendum-keine-neuen-inhalte` | DARF NICHT | 30 | – | – |
| 7.7-5 | `ech-0003-bb-addendum-zu-genehmigter-version` | MUSS | 30 | – | – |
| 7.7-6 | `ech-0003-bb-addendum-ohne-neue-version` | DARF NICHT | 30 | – | – |
| 7.7-7 | `ech-0003-bb-addendum-in-nachfolgeversion` | SOLLTE | 30 | – | – |
| 7.7-8 | `ech-0003-bb-addendum-gueltigkeitsdauer` | MUSS | 30 | – | – |
| 7.7-9 | `ech-0003-bb-addendum-publikation` | SOLLTE | 30 | – | – |
| 7.7-10 | `ech-0003-bb-addendum-entscheid-protokollieren` | MUSS | 30 | – | – |
| 7.8-1 | `ech-0003-bb-kriterium-minor-change` | SOLLTE | 30 | – | – |
| 7.8-2 | `ech-0003-bb-regelfaelle-minor-change` | SOLLTE | 30 | `ech-0003-bb-kriterium-minor-change` | – |
| 7.8-3 | `ech-0003-bb-konsultation-nicht-umgehen` | DARF NICHT | 31 | – | – |
| 7.8-4 | `ech-0003-bb-inhaltliche-nebenversion-erhoehen` | MUSS | 31 | – | – |
| 7.8-5 | `ech-0003-bb-minor-anspruch-pruefen` | MUSS | 31 | `ech-0003-bb-inhaltliche-nebenversion-erhoehen` | angehängt (G1): «Wird der Anspruch auf Minor Change … gutgeheissen …» |
| 7.8-6 | `ech-0003-bb-einsprachefrist-ankuendigen` | MUSS | 31 | `ech-0003-bb-minor-anspruch-pruefen` | angehängt (G1): «Wird innerhalb der Frist keine Einsprache erhoben …» |
| 7.8-7 | `ech-0003-bb-behandlung-einsprachen` | SOLLTE | 31 | – | – |
| 7.8-8 | `ech-0003-bb-einsprachen-antworten-publizieren` | MUSS | 31 | `ech-0003-bb-einsprachefrist-ankuendigen` | – |
| 7.8-9 | `ech-0003-bb-minor-anspruch-abgelehnt` | MUSS | 31 | – | – |
| 7.8-10 | `ech-0003-bb-aenderungen-vorversion` | MUSS | 31 | – | mehrfach verwendet (7.8-10 und 7.9-3), Datei `bausteine/mehrfach/aenderungen-vorversion.md` (E27) |
| 7.8-11 | `ech-0003-bb-verfahren-ech-0150-minor` | MUSS | 31 | – | Verweis auf eCH-0150 als `standard="eCH-0150"` markieren (W3) |
| 7.9-1 | `ech-0003-bb-kriterium-major-change` | MUSS | 31 | – | – |
| 7.9-2 | `ech-0003-bb-hauptversion-erhoehen` | MUSS | 31 | – | – |
| 7.9-3 | `ech-0003-bb-aenderungen-vorversion` | MUSS | 32 | – | mehrfach verwendet (7.8-10 und 7.9-3), Datei `bausteine/mehrfach/aenderungen-vorversion.md` (E27) |
| 7.9-4 | `ech-0003-bb-verfahren-ech-0150-major` | MUSS | 32 | – | Verweis auf eCH-0150 als `standard="eCH-0150"` markieren (W3) |
| 7.10-1 | `ech-0003-bb-aufzufuehrende-voraussetzungen-standard` | MUSS | 32 | – | – |
| 7.10-2 | `ech-0003-bb-aufzufuehrende-voraussetzungen-hilfsmittel` | MUSS | 32 | – | – |
| 7.10-3 | `ech-0003-bb-keine-nicht-normative-voraussetzung` | DARF NICHT | 32 | – | – |
| 7.10-4 | `ech-0003-bb-nur-direkte-voraussetzungen` | MUSS | 32 | – | – |
| 7.10-5 | `ech-0003-bb-keine-indirekten-voraussetzungen` | DARF NICHT | 32 | – | – |
| 7.10-6 | `ech-0003-bb-bezug-auf-bestimmte-version` | MUSS | 32 | – | – |
| 7.10-7 | `ech-0003-bb-kein-bezug-ungenehmigte-dokumente` | DARF NICHT | 32 | – | – |
| 7.10-8 | `ech-0003-bb-ausnahme-bezug-ungenehmigte` | SOLLTE | 32 | `ech-0003-bb-kein-bezug-ungenehmigte-dokumente` | – |
| 7.10-9 | `ech-0003-bb-abhaengigkeiten-separates-hilfsmittel` | MUSS | 32 | – | – |
| 7.10-10 | `ech-0003-bb-abhaengigkeiten-nicht-im-dokument` | DARF NICHT | 32 | – | – |

**Summe:** 10 grobe Bausteine; 55 Klauseln in 54 feinen Bausteinen; 7 Rückbezüge; keine G4-Bausteine.

---
## Zählung und Prüfergebnis

| Verbindlichkeit | Erwartet | Gezählt |
|---|---:|---:|
| `[MUSS]` | 36 | 36 |
| `[SOLLTE]` | 11 | 11 |
| `[DARF NICHT]` | 8 | 8 |
| **Summe** | **55** | **55** |

**Prüfergebnis: Die Zählung stimmt.** Jede Kennzeichnung steht am Absatzanfang. Im Fliesstext von Kapitel 7 steht keine Kennzeichnung, und es gibt keine weiteren Arten (z.B. `[KANN]`). Gezählt wurde per Regex auf den Zeilenanfang (Z. 1029–1334) und dann von Hand gegengeprüft.

| Unterkapitel | MUSS | SOLLTE | DARF NICHT | Summe |
|---|---:|---:|---:|---:|
| 7.1 Zuteilung einer eCH-Nummer | 1 | 1 | 1 | 3 |
| 7.2 Zulässige Formate | 3 | 1 | 0 | 4 |
| 7.3 Versionierung | 7 | 0 | 0 | 7 |
| 7.4 Reifegrad | 1 | 1 | 0 | 2 |
| 7.5 Bearbeitungsstatus | 2 | 0 | 0 | 2 |
| 7.6 Formale Änderungen | 1 | 1 | 0 | 2 |
| 7.7 Addendum | 5 | 3 | 2 | 10 |
| 7.8 Minor Change | 7 | 3 | 1 | 11 |
| 7.9 Major Change | 4 | 0 | 0 | 4 |
| 7.10 Voraussetzungen und Abhängigkeiten | 5 | 1 | 4 | 10 |
| **Total** | **36** | **11** | **8** | **55** |

Alle IDs haben das Präfix `ech-0003-bb-`. Die vier vorgegebenen IDs sind mit «(fest)» markiert. Die 55 Kurznamen sind untereinander eindeutig und überschneiden sich mit keiner der reservierten Kapitel-IDs. Für die Kapitel 1–6 ist die Eindeutigkeit noch nicht geprüft, siehe Auffälligkeit A6.

---

## 7.1 Zuteilung einer eCH-Nummer

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.1-1 | MUSS | 27 | [MUSS] Bevor die Arbeiten an einem Standard, einer Best Practice, einem Hilfsmittel oder … | nein | – (nur E-Mail info@ech.ch) | `ech-0003-bb-ech-nummer-vor-arbeitsbeginn` |
| 7.1-2 | DARF NICHT | 27 | [DARF NICHT] Es besteht hierbei kein Anspruch auf eine bestimmte Nummer, diese werden nach Eingang … | nein | – | `ech-0003-bb-nummernvergabe-nach-eingang` |
| 7.1-3 | SOLLTE | 27 | [SOLLTE] Zugeteilte eCH-Nummern, welche nicht innerhalb von 18 Monaten zu einem Antrag an … | nein | – | `ech-0003-bb-nummernfreigabe-nach-18-monaten` |

Absätze ohne Kennzeichnung: keine.

## 7.2 Zulässige Formate der eingereichten Dokumente

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.2-1 | MUSS | 27 | [MUSS] Es werden nur Dokumente in bearbeitbaren Formaten angenommen, also keine PDF- oder Bilddateien. | nein | – | `ech-0003-bb-nur-bearbeitbare-formate` |
| 7.2-2 | SOLLTE | 27 | [SOLLTE] Diagramme oder Grafiken werden im jeweiligen Ursprungsformat unaufgefordert beigelegt, damit die Überarbeitung … | nein | – | `ech-0003-bb-grafiken-ursprungsformat-beilegen` |
| 7.2-3 | MUSS | 27 | [MUSS] Sind Diagramme oder Grafiken im Ursprungsformat nicht (mehr) vorhanden, können diese als … | nein | – | `ech-0003-bb-grafiken-als-bilddatei` |
| 7.2-4 | MUSS | 27 | [MUSS] Die Antragstellenden stellen sicher, dass die Übersetzungsdienste die Diagramme und Grafiken unabhängig … | nein | – | `ech-0003-bb-grafiken-uebersetzbarkeit` |

Absätze ohne Kennzeichnung: keine.

## 7.3 Versionierung

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.3-1 | MUSS | 27 | [MUSS] Bei der Versionierung sämtlicher Antragsformen gilt das Prinzip der Zielversion. Das heisst ein … | nein | Kapitel 7.5 | `ech-0003-bb-prinzip-zielversion` |
| 7.3-2 | MUSS | 27 | [MUSS] Die Struktur erfolgt gemäss «Semantic Versioning»[SemVer]. eCH setzt nur die Hauptelemente dieses … | ja (3 Punkte) | [SemVer] | `ech-0003-bb-struktur-versionsschema-semver` |
| 7.3-3 | MUSS | 28 | [MUSS] Bei eCH-Dokumenten führt eine punktuelle Überarbeitung gemäss Kapitel 7.8 in der Regel … | nein | Kapitel 7.8, Kapitel 7.9 | `ech-0003-bb-versionsstufe-dokument` |
| 7.3-4 | MUSS | 28 | [MUSS] Besteht nebst einem eCH-Dokument auch ein Schema, so erhalten das Dokument und … | nein | – | `ech-0003-bb-schema-eigene-version` (fest) |
| 7.3-5 | MUSS | 28 | [MUSS] Bei Datenschemata führen gegenüber der Vorversion inkompatible Änderungen oder neue, zwingende Attribute … | nein | – | `ech-0003-bb-versionsstufe-datenschema` |
| 7.3-6 | MUSS | 28 | [MUSS] Im eCH-Dokument ist festzuhalten, welche Version(en) des Schemas mit der Version des … | nein | – | `ech-0003-bb-korrespondierende-schemaversion` |
| 7.3-7 | MUSS | 28 | [MUSS] Referenziert ein eCH-Dokument eine externe Quelle (gedruckt oder online), sind Änderungen der … | nein | Kapitel 7.3 (Selbstverweis), Unterkapitel 1.3.4, «Home (admin.ch)» (Linktext) | `ech-0003-bb-externe-quelle-versionierung` (fest) |

Absätze ohne Kennzeichnung (nach E29/G1 Teil von 7.3-2 `struktur-versionsschema-semver`, weil sie die Klausel erläutern):
- «Die einzelnen Nummern erscheinen nacheinander und sind durch …» (S. 27–28, geht über den Seitenwechsel; enthält den Verweis auf **Anhang F** und die Festlegung «erste Version … 1.0.0»)
- «Es ist nicht gestattet, Versionsnummer zu überspringen. …» (S. 28)
- «Ein Vergleich zwischen Versionen findet von rechts nach …» (S. 28)

## 7.4 Reifegrad eines Dokuments

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.4-1 | MUSS | 28 (Liste bis 29) | [MUSS] Die Reifegrade werden folgendermassen definiert: | ja (4 Punkte: Definiert, Implementiert, Verbreitet, Auslaufend) | – | `ech-0003-bb-definition-reifegrade` |
| 7.4-2 | SOLLTE | 29 | [SOLLTE] Der Reifegrad eines Standards in einer bestimmten Version soll durch die Fachgruppe jährlich … | nein | – | `ech-0003-bb-jaehrliche-reifegradpruefung` |

Absätze ohne Kennzeichnung (Einleitung, nach E29/G2 beim groben Baustein `ech-0003-bb-reifegrad`):
- «Der Reifegrad gibt über die Erprobtheit der Dokumente Auskunft.» (S. 28, steht vor 7.4-1)

## 7.5 Bearbeitungsstatus eines Dokuments

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.5-1 | MUSS | 29 | [MUSS] Es werden dazu folgende Status verwendet: | ja (7 Punkte: In Arbeit, Entwurf, Vorschlag, Genehmigt, Abgelöst, Aufgehoben, Sistiert) | – | `ech-0003-bb-definition-bearbeitungsstatus` |
| 7.5-2 | MUSS | 29 | [MUSS] Soll ein Dokument ohne eine Nachfolgeversion aufgehoben werden, wird es mit dem Bearbeitungsstatus … | nein | «Minor Change» (implizit → 7.8) | `ech-0003-bb-aufhebung-ohne-nachfolgeversion` |

Absätze ohne Kennzeichnung (Einleitung, nach E29/G2 beim groben Baustein `ech-0003-bb-bearbeitungsstatus`):
- «Der Bearbeitungsstatus dient dazu, aufzuzeigen, in welchem Prozessschritt …» (S. 29, steht vor 7.5-1)

## 7.6 Formale Änderungen

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.6-1 | SOLLTE | 29 | [SOLLTE] Die Geschäftsstelle ist ermächtigt, auf Antrag der Fachgruppe oder der externen Antragstellenden offensichtliche … | nein | – | `ech-0003-bb-korrekturen-durch-geschaeftsstelle` |
| 7.6-2 | MUSS | 30 | [MUSS] Die Publikation erfolgt mit einer um den Wert 1 erhöhten numerischen Wert der … | nein | – | `ech-0003-bb-formale-nebenversion-erhoehen` |

Absätze ohne Kennzeichnung: keine.

## 7.7 Addendum

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.7-1 | SOLLTE | 30 | [SOLLTE] Soll ein Standard präzisiert werden, kann ein «Addendum» eingereicht werden. Dies kann etwa … | nein | – | `ech-0003-bb-anlass-fuer-addendum` |
| 7.7-2 | MUSS | 30 | [MUSS] Ein Addendum kann nur für die Antragsform Standard eingereicht werden. | nein | – | `ech-0003-bb-addendum-nur-fuer-standards` |
| 7.7-3 | MUSS | 30 | [MUSS] Es enthält nur Präzisierungen. Über ein Addendum kann auch das Datenschema korrigiert werden, … | nein | Reifegrad «Definiert» (implizit → 7.4) | `ech-0003-bb-addendum-praezisierung-schemakorrektur` |
| 7.7-4 | DARF NICHT | 30 | [DARF NICHT] Neue Inhalte sind nicht erlaubt. | nein | – | `ech-0003-bb-addendum-keine-neuen-inhalte` |
| 7.7-5 | MUSS | 30 | [MUSS] Es betrifft immer eine bestehende, bereits genehmigte und publizierte Version eines Standards. | nein | – | `ech-0003-bb-addendum-zu-genehmigter-version` |
| 7.7-6 | DARF NICHT | 30 | [DARF NICHT] Ein Addendum führt zu keiner neuen Version des Standards oder Datenschemas auf … | nein | – | `ech-0003-bb-addendum-ohne-neue-version` |
| 7.7-7 | SOLLTE | 30 | [SOLLTE] Der Inhalt eines Addendums wird bei der Erstellung einer Nachfolgeversion des Standards, sofern … | nein | – | `ech-0003-bb-addendum-in-nachfolgeversion` |
| 7.7-8 | MUSS | 30 | [MUSS] Ein Addendum bleibt so lange gültig beziehungsweise im Status «Genehmigt», wie der Standard, … | nein | Status «Genehmigt», «Aufgehoben» (implizit → 7.5) | `ech-0003-bb-addendum-gueltigkeitsdauer` |
| 7.7-9 | SOLLTE | 30 | [SOLLTE] Ein Addendum zu einem Standard wird nach Prüfung durch die Referentinnen und Referenten … | nein | – | `ech-0003-bb-addendum-publikation` |
| 7.7-10 | MUSS | 30 | [MUSS] Der Entscheid der Referentinnen und Referenten über die Genehmigung eines Addendums wird an … | nein | – | `ech-0003-bb-addendum-entscheid-protokollieren` |

Absätze ohne Kennzeichnung: keine.

## 7.8 Minor Change

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.8-1 | SOLLTE | 30 | [SOLLTE] Ein Änderungsantrag für einen Standard, eine Best Practice oder eine White Paper kann … | nein | öffentliche Konsultation (implizit → 1.3.4) | `ech-0003-bb-kriterium-minor-change` |
| 7.8-2 | SOLLTE | 30 (Liste bis 31) | [SOLLTE] Dies ist in der Regel der Fall, wenn lediglich | ja, Grenzfall: kein «:» (5 Punkte) | – | `ech-0003-bb-regelfaelle-minor-change` |
| 7.8-3 | DARF NICHT | 31 | [DARF NICHT] Mit einem Minor Change darf eine öffentliche Konsultation nicht umgangen werden. | nein | – | `ech-0003-bb-konsultation-nicht-umgehen` |
| 7.8-4 | MUSS | 31 | [MUSS] Da der Minor Change inhaltlicher Natur ist, wird die inhaltliche Nebenversion numerisch um … | nein | Kapitel 7.3, Kapitel 7.6 | `ech-0003-bb-inhaltliche-nebenversion-erhoehen` |
| 7.8-5 | MUSS | 31 | [MUSS] Ein so überarbeitetes Dokument prüfen die Referentinnen und Referenten auf Gültigkeit bezüglich Anspruchs … | nein | – | `ech-0003-bb-minor-anspruch-pruefen` |
| 7.8-6 | MUSS | 31 | [MUSS] Diese Änderung und die entsprechende Einsprachefrist (Beginn und Ende) wird auf der Webseite … | nein | – | `ech-0003-bb-einsprachefrist-ankuendigen` |
| 7.8-7 | SOLLTE | 31 | [SOLLTE] Geht innerhalb der Einsprachefrist ein begründeter, die Sache betreffender Einwand ein, wird nach … | nein | 1.3.4 | `ech-0003-bb-behandlung-einsprachen` |
| 7.8-8 | MUSS | 31 | [MUSS] Die Geschäftsstelle publiziert nach Abschluss der Frist alle eingegangenen Einsprachen inklusive der Antworten … | nein | – | `ech-0003-bb-einsprachen-antworten-publizieren` |
| 7.8-9 | MUSS | 31 | [MUSS] Wird der Anspruch auf Minor Change seitens der Referentinnen und Referenten nicht gutgeheissen, … | nein | «Major Change» (implizit → 7.9) | `ech-0003-bb-minor-anspruch-abgelehnt` |
| 7.8-10 | MUSS | 31 | [MUSS] Sämtliche inhaltlichen Änderungen zur Vorversion sind unter dem Titel «Änderungen gegenüber Vorversion» … | nein | – | `ech-0003-bb-aenderungen-vorversion` (fest, mehrfach verwendet, E27) |
| 7.8-11 | MUSS | 31 | [MUSS] Das Verfahren und die Organisation von Minor Changes richtet sich nach dem Standard … | nein | eCH-0150 | `ech-0003-bb-verfahren-ech-0150-minor` |

Absätze ohne Kennzeichnung (nach E29/G1: der erste gehört zu 7.8-5 `minor-anspruch-pruefen`, der zweite zu 7.8-6 `einsprachefrist-ankuendigen`):
- «Wird der Anspruch auf Minor Change seitens der Referentinnen …» (S. 31; legt die Einsprachefrist auf vier Wochen fest, verlängerbar auf höchstens sechs Wochen)
- «Wird innerhalb der Frist keine Einsprache erhoben, gilt …» (S. 31)

## 7.9 Major Change

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.9-1 | MUSS | 31 | [MUSS] Soll ein Dokument beziehungsweise ein Standard als Ganzes überarbeitet werden oder kann der … | nein | «Minor Change» (implizit → 7.8) | `ech-0003-bb-kriterium-major-change` |
| 7.9-2 | MUSS | 31 | [MUSS] Bei einem Major Change wird die Hauptversion nummerisch um den Wert 1 erhöht. … | nein | Kapitel 7.3 | `ech-0003-bb-hauptversion-erhoehen` |
| 7.9-3 | MUSS | 32 | [MUSS] Sämtliche inhaltlichen Änderungen zur Vorversion sind unter dem Titel «Änderungen gegenüber Vorversion» … | nein | – | `ech-0003-bb-aenderungen-vorversion` (fest, mehrfach verwendet, E27) |
| 7.9-4 | MUSS | 32 | [MUSS] Das Verfahren und die Organisation von Major Changes richtet sich nach dem Standard … | nein | eCH-0150 | `ech-0003-bb-verfahren-ech-0150-major` |

Absätze ohne Kennzeichnung: keine.

## 7.10 Darstellung von Voraussetzungen und Abhängigkeiten

| # | Verbindlichkeit | S. | Anfang der Klausel | Liste? | Querverweise | Baustein-ID |
|---|---|---|---|---|---|---|
| 7.10-1 | MUSS | 32 | [MUSS] Basiert ein Standard auf anderen Standards und setzt diese zwingend voraus, werden sie … | nein | «Voraussetzungen» (Abschnitt im Dokument) | `ech-0003-bb-aufzufuehrende-voraussetzungen-standard` |
| 7.10-2 | MUSS | 32 | [MUSS] Basiert ein Hilfsmittel oder eine Best Practice auf Standards oder Hilfsmitteln und setzt … | nein | «Voraussetzungen» (Abschnitt im Dokument) | `ech-0003-bb-aufzufuehrende-voraussetzungen-hilfsmittel` |
| 7.10-3 | DARF NICHT | 32 | [DARF NICHT] Eine normative Antragsform darf keine nicht normative Antragsform voraussetzen (z. B. Standard … | nein | – | `ech-0003-bb-keine-nicht-normative-voraussetzung` |
| 7.10-4 | MUSS | 32 | [MUSS] Es werden nur die direkt vorausgesetzten Dokumente referenziert. | nein | – | `ech-0003-bb-nur-direkte-voraussetzungen` |
| 7.10-5 | DARF NICHT | 32 | [DARF NICHT] Allfällig indirekt vorausgesetzte Dokumente werden nicht referenziert (keine Kaskade). | nein | – | `ech-0003-bb-keine-indirekten-voraussetzungen` |
| 7.10-6 | MUSS | 32 | [MUSS] Es kann nur auf eine bestimmte Version eines genehmigten oder abgelösten Dokuments Bezug … | nein | – | `ech-0003-bb-bezug-auf-bestimmte-version` |
| 7.10-7 | DARF NICHT | 32 | [DARF NICHT] Die Bezugnahme auf noch nicht genehmigte Dokumente ist nicht erlaubt. | nein | – | `ech-0003-bb-kein-bezug-ungenehmigte-dokumente` |
| 7.10-8 | SOLLTE | 32 | [SOLLTE] Ausnahmen von dieser Regel sind: | ja (2 Punkte) | – | `ech-0003-bb-ausnahme-bezug-ungenehmigte` |
| 7.10-9 | MUSS | 32 | [MUSS] Soll das Zusammenspiel beziehungsweise die Abhängigkeiten unterschiedlicher Standards, Best Practices oder Hilfsmittel … | nein | – | `ech-0003-bb-abhaengigkeiten-separates-hilfsmittel` |
| 7.10-10 | DARF NICHT | 32 | [DARF NICHT] Das Zusammenspiel beziehungsweise die Abhängigkeiten werden nicht in den betroffenen Standards, … | nein | – | `ech-0003-bb-abhaengigkeiten-nicht-im-dokument` |

Absätze ohne Kennzeichnung: keine.

---

## Auffälligkeiten

### A. Wortgleiche oder fast gleiche Klauseln

1. **7.8-10 = 7.9-3**: wortgleich. Entschieden (E27): ein Baustein `ech-0003-bb-aenderungen-vorversion` mit zwei Fundstellen, abgelegt in `bausteine/mehrfach/`.
2. **7.8-11 ≈ 7.9-4**: Die beiden Klauseln unterscheiden sich nur in «Minor Changes» und «Major Changes». Deshalb gilt die gleiche Endungsregel: `verfahren-ech-0150-minor` und `verfahren-ech-0150-major`.
3. **7.10-1 ≈ 7.10-2**: gleiche Regel mit anderem Geltungsbereich (Standard bzw. Hilfsmittel/Best Practice). Der Geltungsbereich steht deshalb als Endung (`-standard`, `-hilfsmittel`), siehe D7.
4. **Gleiche Aussage, einmal positiv und einmal negativ formuliert**. Diese Paare könnte man später zu je einem Baustein zusammenlegen. Sie sind aber getrennt gekennzeichnet und bleiben deshalb vorerst getrennt:
   - 7.7-3 «nur Präzisierungen» und 7.7-4 «Neue Inhalte sind nicht erlaubt»
   - 7.10-4 «nur die direkt vorausgesetzten» und 7.10-5 «indirekt … nicht referenziert»
   - 7.10-9 «in einem separaten Hilfsmittel» und 7.10-10 «nicht in den betroffenen Standards …»
   - 7.10-6 «nur … genehmigten oder abgelösten» und 7.10-7 «nicht genehmigte … nicht erlaubt» (überschneiden sich teilweise)
5. **Überschneidungen über Unterkapitel hinweg**:
   - 7.8-9 und der zweite Teil von 7.9-1 regeln beide den Wechsel vom Minor- ins Major-Verfahren.
   - 7.3-3 legt fest, welche Überarbeitung zu welcher Versionsstufe führt. 7.6-2, 7.8-4 und 7.9-2 regeln die Erhöhung jeweils noch einmal. Das ist kein Widerspruch, aber dieselbe Regel steht mehrfach im Text.
   - 7.7-7 (Addendum in die Nachfolgeversion einarbeiten) entspricht dem Listenpunkt in 7.8-2 «… ein Addendum eingepflegt wird».
6. **Kollisionsgefahr mit Kapitel 2–5**: In 2.3.1, 3.3.1, 4.3.1 und 5.3.1 steht je eine fast wortgleiche Klausel zu 7.1-1 («[MUSS] Vor Beginn der Arbeiten an einem neuen Standard wird eine eCH-Nummer … beantragt», analog für Best Practice, Hilfsmittel und White Paper). Wenn 7.1-1 `ech-nummer-vor-arbeitsbeginn` erhält, brauchen diese vier Klauseln eine Endung (`-standard`, `-best-practice`, `-hilfsmittel`, `-white-paper`) oder sie verweisen auf 7.1-1. Für die übrigen Kapitel ist die Eindeutigkeit noch nicht geprüft.
7. **Widerspruch zwischen 7.5-2, 7.8-2 und 7.8-4**: Nach 7.5-2 wird ein Dokument, das ohne Nachfolgeversion aufgehoben wird, mit unveränderter Versionsnummer eingereicht, «ansonsten … analog wie bei einem Minor Change». 7.8-2 zählt genau diesen Fall zu den Minor Changes. Nach 7.8-4 erhöht ein Minor Change aber zwingend die inhaltliche Nebenversion.

### B. Grenzfälle der Klauselgrenze

1. **7.3-2**: Direkt nach der Aufzählung folgt ohne Leerzeile der Absatz «Die einzelnen Nummern erscheinen …». Er führt die Klausel inhaltlich weiter und enthält den einzigen Verweis auf **Anhang F** sowie die Festlegung «erste Version = 1.0.0». Nach der Regel gehört er **nicht** zur Klausel. Darum steht in der Tabelle kein Verweis auf Anhang F. Diesen Fall bitte bewusst entscheiden.
2. **7.8-2**: Der Absatz endet mit «wenn lediglich» und nicht mit «:». Erst die Aufzählung macht den Satz vollständig. Die Liste gehört zur Klausel. Entschieden in E14: Eine unmittelbar folgende Aufzählung gehört immer zur Klausel. Die Liste geht über den Seitenwechsel 30/31.
3. **Listen über einen Seitenwechsel**: 7.4-1 (28/29) und 7.8-2 (30/31). In 7.4-1 trennt das Layout zudem einzelne Punkte durch Leerzeilen mitten im Punkt («Ver-␤␤sionen»).
4. **Normativer Inhalt in Listenpunkten**: In 7.5-1 enthalten die Punkte eigene Regeln («darf nicht mehr genutzt werden», Sistierung nach mehr als neun Monaten). Sie bleiben Teil der Klausel 7.5-1 und erhalten keinen eigenen Baustein.
5. **Normative Absätze ohne Kennzeichnung**: Sie bleiben nach der Regel beim groben Baustein.
   - 7.3 «Es ist nicht gestattet, Versionsnummer zu überspringen» ist faktisch ein DARF NICHT.
   - 7.8 «… Einsprachefrist von vier Wochen … maximal sechs Wochen» enthält eine Frist.
   - 7.8 «… gilt der Minor Change als genehmigt» legt eine Rechtsfolge fest.

   7.8-6 («Diese Änderung und die entsprechende Einsprachefrist») bezieht sich direkt auf einen dieser Absätze.
6. **Klauseln, die nur mit dem Text davor verständlich sind** (Rückbezug am Anfang). Herausgelöst stehen sie nicht für sich. Entschieden (E30): Rückbezüge auf einen anderen feinen Baustein werden als `bezug="…"` erfasst (`depends_on`): 7.1-2 → 7.1-1, 7.6-2 → 7.6-1, 7.8-2 → 7.8-1, 7.8-5 → 7.8-4, 7.8-6 → 7.8-5, 7.8-8 → 7.8-6, 7.10-8 → 7.10-7. Rückbezüge auf das Thema des eigenen groben Bausteins (7.5-1, 7.7-3/4/5) werden nicht erfasst.
   - 7.1-2 «hierbei»
   - 7.5-1 «dazu» (bezieht sich auf den Absatz ohne Kennzeichnung davor)
   - 7.6-2 «Die Publikation»
   - 7.7-3 und 7.7-5 «Es» (= Addendum), 7.7-4 ohne genanntes Subjekt
   - 7.8-2 «Dies»
   - 7.8-5 «Ein so überarbeitetes Dokument»
   - 7.8-6 «Diese Änderung»
   - 7.8-8 «der Frist»
   - 7.10-8 «dieser Regel» (= 7.10-7)
7. **Klauseln mit mehreren Regeln**, die man später feiner aufteilen könnte:
   - 7.3-7 hat fünf Sätze: Änderungen festhalten, Versionierung nach 7.3, Synchronisierung, Kopplung der Hauptversion, Konsultation nach 1.3.4.
   - 7.7-3: nur Präzisierungen, Korrektur des Datenschemas, Grenze beim Reifegrad «Definiert».
   - 7.8-7 regelt drei Fälle: begründete Einsprache, unbegründete Einsprache, Information nach einer Abweisung.
8. **Selbstverweis in 7.3-7** («gemäss Kapitel 7.3»): Wird die Klausel herausgelöst, sollte der Verweis auf den groben Baustein `ech-0003-bb-versionierung` zeigen.
9. **Kennzeichnung passt nicht zum Wortlaut** (zur Kenntnis, an der Zählung ändert das nichts):
   - 7.2-3 ist als [MUSS] gekennzeichnet, ist aber eine Erlaubnis («können … eingereicht werden») und zugleich eine Ausnahme zu 7.2-1 («keine … Bilddateien»).
   - 7.3-3 ist als [MUSS] gekennzeichnet, sagt aber «in der Regel».
   - 7.6-1 («ist ermächtigt»), 7.7-1 («kann … eingereicht werden») und 7.8-1 («kann … behandelt werden») sind als [SOLLTE] gekennzeichnet, beschreiben aber Befugnisse oder Möglichkeiten.
   - 7.1-3 ist als [SOLLTE] gekennzeichnet, ist aber als Tatsache formuliert.
   - 7.10-7 ist ein absolutes [DARF NICHT], doch 7.10-8 ([SOLLTE]) nennt Ausnahmen dazu.

### C. Textfehler des Originals

| Stelle | Original | Korrektur / Bemerkung |
|---|---|---|
| 7.3, Absatz ohne Kennzeichnung | «Die Nummer sind nicht als Zahlen …» | «Die Nummern sind …» |
| 7.3, Absatz ohne Kennzeichnung | «Versionsnummer zu überspringen» | «Versionsnummern» |
| 7.3, Absatz ohne Kennzeichnung | «lük-␤kenlose» | Trennung nach alter Regel (ck → k-k). Beim einfachen Zusammenfügen entsteht «lükkenlose»; richtig ist «lückenlose». |
| 7.3, Absatz ohne Kennzeichnung | Versionen werden «von rechts nach links» verglichen; eine Version ist höher, wenn ein Wert höher ist «wenn die anderen gleich oder tiefer sind» | Inhaltlich fehlerhaft: Beim Vergleich 1.0.5 mit 2.0.0 gelten nach dieser Regel beide Versionen als «höher». Nach SemVer wird von links nach rechts verglichen. |
| 7.3-2 | «Semantic Versioning»[SemVer] | Leerzeichen vor «[SemVer]» fehlt (Kleinigkeit) |
| 7.3-7 | «(z.B. Home (admin.ch))» | Wahrscheinlich wurde der Titel eines Hyperlinks statt des Quellennamens übernommen; das Beispiel ist so nicht verständlich. |
| 7.4-1, Punkt «Verbreitet» | «seit mehr als ein Jahr» | «seit mehr als einem Jahr» |
| 7.5-1, Punkt «Aufgehoben» | «Er darf nicht mehr genutzt werden.» | «Es darf …» (gemeint ist das Dokument) |
| 7.6-2 | «mit einer um den Wert 1 erhöhten numerischen Wert» | «mit einem um den Wert 1 erhöhten numerischen Wert» |
| 7.7-6 | «… oder Datenschemas auf den es sich bezieht» | Komma fehlt; «den» passt nur zu «Standard», nicht zu «Datenschema» |
| 7.8-1 | «eine White Paper» | «ein White Paper» |
| 7.8-4 | «betreffen nicht ein «Minor Change»» | «nicht einen …» |
| 7.8-5 | «bezüglich Anspruchs auf Minor Change» | «bezüglich des Anspruchs …» |
| 7.8-6 | «Diese Änderung und die … Einsprachefrist … wird … publiziert» | «werden» (zwei Subjekte) |
| 7.9-2 | «nummerisch»; «Der Wert der inhaltlichen und formalen Nebenversionen werden» | «numerisch» (wie in 7.8-4); «Die Werte … werden» |
| 7.8-7 und 7.3-7 | «(siehe 1.3.4)» bzw. «gemäss Unterkapitel 1.3.4» | Verweise uneinheitlich formuliert (Kleinigkeit) |

### D. Unsichere Namen (mit Alternativvorschlag)

**Durchsicht der Projektleitung (3.11.2026):**

| Nr. | Entscheid |
|---|---|
| 1 | 7.3-2 → `struktur-versionsschema-semver`. Feststehende Fachbegriffe wie «semver», «minor» und «major» sind im Kurznamen erlaubt. |
| 2 | 7.7-3 → `addendum-praezisierung-schemakorrektur` |
| 3 | 7.10-8 → `ausnahme-bezug-ungenehmigte` |
| 4, 6, 7, 9 | bleiben: `korrekturen-durch-geschaeftsstelle`, `nummernvergabe-nach-eingang`, `nummernfreigabe-nach-18-monaten`, `behandlung-einsprachen` |
| 10 | bleiben: `definition-reifegrade`, `definition-bearbeitungsstatus` |
| 11 | Themawörter bleiben, sofern spätere Entscheide nichts ändern |
| 5 | bleiben: `versionsstufe-dokument`, `versionsstufe-datenschema` («Versionsstufe» = welcher Teil der Version sich erhöht; «Versionsnummer» wäre mit `schema-eigene-version` und `korrespondierende-schemaversion` verwechselbar) |
| 8 | 7.10-1 → `aufzufuehrende-voraussetzungen-standard`, 7.10-2 → `aufzufuehrende-voraussetzungen-hilfsmittel` (Geltungsbereich als Endung, R5; Best Practice ist in «hilfsmittel» mitgemeint) |

Ebenfalls entschieden: wortgleiche Klauseln (A1 → E27), Zuordnung der Absätze ohne Kennzeichnung (B1, B5 → E29), Rückbezüge (B6 → E30).

Die drei unsichersten stehen zuerst. Der Text darunter ist der ursprüngliche Entwurf.

1. **7.3-2 `semver-hauptelemente`**: Der Name enthält das Kürzel aus dem Literaturschlüssel und ist nicht deutsch. Alternativen: `dreiteilige-versionsnummer` (rein deutsch) oder `versionsschema-semver`.
2. **7.7-3 `addendum-nur-praezisierungen`**: Der Name beschreibt nur den ersten Satz. Die Korrektur des Datenschemas mit der Grenze beim Reifegrad «Definiert» fehlt. Alternativen: `addendum-praezisierung-schemakorrektur`, oder die Klausel aufteilen (siehe B7). Der Name liegt zudem nahe bei 7.7-4.
3. **7.10-8 `ausnahme-gleichzeitige-vorlage`**: Herausgelöst ist nicht klar, wovon die Ausnahme gilt. Alternativen: `bezug-auf-parallele-antraege` oder `ausnahme-bezug-ungenehmigte`.
4. **7.6-1 `korrekturen-durch-geschaeftsstelle`**: Die Anpassung des Reifegrads ist keine «Korrektur». Alternative: `geschaeftsstelle-orthografie-reifegrad`.
5. **7.3-3 `versionsstufe-dokument` / 7.3-5 `versionsstufe-datenschema`**: «Versionsstufe» ist kein Begriff aus dem Text. Alternativen: `ueberarbeitung-bestimmt-version` bzw. `schema-kompatibilitaet-version`.
6. **7.1-2 `nummernvergabe-nach-eingang`**: Der Name beschreibt das Verfahren, nicht das Verbot. Alternative: `kein-anspruch-wunschnummer` (trifft das DARF NICHT direkter).
7. **7.1-3 `nummernfreigabe-nach-18-monaten`**: Bewusst nicht das Beispiel `freigabe-nach-18-monaten`. «Freigabe» bedeutet in eCH-0003 auch die Freigabe zur Konsultation (Kap. 1.3, 7.5), deshalb ist das Wort allein mehrdeutig.
8. **7.10-2 `voraussetzungen-auffuehren-hilfsmittel`**: Die Best Practice fehlt im Namen; mit ihr wären es 5 Wörter. Alternative: `voraussetzungen-auffuehren-best-practice`, oder die Endung `-uebrige`.
9. **7.8-7 `behandlung-einsprachen`**: Der Name ist recht allgemein. Alternative: `begruendete-einsprache-konsultation`.
10. **7.4-1 `definition-reifegrade` / 7.5-1 `definition-bearbeitungsstatus`**: Die Namen liegen nahe an den Kapitel-IDs `reifegrad` und `bearbeitungsstatus`, sind aber nicht gleich. Alternativen: `reifegradstufen` / `statuswerte-dokument`.
11. **Häufige Themawörter**: «addendum» steht in 9 von 10 Namen in 7.7, «voraussetzungen» in 3 Namen in 7.10. Es ist jeweils Inhaltswort und nicht Kapitel-Präfix, denn jede dieser Klauseln regelt selbst das Addendum bzw. den Abschnitt «Voraussetzungen». Wegen der Rückbezüge (B6) erhalten 7.7-3, 7.7-4 und 7.7-5 das Thema allerdings nur aus dem Zusammenhang.
