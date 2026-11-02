-- Quarto filter: in-text citations without brackets.
--
-- The citation style prints every citation in brackets, "[eCH-0003 11.1.0]".
-- With this filter, the in-text form `@key` renders the label of the
-- reference without them, "eCH-0003 11.1.0" (e.g. "Gemäss @eCH-0003:11.1.0
-- müssen ..."), while `[@key]` keeps the brackets. A locator is kept:
-- `@key [S. 5]` renders "eCH-0003 11.1.0, S.5".
--
-- Quarto runs pandoc's citeproc only after all Lua filters, so the filter
-- renders the citations itself on a copy of the document
-- (pandoc.utils.citeproc) and replaces each in-text citation by its rendered
-- text, stripped of the outer brackets of the style. The replaced keys are
-- added to the `nocite` metadata so that the bibliography still lists them.
-- The filter is listed after `quarto` in docs/_quarto.yml, so that the
-- cross-references (@fig-..., @tbl-...) are already resolved when it runs.

local MARK = "ech-cite-"
local BRACKETS = { ["["] = "]", ["("] = ")" }

local function is_in_text(cite)
  return #cite.citations > 0 and cite.citations[1].mode == "AuthorInText"
end

-- Removes the outer brackets of a rendered citation in place. Returns false
-- if the rendering is not bracketed (e.g. an unknown key).
local function strip_brackets(inlines)
  local first, last = inlines[1], inlines[#inlines]
  if not (first and first.t == "Str" and last.t == "Str") then return false end
  local close = BRACKETS[first.text:sub(1, 1)]
  if not close or last.text:sub(-1) ~= close then return false end
  if #inlines == 1 then
    if #first.text < 2 then return false end
    inlines[1] = pandoc.Str(first.text:sub(2, -2))
  else
    inlines[1] = pandoc.Str(first.text:sub(2))
    inlines[#inlines] = pandoc.Str(last.text:sub(1, -2))
  end
  if inlines[#inlines].text == "" then inlines:remove(#inlines) end
  if #inlines > 0 and inlines[1].text == "" then inlines:remove(1) end
  return true
end

-- On the website, pandoc wraps citations in <span class="citation"> and marks
-- their links with role="doc-biblioref" (used by the hover popups); the
-- replacement does the same.
local function as_citation(inlines, cite)
  if not quarto.doc.is_format("html") then return inlines end
  local ids = {}
  for _, citation in ipairs(cite.citations) do table.insert(ids, citation.id) end
  inlines = inlines:walk({ Link = function(link) link.attributes.role = "doc-biblioref"; return link end })
  return pandoc.Span(inlines, pandoc.Attr("", { "citation" }, { ["data-cites"] = table.concat(ids, " ") }))
end

function Pandoc(doc)
  if not (doc.meta.bibliography or doc.meta.references) then return nil end

  -- Mark the in-text citations so that their renderings can be found again.
  local n = 0
  local marked = doc.blocks:walk({
    Cite = function(cite)
      if is_in_text(cite) then
        n = n + 1
        return pandoc.Span({ cite }, pandoc.Attr(MARK .. n))
      end
    end,
  })
  if n == 0 then return nil end

  local renderings = {}
  pandoc.utils.citeproc(pandoc.Pandoc(marked, doc.meta)).blocks:walk({
    Span = function(span)
      local i = span.identifier:sub(1, #MARK) == MARK and tonumber(span.identifier:sub(#MARK + 1))
      if i and span.content[1] and span.content[1].t == "Cite" then
        renderings[i] = span.content[1].content
      end
    end,
  })

  -- Replace the in-text citations by their rendering without the brackets.
  local keys, seen = {}, {}
  n = 0
  doc.blocks = doc.blocks:walk({
    Cite = function(cite)
      if not is_in_text(cite) then return nil end
      n = n + 1
      local inlines = renderings[n]
      if not (inlines and strip_brackets(inlines)) then return nil end
      for _, citation in ipairs(cite.citations) do
        if not seen[citation.id] then
          seen[citation.id] = true
          table.insert(keys, citation.id)
        end
      end
      return as_citation(inlines, cite)
    end,
  })
  if #keys == 0 then return nil end

  -- Keep the replaced references in the bibliography.
  local citations = {}
  for _, key in ipairs(keys) do table.insert(citations, pandoc.Citation(key, "NormalCitation")) end
  local nocite = pandoc.MetaInlines({ pandoc.Cite({ pandoc.Str("[@" .. table.concat(keys, "; @") .. "]") }, citations) })
  doc.meta.nocite = doc.meta.nocite and pandoc.MetaList({ doc.meta.nocite, nocite }) or nocite
  return doc
end
