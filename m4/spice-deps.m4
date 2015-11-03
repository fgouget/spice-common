# For autoconf < 2.63
m4_ifndef([AS_VAR_APPEND],
          AC_DEFUN([AS_VAR_APPEND], $1=$$1$2))
m4_ifndef([AS_VAR_COPY],
          [m4_define([AS_VAR_COPY],
          [AS_LITERAL_IF([$1[]$2], [$1=$$2], [eval $1=\$$2])])])


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
    AS_VAR_PUSHDEF([gst_inspect],[GST_INSPECT_$2])dnl
    PKG_CHECK_MODULES([$1], [$3],
        [have_gst="yes"
         AC_SUBST(AS_TR_SH([[$1]_CFLAGS]))
         AC_SUBST(AS_TR_SH([[$1]_LIBS]))
         AS_VAR_APPEND([SPICE_REQUIRES], [" $3"])
         AC_DEFINE(AS_TR_SH([HAVE_$1]), [1], [Define if supporting GStreamer $2])
         AC_PATH_PROG(gst_inspect, gst-inspect-$2)
         AS_IF([test "x$gst_inspect" = x],
               SPICE_WARNING([Cannot verify that the required runtime GStreamer $2 elements are present because gst-inspect-$2 is missing]))
         $4],
        [have_gst="no"
         $5])
    AS_VAR_POPDEF([gst_inspect])dnl
    AS_VAR_POPDEF([have_gst])dnl
])

# SPICE_CHECK_GSTREAMER_ELEMENTS(gst-inspect, package, elements-to-check-for)
# ---------------------
# Checks that the specified GStreamer elements are installed. If not it
# issues a warning and sets missing_gstreamer_elements.
# ---------------------
AC_DEFUN([SPICE_CHECK_GSTREAMER_ELEMENTS], [
AS_IF([test "x$1" != x],
      [missing=""
       for element in $3
       do
           AS_VAR_PUSHDEF([cache_var],[spice_cv_prog_${1}_${element}])dnl
           AC_CACHE_CHECK([for the $element GStreamer element], cache_var,
                          [found=no
                           "$1" $element >/dev/null 2>/dev/null && found=yes
                           eval "cache_var=$found"])
           AS_VAR_COPY(res, cache_var)
           AS_IF([test "x$res" = "xno"], [missing="$missing $element"])
           AS_VAR_POPDEF([cache_var])dnl
       done
       AS_IF([test "x$missing" != x],
             [SPICE_WARNING([The$missing GStreamer element(s) are missing. You should be able to find them in the $2 package.])
              missing_gstreamer_elements="yes"],
             [test "x$missing_gstreamer_elements" = x],
             [missing_gstreamer_elements="no"])
      ])
])
