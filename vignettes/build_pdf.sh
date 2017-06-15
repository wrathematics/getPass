#!/bin/sh

cleanVignette(){
  rm -f *.aux *.bbl *.blg *.log *.out *.toc *.dvi
}

buildVignette(){
  cleanVignette
  
  pdflatex $1
  bibname=`echo "$1" | sed -e 's/\..*//'`
  bibtex $bibname
  pdflatex $1
  pdflatex $1
  Rscript -e "tools::compactPDF('$1', gs_quality='ebook')"
}

publish(){
  mv -f *.pdf ../inst/doc/
  cp -f *.Rnw ../inst/doc/
}



buildVignette getPass.Rnw

cleanVignette
publish
