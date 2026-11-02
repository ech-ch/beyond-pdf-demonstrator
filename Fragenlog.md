# Demonstrator Beyond PDF – Fragenlog

Stand: 2. November 2026 · Lebendes Dokument. Neue Punkte unten anhängen, IDs nie neu vergeben.

Status: offen · in Klärung · entschieden (vorläufig) · entschieden

## Offene Fragen

| ID | Thema | Frage | Herkunft | Wann | Status |
|---|---|---|---|---|---|
| F01 | Vorlagenbausteine | Haftungsausschluss und Urheberrechte sind Pflicht, aber nicht standardspezifisch. Wo werden sie gepflegt und wie eingefügt? (Sicherheitsüberlegungen ist Pflichtkapitel, Inhalt aber standardspezifisch → normaler Baustein.) Siehe auch F19. | Leitsatz «Bausteine = standardspezifische Inhalte» | MVP | offen |
| F02 | Inhalt = Metadatum | Titel und Zusammenfassung stehen im Text und auf dem Deckblatt. Baustein oder Metadatenfeld? | Leitsatz «Erzeugtes ist kein Baustein» | MVP | offen |
| F03 | Bausteinform | Datei, markierter Abschnitt oder Hybrid? | Grilling-Session 1 | MVP | offen |
| F04 | Ort der Baustein-Metadaten | Frontmatter, Abschnittsattribute oder zentrale Registry? | Grilling-Session 1 | MVP | offen |
| F05 | Feedback-Zuordnung | Baustein-ID als Label oder Formularfeld? Verhalten bei Personen ohne Schreibrechte? | Grilling-Session 3 | MVP | offen |
| F06 | GitHub-Konto | Barriere für Feedback ohne Konto: welche Alternativen testen? | Frage 32 | nach MVP | offen |
| F07 | Issue vs. RfC | Wie wird aus einem Issue ein RfC? Kann die Rückmeldungsliste aus geschlossenen Issues erzeugt werden? | Fragen 33/34 | nach MVP | offen |
| F08 | Überarbeitungsmodus | Wie entstehen Tracked Changes aus generierten Dokumenten (Word-Vergleich, Git-Diff, Änderungsliste)? | Frage 20 | vor Abnahme | offen |
| F09 | Versionierung | Welche der fünf Varianten (eCH-0003, ZHAW, Politische Geschäfte, I14Y, cube.link)? | Frage 29 | nach MVP | offen |
| F10 | Abbildungen | Bilddatei, Diagrammcode oder Prozessmodell? (V11.1.0: Abb. 1–6 sind Varianten desselben Prozessdiagramms mit unterschiedlicher Schrittauswahl → potenziell erzeugbar.) | Frage 15 | nach MVP | offen |
| F11 | Verbindlichkeit | MUSS/SOLLTE/KANN als Attribut am Baustein oder eigenes Klauselobjekt? | Frage 16 | nach MVP | offen |
| F12 | Versionierte Vokabulare | Das Deckblattschema hängt von der eCH-0003-Version ab (V11.1.0 mit Reifegrad; V12.0.0 ohne Reifegrad, mit Fachgruppendokument). Wie bildet der Metastandard das ab? | FOAG-Template folgt V11.1.0 | Metastandard | offen |
| F13 | Anhang D | «Änderungen gegenüber Vorversion»: erzeugt oder verfasst? | Leitsatz «Erzeugtes ist kein Baustein» | nach MVP | offen |
| F14 | Mehrsprachigkeit | Wie werden Übersetzungen gepflegt (bekannte Lücke in LinkML)? | Frage 10 | nach MVP | offen |
| F15 | Identifikatoren | Provisorisches Schema jetzt, `ld.ech.ch` später: Migrationspfad? Wer entscheidet? | Frage 30 | Verein | offen |
| F16 | Gemeinsames Template | Abstimmung mit FOAG: wer pflegt die eCH-Quarto-Vorlage künftig? | Wiederverwendung Template | bald | offen |
| F17 | Repo-Struktur | Ein Repo oder mehrere (pro Standard / gemeinsame Bausteine)? | Frage 14 | nach MVP | offen |
| F18 | IDs ohne Nummern | Kapitelnummern wechseln zwischen Versionen (V11.1.0 → V12.0.0: Versionierung 7.3 → 7.5, Status 7.5 → 7.6, Minor Change 7.8 → 7.5.1, Voraussetzungen 7.10 → 7.8, Addendum 7.7 → 2.4). Baustein-IDs dürfen keine Nummern enthalten. Wie werden sprechende IDs für feine Bausteine gebildet? | Durchsicht V11.1.0 | MVP | offen |
| F19 | Versionierte Vorlagenbausteine | Haftungsausschluss und Urheberrechte in V11.1.0 («der Benutzer», «der Erarbeitende») unterscheiden sich von der aktuellen Vorlage («die Benutzenden», «die Erarbeitenden»). Welche Fassung fügt der Build ein? | Durchsicht V11.1.0 | MVP | offen |
| F20 | Erzeugt vs. Original | 1.1 Status in V11.1.0: «vom Vorstand genehmigt»; Statustext gemäss Kap. 7.5 und Word-Vorlage: «vom Expertenausschuss genehmigt». Ein aus dem Vokabular erzeugter Text ist nicht zeichengleich. Braucht erzeugter Inhalt einen Übersteuerungsmechanismus? | Durchsicht V11.1.0 | MVP | offen |
| F21 | Quelle der Vokabulare | Anhang C Teil 2 definiert die Deckblattfelder im Standard selbst (inkl. «Überprüft am», das auf keinem Deckblatt steht). Die Word-Vorlage setzt sie als Dropdowns um, inkl. Status «Genehmigtes Addendum», den Kap. 7.5 nicht kennt. Was ist die Quelle der Wahrheit? | Durchsicht V11.1.0 + Vorlage | Metastandard | offen |
| F22 | Verbindlichkeitsvokabular versioniert | V11.1.0 kennt nur MUSS, DARF NICHT, SOLLTE (kein KANN); V12.0.0 führt KANN ein. | Durchsicht V11.1.0 | nach MVP | offen |
| F23 | Vorlage «formal unverändert» | 1.3.2 [MUSS]: Vorlage formal unverändert verwenden. Pandoc-Referenzdokument übernimmt nur Formatvorlagen, Kopf-/Fusszeilen und Seitenformat, nicht Deckblatt-Steuerelemente und Inhalt. Für das Abnahmekriterium: Pandoc + Referenzdokument oder Befüllen der Originalvorlage? | Durchsicht Vorlage | vor Abnahme | offen |
| F24 | Deckblatt in Word | Das FOAG-Template erzeugt das Deckblatt nur für Website und PDF, nicht für Word. Wie wird es im Word erzeugt? | Prüfung FOAG-Template | MVP | offen |
| F25 | Vokabulare aus dem Standard | FOAG-Reifegrad (experimental/defined/established) entspricht nicht V11.1.0 (Definiert/Implementiert/Verbreitet/Auslaufend). Vokabulare aus dem Standard übernehmen, nicht aus dem Template. | Prüfung FOAG-Template | MVP | offen |
| F26 | Parametrisierte Bausteine | Kap. 2–5 wiederholen nahezu wörtlich dieselben Klauseln (z.B. 10-Arbeitstage-Frist, Wiedererwägungsgesuch), obwohl 1.3.3 [DARF NICHT] Wiederholungen verbietet. Ein Baustein mit Parametern (Antragsform, Frist 5/3 Jahre, Deklination «eines Standards / einer Best Practice»)? | Durchsicht V11.1.0 | nach MVP | offen |
| F27 | Anhangstruktur | V11.1.0 (A Referenzen, B Abkürzungen, C Glossar, D Änderungen, E Abbildungen, F Formale Syntax) weicht von der aktuellen Vorlage ab (B Mitarbeit & Überprüfung, C Abkürzungen und Glossar, F Tabellenverzeichnis). Original- oder Vorlagenstruktur? | Durchsicht V11.1.0 + Vorlage | MVP | offen |
| F28 | Verweise auf nicht überführte Kapitel | Kap. 7 verweist auf 1.3.4, 1.3.10 u.a., die im MVP nicht überführt werden. Vorschlag: Gerüst mit allen Überschriften und IDs, Inhalt nur in Pilotkapiteln. | Kapitelwahl MVP | MVP | offen |
| F29 | Quelle nur als PDF | V11.1.0 liegt nur als PDF vor (Silbentrennung, Kopf-/Fusszeilen, Aufzählungszeichen). Extraktion und Textvergleich müssen normalisieren. DOCX bei der Geschäftsstelle anfragen? | Beschaffung | MVP | offen |

## Entscheide

Format je Eintrag: ID · Datum · Entscheid · Begründung · vorläufig (MVP) ja/nein · Überprüfung wann.

- **E01 · 2.11.2026 · Vorschlag, Bestätigung offen** — Eigenes Repo `ech-ch/beyond-pdf-demonstrator` (öffentlich) statt `ech-ch/project-github`. Begründung: GitHub Pages von project-github ist durch die ZHAW-Demo belegt; Feedback-Issues und CI würden sich mit dem Projektrepo vermischen; Experimentcharakter. Später aus project-github verlinken. Vorläufig: ja.
- **E02 · 2.11.2026 · Vorschlag, in Grilling-Session 1 zu bestätigen** — MVP-Pilotkapitel aus eCH-0003 V11.1.0: Gerüst aller Überschriften; Inhalt für 1.1–1.2.1, Kap. 7, Kap. 8–10; Anhänge A, C, F (Stufe 2). Vorläufig: ja.