#!/usr/bin/env python3
"""Word soll Felder und Inhaltsverzeichnis beim Öffnen aktualisieren (E17).

    py -3.11 tools/aktualisiere_felder_beim_oeffnen.py DATEI.docx [DATEI.docx ...]

Pandoc schreibt das Inhaltsverzeichnis nur als leeres Feld, weil es keine
Seiten umbrechen kann. Word füllt es beim Öffnen, wenn in word/settings.xml
das Element <w:updateFields w:val="true"/> steht. Das Skript setzt dieses
Element nach dem Rendern; Word fragt beim Öffnen einmal nach.

- Nur Standardbibliothek (zipfile).
- Steht das Element schon mit dem Wert «true», bleibt die Datei unberührt.
  Ein zweiter Lauf ändert also nichts.
- Das Element kommt an die Stelle, die das Schema von WordprocessingML
  (CT_Settings) vorsieht: vor das erste Element, das ihm folgen muss, sonst
  ans Ende von <w:settings>.
- Alle übrigen Einträge des Archivs bleiben inhaltlich, in Reihenfolge,
  Zeitstempel und Kompressionsart unverändert. Geschrieben wird in eine
  temporäre Datei, die danach die alte ersetzt.

Rückgabewert: 0, wenn alle Dateien in Ordnung sind; 1, wenn eine Datei nicht
bearbeitet werden konnte.
"""
import os
import re
import sys
import tempfile
import zipfile
from pathlib import Path

EINSTELLUNGEN = "word/settings.xml"

# Kinder von <w:settings>, die nach dem Schema auf <w:updateFields> folgen
# (ECMA-376, CT_Settings), dazu Erweiterungen wie w14:/w15:, die Word ans
# Ende schreibt.
NACHFOLGER_W = (
    "hdrShapeDefaults", "footnotePr", "endnotePr", "compat", "docVars", "rsids",
    "attachedSchema", "themeFontLang", "clrSchemeMapping",
    "doNotIncludeSubdocsInStats", "doNotAutoCompressPictures", "forceUpgrade",
    "captions", "readModeInkLockDown", "smartTagType", "shapeDefaults",
    "doNotEmbedSmartTags", "decimalSymbol", "listSeparator",
)
NACHFOLGER_ANDERE = ("m:mathPr", "sl:schemaLibrary")
ERWEITERUNG = re.compile(r"w1[4-9]\w*|w16\w*")

WAHR = {"true", "1", "on"}


def setze_flag(xml: str) -> tuple[str, str]:
    """Gibt (neues XML, Meldung) zurück; das XML ist unverändert, wenn nichts zu tun ist."""
    wurzel = re.search(r"<(?:(\w+):)?settings\b[^>]*>", xml)
    if wurzel is None or wurzel.group(0).endswith("/>"):
        raise ValueError("kein Element <w:settings> mit Inhalt gefunden")
    p = wurzel.group(1) + ":" if wurzel.group(1) else ""
    element = f'<{p}updateFields {p}val="true"/>'

    vorhanden = re.search(rf"<{re.escape(p)}updateFields\b[^>]*?/?>", xml)
    if vorhanden is not None:
        wert = re.search(rf'\b{re.escape(p)}val="([^"]*)"', vorhanden.group(0))
        if wert is None or wert.group(1).lower() in WAHR:
            return xml, "Flag schon gesetzt, unverändert"
        if not vorhanden.group(0).endswith("/>"):
            raise ValueError("unerwartetes Element <updateFields> mit Inhalt")
        neu = xml[:vorhanden.start()] + element + xml[vorhanden.end():]
        return neu, f'Flag von «{wert.group(1)}» auf «true» gesetzt'

    namen = [re.escape(p + n) for n in NACHFOLGER_W] + [re.escape(n) for n in NACHFOLGER_ANDERE]
    folgt = re.compile(rf"<(?:{'|'.join(namen)}|(?:{ERWEITERUNG.pattern}):\w+)[\s/>]")
    nachfolger = folgt.search(xml, wurzel.end())
    if nachfolger is not None:
        stelle = nachfolger.start()
    else:
        ende = xml.rfind(f"</{p}settings>")
        if ende < wurzel.end():
            raise ValueError("kein schliessendes </w:settings> gefunden")
        stelle = ende
    return xml[:stelle] + element + xml[stelle:], "Flag gesetzt"


def bearbeite(pfad: Path) -> str:
    with zipfile.ZipFile(pfad) as archiv:
        eintraege = archiv.infolist()
        if EINSTELLUNGEN not in archiv.namelist():
            raise ValueError(f"{EINSTELLUNGEN} fehlt")
        alt = archiv.read(EINSTELLUNGEN).decode("utf-8")
        neu, meldung = setze_flag(alt)
        if neu == alt:
            return meldung
        inhalte = {e.filename: archiv.read(e) for e in eintraege}
        kommentar = archiv.comment

    inhalte[EINSTELLUNGEN] = neu.encode("utf-8")
    fd, temp = tempfile.mkstemp(suffix=".docx", dir=pfad.parent)
    os.close(fd)
    try:
        with zipfile.ZipFile(temp, "w") as ziel:
            ziel.comment = kommentar
            for eintrag in eintraege:
                ziel.writestr(eintrag, inhalte[eintrag.filename])
        os.replace(temp, pfad)
    except BaseException:
        os.unlink(temp)
        raise
    return meldung


def main(argumente: list[str]) -> int:
    if not argumente:
        print(__doc__, file=sys.stderr)
        return 2
    fehler = 0
    for name in argumente:
        try:
            print(f"{name}: {bearbeite(Path(name))}")
        except (OSError, ValueError, zipfile.BadZipFile) as e:
            print(f"{name}: FEHLER, {e}", file=sys.stderr)
            fehler += 1
    return 1 if fehler else 0


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.exit(main(sys.argv[1:]))
