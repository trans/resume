local seen_h1 = false
local converted_header_contact = false

local function escape_latex(text)
  text = text:gsub("\\", "\\textbackslash{}")
  text = text:gsub("([#$%%&{}_])", "\\%1")
  text = text:gsub("~", "\\textasciitilde{}")
  text = text:gsub("%^", "\\textasciicircum{}")
  return text
end

local function render_inlines_as_latex(inlines)
  local out = {}

  for _, inline in ipairs(inlines) do
    if inline.t == "Str" then
      table.insert(out, escape_latex(inline.text))
    elseif inline.t == "Space" then
      table.insert(out, " ")
    elseif inline.t == "SoftBreak" then
      table.insert(out, " ")
    elseif inline.t == "Code" then
      table.insert(out, "\\texttt{" .. escape_latex(inline.text) .. "}")
    elseif inline.t == "Emph" then
      table.insert(out, "\\emph{" .. render_inlines_as_latex(inline.content) .. "}")
    elseif inline.t == "Strong" then
      table.insert(out, "\\textbf{" .. render_inlines_as_latex(inline.content) .. "}")
    elseif inline.t == "Link" then
      local label = render_inlines_as_latex(inline.content)
      local target = escape_latex(inline.target)
      table.insert(out, "\\href{" .. target .. "}{" .. label .. "}")
    elseif inline.t == "LineBreak" then
      table.insert(out, "\\\\\n")
    else
      table.insert(out, escape_latex(pandoc.utils.stringify(inline)))
    end
  end

  return table.concat(out)
end

function Header(el)
  if el.level == 1 then
    seen_h1 = true
  end

  return el
end

function Para(el)
  if seen_h1 and not converted_header_contact then
    converted_header_contact = true
    local content = render_inlines_as_latex(el.content)
    local block = table.concat({
      "\\begin{center}",
      "{\\small\\color{muted}",
      content,
      "}",
      "\\end{center}",
      "\\vspace{0.35em}"
    }, "\n")
    return pandoc.RawBlock("latex", block)
  end

  return el
end

function Span(el)
  if el.classes:includes("accent") then
    local content = render_inlines_as_latex(el.content)
    return pandoc.RawInline("latex", "\\accentword{" .. content .. "}")
  end

  return el
end
