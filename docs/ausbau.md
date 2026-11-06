# Möglichkeiten für den Ausbau des Demonstrators

Stand: 6.11.2026. Grundlage sind die Unterlagen und Anregungen aus dem Meeting vom 4.11.2026. Nichts davon gehört zur Lieferzusage (E04). Welche Punkte umgesetzt werden, wird entschieden, wenn der MVP steht. Offene Fragen stehen im [Fragenlog](fragenlog.md) (F45–F52).

**Vorbehalt zur Veröffentlichung (F46):** V12.0.0 ist noch nicht publiziert. eCH-0299 hat den Status «In Arbeit», bei dem der Gebrauch nur innerhalb der Fachgruppe bzw. des Expertenausschusses zugelassen ist. Das Repo ist öffentlich. Inhalte aus diesen Dokumenten kommen deshalb erst mit ausdrücklicher Freigabe ins Repo. Die Umfrageresultate in eCH-0299 enthalten zudem Namen und gehören nicht in den Demonstrator.

## Neue Unterlagen

| Unterlage | Was sie bringt |
|---|---|
| eCH-0003 V11.1.0 als Word (de, fr) | Gegenprobe des Texts, Links, Dropdowns der Vorlage 2022, Grundlage für Französisch |
| eCH-0003 V12.0.0 als Word, Fassung zur Publikation | Zweite Version desselben Standards, Testfall für stabile IDs |
| Steckbrief Standardisierungsinhalte (V0.9) | Raster für Metadaten über den Standard |
| Steckbrief eCH-0299 (ältere Fassung) und Inhaltssammlung eCH-0299 | Beispiel für einen Standard, der direkt im neuen Ansatz entsteht, und für Beziehungen zwischen Standards |

## Befunde aus den Unterlagen

**Gegenprobe mit dem Word-Original (E36):** Der Rohtext aus dem PDF stimmt in allen Pilotkapiteln mit dem Word-Original überein (1.1–1.2.1, Kap. 7–10, Anhang A, C, F). Die 15 119 Zeichen von Kap. 7 sind identisch.

**V12.0.0 gegenüber V11.1.0** (Auswertung per Skript, Näherung):

- V12.0.0 hat 215 Kennzeichnungen (131 MUSS, 53 SOLLTE, 13 DARF NICHT, 18 KANN), V11.1.0 hat 174 am Absatzanfang.
- Von den 55 Klauseln aus Kap. 7 sind 22 wortgleich wiederzufinden, 15 ähnlich, 18 sind nicht automatisch zuzuordnen und müssen von Hand beurteilt werden.
- Sie verteilen sich auf neue Orte, z.B. 2.4 Addendum, 7.5 Version, 7.5.1 Minor Change, 7.8 Voraussetzungen. Das bestätigt die Annahme aus ADR 0002, dass Kapitelnummern als Kennung nicht taugen.

**Steckbrief:**

- Er hat vier Teile: Kopf- und Plandaten, strukturierte Einordnung (Zielgruppe, Verwaltungsebene, Rollen, Anwendungssituationen, Bezüge), Zusammenfassung, inhaltliche Strukturierung.
- Viele Felder sind Auswahllisten, also Vokabulare.
- Die inhaltliche Strukturierung ist ausdrücklich eine Hypothese zu den «Building Blocks». Sie entspricht dem Gerüst.

**eCH-0299:**

- Die Inhaltssammlung sieht Bezüge auf eCH-0003 ausdrücklich vor: eine Spalte «Link auf eCH-0003», die noch leer ist, und den Hinweis «mit Referenz auf entsprechenden Building Block / Kapitel im eCH-0003».
- Die Nummer 3.2 entsteht nur, weil eine Abbildungsbeschriftung als Überschrift 1 formatiert ist. Das zeigt, wie unzuverlässig Kapitelnummern als Bezug sind.
- Mehrere Punkte der Checkliste in 3.2 haben eine direkte Entsprechung in Kap. 7, etwa `ech-0003-bb-ech-nummer-vor-arbeitsbeginn` und `ech-0003-bb-aenderungen-vorversion`.

## Möglichkeiten

Die Aufwände sind Schätzungen.

### A. Steckbrief als Daten des Standards (F47)

- **Was:** Die Felder des Steckbriefs werden für eCH-0003 V11.1.0 als Daten im Repo erfasst (Ebene 0, z.B. `steckbrief.yml`) und auf der Website als Seite gezeigt. Die Auswahllisten werden Vokabulare.
- **Erzeugt statt erfasst:**
  - Referenzen auf andere Standards kommen aus den Beziehungen.
  - Die inhaltliche Strukturierung kommt aus der Registry.
- **KI-Vorschläge:** Die Texte können als Vorschlag generiert werden, wenn sie als Vorschlag gekennzeichnet und geprüft sind. E19 gilt nur für den Standardtext.
- **Wert:** ausdrücklicher Wunsch. Ebene 0 wird sichtbar, und der Steckbrief ist die Brücke zu Metadaten wie DCAT und CSSV.
- **Aufwand:** ca. 3 Stunden.
- **Voraussetzung:** Wortlaut der Felder öffentlich zeigen (F46).

### B. eCH-0299 × eCH-0003: Synopse «Erarbeitung» (F48, F49, F50)

- **Was:** eCH-0299 wird von Anfang an im neuen Ansatz angelegt: Steckbrief → Gerüst → Bausteine. Exemplarisch für Kap. 3.2 (Checkliste und FAQ) mit Beziehungen auf Bausteine von eCH-0003. Daraus entsteht eine Sicht für den Anwendungsfall «Ich will einen Standard erarbeiten: Was gilt formell, was in der Praxis?»
- **Wert:** die stärkste Geschichte. Sie zeigt Beziehungen über Standards hinweg, einen Standard ohne Original (ADR 0003) und eine Darstellung, die ein PDF nicht kann.
- **Aufwand:** ca. 1 Tag.
- **Voraussetzungen und offene Punkte:**
  - Freigabe (F46)
  - Überführung von 1.3.1 und 2.3.1 auf der formellen Seite
  - sichtbare Beziehungen auf der Website
  - Regel für feine Bausteine ohne Kennzeichnung (F48)
  - Zielversion der Beziehungen (F49): eCH-0299 stützt sich auf die laufende Revision, also auf V12.0.0

### C. V12.0.0 als zweite Version (F51)

- **Was:** Kap. 7 von V12.0.0 unter `ech-0003/v12.0.0/de/` mit denselben IDs, dazu der Vergleich je Baustein.
- **Wert:** belegt «ID bleibt, Kapitel und Wortlaut ändern sich» am echten Fall. Grundlage für Änderungen je Baustein (F08, F13, F33).
- **Aufwand:**
  - ganz Kap. 7: ca. 1 Tag, davon die Zuordnung der 18 Klauseln von Hand
  - kleine Variante mit den Beispielen aus 3.6: ca. 2 Stunden
- **Voraussetzung:** Freigabe (F46) oder Publikation von V12.0.0.

### D. Französisch für Kap. 7 (F52)

- **Was:** `ech-0003/v11.1.0/fr/` mit denselben IDs, Text per Skript aus dem Word-Original, Kennzeichnungen [DOIT], [DEVRAIT], [NE DOIT PAS].
- **Wert:** prüft die Mehrsprachigkeit früh. Für einen zweisprachigen Verein gut sichtbar.
- **Aufwand:** ca. 2–3 Stunden.
- **Voraussetzung:** keine, die französische Fassung ist publiziert.

### E. Zuschnitt von Bausteinen als Feedback (F42)

- **Was:** Eine eigene Art «Zuschnitt» im Feedback-Formular, etwa «Dieser Baustein sollte feiner aufgeteilt werden». Die offene Zuordnung ungekennzeichneter Absätze wird so selbst zum Anwendungsfall, mit ein bis zwei Beispielen wie 7.3-7 (fünf Sätze, mehrere Regeln).
- **Wert:** zeigt, dass der Zuschnitt zur Diskussion steht (E28).
- **Aufwand:** Minuten, gehört in Session 3.

### F. Word-Original für das Layout

- **Was:** V11.1.0 als Word mit dem Referenzdokument aus dem Original statt der heutigen Vorlage erzeugen, oder nur das Tabellenformat des Deckblatts übernehmen.
- **Wert:** näher am Original. Die Tabelle gehört zum Feinschliff (AP15), der Rest ist optional (F23).
- **Aufwand:** ca. 1 Stunde.

## Empfohlene Reihenfolge, wenn der MVP steht

1. E (in Session 3 ohnehin dabei)
2. sichtbare Beziehungen aus Stufe 2, weil B darauf aufbaut und sie für sich schon viel zeigen
3. A
4. B, falls freigegeben; sonst D
5. C, sobald V12.0.0 publiziert oder freigegeben ist

Anhang C, Vorlage-Fassung 2025 und PDF aus Stufe 2 fallen damit nach hinten.
