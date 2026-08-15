source := "resume.md"
pdf := "Thomas-Sawyer-Resume.pdf"
docx := "resume.docx"
pretty_template := "resume-pretty.tex"
export TEXMFVAR := "/tmp/texmf-var"
export TEXMFCACHE := "/tmp/texmf-cache"

default: pdf

pdf:
    pandoc {{source}} --from markdown+hard_line_breaks --template {{pretty_template}} --lua-filter resume-filter.lua --pdf-engine=pdflatex -o {{pdf}}

docx:
    pandoc {{source}} --from markdown -o {{docx}}

all: pdf docx

clean:
    rm -f {{pdf}} {{docx}} resume.aux resume.log resume.out
