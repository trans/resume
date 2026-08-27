# Thomas Sawyer — Résumé

This repository keeps the résumé content in one source file and produces three public formats:

- Website: <https://7r4n5.top/resume/>
- PDF: `Thomas-Sawyer-Resume.pdf`
- Word: `resume.docx`

## Build

The build requires [Just](https://just.systems/), [Pandoc](https://pandoc.org/), and a LaTeX installation with `pdflatex`.

```sh
just site  # Generate the website, PDF, and DOCX
just pdf   # Generate only the PDF
just docx  # Generate only the DOCX
just all   # Generate all public formats
```

`resume.md` is the single content source. The web and PDF templates apply presentation separately so the published formats remain consistent without sharing layout constraints.

## Publishing

The GitHub Pages workflow publishes `index.html`, `styles.css`, the PDF, and the DOCX whenever `main` is updated. GitHub Pages must use **GitHub Actions** as its publishing source in the repository settings.
