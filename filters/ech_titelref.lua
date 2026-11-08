-- Querverweis «Nummer + Titel» («Kapitel 7.1 Zuteilung einer eCH-Nummer», E11)
-- oder nur «Titel» (AP26).
--
-- Ausgangspunkt: Spike S3 (docs/spikes/s3-querverweise/filters/ech_titelref.lua),
-- ohne den Schalter `spike-filter`.
--
-- Quelle:   gemäss [@sec-zuteilung-ech-nummer]{.mit-titel}
-- Ergebnis: gemäss Kapitel 7.1 Zuteilung einer eCH-Nummer   (ganzer Text verlinkt)
--
-- Läuft NACH dem quarto-Filter (in _quarto.yml nach `quarto` gelistet): Dann hat
-- Quarto den Querverweis bereits zu einem Link «Kapitel 7.1» aufgelöst. Der
-- Filter hängt den Titel der Zielüberschrift an. Quarto hat zu diesem Zeitpunkt
-- die Abschnittsnummer schon in den Überschrifteninhalt geschrieben (HTML: Span
-- .header-section-number, sonst Text «7.1 » bzw. «7. »); sie wird entfernt.
--
-- Anhänge (AP25): ech_anhang.lua hat «Anhang C – » vor den Titel gesetzt und
-- den Verweis zu «Anhang C» aufgelöst. Der Filter hängt « – Glossar» an, wie
-- das Word-Original im Feld REF («vgl. 2. Teil von Anhang C – Glossar», 1.3.2).
--
-- Nur der Titel (AP26): [-@sec-standard-verfahrensstandard]{.nur-titel} ergibt
-- «Verfahrensstandard» (verlinkt), wie ein Feld REF ohne Schalter \r im
-- Word-Original (2.1: «… Interoperabilitätsstandard, Verfahrensstandard und
-- Referenzierter Fremdstandard»).

local stringify = pandoc.utils.stringify

local function title_of(header)
  local inl = header.content:clone()
  if header.classes:includes("ech-anhang") then
    -- «Anhang C – Glossar»: alles bis und mit dem Leerzeichen nach «–» weg
    for i, el in ipairs(inl) do
      if el.t == "Str" and el.text == "–" then
        for _ = 1, i + 1 do inl:remove(1) end
        return inl, true
      end
    end
  end
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
  local titles, anhang = {}, {}
  doc:walk({
    Header = function(h)
      if h.identifier ~= "" then titles[h.identifier], anhang[h.identifier] = title_of(h) end
    end,
  })
  return doc:walk({
    Span = function(span)
      local nur = span.classes:includes("nur-titel")
      if not (nur or span.classes:includes("mit-titel")) then return nil end
      local out = span.content:walk({
        Link = function(link)
          local id = link.target:match("^#(.+)$")
          if id and titles[id] and nur then
            link.content = titles[id]:clone()
            return link
          elseif id and titles[id] then
            link.content:insert(pandoc.Space())
            if anhang[id] then link.content:extend({ pandoc.Str("–"), pandoc.Space() }) end
            link.content:extend(titles[id])
            return link
          end
        end,
      })
      return out
    end,
  })
end
