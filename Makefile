TEXDIRS=$(filter-out CVS/,$(wildcard */))
genls=`pwd`/genls
genbigls=`pwd`/genbigls

all:	Recipe.pdf rmtemp

dirs:
	for dir in ${TEXDIRS}; do $(MAKE) -C $$dir genls=${genls}; done

index.tex: ${TEXDIRS}
	${genbigls} $^

Recipe.pdf: dirs index.tex
	pdflatex Recipe && makeindex Recipe && pdflatex Recipe

rmtemp:
	rm -f Recipe.log Recipe.dvi Recipe.ps missfont.log Recipe.toc Recipe.out

clean: rmtemp
	for dir in ${TEXDIRS}; do $(MAKE) -C $$dir clean; done
	rm -f Recipe.pdf index.tex

.PHONY: all clean rmtemp dirs
