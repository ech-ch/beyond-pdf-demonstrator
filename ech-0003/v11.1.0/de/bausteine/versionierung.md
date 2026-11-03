## Versionierung {#sec-versionierung bb="ech-0003-bb-versionierung" typ="rule" original-seite="27"}

::: {bb="ech-0003-bb-prinzip-zielversion" typ="requirement" original-seite="27"}
[MUSS] Bei der Versionierung sämtlicher Antragsformen gilt das Prinzip der Zielversion. Das heisst ein Dokument behält über sämtliche Prozessschritte die gleiche Versionsnummer. Diese wird durch den Bearbeitungsstatus (siehe Kapitel -@sec-bearbeitungsstatus) sowie das Ausgabedatum weiter spezifiziert.
:::

::: {bb="ech-0003-bb-struktur-versionsschema-semver" typ="requirement" original-seite="27"}
[MUSS] Die Struktur erfolgt gemäss «Semantic Versioning»[@SemVer]. eCH setzt nur die Hauptelemente dieses Versionierungsschemas ein und nutzt die optionalen nicht. Es handelt sich um:

- Hauptversionsnummer (engl. «major version»)
- Nebenversionsnummer (engl. «minor version») auf inhaltlicher Ebene
- Nebenversionsnummer (engl. «patch version») auf formaler Ebene.

Die einzelnen Nummern erscheinen nacheinander und sind durch einen Punkt getrennt, z.B. «3.7.1»

Die Nummer sind nicht als Zahlen im mathematischen Sinn zu interpretieren, sondern als Codierungen. Die formale Syntax für das von eCH verwendete Schema ist Anhang -@sec-formale-syntax unten zu entnehmen.

Hauptversionen (Major) werden durch eine ganze Versionsnummer ausgedrückt, Nebenversionen (Minor) durch «Zehntel» und Patches durch «Hundertstel». Die erste Version eines eCH-Dokuments oder eines eCH-Datenschemas ist demnach die Version 1.0.0.

Es ist nicht gestattet, Versionsnummer zu überspringen. Unabhängig davon, ob es sich um eine Hauptversion, eine inhaltliche Nebenversion oder eine formale Nebenversion handelt, wird der numerische Wert der vorangehenden Version um den Wert 1 erhöht. Es ergibt sich in jedem Fall eine lückenlose Nummerierung.

Ein Vergleich zwischen Versionen findet von rechts nach links statt, ausgehend von der formalen Nebenversion über die inhaltliche Nebenversion bis zur Hauptversion. Bei jedem Schritt wird der numerische Wert der ersten Version mit dem numerischen Wert der zweiten Version an der jeweiligen Stelle verglichen. Ist ein Wert höher, wenn die anderen gleich oder tiefer sind, gilt diese Version insgesamt als «höher» in Bezug zur anderen.
:::

::: {bb="ech-0003-bb-versionsstufe-dokument" typ="requirement" original-seite="28"}
[MUSS] Bei eCH-Dokumenten führt eine punktuelle Überarbeitung gemäss Kapitel -@sec-minor-change in der Regel zu einer neuen inhaltlichen Nebenversion (als erste Version 1.1.0) und eine umfassende Überarbeitung gemäss Kapitel -@sec-major-change zu einer neuen Hauptversion (Version 2.0.0). Typografische Anpassungen oder sprachlich-formale Änderungen führen zu einer neuen formalen Nebenversion (als erste Version 1.0.1).
:::

::: {bb="ech-0003-bb-schema-eigene-version" typ="requirement" original-seite="28"}
[MUSS] Besteht nebst einem eCH-Dokument auch ein Schema, so erhalten das Dokument und das Schema je eine eigene, unabhängige Versionsnummer.
:::

::: {bb="ech-0003-bb-versionsstufe-datenschema" typ="requirement" original-seite="28"}
[MUSS] Bei Datenschemata führen gegenüber der Vorversion inkompatible Änderungen oder neue, zwingende Attribute zu einer neuen Hauptversion, kompatible Änderungen oder neue, optionale Attribute zu einer inhaltlichen Nebenversion und formale Änderungen ohne Auswirkung auf Implementierung oder Anwendung zu einer formalen Nebenversion.
:::

::: {bb="ech-0003-bb-korrespondierende-schemaversion" typ="requirement" original-seite="28"}
[MUSS] Im eCH-Dokument ist festzuhalten, welche Version(en) des Schemas mit der Version des Dokuments korrespondieren.
:::

::: {bb="ech-0003-bb-externe-quelle-versionierung" typ="requirement" original-seite="28"}
[MUSS] Referenziert ein eCH-Dokument eine externe Quelle (gedruckt oder online), sind Änderungen der externen Quelle im eCH-Dokument festzuhalten oder diesbezüglich auf ein öffentlich verfügbares Protokoll in Textform zu verweisen. Die Versionierung des eCH-Dokuments erfolgt gemäss Kapitel -@sec-versionierung. Trägt die externe Quelle eine eigene Versionsnummer (z.B. Home (admin.ch)), ist die Versionierung des eCH-Dokuments mit der externen Quelle zu synchronisieren. Ändert sich die Hauptversion der externen Quelle, ändert sich zwingend auch die Hauptversion des eCH-Dokuments, unabhängig von weiteren Änderungen im eCH-Dokument. In der Folge ist gemäss Unterkapitel -@sec-oeffentliche-konsultation eine öffentliche Konsultation durchzuführen.
:::
