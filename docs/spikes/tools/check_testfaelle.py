"""Vergleicht die Testfaelle (Listeneintraege «Tn `quelle`: ergebnis = soll») in HTML und DOCX.

Aufruf: py -I tools/check_testfaelle.py <datei.html|datei.docx> [...]
"""
import html
import re
import sys
import zipfile


def items_html(path):
    s = open(path, encoding="utf-8").read()
    for li in re.findall(r"<li>(.*?)</li>", s, re.S):
        raw = li
        txt = html.unescape(re.sub(r"<[^>]+>", "", li)).replace("\n", " ").strip()
        if re.match(r"T\d+\w? ", txt):
            yield txt, raw


def items_docx(path):
    x = zipfile.ZipFile(path).read("word/document.xml").decode("utf-8")
    for p in re.findall(r"<w:p\b.*?</w:p>", x, re.S):
        txt = "".join(re.findall(r"<w:t(?:\s[^>]*)?>([^<]*)</w:t>", p))
        txt = html.unescape(txt)
        if re.match(r"T\d+\w? ", txt):
            yield txt, p


def check(path):
    gen = items_docx(path) if path.endswith(".docx") else items_html(path)
    print(f"== {path.split('/')[-1].split(chr(92))[-1]}")
    for txt, raw in gen:
        label, _, rest = txt.partition(": ")
        ist, _, soll = rest.rpartition(" = ")
        ok = "OK " if ist == soll else "ABW"
        tag = label.split(" ")[0]
        # Verlinkung
        if path.endswith(".docx"):
            anchors = re.findall(r'<w:hyperlink [^>]*?w:anchor="([^"]+)"', raw)
            fields = re.findall(r"<w:instrText[^>]*>([^<]*)<", raw)
            link = f"hyperlink->{anchors}" + (f" felder={fields}" if fields else "")
        else:
            link = "href->" + str(re.findall(r'href="(#[^"]+)"', raw))
        print(f"  {ok} {tag:4} ist={ist!r:55} soll={soll!r:50} {link}")


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    for p in sys.argv[1:]:
        check(p)
