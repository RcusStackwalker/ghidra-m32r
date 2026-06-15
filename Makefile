GHIDRA_LANG ?= /opt/homebrew/opt/ghidra/libexec/Ghidra/Processors/M32R/data/languages

.PHONY: check-sleigh install-sleigh

check-sleigh:
	bash check-sleigh.sh

install-sleigh:
	sudo cp data/languages/m32r.sinc $(GHIDRA_LANG)/m32r.sinc
	sudo cp data/languages/m32r.cspec $(GHIDRA_LANG)/m32r.cspec
	sudo rm -f $(GHIDRA_LANG)/m32r.sla $(GHIDRA_LANG)/m32r-fp8000.sla
	@echo "Installed m32r.sinc + m32r.cspec to $(GHIDRA_LANG) — restart Ghidra to recompile"
