## Minor Change {#sec-minor-change bb="ech-0003-bb-minor-change" typ="process" original-seite="30"}

::: {bb="ech-0003-bb-kriterium-minor-change" typ="requirement" original-seite="30"}
[SOLLTE] Ein Änderungsantrag für einen Standard, eine Best Practice oder eine White Paper kann als Minor Change behandelt werden, wenn aus einer öffentlichen Konsultation keine substantielle Rückmeldung zu erwarten ist.
:::

::: {bb="ech-0003-bb-regelfaelle-minor-change" typ="requirement" original-seite="30" bezug="ech-0003-bb-kriterium-minor-change"}
[SOLLTE] Dies ist in der Regel der Fall, wenn lediglich

- erkannte Fehler inhaltlicher Natur behoben werden;
- Sachverhalte präzisiert werden beziehungsweise ein Addendum eingepflegt wird;
- eine neue Version nötig wurde, weil der Standard oder die Best Practice angepasst werden musste, um neue Versionen referenzierter Standards oder Best Practices zu berücksichtigen;
- gesetzliche Vorgaben nachvollzogen werden müssen;
- das Dokument ohne Nachfolgeversion aufgehoben wird.
:::

::: {bb="ech-0003-bb-konsultation-nicht-umgehen" typ="requirement" original-seite="31"}
[DARF NICHT] Mit einem Minor Change darf eine öffentliche Konsultation nicht umgangen werden.
:::

::: {bb="ech-0003-bb-inhaltliche-nebenversion-erhoehen" typ="requirement" original-seite="31"}
[MUSS] Da der Minor Change inhaltlicher Natur ist, wird die inhaltliche Nebenversion numerisch um den Wert 1 erhöht. Der Wert der formalen Nebenversion wird auf 0 gesetzt (vgl. Kapitel -@sec-versionierung). Änderungen der formalen Nebenversion betreffen nicht ein «Minor Change», sondern eine formale Änderung (vgl. Kapitel -@sec-formale-aenderungen).
:::

::: {bb="ech-0003-bb-minor-anspruch-pruefen" typ="requirement" original-seite="31" bezug="ech-0003-bb-inhaltliche-nebenversion-erhoehen"}
[MUSS] Ein so überarbeitetes Dokument prüfen die Referentinnen und Referenten auf Gültigkeit bezüglich Anspruchs auf Minor Change.

Wird der Anspruch auf Minor Change seitens der Referentinnen und Referenten gutgeheissen und der Antrag vom Expertenausschuss genehmigt, veröffentlicht die Geschäftsstelle das geänderte Dokument mit einer Einsprachefrist von vier Wochen ab Publikation. Gegebenenfalls (etwa in der Ferienzeit) kann diese Frist von der Geschäftsstelle auf maximal sechs Wochen verlängert werden.
:::

::: {bb="ech-0003-bb-einsprachefrist-ankuendigen" typ="requirement" original-seite="31" bezug="ech-0003-bb-minor-anspruch-pruefen"}
[MUSS] Diese Änderung und die entsprechende Einsprachefrist (Beginn und Ende) wird auf der Webseite (Frontseite, News) publiziert.

Wird innerhalb der Frist keine Einsprache erhoben, gilt der Minor Change als genehmigt.
:::

::: {bb="ech-0003-bb-behandlung-einsprachen" typ="requirement" original-seite="31"}
[SOLLTE] Geht innerhalb der Einsprachefrist ein begründeter, die Sache betreffender Einwand ein, wird nach Rücksprache mit den Referentinnen und Referenten eine ordentliche öffentliche Konsultation (siehe -@sec-oeffentliche-konsultation) gestartet. Ist der Einwand unbegründet, nicht die Sache betreffend oder offensichtlich willkürlich oder bewusst verzögernd für dringend notwendige und begründete Änderungen, kann der Expertenausschuss diesen als nichtig zurückweisen. Wird eine Einsprache abgewiesen, wird die Person, welche die Einsprache erhoben hat, von der Geschäftsstelle informiert und die Ablehnung seitens des Expertenausschusses schriftlich begründet.
:::

::: {bb="ech-0003-bb-einsprachen-antworten-publizieren" typ="requirement" original-seite="31" bezug="ech-0003-bb-einsprachefrist-ankuendigen"}
[MUSS] Die Geschäftsstelle publiziert nach Abschluss der Frist alle eingegangenen Einsprachen inklusive der Antworten der Referentinnen und Referenten beziehungsweise des Expertenausschusses auf der Webseite.
:::

::: {bb="ech-0003-bb-minor-anspruch-abgelehnt" typ="requirement" original-seite="31"}
[MUSS] Wird der Anspruch auf Minor Change seitens der Referentinnen und Referenten nicht gutgeheissen, wird der Antrag nach dem Verfahren des Major Change behandelt.
:::

{{< include bausteine/mehrfach/aenderungen-vorversion.md >}}

::: {bb="ech-0003-bb-verfahren-ech-0150-minor" typ="requirement" original-seite="31"}
[MUSS] Das Verfahren und die Organisation von Minor Changes richtet sich nach dem Standard [«[eCH-0150: Change und Releasemanagement von eCH-Standards](https://www.ech.ch/ech/ech-0150)»]{standard="eCH-0150"}.
:::
