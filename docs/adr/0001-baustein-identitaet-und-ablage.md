---
status: accepted (vorläufig, MVP; Überprüfung nach 12.11.2026)
---

# Bausteine: Identität über die ID, Ablage hybrid

Ein Baustein ist allein durch seine stabile ID identifiziert. Datei, Pfad, Kapitelnummer und Position im Dokument gehören nicht zu seiner Identität.

- Jeder Baustein, ob grob oder fein, hat einen eigenen Anker und eine eigene Feedback-Adresse.
- Jeder Baustein kann Quelle und Ziel jeder Beziehung sein, auch über Standards hinweg.
- Die Einbettung eines feinen in einen groben Baustein (`is_part_of`) wird aus der Position erzeugt. Alle anderen Beziehungen sind davon unabhängig.

Für den MVP gilt folgende Ablage:

- Jeder grobe Baustein (Unterkapitel mit eigenem Text) liegt in einer eigenen Markdown-Datei, die eine Gerüst-Datei einbindet.
- Feine Bausteine sind `:::`-Blöcke oder Inline-Markierungen in dieser Datei.
- Baustein-Dateien haben keine YAML-Kopfzeile.

Damit bleibt die Quelle lesbar wie der Standard. Gleichzeitig ist jede Beziehung unabhängig von der Grösse eines Bausteins direkt modellierbar.

## Ergänzung 3.11.2026: Mehrfachverwendung (E27)

Zeichengleiche Klauseln an mehreren Stellen sind **ein** Baustein mit mehreren Fundstellen. Ein Beispiel ist «Sämtliche inhaltlichen Änderungen zur Vorversion …» in 7.8 und 7.9.

- Ein solcher Baustein liegt einmal in `bausteine/mehrfach/` und wird an jeder Stelle eingebunden.
- Die Einbettung ist damit kein strenger Baum mehr: Ein feiner Baustein kann in mehreren groben Bausteinen eingebettet sein.
- Ähnliche, aber nicht zeichengleiche Klauseln bleiben getrennte Bausteine.

## Considered Options

- **Eine Datei pro Sprache (FOAG-Template):** einfachster Build, aber kein Änderungsverlauf je Baustein.
- **Jeder Baustein in einer eigenen Datei, auch die feinen (strikt ZHAW):** Der Verlauf je Baustein ist ohne Werkzeug sichtbar. Dafür zerfällt die Quelle in Puzzleteile, und für die Beziehungen bringt es nichts zusätzlich.
- **Strukturierte Daten (YAML mit Textfeld und Generator):** am stärksten maschinenlesbar, aber Fliesstext in YAML ist unhandlich, und für den Zeitrahmen ist ein Generator zu aufwendig.

## Consequences

- Die Lösung weicht bewusst von zwei Vorgaben ab:
  - FOAG: eine Datei pro Sprache
  - ZHAW: eine Datei pro Baustein, einzelne Sätze nur mit Begründung als Baustein
- Den Verlauf eines feinen Bausteins zeigt `git log` nicht direkt. Dafür braucht es ein Werkzeug, das Bausteine anhand ihrer ID über Versionen hinweg herauszieht (F33).
- Die Überschriftenebene steht in der Baustein-Datei, obwohl sie zur Struktur gehört (F32).
- Die CI verbietet YAML-Kopfzeilen in Baustein-Dateien. Spike S2 hat gezeigt, dass Quarto sie still in die Dokument-Metadaten übernimmt und sogar den Titel überschreibt.
- Ein späterer Umbau auf eine andere Ablage ist mechanisch, solange alle Verweise und Beziehungen ausschliesslich über IDs laufen.

## Auslöser für eine Neubeurteilung

- Eine Umsetzung nach dem ZHAW-Modell wird ersichtlich oder verlangt, etwa Versionierung je Baustein oder eine Datei je Baustein. Dann ist «jeder Baustein eine eigene Datei» zu prüfen.
- Ein Baustein braucht nicht zusammenhängenden Text. Dann sind strukturierte Daten zu prüfen.
- Derselbe Baustein soll in mehreren Standards vorkommen (gemeinsame oder parametrisierte Bausteine, F26). Innerhalb eines Standards ist das mit der Mehrfachverwendung (E27) für zeichengleiche Klauseln bereits gelöst.
- Übersetzungen weichen in der Struktur vom Original ab.
