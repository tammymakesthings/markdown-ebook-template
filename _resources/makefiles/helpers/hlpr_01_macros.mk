#----------------------------------------------------------------------------
# Makefile macros
#----------------------------------------------------------------------------

__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))

_check_path_exists = \
	$(if $(realpath $(strip $(firstword $1))), , $(error could not find $2 at '$1'))

check_path_exists = \
    $(strip $(foreach 1,$1, \
        $(call __check_path_exists,$1,$(strip $(value 2)))))
