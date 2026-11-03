#!/usr/bin/env python3
"""CI-Prüfungen des Demonstrators (AP7, MVP-Spezifikation 3.7).

    py -3.11 tools/pruefe.py quelle                    vor dem Rendern
    py -3.11 tools/pruefe.py ausgabe [--log DATEI]     nach dem Rendern

Konfiguration: tools/pruefe.toml. Nur Standardbibliothek; alle Dateien werden
ausdrücklich als UTF-8 gelesen. Rückgabewert 1, wenn ein Fehler gefunden
wurde; Hinweise brechen nicht ab. In GitHub Actions erscheinen Fehler und
Hinweise zusätzlich als Annotation an der Datei.

Quelle (Gerüst und Baustein-Dateien):
  1. keine YAML-Kopfzeile in Baustein-Dateien (Spike S2, E07)
  2. ID-Format und Zeichen (R1, R2); `typ` und `original-seite` vorhanden (E09)
  3. jede ID nur einmal in der Quelle (R5); Mehrfachverwendung nur über
     bausteine/mehrfach/ (E27); jede Baustein-Datei eingebunden
  4. grober Baustein: Anker `sec-<kurzname>` passt zur ID (R6)
  5. keine Kapitel- oder Anhangsnummer als reiner Text (K1)
  6. je feinem Baustein höchstens eine Kennzeichnung, ohne Kennzeichnung nur
     mit Typ ausser `requirement`; jede Kennzeichnung in einem feinen
     Baustein (E29)
  7. Ziele von `bezug` existieren (E30)
  8. Hinweis bei zeichengleichen Klauseln ohne Mehrfachverwendung (E27)

Ausgabe (gerendertes HTML und Word, je überführtem Kapitel):
  1. Zählung der Kennzeichnungen (D4)
  2. normalisierter Textvergleich mit dem Rohtext aus original/text/ (E19);
     normalisiert wird nur ASCII-Leerraum, ein geschütztes Leerzeichen gilt
     als Abweichung (E11)
  3. kein unaufgelöster Verweis: «?@…», «@sec-…» im Text oder die
     Quarto-Warnung «Unable to resolve crossref» im Log (K3)
"""
import argparse
import difflib
import html
import os
import re
import sys
import tomllib
import zipfile
from dataclasses import dataclass, field
from html.parser import HTMLParser
from pathlib import Path

WURZEL = Path(__file__).resolve().parent.parent
KONFIG = Path(__file__).resolve().with_suffix(".toml")

ATTR = re.compile(r'#([\w-]+)|\.([\w-]+)|([\w-]+)=(?:"([^"]*)"|(\S+))')
TITEL = re.compile(r"^(#{1,6})\s+(.*?)\s*\{([^}]*)\}\s*$")
DIV_AUF = re.compile(r"^(:{3,})\s*\{([^}]*)\}\s*$")
DIV_ZU = re.compile(r"^:{3,}\s*$")
INCLUDE = re.compile(r"\{\{<\s*include\s+(\S+)\s*>\}\}")
YAML_SCHLUESSEL = re.compile(r"^[A-Za-z0-9_-]+\s*:")
KOMMENTAR = re.compile(r"<!--.*?-->", re.S)
NUMMER_VON_HAND = (
    re.compile(r"\b(?:Kapitel|Kapiteln|Unterkapitel|Abschnitt)\s+\d+(?:\.\d+)*\b"),
    re.compile(r"\bAnh(?:ang|änge)\s+[A-Z]\b"),
    re.compile(r"\((?:siehe|vgl\.)\s+\d+(?:\.\d+)+\)"),
)
LEERRAUM = re.compile(r"[ \t\r\n]+")   # nur ASCII-Leerraum, nicht U+00A0


# --- Befunde -----------------------------------------------------------------

@dataclass
class Befunde:
    fehler: int = 0
    hinweise: int = 0

    def melde(self, stufe: str, text: str, datei: Path | None = None, zeile: int | None = None) -> None:
        ort = ""
        if datei is not None:
            ort = rel(datei) + (f":{zeile}" if zeile else "") + ": "
        print(f"{stufe.upper():7} {ort}{text}")
        if os.environ.get("GITHUB_ACTIONS") == "true":
            art = "error" if stufe == "fehler" else "warning"
            pos = f" file={rel(datei)}" + (f",line={zeile}" if zeile else "") if datei else ""
            print(f"::{art}{pos}::{text}")
        if stufe == "fehler":
            self.fehler += 1
        else:
            self.hinweise += 1

    def fehler_(self, text, datei=None, zeile=None):
        self.melde("fehler", text, datei, zeile)

    def hinweis(self, text, datei=None, zeile=None):
        self.melde("hinweis", text, datei, zeile)


def rel(pfad: Path) -> str:
    try:
        return pfad.resolve().relative_to(WURZEL).as_posix()
    except ValueError:
        return str(pfad)


def lies(pfad: Path) -> str:
    return pfad.read_text(encoding="utf-8")


def attribute(text: str) -> dict:
    """{'id': …, 'klassen': […], Schlüssel: Wert} aus dem Inhalt von {…}."""
    werte: dict = {"klassen": []}
    for m in ATTR.finditer(text):
        if m[1]:
            werte["id"] = m[1]
        elif m[2]:
            werte["klassen"].append(m[2])
        else:
            werte[m[3]] = m[4] if m[4] is not None else m[5]
    return werte


# --- Quelle ------------------------------------------------------------------

@dataclass
class Baustein:
    bb: str
    art: str                 # grob, fein, inline
    attr: dict
    datei: Path
    zeile: int
    absaetze: list[str] = field(default_factory=list)   # nur feine Bausteine


def zerlege(datei: Path, text: str, bausteine: list[Baustein], kennz: re.Pattern, b: Befunde) -> None:
    """Liest Überschriften, :::-Blöcke und Absatzanfänge einer Datei."""
    zeilen = KOMMENTAR.sub(lambda m: "\n" * m[0].count("\n"), text).split("\n")
    stapel: list[Baustein | None] = []
    absatzanfang, im_code = True, False
    for nr, zeile in enumerate(zeilen, 1):
        if zeile.lstrip().startswith("```"):
            im_code = not im_code
            continue
        if im_code:
            continue
        if m := TITEL.match(zeile):
            a = attribute(m[3])
            if "bb" in a:
                bausteine.append(Baustein(a["bb"], "grob", a, datei, nr))
            absatzanfang = True
            continue
        if m := DIV_AUF.match(zeile):
            a = attribute(m[2])
            neu = Baustein(a["bb"], "fein", a, datei, nr) if "bb" in a else None
            if neu:
                bausteine.append(neu)
            stapel.append(neu)
            absatzanfang = True
            continue
        if DIV_ZU.match(zeile):
            if stapel:
                stapel.pop()
            else:
                b.fehler_("schliessendes ::: ohne öffnendes", datei, nr)
            absatzanfang = True
            continue
        if not zeile.strip():
            absatzanfang = True
            continue
        innerster = next((x for x in reversed(stapel) if x is not None), None)
        if innerster is not None:
            if absatzanfang:
                innerster.absaetze.append(zeile.strip())
            else:
                innerster.absaetze[-1] += " " + zeile.strip()
        if absatzanfang and kennz.match(zeile.strip()) and innerster is None:
            b.fehler_(f"Kennzeichnung ausserhalb eines feinen Bausteins: «{zeile.strip()[:60]}…» (E29)", datei, nr)
        for m in re.finditer(r"\]\{([^}]*\bbb=[^}]*)\}", zeile):
            a = attribute(m[1])
            bausteine.append(Baustein(a["bb"], "inline", a, datei, nr))
        absatzanfang = False
    if stapel:
        b.fehler_(f"{len(stapel)} ::: nicht geschlossen", datei)


def pruefe_k1(datei: Path, text: str, b: Befunde) -> None:
    ohne = KOMMENTAR.sub(lambda m: "\n" * m[0].count("\n"), text)
    for nr, zeile in enumerate(ohne.split("\n"), 1):
        if TITEL.match(zeile) or zeile.startswith(("---", "title:", "abstract:")):
            continue
        for muster in NUMMER_VON_HAND:
            for m in muster.finditer(zeile):
                b.fehler_(f"Nummer von Hand «{m[0]}»: Querverweis mit -@sec-… schreiben (K1)", datei, nr)


def pruefe_quelle(std: dict, b: Befunde) -> None:
    quelle = WURZEL / std["quelle"]
    geruest = quelle / "index.qmd"
    ordner = quelle / "bausteine"
    praefix = std["id_praefix"]
    kennz = re.compile(r"^\[(" + "|".join(re.escape(k) for k in std["kennzeichnungen"]) + r")\]")
    mit_original = re.search(r"^original:", lies(WURZEL / std["metadaten"]), re.M) is not None
    id_muster = re.compile("^" + re.escape(praefix) + r"[a-z0-9]+(?:-[a-z0-9]+)*$")

    dateien = sorted(ordner.rglob("*.md")) if ordner.exists() else []
    bausteine: list[Baustein] = []
    includes: dict[Path, list[tuple[Path, int]]] = {}
    for datei in [geruest] + dateien:
        text = lies(datei)
        ohne_kommentare = KOMMENTAR.sub(lambda m: "\n" * m[0].count("\n"), text)
        for nr, zeile in enumerate(ohne_kommentare.split("\n"), 1):
            for m in INCLUDE.finditer(zeile):
                # Quarto löst auch verschachtelte Includes ab dem Gerüst auf (E32)
                ziel = (quelle / m[1]).resolve()
                includes.setdefault(ziel, []).append((datei, nr))
                if not ziel.exists():
                    b.fehler_(f"eingebundene Datei fehlt: {m[1]}", datei, nr)
        if datei != geruest:
            # 1. YAML-Kopfzeile
            zeilen = text.split("\n")
            for i, zeile in enumerate(zeilen):
                if zeile.strip() == "---":
                    folgende = next((z for z in zeilen[i + 1:] if z.strip()), "")
                    if YAML_SCHLUESSEL.match(folgende):
                        b.fehler_("YAML-Kopfzeile in Baustein-Datei (überschreibt still die Metadaten, Spike S2)", datei, i + 1)
            # grober Baustein beginnt mit seiner Überschrift
            if datei.parent == ordner:
                erste = next((z for z in zeilen if z.strip()), "")
                m = TITEL.match(erste)
                if not (m and "bb" in attribute(m[3])):
                    b.fehler_("Baustein-Datei beginnt nicht mit der Überschrift eines groben Bausteins (bb)", datei, 1)
        pruefe_k1(datei, text, b)
        zerlege(datei, text, bausteine, kennz, b)

    # 3. Einbindung
    for datei in dateien:
        n = len(includes.get(datei.resolve(), []))
        mehrfach = datei.parent.name == "mehrfach"
        if n == 0:
            b.fehler_("Baustein-Datei ist nirgends eingebunden", datei)
        elif mehrfach and n < 2:
            b.hinweis("mehrfach verwendeter Baustein ist nur einmal eingebunden (E27)", datei)
        elif not mehrfach and n > 1:
            b.fehler_(f"Baustein-Datei {n}× eingebunden; Mehrfachverwendung nur über bausteine/mehrfach/ (E27)", datei)

    # 2.–4. IDs
    gesehen: dict[str, Baustein] = {}
    for x in bausteine:
        if not id_muster.match(x.bb):
            b.fehler_(f"ID «{x.bb}» verletzt R1/R2 ({praefix}<kurzname>, a–z, 0–9, Bindestrich)", x.datei, x.zeile)
        if x.bb in gesehen:
            erste = gesehen[x.bb]
            b.fehler_(f"ID «{x.bb}» doppelt (zuerst {rel(erste.datei)}:{erste.zeile}); "
                      "Mehrfachverwendung nur über bausteine/mehrfach/ (R5, E27)", x.datei, x.zeile)
        else:
            gesehen[x.bb] = x
        if x.art != "inline":
            if "typ" not in x.attr:
                b.fehler_(f"«{x.bb}» ohne typ (E09)", x.datei, x.zeile)
            seite = x.attr.get("original-seite")
            if mit_original and seite is None:
                b.fehler_(f"«{x.bb}» ohne original-seite (E09)", x.datei, x.zeile)
            elif seite is not None and not re.fullmatch(r"\d+(?: \d+)*", seite):
                b.fehler_(f"«{x.bb}»: original-seite «{seite}» ist keine Seitenzahl", x.datei, x.zeile)
        if x.art == "grob":
            soll = "sec-" + x.bb[len(praefix):]
            if x.attr.get("id") != soll:
                b.fehler_(f"grober Baustein «{x.bb}»: Anker «#{x.attr.get('id')}» statt «#{soll}» (R6)", x.datei, x.zeile)
        elif x.attr.get("id"):
            b.hinweis(f"feiner Baustein «{x.bb}» mit eigener ID «#{x.attr['id']}»; den Anker setzt ein Filter (R6)", x.datei, x.zeile)

    # 6. Kennzeichnungen je feinem Baustein
    for x in bausteine:
        if x.art != "fein":
            continue
        n = sum(1 for a in x.absaetze if kennz.match(a))
        if n > 1:
            b.fehler_(f"«{x.bb}» enthält {n} Kennzeichnungen; höchstens eine je feinem Baustein (E29)", x.datei, x.zeile)
        if n == 0 and x.attr.get("typ") == "requirement":
            b.fehler_(f"«{x.bb}» ohne Kennzeichnung, aber Typ requirement (E29, G4)", x.datei, x.zeile)

    # 7. bezug
    for x in bausteine:
        for ziel in x.attr.get("bezug", "").split():
            if ziel == x.bb:
                b.fehler_(f"«{x.bb}» bezieht sich auf sich selbst (E30)", x.datei, x.zeile)
            elif ziel not in gesehen:
                b.fehler_(f"bezug-Ziel «{ziel}» gibt es nicht (E30)", x.datei, x.zeile)

    # 8. zeichengleiche Klauseln
    nach_text: dict[str, list[Baustein]] = {}
    for x in bausteine:
        if x.art == "fein" and x.absaetze:
            nach_text.setdefault(" ".join(x.absaetze), []).append(x)
    for gleiche in nach_text.values():
        if len(gleiche) > 1:
            namen = ", ".join(f"{g.bb} ({rel(g.datei)}:{g.zeile})" for g in gleiche)
            b.hinweis(f"zeichengleiche Klauseln ohne Mehrfachverwendung: {namen} (E27)", gleiche[0].datei, gleiche[0].zeile)

    grob = sum(1 for x in bausteine if x.art == "grob")
    fein = sum(1 for x in bausteine if x.art == "fein")
    print(f"{std['name']}: {len(dateien)} Baustein-Dateien, {grob} grobe und {fein} feine Bausteine in der Quelle")


# --- Ausgabe -----------------------------------------------------------------

def norm(text: str) -> str:
    return LEERRAUM.sub(" ", text).strip()


class HtmlText(HTMLParser):
    BLOCK = {"p", "div", "section", "h1", "h2", "h3", "h4", "h5", "h6", "li", "ul", "ol", "br", "pre",
             "table", "tr", "td", "th", "dl", "dt", "dd", "header", "nav", "main", "blockquote", "figure"}
    LEER = {"br", "img", "hr", "input", "meta", "link", "wbr"}

    def __init__(self, ignorieren: set[str]):
        super().__init__(convert_charrefs=True)
        self.ignorieren = ignorieren
        self.teile: list[str] = []
        self.offen: list[bool] = []   # je offenem Element: wird ignoriert?

    def handle_starttag(self, tag, attrs):
        klassen = set((dict(attrs).get("class") or "").split())
        aus = tag in ("script", "style") or bool(klassen & self.ignorieren)
        if tag not in self.LEER:
            self.offen.append(aus)
        if tag in self.BLOCK:
            self.teile.append(" ")

    def handle_endtag(self, tag):
        if tag not in self.LEER and self.offen:
            self.offen.pop()
        if tag in self.BLOCK:
            self.teile.append(" ")

    def handle_data(self, data):
        if not any(self.offen):
            self.teile.append(data)


def html_kapitel(t: str, von: str, bis: str, ignorieren: set[str]) -> str:
    a = t.index(f'<section id="{von}"')
    e = t.index(f'<section id="{bis}"', a)
    p = HtmlText(ignorieren)
    p.feed(t[a:e])
    return norm("".join(p.teile))


def docx_absaetze(pfad: Path) -> list[tuple[str, set[str]]]:
    """(Text, Textmarken) je Absatz des Word-Dokuments."""
    with zipfile.ZipFile(pfad) as z:
        xml = z.read("word/document.xml").decode("utf-8")
    # Pandoc setzt die Textmarken von Abschnitten zwischen die Absätze; sie
    # gehören zum folgenden Absatz.
    absaetze, offen = [], set()
    for m in re.finditer(r"<w:bookmarkStart\b[^>]*/>|<w:p[ >].*?</w:p>|<w:p/>", xml, re.S):
        p = m[0]
        marken = set(re.findall(r'<w:bookmarkStart\b[^>]*w:name="([^"]+)"', p))
        if p.startswith("<w:bookmarkStart"):
            offen |= marken
            continue
        teile = re.findall(r"<w:t(?: [^>]*)?>([^<]*)</w:t>|<w:(tab|br)\b[^>]*/>", p)
        text = "".join(t if t else " " for t, sonst in teile)
        absaetze.append((html.unescape(text), marken | offen))
        offen = set()
    return absaetze


def docx_kapitel(absaetze, von: str, bis: str) -> str:
    a = next(i for i, (_, m) in enumerate(absaetze) if von in m)
    e = next(i for i, (_, m) in enumerate(absaetze) if bis in m and i > a)
    return norm(" ".join(t for t, _ in absaetze[a:e]))


def rohtext(pfad: Path, ueberschriften: dict[str, str] | None) -> str:
    """Rohtext ohne Seitenmarken und Listenzeichen; ohne Kapitelnummern, wenn
    `ueberschriften` (Überschrift mit Nummer -> ohne) gegeben ist (Word)."""
    zeilen = []
    for z in lies(pfad).split("\n"):
        if re.fullmatch(r"--- Seite \d+ ---", z):
            continue
        if z.startswith("- "):
            z = z[2:]
        if ueberschriften and z in ueberschriften:
            z = ueberschriften[z]
        zeilen.append(z)
    return norm("\n".join(zeilen))


def vergleiche(name: str, ist: str, soll: str, quelle: Path, b: Befunde, max_stellen: int = 5) -> None:
    if ist == soll:
        print(f"{name}: Klartext gleich wie {rel(quelle)} ({len(soll)} Zeichen)")
        return
    sm = difflib.SequenceMatcher(None, soll, ist, autojunk=False)
    stellen = [op for op in sm.get_opcodes() if op[0] != "equal"]
    for op, a1, a2, b1, b2 in stellen[:max_stellen]:
        b.fehler_(f"{name}: Text weicht vom Rohtext ab ({op}): Rohtext «…{soll[max(0, a1 - 25):a2 + 25]}…» / "
                  f"gerendert «…{ist[max(0, b1 - 25):b2 + 25]}…» (E19)", quelle)
    if len(stellen) > max_stellen:
        b.fehler_(f"{name}: {len(stellen) - max_stellen} weitere Abweichungen", quelle)


def pruefe_ausgabe(std: dict, log: Path | None, b: Befunde) -> None:
    html_pfad, docx_pfad = WURZEL / std["html"], WURZEL / std["docx"]
    for pfad in (html_pfad, docx_pfad):
        if not pfad.exists():
            b.fehler_(f"Ausgabe fehlt, erst `quarto render`: {rel(pfad)}")
            return
    html_roh = lies(html_pfad)
    absaetze = docx_absaetze(docx_pfad)
    ignorieren = set(std.get("html_ignorieren", []))
    ueberschriften = {}
    for zeile in lies(WURZEL / std["inhaltsverzeichnis"]).split("\n")[1:]:
        if zeile.strip():
            _, nr, titel, *_ = zeile.split("\t")
            if not nr.startswith("Anhang"):
                ueberschriften[f"{nr} {titel}"] = titel

    # 3. unaufgelöste Verweise im ganzen Dokument
    seite = HtmlText(ignorieren)
    seite.feed(html_roh)
    for name, text in (("HTML", "".join(seite.teile)), ("Word", " ".join(t for t, _ in absaetze))):
        for m in re.finditer(r"\?@[\w:-]+|(?<![\w.])-?@(?:sec|fig|tbl)-[\w-]+", text):
            b.fehler_(f"{name}: unaufgelöster Verweis «{m[0]}» (K3)", html_pfad if name == "HTML" else docx_pfad)
    if log is not None:
        for nr, zeile in enumerate(log.read_text(encoding="utf-8", errors="replace").split("\n"), 1):
            if "Unable to resolve crossref" in zeile:
                ohne_farben = re.sub(r"\x1b\[[0-9;]*m", "", zeile).strip()
                b.fehler_(f"Quarto: {ohne_farben} (K3)", log, nr)

    # 1.–2. je überführtem Kapitel
    for kap in std.get("kapitel", []):
        quelle = WURZEL / kap["rohtext"]
        try:
            h = html_kapitel(html_roh, kap["von"], kap["bis"], ignorieren)
        except ValueError:
            b.fehler_(f"{kap['name']}: Abschnitt #{kap['von']} … #{kap['bis']} im HTML nicht gefunden", html_pfad)
            continue
        try:
            d = docx_kapitel(absaetze, kap["von"], kap["bis"])
        except StopIteration:
            b.fehler_(f"{kap['name']}: Textmarken {kap['von']} … {kap['bis']} im Word nicht gefunden", docx_pfad)
            continue
        vergleiche(f"{kap['name']}, HTML", h, rohtext(quelle, None), quelle, b)
        vergleiche(f"{kap['name']}, Word", d, rohtext(quelle, ueberschriften), quelle, b)
        for name, text in (("HTML", h), ("Word", d)):
            ist = {k: text.count(f"[{k}]") for k in kap["zaehlung"]}
            if ist != kap["zaehlung"]:
                b.fehler_(f"{kap['name']}, {name}: Kennzeichnungen {ist}, erwartet {kap['zaehlung']} (D4)")
            else:
                print(f"{kap['name']}, {name}: Zählung {ist}")


def main() -> int:
    sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description="CI-Prüfungen des Demonstrators")
    parser.add_argument("phase", choices=["quelle", "ausgabe"])
    parser.add_argument("--log", type=Path, help="Ausgabe von `quarto render` (Warnungen)")
    args = parser.parse_args()
    konfig = tomllib.loads(KONFIG.read_text(encoding="utf-8"))
    b = Befunde()
    for std in konfig["standard"]:
        if args.phase == "quelle":
            pruefe_quelle(std, b)
        else:
            pruefe_ausgabe(std, args.log, b)
    print(f"Prüfung {args.phase}: {b.fehler} Fehler, {b.hinweise} Hinweise")
    return 1 if b.fehler else 0


if __name__ == "__main__":
    sys.exit(main())
