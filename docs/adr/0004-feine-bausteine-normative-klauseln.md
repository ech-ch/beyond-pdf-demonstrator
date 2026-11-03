---
status: accepted (vorläufig, MVP; Überprüfung nach 12.11.2026)
---

# Jede normative Klausel ist ein feiner Baustein

Jede normative Klausel ist ein feiner Baustein. Als normative Klausel gilt ein Absatz mit `[MUSS]`, `[SOLLTE]` oder `[DARF NICHT]` am Anfang, zusammen mit einer unmittelbar folgenden Aufzählung, auch wenn der Absatz nicht mit «:» endet (präzisiert in E14, Fall 7.8). Präzisiert am 3.11.2026 (E29):

- Absätze ohne Kennzeichnung, die sich auf die vorangehende Klausel beziehen, gehören zu deren Baustein (G1).
- Einleitungen vor der ersten Klausel gehören zum groben Baustein (G2).
- Eigenständige Absätze werden eigene feine Bausteine (G4).

Grund: Die normative Klausel ist die Einheit, auf die sich Umsetzung, Konformitätsprüfung und öK-Rückmeldungen beziehen. Eine mechanische Regel ist zudem für Besuchende ohne Begleitung verständlich (E03). Unter dem Leitsatz «so granular wie nötig» ist das gerechtfertigt. ZHAW lässt einzelne Sätze als Baustein ausdrücklich zu, wenn sie eine eigene normative Funktion haben.

## Considered Options

- **Nach Bedarf:** Nur Klauseln mit belegter eigener Rückmeldung werden fein, in Kap. 7 wären das 4 von 55. Das ist «so grob wie möglich» und kostet am wenigsten. Besuchende können dann aber nur einzelne, scheinbar willkürliche Klauseln direkt kommentieren. Bleibt als Regel für Absätze ohne Kennzeichnung.
- **Jede Klausel, die einen Verweis enthält:** Das ergäbe 13 von 55. Es zerschneidet die Kapitel, ohne dass sich eine klare Regel ergibt.

## Consequences

- Kap. 7 hat 54 feine Bausteine (55 Klauseln, eine davon mehrfach verwendet, E27) und 10 grobe, also 64 Feedback-Adressen. Die Website braucht dafür ein dezentes Design der Knöpfe (Session 3).
- `name` ist bei feinen Bausteinen optional. Fehlt er, erzeugt der Build ihn aus den ersten Wörtern der Klausel (passt E09 an).
- Die CI prüft, dass jeder feine Baustein höchstens eine Kennzeichnung enthält und jede Kennzeichnung in einem feinen Baustein steht (E29).
- Zeichengleiche Klauseln an mehreren Stellen sind **ein** Baustein mit mehreren Fundstellen (Mehrfachverwendung, E27, ADR 0001). Damit hat Kap. 7 54 feine Bausteine. Nur ähnliche, nicht zeichengleiche Klauseln (z.B. Minor/Major in der eCH-0150-Klausel) bleiben getrennt; bei ihnen unterscheidet der Geltungsbereich als Endung die IDs.
- **Asymmetrie:** Verfeinern ist jederzeit möglich und bricht nichts, denn bestehende IDs, Beziehungen und Issues bleiben gültig. Vergröbern hiesse, eine veröffentlichte ID zu entfernen, und das ist nicht erlaubt (ADR 0002).
