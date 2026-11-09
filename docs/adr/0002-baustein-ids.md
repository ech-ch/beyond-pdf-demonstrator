---
status: accepted (vorläufig, MVP; Überprüfung nach 12.11.2026)
---

# Baustein-IDs: sprechend, inhaltsbezogen, eingefroren

Baustein-IDs folgen dem ZHAW-Schema `<standard-id>-bb-<kurzname>`, also `ech-0003-bb-<kurzname>`. Die Standard-ID ist die eigene Kennung des Standards; zusammen mit ihr ist ein Kurzname auch über Standards hinweg eindeutig (E38). Für den Kurznamen gelten drei Regeln:

- Er beschreibt den **Inhalt** in 1–4 deutschen Wörtern. Feststehende Fachbegriffe bleiben im Original, z.B. «semver», «minor» und «major». Kapitelnummer, Version und Präfix des Elternbausteins kommen nicht vor.
- Er wird mit der ersten Veröffentlichung (Release oder Pages) **eingefroren** und danach nie geändert, auch wenn sich der Wortlaut ändert. Vorher, solange er nur in der Doku steht, darf er noch angepasst werden (präzisiert 3.11.2026, E27).
- Er ist eindeutig im Standard. Kollisionen werden mit einem Inhaltswort gelöst, nicht mit einem Zähler.

Grund: Nach ADR 0001 bestimmt allein die ID die Identität eines Bausteins. Position und Wortlaut ändern sich zwischen Versionen: Eine Klausel wandert in ein anderes Kapitel, ein Begriff wird durch einen anderen ersetzt, ein Unterkapitel wird zu einem eigenen Kapitel. Deshalb dürfen beide die ID nicht prägen.

Die ID steht bei jedem Baustein im Attribut `bb`. Querverweise in Quarto verlangen bei Überschriften einen Anker mit Präfix `sec-` (Spike S2). Grobe Bausteine tragen deshalb zusätzlich `#sec-<kurzname>` mit demselben Kurznamen. Die CI prüft Eindeutigkeit und Übereinstimmung.

**Stellenwert (E28):** Diese Regeln sind ein Vorschlag und eine Diskussionsgrundlage. Wie IDs künftig gebildet und verwaltet werden, regelt voraussichtlich ein eigener eCH-Standard oder ein Zusatz zu einem bestehenden. Darüber entscheiden die zuständigen Gremien des Vereins eCH (F41). Auch die vergebenen IDs und der Zuschnitt der Bausteine sind ein initialer Vorschlag, für den MVP freigegeben, nicht für die Zukunft fixiert (E53). Wie eine spätere Überarbeitung mit veröffentlichten, eingefrorenen IDs umgeht, ist offen (F59).

## Considered Options

- **Kurzname mit Präfix des Elternbausteins** (z.B. `ech-0003-bb-versionierung-schema-eigene-version`): In der Quelle übersichtlicher gruppiert, aber die ID codiert die Position. Bei Verschiebungen wäre sie falsch und dürfte wegen der Stabilität nicht korrigiert werden. Neu zu prüfen, falls eine Gruppierung in der ID ausdrücklich verlangt wird.
- **Undurchsichtige IDs** (z.B. `ech-0003-bb-k7f3`): Sie veralten nie, sind aber nicht sprechend und widersprechen dem ZHAW-Schema («nicht nur aus einer laufenden Nummer»). Neu zu prüfen, falls veraltete sprechende IDs in der Praxis mehr verwirren als helfen.
- **Kurzname nachführen, wenn sich der Wortlaut ändert:** Damit bricht jede bestehende Referenz, jeder Link und jede Issue-Zuordnung. Ausgeschlossen.

## Consequences

- Sprechende IDs können inhaltlich veralten. Ein Beispiel: `schema-eigene-version` bliebe auch dann so, wenn eine spätere Version den Begriff «Schema» durch einen anderen ersetzt. Das ist gewollt, denn die ID ist eine Kennung, kein Titel.
- Grobe Bausteine haben zwei Kennungen: die Baustein-ID (`bb`) und den technischen Anker (`sec-`). Nur die Baustein-ID gilt nach aussen, etwa in Beziehungen, Feedback und der Registry.
- Die Migration auf `ld.ech.ch`-Identifikatoren bleibt offen (F15).
