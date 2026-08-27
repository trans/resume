local awaiting_contact = false
local contact_done = false

local function with_attributes(link, class_name)
  if class_name then
    link.classes:insert(class_name)
  end
  return link
end

local function contact_link(label, target)
  return with_attributes(pandoc.Link({ pandoc.Str(label) }, target), "contact-link")
end

local function linkify_contact(inlines)
  local linked = {}

  for _, inline in ipairs(inlines) do
    if inline.t == "Str" and inline.text == "321-987-6732" then
      table.insert(linked, contact_link(inline.text, "tel:+13219876732"))
    elseif inline.t == "Str" and inline.text == "transfire@gmail.com" then
      table.insert(linked, contact_link(inline.text, "mailto:transfire@gmail.com"))
    else
      table.insert(linked, inline)
    end
  end

  return linked
end

local function wrap_contact_lines(inlines)
  local lines = { {} }

  for _, inline in ipairs(inlines) do
    if inline.t == "LineBreak" then
      table.insert(lines, {})
    else
      table.insert(lines[#lines], inline)
    end
  end

  local wrapped = {}
  for _, line in ipairs(lines) do
    table.insert(wrapped, pandoc.Span(line, pandoc.Attr("", { "contact-line" })))
  end

  return wrapped
end

function Header(el)
  if el.level == 1 and not contact_done then
    awaiting_contact = true
    el.classes:insert("hero-name")
  end

  return el
end

function Para(el)
  if awaiting_contact and not contact_done then
    awaiting_contact = false
    contact_done = true
    local content = wrap_contact_lines(linkify_contact(el.content))
    return pandoc.Div(
      { pandoc.Para(content) },
      pandoc.Attr("", { "contact" })
    )
  end

  return el
end

function Link(el)
  if el.target:match("^https?://") then
    el.attributes.target = "_blank"
    el.attributes.rel = "noreferrer"
    el.classes:insert("external")
  end

  if el.classes:includes("uri") then
    if el.target:match("/microgpt/blob/") then
      el.content = { pandoc.Str("Read preprint"), pandoc.Space(), pandoc.Str("↗") }
    else
      el.content = { pandoc.Str("View portfolio"), pandoc.Space(), pandoc.Str("↗") }
    end
  end

  return el
end
