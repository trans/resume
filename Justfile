source := "resume.md"
pdf := "Thomas-Sawyer-Resume.pdf"
source_pdf := "resume-source.pdf"
docx := "resume.docx"
pretty_template := "resume-pretty.tex"
source_template := "resume-source.tex"
export TEXMFVAR := "/tmp/texmf-var"
export TEXMFCACHE := "/tmp/texmf-cache"

default: pdf

pdf:
    pandoc {{source}} --from markdown+hard_line_breaks --template {{pretty_template}} --lua-filter resume-filter.lua --pdf-engine=pdflatex -o {{pdf}}

pdf-source:
    ruby render-source.rb
    pdflatex -interaction=nonstopmode -halt-on-error -jobname=resume-source {{source_template}}

docx:
    pandoc {{source}} --from markdown -o {{docx}}

all: pdf pdf-source docx

clean:
    rm -f {{pdf}} {{source_pdf}} {{docx}} resume-body.tex resume.aux resume.log resume.out resume-source.aux resume-source.log resume-source.out
