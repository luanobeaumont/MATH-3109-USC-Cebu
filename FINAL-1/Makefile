# PROJECT NAME
DOCNAME = main

# COMMANDS
# -shell-escape is required for Minted/Python
# -interaction=nonstopmode prevents it from pausing on minor warnings
LATEX = latexmk -lualatex -shell-escape -interaction=nonstopmode -use-make

# 1. 'make' -> Compiles the PDF
all:
	$(LATEX) $(DOCNAME).tex

# 2. 'make clean' -> Removes all temporary files (keeps PDF)
clean:
	latexmk -c
	rm -rf _minted-$(DOCNAME) *.codeblk *.nav *.snm *.vrb

# 3. 'make purge' -> Removes EVERYTHING including the PDF (Fresh start)
purge: clean
	latexmk -C
	rm -f $(DOCNAME).pdf

# 4. 'make watch' -> Watches for file changes and auto-compiles
watch:
	$(LATEX) -pvc $(DOCNAME).tex