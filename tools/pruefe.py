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
     Baustein (E29), ausser im Text ohne Bausteine (AP26, E54)
  7. Ziele von `bezug` existieren (E30)
  8. Hinweis bei zeichengleichen Klauseln ohne Mehrfachverwendung (E27)
  9. Label `bb:<kurzname>` höchstens 50 Zeichen (Grenze von GitHub, E38)
 10. Übersicht «Beziehungen» steht in der render-Liste nach der Standardseite,
     deren Registry sie liest (AP21), ebenso der Steckbrief (AP24)
 11. Steckbrief (AP24, E51): Raster-Fassung vorhanden, jede Auswahl in
     steckbrief.yml nur mit Codes aus dem Vokabular des Rasters, jede Auswahl
     des Rasters belegt
 12. Text ohne Bausteine (AP26, E54): Dateien in text/ beginnen mit einer
     Kapitelüberschrift `.nur-text-kapitel` mit `feedback-id`, alle übrigen
     Überschriften dort tragen `.nur-text`, kein `bb`; beides nur dort;
     feedback-id im Format <standard-id>-<kurzname>, eindeutig, Label
     höchstens 50 Zeichen und nicht gleich dem Label eines Bausteins

Ausgabe (gerendertes HTML und Word, je überführtem Kapitel):
  1. Zählung der Kennzeichnungen (D4)
  2. normalisierter Textvergleich mit dem Rohtext aus original/text/ (E19);
     normalisiert wird nur ASCII-Leerraum, ein geschütztes Leerzeichen gilt
     als Abweichung (E11)
  3. kein unaufgelöster Verweis: «?@…», «@sec-…» im Text oder die
     Quarto-Warnung «Unable to resolve crossref» im Log (K3); jede Meldung
     «ERROR» im Log ist ein Fehler, denn `error()` in einem Lua-Filter bricht
     den Build in Quarto nicht ab (E48); Warnungen sind Hinweise
  4. auf der Website hat jeder Baustein genau einen Anker #<baustein-id> (R6)
  6. Registry bausteine.json (E09, E10, E27, E30): gültiges JSON, dieselben
     Bausteine wie die Quelle, Kennzeichnung und bezug wie in der Quelle, jedes
     Ziel einer Beziehung vorhanden oder ausdrücklich «noch kein Baustein»
     (nur Platzhalter), Vorlagentext, Statustext (E50), Literatur oder
     Standard, Umkehrungen vollständig, keine Selbstverweise
  5. Feedback (E37, E39): je Fundstelle genau ein Link, ein Link zum Standard
     als Ganzes, keine `labels=` in der URL, Wortlaut gleich wie der Rohtext;
     die Bedienelemente stehen im HTML und sind vom Textvergleich ausgenommen;
     im Word gibt es keine
     Kapitel als Text ohne Bausteine (AP26, E54): Hinweis «Text überführt, noch
     nicht in Bausteine zerlegt» genau einmal auf der Website und im Word,
     vom Textvergleich ausgenommen; kein Baustein; Feedback-Knopf vorhanden
  7. Beziehungen (E47, AP21): «Beziehungen (n)» genau bei den Bausteinen mit
     Querverweis oder Rückbezug in der Registry, je Fundstelle einmal, n und
     Einträge stimmen, vom Textvergleich ausgenommen, nicht im Word; die
     Übersichtsseite hat einen Graph ohne Pfeile aus Anhängen (F56), eine
     Legende genau für das, was im Graph vorkommt, je Vorwärtsbeziehung eine
     Tabellenzeile, die Prüfsumme der aktuellen Registry und nur auflösbare
     Links
 10. Abbildungsverzeichnis (Anhang E, AP26): Einträge wie im Original (ohne
     Seitenzahlen), gleich den Bildunterschriften in Reihenfolge, je Eintrag ein
     Link auf die Abbildung; im Word Formatvorlage «Abbildungsverzeichnis» und
     je Eintrag ein Feld PAGEREF auf die Textmarke der Abbildung
  8. interne Links aller Seiten unter _site/: Zieldatei und Anker vorhanden,
     z. B. kein Link auf eine .qmd-Quelle (404 auf GitHub Pages)
  9. Steckbrief (AP24, E51): aus der aktuellen Registry erzeugt (Prüfsumme),
     Auswahlen wie in steckbrief.yml, Referenzen auf eCH-Standards wie in der
     Registry, externe Standards wie Anhang A ohne eCH-Standards,
     Strukturierung deckt die Gliederung der Registry ab (jeder grobe Baustein
     einmal, Zahl der feinen Bausteine), Kennzeichnung «Vorschlag, nicht
     geprüft» genau solange `vorschlag: true`; die Gliederung der Registry
     entspricht dem Inhaltsverzeichnis des Originals
"""
import argparse
import difflib
import hashlib
import html
import json
import os
import re
import sys
import tomllib
import urllib.parse
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
LABEL_MAX = 50                         # Grenze von GitHub für Labels (E38)
URL_MAX = 6000                         # bis hier antwortet GitHub normal (E37)
WORTLAUT_MAX = 2000                    # Zeichen (E37)
FEEDBACK_LINK = re.compile(r'<a class="baustein-feedback[^"]*" data-feedback-(bb|standard)="([^"]*)" href="([^"]*)"')


# --- Befunde -----------------------------------------------------------------

@dataclass
class Befunde:
    fehler: int = 0
    hinweise: int = 0
    still: bool = False   # zählt nur, z.B. beim erneuten Lesen der Quelle

    def melde(self, stufe: str, text: str, datei: Path | None = None, zeile: int | None = None) -> None:
        if self.still:
            self.fehler += stufe == "fehler"
            return
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


NUR_TEXT = {"nur-text", "nur-text-kapitel"}   # Text ohne Bausteine (AP26, E54)


def zerlege(datei: Path, text: str, bausteine: list[Baustein], kennz: re.Pattern, b: Befunde,
            im_text_gezaehlt: dict[str, int] | None = None) -> None:
    """Liest Überschriften, :::-Blöcke und Absatzanfänge einer Datei. Zählt die
    Kennzeichnungen im Text ohne Bausteine in `im_text_gezaehlt`."""
    zeilen = KOMMENTAR.sub(lambda m: "\n" * m[0].count("\n"), text).split("\n")
    stapel: list[Baustein | None] = []
    absatzanfang, im_code, im_text = True, False, False
    for nr, zeile in enumerate(zeilen, 1):
        if zeile.lstrip().startswith("```"):
            im_code = not im_code
            continue
        if im_code:
            continue
        if m := TITEL.match(zeile):
            a = attribute(m[3])
            im_text = bool(NUR_TEXT & set(a["klassen"]))
            if "bb" in a:
                bausteine.append(Baustein(a["bb"], "grob", a, datei, nr))
                if im_text:
                    b.fehler_(f"«{a['bb']}»: Baustein an einer Überschrift mit Text ohne Bausteine (E54)", datei, nr)
            absatzanfang = True
            continue
        if m := DIV_AUF.match(zeile):
            a = attribute(m[2])
            neu = Baustein(a["bb"], "fein", a, datei, nr) if "bb" in a else None
            if neu and im_text:
                b.fehler_(f"«{a['bb']}»: Baustein im Text ohne Bausteine (E54)", datei, nr)
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
        if absatzanfang and (k := kennz.match(zeile.strip())) and innerster is None:
            if im_text:
                if im_text_gezaehlt is not None:
                    im_text_gezaehlt[k[1]] = im_text_gezaehlt.get(k[1], 0) + 1
            else:
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
    text_ordner = quelle / "text"
    text_dateien = sorted(text_ordner.glob("*.md")) if text_ordner.exists() else []
    bausteine: list[Baustein] = []
    includes: dict[Path, list[tuple[Path, int]]] = {}
    im_text_gezaehlt: dict[str, int] = {}
    feedback_ids: dict[str, tuple[Path, int]] = {}
    standard_id = praefix.removesuffix("bb-")   # «ech-0003-»
    for datei in [geruest] + dateien + text_dateien:
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
        zerlege(datei, text, bausteine, kennz, b, im_text_gezaehlt)
        # 12. Text ohne Bausteine: Klassen nur in text/, dort an jeder Überschrift
        ohne = KOMMENTAR.sub(lambda m: "\n" * m[0].count("\n"), text).split("\n")
        erste = True
        for nr, zeile in enumerate(ohne, 1):
            m = TITEL.match(zeile)
            if not m:
                continue
            a, ebene = attribute(m[3]), len(m[1])
            klassen = set(a["klassen"])
            if "feedback-id" in a:
                fid = a["feedback-id"]
                if fid in feedback_ids:
                    b.fehler_(f"feedback-id «{fid}» doppelt (zuerst {rel(feedback_ids[fid][0])}:{feedback_ids[fid][1]})", datei, nr)
                feedback_ids.setdefault(fid, (datei, nr))
            if datei.parent != text_ordner:
                if klassen & NUR_TEXT:
                    b.fehler_("`.nur-text` und `.nur-text-kapitel` nur in den Dateien unter text/ (E54)", datei, nr)
                continue
            if erste:
                if not (ebene == 1 and "nur-text-kapitel" in klassen and "feedback-id" in a and "id" in a):
                    b.fehler_("Datei in text/ beginnt nicht mit einer Kapitelüberschrift {#sec-… .nur-text-kapitel feedback-id=…} (E54)", datei, nr)
            elif "nur-text" not in klassen or ebene == 1:
                b.fehler_("Überschrift in text/ ohne `.nur-text` oder ein zweites Kapitel in derselben Datei (E54)", datei, nr)
            if "original-seite" not in a:
                b.fehler_("Überschrift in text/ ohne original-seite (E09)", datei, nr)
            erste = False

    # 3. Einbindung
    for datei in text_dateien:
        n = len(includes.get(datei.resolve(), []))
        if n != 1:
            b.fehler_(f"Datei mit Text ohne Bausteine ist {n}× eingebunden, erwartet einmal (E54)", datei)
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
        elif len("bb:" + x.bb[len(praefix):]) > LABEL_MAX:
            b.fehler_(f"Label zu «{x.bb}» wäre länger als {LABEL_MAX} Zeichen (E38)", x.datei, x.zeile)
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

    # 12. feedback-id: Format, Label, nicht gleich dem Label eines Bausteins
    fid_muster = re.compile("^" + re.escape(standard_id) + r"[a-z0-9]+(?:-[a-z0-9]+)*$")
    bb_labels = {"bb:" + x.bb[len(praefix):] for x in bausteine}
    for fid, (datei, nr) in sorted(feedback_ids.items()):
        label = "bb:" + fid[len(standard_id):]
        if not fid_muster.match(fid) or fid.startswith(praefix):
            b.fehler_(f"feedback-id «{fid}»: erwartet {standard_id}<kurzname> ohne «bb-» (E38, E54)", datei, nr)
        elif len(label) > LABEL_MAX:
            b.fehler_(f"Label zu feedback-id «{fid}» wäre länger als {LABEL_MAX} Zeichen (E38)", datei, nr)
        elif label in bb_labels:
            b.fehler_(f"feedback-id «{fid}» ergäbe dasselbe Label {label} wie ein Baustein (E38)", datei, nr)

    grob = sum(1 for x in bausteine if x.art == "grob")
    fein = sum(1 for x in bausteine if x.art == "fein")
    print(f"{std['name']}: {len(dateien)} Baustein-Dateien, {grob} grobe und {fein} feine Bausteine in der Quelle")
    if text_dateien:
        zaehlung = ", ".join(f"{k} {im_text_gezaehlt.get(k, 0)}" for k in std["kennzeichnungen"])
        print(f"{std['name']}: {len(text_dateien)} Dateien mit Text ohne Bausteine, Kennzeichnungen dort: {zaehlung}; "
              f"{len(feedback_ids)} feedback-id ({', '.join(sorted(feedback_ids))})")

    # 10. Reihenfolge: Übersicht «Beziehungen» und Steckbrief nach der Standardseite
    for schluessel in ("beziehungen_quelle", "steckbrief_quelle"):
        if schluessel not in std:
            continue
        konfig = WURZEL / "_quarto.yml"
        block = re.search(r"^  render:\n((?:    .*\n|\s*\n)+)", lies(konfig), re.M)
        liste = re.findall(r"^    -\s*(\S+)", block[1], re.M) if block else []
        seite, uebersicht = f"{std['quelle']}/index.qmd", std[schluessel]
        if seite not in liste or uebersicht not in liste:
            b.fehler_(f"render-Liste: {seite} und {uebersicht} müssen beide aufgeführt sein (AP21, AP24)", konfig)
        elif liste.index(uebersicht) < liste.index(seite):
            b.fehler_(f"render-Liste: {uebersicht} liest die Registry von {seite} und muss danach stehen (AP21, AP24)", konfig)

    # 11. Steckbrief: Codes aus dem Vokabular der Raster-Fassung
    if "steckbrief_daten" in std:
        sb = lies_steckbrief(std, b)
        if sb:
            print(f"Steckbrief: Raster {sb['raster']}, {sum(len(v) for v in sb['auswahl'].values())} Codes "
                  f"in {len(sb['auswahl'])} Auswahlen, vorschlag: {str(sb['vorschlag']).lower()}")


def lies_steckbrief(std: dict, b: Befunde) -> dict | None:
    """Angaben aus steckbrief.yml und Vokabular des Rasters (ohne YAML-Bibliothek,
    die Dateien haben einen festen, einfachen Aufbau). Meldet ungültige Codes."""
    pfad = WURZEL / std["steckbrief_daten"]
    if not pfad.exists():
        b.fehler_(f"Steckbrief: {rel(pfad)} fehlt")
        return None
    t = lies(pfad)
    raster = re.search(r'^raster:\s*"([^"]+)"\s*(?:#.*)?$', t, re.M)
    vorschlag = re.search(r"^vorschlag:\s*(true|false)\s*(?:#.*)?$", t, re.M)
    block = re.search(r"^auswahl:\n((?:  .*\n?)+)", t, re.M)
    if not raster or not vorschlag or not block:
        b.fehler_("Steckbrief: `raster`, `vorschlag` oder `auswahl` fehlt oder hat eine unerwartete Form", pfad)
        return None
    auswahl = {m[1]: [c.strip() for c in m[2].split(",") if c.strip()]
               for m in re.finditer(r"^  ([a-z-]+):\s*\[([^\]]*)\]", block[1], re.M)}
    rpfad = WURZEL / std["steckbrief_raster"] / raster[1] / "raster.yml"
    if not rpfad.exists():
        b.fehler_(f"Steckbrief: Raster-Fassung {raster[1]} fehlt ({rel(rpfad)})", pfad)
        return None
    vokabular: dict[str, list[str]] = {}
    feld = None
    im_block = False
    for zeile in lies(rpfad).split("\n"):
        if re.match(r"^auswahlen:\s*$", zeile):
            im_block = True
        elif re.match(r"^\S", zeile):
            im_block = False
        elif im_block and (m := re.match(r"^  ([a-z-]+):\s*$", zeile)):
            feld = m[1]
            vokabular[feld] = []
        elif im_block and feld and (m := re.match(r"^\s+- code: ([a-z0-9-]+)\s*$", zeile)):
            vokabular[feld].append(m[1])
    for f, codes in auswahl.items():
        if f not in vokabular:
            b.fehler_(f"Steckbrief: «{f}» ist im Raster {raster[1]} keine Auswahl", pfad)
            continue
        for c in codes:
            if c not in vokabular[f]:
                b.fehler_(f"Steckbrief: Code «{c}» steht nicht im Vokabular «{f}» des Rasters {raster[1]} "
                          f"(erlaubt: {', '.join(vokabular[f])})", pfad)
    for f in sorted(set(vokabular) - set(auswahl)):
        b.fehler_(f"Steckbrief: Auswahl «{f}» fehlt (leere Liste mit Begründung möglich)", pfad)
    return {"raster": raster[1], "vorschlag": vorschlag[1] == "true", "auswahl": auswahl, "vokabular": vokabular}


def pruefe_steckbrief(std: dict, registry_pfad: Path, b: Befunde) -> None:
    sb = lies_steckbrief(std, b)
    seite, jpfad = WURZEL / std["steckbrief"], WURZEL / std["steckbrief_json"]
    for p in (seite, jpfad):
        if not p.exists():
            b.fehler_(f"Steckbrief fehlt: {rel(p)}")
            return
    try:
        roh = registry_pfad.read_bytes()
        registry = json.loads(roh.decode("utf-8"))
        sj = json.loads(jpfad.read_text(encoding="utf-8"))
    except (OSError, ValueError) as fehler:
        b.fehler_(f"Steckbrief: JSON nicht lesbar: {fehler}", jpfad)
        return
    if sj.get("registry_sha1") != hashlib.sha1(roh).hexdigest():
        b.fehler_("Steckbrief: erzeugt aus einer anderen bausteine.json als der aktuellen (Render-Reihenfolge?)", jpfad)
    t = lies(seite)
    haupt = t[t.find("<main"):t.find("</main>")]
    zeilen = {m[1]: m[0] for m in re.finditer(r'<tr data-feld="([^"]+)" data-herkunft="[^"]+">.*?</tr>', haupt, re.S)}
    herkunft = dict(re.findall(r'<tr data-feld="([^"]+)" data-herkunft="([^"]+)">', haupt))

    # Auswahlen wie in steckbrief.yml
    if sb:
        if sj.get("vorschlag") != sb["vorschlag"]:
            b.fehler_(f"Steckbrief: vorschlag {sj.get('vorschlag')} im JSON, {sb['vorschlag']} in steckbrief.yml", jpfad)
        for f, codes in sb["auswahl"].items():
            z = zeilen.get(f, "")
            ist = re.findall(r'data-code="([^"]+)" data-gewaehlt="ja"', z)
            alle = re.findall(r'data-code="([^"]+)"', z)
            if sorted(ist) != sorted(codes):
                b.fehler_(f"Steckbrief: Auswahl «{f}» zeigt {ist}, steckbrief.yml hat {codes}", seite)
            if alle != sb["vokabular"].get(f, []):
                b.fehler_(f"Steckbrief: Auswahl «{f}» zeigt nicht alle Werte des Rasters in dessen Reihenfolge", seite)

    # Vorschlag gekennzeichnet, solange `vorschlag: true`
    marken = re.findall(r'<p class="steckbrief-vorschlag" data-vorschlag="([^"]+)">', haupt)
    mit_vorschlag = [ab["abschnitt"] for ab in sj.get("abschnitte", [])
                     if any(f.get("herkunft") == "vorschlag" for f in ab.get("felder", []))]
    if sb and sb["vorschlag"]:
        if not mit_vorschlag or sorted(marken) != sorted(mit_vorschlag):
            b.fehler_(f"Steckbrief: Kennzeichnung «Vorschlag» bei {sorted(marken)}, erwartet {sorted(mit_vorschlag)}", seite)
        for f, h in herkunft.items():
            if f in (sb["auswahl"] if sb else {}) and h != "vorschlag":
                b.fehler_(f"Steckbrief: Auswahl «{f}» nicht als Vorschlag gekennzeichnet", seite)
    elif marken or "vorschlag" in herkunft.values() or mit_vorschlag:
        b.fehler_("Steckbrief: Kennzeichnung «Vorschlag», obwohl steckbrief.yml `vorschlag: false` hat", seite)

    # Referenzen auf eCH-Standards = Ziele der Art «standard» in der Registry
    soll = sorted({r["target"] for e in registry["bausteine"] for r in e["relationships"]
                   if r["type"] == "refers_to" and r["target_kind"] == "standard"})
    ist = sorted(re.findall(r'<li data-standard="([^"]+)">', zeilen.get("referenzen-ech", "")))
    if ist != soll or herkunft.get("referenzen-ech") != "registry":
        b.fehler_(f"Steckbrief: Referenzen auf eCH-Standards {ist}, Registry {soll}", seite)

    # Bezüge zu externen Standards = Anhang A ohne eCH-Standards
    alle_ref = re.findall(r"^\s*-\s*schluessel:\s*(\S+)\s*$", lies(WURZEL / std["referenzen"]), re.M)
    soll = [k for k in alle_ref if not k.startswith("eCH-")]
    ist = re.findall(r'<li data-referenz="([^"]+)">', zeilen.get("externe-standards", ""))
    if ist != soll or herkunft.get("externe-standards") != "anhang-a":
        b.fehler_(f"Steckbrief: Bezüge zu externen Standards {ist}, Anhang A ohne eCH-Standards {soll}", seite)

    # Strukturierung deckt die Gliederung ab
    gliederung = registry.get("gliederung", [])
    feine: dict[str, int] = {}
    for e in registry["bausteine"]:
        if e["granularitaet"] == "fein":
            for r in e["relationships"]:
                if r["type"] == "is_part_of":
                    feine[r["target"]] = feine.get(r["target"], 0) + 1
    tab = re.search(r'<table class="table table-sm steckbrief-gliederung" data-registry-sha1="([0-9a-f]+)">(.*?)</table>', haupt, re.S)
    if not tab or tab[1] != hashlib.sha1(roh).hexdigest():
        b.fehler_("Steckbrief: Strukturierung fehlt oder ist aus einer anderen Registry erzeugt", seite)
        return
    reihen = [(m[1], m[2], m[3]) for m in re.finditer(
        r'<tr class="ebene-\d" data-anker="([^"]+)" data-stand="([^"]+)"(?: data-baustein="([^"]+)" data-feine="\d+")?>', tab[2])]
    feine_ist = dict(re.findall(r'data-baustein="([^"]+)" data-feine="(\d+)"', tab[2]))
    grobe = [e["id"] for e in registry["bausteine"] if e["granularitaet"] == "grob"]
    gezeigt = [r[2] for r in reihen if r[2]]
    if sorted(gezeigt) != sorted(grobe):
        b.fehler_(f"Steckbrief: Strukturierung zeigt {len(gezeigt)} grobe Bausteine, Registry {len(grobe)}", seite)
    for bb, n in feine_ist.items():
        if int(n) != feine.get(bb, 0):
            b.fehler_(f"Steckbrief: «{bb}» mit {n} feinen Bausteinen, Registry {feine.get(bb, 0)}", seite)
    ueberfuehrt = {"baustein", "vorlagentext", "statustext", "daten", "text", "verzeichnis"}
    stand_soll = {"baustein": "baustein", "vorlagentext": "vorlagentext", "statustext": "statustext",
                  "daten": "daten", "platzhalter": "nicht-ueberfuehrt", "ohne_text": "gliederung", "text": "text",
                  "verzeichnis": "verzeichnis"}
    i, k = 0, 0
    while i < len(gliederung):
        g = gliederung[i]
        ende = i + 1
        while ende < len(gliederung) and gliederung[ende]["ebene"] > g["ebene"]:
            ende += 1
        if k >= len(reihen) or reihen[k][0] != g["anker"]:
            b.fehler_(f"Steckbrief: Strukturierung ohne Zeile für «{g.get('section')} {g['title']}»", seite)
            break
        stand = reihen[k][1]
        teilbaum_leer = not any(x["inhalt"] in ueberfuehrt for x in gliederung[i:ende])
        teilbaum_text = all(x["inhalt"] in ("text", "ohne_text") for x in gliederung[i:ende]) \
            and any(x["inhalt"] == "text" for x in gliederung[i:ende])
        if stand == "nicht-ueberfuehrt" and teilbaum_leer:
            i = ende   # ganzer Teilbaum in einer Zeile
        elif stand == "text" and teilbaum_text:
            i = ende   # Kapitel nur als Text in einer Zeile (AP26, E54)
        elif teilbaum_text and ende > i + 1:
            b.fehler_(f"Steckbrief: «{g.get('section')} {g['title']}» ist nur als Text überführt, "
                      f"steht aber nicht in einer Zeile «text» (E54)", seite)
            i = ende
        elif stand != stand_soll.get(g["inhalt"]):
            b.fehler_(f"Steckbrief: «{g.get('section')} {g['title']}» als {stand}, Registry {g['inhalt']}", seite)
            i += 1
        else:
            i += 1
        k += 1
    if k != len(reihen):
        b.fehler_(f"Steckbrief: Strukturierung mit {len(reihen) - k} Zeilen ausserhalb der Gliederung", seite)
    print(f"Steckbrief: {len(zeilen)} Felder, {len(marken)}× «Vorschlag, nicht geprüft», "
          f"Strukturierung {len(reihen)} Zeilen mit {len(gezeigt)} groben Bausteinen")


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


def html_abschnitt(t: str, von: str, bis: str | None) -> str:
    """HTML vom Abschnitt `von` bis vor den Abschnitt `bis` oder ans Ende des Inhalts."""
    a = t.index(f'<section id="{von}"')
    e = t.index(f'<section id="{bis}"', a) if bis else t.index("</main>", a)
    return t[a:e]


def html_klartext(ausschnitt: str, ignorieren: set[str]) -> str:
    p = HtmlText(ignorieren)
    p.feed(ausschnitt)
    return norm("".join(p.teile))


def html_kapitel(t: str, von: str, bis: str | None, ignorieren: set[str]) -> str:
    return html_klartext(html_abschnitt(t, von, bis), ignorieren)


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


def docx_bereich(absaetze, von: str, bis: str | None) -> list[str]:
    """Absätze vom Absatz mit der Textmarke `von` bis vor den mit `bis`."""
    a = next(i for i, (_, m) in enumerate(absaetze) if von in m)
    e = next(i for i, (_, m) in enumerate(absaetze) if bis in m and i > a) if bis else len(absaetze)
    return [t for t, _ in absaetze[a:e]]


def docx_kapitel(absaetze, von: str, bis: str | None, ignorieren: tuple[str, ...] = ()) -> str:
    """Text des Bereichs ohne Absätze, die mit einem Text aus `ignorieren`
    beginnen (Hinweise des Demonstrators, AP26)."""
    return norm(" ".join(t for t in docx_bereich(absaetze, von, bis) if not (ignorieren and t.startswith(ignorieren))))


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


def feedback_links(t: str) -> list[tuple[str, str, str, dict]]:
    """(Art, ID, URL, Parameter) je Feedback-Link eines HTML-Ausschnitts."""
    links = []
    for m in FEEDBACK_LINK.finditer(t):
        url = html.unescape(m[3])
        parameter = urllib.parse.parse_qs(urllib.parse.urlsplit(url).query, keep_blank_values=True)
        links.append((m[1], html.unescape(m[2]), url, {k: v[0] for k, v in parameter.items()}))
    return links


def pruefe_feedback(std: dict, t: str, html_pfad: Path, docx_pfad: Path, b: Befunde) -> None:
    links = feedback_links(t)
    ziel = std["feedback_repo"] + "/issues/new?"
    erlaubt = {"template", "title", "standard", "baustein", "stand", "stelle", "wortlaut"}
    laengste = 0
    ids = set(re.findall(r'\sid="([^"]+)"', t))

    # je Fundstelle genau ein Link
    fundstellen: dict[str, int] = {}
    for bb in re.findall(r'<(?:div|section)\b[^>]*\sdata-(?:bb|feedback-id)="([^"]+)"', t):
        fundstellen[bb] = fundstellen.get(bb, 0) + 1
    je_id: dict[str, int] = {}
    for art, wert, _, _ in links:
        if art == "bb":
            je_id[wert] = je_id.get(wert, 0) + 1
    for bb in sorted(set(fundstellen) | set(je_id)):
        if fundstellen.get(bb, 0) != je_id.get(bb, 0):
            b.fehler_(f"HTML: «{bb}» hat {fundstellen.get(bb, 0)} Fundstellen, aber {je_id.get(bb, 0)} Feedback-Links (E39)", html_pfad)
    if sum(1 for art, *_ in links if art == "standard") != 1:
        b.fehler_("HTML: Es braucht genau einen Knopf «Feedback zum Standard» (E39)", html_pfad)

    # jeder Link
    for art, wert, url, p in links:
        laengste = max(laengste, len(url))
        name = wert or "Standard"
        if not url.startswith(ziel) or p.get("template") != "feedback.yml":
            b.fehler_(f"HTML: Feedback-Link zu «{name}» führt nicht aufs Formular: {url[:80]}", html_pfad)
        if "labels" in p or "labels=" in url:
            b.fehler_(f"HTML: Feedback-Link zu «{name}» setzt Labels in der URL (404 ohne Berechtigung, E37)", html_pfad)
        if set(p) - erlaubt:
            b.fehler_(f"HTML: Feedback-Link zu «{name}» mit unbekannten Parametern {sorted(set(p) - erlaubt)}", html_pfad)
        if len(url) > URL_MAX:
            b.fehler_(f"HTML: Feedback-Link zu «{name}» ist {len(url)} Zeichen lang (höchstens {URL_MAX}, E37)", html_pfad)
        if art == "bb":
            if p.get("baustein") != wert:
                b.fehler_(f"HTML: Feedback-Link zu «{wert}» nennt die ID «{p.get('baustein')}»", html_pfad)
            if not p.get("title", "").endswith(f"({wert})"):
                b.fehler_(f"HTML: Titel des Feedback-Links zu «{wert}» ohne ID: «{p.get('title')}»", html_pfad)
            anker = urllib.parse.urlsplit(p.get("stelle", "")).fragment
            if anker not in ids:
                b.fehler_(f"HTML: Link zur Stelle von «{wert}» führt auf den fehlenden Anker «{anker}»", html_pfad)
        elif "baustein" in p:
            b.fehler_("HTML: Der Knopf zum Standard darf keine Baustein-ID mitgeben (E38)", html_pfad)

    # Wortlaut und Ausnahme vom Textvergleich je überführtem Kapitel
    ignorieren = set(std.get("html_ignorieren", []))
    for kap in std.get("kapitel", []):
        try:
            ausschnitt = html_abschnitt(t, kap["von"], kap.get("bis"))
        except ValueError:
            continue   # meldet der Textvergleich
        mit, ohne = html_klartext(ausschnitt, ignorieren), html_klartext(ausschnitt, set())
        if 'class="platzhalter-hinweis"' in ausschnitt:
            b.fehler_(f"{kap['name']}: überführt, enthält aber noch einen Platzhalter (E05)", html_pfad)
        if kap.get("nur_text"):
            if "data-bb=" in ausschnitt:
                b.fehler_(f"{kap['name']}: Text ohne Bausteine enthält einen Baustein (E54)", html_pfad)
            n = ausschnitt.count('class="nur-text-hinweis"')
            if n != 1:
                b.fehler_(f"{kap['name']}: Hinweis «Text überführt, noch nicht in Bausteine zerlegt» "
                          f"{n}× auf der Website, erwartet einmal (E54)", html_pfad)
            if 'data-feedback-id="' not in ausschnitt:
                b.fehler_(f"{kap['name']}: Text ohne Bausteine ohne feedback-id am Kapitel (E54)", html_pfad)
        if kap.get("vorlagentext"):
            if "data-bb=" in ausschnitt or "baustein-feedback" in ausschnitt:
                b.fehler_(f"{kap['name']}: Ein Vorlagentext ist kein Baustein und hat kein Feedback (E13)", html_pfad)
            if "Vorlagentext, zentral gepflegt" not in ohne:
                b.fehler_(f"{kap['name']}: Hinweis «Vorlagentext, zentral gepflegt …» fehlt auf der Website (E13)", html_pfad)
        elif "baustein-feedback" not in ausschnitt:
            b.fehler_(f"{kap['name']}: keine Bedienelemente im HTML; die Ausnahme vom Textvergleich prüft nichts", html_pfad)
        if std["id_praefix"] in mit or "Alle Rückmeldungen" in mit or "Vorlagentext, zentral" in mit \
                or "noch nicht in Bausteine zerlegt" in mit:
            b.fehler_(f"{kap['name']}: Bedienelemente stehen im Klartext (html_ignorieren)", html_pfad)
        soll = rohtext(WURZEL / kap["rohtext"], None)
        for art, wert, _, p in feedback_links(ausschnitt):
            text = p.get("wortlaut")
            if text is None:
                continue
            gekuerzt = text.endswith(" …")
            if len(text) > WORTLAUT_MAX + 2:
                b.fehler_(f"HTML: Wortlaut von «{wert}» hat {len(text)} Zeichen (höchstens {WORTLAUT_MAX}, E37)", html_pfad)
            zeilen = [z[2:] if z.startswith("- ") else z for z in (text[:-2] if gekuerzt else text).split("\n")]
            if norm("\n".join(zeilen)) not in soll:
                b.fehler_(f"HTML: Wortlaut von «{wert}» weicht vom Rohtext ab (E19)", html_pfad)

    # Im Word gibt es kein Feedback
    with zipfile.ZipFile(docx_pfad) as z:
        for teil in ("word/document.xml", "word/_rels/document.xml.rels"):
            xml = z.read(teil).decode("utf-8")
            if "/issues/new" in xml or "Alle Rückmeldungen" in xml or "baustein-feedback" in xml:
                b.fehler_(f"Word: Feedback-Link in {teil} (E39)", docx_pfad)
    print(f"Feedback: {len(links)} Links, {sum(fundstellen.values())} Fundstellen, längste URL {laengste} Zeichen")


def lies_quelle(std: dict) -> list["Baustein"]:
    """Bausteine der Quelle, ohne Meldungen (die gibt die Phase «quelle»)."""
    quelle = WURZEL / std["quelle"]
    kennz = re.compile(r"^\[(" + "|".join(re.escape(k) for k in std["kennzeichnungen"]) + r")\]")
    bausteine: list[Baustein] = []
    for datei in [quelle / "index.qmd"] + sorted((quelle / "bausteine").rglob("*.md")) + sorted((quelle / "text").glob("*.md")):
        zerlege(datei, lies(datei), bausteine, kennz, Befunde(still=True))
    return bausteine


UMKEHRUNG = {"is_part_of": "has_part", "has_part": "is_part_of", "refers_to": "is_referenced_by",
             "is_referenced_by": "refers_to", "depends_on": "is_required_by", "is_required_by": "depends_on"}


def pruefe_registry(std: dict, t: str, b: Befunde) -> None:
    pfad = WURZEL / std["registry"]
    if not pfad.exists():
        b.fehler_(f"Registry fehlt: {rel(pfad)} (E09)")
        return
    try:
        registry = json.loads(pfad.read_text(encoding="utf-8"))
    except json.JSONDecodeError as fehler:
        b.fehler_(f"Registry ist kein gültiges JSON: {fehler}", pfad)
        return
    eintraege = {e["id"]: e for e in registry.get("bausteine", [])}
    quelle = lies_quelle(std)
    kennz = re.compile(r"^\[(" + "|".join(re.escape(k) for k in std["kennzeichnungen"]) + r")\]")
    soll: dict[str, Baustein] = {}
    for x in quelle:
        if x.art != "inline":
            soll.setdefault(x.bb, x)
    for bb in sorted(set(soll) - set(eintraege)):
        b.fehler_(f"Registry: Baustein «{bb}» aus der Quelle fehlt", pfad)
    for bb in sorted(set(eintraege) - set(soll)):
        b.fehler_(f"Registry: «{bb}» steht nicht in der Quelle", pfad)
    anzahl = {"grob": sum(1 for x in soll.values() if x.art == "grob"), "fein": sum(1 for x in soll.values() if x.art == "fein")}
    if registry.get("anzahl") != anzahl:
        b.fehler_(f"Registry: Anzahl {registry.get('anzahl')}, in der Quelle {anzahl}", pfad)

    literatur = set(re.findall(r"^\s*-\s*schluessel:\s*(\S+)\s*$", lies(WURZEL / std["referenzen"]), re.M))
    ids_html = set(re.findall(r'\sid="([^"]+)"', t))
    bb_anker = set(re.findall(r'<section id="([^"]+)"[^>]*\sdata-bb="', t))
    platzhalter = set(re.findall(r'<section id="([^"]+)" class="[^"]*\bplatzhalter\b', t))
    nur_text = set(re.findall(r'<section id="([^"]+)" class="[^"]*\bnur-text\b(?!-)', t))

    def abschnitt(anker: str) -> str:
        """HTML vom Abschnitt mit dem Anker bis zum nächsten Abschnitt."""
        m = re.search(rf'<section id="{re.escape(anker)}"', t)
        if not m:
            return ""
        ende = t.find("<section ", m.end())
        return t[m.end():ende if ende >= 0 else len(t)]
    vorlage_merkmal = {"vorlagentext": 'class="vorlagentext-hinweis', "statustext": '<span class="statustext">'}
    for bb, e in eintraege.items():
        x = soll.get(bb)
        if x is None:
            continue
        if e.get("granularitaet") != x.art or e.get("building_block_type") != x.attr.get("typ"):
            b.fehler_(f"Registry: «{bb}» mit Granularität/Typ {e.get('granularitaet')}/{e.get('building_block_type')}, Quelle {x.art}/{x.attr.get('typ')}", pfad)
        fund, seiten = e.get("source_reference") or [], (e.get("herkunft") or {}).get("seite", [])
        if not fund or not all(f.get("title") for f in fund):
            b.fehler_(f"Registry: «{bb}» ohne Fundstelle", pfad)
        if "herkunft" in e and len(seiten) not in (1, len(fund)):
            b.fehler_(f"Registry: «{bb}» hat {len(fund)} Fundstellen, aber {len(seiten)} Seiten (F43)", pfad)
        if x.art == "fein":
            k = next((m[1] for a in x.absaetze if (m := kennz.match(a))), None)
            if e.get("kennzeichnung") != k:
                b.fehler_(f"Registry: «{bb}» mit Kennzeichnung {e.get('kennzeichnung')}, Quelle {k} (V1)", pfad)
        bezug = sorted(x.attr.get("bezug", "").split())
        depends = sorted(r["target"] for r in e.get("relationships", []) if r["type"] == "depends_on")
        if bezug != depends:
            b.fehler_(f"Registry: depends_on von «{bb}» {depends}, bezug in der Quelle {bezug} (E30)", pfad)
        paare = {(r["type"], r["target"]) for r in e.get("relationships", [])}
        for r in e.get("relationships", []):
            typ, ziel, art = r.get("type"), r.get("target"), r.get("target_kind")
            if ziel == bb:
                b.fehler_(f"Registry: Selbstverweis bei «{bb}» (W5)", pfad)
            if art == "baustein":
                if ziel not in eintraege:
                    b.fehler_(f"Registry: «{bb}» {typ} «{ziel}», den es nicht gibt", pfad)
                elif typ in UMKEHRUNG and (UMKEHRUNG[typ], bb) not in {(q["type"], q["target"]) for q in eintraege[ziel].get("relationships", [])}:
                    b.fehler_(f"Registry: Umkehrung fehlt: «{ziel}» hat kein {UMKEHRUNG[typ]} «{bb}» (W4)", pfad)
            elif typ != "refers_to":
                b.fehler_(f"Registry: «{bb}» {typ} auf ein Ziel ohne Baustein ({art})", pfad)
            elif art == "noch_kein_baustein":
                if ziel not in ids_html or ziel in bb_anker:
                    b.fehler_(f"Registry: «{bb}» verweist auf «{ziel}», der kein Anker einer Überschrift ohne Baustein ist (W2)", pfad)
                elif ziel not in platzhalter | nur_text:
                    b.fehler_(f"Registry: «{bb}» verweist auf «{ziel}» als «noch kein Baustein», aber dort steht "
                              f"weder ein Platzhalter noch Text ohne Bausteine (E50, E54)", pfad)
            elif art in vorlage_merkmal:
                if ziel not in ids_html or ziel in bb_anker or vorlage_merkmal[art] not in abschnitt(ziel):
                    b.fehler_(f"Registry: «{bb}» verweist auf «{ziel}» als {art}, aber der Abschnitt enthält keinen (E50)", pfad)
            elif art == "literatur":
                if ziel not in literatur:
                    b.fehler_(f"Registry: «{bb}» zitiert «{ziel}», das in referenzen.yml fehlt", pfad)
            elif art == "standard":
                if not re.fullmatch(r"eCH-\d{4}", ziel or ""):
                    b.fehler_(f"Registry: «{bb}» verweist auf den Standard «{ziel}» (W3)", pfad)
            else:
                b.fehler_(f"Registry: «{bb}» mit unbekannter Zielart «{art}»", pfad)
        if ("is_part_of", bb) in paare:
            b.fehler_(f"Registry: «{bb}» ist Teil von sich selbst", pfad)
    # Gliederung (AP24): jede Überschrift des Inhaltsverzeichnisses, gleiche
    # Nummer, Titel und Ebene; «ohne_text» genau dort, wo das Original keinen
    # eigenen Text hat; Bausteine mit ihrer Überschrift
    toc = [z.split("\t") for z in lies(WURZEL / std["inhaltsverzeichnis"]).split("\n")[1:] if z.strip()]
    gliederung = registry.get("gliederung", [])
    if len(gliederung) != len(toc):
        b.fehler_(f"Registry: Gliederung mit {len(gliederung)} Überschriften, Inhaltsverzeichnis {len(toc)}", pfad)
    for g, (ebene, nr, titel, _, eigen) in zip(gliederung, toc):
        if (g.get("section"), g.get("title"), g.get("ebene")) != (nr, titel, int(ebene)):
            b.fehler_(f"Registry: Gliederung «{g.get('section')} {g.get('title')}» (Ebene {g.get('ebene')}), "
                      f"Inhaltsverzeichnis «{nr} {titel}» (Ebene {ebene})", pfad)
        if (g.get("inhalt") == "ohne_text") != (eigen == "nein"):
            b.fehler_(f"Registry: «{nr} {titel}» als {g.get('inhalt')}, eigener Text im Original: {eigen}", pfad)
        if (g.get("inhalt") == "text") != (g.get("anker") in nur_text):
            b.fehler_(f"Registry: Gliederung «{nr} {titel}» als {g.get('inhalt')}, Überschrift "
                      f"{'mit' if g.get('anker') in nur_text else 'ohne'} `.nur-text` (E54)", pfad)
        if (g.get("inhalt") == "baustein") != bool(g.get("baustein")) or \
                (g.get("baustein") and eintraege.get(g["baustein"], {}).get("granularitaet") != "grob"):
            b.fehler_(f"Registry: Gliederung «{nr} {titel}» mit Baustein «{g.get('baustein')}», kein grober Baustein", pfad)
    arten: dict[str, int] = {}
    for g in gliederung:
        arten[g.get("inhalt")] = arten.get(g.get("inhalt"), 0) + 1
    print(f"Registry: {anzahl['grob']} grobe, {anzahl['fein']} feine Bausteine, "
          f"{sum(len(e.get('relationships', [])) for e in eintraege.values())} Beziehungen, "
          f"Gliederung {len(gliederung)} Überschriften ({', '.join(f'{k} {v}' for k, v in sorted(arten.items()))})")


SICHTBAR = ("refers_to", "is_referenced_by", "depends_on", "is_required_by")   # ohne Einbettung
VORWAERTS = ("refers_to", "depends_on")
KNOTEN = re.compile(r'^\s*(n\d+)\W*"([^"]*)"\W*:::(\w+)\s*$', re.M)
PFEIL = re.compile(r"^\s*(n\d+) (<?)(-->|-\.->)(\|\d+\|)? (n\d+)\s*$", re.M)


def grobe_von(e: dict, eintraege: dict) -> list[dict]:
    """Grobe Bausteine, zu denen ein Baustein gehört (sich selbst, wenn er grob ist)."""
    if e["granularitaet"] == "grob":
        return [e]
    return [eintraege[r["target"]] for r in e["relationships"] if r["type"] == "is_part_of" and r["target"] in eintraege]


def im_anhang(e: dict) -> bool:
    return (e["source_reference"][0].get("section") or "").startswith("Anhang ")
DETAILS = re.compile(r'<details class="baustein-beziehungen" data-beziehungen="([^"]+)" data-anzahl="(\d+)">'
                     r"<summary>Beziehungen \((\d+)\)</summary>(.*?)</details>", re.S)


def links_ok(von: Path, ausschnitt: str, b: Befunde, was: str) -> int:
    """Interne Links eines HTML-Ausschnitts: Datei und Anker vorhanden. Gibt die Anzahl zurück."""
    n = 0
    for href in sorted(set(re.findall(r'<a [^>]*href="([^"]+)"', ausschnitt))):
        u = urllib.parse.urlsplit(html.unescape(href))
        if u.scheme or u.netloc:   # extern (http, mailto, …)
            continue
        n += 1
        ziel = (von.parent / urllib.parse.unquote(u.path)).resolve() if u.path else von
        if not ziel.exists():
            b.fehler_(f"{was}: Link auf fehlende Datei «{href}»", von)
        elif u.fragment and ziel.suffix == ".html" and f'id="{u.fragment}"' not in lies(ziel):
            b.fehler_(f"{was}: Link auf fehlenden Anker «{href}»", von)
    return n


def pruefe_beziehungen(std: dict, t: str, html_pfad: Path, docx_pfad: Path, b: Befunde) -> None:
    pfad = WURZEL / std["registry"]
    try:
        roh = pfad.read_bytes()
        registry = json.loads(roh.decode("utf-8"))
    except (OSError, ValueError):
        return   # meldet pruefe_registry
    soll: dict[str, tuple[int, int]] = {}   # ID -> (n, Fundstellen)
    for e in registry["bausteine"]:
        n = sum(1 for r in e["relationships"] if r["type"] in SICHTBAR)
        if n:
            soll[e["id"]] = (n, len(e["source_reference"]))

    # Standardseite: «Beziehungen (n)» je Baustein und Fundstelle
    ist: dict[str, int] = {}
    for m in DETAILS.finditer(t):
        bb, anzahl, summary, inhalt = m[1], int(m[2]), int(m[3]), m[4]
        ist[bb] = ist.get(bb, 0) + 1
        n = soll.get(bb, (0, 0))[0]
        eintraege = len(re.findall(r"<li\b", inhalt))
        if not (anzahl == summary == eintraege == n):
            b.fehler_(f"HTML: «Beziehungen ({summary})» bei «{bb}» mit {eintraege} Einträgen, Registry {n}", html_pfad)
    for bb in sorted(set(soll) | set(ist)):
        erwartet = soll.get(bb, (0, 0))[1]
        if ist.get(bb, 0) != erwartet:
            b.fehler_(f"HTML: «{bb}» hat {ist.get(bb, 0)}× «Beziehungen», erwartet {erwartet} (je Fundstelle)", html_pfad)
    if t.count('<details class="baustein-beziehungen"') != sum(ist.values()):
        b.fehler_("HTML: «Beziehungen» mit unerwartetem Aufbau", html_pfad)
    seite = HtmlText(set(std.get("html_ignorieren", [])))
    seite.feed(t)
    if re.search(r"Beziehungen \(\d+\)", "".join(seite.teile)):
        b.fehler_("HTML: «Beziehungen (n)» steht im Klartext (html_ignorieren)", html_pfad)
    n_links = links_ok(html_pfad, "".join(m[0] for m in DETAILS.finditer(t)), b, "HTML, Beziehungen")
    with zipfile.ZipFile(docx_pfad) as z:
        xml = z.read("word/document.xml").decode("utf-8")
        if re.search(r"Beziehungen \(\d+\)", xml) or "baustein-beziehungen" in xml:
            b.fehler_("Word: «Beziehungen» gehören nur auf die Website (E47)", docx_pfad)

    # Übersichtsseite
    uebersicht = WURZEL / std["beziehungen"]
    if not uebersicht.exists():
        b.fehler_(f"Übersicht fehlt: {rel(uebersicht)}")
        return
    u = lies(uebersicht)
    haupt = u[u.find("<main"):u.find("</main>")]
    graph = re.search(r'<pre class="mermaid mermaid-js"[^>]*>(.*?)</pre>', haupt, re.S)
    graph_text = html.unescape(graph[1]) if graph else ""
    if not graph_text.lstrip().startswith("flowchart") or "-->" not in graph_text or "platzhalter" in graph_text:
        b.fehler_("Übersicht: Graph fehlt oder ist der Platzhalter", uebersicht)
    alle = {e["id"]: e for e in registry["bausteine"]}
    for e in registry["bausteine"]:
        if all(im_anhang(g) for g in grobe_von(e, alle)):
            continue   # Verweise aus Anhängen nur in der Tabelle (F56)
        for r in e["relationships"]:
            if r["type"] in VORWAERTS and r["target_kind"] != "baustein" and r["target"] not in graph_text \
                    and (r.get("title") or "") not in graph_text:
                b.fehler_(f"Übersicht: Ziel «{r['target']}» ({r['target_kind']}) fehlt im Graph", uebersicht)
    knoten = {m[1]: (m[2], m[3]) for m in KNOTEN.finditer(graph_text)}
    pfeile = list(PFEIL.finditer(graph_text))
    verwendet = {k for _, k in knoten.values()}
    for p in pfeile:
        von, doppelt, art, anzahl, nach = p[1], p[2], p[3], p[4], p[5]
        verwendet |= {"refers_to" if art == "-->" else "depends_on"} | ({"doppelt"} if doppelt else set()) \
            | ({"anzahl"} if anzahl else set())
        if von not in knoten or nach not in knoten:
            b.fehler_(f"Übersicht: Pfeil «{p[0].strip()}» mit unbekanntem Knoten", uebersicht)
        elif knoten[von][0].startswith("Anhang ") or (doppelt and knoten[nach][0].startswith("Anhang ")):
            b.fehler_(f"Übersicht: Pfeil aus einem Anhang im Graph: {knoten[von][0]} (F56)", uebersicht)
    n_pfeile = sum(1 for z in graph_text.split("\n") if re.search(r"--|-\.-", z))
    if n_pfeile != len(pfeile):
        b.fehler_(f"Übersicht: {n_pfeile} Pfeilzeilen im Graph, {len(pfeile)} lesbar", uebersicht)
    legende = re.findall(r'<li data-legende="([^"]+)">', haupt)
    if sorted(legende) != sorted(verwendet):
        b.fehler_(f"Übersicht: Legende {sorted(legende)}, im Graph {sorted(verwendet)}", uebersicht)
    zeilen = re.findall(r'<tr data-von="([^"]+)" data-typ="([^"]+)" data-nach="([^"]+)">', haupt)
    vorwaerts = [(e["id"], r["type"], r["target"]) for e in registry["bausteine"] for r in e["relationships"]
                 if r["type"] in VORWAERTS]
    if sorted(html.unescape(x) for z in zeilen for x in [" ".join(z)]) != sorted(" ".join(v) for v in vorwaerts):
        b.fehler_(f"Übersicht: {len(zeilen)} Tabellenzeilen, Registry {len(vorwaerts)} Vorwärtsbeziehungen "
                  f"oder andere Paare", uebersicht)
    summe = re.search(r'data-registry-sha1="([0-9a-f]+)"', haupt)
    if not summe or summe[1] != hashlib.sha1(roh).hexdigest():
        b.fehler_("Übersicht: erzeugt aus einer anderen bausteine.json als der aktuellen (Render-Reihenfolge?)", uebersicht)
    n_links += links_ok(uebersicht, haupt, b, "Übersicht")
    print(f"Beziehungen: {sum(ist.values())}× «Beziehungen (n)» bei {len(soll)} Bausteinen, "
          f"{len(zeilen)} Tabellenzeilen, Graph {len(knoten)} Knoten und {len(pfeile)} Pfeile, "
          f"Legende {len(legende)} Einträge, {n_links} interne Links")


def pruefe_abbildungsverzeichnis(std: dict, t: str, html_pfad: Path, docx_pfad: Path, b: Befunde) -> None:
    soll = std["abbildungsverzeichnis"]
    # Bildunterschriften der Website in Reihenfolge
    unterschriften = [(m[1], norm(html_klartext(m[2], set())))
                      for m in re.finditer(r'<div id="(fig-[^"]+)" class="quarto-float.*?<figcaption[^>]*>(.*?)</figcaption>', t, re.S)]
    if [u for _, u in unterschriften] != soll:
        b.fehler_(f"Abbildungen: Bildunterschriften {[u for _, u in unterschriften]}, Anhang E im Original {soll}", html_pfad)
    # Website: Liste unter Anhang E
    m = re.search(r'<section id="sec-abbildungsverzeichnis"[^>]*>(.*?)</section>', t, re.S)
    liste = re.search(r'<div class="abbildungsverzeichnis">(.*?)</div>', m[1], re.S) if m else None
    if not liste:
        b.fehler_("Anhang E: Abbildungsverzeichnis fehlt auf der Website (AP26)", html_pfad)
    else:
        eintraege = [(a, norm(html_klartext(x, set()))) for a, x in re.findall(r'<li><a href="#([^"]+)"[^>]*>(.*?)</a></li>', liste[1], re.S)]
        if eintraege != [(i, u) for i, u in unterschriften]:
            b.fehler_(f"Anhang E: Einträge {eintraege} statt der Abbildungen {unterschriften}", html_pfad)
    # Word: Formatvorlage und PAGEREF je Eintrag
    with zipfile.ZipFile(docx_pfad) as z:
        xml = z.read("word/document.xml").decode("utf-8")
        stile = z.read("word/styles.xml").decode("utf-8")
    stil = re.search(r'<w:style [^>]*w:styleId="([^"]+)"[^>]*>\s*<w:name w:val="table of figures"', stile)
    absaetze = [p for p in re.findall(r"<w:p[ >].*?</w:p>", xml, re.S)
                if stil and f'<w:pStyle w:val="{stil[1]}"' in p]
    word = []
    for p in absaetze:
        vor_tab = p.split("<w:tab/>")[0]
        text = html.unescape("".join(re.findall(r"<w:t(?: [^>]*)?>([^<]*)</w:t>", vor_tab)))
        ziel = re.search(r"PAGEREF (\S+) \\h", p)
        word.append((ziel[1] if ziel else None, norm(text)))
    marken = set(re.findall(r'<w:bookmarkStart\b[^>]*w:name="([^"]+)"', xml))
    if word != [(i, u) for i, u in unterschriften]:
        b.fehler_(f"Anhang E, Word: Einträge {word} statt der Abbildungen {unterschriften}", docx_pfad)
    for ziel, _ in word:
        if ziel not in marken:
            b.fehler_(f"Anhang E, Word: PAGEREF auf die fehlende Textmarke «{ziel}»", docx_pfad)
    print(f"Anhang E: {len(unterschriften)} Abbildungen, Website {len(eintraege) if liste else 0} Einträge, "
          f"Word {len(word)} Einträge mit PAGEREF")


def pruefe_ausgabe(std: dict, log: Path | None, b: Befunde) -> None:
    html_pfad, docx_pfad = WURZEL / std["html"], WURZEL / std["docx"]
    for pfad in (html_pfad, docx_pfad):
        if not pfad.exists():
            b.fehler_(f"Ausgabe fehlt, erst `quarto render`: {rel(pfad)}")
            return
    html_roh = lies(html_pfad)
    absaetze = docx_absaetze(docx_pfad)
    ignorieren = set(std.get("html_ignorieren", []))
    docx_ignorieren = tuple(std.get("docx_ignorieren", []))
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
            ohne_farben = re.sub(r"\x1b\[[0-9;]*m", "", zeile).strip()
            if "Unable to resolve crossref" in zeile:
                b.fehler_(f"Quarto: {ohne_farben} (K3)", log, nr)
            elif re.match(r"(ERROR|FATAL)\b", ohne_farben):
                b.fehler_(f"Quarto: {ohne_farben[:300]} (E48)", log, nr)
            elif re.match(r"\[?WARN(ING)?\b", ohne_farben):
                b.hinweis(f"Quarto: {ohne_farben[:300]}", log, nr)

    # 4. Anker = Baustein-ID auf der Website, genau einmal (R6, E27)
    ids = re.findall(r'\sid="([^"]+)"', html_roh)
    for bb in sorted(set(re.findall(r'data-bb="([^"]+)"', html_roh))):
        n = ids.count(bb)
        if n != 1:
            b.fehler_(f"HTML: Baustein «{bb}» hat {n} Anker #{bb}, erwartet genau einen (R6)", html_pfad)

    pruefe_feedback(std, html_roh, html_pfad, docx_pfad, b)
    pruefe_registry(std, html_roh, b)
    if "beziehungen" in std:
        pruefe_beziehungen(std, html_roh, html_pfad, docx_pfad, b)
    if "steckbrief" in std:
        pruefe_steckbrief(std, WURZEL / std["registry"], b)
    if "abbildungsverzeichnis" in std:
        pruefe_abbildungsverzeichnis(std, html_roh, html_pfad, docx_pfad, b)

    # 8. interne Links aller Seiten der Website
    seiten = sorted((WURZEL / "_site").rglob("*.html"))
    n_links = sum(links_ok(s, lies(s), b, f"HTML {rel(s)}") for s in seiten)
    print(f"Interne Links: {n_links} auf {len(seiten)} Seiten geprüft")

    # 1.–2. je überführtem Kapitel
    for kap in std.get("kapitel", []):
        quelle = WURZEL / kap["rohtext"]
        try:
            h = html_kapitel(html_roh, kap["von"], kap.get("bis"), ignorieren)
        except ValueError:
            b.fehler_(f"{kap['name']}: Abschnitt #{kap['von']} … #{kap.get('bis')} im HTML nicht gefunden", html_pfad)
            continue
        try:
            d = docx_kapitel(absaetze, kap["von"], kap.get("bis"), docx_ignorieren)
            if kap.get("nur_text"):
                n = sum(1 for t in docx_bereich(absaetze, kap["von"], kap.get("bis"))
                        if docx_ignorieren and t.startswith(docx_ignorieren))
                if n != 1:
                    b.fehler_(f"{kap['name']}, Word: Hinweis «Text überführt, noch nicht in Bausteine zerlegt» {n}×, "
                              f"erwartet einmal (E54)", docx_pfad)
        except StopIteration:
            b.fehler_(f"{kap['name']}: Textmarken {kap['von']} … {kap.get('bis')} im Word nicht gefunden", docx_pfad)
            continue
        vergleiche(f"{kap['name']}, HTML", h, rohtext(quelle, None), quelle, b)
        vergleiche(f"{kap['name']}, Word", d, rohtext(quelle, ueberschriften), quelle, b)
        for name, text in (("HTML", h), ("Word", d)):
            if "zaehlung" not in kap:
                continue
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
