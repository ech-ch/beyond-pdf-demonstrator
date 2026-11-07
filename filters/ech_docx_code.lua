-- Codeblöcke im Word in Festbreitenschrift (E43), ohne die eCH-Vorlage zu ändern.
--
-- Nur DOCX, läuft NACH `quarto`. Die eCH-Vorlage kennt die Zeichenvorlage
-- «Verbatim Char» nicht, mit der Pandoc Code setzt; der Code erschiene sonst
-- in Arial. Der Filter setzt den Block deshalb als OpenXML-Absatz mit direkter
-- Formatierung: Consolas 9 pt, grau hinterlegt, Zeilen mit Zeilenumbruch.

local function xml(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

function CodeBlock(block)
  if not quarto.doc.is_format("docx") then return nil end
  local zeilen = {}
  for zeile in (block.text .. "\n"):gmatch("(.-)\n") do
    table.insert(zeilen, '<w:t xml:space="preserve">' .. xml(zeile) .. "</w:t>")
  end
  return pandoc.RawBlock("openxml", table.concat({
    "<w:p><w:pPr>",
    '<w:shd w:val="clear" w:color="auto" w:fill="F1F3F5"/>',
    '<w:spacing w:before="120" w:after="120" w:line="240" w:lineRule="auto"/>',
    "</w:pPr><w:r><w:rPr>",
    '<w:rFonts w:ascii="Consolas" w:hAnsi="Consolas" w:cs="Consolas"/><w:sz w:val="18"/><w:szCs w:val="18"/>',
    "</w:rPr>",
    table.concat(zeilen, "<w:br/>"),
    "</w:r></w:p>",
  }))
end
