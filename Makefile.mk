NAME?=cv
SRCDIR=${PWD}:${PWD}/${NAME}/:
WRKDIR=tmp
ENV=env TEXINPUTS=".:${SRCDIR}" BSTINPUTS="${SRCDIR}" BIBINPUTS="${SRCDIR}"

DVIPS_ARG=-Pdownload35 -Ppdf -G0 -ta4
PSPDF_ARG=-dCompatibilityLevel=1.4 \
		  -dPDFSETTINGS=/printer \
		  -dMAxSubsetPct=100 \
		  -dSubsetFonts=true \
		  -dEmbedAllFonts=true \
		  -sPAPERSIZE=a4


all: cv letter


cv:
	${MAKE} pdf_with_bib NAME=cv

letter:
	${MAKE} pdf_without_bib NAME=cover_letter


pdf_without_bib:
	mkdir -p ${WRKDIR}
	cd ${WRKDIR}; ${ENV} latex ${NAME}.tex
	cd ${WRKDIR}; ${ENV} dvips ${DVIPS_ARG} ${NAME}
	cd ${WRKDIR}; ${ENV} ps2pdf ${PSPDF_ARG} ${NAME}.ps
	mv ${WRKDIR}/${NAME}.pdf ${NAME}.pdf

pdf_with_bib:
	mkdir -p ${WRKDIR}
	cd ${WRKDIR}; ${ENV} latex ${NAME}.tex
	cd ${WRKDIR}; ${ENV} bibtex ${NAME}
	cd ${WRKDIR}; ${ENV} latex ${NAME}.tex
	cd ${WRKDIR}; ${ENV} latex ${NAME}.tex
	cd ${WRKDIR}; ${ENV} dvips ${DVIPS_ARG} ${NAME}
	cd ${WRKDIR}; ${ENV} ps2pdf ${PSPDF_ARG} ${NAME}.ps
	mv ${WRKDIR}/${NAME}.pdf ${NAME}.pdf


clean:
	rm -f ${WRKDIR}/*

spell:
	hunspell -t */${NAME}.tex

fclean: clean
	rm -Rf *.pdf

.PHONY: cv cover_letter
