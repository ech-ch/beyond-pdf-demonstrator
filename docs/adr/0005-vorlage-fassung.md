---
status: accepted (vorläufig, MVP; Überprüfung nach 12.11.2026)
---

# Die Vorlage ist versioniert: Ein Standard wählt eine Vorlage-Fassung

Was ein Standard aus der eCH-Vorlage übernimmt, gehört zu einer **Vorlage-Fassung**. Jeder Standard nennt in seinen Metadaten, welche Fassung er verwendet (`vorlage: 2022`). Der Build setzt alles daraus ein, ohne Übersteuerung im einzelnen Standard. Zu einer Vorlage-Fassung gehören:

- die Vorlagentexte (Haftungsausschluss, Urheberrechte)
- die Statustexte für 1.1
- die Beschriftungen des Deckblatts
- der Block Herausgeber/Vertrieb

Auslöser war F20. In V11.1.0 lautet 1.1 «Das Dokument wurde vom **Vorstand** genehmigt», Kap. 7.5 und die heutige Vorlage sagen «vom **Expertenausschuss**». Der Statustext wird nicht aus 7.5 abgeleitet. Er ist ein fester Satz aus einem Dropdown der Vorlage, das laut Anhang D mit V11.1.0 eingeführt wurde, und weicht auch sonst von 7.5 ab. «Vorstand» ist also kein Fehler, sondern der Wortlaut der Vorlage von 2022. Wer V11.1.0 mit der Fassung 2022 erzeugt, erhält den Text zeichengleich.

## Considered Options

- **Übersteuerung je Standard** (z.B. `statustext: "…vom Vorstand…"`): schnell umgesetzt, aber Doppelpflege. Ausserdem verdeckt sie die eigentliche Ursache, nämlich dass die Vorlage versioniert ist.
- **1.1 Status als Baustein:** widerspricht dem Leitsatz «Was erzeugt werden kann, ist kein Baustein».

## Consequences

- Von der Fassung 2022 kennen wir nur, was im Original sichtbar ist, also den Statustext für «Genehmigt». Ein anderer Status zusammen mit der Fassung 2022 bricht den Build ab, statt einen Text zu erfinden.
- Die Fassung 2025 wird aus der heutigen Word-Vorlage übernommen (Beilagen vom 28.11.2025, Stufe 2).
- Das Layout (Word-Referenzdokument) stammt immer aus der aktuellen Vorlage vom 28.11.2025, weil keine Word-Datei der Vorlage von 2022 vorliegt. Die Fassung 2022 liefert nur Texte und Beschriftungen (E20).
- Die Vokabulare für das Deckblatt kommen aus der Vorlage-Fassung, nicht aus `ech_vocabulary.yml` des FOAG-Templates.
- Wer später «Vorstand» zu «Expertenausschuss» korrigieren will, ändert nicht den Standard, sondern stellt ihn auf eine neuere Vorlage-Fassung um.
