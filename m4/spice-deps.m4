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

# SPICE_CHECK_GSTREAMER(VAR, version, packages-to-check-for, [action-if-found, [action-if-not-found]])
# ---------------------
# Checks whether the specified GStreamer modules are present and sets the
# corresponding autoconf variables and preprocessor definitions.
# ---------------------
AC_DEFUN([SPICE_CHECK_GSTREAMER], [
    AS_VAR_PUSHDEF([have_gst],[have_]m4_tolower([$1]))dnl
    PKG_CHECK_MODULES([$1], [$3],
        [have_gst="yes"
         AC_SUBST(AS_TR_SH([[$1]_CFLAGS]))
         AC_SUBST(AS_TR_SH([[$1]_LIBS]))
         AS_VAR_APPEND([SPICE_REQUIRES], [" $3"])
         AC_DEFINE(AS_TR_SH([HAVE_$1]), [1], [Define if supporting GStreamer $2])
         $4],
        [have_gst="no"
         $5])
    AS_VAR_POPDEF([have_gst])dnl
])
