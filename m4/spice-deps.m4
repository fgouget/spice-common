# For autoconf < 2.63
m4_ifndef([AS_VAR_APPEND],
          AC_DEFUN([AS_VAR_APPEND], $1=$$1$2))

# SPICE_WARNING(warning)
# SPICE_PRINT_MESSAGES
# ----------------------
# Collect warnings and print them at the end so they are clearly visible.
# ---------------------
AC_DEFUN([SPICE_WARNING],AS_VAR_APPEND([spice_warnings],["|$1"]))
AC_DEFUN([SPICE_PRINT_MESSAGES],[
    ac_save_IFS="$IFS"
    IFS="|"
    for msg in $spice_warnings; do
        IFS="$ac_save_IFS"
        AS_VAR_IF([msg],[],,[AC_MSG_WARN([$msg]); echo >&2])
    done
    IFS="$ac_save_IFS"
])
