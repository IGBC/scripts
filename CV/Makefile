.PHONY: all, clean, cleanall

CC = xelatex

cv.pdf: cv.tex
	$(CC) $<

resume.pdf: resume.tex
	$(CC) $<
	
coverletter.pdf: coverletter.tex
	$(CC) $<

all: cv.pdf, resume.pdf, coverletter.pdf

cleanall: clean
	rm -f *.pdf

clean: 
	rm -f *.log
	rm -f *.aux
	rm -f *.out
