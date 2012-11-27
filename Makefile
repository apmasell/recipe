TEXDIRS=$(filter-out CVS/,$(wildcard */))
genls=`pwd`/genls
genbigls=`pwd`/genbigls

all:	Revision.tex Recipe.pdf rmtemp

dirs:
	for dir in ${TEXDIRS}; do $(MAKE) -C $$dir genls=${genls}; done

index.tex: ${TEXDIRS}
	${genbigls} $^

Recipe.pdf: dirs index.tex RecipeMain.tex CoverLogo.pdf $(foreach file, $(wildcard */*.svg), $(addsuffix .pdf, $(basename $(file))))
	pdflatex Recipe && makeindex Recipe && pdflatex Recipe

RecipeEbook.pdf: dirs index.tex RecipeMain.tex CoverLogo.pdf $(foreach file, $(wildcard */*.svg), $(addsuffix .pdf, $(basename $(file))))
	pdflatex RecipeEbook && makeindex RecipeEbook && pdflatex RecipeEbook

Revision.tex: always
	git log HEAD^..HEAD --pretty=format:%H > $@
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

