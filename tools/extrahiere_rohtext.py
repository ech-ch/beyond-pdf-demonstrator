#!/usr/bin/env python3
"""Rohtext je Kapitel aus dem Original-PDF (Überführung, Schritt 1, E19).

    py -3.11 tools/extrahiere_rohtext.py [PDF] [ZIELORDNER]

Standard: original/eCH-0003_V11.1.0_d.pdf -> original/text/

Ein Skript liefert den Text, die KI legt nur Struktur darum (E19). Das Skript
bereinigt deshalb nur Artefakte der PDF-Extraktion und lässt Fehler des
Originals stehen (E06):

- Kopf- und Fusszeilen fallen weg. Vor dem ersten Absatz, der auf einer neuen
  Seite beginnt, steht die Marke «--- Seite N ---».
- Silbentrennung am Zeilenende wird aufgelöst, die alte Trennung «k-k» wird zu
  «ck» («lük-kenlose» -> «lückenlose»). Vor einem Grossbuchstaben oder einer
  Ziffer bleibt der Bindestrich stehen («eCH-Nummer»), ebenso ein
  Ergänzungsstrich vor «und»/«oder» («Genehmigungs- und …»).
- Das Aufzählungszeichen (U+F0B7) wird zu «- ».
- Zeilen werden zu Absätzen zusammengefügt. Absätze sind durch eine Leerzeile
  getrennt, die Punkte einer Aufzählung stehen ohne Leerzeile untereinander.
- Eine Tabelle ergibt eine Zeile je Tabellenzeile, die Zellen sind durch
  einen Tabulator getrennt; eine leere Zelle bleibt leer. Tabellen mit drei und
  mehr Spalten (Anhang D) werden über die Spaltenpositionen gelesen. Eine nach
  einem Seitenwechsel wiederholte Kopfzeile fällt weg, wie Kopf- und Fusszeile.
- Codeblöcke (EBNF in Anhang F) bleiben zeilengenau erhalten.

Daneben entsteht `inhaltsverzeichnis.tsv` mit allen Überschriften des
Inhaltsverzeichnisses, ihrer Seite und der Angabe, ob unter der Überschrift
eigener Text steht (Grundlage für das Gerüst, E05).

Werkzeug: pdftotext 4.00 (Xpdf, in Git for Windows enthalten). Der Text stammt
aus dem Modus `-simple`, der Tabellen zellenweise richtig liest. Die
Absatzabstände (Leerzeilen) stammen aus dem Modus `-layout`, der dafür die
Zeilen gleich liest. Poppler-pdftotext kennt `-simple` nicht.

Alle Entscheide, die nicht eindeutig sind (Trennstriche, Absatzgrenzen ohne
Abstand), stehen im Protokoll auf der Standardausgabe. Es ist nach jedem Lauf
gegen das PDF zu prüfen.
"""
import re
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

PDF = Path("original/eCH-0003_V11.1.0_d.pdf")
ZIEL = Path("original/text")

# Rohtext-Dateien: (Datei, erste Überschrift, Überschrift danach (exklusiv)).
KAPITEL = [
    ("kap01-1.1-bis-1.2.1.txt", "1", "1.3"),
    ("kap06.txt", "6", "7"),
    ("kap07.txt", "7", "8"),
    ("kap08.txt", "8", "9"),
    ("kap09.txt", "9", "10"),
    ("kap10.txt", "10", "Anhang A"),
    ("anhang-a.txt", "Anhang A", "Anhang B"),
    ("anhang-b.txt", "Anhang B", "Anhang C"),
    ("anhang-c.txt", "Anhang C", "Anhang D"),
    ("anhang-d.txt", "Anhang D", "Anhang E"),
    ("anhang-f.txt", "Anhang F", None),
]

TOC_SEITEN = (2, 4)      # Inhaltsverzeichnis im Original
TEXT_AB_SEITE = 6        # erste Seite mit Text (Seite 5 ist leer)

KOPF = re.compile(r"^\s*E-Government Standards\s+Seite (\d+) von \d+\s*$")
FUSS = (
    re.compile(r"^\s*Verein eCH\s+www\.ech\.ch / info@ech\.ch\s*$"),
    re.compile(r"^\s*eCH-0003 – Leitfaden zur Genehmigung von Anträgen / 11\.1\.0 / Genehmigt / 2022-07-25\s*$"),
)
TOC_ZEILE = re.compile(r"^(?P<nr>\d+(?:\.\d+)*|Anhang [A-Z])\s+(?:–\s+)?(?P<titel>.+?)\s*\.{3,}\s*(?P<seite>\d+)$")
KENNZEICHNUNG = re.compile(r"^\[(MUSS|SOLLTE|DARF NICHT|KANN)\]")
BULLET = ""
ZWEISPALTIG = re.compile(r"^(\S.*?)\s{2,}(\S.*)$")
ZELLE = re.compile(r"\S+(?: \S+)*")    # Zellen sind durch mindestens zwei Leerzeichen getrennt
EBNF_START = re.compile(r"^<[^>]+> ::=")
ERGAENZUNG = {"und", "oder", "bzw.", "sowie", "bis"}
SATZENDE = re.compile(r"[.:!?»)]$")

protokoll: list[tuple[int, str]] = []


def log(art: str, seite: int, text: str) -> None:
    protokoll.append((seite, f"S.{seite:>2} {art:<13} {text}"))


def pdftotext(pdf: Path, modus: str) -> list[list[str]]:
    """Seiten (Index 1 = Seite 1) als Zeilenlisten."""
    out = subprocess.run(
        ["pdftotext", "-enc", "UTF-8", modus, str(pdf), "-"],
        check=True, capture_output=True,
    ).stdout.decode("utf-8")
    seiten = out.split("\f")
    return [[]] + [s.split("\n") for s in seiten]


def norm(s: str) -> str:
    return " ".join(s.split())


# --- Inhaltsverzeichnis --------------------------------------------------------

@dataclass
class Eintrag:
    nr: str
    titel: str
    seite: int
    eigener_text: bool = False

    @property
    def ueberschrift(self) -> str:
        sep = " – " if self.nr.startswith("Anhang") else " "
        return f"{self.nr}{sep}{self.titel}"

    @property
    def ebene(self) -> int:
        return 1 if self.nr.startswith("Anhang") else self.nr.count(".") + 1


def lies_inhaltsverzeichnis(layout: list[list[str]]) -> list[Eintrag]:
    eintraege = []
    for nr in range(TOC_SEITEN[0], TOC_SEITEN[1] + 1):
        for zeile in layout[nr]:
            m = TOC_ZEILE.match(zeile.strip())
            if m:
                eintraege.append(Eintrag(m["nr"], m["titel"].strip(), int(m["seite"])))
    return eintraege


# --- Zeilen --------------------------------------------------------------------

@dataclass
class Zeile:
    seite: int
    text: str                 # wie im Modus -simple, rechts gekürzt
    leer_davor: bool | None   # Leerzeile davor im Modus -layout (None: unbekannt)

    @property
    def s(self) -> str:
        return self.text.strip()

    @property
    def einzug(self) -> int:
        return len(self.text) - len(self.text.lstrip())


def ist_kopf_oder_fuss(zeile: str) -> bool:
    return bool(KOPF.match(zeile)) or any(p.match(zeile) for p in FUSS)


def leerzeilen_aus_layout(layout_seite: list[str]) -> list[tuple[str, bool | None]]:
    """Normalisierte Zeilen einer Seite mit «Leerzeile davor».

    Für die erste Zeile einer Seite ist das unbekannt (None): Der Abstand zur
    Kopfzeile sagt nichts über Absätze.
    """
    result: list[tuple[str, bool | None]] = []
    leer = False
    for z in layout_seite:
        if not z.strip():
            leer = True
            continue
        if not ist_kopf_oder_fuss(z):
            result.append((norm(z), leer if result else None))
        leer = False
    return result


def lies_zeilen(simple: list[list[str]], layout: list[list[str]]) -> list[Zeile]:
    zeilen = []
    for nr in range(TEXT_AB_SEITE, len(simple)):
        hinweise = leerzeilen_aus_layout(layout[nr]) if nr < len(layout) else []
        zeiger = 0
        for z in simple[nr]:
            if not z.strip() or ist_kopf_oder_fuss(z):
                continue
            leer = None
            n = norm(z)
            for j in range(zeiger, min(zeiger + 8, len(hinweise))):
                if hinweise[j][0] == n:
                    leer, zeiger = hinweise[j][1], j + 1
                    break
            zeilen.append(Zeile(nr, z.rstrip(), leer))
    return zeilen


# --- Zusammenfügen -------------------------------------------------------------

def verbinde(vorne: str, hinten: str, seite: int) -> str:
    """Hängt die nächste Zeile an und löst Trennungen am Zeilenende auf."""
    if not vorne:
        return hinten
    if vorne.endswith("-") and len(vorne) >= 2 and vorne[-2].isalpha():
        wort_vorne = vorne.split()[-1]
        wort_hinten = hinten.split()[0]
        erstes = hinten[0]
        if erstes.islower():
            if wort_hinten in ERGAENZUNG:
                log("Ergänzung", seite, f"{wort_vorne} {wort_hinten} (Bindestrich bleibt)")
                return vorne + " " + hinten
            if vorne.endswith("k-") and not vorne.endswith("ck-") and hinten.startswith("k"):
                log("k-k -> ck", seite, f"{wort_vorne}{wort_hinten} -> {wort_vorne[:-2]}ck{wort_hinten[1:]}")
                return vorne[:-2] + "ck" + hinten[1:]
            log("Trennung", seite, f"{wort_vorne}{wort_hinten} -> {wort_vorne[:-1]}{wort_hinten}")
            return vorne[:-1] + hinten
        log("Bindestrich", seite, f"{wort_vorne}{wort_hinten} (bleibt)")
        return vorne + hinten
    if vorne.endswith(" /"):
        # «1.3.4 /» + «1.3.9» (Anhang D): Leerzeichen vor dem Schrägstrich, also auch danach
        log("Schrägstrich", seite, f"{vorne.split()[-2]} / {hinten.split()[0]} (mit Leerzeichen)")
        return vorne + " " + hinten
    if vorne.endswith("/"):
        log("Schrägstrich", seite, f"{vorne.split()[-1]}{hinten.split()[0]} (ohne Leerzeichen)")
        return vorne + hinten
    return vorne + " " + hinten


@dataclass
class Block:
    art: str                  # titel, absatz, punkt, tabelle, code
    seite: int
    zeilen: list[str] = field(default_factory=list)   # absatz/punkt/code
    zellen: list[list[str]] = field(default_factory=lambda: [[], []])  # tabelle
    letzte_laenge: int = 0    # Länge der letzten Zeile (für Absatzgrenzen)

    def text(self) -> str:
        if self.art == "code":
            return "\n".join(self.zeilen)
        if self.art == "tabelle":
            return "\t".join(self._fuege(z) for z in self.zellen)
        if self.art == "punkt":
            return "- " + self._fuege(self.zeilen)
        return self._fuege(self.zeilen)

    def _fuege(self, teile: list[str]) -> str:
        text = ""
        for t in teile:
            text = verbinde(text, t, self.seite)
        return text


def baue_bloecke(zeilen: list[Zeile], toc: list[Eintrag]) -> list[Block]:
    ueberschriften = {norm(e.ueberschrift) for e in toc}

    bloecke: list[Block] = []
    aktuell: Block | None = None
    in_liste = in_tabelle = in_code = False
    spalte = 0
    mehr: dict | None = None   # Tabelle mit drei und mehr Spalten: Kopfzeile, Spaltenanfänge

    def spalte_von(pos: int) -> int:
        return max(i for i, anfang in enumerate(mehr["spalten"]) if anfang <= pos + 2)

    def zeile_mehrspaltig(z: Zeile, teile: list[tuple[int, str]]) -> None:
        b = neu("tabelle", z)
        b.zellen = [[] for _ in mehr["spalten"]]
        for pos, text in teile:
            b.zellen[spalte_von(pos)].append(text)

    def neu(art: str, z: Zeile) -> Block:
        nonlocal aktuell
        aktuell = Block(art, z.seite)
        bloecke.append(aktuell)
        return aktuell

    for z in zeilen:
        s = z.s
        # Überschrift aus dem Inhaltsverzeichnis
        if z.einzug == 0 and norm(s) in ueberschriften:
            neu("titel", z).zeilen.append(norm(s))
            in_liste = in_tabelle = in_code = False
            mehr = None
            continue
        # Tabelle mit drei und mehr Spalten (Anhang D)
        teile = [(m.start(), m[0]) for m in ZELLE.finditer(z.text)]
        if z.einzug == 0 and len(teile) >= 3 and not KENNZEICHNUNG.match(s):
            zellen = [text for _, text in teile]
            if mehr is not None and zellen == mehr["kopf"]:
                mehr["spalten"] = [pos for pos, _ in teile]
                log("Kopfzeile", z.seite, f"wiederholte Kopfzeile der Tabelle übergangen: {' | '.join(zellen)}")
                continue
            if mehr is None:
                mehr = {"kopf": zellen, "spalten": [pos for pos, _ in teile]}
            zeile_mehrspaltig(z, teile)
            in_tabelle, in_liste = True, False
            continue
        if mehr is not None:
            if z.einzug == 0 and len(teile) == 2 and not KENNZEICHNUNG.match(s):
                zeile_mehrspaltig(z, teile)   # Zeile mit leerer Zelle («Beilage»)
                continue
            if z.einzug > 0 or (len(teile) == 1 and len(s) < mehr["spalten"][1]):
                for pos, text in teile:
                    aktuell.zellen[spalte_von(pos)].append(text)
                continue
            mehr = None
        # Codeblock (EBNF)
        if EBNF_START.match(s) or (in_code and (s.startswith("|") or s == "):")):
            if not in_code:
                neu("code", z)
                in_code = True
            aktuell.zeilen.append(z.text)
            continue
        in_code = False
        # Tabelle mit zwei Spalten
        m = ZWEISPALTIG.match(z.text) if z.einzug == 0 else None
        if m and not KENNZEICHNUNG.match(s):
            if in_tabelle and aktuell.art == "tabelle" and not aktuell.zellen[0]:
                aktuell.zellen[0].append(m[1])
            else:
                neu("tabelle", z).zellen[0].append(m[1])
            aktuell.zellen[1].append(m[2])
            in_tabelle, in_liste, spalte = True, False, m.start(2)
            continue
        if z.einzug >= 10 and not in_liste and not s.startswith(BULLET):
            if not in_tabelle:
                neu("tabelle", z)
                in_tabelle, spalte = True, z.einzug
            aktuell.zellen[1].append(s)
            continue
        if in_tabelle and z.einzug == 0 and len(s) < spalte and not KENNZEICHNUNG.match(s):
            aktuell.zellen[0].append(s)
            continue
        in_tabelle = False
        # Aufzählung
        if s.startswith(BULLET):
            neu("punkt", z).zeilen.append(s[1:].strip())
            in_liste = True
            continue
        if in_liste and z.einzug > 0:
            aktuell.zeilen.append(s)
            continue
        in_liste = False
        # Absatz
        neuer_absatz = aktuell is None or aktuell.art != "absatz"
        if not neuer_absatz:
            vorher = aktuell.zeilen[-1]
            satzende = SATZENDE.search(vorher) is not None
            if KENNZEICHNUNG.match(s):
                neuer_absatz = True
            elif z.leer_davor:
                # Ein grösserer Zeilenabstand mitten im Satz ist kein Absatz
                # (Anhang F: «… ohne optionale Ergänzungen / lautet wie folgt:»).
                if not satzende and s[0].islower():
                    log("Abstand?", z.seite, f"Leerzeile vor «{s[:40]}…» übergangen (Satz läuft weiter)")
                else:
                    neuer_absatz = True
            elif satzende and not s[0].islower():
                # Kleine Absatzabstände zeigt -layout nicht als Leerzeile
                # (7.3: «… z.B. «3.7.1»» / «Die Nummer sind …»).
                neuer_absatz = True
                log("Absatz?", z.seite, f"ohne Leerzeile: «…{vorher[-30:]}» / «{s[:30]}…» getrennt")
        if neuer_absatz:
            neu("absatz", z)
        aktuell.zeilen.append(s)
    return bloecke


def markiere_eigenen_text(bloecke: list[Block], toc: list[Eintrag]) -> None:
    nach_titel = {norm(e.ueberschrift): e for e in toc}
    vorher: Eintrag | None = None
    for b in bloecke:
        if b.art == "titel":
            vorher = nach_titel[b.zeilen[0]]
        elif vorher is not None:
            vorher.eigener_text = True


# --- Ausgabe -------------------------------------------------------------------

def schreibe_kapitel(bloecke: list[Block], toc: list[Eintrag], ziel: Path) -> set[int]:
    """Schreibt die Rohtext-Dateien und gibt die betroffenen Seiten zurück."""
    titel_von = {e.nr: norm(e.ueberschrift) for e in toc}
    seiten: set[int] = set()
    for datei, von, bis in KAPITEL:
        start = next(i for i, b in enumerate(bloecke) if b.art == "titel" and b.zeilen[0] == titel_von[von])
        ende = len(bloecke)
        if bis is not None:
            ende = next(i for i, b in enumerate(bloecke) if b.art == "titel" and b.zeilen[0] == titel_von[bis])
        teile, seite, vorher = [], None, None
        for b in bloecke[start:ende]:
            if b.seite != seite:
                seite = b.seite
                teile.append(f"\n--- Seite {seite} ---\n")
            elif vorher is not None and not (vorher.art == "punkt" and b.art == "punkt") \
                    and not (vorher.art == "tabelle" and b.art == "tabelle"):
                teile.append("\n")
            teile.append(b.text() + "\n")
            seiten.add(b.seite)
            vorher = b
        (ziel / datei).write_text("".join(teile).lstrip("\n"), encoding="utf-8", newline="\n")
        print(f"{ziel / datei}: {ende - start} Blöcke")
    return seiten


def schreibe_toc(toc: list[Eintrag], ziel: Path) -> None:
    zeilen = ["ebene\tnummer\ttitel\tseite\teigener_text"]
    for e in toc:
        zeilen.append(f"{e.ebene}\t{e.nr}\t{e.titel}\t{e.seite}\t{'ja' if e.eigener_text else 'nein'}")
    (ziel / "inhaltsverzeichnis.tsv").write_text("\n".join(zeilen) + "\n", encoding="utf-8", newline="\n")
    print(f"{ziel / 'inhaltsverzeichnis.tsv'}: {len(toc)} Überschriften")


def main() -> None:
    pdf = Path(sys.argv[1]) if len(sys.argv) > 1 else PDF
    ziel = Path(sys.argv[2]) if len(sys.argv) > 2 else ZIEL
    ziel.mkdir(parents=True, exist_ok=True)
    layout = pdftotext(pdf, "-layout")
    simple = pdftotext(pdf, "-simple")
    toc = lies_inhaltsverzeichnis(layout)
    bloecke = baue_bloecke(lies_zeilen(simple, layout), toc)
    markiere_eigenen_text(bloecke, toc)
    gefunden = {b.zeilen[0] for b in bloecke if b.art == "titel"}
    for e in toc:
        if norm(e.ueberschrift) not in gefunden:
            print(f"WARNUNG: Überschrift nicht im Text gefunden: {e.ueberschrift}", file=sys.stderr)
    seiten = schreibe_kapitel(bloecke, toc, ziel)
    schreibe_toc(toc, ziel)
    print("\nProtokoll für die Seiten der Rohtexte (gegen das PDF prüfen):")
    for seite, eintrag in protokoll:
        if seite in seiten:
            print("  " + eintrag)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    main()
