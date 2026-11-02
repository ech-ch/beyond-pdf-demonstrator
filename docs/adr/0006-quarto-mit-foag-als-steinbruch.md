---
status: accepted (vorläufig, MVP; Überprüfung nach 12.11.2026)
---

# Quarto als Basis, FOAG-Template als Steinbruch statt Fork

Der Demonstrator ist ein neues, minimales Quarto-Projekt nach eigener Struktur. Vom FOAG-Template (`blw-ofag-ufag/semantic-web-template`, CC BY 4.0) übernehmen wir gezielt Dateien mit Namensnennung:

- Deckblatt-Partial für die Website
- SCSS und Logos
- Typst-Vorlagen
- Lua-Filter für Metadaten und Shortcodes, umgestellt auf die Vorlage-Fassung
- Pages-Deploy

Wir forken das Template nicht.

Gründe:

- Quarto liefert die Website (eines der drei Ziele) mit Navigation, Ankern und Querverweisen fertig. Spike S1 zeigt, dass HTML, DOCX und PDF ohne die RDF-Pipeline rendern.
- Ein Fork brächte RDF/SHACL/SPARQL, R, Java, Python-Pipeline, Makefile und Tests mit. Sie auszuräumen kostet mehr als das Zusammenstellen von etwa zwölf Dateien.

Die Quarto-Version ist in der CI auf 1.10.19 festgelegt. Die Word-Vorlage liegt als lokale Kopie im Repo, nicht als URL.

## Considered Options

- **FOAG forken und ausräumen:** kleinerer Abstand zum Upstream, was für ein gemeinsames Template wichtig wäre (F16). Dafür bleiben Ballast und Warnungen des Sync-Tests.
- **Reines Pandoc nach dem Muster der Politischen Geschäfte:** bewährtes Word, aber keine Website. Diese müssten wir selbst bauen, was den Durchstich gefährdet.

## Consequences

- **Rückfallebene am Entscheidungstor Do 5.11.:** Scheitert das Word mit Quarto, wird nur das Word mit reinem Pandoc erzeugt. Es entsteht aus demselben zusammengesetzten Markdown mit denselben Lua-Filtern. Website und Quellmodell bleiben unverändert.
- Das README hält die Abweichungen vom FOAG-Template fest, damit eine spätere Rückführung in ein gemeinsames eCH-Template möglich bleibt (F16).
