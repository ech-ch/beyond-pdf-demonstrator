# Beyond PDF – Demonstrator

Der Demonstrator zerlegt einen textbasierten eCH-Standard (Pilot: eCH-0003 V11.1.0) in Bausteine. Aus den Bausteinen erzeugt er wieder ein Word-Dokument und eine Website mit Feedback je Baustein. Dieses Glossar hält die Sprache des Demonstrators fest. Alle Begriffe gelten vorläufig (MVP) und werden nach dem 12.11.2026 überprüft.

## Sprache

### Bausteine

**Baustein**:
Fachlich abgrenzbarer, standardspezifischer Inhalt eines Standards mit stabiler ID.
_Vermeiden_: Building Block (im deutschen Text), Modul, Abschnitt

**Grober Baustein**:
Ein Baustein, der ein ganzes Kapitel oder Unterkapitel umfasst.

**Feiner Baustein**:
Ein Baustein im Text eines groben Bausteins. Jede normative Klausel ist ein feiner Baustein, samt den Absätzen, die sie erläutern. Ein eigenständiger Absatz ohne Kennzeichnung wird ebenfalls ein feiner Baustein. Er ist ein vollwertiger Baustein mit eigener ID.

**Mehrfachverwendung**:
Ein Baustein, der an mehreren Stellen eines Standards vorkommt, weil der Text dort zeichengleich ist. Er hat eine ID und mehrere Fundstellen.
_Vermeiden_: Kopie, Duplikat (für einen mehrfach verwendeten Baustein)

**Verfeinern**:
Einen Textteil eines groben Bausteins nachträglich als feinen Baustein auszeichnen. Bestehende IDs, Beziehungen und Rückmeldungen bleiben dabei gültig. Das Gegenteil, eine veröffentlichte ID wieder zu entfernen, ist nicht erlaubt.
_Vermeiden_: Zerlegen (wenn Verfeinern gemeint ist)

**Standard-ID**:
Die Kennung eines Standards ohne Version, z.B. `ech-0003`. Sie steht vorne in der Baustein-ID, im Pfad der Website und in den Labels.

**Baustein-ID**:
Die stabile Kennung eines Bausteins. Sie allein bestimmt seine Identität. Datei, Position und Kapitelnummer gehören nicht dazu.
_Vermeiden_: Kapitelnummer, Anker (als Kennung eines Bausteins)

**Kurzname**:
Der sprechende Teil der Baustein-ID (`ech-0003-bb-<kurzname>`). Er beschreibt den Inhalt beim ersten Vergeben und wird danach nie mehr geändert.
_Vermeiden_: Titel, Name (der Kurzname ist kein Titel)

**Anker**:
Technische Sprungmarke für Querverweise im Dokument (`sec-…`). Er ist keine Kennung eines Bausteins und gilt nicht nach aussen.

**Beziehung**:
Gerichtete Verbindung von einem Baustein zu einem anderen Baustein oder zu einem Standard. Jeder Baustein, grob oder fein, kann Quelle und Ziel sein.

**Querverweis**:
Stelle im Text, die auf eine Überschrift, einen Baustein, einen Literatureintrag oder einen anderen Standard zeigt. Aus jedem Querverweis entsteht eine Beziehung.
_Vermeiden_: Link (für den fachlichen Verweis)

**Verbindlichkeit**:
Die Stufe einer normativen Klausel, abgeleitet aus ihrer Kennzeichnung ([MUSS], [SOLLTE], [DARF NICHT]). Absätze ohne Kennzeichnung haben keine Verbindlichkeit.

**Rückbezug**:
Stelle, an der ein feiner Baustein nur mit dem Text davor verständlich ist («hierbei», «Dies», «Diese Änderung»). Ein Rückbezug auf einen anderen feinen Baustein wird als Beziehung `depends_on` festgehalten.

**Einbettung**:
Die Beziehung eines feinen Bausteins zum groben Baustein, in dessen Text er steht (`is_part_of`). Sie ergibt sich aus der Position im Text und wird erzeugt.
_Vermeiden_: Zugehörigkeit

**Ablageort**:
Die Datei, in der ein Baustein gepflegt wird. Er ist austauschbar und gehört nicht zur Identität des Bausteins.

**Vorlagentext**:
Pflichtinhalt eines Standards, der nicht standardspezifisch ist, etwa Haftungsausschluss oder Urheberrechte. Er wird zentral in Fassungen gepflegt und beim Erzeugen eingefügt. Er ist kein Baustein: Er hat keine Baustein-ID und keinen Feedback-Knopf.
_Vermeiden_: Vorlagenbaustein, Boilerplate, Standardtext

**Vorlage-Fassung**:
Ein bestimmter Stand der eCH-Vorlage. Dazu gehören die Vorlagentexte, die Statustexte für 1.1, die Beschriftungen des Deckblatts und der Block Herausgeber/Vertrieb. Beispiele sind «2022» (wie in eCH-0003 V11.1.0 publiziert) und «2025» (heutige Vorlage). Welche Vorlage-Fassung ein Standard verwendet, steht in seinen Metadaten.
_Vermeiden_: Template-Version, Vorlagenversion

**Statustext**:
Der Satz in 1.1 «Status», der den Bearbeitungsstatus erklärt. Er ist erzeugter Inhalt aus dem Status des Standards und der Vorlage-Fassung, nicht aus Kap. 7.5.

**Normative Klausel**:
Absatz, der mit [MUSS], [SOLLTE] oder [DARF NICHT] beginnt, samt einer unmittelbar folgenden Aufzählung. eCH-0003 V11.1.0 kennt kein [KANN] und nennt MUSS/DARF NICHT «Richtlinie» und SOLLTE «Empfehlung».
_Vermeiden_: Regel, Anforderung

### Dokumentstruktur

**Gerüst**:
Die vollständige Überschriftenstruktur eines Standards. Der Inhalt darf fehlen. Feste IDs tragen nur Überschriften von Bausteinen und Verweisziele; alle anderen haben einen provisorischen Anker.

**Platzhalter**:
Kurzer Hinweis unter einer Überschrift des Gerüsts, deren Inhalt nicht überführt ist. Er verweist auf die entsprechende Seite im Original.

**Provisorischer Anker**:
Automatisch erzeugte Sprungmarke einer nicht überführten Überschrift. Er ist weder stabil noch eine Baustein-ID.
_Vermeiden_: ID (für provisorische Anker)

**Erzeugter Inhalt**:
Alles, was sich aus Bausteinen oder Metadaten ableiten lässt, etwa Deckblatt, Statustext, Nummerierung, Verzeichnisse und Rückverweise. Erzeugter Inhalt ist kein Baustein.

**Ebene 0 / 1 / 2**:
Ebene 0 sind die Metadaten über den Standard, darunter Deckblattfelder, Titel und Zusammenfassung. Ebene 1 sind Struktur und Metadaten der Bausteine. Ebene 2 ist der Inhalt der Bausteine.

### Rückmeldungen

**öK-Rückmeldung**:
Offizielle Stellungnahme zu einem Standard in der öffentlichen Konsultation von eCH. Sie wird heute über Kapitel und Seite verortet.
_Vermeiden_: Feedback (für öK-Rückmeldungen)

**Feedback**:
Rückmeldung über den Feedback-Knopf des Demonstrators, als GitHub-Issue zu genau einem Baustein oder zum Standard als Ganzes. Feedback ist keine öK-Rückmeldung.
_Vermeiden_: Rückmeldung (für Feedback im Demonstrator), Kommentar

### Vorgehen

**Pilotstandard**:
eCH-0003 V11.1.0 «Leitfaden zur Genehmigung von Anträgen», publiziert 2022.

**Original**:
Die publizierte Fassung, aus der ein Standard überführt wird. Im MVP ist das die PDF-Fassung von eCH-0003 V11.1.0. An ihr wird die inhaltliche Treue gemessen.

**Überführung**:
Die einmalige Umwandlung eines Originals in Bausteine. Ein Standard, der direkt im neuen Ansatz entsteht, durchläuft keine Überführung.
_Vermeiden_: Migration, Konvertierung

**Herkunft**:
Angabe, aus welchem Original und von welcher Seite ein überführter Baustein stammt. Sie ist historisch und bleibt auch dann stehen, wenn sich der Baustein später ändert.

**Fundstelle**:
Kapitel und Titel eines Bausteins im erzeugten Dokument einer bestimmten Version. Sie ist erzeugter Inhalt. Ein mehrfach verwendeter Baustein hat mehrere Fundstellen.
_Vermeiden_: Quelle (für die Fundstelle)

**Steckbrief**:
Raster mit Plandaten, Einordnung, Zusammenfassung und inhaltlicher Strukturierung eines Standards, entlang des Prozesses nachgeführt. Er gehört zur Ebene 0 und ist bisher ein Word-Dokument (offen: F47).
_Vermeiden_: Faktenblatt

**Registry**:
Die vom Build erzeugte, maschinenlesbare Liste aller Bausteine mit ihren Metadaten (`bausteine.json`).

**Pilotkapitel**:
Ein Kapitel, dessen Inhalt im MVP in Bausteine überführt wird.

**Rundgang**:
Drei Schritte auf der Startseite der Website, mit denen Besuchende den Demonstrator ohne Begleitung erkunden: einen Baustein ansehen, Feedback geben, Word herunterladen.

**Synopse**:
Sicht für einen Anwendungsfall, die zusammengehörige Bausteine aus mehreren Standards nebeneinander zeigt, etwa «was gilt formell, was in der Praxis» (offen: F50).

**Durchstich**:
Ein Kapitel durchgehend umgesetzt: von der Quelle zum Word-Dokument und von der Quelle zur Website mit Feedback-Knopf.
