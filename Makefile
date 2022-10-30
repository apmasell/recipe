TEXDIRS=$(filter-out CVS/,$(wildcard */))
genls=`pwd`/genls
genbigls=`pwd`/genbigls
MODE ?= nonstopmode

all:	Revision.tex Recipe.pdf rmtemp

dirs:
	for dir in ${TEXDIRS}; do $(MAKE) -C $$dir genls=${genls}; done

index.tex: ${TEXDIRS}
	${genbigls} $^

Recipe.pdf: dirs index.tex RecipeMain.tex CoverLogo.pdf $(foreach file, $(wildcard */*.svg), $(addsuffix .pdf, $(basename $(file))))
	pdflatex -interaction=$(MODE) Recipe && makeindex -q Recipe && pdflatex -interaction=$(MODE) Recipe

RecipeEbook.pdf: dirs index.tex RecipeMain.tex CoverLogo.pdf $(foreach file, $(wildcard */*.svg), $(addsuffix .pdf, $(basename $(file))))
	pdflatex -interaction=$(MODE) RecipeEbook && makeindex -q RecipeEbook && pdflatex -interaction=$(MODE) RecipeEbook

Revision.tex: always
	git rev-parse HEAD > $@
	git status > /dev/null || echo Dirty >> $@
	git rev-parse HEAD | qrencode -i -o Revision.png

%.pdf: %.svg
	inkscape -A $@ $<

rmtemp:
	rm -f Recipe.dvi Recipe.ps missfont.log Recipe.out

clean: rmtemp
	for dir in ${TEXDIRS}; do $(MAKE) -C $$dir clean; done
	rm -f Recipe.aux Recipe.idx Recipe.ilg Recipe.ind index.tex Revision.tex Recipe.log

.PHONY: all clean rmtemp dirs always

