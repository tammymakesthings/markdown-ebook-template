#############################################################################
# Markdown to Ebook/Paper Book Conversion Makefile
# Version 1.00, 2020-05-14, Tammy Cravit <tammymakesthings@gmail.com>
#############################################################################
# Requires the following tools to be installed:
#
# - Pandoc
# - ebook-convert (from Calibre)
# - XeLaTeX
#############################################################################

#---------------------------------------------------------------------------
# The basename for the generated files
#---------------------------------------------------------------------------

FILENAME=@@SLUG@@
BOOK_TAG=@@TITLE_SLUG@@
BOOK_NUM=@@BOOKNUM@@

BOOK_TITLE="@@TITLE@@"
SERIES_TITLE="Series Title"
AUTHOR="Author Name"

###########################################################################
# No user serviceable components below this line.
###########################################################################

# All this path nonsense is to work around the fact that on macOS with
# iCloud enabled, the realpath of $HOME includes spaces.
BOOK_TOPDIR := $(abspath $(subst Library/Mobile Documents/com~apple~CloudDocs/,, $(dir $(PWD))))
BOOK_BASE := $(abspath $(subst Library/Mobile Documents/com~apple~CloudDocs/,, $(PWD)))

include $(BOOK_BASE)/_resources/makefiles/book.mk
