<!--
Kapitel 2 Standard (AP26, E54): Text aus original/text/kap02.txt, überführt, noch nicht in
Bausteine zerlegt. Keine Baustein-IDs, die Kennzeichnungen stehen im Text. Feedback
gibt es für das ganze Kapitel (feedback-id an der Überschrift). Querverweise wie die
Felder REF im Word-Original; sie zählen in der Registry noch nicht als Beziehungen,
weil die Quelle kein Baustein ist. Erzeugt per Skript aus dem Rohtext (E19).
Abweichend vom Word-Original korrigiert (E54, Nachtrag): Link «Vorlage» in der
Erarbeitung auf die heutige Adresse der Vorlagen-Seite, «Webseite» auf https://www.ech.ch statt mailto:Webseite (F54).
-->

# Standard {#sec-standard .nur-text-kapitel feedback-id="ech-0003-kapitel-standard" original-seite="14"}

## Einleitung {.nur-text original-seite="14"}

Ein «Standard» legt für allgemeine und wiederkehrende Anwendungen Regeln, Leitlinien oder Merkmale für Tätigkeiten oder deren Ergebnisse fest. Darunter fallen unter anderem technische Interoperabilitätsstandards, Verfahrensstandards sowie das Referenzieren beziehungsweise Präzisieren von Fremdstandards.

[SOLLTE] Als eCH-Standards vorgesehen sind: [-@sec-standard-interoperabilitaetsstandard]{.nur-titel}, [-@sec-standard-verfahrensstandard]{.nur-titel} und [-@sec-standard-referenzierter-fremdstandard]{.nur-titel}.

### Interoperabilitätsstandard {#sec-standard-interoperabilitaetsstandard .nur-text original-seite="14"}

Technische Spezifikation, die eingehalten werden muss, damit zwei oder mehrere Systeme oder Partner ohne Probleme zusammenarbeiten und bei Bedarf modular ausgetauscht werden können.

Eine spezielle Ausprägung von Interoperabilitätsstandards sind Schnittstellen- und Datenstandards, die Anforderungen zur Sicherstellung der Kompatibilität von Produkten oder Systemen an Verbindungsstellen festlegen ([@ISO]). Die Schnittstellenstandards befassen sich hauptsächlich mit der Übertragung und Adressierung im Datenaustausch. Hierunter fallen z.B. Übertragungsprotokolle. Die Datenstandards befassen sich hauptsächlich mit den auszutauschenden Daten. Hierunter falls z.B. konzeptionelle Datenmodelle sowie Format- und Datendefinitionen.

[SOLLTE] Die Trennung von Schnittstellen- und Datenstandards ist von grosser Bedeutung für das Baukastenprinzip der eCH-Standards; entsprechend sind diese wenn möglich separat zu spezifizieren.

Die Definition von Fachterminologien, die der semantischen Interoperabilität dienen, gehört ebenfalls zu den Interoperabilitätsstandards.

Im dreistufigen schweizerischen Föderalismus mit einer entsprechend heterogenen Landschaft der Informationssysteme und deren Spezifikationen stellt dieser Standardtyp die Grundlage der Ebenen übergreifenden Kooperation dar.

### Verfahrensstandard {#sec-standard-verfahrensstandard .nur-text original-seite="14"}

Standard, der die Anforderungen festlegt, die durch ein Verfahren erfüllt werden müssen, um dessen Gebrauchstauglichkeit sicherzustellen [@ISO]: z.B. Prozessvorgaben, Leitfäden, Vorgehensmodelle, oder Methoden.

### Referenzierter Fremdstandard {#sec-standard-referenzierter-fremdstandard .nur-text original-seite="14"}

In der Regel will eCH die Nutzung bereits bestehender Standards fördern.

[MUSS] Soll ein Fremdstandard, d.h. ein von einem anderen Standardisierungsgremium definierter Standard, als eCH-Standard gekennzeichnet werden, wird ein eigener eCH-Standard erstellt.

[MUSS] Darin wird der Fremdstandard referenziert und sein Einsatz im E-Government der Schweiz begründet sowie bei Bedarf präzisiert. Es ist möglich, in einem einzigen eCH-Standard auf eine Sammlung von Fremdstandards zu verweisen.

[SOLLTE] Bevorzugt werden offene Fremdstandards über einen eCH-Standard referenziert.

[DARF NICHT] Kostenpflichtige Fremdstandards können durch eCH nicht kostenlos zur Verfügung gestellt werden.

### Datenschemata {#sec-standard-datenschemata .nur-text original-seite="15"}

[MUSS] Zusammen mit dem Standarddokument veröffentlichte Datenschemata (z.B. in XML, XML-Varianten oder JSON) sind integraler Bestandteil des jeweiligen Standards. Das bedeutet, dass Anpassungen nach denselben formalen Vorgaben erfolgen wie Änderungen des Standarddokuments selbst (zur Versionierung vgl. Kapitel -@sec-versionierung).

[SOLLTE] Die zu einem eCH-Standard gehörenden Datenschemata müssen grundsätzlich auf den Namensraum «ech.ch» verweisen. Wenn ein Schema Bestandteil eines referenzierten Fremdstandards ist, kann dieses mit dem dort verwenden Namensraum eingesetzt werden.

[SOLLTE] Die Kompatibilität der Datenschemata bzw. die Konvertierung zwischen verschiedenen Datenformaten (z.B. von XML zu JSON oder umgekehrt) sollte gewährleistet sein. Für diesbezügliche Tests sind die Antragstellenden (vgl. Kapitel -@sec-standard-antragstellende) verantwortlich.

## Antragstellende {#sec-standard-antragstellende .nur-text original-seite="15"}

Als Antragstellende kommen Fachgruppen oder externe Personen und Organisationen in Frage.

## Prozess {.nur-text original-seite="15"}

<!-- Abbildung 3 aus dem Original-PDF (tools/schneide_abbildungen.py, F10 vorläufig E52). -->

![Genehmigungsprozess Antrag auf Standard](abbildungen/genehmigungsprozess-standard.png){#fig-genehmigungsprozess-standard fig-alt="Ablaufdiagramm mit zwölf Kästchen in zwei Reihen. Obere Reihe von links nach rechts: Erarbeitung, Formale QS 1, Inhaltliche QS 1, Übersetzung, Öffentliche Konsultation, Einarbeitung Rückmeldungen. Untere Reihe von rechts nach links: Formale QS 2, Inhaltliche QS 2, Genehmigung / Ablehnung, Übersetzung, Publikation, Überprüfung. Durchgezogene Pfeile führen in dieser Reihenfolge von Formale QS 1 bis Überprüfung. Gepunktete Pfeile führen von Erarbeitung zu Formale QS 1, von Formale QS 1 und von Inhaltliche QS 1 zurück zu Erarbeitung, von Inhaltliche QS 1 zu Genehmigung / Ablehnung, von Formale QS 2 und von Inhaltliche QS 2 zurück zu Einarbeitung Rückmeldungen sowie von Überprüfung zu Erarbeitung und zu Publikation."}

Je nach Behandlung des Antrags als Minor- oder Major-Change können Prozessschritte wie die öffentliche Konsultation und in der Folge die Qualitätssicherung 2 entfallen (Ausführungen vgl. Kapitel -@sec-minor-change und -@sec-major-change).

### Erarbeitung {.nur-text original-seite="15"}

[MUSS] Vor Beginn der Arbeiten an einem neuen Standard wird eine eCH-Nummer bei der Geschäftsstelle ([info@ech.ch](mailto:info@ech.ch)) beantragt.

[MUSS] Ein Antrag auf einen eCH-Standard wird mittels der dafür vorgesehenen [Vorlage](https://www.ech.ch/de/ech-standards/standardisierungsprozess/vorlagen) (verfügbar auf der [Webseite](https://www.ech.ch)) bei der Geschäftsstelle eingereicht ([info@ech.ch](mailto:info@ech.ch)).

### Formale Qualitätssicherung 1 {.nur-text original-seite="16"}

Die Geschäftsstelle prüft eingegangene Standardanträge gemäss Kapitel -@sec-formale-qualitaetssicherung-1.

[SOLLTE] Eventuelle Unzulänglichkeiten werden den Antragstellenden direkt gemeldet und es wird eine Korrektur verlangt.

### Inhaltliche Qualitätssicherung 1 {.nur-text original-seite="16"}

Ist der Antrag formgerecht eingereicht, wird er den Referentinnen und Referenten zur Freigabe für die öffentliche Konsultation zugestellt. Die Referentinnen und Referenten prüfen den Standard in Bezug auf die Publikationsfähigkeit gemäss Kapitel -@sec-inhaltliche-qualitaetssicherung-1.

[MUSS] Die Prüfung erfolgt innerhalb von zehn Arbeitstagen nach Zustellung der Unterlagen (in Ferienzeiten wird diese Frist auf maximal 20 Arbeitstage verlängert) und die Freigabe wird umgehend der Geschäftsstelle gemeldet.

[MUSS] Wird ein Standard zur Bearbeitung zurückgewiesen, nehmen die Antragstellenden die geforderten Korrekturen vor und reichen ihn vollständig wieder bei der Geschäftsstelle ein. Der Prozess beginnt wieder bei der «Formalen Qualitätssicherung 1».

### Öffentliche Konsultation und Einarbeitung Rückmeldungen {.nur-text original-seite="16"}

Die öffentliche Konsultation findet gemäss Kapitel -@sec-oeffentliche-konsultation und die Einarbeitung der Rückmeldungen gemäss Kapitel -@sec-einarbeitung-rueckmeldungen statt.

### Formale Qualitätssicherung 2 {.nur-text original-seite="16"}

Das Standarddokument wird durch die Geschäftsstelle gemäss Kapitel -@sec-formale-qualitaetssicherung-2 geprüft.

### Inhaltliche Qualitätssicherung 2 {.nur-text original-seite="16"}

Der auf formale Aspekte geprüfte Standard wird den Referentinnen und Referenten zur Begutachtung gemäss Kapitel -@sec-inhaltliche-qualitaetssicherung-2 zugestellt.

[MUSS] Aufgrund dieser Angaben erarbeiten die Referentinnen und Referenten eine Empfehlung zuhanden des Expertenausschusses.

[SOLLTE] Diese Empfehlung wird normalerweise bis spätestens zehn Arbeitstage vor der nächsten Sitzung bei der Geschäftsstelle gemeldet, um eine entsprechende Traktandierung zu ermöglichen.

### Genehmigung oder Ablehnung {.nur-text original-seite="16"}

[SOLLTE] Der Expertenausschuss beschliesst mittels Online-Abstimmung oder an einer ordentlichen Sitzung die Genehmigung oder Ablehnung eines Standards.

Wird ein Standard durch den Expertenausschuss für qualitativ gut, aber mit Korrekturbedarf befunden, kann dieser vorbehaltlich der Behebung der festgestellten Mängel genehmigt werden.

[MUSS] Die Genehmigung tritt dann in Kraft, sobald das überarbeitete Dokument von den zuständigen Referentinnen und Referenten als den Anforderungen entsprechend taxiert wird.

Wird ein Standard abgelehnt, können die Antragstellenden auf die nächste Sitzung ein schriftliches Wiedererwägungsgesuch stellen und dieses auf Wunsch an der entsprechenden Sitzung als Gast mündlich vorbringen.

[SOLLTE] Wurde ein Standard grundlegend überarbeitet, sind die zuständigen Referentinnen und Referenten ermächtigt, eine erneute öffentliche Konsultation zu verlangen.

### Publikation {.nur-text original-seite="17"}

[MUSS] Nach erfolgter Genehmigung werden allfällige Korrekturen übersetzt und das Standarddokument in der Originalsprache und in übersetzter Sprache auf der [Webseite](http://www.ech.ch) veröffentlicht.

[SOLLTE] Ausnahmsweise können Standards, welche ausschliesslich in englischer Sprache vorliegen, einsprachig publiziert werden.

### Überprüfung {.nur-text original-seite="17"}

[MUSS] Standards mit dem Status «Genehmigt» werden fünf Jahre nach deren Genehmigung oder letzten Überprüfung gemäss Ausführungen unter Kapitel -@sec-ueberpruefung überprüft.
