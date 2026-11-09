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

### A. Steckbrief als Daten des Standards (F47) – umgesetzt mit AP24 (E51)

**Stand 8.11.2026:** umgesetzt, siehe [Spezifikation 5.5](mvp-spezifikation.md) und E51. Die Seite heisst «Steckbrief»; die Texte und Auswahlen sind ein Vorschlag, bis die Projektleitung sie geprüft hat. Zusätzlich zur Beschreibung unten sind auch Bezüge zu externen Standards (Anhang A), Standard, Status und Daten erzeugt.


- **Was:** Die Felder des Steckbriefs werden für eCH-0003 V11.1.0 als Daten im Repo erfasst (Ebene 0, z.B. `steckbrief.yml`) und auf der Website als Seite gezeigt. Die Auswahllisten werden Vokabulare.
- **Erzeugt statt erfasst:**
  - Referenzen auf andere Standards kommen aus den Beziehungen.
  - Die inhaltliche Strukturierung kommt aus der Registry.
- **KI-Vorschläge:** Die Texte können als Vorschlag generiert werden, wenn sie als Vorschlag gekennzeichnet und geprüft sind. E19 gilt nur für den Standardtext.
- **Wert:** ausdrücklicher Wunsch. Ebene 0 wird sichtbar, und der Steckbrief ist die Brücke zu Metadaten wie DCAT und CSSV.
- **Aufwand:** ca. 3 Stunden.
- **Voraussetzung:** Wortlaut der Felder öffentlich zeigen (F46; für das Raster entschieden am 7.11.2026).

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

### G. Abbildungen aus den Prozessschritten erzeugen (F10)

- **Befund (AP25):** Abbildung 1 (1.3) und Abbildung 2 (1.4) zeigen dieselben zwölf Schritte in derselben Anordnung. Abbildung 2 färbt drei Bereiche ein und nennt ihre Dauer (grün «4 Wochen», blau «6 Wochen», rot «5 Wochen»); ihr fehlt der gepunktete Pfeil von «Formale QS 1» zurück zu «Erarbeitung». Abbildungen 3–6 in Kap. 2–5 sind nach F10 Varianten mit einer Auswahl der Schritte. Im Word-Original sind es eingebettete Visio-Zeichnungen.
- **Was:** Die Schritte und Übergänge einmal als Daten (z.B. `prozess.yml`: Schritte, Pfeile durchgezogen oder gepunktet, je Antragsform die Auswahl, je Schritt die Frist), daraus alle Abbildungen als Diagrammcode erzeugen (Mermaid oder Graphviz, wie der Graph der Beziehungen). Die Fristen in 1.4 und die Fristen in den Klauseln (z.B. «mindestens 6 Wochen» in 1.3.4) kämen dann aus derselben Quelle.
- **Wert:** Abweichungen wie der fehlende Pfeil würden sichtbar oder verschwinden; Kap. 2–5 bekämen ihre Abbildungen ohne Zeichnen; Beschriftung, Farben und Alternativtext entstünden aus denselben Daten; übersetzt würden nur die Beschriftungen.
- **Aufwand:** ca. ½ Tag für 1.3 und 1.4, mit Kap. 2–5 zusammen mit J (F26). Offen: ob die Darstellung dem Original nahe genug kommt (F10).
- **Befund (AP26, E54):** Abbildung 4 ist pixelgleich mit Abbildung 1, Abbildung 3 inhaltlich gleich. Abbildung 5 zeigt die nicht durchlaufenen Schritte hellgrau. Abbildung 6 fehlen beide Schritte «Übersetzung», der gepunktete Pfeil von Formale QS 1 zurück zu Erarbeitung und die gepunktete Abkürzung von Inhaltliche QS 1 zu Genehmigung / Ablehnung. Aus Daten erzeugt, würden solche Abweichungen sichtbar.

### H. Abbildungen als Originaldatei einbetten (F10)

- **Was:** Liegt eine Abbildung als Visio-Datei oder in einem anderen Format vor, sie so ins Dokument einbetten, statt sie als Bild aus dem PDF zu schneiden: im Word als eingebettetes Objekt wie im Original, auf der Website als daraus erzeugte Grafik (z.B. SVG).
- **Heute:** Abbildung 1 und 2 sind Bilddateien aus dem Original-PDF (E52); das passt für den MVP. Im Word-Original sind beide eingebettete Visio-Zeichnungen. Das Word-Original kommt nicht ins Repo; die Quelldateien müsste die Geschäftsstelle liefern.
- **Wert:** Die Abbildung bleibt bearbeitbar und entspricht dem Original, ohne Umweg über das PDF.
- **Aufwand:** offen. Zuerst prüfen, ob Quarto und Pandoc solche Objekte ins Word übernehmen können und wie die Website sie zeigt. Alternative oder Ergänzung zu G.

### I. Aufbau, Darstellung und Namen der Bausteine überarbeiten (E53)

- **Was:** Wie die Bausteine und die allgemeinen Texte aufgebaut, dargestellt und benannt sind, gesamthaft überprüfen, etwa mit Fachleuten und den Gremien des Vereins eCH. Für den MVP ist das ein initialer Vorschlag, freigegeben, aber nicht fixiert; das gilt für alle Bausteine und Kapitel. Beispiele für Gestaltungsfragen sind die Fälle 1–6 aus AP25 in [bausteine-1-3-und-1-4.md](bausteine-1-3-und-1-4.md): Zwischentitel, ein Satz mit zwei Kennzeichnungen, Absätze ohne Kennzeichnung, Verweise.
- **Wert:** Das Modell entwickelt sich aus der Diskussion weiter, statt durch den MVP festgeschrieben zu werden (E28, F41).
- **Aufwand:** offen. Vorher klären, wie Änderungen mit eingefrorenen IDs zusammengehen (F59).

### J. Kap. 2–5 in Bausteine umbauen (E54)

- **Heute:** Kap. 2–5 sind seit AP27 in grobe Bausteine gegliedert, eines je Unterkapitel mit Feedback und Beziehungen (E56); die Klauseln stehen im Text und sind noch nicht als feine Bausteine erfasst (`.klauseln-im-text`). Pfeile aus Kap. 2–5 stehen nur in der Tabelle der Beziehungen.
- **Erste Frage: F26.** Kap. 2–5 wiederholen fast wörtlich dieselben Klauseln, mit Unterschieden in Antragsform, Frist (fünf oder drei Jahre), Deklination und Verbindlichkeit ([SOLLTE] in 2.3.7, [MUSS] in 3.3.7, 4.3.4, 5.3.7). Parametrisierte Bausteine, Mehrfachverwendung (E27) oder getrennte Bausteine? Davon hängen Zuschnitt, Kurznamen und Beziehungen ab. Gleich danach F59: was mit den vier Kennungen und ihren Issues geschieht.
- **Was dann:** ID-Liste wie in AP22 bis AP25 (Grenzregeln G1–G4, `bezug`), Durchsicht durch die Projektleitung, Umbau per Skript aus den Rohtexten, die schon da sind. Die Prüfungen gegen das Word-Original laufen bereits je Kapitel.
- **Wert:** Feedback, Registry, Beziehungen und Steckbrief decken dann den ganzen Standard ab; die Wiederholungen aus 1.3.3 [DARF NICHT] werden sichtbar. Passt zu G (Abbildungen aus den Prozessschritten).
- **Aufwand:** ca. 1 Tag nach dem Entscheid zu F26. E53 gilt: Auch dieser Zuschnitt ist ein initialer Vorschlag.

### K. Automatische Antwort beim Schliessen eines Issues (E55)

- **Stand:** grobe Idee aus dem Fremdtest (9.11.2026); die Projektleitung präzisiert Zweck und Ablauf.
- **Was:** Wer Feedback gibt, soll erfahren, ob und was damit geschehen ist, ohne dass bei über 100 Rückmeldungen jede von Hand beantwortet werden muss. Beim Schliessen eines Issues schreibt eine Action je nach Status einen Standardtext, z.B. «Rückmeldung umgesetzt in Version x» mit Link auf die Änderung. Status über Labels (z.B. umgesetzt, abgelehnt, zurückgestellt, Duplikat) oder den Grund des Schliessens bei GitHub.
- **Bezug zum Standard:** eCH-0003 verlangt in 1.3.5, die Ablehnung eines Änderungsvorschlags konkret und nachvollziehbar zu begründen; allgemeine Begründungen sind nicht zulässig. Für «umgesetzt» genügt ein Standardtext, für «abgelehnt» nicht: Die Action könnte dort eine Begründung verlangen.
- **Aufwand:** ca. 1–2 Stunden, nach dem Muster der Action für die Feedback-Labels.

### L. Übersicht der Rückmeldungen aus den Issues (E55)

- **Stand:** grobe Idee aus dem Fremdtest (9.11.2026); die Projektleitung präzisiert Zweck und Ablauf.
- **Was:** Eine Tabelle, automatisch aus den Issues: Stelle (Baustein), Wortlaut, Vorschlag, Status (offen, umgesetzt, abgelehnt usw.). Für die Verantwortlichen eines Standards als Arbeitsübersicht, für die Übersetzung als Kontext. Die Labels `bb:…` verbinden jedes Issue schon heute mit einem Baustein der Registry. Möglich als Seite «Rückmeldungen», die der Build erzeugt, oder als Tabellenansicht in GitHub Projects.
- **Bezug zum Standard:** 1.3.5 verlangt, die Rückmeldungen zusammenzufassen und an die Antragstellenden zurückzumelden.
- **Aufwand:** ca. ½ Tag; der Status kommt aus K.

### M. Anhang D aus Änderungen und Rückmeldungen erzeugen (E55)

- **Stand:** grobe Idee aus dem Fremdtest (9.11.2026); die Projektleitung präzisiert Zweck und Ablauf.
- **Was:** Zwei Teile. (1) Erzeugt: welche Bausteine sich zwischen zwei Versionen geändert haben, neu sind oder wegfallen, über die Registry beider Versionen. (2) Vorschlag: Eine KI fasst daraus und aus den verknüpften Issues und Änderungen einen Text für Anhang D zusammen; Menschen prüfen und entscheiden.
- **Bezug zum Standard:** 1.3.2 verlangt, die Änderungen zur Vorversion im Einzelnen aufzuführen und zu erläutern.
- **Voraussetzung:** eine zweite Version (C) und Issues, die mit ihren Änderungen verknüpft sind (K, L).
- **Aufwand:** offen; ein erster Versuch ca. 1 Tag nach C.

## Empfohlene Reihenfolge, wenn der MVP steht

1. J (Kap. 2–5 in Bausteine), zuerst F26 klären; der MVP zeigt den ganzen Standard, aber Kap. 2–5 noch ohne Bausteine
2. E (in Session 3 ohnehin dabei)
3. sichtbare Beziehungen aus Stufe 2, weil B darauf aufbaut und sie für sich schon viel zeigen
4. A
5. B, falls freigegeben; sonst D
6. C, sobald V12.0.0 publiziert oder freigegeben ist
7. K, L, M in dieser Reihenfolge, weil sie aufeinander aufbauen; M erst nach C

Anhang C, Vorlage-Fassung 2025 und PDF aus Stufe 2 fallen damit nach hinten.
