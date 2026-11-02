"""Hilfsskript fuer die Spikes: DOCX inspizieren (Styles, Nummerierung, Ueberschriften, Bookmarks, Links, Felder).

Aufruf:  py -I tools/docx_inspect.py <datei.docx> [styles|numbering|headings|body|bookmarks|links|fields|text|all]
"""
import re
import sys
import zipfile

W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def read(z, name):
    try:
        return z.read(name).decode("utf-8")
    except KeyError:
        return ""


def styles(z):
    xml = read(z, "word/styles.xml")
    print("== Formatvorlagen mit Heading/Ueberschrift/Titel/Anhang (styleId, name, basedOn, numPr) ==")
    for m in re.finditer(r'<w:style\b[^>]*w:styleId="([^"]+)"[^>]*>(.*?)</w:style>', xml, re.S):
        sid, body = m.group(1), m.group(2)
        name = re.search(r'<w:name w:val="([^"]+)"', body)
        name = name.group(1) if name else ""
        if not re.search(r"heading|berschrift|title|titel|anhang|appendix|toc|verzeichnis", sid + " " + name, re.I):
            continue
        based = re.search(r'<w:basedOn w:val="([^"]+)"', body)
        numpr = re.search(r"<w:numPr>(.*?)</w:numPr>", body, re.S)
        outl = re.search(r'<w:outlineLvl w:val="(\d+)"', body)
        print(f"  {sid!r:30} name={name!r:28} basedOn={based.group(1) if based else '-':14} "
              f"outline={outl.group(1) if outl else '-'} numPr={numpr.group(1) if numpr else '-'}")


def numbering(z):
    xml = read(z, "word/numbering.xml")
    if not xml:
        print("(keine numbering.xml)")
        return
    print("== abstractNum mit pStyle-Bindung ==")
    for m in re.finditer(r'<w:abstractNum\b[^>]*w:abstractNumId="(\d+)"[^>]*>(.*?)</w:abstractNum>', xml, re.S):
        aid, body = m.group(1), m.group(2)
        lvls = re.findall(r'<w:lvl w:ilvl="(\d)"[^>]*>(.*?)</w:lvl>', body, re.S)
        bound = []
        for ilvl, lb in lvls:
            ps = re.search(r'<w:pStyle w:val="([^"]+)"', lb)
            fmt = re.search(r'<w:numFmt w:val="([^"]+)"', lb)
            txt = re.search(r'<w:lvlText w:val="([^"]*)"', lb)
            if ps:
                bound.append(f"ilvl{ilvl}:{ps.group(1)} fmt={fmt.group(1) if fmt else '?'} text={txt.group(1) if txt else '?'}")
        if bound:
            print(f"  abstractNum {aid}: " + "; ".join(bound))
    print("== num -> abstractNum ==")
    for m in re.finditer(r'<w:num w:numId="(\d+)"[^>]*>.*?<w:abstractNumId w:val="(\d+)"', xml, re.S):
        print(f"  num {m.group(1)} -> abstract {m.group(2)}")


def paragraphs(z):
    xml = read(z, "word/document.xml")
    for p in re.finditer(r"<w:p\b.*?</w:p>", xml, re.S):
        px = p.group(0)
        st = re.search(r'<w:pStyle w:val="([^"]+)"', px)
        text = "".join(re.findall(r"<w:t(?:\s[^>]*)?>([^<]*)</w:t>", px))
        yield (st.group(1) if st else ""), text, px


def headings(z):
    print("== Absaetze mit Heading-/Titel-Style ==")
    for st, text, px in paragraphs(z):
        if re.search(r"heading|berschrift|title|titel|subtitle|anhang", st, re.I):
            numpr = "numPr" if "<w:numPr>" in px else ""
            bms = re.findall(r'w:bookmarkStart [^>]*w:name="([^"]+)"', px)
            print(f"  [{st}] {text!r} {numpr} bookmarks={bms}")


def body(z, limit=60):
    print(f"== Erste {limit} Absaetze (Style | Text) ==")
    for i, (st, text, px) in enumerate(paragraphs(z)):
        if i >= limit:
            break
        print(f"  {i:3} [{st}] {text[:110]!r}")


def bookmarks(z):
    xml = read(z, "word/document.xml")
    print("== Bookmarks ==")
    for name in re.findall(r'<w:bookmarkStart [^>]*w:name="([^"]+)"', xml):
        print("  ", name)


def links(z):
    xml = read(z, "word/document.xml")
    rels = read(z, "word/_rels/document.xml.rels")
    relmap = dict(re.findall(r'Id="([^"]+)"[^>]*Target="([^"]+)"', rels))
    print("== Hyperlinks (anchor/r:id -> Text) ==")
    for m in re.finditer(r"<w:hyperlink\b([^>]*)>(.*?)</w:hyperlink>", xml, re.S):
        attrs, inner = m.group(1), m.group(2)
        a = re.search(r'w:anchor="([^"]+)"', attrs)
        r = re.search(r'r:id="([^"]+)"', attrs)
        txt = "".join(re.findall(r"<w:t(?:\s[^>]*)?>([^<]*)</w:t>", inner))
        tgt = ("#" + a.group(1)) if a else relmap.get(r.group(1), r.group(1)) if r else "?"
        print(f"   {txt!r} -> {tgt}")


def fields(z):
    xml = read(z, "word/document.xml")
    print("== Feldfunktionen (instrText / fldSimple) ==")
    for t in re.findall(r"<w:instrText[^>]*>([^<]*)</w:instrText>", xml):
        print("   instr:", t.strip())
    for t in re.findall(r'<w:fldSimple w:instr="([^"]*)"', xml):
        print("   fldSimple:", t.strip())


def text(z):
    for st, t, px in paragraphs(z):
        if t.strip():
            print(f"[{st}] {t}")


def main():
    path = sys.argv[1]
    what = sys.argv[2] if len(sys.argv) > 2 else "all"
    with zipfile.ZipFile(path) as z:
        funcs = {"styles": styles, "numbering": numbering, "headings": headings, "body": body,
                 "bookmarks": bookmarks, "links": links, "fields": fields, "text": text}
        if what == "all":
            for k in ["styles", "numbering", "headings", "fields"]:
                funcs[k](z)
        else:
            funcs[what](z)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    main()
