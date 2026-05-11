# =====================================================================
# Makefile - Projet d'apprentissage COBOL
# Compilateur : GnuCOBOL en mode Micro Focus / IBM, format libre
# =====================================================================

COBC          := cobc
COBFLAGS      := -free -std=mf -Wall -debug -fdebugging-line
COBCPY        := -I src/copybooks
BUILD         := build
DATA          := data

# Sous-programmes (compiles en .so, charges dynamiquement)
MODULES_SRC   := $(wildcard src/modules/*.cob)
MODULES_BIN   := $(patsubst src/modules/%.cob,$(BUILD)/%.so,$(MODULES_SRC))

# Programmes appeles par MAIN (egalement en .so)
SUBPROGS_SRC  := $(filter-out src/programs/MAIN.cob,$(wildcard src/programs/*.cob))
SUBPROGS_BIN  := $(patsubst src/programs/%.cob,$(BUILD)/%.so,$(SUBPROGS_SRC))

# Executable principal
MAIN_BIN      := $(BUILD)/MAIN

# Tests
TESTS_SRC     := $(wildcard tests/TEST-*.cob)
TESTS_BIN     := $(patsubst tests/%.cob,$(BUILD)/%,$(TESTS_SRC))

export COB_LIBRARY_PATH := $(CURDIR)/$(BUILD)

# =====================================================================
# Cibles publiques
# =====================================================================
.PHONY: all modules programs main tests test run debug clean reset help

all: modules programs main

modules: $(MODULES_BIN)

programs: $(SUBPROGS_BIN)

main: $(MAIN_BIN)

tests: $(TESTS_BIN)

test: all tests
	@bash tests/run-tests.sh

run: all | $(DATA)
	@$(MAIN_BIN)

debug: all | $(DATA)
	@gdb --args $(MAIN_BIN)

clean:
	rm -rf $(BUILD)

reset:
	rm -f $(DATA)/COMPTES.dat $(DATA)/TRANS.dat $(DATA)/COURS-PROD.dat

help:
	@echo "Cibles disponibles :"
	@echo "  make            - compile tout (modules + programmes + main)"
	@echo "  make run        - lance le menu bancaire"
	@echo "  make test       - compile et execute les tests unitaires"
	@echo "  make debug      - lance MAIN sous gdb"
	@echo "  make clean      - supprime build/"
	@echo "  make reset      - supprime les fichiers de donnees (data/)"
	@echo ""
	@echo "Stack etendue (Docker optionnel) : voir README section 5,"
	@echo "  docker-compose.stack.yml et stack/README.md"
	@echo ""
	@echo "Extensions / metier : docs/GUIDE-EXTENSION.md , docs/BACKLOG-METIER.md"

# =====================================================================
# Regles de compilation
# =====================================================================

# Modules metier (data access, validation) -> .so dynamique
$(BUILD)/%.so: src/modules/%.cob | $(BUILD) $(DATA)
	$(COBC) $(COBFLAGS) $(COBCPY) -m -o $@ $<

# Sous-programmes (CREER, DEPOT, ...) -> .so dynamique
$(BUILD)/%.so: src/programs/%.cob | $(BUILD)
	$(COBC) $(COBFLAGS) $(COBCPY) -m -o $@ $<

# Programme principal -> executable
$(MAIN_BIN): src/programs/MAIN.cob $(MODULES_BIN) $(SUBPROGS_BIN) | $(BUILD)
	$(COBC) $(COBFLAGS) $(COBCPY) -x -o $@ $<

# Tests -> executables
$(BUILD)/TEST-%: tests/TEST-%.cob $(MODULES_BIN) | $(BUILD)
	$(COBC) $(COBFLAGS) $(COBCPY) -x -o $@ $<

$(BUILD):
	mkdir -p $(BUILD)

$(DATA):
	mkdir -p $(DATA)
