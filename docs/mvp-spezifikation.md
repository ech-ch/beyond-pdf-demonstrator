# MVP-Spezifikation Demonstrator «Beyond PDF»

Stand: 2.11.2026 (Grilling-Session 1, laufend nachgeführt). Alle Festlegungen gelten vorläufig (MVP) und werden nach dem 12.11.2026 überprüft. Die Regeln zu Bausteinen, IDs und Beziehungen sind ein Vorschlag und eine Diskussionsgrundlage für eCH, keine verbindliche Regel. Wie IDs künftig verwaltet werden, entscheiden die zuständigen Gremien des Vereins eCH (E28, F41). Auch wie die einzelnen Bausteine und die allgemeinen Texte aufgebaut, dargestellt und benannt sind, ist ein initialer Vorschlag: für den MVP freigegeben, bei Ausbau oder Überarbeitung änderbar (E53). Begriffe gemäss [CONTEXT.md](../CONTEXT.md), Entscheide im [Fragenlog](fragenlog.md).

## 1. Zielbild und Präsentation

**Anlass:** Mitgliederversammlung des Vereins eCH, Do 12.11.2026.

**Form (E03):** Keine Live-Demo. Der Vorgesetzte zeigt je nach Stand 1–2 Folien («hier ist, was wir haben»). Interessierte öffnen danach selbst Website und Repo und probieren den Feedback-Knopf aus. Die Projektleitung ist am Anlass nicht anwesend.

**Hauptziel:** Machbarkeit am Schmerzpunkt öK-Rückmeldungen zeigen. Der Demonstrator zeigt Folgendes:

- Rückmeldungen landen an einer festen Baustein-Adresse statt bei «Kapitel X, Seite Y».
- Das Word-Dokument entsteht trotzdem, mit korrekten Verzeichnissen und Verweisen.

**Belegfall:** Die Regel «[MUSS] Besteht nebst einem eCH-Dokument auch ein Schema …» (V11.1.0, Kap. 7.3; V12.0.0, Kap. 7.5) erhielt in der öK zu V12.0.0 mindestens vier Rückmeldungen.

- Verortet sind sie uneinheitlich: «7.5», «7.5 Version – Handhabung der Versionierung …», Seite «31» bzw. «31/32».
- Alle vier erhielten wörtlich dieselbe Antwort.
- In V12.0.0 lautet der Text zudem anders: «Implementationshilfe (XML-Schema, JSON-Schema, usw.)» statt «Schema».

**Folgen der Form:**

- Der Demo-Ablauf wird zu einem selbsterklärenden Rundgang auf der Startseite der Website (E18, Abschnitt 4.3).
- Der Hinweis «kein offizieller eCH-Standard» steht auf der Website selbst und nicht nur im README.
- Probelauf und Backup-Aufnahme am Mi 11.11. entfallen. Stattdessen geht eine unbeteiligte Person den Rundgang ohne Hilfe durch.

### Lieferzusage an den Vorgesetzten (bestätigt 2.11.2026, E04)

**Fest zugesagt:**

- Öffentliche Website `https://ech-ch.github.io/beyond-pdf-demonstrator/` mit eCH-0003 V11.1.0:
  - vollständiges Inhaltsverzeichnis (Gerüst)
  - Kapitel 7 «Formales» vollständig als Bausteine
  - übrige Kapitel als Platzhalter mit Verweis auf das Original-PDF
- Feedback-Knopf je Baustein. Er öffnet ein GitHub-Issue zu genau diesem Baustein.
- Download des erzeugten Word-Dokuments. Es enthält Deckblatt, Inhaltsverzeichnis und Querverweise, alles automatisch erzeugt.
- Startseite mit kurzem Rundgang und deutlichem Hinweis «Demonstrator, kein offizieller eCH-Standard».
- Folienpaket:
  - Vorschlag für zwei Folien («Problem → Ansatz» und «Selbst anschauen»)
  - zwei bis drei Screenshots
  - QR-Code
  - drei Sätze Text

**Geplant:** 1.1–1.2.1, Kap. 8–10 (9 und 10 als Vorlagentexte), Anhang A und Anhang F (beide Verweisziele aus 7.3).

**Wenn Zeit bleibt:** Anhang C, PDF, sichtbare Beziehungen zwischen Bausteinen.

**Termine:**

| Datum | Lieferung |
|---|---|
| erledigt | URL und QR-Code stehen fest. Repo öffentlich und Website online seit 4.11. |
| **Mo 9.11. abends** | Material an den Vorgesetzten: relevante Informationen, Visualisierungen und Storyline zur Demo und zu Beyond PDF. Die Folien erstellt er selbst (E36). |

**Rückfall:** Läuft die Word-Erzeugung nicht, wird der Umfang reduziert. Der Termin bleibt.

**Ergebnis des Meetings vom 4.11. (E36):**

1. Termin: Mo 9.11. abends. Was genau zum Material gehört, wird festgelegt, wenn der MVP steht.
2. Veröffentlichen ist freigegeben. Repo öffentlich, Pages aktiv.
3. Lizenz (F36): nicht besprochen, wird nach dem MVP geklärt.
4. Word-Original von V11.1.0 erhalten (de, fr), dazu weitere Unterlagen ([ausbau.md](ausbau.md)).

**Nicht für den Vorgesetzten:** Sichtung der Issues (F30) und GitHub-Konto als Hürde (F06) betreffen den Weiterbetrieb nach dem MVP. Im MVP gibt es dafür nur zwei Massnahmen:

- Die Startseite sagt offen, dass Feedback ein kostenloses GitHub-Konto braucht.
- Das Issue-Formular sagt, dass Feedback gesammelt und nach dem 12.11. gesichtet wird, ohne Zusage einer Antwort (Wortlaut in Session 3).

### Material für den Vorgesetzten (Stoffsammlung; Inhalt wird festgelegt, wenn der MVP steht)

| Folie | Inhalt | Quelle |
|---|---|---|
| 1 «Problem → Ansatz» | Links: vier öK-Rückmeldungen zur selben Regel, verortet als «7.5», «Seite 31», «31/32», mit viermal derselben Antwort. Rechts: dieselbe Regel als Baustein `ech-0003-bb-schema-eigene-version` mit Feedback-Symbol und Label-Ansicht «alle Rückmeldungen zu diesem Baustein». | öK-Liste V12.0.0; Website; E21 |
| 1 (Zusatz) | «ID bleibt, auch wenn sich Kapitel und Wortlaut ändern»: 7.3 → 7.5, «Schema» → «Implementationshilfe» | ADR 0002 |
| 2 «Selbst anschauen» | QR-Code zur Startseite; drei Dinge zum Ausprobieren (Rundgang); Hinweis Demonstrator | E18 |
| optional «Was die Zerlegung zeigt» | Allein Kap. 7: 7 wortgleiche oder fast gleiche Klauseln (z.B. die Regel zur Versionserhöhung viermal), 1 inhaltlicher Widerspruch (7.5 / 7.8), 16 Textfehler, alle zeichengleich erhalten und automatisch geprüft | [kap7-bausteine.md](kap7-bausteine.md), E19 |
| Screenshots | Schema-Regel auf der Website; Issue-Formular vorbefüllt; Word-Deckblatt; 7.3 im Word mit erzeugten Verweisen | AP11 |

## 2. Umfang und Stufen

Umfang gemäss E02 und E04:

| Stufe | Inhalt | Zusage |
|---|---|---|
| 1 | Gerüst aller Überschriften (Kap. 1–10, Anhänge A–F); Kap. 7 (7.1–7.10) vollständig als Bausteine; Website mit Feedback-Knopf; Word mit Deckblatt, Inhaltsverzeichnis und Querverweisen | fest zugesagt (Durchstich) |
| 1 | 1.1 Status, 1.2 Anwendungsgebiet, 1.2.1 Beschreibungsterminologie; Kap. 8; Kap. 9 und 10 als Vorlagentexte (Fassung 2022); Anhang A; Anhang F | geplant |
| 1+ | Kap. 6, Anhänge B, C, D (AP22); 1.3.4, 1.3.9, 1.3.10 (AP23); sichtbare Beziehungen (AP21); Steckbrief (AP24); Rest von 1.3 und 1.4 mit Abbildung 1 und 2 (AP25); Kap. 2–5 als Text ohne Bausteine mit Abbildung 3–6, Anhang E erzeugt (AP26) | umgesetzt am Wochenende 7./8.11. (E47–E54) |
| 2 | Vorlagentexte in der Fassung 2025 mit Umschalten über Metadaten; PDF | wenn Zeit bleibt |
| 3 | Rückmeldungsliste aus Issues; Wechsel V11.1.0 → V12.0.0 bei gleicher ID; Französisch | nach MVP |

**Nicht im MVP:** Kap. 2–5 als Bausteine. Sie sind seit AP26 als Text überführt, aber noch nicht in Bausteine zerlegt (E54); der Umbau folgt im Ausbau ([ausbau.md](ausbau.md) J). Anhang E ist seit AP26 aus den Abbildungen erzeugt (E15). Kap. 1 ist mit AP25 vollständig überführt (E52). Damit ist der ganze Standard abgebildet; Platzhalter gibt es keine mehr.

**Gerüst und Platzhalter (E05):**

- Alle rund 92 Überschriften von V11.1.0 stehen im Gerüst. Nummerierung und Inhaltsverzeichnis entsprechen damit dem Original.
- Einen festen Anker (`sec-…`) tragen nur:
  - Überschriften in Pilotkapiteln
  - Verweisziele aus überführtem Inhalt: 1.1 (aus Anhang D; Statustext, E50), 1.3.4 (aus 7.3, 7.8, 1.3.9 und Anhang D), 1.3.9 (aus Anhang C und D), 1.3.10 (aus Anhang C), 2.1.4 (aus Anhang D, `sec-standard-datenschemata`). 1.3.4, 1.3.9 und 1.3.10 sind seit AP23 Bausteine; ihre Anker sind geblieben.
  - Kapitel ohne eigenen Text vor überführten Unterkapiteln: 6 (`sec-fachgruppendokument`), 7 (`sec-formales`)
  - Kap. 2–5 als Text ohne Bausteine (AP26, E54): die Kapitel (`sec-standard`, `sec-best-practice`, `sec-hilfsmittel`, `sec-white-paper`; Stelle des Feedbacks) und die Verweisziele 2.1.1–2.1.3 und 2.2 (`sec-standard-…`, aus 2.1 und 2.1.4); Anhang E (`sec-abbildungsverzeichnis`)

  Eine Baustein-ID (`bb`) tragen nur Bausteine (E08, R7).
- Alle übrigen Überschriften erhalten einen provisorischen Anker. Sie haben keinen Feedback-Knopf.
- Jede nicht überführte Überschrift erhält diesen Platzhalter:

  > *Dieser Abschnitt ist im Demonstrator nicht in Bausteine überführt. Massgebend ist das Original: eCH-0003 V11.1.0, Seite N.*

  Er verlinkt auf die PDF-Seite. Auf der Website erscheint er als grauer Hinweiskasten, im Word als kursiver Satz. Die Seitenzahlen stammen aus dem Inhaltsverzeichnis des Originals.
- Die Startseite der Website nennt den Stand der Überführung (Stand AP26: keine Platzhalter mehr; Kap. 2–5 als Text ohne Bausteine).
- Kap. 2–5 sind seit AP26 als Text überführt, aber noch nicht in Bausteine zerlegt (E54). Unter jeder Kapitelüberschrift steht:

  > *Text überführt, noch nicht in Bausteine zerlegt. Dieses Kapitel steht wörtlich wie im Original (eCH-0003 V11.1.0, ab Seite N), aber noch ohne Baustein-IDs.*

  Auf der Website im selben grauen Kasten wie der Platzhalter, dazu: «Feedback gibt es vorerst für das ganze Kapitel; Vorschläge zum Zuschnitt in Bausteine sind willkommen.» Im Word kursiv, ohne diesen Satz.

**Referenzbaustein 7.3 Versionierung:** Bis auf «Unterkapitel 1.3.4» führen alle Verweise aus 7.3 auf überführten Inhalt:

- Kapitel 7.3, 7.5, 7.8 und 7.9
- Anhang F
- das Zitat [SemVer] in Anhang A (eCH-0150 wird aus 7.8 und 7.9 zitiert und steht ebenfalls dort)

«Unterkapitel 1.3.4» führte bis AP23 bewusst auf einen Platzhalter; seither ist 1.3.4 ein Baustein (E50).

## 3. Bausteinmodell

### 3.1 Grundsatz und Ablage (E07, [ADR 0001](adr/0001-baustein-identitaet-und-ablage.md))

**Grundsatz** (gilt auch nach einem Umbau der Ablage):

1. **Identität = ID.** Jeder Baustein, grob oder fein, hat eine eigene stabile ID, einen eigenen Anker auf der Website und eine eigene Feedback-Adresse.
2. **Jeder Baustein kann Quelle und Ziel jeder Beziehung sein**, auch über Standards hinweg. Referenziert wird nur über die ID, nie über Datei, Pfad, Kapitelnummer oder Position.
3. **Struktur und Beziehungen sind getrennt.** Die Einbettung (`is_part_of` / `has_part`) ergibt sich aus der Verschachtelung und wird erzeugt. Alle anderen Beziehungen sind davon unabhängig.

**Ablage im MVP:**

| Element | Form |
|---|---|
| Gerüst | eine Datei je Sprache. Enthält Hauptkapitel ohne eigenen Text, Platzhalter und die Einbindung der Baustein-Dateien |
| Grober Baustein | eine Datei je Unterkapitel mit eigenem Text; beginnt mit der eigenen Überschrift |
| Feiner Baustein | `:::`-Block in der Datei des groben Bausteins, bei einem Satz mitten im Absatz eine Inline-Markierung `[…]{…}` (F34) |
| Mehrfach verwendeter feiner Baustein (E27) | zeichengleiche Klausel an mehreren Stellen: einmal in `bausteine/mehrfach/<kurzname>.md`, an jeder Stelle eingebunden; mehrere Fundstellen |
| Hauptkapitel ohne eigenen Text (z.B. «1 Einleitung», «7 Formales») | kein Baustein, nur im Gerüst, kein Feedback-Knopf |
| Kapitel als Text ohne Bausteine (Kap. 2–5, E54) | eine Datei je Kapitel in `text/`, beginnt mit der Kapitelüberschrift (`.nur-text-kapitel`, `feedback-id`); alle Überschriften darunter `.nur-text`; kein `bb`; Kennzeichnungen im Text erlaubt |
| YAML-Kopfzeile in Baustein-Dateien | verboten, die CI prüft das (Spike S2) |

**Beispiel: Gerüst `ech-0003/v11.1.0/de/index.qmd` (Auszug, Stand aller Entscheide)**

Gerüst-Überschriften ohne Baustein tragen `original-seite` und, falls nicht überführt, die Klasse `.platzhalter`. Ein Filter setzt dann den Platzhalter-Text darunter (E05). Die Shortcode- und Klassennamen sind Vorschläge für die Umsetzung.

```markdown
---
title: "Leitfaden zur Genehmigung von Anträgen"
lang: de
abstract: "Der vorliegende Standard definiert gemäss den Statuten des Vereins eCH Art. 40 Abs. 3 den Standardisierungsprozess des Vereins eCH."
---

# Einleitung {original-seite="6"}

## Status {original-seite="6"}

{{< statustext >}}

{{< include bausteine/anwendungsgebiet.md >}}

{{< include bausteine/beschreibungsterminologie.md >}}

## Prozessmodule {.platzhalter original-seite="6"}

### Erarbeitung {.platzhalter original-seite="7"}

…

### Öffentliche Konsultation {#sec-oeffentliche-konsultation .platzhalter original-seite="10"}

…

# Formales {#sec-formales original-seite="27"}

{{< include bausteine/zuteilung-ech-nummer.md >}}

…

{{< include bausteine/versionierung.md >}}

…

{{< include bausteine/sicherheitsueberlegungen.md >}}

{{< vorlagentext haftungsausschluss >}}

{{< vorlagentext urheberrechte >}}

# Referenzen & Bibliographie {#sec-referenzen .appendix original-seite="34"}

{{< referenzen >}}

# Abkürzungen {.appendix .platzhalter original-seite="34"}

…

{{< include bausteine/formale-syntax.md >}}
```

Das vollständige Beispiel einer Baustein-Datei (7.3 mit der Schema-Regel) steht in 3.3.

**Bekannte Grenzen:**

- Kein Verlauf je feinem Baustein ohne Werkzeug (F33).
- Die Überschriftenebene steht in der Baustein-Datei (F32).
- Bausteine aus nicht zusammenhängendem Text und überlappende Bausteine sind nicht möglich.

Die Auslöser für eine Neubeurteilung stehen in ADR 0001.

### 3.2 Baustein-IDs (E08, [ADR 0002](adr/0002-baustein-ids.md))

| Regel | Inhalt |
|---|---|
| R1 Format | `<standard-id>-bb-<kurzname>`, also `ech-0003-bb-<kurzname>`. Die Standard-ID (`ech-0003`) ist die eigene Kennung des Standards und enthält keine Version; sie steht auch im Pfad der Website und in den Labels (E38). |
| R2 Zeichen | `a–z`, `0–9`, Bindestrich. Umlaute werden ausgeschrieben (ä→ae, ö→oe, ü→ue). |
| R3 Inhalt | Der Kurzname beschreibt den Inhalt in 1–4 deutschen Wörtern, auch für Übersetzungen. Feststehende Fachbegriffe bleiben in der Sprache des Originals, z.B. «semver», «minor», «major» (3.11.2026). Er enthält keine Kapitelnummer, keine Version und kein Präfix des Elternbausteins. Prüffrage: «Stimmt der Name noch, wenn der Baustein in ein anderes Kapitel wandert?» Zahlen sind nur als Inhalt erlaubt. |
| R4 Stabilität | Ab der ersten Veröffentlichung (Release oder Pages) wird eine ID nie geändert, auch wenn sich der Wortlaut ändert. Vorher darf sie noch angepasst werden (E27). |
| R5 Eindeutigkeit | Die ID ist eindeutig im Standard. Bei Kollisionen kommt ein unterscheidendes Inhaltswort hinzu, kein Zähler. |
| R6 Ort | Die ID steht bei jedem Baustein im Attribut `bb`. Grobe Bausteine tragen an der Überschrift zusätzlich den Anker `#sec-<kurzname>` mit demselben Kurznamen. Die CI prüft Eindeutigkeit und Übereinstimmung. Auf der Website ist jeder Baustein unter `…#<baustein-id>` erreichbar; den Anker setzt ein Filter. |
| R7 Kein Baustein | Gerüst-Überschriften ohne Baustein tragen nur einen `sec-`-Anker (z.B. die Verweisziele 1.1 und 2.1.4). |

**Grobe Bausteine Kap. 7:**

| Kap. | Baustein-ID | Anker |
|---|---|---|
| 7.1 | `ech-0003-bb-zuteilung-ech-nummer` | `sec-zuteilung-ech-nummer` |
| 7.2 | `ech-0003-bb-zulaessige-formate` | `sec-zulaessige-formate` |
| 7.3 | `ech-0003-bb-versionierung` | `sec-versionierung` |
| 7.4 | `ech-0003-bb-reifegrad` | `sec-reifegrad` |
| 7.5 | `ech-0003-bb-bearbeitungsstatus` | `sec-bearbeitungsstatus` |
| 7.6 | `ech-0003-bb-formale-aenderungen` | `sec-formale-aenderungen` |
| 7.7 | `ech-0003-bb-addendum` | `sec-addendum` |
| 7.8 | `ech-0003-bb-minor-change` | `sec-minor-change` |
| 7.9 | `ech-0003-bb-major-change` | `sec-major-change` |
| 7.10 | `ech-0003-bb-voraussetzungen-abhaengigkeiten` | `sec-voraussetzungen-abhaengigkeiten` |

**Referenzbeispiel feiner Baustein:** `ech-0003-bb-schema-eigene-version` (in V11.1.0 in 7.3, in V12.0.0 in 7.5 mit dem Wortlaut «Implementationshilfe»; die ID bleibt).

### 3.3 Metadaten (E09, [ADR 0003](adr/0003-metadaten-am-baustein.md))

**Grundsatz:** Nur erfassen, was sich nicht ableiten lässt. Ein Baustein ist jedes Element mit Attribut `bb`.

| Feld (ZHAW) | Grober Baustein | Feiner Baustein | Herkunft des Werts |
|---|---|---|---|
| `id` | `bb="…"` | `bb="…"` | Attribut, Pflicht |
| `building_block_type` | `typ="…"` | `typ="…"` | Attribut, Pflicht (Zuordnung in B8) |
| `name` | Überschrift | `name="…"` | beim feinen Baustein optional; fehlt es, erzeugt der Build den Namen aus den ersten Wörtern (E12) |
| `relationships` (`depends_on`) | – | `bezug="…"` | Attribut, nur bei Rückbezug im Text (E30) |
| `herkunft.seite` (Erweiterung) | `original-seite="27"` | `original-seite="28"` | Attribut. Pflicht nur, solange ein Standard aus einem Original überführt wird; auch an Gerüst-Überschriften (Platzhalter-Link) |
| `standard`, Dokumentversion, `herkunft.dokument` | – | – | einmal global in den Metadaten des Standards (`original: eCH-0003 V11.1.0`) |
| `status` | – | – | global `draft`, Attribut nur bei Abweichung |
| `source_reference` (`section`, `title`) | – | – | erzeugt: Fundstelle im aktuellen Build, ohne Seite |
| Einbettung, Verbindlichkeit, Beziehungen | – | – | erzeugt (B5, B6) |
| `description`, `building_block_version`, `responsible_working_group` | – | – | nicht im MVP (Abweichung von ZHAW) |

**Registry (umgesetzt mit AP14, E45):** `filters/ech_registry.lua` erzeugt bei jedem Lauf `ech-0003/v11.1.0/bausteine.json` mit allen erfassten und erzeugten Werten. Die Datei liegt neben der Website (`_site/ech-0003/v11.1.0/bausteine.json`). Verlinkt ist sie auf der Startseite und auf der Standardseite unter «Weitere Links».

| Teil | Inhalt |
|---|---|
| `hinweis` | Demonstrator, Regeln sind ein Vorschlag (E28) |
| `erzeugt` | Datum und Commit des Builds, lokal «lokal» |
| `standard` (Ebene 0) | ID, Nummer, Version, Titel (ohne Nummer, AP24), Sprache, Status, Vorlage-Fassung, Vorlagentexte mit Fassung und Fundstelle, Original, Kennzeichnungen (V4) |
| `anzahl` | grobe und feine Bausteine (V11.1.0: 14 und 54) |
| `bausteine[]` | je Baustein die Felder der Tabelle oben; dazu `granularitaet`, `kennzeichnung` (nur fein) und `verbindlichkeit` (Anzahl je Stufe, V2) |
| `gliederung[]` | jede Überschrift des Gerüsts in Reihenfolge: `section`, `title`, `ebene`, `anker`, `inhalt` (`baustein` mit `baustein`, `platzhalter`, `vorlagentext`, `statustext`, `daten` für Anhang A, `ohne_text`). Anker ohne Baustein können provisorisch sein (E05). Geprüft gegen das Inhaltsverzeichnis des Originals (AP24, E51) |

- **Fundstellen:** `source_reference` ist eine Liste, beim Mehrfachbaustein mit zwei Einträgen (E27).
- **Seiten (F43):** `herkunft.seite` enthält eine Seite je Fundstelle, in derselben Reihenfolge. Der Mehrfachbaustein trägt in der Quelle `original-seite="31 32"`; in der Registry gehört 31 zu 7.8 und 32 zu 7.9.
- **Beziehungen:** Typen sind `is_part_of`/`has_part`, `refers_to`/`is_referenced_by` und `depends_on`/`is_required_by`. Jede Beziehung hat ihre Umkehrung (W4). Selbstverweise und Verweise auf einen umschliessenden Baustein fehlen (W5).
- **Ziele:** `target_kind` gibt an, was das Ziel ist:
  - `baustein`
  - `noch_kein_baustein`: Anker einer Platzhalter-Überschrift oder einer Überschrift mit Text ohne Bausteine (Kap. 2–5, E54), mit `title` (W2)
  - `vorlagentext`, `statustext`: Anker einer Überschrift, deren Inhalt aus der Vorlage-Fassung erzeugt wird (Kap. 9 und 10 bzw. 1.1), mit `title`. Dieser Inhalt wird nie ein Baustein (ADR 0005, E50).
  - `literatur`: Schlüssel in `referenzen.yml`
  - `standard`: z.B. `eCH-0150` (W3), mit `title` und `url` des Links im Text (AP21)
- Links auf Websites sind keine Beziehungen.
- Ein Verweis auf eine andere Überschrift ohne Baustein bricht den Build ab, etwa auf ein Kapitel ohne eigenen Text. Seine Zielart ist erst zu entscheiden (E50).

Beispiel-Eintrag aus der erzeugten Registry:

```json
{
  "id": "ech-0003-bb-schema-eigene-version",
  "name": "Besteht nebst einem eCH-Dokument auch ein Schema …",
  "standard": "ech-0003",
  "building_block_type": "requirement",
  "status": "draft",
  "granularitaet": "fein",
  "source_reference": [{ "section": "7.3", "title": "Versionierung" }],
  "herkunft": { "dokument": "eCH-0003 V11.1.0", "seite": [28] },
  "kennzeichnung": "MUSS",
  "verbindlichkeit": { "MUSS": 1, "SOLLTE": 0, "DARF NICHT": 0 },
  "relationships": [
    { "type": "is_part_of", "target": "ech-0003-bb-versionierung", "target_kind": "baustein" }
  ]
}
```

`tools/pruefe.py ausgabe` prüft die Registry gegen die Quelle:

- gültiges JSON und dieselben Bausteine wie die Quelle (Stand AP23: 22 grobe, 77 feine)
- Typ, Granularität und Kennzeichnung wie in der Quelle
- `depends_on` gleich `bezug`
- je Fundstelle eine Seite
- jedes Ziel vorhanden oder als `noch_kein_baustein` (nur Platzhalter oder Text ohne Bausteine), `vorlagentext`, `statustext` (Abschnitt mit Hinweis «Vorlagentext» bzw. Statustext), `literatur` oder `standard` markiert
- Umkehrungen vollständig, keine Selbstverweise

**Ausgearbeitetes Beispiel: Baustein-Datei `bausteine/versionierung.md`** (grober Baustein 7.3 mit sieben feinen Bausteinen, darunter die Schema-Regel; Stand aller Entscheide E07–E15)

Ausgelassene Stellen sind mit «…» markiert. Absatzgrenzen und Wortlaut legt in der Umsetzung der extrahierte Rohtext fest (E19), nicht dieses Beispiel. Fest vergeben sind nur `versionierung`, `schema-eigene-version` und `externe-quelle-versionierung`. Die übrigen IDs stammen aus dem Entwurf [kap7-bausteine.md](kap7-bausteine.md) und können sich bei der Durchsicht (AP0d) noch ändern.

```markdown
## Versionierung {#sec-versionierung bb="ech-0003-bb-versionierung" typ="rule" original-seite="27"}

::: {bb="ech-0003-bb-prinzip-zielversion" typ="requirement" original-seite="27"}
[MUSS] Bei der Versionierung sämtlicher Antragsformen gilt das Prinzip der Zielversion. Das heisst ein Dokument behält über sämtliche Prozessschritte die gleiche Versionsnummer. Diese wird durch den Bearbeitungsstatus (siehe Kapitel -@sec-bearbeitungsstatus) sowie das Ausgabedatum weiter spezifiziert.
:::

::: {bb="ech-0003-bb-struktur-versionsschema-semver" typ="requirement" original-seite="27"}
[MUSS] Die Struktur erfolgt gemäss «Semantic Versioning»[@SemVer]. eCH setzt nur die Hauptelemente dieses Versionierungsschemas ein und nutzt die optionalen nicht. Es handelt sich um:

- Hauptversionsnummer (engl. «major version»)
- Nebenversionsnummer (engl. «minor version») auf inhaltlicher Ebene
- Nebenversionsnummer (engl. «patch version») auf formaler Ebene.
:::

Die einzelnen Nummern erscheinen nacheinander und sind durch einen Punkt getrennt, z.B. «3.7.1» … Die formale Syntax für das von eCH verwendete Schema ist Anhang -@sec-formale-syntax unten zu entnehmen. …

Es ist nicht gestattet, Versionsnummer zu überspringen. …

Ein Vergleich zwischen Versionen findet von rechts nach links statt, …

::: {bb="ech-0003-bb-versionsstufe-dokument" typ="requirement" original-seite="28"}
[MUSS] Bei eCH-Dokumenten führt eine punktuelle Überarbeitung gemäss Kapitel -@sec-minor-change in der Regel zu einer neuen inhaltlichen Nebenversion (als erste Version 1.1.0) und eine umfassende Überarbeitung gemäss Kapitel -@sec-major-change zu einer neuen Hauptversion (Version 2.0.0). …
:::

::: {bb="ech-0003-bb-schema-eigene-version" typ="requirement" original-seite="28"}
[MUSS] Besteht nebst einem eCH-Dokument auch ein Schema, so erhalten das Dokument und das Schema je eine eigene, unabhängige Versionsnummer.
:::

::: {bb="ech-0003-bb-versionsstufe-datenschema" typ="requirement" original-seite="28"}
[MUSS] Bei Datenschemata führen gegenüber der Vorversion inkompatible Änderungen oder neue, zwingende Attribute zu einer neuen Hauptversion, …
:::

::: {bb="ech-0003-bb-korrespondierende-schemaversion" typ="requirement" original-seite="28"}
[MUSS] Im eCH-Dokument ist festzuhalten, welche Version(en) des Schemas mit der Version des Dokuments korrespondieren.
:::

::: {bb="ech-0003-bb-externe-quelle-versionierung" typ="requirement" original-seite="28"}
[MUSS] Referenziert ein eCH-Dokument eine externe Quelle (gedruckt oder online), sind Änderungen der externen Quelle im eCH-Dokument festzuhalten oder diesbezüglich auf ein öffentlich verfügbares Protokoll in Textform zu verweisen. Die Versionierung des eCH-Dokuments erfolgt gemäss Kapitel -@sec-versionierung. … In der Folge ist gemäss Unterkapitel -@sec-oeffentliche-konsultation eine öffentliche Konsultation durchzuführen.
:::
```

Daraus erzeugt der Build unter anderem:

| Erzeugt | Ergebnis für dieses Beispiel |
|---|---|
| Querverweise (E11) | «(siehe Kapitel 7.5)», «Anhang F unten», «gemäss Kapitel 7.8», «gemäss Unterkapitel 1.3.4», «Semantic Versioning»[SemVer], alle zeichengleich |
| Einbettung (E10, W4) | 7 feine Bausteine `is_part_of` `ech-0003-bb-versionierung` |
| Verbindlichkeit (E10, V2) | grob: 7× MUSS; jeder feine Baustein: MUSS |
| Beziehungen (E10, W1–W5) | `prinzip-zielversion` → `bearbeitungsstatus`; `struktur-versionsschema-semver` → Literatureintrag SemVer; `versionierung` (grob) → `formale-syntax` (Absatz ohne Kennzeichnung); `versionsstufe-dokument` → `minor-change`, `major-change`; `externe-quelle-versionierung` → 1.3.4 (bis AP23 «noch kein Baustein», seither `oeffentliche-konsultation`); Selbstverweis auf 7.3 nicht erfasst |
| Name des feinen Bausteins (E12) | aus den ersten Wörtern, z.B. «Besteht nebst einem eCH-Dokument auch ein Schema …» |
| Herkunft (E09) | eCH-0003 V11.1.0, Seite 27 bzw. 28 |
| Website (E18) | Anker `#ech-0003-bb-schema-eigene-version`, Feedback-Symbol am Rand, ID beim Darüberfahren |

**Ohne Original** (Standard direkt im neuen Ansatz verfasst): kein `original` in den Metadaten, kein `original-seite`, keine `herkunft` in der Registry. Sonst ist alles gleich.

### 3.4 Abgeleitete Verbindlichkeit und Beziehungen (E10)

**Verbindlichkeit:**

| Regel | Inhalt |
|---|---|
| V1 | Abgeleitet wird nur aus `[MUSS]`, `[SOLLTE]`, `[DARF NICHT]` in Klammern am Absatzanfang. Dieselben Wörter ohne Klammer zählen nicht (z.B. Tabelle in 1.2.1). |
| V2 | Ein feiner Baustein bekommt die Stufe seiner Klausel(n). Ein grober Baustein bekommt die Anzahl je Stufe, inklusive der eingebetteten feinen. |
| V3 | Absätze ohne Kennzeichnung bleiben «ohne Kennzeichnung». Der Build interpretiert nichts. |
| V4 | Das Vokabular steht in den Metadaten des Standards (V11.1.0: MUSS, SOLLTE, DARF NICHT; F22). |

Dieselbe Erkennung liefert die Zählung für D4.

**Beziehungen:**

| Regel | Inhalt |
|---|---|
| W1 | Jeder Querverweis ergibt eine Beziehung `refers_to`. Quelle ist der innerste umschliessende Baustein. |
| W2 | Ziel ist die Baustein-ID der Überschrift mit `bb`. Bei einer Platzhalter-Überschrift oder einer Überschrift mit Text ohne Bausteine (E54) ist es der Anker, markiert als «noch kein Baustein»; nach der Überführung wird daraus automatisch eine Baustein-Beziehung. Text ohne Bausteine ist selbst keine Quelle: Seine Querverweise ergeben noch keine Beziehungen. Bei einer Überschrift mit Vorlagentext oder Statustext ist es der Anker, markiert als «Vorlagentext» bzw. «Statustext» (E50). Bei einem Zitat ist es der Literatureintrag. |
| W3 | Verweise auf andere eCH-Standards werden markiert, ohne den Text zu ändern: `[«eCH-0150: Change und Releasemanagement von eCH-Standards»]{standard="eCH-0150"}`. Daraus entsteht eine Beziehung zum Standard. |
| W4 | Die Umkehrung «wird referenziert von» wird erzeugt. Die Einbettung `is_part_of` / `has_part` ergibt sich aus der Verschachtelung. |
| W5 | Selbstverweise werden nicht erfasst. |
| W6 | Manuelle Beziehungen mit Bedeutung kommen erst nach dem MVP (ADR 0003). Ausnahme: Rückbezüge im Text (E30). |
| W7 | Rückbezüge zwischen feinen Bausteinen («hierbei», «Dies», «Diese Änderung» …) werden am abhängigen Baustein als `bezug="ech-0003-bb-…"` erfasst und ergeben `depends_on` samt Umkehrung. Rückbezüge auf das Thema des eigenen groben Bausteins werden nicht erfasst (E30). |

**Stufen:** Registry mit Verbindlichkeit und Beziehungen: Stufe 1 (umgesetzt mit AP14). Sichtbar auf der Website: umgesetzt mit AP21 (E47, E48), im Word nicht:

- **Je Baustein:** «Beziehungen (n)» zum Aufklappen, ohne JavaScript. Es steht nur bei Bausteinen mit Querverweis oder Rückbezug, in einer der beiden Richtungen; die Einbettung zählt nicht. Beim groben Baustein steht es unter der Überschrift, beim feinen am Ende des Bausteins. Gruppen: «Querverweis auf», «Querverweis von», «Rückbezug auf», «Rückbezug von».
- **Übersichtsseite** `ech-0003/v11.1.0/de/beziehungen.qmd`: Graph (Mermaid) auf Ebene der groben Bausteine und Tabelle aller Beziehungen in Vorwärtsrichtung. Pfeile, die in einem Anhang beginnen, stehen nur in der Tabelle; Pfeile in einen Anhang hinein zeigt der Graph (F56, Variante a). Die Legende nennt nur, was im Graph vorkommt. Aufhänger ist 7.10 (separates Hilfsmittel), formuliert als Vorschlag (E28).
- **Eine Quelle:** Listen, Graph und Tabelle entstehen aus der geschriebenen `bausteine.json`. Die Übersicht liest sie aus dem Ausgabeordner und steht deshalb in der render-Liste nach der Standardseite (geprüft; Begründung E48).

### 3.5 Querverweise (E11)

**Regel:** Das Präfix steht als Text, erzeugt wird nur die Nummer.

| Original | Quelle im Baustein |
|---|---|
| (siehe Kapitel 7.5) | `(siehe Kapitel -@sec-bearbeitungsstatus)` |
| gemäss Unterkapitel 1.3.4 | `gemäss Unterkapitel -@sec-oeffentliche-konsultation` |
| (siehe 1.3.4) | `(siehe -@sec-oeffentliche-konsultation)` |
| Anhang F unten | `Anhang -@sec-formale-syntax unten` (Buchstabe erzeugt, E15) |
| gemäss Kapitel 7.1 Zuteilung einer eCH-Nummer | `gemäss Kapitel [-@sec-zuteilung-ech-nummer]{.mit-titel}` |
| «Semantic Versioning»[SemVer] | `«Semantic Versioning»[@SemVer]` |
| Verweis auf einen feinen Baustein (ohne Nummer) | `[Text](#ech-0003-bb-…)` |
| Verweis auf einen anderen eCH-Standard (W3) | `[«eCH-0150: …»]{standard="eCH-0150"}` |

| Regel | Inhalt |
|---|---|
| K1 | Keine Kapitel- oder Anhangsnummer von Hand. Die CI meldet Muster wie «Kapitel 7.3», die als reiner Text stehen. |
| K2 | Verweisziele sind nur `sec-`-Anker. Feine Bausteine werden ohne Nummer verlinkt. |
| K3 | Unaufgelöste Verweise brechen den Build ab. |

### 3.6 Feinschnitt (E12, [ADR 0004](adr/0004-feine-bausteine-normative-klauseln.md))

**Regel:** Jede normative Klausel ist ein feiner Baustein. Grenzen (E29, präzisiert E12/E14):

| Regel | Inhalt |
|---|---|
| G1 | Ein feiner Baustein reicht von seiner Kennzeichnung bis zur nächsten Kennzeichnung oder zum Ende des Unterkapitels, inklusive Aufzählungen (auch ohne «:») und Absätzen ohne Kennzeichnung, sofern sie sich auf die Klausel beziehen. |
| G2 | Absätze vor der ersten Klausel eines Unterkapitels sind Einleitung und gehören zum groben Baustein. |
| G3 | Verbindlichkeit = die der Kennzeichnung; angehängte Absätze erläutern sie, der Build interpretiert nichts. |
| G4 | Ein Absatz ohne Kennzeichnung ohne Bezug zur vorangehenden Klausel wird ein eigener feiner Baustein (z.B. Typ `descriptive`, Verbindlichkeit «ohne Kennzeichnung»). Beurteilt wird beim Überführen; festgehalten in `kap7-bausteine.md`. |

In Kap. 7 beziehen sich alle fünf ungekennzeichneten Absätze auf die vorangehende Klausel (3× 7.3-2, je 1× 7.8-5 und 7.8-6); es entsteht kein G4-Baustein. Zur Rückmeldung des Vorgesetzten: F42.

**Kap. 7:** 55 normative Klauseln (36 MUSS, 11 SOLLTE, 8 DARF NICHT) in 54 feinen Bausteinen, davon einer mehrfach verwendet (E27), und 10 grobe. Entwurf aller Baustein-IDs mit Auffälligkeiten: [kap7-bausteine.md](kap7-bausteine.md) (zur Durchsicht).

**Beispiele mit belegter öK-Rückmeldung zu V12.0.0** (für das Folienpaket):

| V11.1.0 | Klausel (Anfang) | öK V12.0.0 | Baustein-ID |
|---|---|---|---|
| 7.3 | [MUSS] Besteht nebst einem eCH-Dokument auch ein Schema … | 4 Rückmeldungen, verortet als «7.5», S. 31/32 | `ech-0003-bb-schema-eigene-version` |
| 7.3 | [MUSS] Referenziert ein eCH-Dokument eine externe Quelle … | «Versionierung externe Versionsnummern», 7.5, S. 31 | `ech-0003-bb-externe-quelle-versionierung` |
| 7.8 und 7.9 | [MUSS] Sämtliche inhaltlichen Änderungen zur Vorversion … (wortgleich an beiden Stellen) | «inhaltliche Änderungen zur Vorversion beschreiben», 7.51/7.5.2 | `ech-0003-bb-aenderungen-vorversion` (ein Baustein, zwei Fundstellen, E27) |

**Typen (ZHAW):**

| Typ | Bausteine |
|---|---|
| `requirement` | alle feinen Bausteine |
| `classification` | 7.4 Reifegrad, 7.5 Bearbeitungsstatus |
| `process` | 7.1, 7.8, 7.9 |
| `governance` | 7.6, 7.7 |
| `rule` | 7.2, 7.3, 7.10 |

**CI-Prüfung:** Jeder feine Baustein enthält höchstens eine Kennzeichnung; feine Bausteine ohne Kennzeichnung (G4) haben einen Typ ausser `requirement`. Jede Kennzeichnung steht in einem feinen Baustein (E29).

**Verfeinern statt Vergröbern:** Ein Textteil kann jederzeit nachträglich fein werden, ohne dass bestehende IDs, Beziehungen oder Issues brechen. Eine veröffentlichte ID wird nie entfernt.

### 3.7 Benötigte Filter (Stand Spikes)

| Filter / Shortcode | Aufgabe | Ausgangspunkt | Entscheid |
|---|---|---|---|
| `ech_anhang.lua` | Buchstaben der Anhänge vergeben («Anhang F – …»), Verweise auf `.appendix`-Ziele auflösen, mit `-@` nur den Buchstaben | Spike S3; umstellen von ID-Präfix auf Klasse | E11, E15 |
| `ech_titelref.lua` | Verweis «Nummer + Titel» (`.mit-titel`); auf einen Anhang «Anhang C – Glossar» (AP25); nur der Titel (`.nur-titel`, AP26) | Spike S3 | E11, E52, E54 |
| `ech_abbildungen.lua` | Bildunterschrift «Abbildung 1 – …» mit gewöhnlichen Leerzeichen; im DOCX Bild und Bildunterschrift ohne Tabelle, Formatvorlage «Beschriftung», Alternativtext, Bild mit der Unterschrift zusammengehalten (umgesetzt mit AP25); Abbildungsverzeichnis in Anhang E, im Word mit Feld PAGEREF (AP26) | neu | F10, E52, E54 |
| `ech_docx_nummern.lua` | im DOCX: Word nummeriert, Quarto-Textnummern entfernen, unnummerierte Überschriften und Anhänge in eCH-Formatvorlagen | Spike S3 (Lösung A) | Block C |
| `ech_anker.lua` | Anker = Baustein-ID, nur HTML; bei Mehrfachverwendung nur an der ersten Fundstelle (umgesetzt mit AP8) | neu | R6, E27, E35 |
| `ech_feedback.lua` | Feedback-Link je Baustein (Element mit `bb`), nur HTML (umgesetzt mit AP9) | Spike S4; umgestellt von `.baustein` auf `bb` | E08, E09, E39, E41 |
| `ech_registry.lua` | `bausteine.json`: Ebene 0, Metadaten, Fundstellen, Herkunft, Verbindlichkeit, Beziehungen mit Umkehrung; nur HTML (umgesetzt mit AP14). Setzt «Beziehungen (n)» je Baustein und füllt die Übersichtsseite (AP21); Gliederung, Steckbrief-Seite und `steckbrief.json` (AP24); Gliederung mit den Arten `text` und `verzeichnis` (AP26) | neu | E09, E10, E27, E30, E45, E48, E51, E54 |
| `ech_beziehungen.lua` | Modul, kein Filter: Darstellung der Beziehungen aus der Registry (Listen, Mermaid-Graph, Tabelle) (umgesetzt mit AP21) | neu | E47, E48 |
| `ech_steckbrief.lua` | Modul, kein Filter: Steckbrief aus Raster, `steckbrief.yml`, Texten der Sprachfassung und Registry; prüft die Codes gegen das Raster (umgesetzt mit AP24) | neu | E51 |
| `ech_referenzen.lua`, `{{< referenzen >}}` | Zitate `[@key]` aus `referenzen.yml` auf den Eintrag verlinken; Tabelle für Anhang A (umgesetzt mit AP13) | neu | E15, E32, E43 |
| `{{< statustext >}}` | Statustext 1.1 aus Vorlage-Fassung | FOAG `{{< ech status >}}` | E14 |
| `{{< vorlagentext … >}}` | Vorlagentext der gewählten Fassung einfügen, auf der Website mit Hinweis (umgesetzt mit AP12) | neu | E13, E43 |
| `ech_docx_tabellen.lua` | im DOCX: Tabellenzellen in «Tabellentext» | neu | E43 |
| `ech_docx_code.lua` | im DOCX: Codeblöcke in Consolas 9 pt, grau hinterlegt, ohne Änderung der eCH-Vorlage (umgesetzt mit AP15) | neu | E43, E46 |
| Platzhalter | Platzhalter unter nicht überführten Überschriften; Hinweis über Kapiteln, die nur als Text überführt sind (AP26) | neu | E05, E54 |
| Deckblatt-Filter (DOCX) | Titel, Hinweis, Metadatentabelle (OpenXML im Format des Originals, AP15), Zusammenfassung, Inhaltsverzeichnis-Feld, Textmarken der Fusszeile | neu; Textmarken aus Spike S3 | E17, E46 |
| `aktualisiere_felder_beim_oeffnen.py` | Word aktualisiert Felder beim Öffnen | neu (F40) | E17 |
| CI-Prüfungen (`tools/pruefe.py`, `tools/pruefe.toml`) | keine YAML-Kopfzeile in Bausteinen; ID-Regeln (Eindeutigkeit, `sec-` = `bb`); keine Nummern von Hand; je feinem Baustein höchstens eine Kennzeichnung (G4-Bausteine ohne, E29); `bezug`-Ziele; Zählung 36/11/8; Textvergleich mit dem Rohtext; unaufgelöste Verweise als Fehler; Feedback-Links (AP9); Registry (AP14); Beziehungen und Reihenfolge der render-Liste (AP21); jede Meldung «ERROR» im Log von `quarto render` (E48); Text ohne Bausteine und Anhang E (AP26) | neu (umgesetzt mit AP7) | E07, E08, E11, E12, D4, E34, E41, E45, E48, E54 |

## 4. Verzeichnisstruktur und Build-Pipeline

### 4.1 Werkzeug-Basis (E16, [ADR 0006](adr/0006-quarto-mit-foag-als-steinbruch.md))

- Neues, minimales Quarto-Projekt. Das FOAG-Template dient als Steinbruch, nicht als Fork. Übernommene Dateien werden mit Namensnennung (CC BY 4.0) ausgewiesen, Abweichungen stehen im README.
- **Übernehmen und anpassen:**
  - `title-metadata.html`, `ech.scss`, `ech_dark.scss`, `ech.svg`, `favicon.svg`
  - `typst-template.typ` und `typst-show.typ` (Stufe 2)
  - `ech_common.lua`, `ech_metadata.lua`, `ech_shortcodes.lua`, umgestellt auf die Vorlage-Fassung
  - `ech_citations.lua` und CSL nur bei Bedarf
  - Pages-Deploy
- **Nicht übernehmen:**
  - RDF/SHACL/SPARQL, LINDAS, Python-Datenpipeline, R, Java/ROBOT
  - Makefile und FOAG-Tests
  - `ech_vocabulary.yml` und `ech_captions.lua`
  - die Remote-URL des Referenzdokuments
- Quarto ist in der CI auf **1.10.19** festgelegt. Die Word-Vorlage liegt als **lokale Kopie** im Repo.
- Alle Formate entstehen in **einem** `quarto render`-Aufruf (S1).
- **Rückfall (Entscheidungstor Do 5.11.):** Nur das Word wird mit reinem Pandoc erzeugt, aus demselben zusammengesetzten Markdown mit denselben Lua-Filtern. Die Website bleibt bei Quarto.

### 4.2 Deckblatt und Inhaltsverzeichnis im Word (E17)

Ein Deckblatt-Filter erzeugt nur im DOCX, in dieser Reihenfolge:

1. Titel «eCH-0003 – Leitfaden zur Genehmigung von Anträgen» (Formatvorlage «Titel»)
2. Demonstrator-Hinweis (D5)
3. Zweispaltige Tabelle: Beschriftungen aus `vorlage/2022/deckblatt.yml`, Werte aus den Metadaten des Standards. Format wie im Word-Original (AP15, E46):
   - Rahmen 0,5 pt aussen und innen, Spalten 2622/6589 dxa, Zellränder 70 dxa, senkrecht zentriert
   - Beschriftungen fett in «Standard», Werte in «Standard»
   - die drei Dateinamen der Beilagen in «Aufzählung»
   - Website und E-Mail-Adresse verlinkt
   - eine Leerzeile vor und zwei nach der Tabelle
4. «Zusammenfassung» und Text
5. Seitenumbruch
6. Inhaltsverzeichnis als Word-Feld unter «Inhaltsverzeichnis» («TitelInhaltsverzeichnis»)
7. Seitenumbruch

Zusätzlich:

- Derselbe Filter setzt die Textmarken der Fusszeile.
- Pandoc-Titelblock und `toc` sind für DOCX abgeschaltet.
- Nach dem Rendern setzt `tools/aktualisiere_felder_beim_oeffnen.py` (nur Standardbibliothek) das Flag, damit Word Felder und Inhaltsverzeichnis beim Öffnen aktualisiert. Word fragt dabei einmal nach.
- Die Tabelle entsteht als OpenXML, weil sich Rahmen und Zellränder einer Pandoc-Tabelle nicht steuern lassen. Links darin sind Felder HYPERLINK. Die frühere Einschränkung (Rahmen aus Pandocs Tabellenvorlage) entfällt.
- Im Front matter markiert `aufzaehlung:` die Beilagen mit Aufzählung. Die Website zeigt sie weiter als Zeilen.
- Codeblöcke (Anhang F) setzt `filters/ech_docx_code.lua` in Consolas 9 pt; die eCH-Vorlage bleibt unverändert (E46).
- Die Inhaltssteuerelemente der Original-Vorlage werden nicht nachgebildet (F23, vor Abnahme).

Website: Das Deckblatt-Partial `title-metadata.html` (FOAG) verwendet dieselben Beschriftungen und Werte.

**Termin:** Das Deckblatt gehört zum Durchstich (Do 5.11.). Am Mo 9.11. folgt nur noch Feinschliff.

### 4.3 Website (E18)

| Punkt | Festlegung |
|---|---|
| Startseite `…/beyond-pdf-demonstrator/` (Ziel des QR-Codes) | Was das ist; Hinweis «kein offizieller eCH-Standard»; Hinweis auf Platzhalter; Hinweis, dass Feedback ein kostenloses GitHub-Konto braucht (F06). Rundgang mit Links: (1) Schema-Regel ansehen, direkt auf `#ech-0003-bb-schema-eigene-version`, (2) Feedback geben, (3) Word herunterladen. Links zu Repo, Fragenlog, Registry. |
| Standardseite | `…/ech-0003/v11.1.0/de/`: Deckblatt, Inhaltsverzeichnis am Rand, alle Kapitel des Gerüsts, Anker = Baustein-ID |
| Feedback-Darstellung | grober Baustein: Knopf auf der Zeile der Überschrift; feiner Baustein: dezentes Symbol am rechten Rand; Baustein-ID beim Darüberfahren sichtbar (Details Session 3) |
| Downloads | Word `DEMO_eCH-0003_V11.1.0_de.docx` (bewusst kein eCH-Dateiname) und `bausteine.json`, verlinkt auf der Standardseite |
| Nicht im MVP | Seite pro Baustein, Suche über Bausteine, Sprachumschalter |

### 4.4 Text aus dem PDF und Treueprüfung (E19)

**Grundsatz:** Ein Skript liefert den Text, die KI liefert die Struktur, ein Skript prüft. Die KI erzeugt oder ändert nie Text.

| Schritt | Wer | Was |
|---|---|---|
| 1 Extrahieren | Skript | `pdftotext -enc UTF-8 -layout`; Kopf- und Fusszeilen entfernen; Silbentrennung auflösen, inklusive alter Trennung «k-k» → «ck»; `` → `-`; Absätze zusammenfügen. Rohtext je Kapitel im Repo. |
| 2 Strukturieren | KI-gestützt | Markdown, `:::`-Blöcke, Attribute, Querverweis-Syntax und Platzhalter um den unveränderten Text legen |
| 3 Prüfen, automatisch | CI | Zählung 36/11/8; gerenderten Klartext normalisiert (Leerraum) mit dem Rohtext vergleichen, Kapitel für Kapitel. Weil gerendert verglichen wird, sind die erzeugten Nummern in Querverweisen mitgeprüft. Erzeugte Teile wie Deckblatt und 1.1 sind ausgenommen. |
| 4 Prüfen, von Hand | Projektleitung | Kap. 7 im Word neben dem PDF auf Struktur und Layout durchsehen |

**Gegenprobe:** DOCX von V11.1.0 bei der Geschäftsstelle anfragen (offen), z.B. für die URL hinter «Home (admin.ch)» in 7.3. Der Hauptweg wartet nicht darauf.

### 4.5 Verzeichnisstruktur und Umgebung (E20)

```
beyond-pdf-demonstrator/
├── README.md                     Zweck, «kein offizieller eCH-Standard», Aufbau, Namensnennung FOAG
├── CONTEXT.md                    Glossar
├── _quarto.yml                   Website-Projekt; render-Liste explizit (Startseite + Standardseiten)
├── index.qmd                     Startseite mit Rundgang
├── ech-0003/v11.1.0/
│   ├── _metadata.yml             Ebene 0, sprachneutral: Nummer, Version, Status, Daten, vorlage: 2022, original
│   ├── referenzen.yml            Daten für Anhang A
│   └── de/
│       ├── index.qmd             Gerüst; Kopfzeile mit sprachabhängiger Ebene 0 (Name, Zusammenfassung, Autoren …)
│       └── bausteine/            eine Datei je grobem Baustein, Dateiname = Kurzname
├── vorlage/
│   ├── 2022/                     haftungsausschluss.md, urheberrechte.md, statustexte.yml, deckblatt.yml
│   └── word/ech-vorlage-d-2025-11-28.docx   Referenzdokument (lokale Kopie)
├── original/
│   ├── eCH-0003_V11.1.0_d.pdf    Original (ASCII-Name)
│   └── text/                     extrahierter Rohtext je Kapitel
├── filters/                      Lua-Filter und Shortcodes (eigene und von FOAG übernommene, mit Herkunftsvermerk)
├── assets/                       SCSS, Logos, HTML-Partial, Typst (FOAG)
├── tools/                        Python: Extraktion, CI-Prüfungen, Nachbearbeitung Word
├── .github/workflows/build.yml   Prüfen → Rendern → Word nachbearbeiten → Pages
├── .github/workflows/feedback-label.yml  Labels für Feedback-Issues
├── .github/scripts/             Auswertung der Feedback-Issues mit Tests
├── .github/ISSUE_TEMPLATE/       Feedback-Formular
├── docs/                         Projektdoku (wird nicht gerendert)
└── _site/                        erzeugt, in .gitignore
```

**Grundsätze:**

- **Quelle und Ausgabe:** Alles im Repo ist Quelle. `_site/` ist erzeugt und wird nicht committet. Die CI baut und veröffentlicht direkt auf GitHub Pages. Fassungen des Words gibt es über Releases (E2). Die Alternative `input/`/`output/` mit committeten Ausgaben (Politische Geschäfte) bleibt zur späteren Diskussion offen (F38).
- **Layout:** Das Word-Referenzdokument stammt immer aus der aktuellen Vorlage vom 28.11.2025. Die Fassung 2022 liefert nur Texte und Beschriftungen (ADR 0005).
- **Original-PDF im Repo:** Kap. 10 des Standards erlaubt die Weiterverbreitung, und die Platzhalter brauchen ein stabiles Linkziel.

**Umgebung:**

- Nur ASCII-Dateinamen.
- `.gitattributes` mit `eol=lf` für md, qmd, lua, yml und py.
- Quarto 1.10.19 und Python 3.11 lokal und in der CI (`ubuntu-latest`).
- Kein LibreOffice in Stufe 1.
- Lua-Filter verwenden explizite ASCII-Klassen statt `%w` (Windows-Falle aus S4).

**Vor dem Veröffentlichen zu klären:** Lizenz des Repos (F36).

## 5. Erzeugter Inhalt und Vorlagentexte

### 5.1 Vorlagentexte (E13)

| Punkt | Festlegung |
|---|---|
| Begriff | Vorlagentext, früher «Vorlagenbaustein». Er ist kein Baustein, weil er nicht standardspezifisch ist. |
| Ablage | `vorlage/<fassung>/haftungsausschluss.md` und `…/urheberrechte.md`. Jede Datei enthält Überschrift und Text. Im selben Ordner liegen die übrigen Teile der Vorlage-Fassung (E14). |
| Fassungen | `2022`: Wortlaut wie in V11.1.0 publiziert, zeichengleich aus dem Original. `2025`: heutige Vorlage, Beilagen vom 28.11.2025 (Stufe 2). |
| Auswahl | Metadatum des Standards `vorlage: 2022`; im Gerüst `{{< vorlagentext haftungsausschluss >}}` und `{{< vorlagentext urheberrechte >}}`; ein Shortcode fügt die Datei der gewählten Fassung ein. |
| Website | kein Feedback-Knopf, keine Baustein-ID; dezenter Hinweis «Vorlagentext, zentral gepflegt, Fassung 2022» |
| Registry | Eintrag beim Standard: verwendete Vorlagentexte und Fassung |
| Kap. 8 | Sicherheitsüberlegungen ist ein normaler grober Baustein (`ech-0003-bb-sicherheitsueberlegungen`, Typ `descriptive`). |

**Unterschied der Fassungen (F19):** Die Überschriften sind gleich. Der Text ist in der Fassung 2025 durchgehend anders formuliert, z.B. «dem Benutzer» → «den Benutzenden», «der Erarbeitende» → «die Erarbeitenden», «der jeweiligen Urheber» → «der jeweiligen urhebenden Person».

### 5.2 Vorlage-Fassung (E14, [ADR 0005](adr/0005-vorlage-fassung.md))

Eine Vorlage-Fassung (`vorlage/<fassung>/`) umfasst:

| Teil | Datei (Vorschlag) | Fassung 2022 |
|---|---|---|
| Vorlagentexte | `haftungsausschluss.md`, `urheberrechte.md` | aus dem Original, Kap. 9 und 10 |
| Statustexte (1.1) | `statustexte.yml` | alle sieben Sätze aus dem Dropdown des Word-Originals, Zeichen für Zeichen (E36, E43). Sichtbar im publizierten Original ist nur «Genehmigt: Das Dokument wurde vom Vorstand genehmigt. Es hat für das definierte Einsatzgebiet im festgelegten Gültigkeitsbereich normative Kraft.» |
| Beschriftungen des Deckblatts | `deckblatt.yml` | Name, eCH-Nummer, Kategorie, Reifegrad, Version, Status, Beschluss am, Ausgabedatum, Ersetzt Version, Voraussetzungen, Beilagen, Sprachen, Autoren, Herausgeber / Vertrieb, Zusammenfassung |
| Herausgeber/Vertrieb | in `deckblatt.yml` | «Verein eCH, Mainaustrasse 30, Postfach, 8034 Zürich», «T 044 388 74 64, F 044 388 71 80», «www.ech.ch / info@ech.ch» |

Ein Status, für den die gewählte Fassung keinen Statustext hat, bricht den Build ab.

### 5.3 Anhänge (E15)

| Anhang | Im MVP | Form |
|---|---|---|
| Buchstaben | erzeugt | Klasse `.appendix` und nur der Titel; der Filter vergibt «Anhang X – » in Reihenfolge |
| A Referenzen & Bibliographie | Stufe 1 (geplant), erzeugt | Tabelle aus `referenzen.yml` mit Schlüssel, Anzeige-Kürzel und wörtlichem Text («[ISO]», «eCH-0150», «SemVer»); Zitate verlinken darauf; ein Feedback-Knopf für den ganzen Anhang |
| B Abkürzungen | Platzhalter | – |
| C Glossar | Stufe 2 | grober Baustein `ech-0003-bb-glossar`, [MUSS]-Klausel in Teil 2 als feiner Baustein |
| D Änderungen gegenüber Vorversion | Platzhalter | F13 |
| E Abbildungsverzeichnis | erzeugt (AP26) | aus den Bildunterschriften der sechs Abbildungen in Reihenfolge; Website als Liste mit Links ohne Seitenzahlen, Word in der Formatvorlage «Abbildungsverzeichnis» mit Seitenzahl als Feld PAGEREF (E54) |
| F Formale Syntax für die Versionierung | Stufe 1 (geplant) | grober Baustein `ech-0003-bb-formale-syntax`, Typ `rule`, Anker `sec-formale-syntax`; EBNF als Codeblock einschliesslich «):» |

### 5.4 Erzeugter Inhalt (E14)

| Element | Quelle |
|---|---|
| Deckblatt (Word, Website) | Metadaten des Standards (Ebene 0) und Beschriftungen der Vorlage-Fassung |
| 1.1 Status | `{{< statustext >}}` im Gerüst: Status × Statustext der Vorlage-Fassung |
| Titel, Zusammenfassung | Metadaten des Standards, keine Bausteine. Auf der Website gibt es einen Knopf «Feedback zum Standard als Ganzes». |
| Inhaltsverzeichnis, Nummerierung | Gerüst |
| Kopf- und Fusszeile (Word) | Metadaten → Textmarken `eCHNummer`, `eCHName`, `Version`, `Status`, `Ausgabedatum` (S3) |
| Platzhalter | Gerüst (E05) |
| Hinweis «Text überführt, noch nicht in Bausteine zerlegt» | Gerüst (E54) |
| Abbildungsverzeichnis (Anhang E) | Bildunterschriften (E54) |
| Demonstrator-Hinweis | D5 |
| Rückverweise, Registry | Bausteine (E10) |

Einen Übersteuerungsmechanismus gibt es im MVP nicht. Weicht erzeugter Inhalt vom Original ab, wird zuerst die Ursache gesucht, z.B. eine andere Vorlage-Fassung.

**Metadaten des Standards V11.1.0** (Ebene 0, Werte aus dem Original-Deckblatt):

| Feld | Wert |
|---|---|
| Name | Leitfaden zur Genehmigung von Anträgen |
| eCH-Nummer | eCH-0003 |
| Kategorie | Standard |
| Reifegrad | Verbreitet |
| Version | 11.1.0 |
| Status | Genehmigt |
| Beschluss am | 2022-06-22 |
| Ausgabedatum | 2022-07-25 |
| Ersetzt Version | 11.0.0 – Minor Change |
| Voraussetzungen | - |
| Beilagen | Vorlage je in Deutsch, Französisch und Englisch für Standard, Best Practice, Hilfsmittel, White Paper und Addendum, mit den drei Dateinamen |
| Sprachen | Deutsch (Original), Französisch (Übersetzung) |
| Autoren | Mitglieder des Expertenausschusses, Verein eCH; Mitarbeitende der Geschäftsstelle, Verein eCH |
| Zusammenfassung | «Der vorliegende Standard definiert gemäss den Statuten des Vereins eCH Art. 40 Abs. 3 den Standardisierungsprozess des Vereins eCH.» |
| Vorlage | 2022 |
| Original | eCH-0003 V11.1.0 (PDF) |

### 5.5 Steckbrief (E51, AP24)

Der Steckbrief von eCH-0003 V11.1.0 folgt dem Raster «eCH Steckbrief Standardisierungsinhalte» (V0.9, Entwurf der Geschäftsstelle) und erscheint als Seite `ech-0003/v11.1.0/de/steckbrief.qmd` (nur Website). Das Raster ist versioniert wie die Vorlage (Raster-Fassung, ADR 0005 sinngemäss).

| Teil | Quelle |
|---|---|
| Aufbau, Feldnamen, Auswahllisten | Raster-Fassung `vorlage/steckbrief/0.9/raster.yml`; Codes vom Demonstrator, unbekannter Code bricht den Build ab |
| Auswahlen, Stand, offene und nicht zutreffende Felder, `vorschlag` | `ech-0003/v11.1.0/steckbrief.yml` (sprachneutral) |
| Texte (Zusammenfassung, vier Fragen, freie Texte, Gründe) | Kopfzeile der Sprachfassung (`steckbrief-texte`) |
| Standard, Status, Daten | Ebene 0 (`_metadata.yml`, Titel aus der Registry), Beschriftungen der Vorlage-Fassung |
| Referenzen auf andere eCH-Standards | Registry, Ziele der Art `standard` |
| Bezüge zu externen Standards | Anhang A (`referenzen.yml`) ohne eCH-Standards, mit Fundstelle der Zitate aus der Registry |
| Inhaltliche Strukturierung | Registry, `gliederung` und Bausteine: je grober Baustein eine Zeile, ein ganz unüberführter Teil in einer Zeile |

Solange `vorschlag: true` steht, trägt jeder Abschnitt mit Texten oder Auswahlen die Kennzeichnung «Vorschlag, nicht geprüft». Die Seite liest die Registry desselben Laufs wie «Beziehungen» und steht deshalb in der render-Liste nach der Standardseite. Der Build schreibt `steckbrief.json` neben `bausteine.json` (Brücke zu DCAT, nicht ausgebaut).

## 6. Feedback (E21, E37; Session 3)

**Formular** `.github/ISSUE_TEMPLATE/feedback.yml` (E37):

| Feld | Typ | Inhalt |
|---|---|---|
| Hinweis oben | Text | siehe unten |
| Standard | vorbefüllt | Standard-ID `ech-0003` (E38) |
| Baustein-ID | vorbefüllt | z.B. `ech-0003-bb-schema-eigene-version`; `ech-0003-referenzen` bei Anhang A; `ech-0003-kapitel-standard` usw. bei Kap. 2–5 (E54); leer beim Standard als Ganzes |
| Stand | vorbefüllt | «eCH-0003 V11.1.0, Build 2026-11-09 (a05c2c3)» |
| Link zur Stelle | vorbefüllt | `…/ech-0003/v11.1.0/de/index.html#<baustein-id>` |
| Wortlaut | vorbefüllt | feiner Baustein: Text der Klausel; grober Baustein und Anhang A: eigener Text ohne die feinen Bausteine, mit Bildunterschriften, ohne eigenen Text ein Hinweis (E56); über 2 000 Zeichen gekürzt, mit «…», und so weit, dass die URL höchstens 6 000 Zeichen hat |
| Art | Auswahl, Pflicht | Zum Inhalt / Zum Zuschnitt oder zu Beziehungen / Zum Demonstrator / Frage |
| Kommentar | Text, Pflicht | |
| Vorschlag | Text, freiwillig | |

Titel: «Feedback zu <Name> (<Baustein-ID>)». Labels werden nie per URL gesetzt: Ohne Berechtigung führt das laut GitHub-Doku zu einer 404-Seite.

**Hinweis oben im Formular:**

> **Dies ist ein Demonstrator, kein offizielles Verfahren von eCH.** Ihr Feedback ist keine Rückmeldung im Sinn einer öffentlichen Konsultation und fliesst nicht in die Überarbeitung von eCH-0003 ein. Es ist öffentlich sichtbar, bitte schreiben Sie nichts Vertrauliches hinein. Wir sammeln es und nutzen es für den Ausbau des Demonstrators. Eine Antwort können wir nicht zusagen.

**Ohne Baustein:** Dasselbe Formular dient für «Feedback zum Standard als Ganzes» (`bb:gesamt`), Anhang A (`bb:referenzen`) und Kap. 2–5 als Text (`bb:kapitel-standard`, `bb:kapitel-best-practice`, `bb:kapitel-hilfsmittel`, `bb:kapitel-white-paper`; E54). Die Action liest die Kennungen ohne Baustein aus dem Attribut `feedback-id` der Quelle.

**Action `.github/workflows/feedback-label.yml` (E38):**

| Punkt | Festlegung |
|---|---|
| Auslöser, Rechte | `issues: opened`; nur `issues: write` und `contents: read` (Checkout, um IDs gegen die Quelle zu prüfen) |
| Labels | `feedback`, `standard:<standard-id>` (z.B. `standard:ech-0003`), `bb:<kurzname>`, `art:inhalt`, `art:zuschnitt`, `art:demonstrator`, `art:frage`. Fehlende Labels legt die Action an. |
| Eindeutigkeit | `standard:` und `bb:` zusammen. Der Kurzname ist nur innerhalb eines Standards eindeutig (R5), und GitHub begrenzt Labels auf 50 Zeichen. |
| Prüfung | Die ID muss in der Quelle vorkommen (`bb="…"`); sonst `bb:unbekannt`, das Issue bleibt bestehen. |
| Sicherheit | Der Issue-Text wird nur als Daten gelesen, nie in einen Shell-Befehl eingesetzt; ins Label kommt nur `[a-z0-9-]`. |
| Keine Antwort | Die Action schreibt keinen Kommentar. |
| Nur das Formular | `blank_issues_enabled: false` |
| Rückfall | Ist die Action blockiert: Suche nach der ID (`…/issues?q="<baustein-id>"`). |

Alle Rückmeldungen zu einem Baustein: `…/issues?q=label:"standard:ech-0003" label:"bb:schema-eigene-version"`.

**Darstellung auf der Website (E39):**

| Punkt | Festlegung |
|---|---|
| Grober Baustein | kleiner Knopf «Feedback» rechts auf der Zeile der Überschrift, Baustein-ID in kleiner grauer Schrift |
| Feiner Baustein | dezentes Sprechblasen-Symbol am rechten Rand; beim Darüberfahren färbt sich der Block leicht und zeigt die ID |
| ID | Link auf den eigenen Anker |
| Alle Rückmeldungen | kleiner Link neben der ID auf die Liste bei GitHub, ohne Zähler |
| Handy | nur das Symbol, immer sichtbar |
| Mehrfachbaustein | an beiden Stellen dasselbe Symbol und «erscheint auch in …» |
| Standard als Ganzes | Knopf «Feedback zum Standard» beim Deckblatt |
| Kein Knopf | Platzhalter, Vorlagentexte, Word |
| Bedienung | mit Tastatur erreichbar, für Screenreader beschriftet, beim Drucken ausgeblendet; ohne JavaScript |
| Startseite | Schritt 2 des Rundgangs erklärt das Symbol und ersetzt «folgt in Kürze» |

**Test auf der Live-Website nach dem Push (E40, D2):**

| Test | Erwartung |
|---|---|
| Testkonto ohne Schreibrechte klickt das Symbol der Schema-Regel | Formular vorbefüllt, Absenden klappt, Labels `feedback`, `standard:ech-0003`, `bb:schema-eigene-version`, `art:…` |
| Ohne Anmeldung klicken | Weiterleitung zum Login, danach wieder das vorbefüllte Formular |
| ID von Hand ändern | Label `bb:unbekannt`, das Issue bleibt bestehen |
| Längste Klausel (`struktur-versionsschema-semver`) | Wortlaut vollständig, keine Fehlerseite |
| Handy | Symbol sichtbar und antippbar |

Test-Issues werden danach gelöscht. **Beispiel-Issues (E40):** fünf, deutlich gekennzeichnet («[Beispiel]», Label `beispiel`), vier zur Schema-Regel ohne Namen und Organisationen, eines zum Zuschnitt.

**Nutzen für das Material:** Der mitgelieferte Wortlaut hält fest, worauf sich ein Feedback bezog, auch wenn sich der Text später ändert.

## 7. Definition of Done für den 12.11.

Gemäss E06.

### Durchstich (geplant Do 5.11., neu Fr 6.11., E36)

| # | Kriterium |
|---|---|
| D1 | Ein Push auf `main` baut Website und Word in der CI und veröffentlicht beides auf GitHub Pages, ohne Handarbeit. |
| D2 | Die Website zeigt alle Überschriften des Gerüsts, nummeriert wie im Original. Kap. 7 ist vollständig. Jeder Baustein hat einen ID-Anker und einen Feedback-Knopf. Der Klick öffnet ein vorbefülltes Issue mit der Baustein-ID. Getestet wird mit einem GitHub-Konto ohne Schreibrechte im Repo. |
| D3 | Das Word ist von der Website herunterladbar und verwendet das eCH-Referenzdokument. Es enthält ein Deckblatt mit den Metadaten von V11.1.0 und ein Inhaltsverzeichnis. Die Verweise in Kap. 7 lauten wie im Original. |
| D4 | Treue Kap. 7: Eine automatische Zählung ergibt 36 [MUSS], 11 [SOLLTE] und 8 [DARF NICHT]. Der normalisierte Textvergleich zwischen gerendertem Klartext und Rohtext aus dem PDF ist ohne Abweichung (E19). Kap. 7 wird im Word einmal neben dem PDF auf Struktur und Layout durchgesehen. |
| D5 | Der Hinweis «Demonstrator, kein offizieller eCH-Standard» steht auf jeder Seite der Website, im README und im Word. |

**Regeln zur Treue:**

- Fehler des Originals bleiben zeichengleich erhalten. Beispiele: «Die Nummer sind» (7.3), «nummerisch» (7.9), «Er darf nicht mehr genutzt werden» (7.5, Status «Aufgehoben») und das abschliessende «):» in Anhang F.
- Nur Artefakte der PDF-Extraktion werden bereinigt: Silbentrennung (alte Trennung «lük-kenlose» wird zu «lückenlose»), Kopf- und Fusszeilen sowie Aufzählungszeichen.
- Der Demonstrator-Hinweis im Word ist eine bewusste Abweichung vom Original. Ohne ihn liesse sich ein erzeugtes Word mit «Status: Genehmigt» mit der offiziellen Fassung verwechseln.

### Stufe 1 komplett (Mo 9.11.)

- Die geplanten Kapitel (1.1–1.2.1, Kap. 8–10, Anhang A und F) erfüllen D2–D4 sinngemäss, soweit fertig.
- Die Startseite enthält einen Rundgang und den Hinweis auf die Platzhalter.
- Das README beschreibt Zweck, Abgrenzung («kein offizieller eCH-Standard») und Aufbau und nennt das FOAG-Template (CC BY 4.0) als Quelle.
- Das Material ist an den Vorgesetzten geliefert (Mo 9.11. abends).
- **Fremdtest bestanden:** Eine Person ohne Vorwissen schafft in 10 Minuten ohne Hilfe drei Dinge: die Schema-Regel finden, ein Feedback abschicken und das Word herunterladen.

### Erfolgskriterium 12.11.

Der Vorgesetzte erhält das Material bis Mo 9.11. abends und zeigt am Anlass mindestens eine Folie mit Link oder QR-Code. Website und Feedback-Knopf funktionieren an diesem Tag für Besuchende ohne Hilfe.

**Voraussetzung:** Für D2 braucht es ein zweites GitHub-Konto ohne Mitgliedschaft in `ech-ch` und ohne Schreibrechte im Repo (AP0c).

## 8. Arbeitspakete

Abgestimmt auf den Zeitplan bis 12.11.2026. «PL» = Projektleitung. Verweise auf Entscheide in Klammern.

### Erledigt (Stand 6.11.2026)

| # | Was | Stand |
|---|---|---|
| AP0a | Meeting mit dem Vorgesetzten | 4.11., Ergebnis in E36 |
| AP0b | Word-Original V11.1.0 | erhalten; Rohtext aller Pilotkapitel bestätigt |
| AP0d | Kurznamen Kap. 7 | 3.11. (E27–E31) |
| AP1–AP4 | Repo, CI, Rohtext, Gerüst | committet, live |
| AP5 | Kap. 7 als 10 grobe und 54 feine Bausteine | committet, live |
| AP6 | Word mit Deckblatt, Inhaltsverzeichnis, Fusszeile | committet, live |
| AP7 | CI-Prüfungen (Quelle und Ausgabe) | committet, unter Linux grün |
| AP8 | Startseite mit Rundgang, Anker = Baustein-ID | committet, live (`a05c2c3`) |
| — | Session 3 (Feedback) | 6.11. (E37–E40) |
| AP9 | Feedback-Knopf, Formular, Action | live (`1f1193c`), Test bestanden (E42) |
| AP10 | D1–D5 geprüft, Tag `v0.1-durchstich` | 6.11. (E42); offen nur die Durchsicht von Kap. 7 im Word neben dem PDF (D4, Projektleitung) |

Entfallen: AP11 (Vorschau mit Go/No-Go, E36); die Screenshots gehen in AP17 auf.

### Fr 6.11. – geplante Kapitel

| # | Aufgabe | Grundlage |
|---|---|---|
| AP12 | 1.2, 1.2.1, Kap. 8, Vorlagentexte 9/10 (`{{< vorlagentext >}}`, Fassung 2022); Statustexte 2022 vollständig aus dem Word-Original; Links aus dem Word-Original ergänzen, Text unverändert («Home (admin.ch)» → `https://www.hermes.admin.ch/`, SemVer, eCH-0150) | E13, E14, E36 |
| AP13 | Anhang A (Filter, `referenzen.yml`) und Anhang F | E15 |

Was heute nicht fertig wird, rückt auf Mo 9.11. vormittags.

### Wochenende 7./8.11. – zusätzlicher Umfang (E47)

| # | Paket | Grundlage |
|---|---|---|
| AP21 | Beziehungen sichtbar: aufklappbare Liste je Baustein, Übersichtsseite mit Graph (Mermaid) und Tabelle, aus der Registry. Umgesetzt 8.11., committet als `e90d169` (E48) | E10, E30, E47, E48 |
| AP22 | A: Kap. 6, Anhang B, C, D als Bausteine. Umgesetzt 8.11., committet als `062b21a`; IDs freigegeben in [bausteine-kap6-anhaenge.md](bausteine-kap6-anhaenge.md) (E49) | E15, E47, E49 |
| AP23 | B: 1.3.4, 1.3.9, 1.3.10 als Bausteine. Dazu Nachbesserungen zu AP21/AP22: Graph ohne Pfeile aus Anhängen (F56), Zielarten «Vorlagentext» und «Statustext». Umgesetzt 8.11., committet als `aa70f36`; IDs freigegeben in [bausteine-1-3.md](bausteine-1-3.md) (E50) | E29, E30, E47, E50 |
| AP24 | Steckbrief eCH-0003 als Daten und Seite (Option A, `ausbau.md`). Umgesetzt 8.11., committet als `ad7291a`; Texte und Auswahlen freigegeben (E51, Abschnitt 5.5) | E47, E51, F46, F47 |
| AP25 | C: Rest von 1.3 und 1.4 als 9 grobe und 45 feine Bausteine; Abbildung 1 und 2 als Bild aus dem Original-PDF (`tools/schneide_abbildungen.py`, F10 vorläufig). Umgesetzt 8.11.; IDs und Fälle 1–6 freigegeben in [bausteine-1-3-und-1-4.md](bausteine-1-3-und-1-4.md) (E52), als initialer Vorschlag (E53) | E29, E30, E47, E52, E53, F10 |
| AP26 | D in der Variante «nur Text» (Entscheid der Projektleitung): Kap. 2–5 wörtlich als Text, ohne Bausteine; Querverweise erzeugt, Abbildung 3–6 aus dem Original-PDF, Hinweis über jedem Kapitel, Feedback je Kapitel (vier `feedback-id`, freigegeben); Anhang E erzeugt; zwei Links gegenüber dem Original korrigiert (F54). Umgesetzt 8.11. (E54) | E47, E53, E54, F10, F26 |

**Stichzeit Mo 9.11. 12 Uhr:** Was dann live ist, gilt als Stand des MVP.

### Mo 9.11. – Stufe 1 komplett, abends Material

| # | Aufgabe | Grundlage |
|---|---|---|
| AP14 | Registry-Filter `bausteine.json` mit Fundstelle, Herkunft, Verbindlichkeit und Beziehungen; F43 | E09, E10, E30 |
| AP15 | Feinschliff Deckblatt (Tabellenformat aus dem Word-Original), README fertig | E17, E36 |
| AP16 | Fremdtest mit einer unbeteiligten Person, nach der Stichzeit. Erledigt am 9.11.; Ergebnis und Entscheid in E55 | Stufe 1 DoD, E47, E55 |
| AP27 | Nachbesserungen aus dem Fremdtest (E55): (1) Wortlaut beim Knopf des groben Bausteins, umgesetzt 9.11., nicht committet (E56); (2) Feedback je Unterkapitel in Kap. 2–5 als grobe Bausteine, in Arbeit | E55, E56 |
| AP17 | Inhalt des Materials gemeinsam festlegen und erstellen (Informationen, Visualisierungen, Storyline, Screenshots, QR-Code); Tag `v0.3-material` (E44); **abends an den Vorgesetzten** | E36 |
| — | F45 entscheiden: Was von der Projektdoku bleibt öffentlich? | E36 |

Was im Material gezeigt wird, muss ab Montagabend stabil sein. Für Sichtbares liegt der Freeze damit einen Tag vor dem Feature-Freeze.

### Di 10.11. – Stufe 2 und Ausbau nach Priorität, abends Feature-Freeze

| # | Aufgabe | Grundlage |
|---|---|---|
| AP18 | nach Entscheid, wenn der MVP steht. Stufe 2: sichtbare Beziehungen, Anhang C, Vorlage-Fassung 2025, PDF (F37). Ausbau: [ausbau.md](ausbau.md), dort auch die empfohlene Reihenfolge. | E10, E13, E15, E36 |
| AP19 | Feature-Freeze; Tag `v1.0-mitgliederversammlung` | E22 |

### Mi 11.11. – Abschluss

| # | Aufgabe |
|---|---|
| AP20 | Fragenlog bereinigen (Stand, offene Punkte für die Zeit nach dem MVP); Website und Downloads ein letztes Mal prüfen. Probelauf und Backup-Aufnahme entfallen (E03). |

### Offen bei der Projektleitung

| # | Aufgabe | Wann |
|---|---|---|
| D4 | Kap. 7 im Word neben dem PDF auf Struktur und Layout durchsehen | vor AP17 |
| AP16 | Vertrauensperson für den Fremdtest anfragen; sie kennt den Ablauf noch nicht | erledigt 9.11. (E55) |

### Abhängigkeiten

- AP17 braucht einen stabilen Stand von AP9, AP12 und AP13.
