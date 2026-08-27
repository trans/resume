source := "resume.md"
pdf := "Thomas-Sawyer-Resume.pdf"
docx := "resume.docx"
html := "index.html"
pretty_template := "resume-pretty.tex"
web_template := "resume-web.html"
web_filter := "resume-web-filter.lua"
export TEXMFVAR := "/tmp/texmf-var"
export TEXMFCACHE := "/tmp/texmf-cache"

default: pdf

pdf:
    pandoc {{source}} --from markdown+hard_line_breaks --template {{pretty_template}} --lua-filter resume-filter.lua --pdf-engine=pdflatex -o {{pdf}}

docx:
    pandoc {{source}} --from markdown -o {{docx}}

site: pdf docx
    pandoc {{source}} --from markdown+hard_line_breaks --to html5 --standalone --section-divs --template {{web_template}} --lua-filter {{web_filter}} -o {{html}}

all: site

clean:
    rm -f {{pdf}} {{docx}} {{html}} resume.aux resume.log resume.out
