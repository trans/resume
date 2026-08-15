#!/usr/bin/env ruby
# frozen_string_literal: true

INPUT = "resume.md"
OUTPUT = "resume-body.tex"

def escape_tex(text)
  text
    .gsub("\\", "\\textbackslash{}")
    .gsub("{", "\\{")
    .gsub("}", "\\}")
    .gsub("$", "\\$")
    .gsub("&", "\\&")
    .gsub("#", "\\#")
    .gsub("_", "\\_")
    .gsub("%", "\\%")
    .gsub("<", "\\textless{}")
    .gsub(">", "\\textgreater{}")
    .gsub("~", "\\textasciitilde{}")
    .gsub("^", "\\textasciicircum{}")
end

def render_inline(text)
  out = +""
  i = 0

  while i < text.length
    if text[i, 2] == "**" && (j = text.index("**", i + 2))
      out << "\\textbf{#{escape_tex(text[i...(j + 2)])}}"
      i = j + 2
    elsif text[i] == "*" && (j = text.index("*", i + 1))
      out << "\\textit{#{escape_tex(text[i..j])}}"
      i = j + 1
    else
      out << escape_tex(text[i])
      i += 1
    end
  end

  out
end

def render_line(line)
  return "\\vspace{0.35\\baselineskip}" if line.empty?

  leading = line[/\A */].length
  content = line[leading..] || ""
  indent = leading.positive? ? "\\hspace*{#{format('%.1f', leading * 0.6)}em}" : ""
  rendered = "#{indent}#{render_inline(content)}"

  if content.start_with?("#")
    "\\noindent\\textbf{#{rendered}}\\par"
  else
    "\\noindent #{rendered}\\par"
  end
end

body = File.readlines(INPUT, chomp: true).map { |line| render_line(line) }.join("\n")
File.write(OUTPUT, body)
