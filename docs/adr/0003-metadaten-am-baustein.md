---
status: accepted (vorläufig, MVP; Überprüfung nach 12.11.2026)
---

# Metadaten am Baustein, Registry erzeugt, Herkunft getrennt von Fundstelle

Erfasst wird nur, was sich nicht ableiten lässt, und zwar als Attribute direkt am Baustein:

- `bb`, `typ` und `name` (nur bei feinen Bausteinen)
- optional `original-seite`

Alles Weitere erzeugt der Build und legt es in einer maschinenlesbaren Registry (`bausteine.json`) mit ZHAW-Feldnamen ab. Dazu gehören Fundstelle, Einbettung, Verbindlichkeit und Beziehungen.

Damit gibt es eine einzige Quelle. Die ZHAW-kompatible Sicht ist eine Ableitung.

## Umkehrung gegenüber ZHAW

Im ZHAW-Ansatz ist das PDF die Quelle der Wahrheit. Bausteine beschreiben es, und `source_reference` zeigt auf eine gepflegte Fundstelle im PDF.

Bei uns sind die Bausteine die Quelle, und das Dokument wird erzeugt. Daraus folgt:

- `source_reference` (Kapitel, Titel) ist erzeugter Inhalt des jeweiligen Builds.
- Die Herkunft aus einem Original (`herkunft`: Dokument, Seite) ist eine separate, optionale Angabe. Es gibt sie nur bei überführten Bausteinen.
- Ein Standard, der direkt im neuen Ansatz entsteht, hat keine Herkunft, und es fehlt ihm nichts.

## Considered Options

- **Eine YAML-Datei neben jedem groben Baustein mit allen ZHAW-Feldern:** näher am ZHAW-Template, auch für verschachtelte Felder. Die Pflege ist aber doppelt, weil IDs in YAML und Text übereinstimmen müssen. Neu zu prüfen, sobald manuelle Beziehungen mit Zielversion und Beschreibung nötig werden.
- **Zentrale, von Hand gepflegte Registry:** Sie hat dieselben Nachteile und steht noch weiter weg vom Text.

## Consequences

- Drei ZHAW-Pflichtfelder fehlen im MVP: `description`, `building_block_version`, `responsible_working_group`. Das ist eine dokumentierte Abweichung.
- Seitenzahlen im erzeugten Word oder PDF werden nicht erfasst. Sie entstehen erst beim Umbruch.
