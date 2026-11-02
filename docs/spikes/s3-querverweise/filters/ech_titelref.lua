-- Spike S3: Querverweis «Nummer + Titel» («Kapitel 7.1 Zuteilung einer eCH-Nummer»).
--
-- Quelle:   gemäss [@sec-zuteilung-ech-nummer]{.mit-titel}
-- Ergebnis: gemäss Kapitel 7.1 Zuteilung einer eCH-Nummer   (ganzer Text verlinkt)
--
-- Läuft NACH dem quarto-Filter (in _quarto.yml nach `quarto` gelistet): Dann hat
-- Quarto den Querverweis bereits zu einem Link «Kapitel 7.1» aufgelöst. Der
-- Filter hängt den Titel der Zielüberschrift an. Quarto hat zu diesem Zeitpunkt
-- die Abschnittsnummer schon in den Überschrifteninhalt geschrieben (HTML: Span
-- .header-section-number, sonst Text «7.1 » bzw. «7. »); sie wird entfernt.
-- Abschaltbar mit Metadatum `spike-filter: false`.

local stringify = pandoc.utils.stringify

local function title_of(header)
  local inl = header.content:clone()
  -- HTML: <span class="header-section-number">7.1</span> + Space
  if inl[1] and inl[1].t == "Span" and inl[1].classes:includes("header-section-number") then
    inl:remove(1)
    if inl[1] and inl[1].t == "Space" then inl:remove(1) end
  else
    local num = header.attributes["number"]
    if num and inl[1] and inl[1].t == "Str" and inl[1].text == num then
      inl:remove(1)
      if inl[1] and (inl[1].t == "Space" or (inl[1].t == "Str" and inl[1].text == ". ")) then inl:remove(1) end
    end
  end
  return inl
end

function Pandoc(doc)
  if doc.meta["spike-filter"] == false then return nil end
  local titles = {}
  doc:walk({
    Header = function(h)
      if h.identifier ~= "" then titles[h.identifier] = title_of(h) end
    end,
  })
  return doc:walk({
    Span = function(span)
      if not span.classes:includes("mit-titel") then return nil end
      local out = span.content:walk({
        Link = function(link)
          local id = link.target:match("^#(.+)$")
          if id and titles[id] then
            link.content:insert(pandoc.Space())
            link.content:extend(titles[id])
            return link
          end
        end,
      })
      return out
    end,
  })
end
