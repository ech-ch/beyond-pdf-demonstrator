-- Spike S4: Feedback-Link pro Baustein (nur HTML).
--
-- * Überschriften mit Attribut `bb`  -> nach der Überschrift ein Absatz
--   «Feedback» (Div .feedback), Baustein-ID = Wert von `bb`.
-- * Divs mit Klasse `.baustein`      -> am Ende des Divs ein Absatz «Feedback»,
--   Baustein-ID = ID des Divs.
-- * DOCX und alle anderen Formate: nichts einfügen.
--
-- Link: https://github.com/ech-ch/beyond-pdf-demonstrator/issues/new
--         ?template=feedback.yml&title=<Feedback zu …>&baustein=<id>  (URL-kodiert)
--
-- Metadatum `feedback-pos: header` setzt den Link testweise IN die Überschrift.

local REPO = "https://github.com/ech-ch/beyond-pdf-demonstrator/issues/new"
local stringify = pandoc.utils.stringify

local function urlencode(s)
  -- Achtung: NICHT %w verwenden - unter Windows (LC_CTYPE=German_Switzerland.1252)
  -- zählt Lua Bytes >= 0x80 teilweise als Buchstaben, Umlaute würden halb kodiert.
  return (s:gsub("[^A-Za-z0-9%-%._~]", function(c) return string.format("%%%02X", string.byte(c)) end))
end

local function feedback_link(id, title)
  local url = REPO .. "?template=feedback.yml"
    .. "&title=" .. urlencode("Feedback zu " .. title)
    .. "&baustein=" .. urlencode(id)
  return pandoc.Link({ pandoc.Str("Feedback") }, url, "",
    pandoc.Attr("", { "feedback-link" }, { ["data-baustein"] = id }))
end

-- Überschriftentext ohne die von Quarto eingefügte Nummer (falls Filter nach quarto läuft)
local function plain_title(h)
  local inl = h.content:filter(function(x)
    return not (x.t == "Span" and x.classes:includes("header-section-number"))
  end)
  return (stringify(inl):gsub("^%s+", ""))
end

local in_header = false

return {
  {
    Meta = function(meta)
      in_header = stringify(meta["feedback-pos"] or "") == "header"
    end,
  },
  {
    Header = function(h)
      if not quarto.doc.is_format("html") then return nil end
      local bb = h.attributes["bb"]
      if not bb then return nil end
      local link = feedback_link(bb, plain_title(h))
      if in_header then
        h.content:extend({ pandoc.Space(), link })
        return h
      end
      return { h, pandoc.Div({ pandoc.Para({ link }) }, pandoc.Attr("", { "feedback" })) }
    end,
    Div = function(div)
      if not quarto.doc.is_format("html") then return nil end
      if not div.classes:includes("baustein") then return nil end
      div.content:insert(pandoc.Div({ pandoc.Para({ feedback_link(div.identifier, div.identifier) }) },
        pandoc.Attr("", { "feedback" })))
      return div
    end,
  },
}
