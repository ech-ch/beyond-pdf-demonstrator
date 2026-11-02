-- Spike S4: protokolliert Header mit `bb` und Divs mit `.baustein` (stderr),
-- um zu sehen, was Quarto vor/nach seinem eigenen Filter an Attributen ändert.
-- Etikett («pre» / «post») aus dem Dateinamen (debug_pre.lua / debug_post.lua).
local label = (PANDOC_SCRIPT_FILE or ""):match("debug_(%w+)%.lua$") or "?"

local function attrs(a)
  local t = {}
  for k, v in pairs(a) do table.insert(t, k .. "=" .. v) end
  table.sort(t)
  return table.concat(t, ", ")
end


return {
  {
    Header = function(h)
      if h.attributes["bb"] or h.identifier:match("bb") then
        io.stderr:write(string.format("[S4-%s] %s Header L%d id=%s classes=[%s] attrs={%s} text=%q\n",
          label, FORMAT, h.level, h.identifier, table.concat(h.classes, ","), attrs(h.attributes),
          pandoc.utils.stringify(h.content)))
      end
    end,
    Div = function(d)
      if d.classes:includes("baustein") then
        io.stderr:write(string.format("[S4-%s] %s Div id=%s classes=[%s] attrs={%s} blocks=%d\n",
          label, FORMAT, d.identifier, table.concat(d.classes, ","), attrs(d.attributes), #d.content))
      end
    end,
  },
}
