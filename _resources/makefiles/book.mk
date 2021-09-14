#*****************************************************************************
#* Makefile for Book Publishing toolchain
#*
#* Included from the individual books' Makefiles. See the definitions in
#* check_variables_defined.mk for the variables the individual makefile needs
#* to define.
#*****************************************************************************

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

include $(mkfile_dir)/config/cfg_*.mk
include $(mkfile_dir)/helpers/hlpr_*.mk
include $(mkfile_dir)/targets/tgt_*.mk
