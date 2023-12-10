# var
MODULE  = $(notdir $(CURDIR))
module  = $(shell echo $(MODULE) | tr A-Z a-z)
OS      = $(shell uname -o|tr / _)
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
CORES  ?= $(shell grep processor /proc/cpuinfo | wc -l)

# version
JQUERY_VER       = 3.7.1
JQUERY_UI        = 1.13.2
JQUERY_THEME     = dark-hive
JQUERY_THEME_VER = 1.12.1

# dir
CWD = $(CURDIR)
BIN = $(CWD)/bin
DOC = $(CWD)/doc
SRC = $(CWD)/src
TMP = $(CWD)/tmp
GZ  = $(HOME)/gz

# tool
CURL = curl -L -o
DC   = dmd
BLD  = dub build --compiler=$(DC)
RUN  = dub run   --compiler=$(DC)

# src
D += $(wildcard src/*.d)
J += $(wildcard *.json)
T += $(wildcard views/*.dt)

# all
.PHONY: all run
all: bin/$(MODULE)
bin/$(MODULE): $(D) $(J) $(T)
	$(BLD)
run: $(D) $(J) $(T)
	$(RUN)

# format
.PHONY: format
format: tmp/format_d
tmp/format_d: $(D)
	$(RUN) dfmt -- -i $? && touch $@

# rule
bin/$(MODULE): $(D) $(J) $(T) Makefile
	dub build -c $(CONFIG)

# doc
doc: doc/yazyk_programmirovaniya_d.pdf doc/Programming_in_D.pdf \
     doc/BuildWebAppsinVibe.pdf doc/BuildTimekeepWithVibe.pdf   \
	 doc/PSiCC2.pdf doc/PSiCC.pdf

doc/yazyk_programmirovaniya_d.pdf:
	$(CURL) $@ https://www.k0d.cc/storage/books/D/yazyk_programmirovaniya_d.pdf
doc/Programming_in_D.pdf:
	$(CURL) $@ http://ddili.org/ders/d.en/Programming_in_D.pdf
doc/BuildWebAppsinVibe.pdf:
	$(CURL) $@ https://raw.githubusercontent.com/reyvaleza/vibed/main/BuildWebAppsinVibe.pdf
doc/BuildTimekeepWithVibe.pdf:
	$(CURL) $@ https://raw.githubusercontent.com/reyvaleza/vibed/main/BuildTimekeepWithVibe.pdf

doc/PSiCC2.pdf:
	$(CURL) $@ https://www.state-machine.com/doc/PSiCC2.pdf
doc/PSiCC.pdf:
	$(CURL) $@ https://www.state-machine.com/doc/PSiCC.pdf

# install
.PHONY: install update gz
install: doc gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`

