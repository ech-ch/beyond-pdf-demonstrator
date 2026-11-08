#!/usr/bin/env python3
"""Abbildungen aus dem Original-PDF als PNG (Überführung, AP25, F10 vorläufig E52).

    py -3.11 tools/schneide_abbildungen.py [PDF] [ZIELORDNER]

Standard: original/eCH-0003_V11.1.0_d.pdf -> ech-0003/v11.1.0/de/abbildungen/

Die Abbildungen von eCH-0003 V11.1.0 sind im Word-Original eingebettete
Visio-Zeichnungen. Im PDF bestehen sie aus vielen kleinen Rasterbildern
(Kästchen, Pfeile) mit Text darüber. Das Skript rendert die Seite und schneidet
den Bereich der Abbildung aus, ohne Bildunterschrift; die Bildunterschrift
erzeugt der Build (Nummer aus der Reihenfolge, E11).

Wie beim Rohtext liefert ein Skript das Bild, von Hand wird nichts geändert
(E19). Die Bereiche unten sind in Pixeln bei 300 dpi angegeben, mit etwa 15 px
Rand um die dunklen Pixel der Abbildung; sie wurden einmal am gerenderten PDF
bestimmt (AP25). Das Skript prüft, dass der Rand weiss ist, also nichts
abgeschnitten wird.

Werkzeug: pdftoppm (Poppler, z.B. aus MiKTeX), Pillow für die Prüfung. Die
Schrift Arial ist im PDF nicht eingebettet; gerendert wird mit der Arial des
Systems (Windows). Die Ergebnisse sind committet; das Skript läuft nicht in
der CI.
"""
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image

PDF = Path("original/eCH-0003_V11.1.0_d.pdf")
ZIEL = Path("ech-0003/v11.1.0/de/abbildungen")
DPI = 300

# Datei, Seite im Original, Bereich (links, oben, Breite, Höhe) in Pixeln bei DPI
ABBILDUNGEN = [
    ("genehmigungsprozess.png", 7, (205, 542, 2116, 563)),     # Abbildung 1, 1.3
    ("fristen-und-termine.png", 13, (205, 473, 2144, 623)),    # Abbildung 2, 1.4
]

WEISS = 245   # hellster Grauwert, der noch als Inhalt gilt


def rand_ist_weiss(pfad: Path) -> bool:
    bild = Image.open(pfad).convert("L")
    b, h = bild.size
    px = bild.load()
    rand = [(x, 0) for x in range(b)] + [(x, h - 1) for x in range(b)] \
        + [(0, y) for y in range(h)] + [(b - 1, y) for y in range(h)]
    return all(px[p] >= WEISS for p in rand)


def main() -> int:
    pdf = Path(sys.argv[1]) if len(sys.argv) > 1 else PDF
    ziel = Path(sys.argv[2]) if len(sys.argv) > 2 else ZIEL
    ziel.mkdir(parents=True, exist_ok=True)
    fehler = 0
    with tempfile.TemporaryDirectory() as tmp:
        for datei, seite, (x, y, w, h) in ABBILDUNGEN:
            praefix = Path(tmp) / datei.removesuffix(".png")
            subprocess.run(
                ["pdftoppm", "-png", "-r", str(DPI), "-f", str(seite), "-l", str(seite),
                 "-x", str(x), "-y", str(y), "-W", str(w), "-H", str(h), "-singlefile",
                 str(pdf), str(praefix)],
                check=True, capture_output=True,
            )
            roh = praefix.with_suffix(".png")
            # Neu speichern ohne Zeitstempel und Software-Angabe: gleiche Eingabe, gleiche Datei
            Image.open(roh).convert("RGB").save(ziel / datei, optimize=True, dpi=(DPI, DPI))
            ok = rand_ist_weiss(ziel / datei)
            fehler += not ok
            print(f"{ziel / datei}: Seite {seite}, {w}×{h} px bei {DPI} dpi"
                  + ("" if ok else " – FEHLER: Rand nicht weiss, Bereich prüfen"))
    return 1 if fehler else 0


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.exit(main())
