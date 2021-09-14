#---------------------------------------------------------------------------
# Tool locations
#---------------------------------------------------------------------------

os_platform := $(shell uname -s)

ifeq ($(os_platform),Darwin)
RM := /bin/rm
GIT := /usr/local/bin/git
PANDOC := /usr/local/bin/pandoc
EBOOK_CONVERT := /usr/local/bin/ebook-convert
PDF_ENGINE ?= /Library/TeX/texbin/xelatex
PERL := /Users/tammy/perl5/bin/perl
XELATEX :=$(PDF_ENGINE)
PYTHON := /Users/tammy/.pyenv/shims/python
SPELL := /usr/local/bin/aspell
GS := /usr/local/bin/gs
VSCODE := /usr/local/bin/code
endif

ifeq ($(os_platform),Linux)
RM := /usr/bin/rm
GIT := /usr/bin/git
PANDOC := /usr/bin/pandoc
EBOOK_CONVERT := /usr/bin/ebook-convert
PDF_ENGINE ?= /usr/bin/xelatiex
PERL := /Users/tammy/perl5/bin/perl
XELATEX :=$(PDF_ENGINE)
PYTHON := /Users/tammy/.pyenv/shims/python
SPELL := /usr/bin/aspell
GS := /usr/bin/gs
VSCODE := /usr/bin/code
endif

$(call check_path_exists, $(RM), rm)
$(call check_path_exists, $(GIT), git)
$(call check_path_exists, $(PANDOC), pandoc)
$(call check_path_exists, $(EBOOK_CONVERT), ebook_convert)
$(call check_path_exists, $(PDF_ENGINE), PDF engine ($(notdir $(PDF_ENGINE))))
$(call check_path_exists, $(PERL), perl)
$(call check_path_exists, $(XELATEX), xelatex)
$(call check_path_exists, $(PYTHON), python)
$(call check_path_exists, $(SPELL), spell)
$(call check_path_exists, $(GS), gs)
$(call check_path_exists, $(VSCODE), code)

