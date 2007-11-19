TEXDIRS=$(filter-out CVS/,$(wildcard */))
genls=`pwd`/genls
genbigls=`pwd`/genbigls

all:	Revision.tex Recipe.pdf rmtemp

dirs:
	for dir in ${TEXDIRS}; do $(MAKE) -C $$dir genls=${genls}; done

index.tex: ${TEXDIRS}
	${genbigls} $^

Recipe.pdf: dirs index.tex CoverLogo.pdf $(foreach file, $(wildcard */*.svg), $(addsuffix .pdf, $(basename $(file))))
	pdflatex Recipe && makeindex Recipe && pdflatex Recipe

Revision.tex: always
	svn info https://masella.no-ip.org/svn/recipes | grep Revision > $@
	[ `svn st | wc -l` -gt 0 ] && echo Dirty || exit 0 >> $@

%.pdf: %.svg
	inkscape -A $@ $<

rmtemp:
	rm -f Recipe.log Recipe.dvi Recipe.ps missfont.log Recipe.out

clean: rmtemp
	for dir in ${TEXDIRS}; do $(MAKE) -C $$dir clean; done
	rm -f Recipe.aux Recipe.idx Recipe.ilg Recipe.ind Recipe.pdf index.tex Revision.tex

.PHONY: all clean rmtemp dirs always

