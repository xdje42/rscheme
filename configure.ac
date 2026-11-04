dnl Top level configure for Rscheme
dnl This is the only configure humans have to run, further configurations are
dnl handled internally.

AC_INIT
AC_CONFIG_SRCDIR([BASE-VER])
AC_CONFIG_HEADERS([config.h])

RSCHEME_VERSION=`cat $srcdir/BASE-VER`
AC_SUBST(RSCHEME_VERSION)

if test x"${with_build_id}" != x
then RSCHEME_BUILD="$with_build_id"
else RSCHEME_BUILD="Dev Build, `date +'%Y-%m-%d %H:%M'`"
fi
AC_SUBST(RSCHEME_BUILD)

# FIXME: Does this propagate to subdir configury?
test "$prefix" = NONE && prefix=/usr/local/lib/rs/$RSCHEME_VERSION
# FIXME: It's non-standard to put user binaries in lib. Plus, the default is
# $prefix, suggesting it's not our responsibility to add the "/bin".
test "$exec_prefix" = NONE && exec_prefix=$prefix/bin

echo "Configuring: RScheme ($RSCHEME_VERSION $RSCHEME_BUILD)"

INSTALL_DIR=${prefix}

###############################################################################

# Configure arguments

# Enable the tree for building with the stage0 source directory.
AC_MSG_CHECKING([for building stage0])
AC_ARG_ENABLE(stage0-build,
  AS_HELP_STRING([--enable-stage0-build=no|yes],
    [enable building stage0 sources]),
  ENABLE_STAGE0_BUILD=$enableval,
  ENABLE_STAGE0_BUILD=no)
case "$ENABLE_STAGE0_BUILD" in
no) ;;
yes)
  if test ! -d $srcdir/stage0
  then
    AC_MSG_ERROR([cannot enable stage0 build, stage0 sources not present])
  fi
  ;;
*)
  AC_MSG_ERROR([--enable-stage0-build argument must be yes or no])
  ;;
esac
AC_MSG_RESULT([$ENABLE_STAGE0_BUILD])
AC_SUBST(ENABLE_STAGE0_BUILD)

if test "$ENABLE_STAGE0_BUILD" = yes
then MODULES_SUBDIR=stage0
     SYSTEM_BAS=stage0-system.bas
else MODULES_SUBDIR=modules
     SYSTEM_BAS=system.bas
fi
AC_SUBST(MODULES_SUBDIR)
AC_SUBST(SYSTEM_BAS)

# Default to yes if stage0 is in the tree, and we're not building stage0,
# otherwise no.
if test -d "$srcdir/stage0" -a "$ENABLE_STAGE0_BUILD" = no
then
  default_bootstrap=yes
else
  default_bootstrap=no
fi
AC_MSG_CHECKING([for bootstrapping via stage0])
AC_ARG_ENABLE(bootstrap,
  AS_HELP_STRING([--enable-bootstrap=no|yes],
    [enable bootstrapping]),
  ENABLE_BOOTSTRAP=$enableval,
  ENABLE_BOOTSTRAP=$default_bootstrap)
case "$ENABLE_BOOTSTRAP" in
no) ;;
yes)
  if test ! -d $srcdir/stage0
  then
    AC_MSG_ERROR([Bootstrap directory stage0 not present in source tree])
  fi
  ;;
*)
  AC_MSG_ERROR([--enable-bookstrap argument must be yes or no])
  ;;
esac
AC_MSG_RESULT([$ENABLE_BOOTSTRAP])
AC_SUBST(ENABLE_BOOTSTRAP)

if test "$ENABLE_STAGE0_BUILD" = yes -a "$ENABLE_BOOTSTRAP" = yes
then
  AC_MSG_ERROR([cannot specify both --enable-stage0-build --enable-bootstrap])
fi

# Set RS to either the value from $PATH or stage0 if bootstrapping.
AS_IF([test "$ENABLE_BOOTSTRAP" = yes],
      [RS="\$(abs_top_builddir)/build0/\$(STAGING_INSTALL_DIR)/bin/rs"
       AC_SUBST(RS)],
      [test "$ENABLE_STAGE0_BUILD" = yes],
      [RS="\$(abs_top_builddir)/\$(STAGING_INSTALL_DIR)/bin/rs"
       AC_SUBST(RS)],
      [AC_PATH_PROG(RS, rs, rs)])

AC_ARG_WITH([packages],
  [AS_HELP_STRING([--with-packages=no|default|pkg1,pkg2,...],
     [specify additional packages to build and install])])

###############################################################################

# Compilation configury

#
#  use C++ if using the RTGC
#

AC_PROG_CC
AC_PROG_CPP

if test "$with_gc" = "rtgc"
then AC_LANG([C++])
     AC_PROG_CXX
     AC_PROG_CXXCPP
     gnu_c="$GXX"
     COMPILE="$CXX"
else gnu_c="$GCC"
     COMPILE="$CC"
fi

AC_SUBST(COMPILE)

USE_INLINES=false
OPTIMIZE=true
ASSERTIONS=false
PERMIT_APPLY_BACKTRACE=false
USE_STACK_CACHE=true
FAKE_TIME_THREADS=false

if test "$enable_debug" = "yes"
then ASSERTIONS=true
fi

if $ASSERTIONS
then CFLAGS="$CFLAGS -g"
else CFLAGS="$CFLAGS -DNDEBUG"
fi

# FIXME: AC_PROG_LD
if test "${gnu_c}" = "yes" ; then
  GNU_C=true
  LD=${LD:-gcc}
  PERMIT_APPLY_BACKTRACE=true
  USE_INLINES=true
  STYLE=gcc
else
  GNU_C=false
  LD=${LD:-ld}
  PERMIT_APPLY_BACKTRACE=false
  USE_INLINES=false
  STYLE=ansi
fi

if test "$enable_debug" = "yes"
then USE_INLINES=false
     OPTIMIZE=false
     AC_DEFINE(DEBUG_BCI, 1)
else AC_DEFINE(DEBUG_BCI, 0)
fi

# This is built up incrementally and then stored in the Makefile as CFLAGS1.
# The ultimate CFLAGS is defined in the Makefile using this and other values.
CFLAGS=""

LDX_FLAGS="-lm"

AC_CANONICAL_HOST
AC_C_BIGENDIAN

###############################################################################

# Platform configury

default_pkgs="syscalls unixm"
dl_default=no

include_rstore=rstore

case "${host}" in
  m68k-*-*)     ARCH=m68k ; AC_DEFINE(PLATFORM_ARCH_M68K,1) ;;
  powerpc-*-*)  ARCH=powerpc ; AC_DEFINE(PLATFORM_ARCH_PPC,1) ;;
  rs6000-*-*)   ARCH=powerpc ; AC_DEFINE(PLATFORM_ARCH_PPC,1) ;;
  i?86-*-*)     ARCH=i386 ; AC_DEFINE(PLATFORM_ARCH_I386,1) ;;
  x86_64-*-*)   ARCH=x86_64 ; AC_DEFINE(PLATFORM_ARCH_X86_64,1)
                # rstore does not work (yet) on 64-bit
                include_rstore="" ;;
  mips-*-*)     ARCH=mips ; AC_DEFINE(PLATFORM_ARCH_MIPS,1) ;;
  sparc-*-*)    ARCH=sparc ; AC_DEFINE(PLATFORM_ARCH_SPARC,1) ;;
  alpha*-*-*)   ARCH=alpha ; AC_DEFINE(PLATFORM_ARCH_ALPHA,1) ;;
  s390-*-*)     ARCH=s390 ; AC_DEFINE(PLATFORM_ARCH_S390,1) ;;
  *-*-*)        ARCH=unknown ; AC_DEFINE(PLATFORM_ARCH_UNKNOWN,1) ;;
esac
AC_MSG_RESULT(Found architecture: $ARCH)

# configure PLATFORM and PLATCAP (used in various #defines and
# for reading platform-specific config files)
#
# also, for some systems, augment the set of default packages
# and whether dynamic linking is configured by default or
# not

case "${host}" in
  m68k-*-nextstep*) PLATFORM=next ; PLATCAP=NEXT
                 ;;
  *-*-darwin*)   PLATFORM=darwin ; PLATCAP=DARWIN
                 default_pkgs="fasl"
	         LDX_FLAGS=""
                 ;;
  *-*-rhapsody*) PLATFORM=rhapsody ; PLATCAP=RHAPSODY
                 default_pkgs="fasl"
	         LDX_FLAGS=""
                 ;;
  *-*-bsdi*)     PLATFORM=bsdi ; PLATCAP=BSDI
                 ;;
  *-*-*bsd*)	 PLATFORM=bsd ; PLATCAP=BSD
                 dl_default=yes
                 default_pkgs="fasl threads lss ${include_rstore}"
		 ;;
  *-*-darwin*)   PLATFORM=darwin ; PLATCAP=DARWIN
                 dl_default=yes
                 default_pkgs="fasl threads lss"
                 ;;
  *-*-aix*)      PLATFORM=aix ; PLATCAP=AIX
                 dl_default=yes
                 default_pkgs="fasl threads lss ${include_rstore}"
                 ;;
  *-*-linux*)    PLATFORM=linux ; PLATCAP=LINUX
                 dl_default=yes
                 default_pkgs="fasl threads lss ${include_rstore}"
                 ;;
  *-*-sunos* | *-*-solaris*) PLATFORM=sunos ; PLATCAP=SUNOS
                 dl_default=yes
                 default_pkgs="fasl threads lss ${include_rstore}"
                 ;;
  *-*-irix6*)    PLATFORM=irix ; PLATCAP=IRIX
                 LD="ld -old_ld"
                 default_pkgs=""
                 dl_default=yes
                 ;;
  *-*-irix*)     PLATFORM=irix ; PLATCAP=IRIX
                 ;;
  *-*-*)         PLATFORM=com ; PLATCAP=ANSI
                 ;;
esac
AC_MSG_RESULT(Found platform: $PLATFORM $PLATCAP)

default_pkgs="general syscalls unixm calendar sets $default_pkgs"

if test "$PLATFORM" = "linux"
then LDX_FLAGS="$LDX_FLAGS -ldl"
fi

if test "$PLATFORM" = "aix"
then LDX_FLAGS="$LDX_FLAGS -lcur -lbsd"
fi

if test "$PLATFORM" = "next"
then LDX_FLAGS="-sectcreate IMAGE system install/resource/system.img $LDX_FLAGS"
fi

#  there seems to be a bug in AIX 4.1.4 xlc that causes optimization
#  to kill RScheme...

if test "$PLATFORM" = aix -a $GNU_C = false
then OPTIMIZE=false
fi

if test "$OPTIMIZE" = true -a "$GNU_C" = true
then CFLAGS="$CFLAGS -O2"
fi

if test "$PLATFORM" = "aix"
then CFLAGS="$CFLAGS -D_BSD=43 -D_ALL_SOURCE"
fi

# HWREGS is broken on the latest GCC (3.3) on both
# 68K and PowerPC...

hwregs=none

# AC_MSG_CHECKING(if we should use hardware registers)
#
# hwregs=platform/arch/$ARCH/hwregs
#
# if test "$PLATFORM" = "rhapsody"
# then # broken on Rhapsody, even though it is a gcc
#      hwregs=none
# fi
# 
# if test -r $hwregs -a $GNU_C = true
# then AC_MSG_RESULT(yes)
#      CFLAGS="$CFLAGS -DUSE_HW_REGS `cat $hwregs`"
# else AC_MSG_RESULT(no)
# fi

###############################################################################

# Option handling

#
#  handle specification of --with-gc={irc,freelist,rtgc}
#

GC=${with_gc:-irc}

#
#  if using readline library, add appropriate LDX flags
# should this a --with option?  Better defaults?

case "$enable_readline" in
  gnu | yes )
     rdln_dir=""
     for i in /lib /usr/lib /usr/local/lib $HOME/lib
     do if test -r $i/libreadline.a
        then rdln_dir=$i
	fi
     done
     if test -z "$rdln_dir"
     then echo "WARNING: could not find GNU readline library" >&2
          echo "         may need to patch rshell/Makefile" >&2
          LDX_FLAGS="-lreadline $LDX_FLAGS"
     else LDX_FLAGS="-L$rdln_dir -lreadline $LDX_FLAGS"
     fi
     if test -r /usr/lib/libcur.a
     then LDX_FLAGS="$LDX_FLAGS -lcur"
     else if test -r /usr/lib/libtermcap.a
	  then LDX_FLAGS="$LDX_FLAGS -ltermcap"
	  fi
     fi
     RDLN="gnu"
     RDLN_SUBDIR="cfg/rdln/gnu"
     ;;
  "std" | "no" | "" )
     RDLN="std"
     ;;
  *)
     RDLN="$enable_readline"
     ;;
esac

if test "$enable_dynamic_linking" = "" -a "$dl_default" = "yes"
then enable_dynamic_linking=yes
fi

case "$enable_dynamic_linking" in
  yes )
     AC_CHECK_LIB(dl,dlopen)
	case "${host}" in
        *-*-aix*)
            LDX_FLAGS="-Wl,-bE:\$(INSTALL_DIR)/lib/rs.exp $LDX_FLAGS"
            ;;
	*-*-freebsd2*)
	    LDX_FLAGS="-Wl,-Bforcedynamic $LDX_FLAGS"
	    ;;
	*-*-darwin*)
	    LDX_FLAGS="-dynamic $LDX_FLAGS"
	    ;;
        *-*-sunos | *-*-solaris*)
	    LDX_FLAGS="$LDX_FLAGS -ldl"
	    ;;
	*)
	    LDX_FLAGS="-rdynamic $LDX_FLAGS"
	    ;;
	esac;
     ;;
  no )
     ;;
esac

if test "$enable_trace_signal_latency" = "yes"
then AC_DEFINE(TRACE_SIGNAL_LATENCY, 1)
else AC_DEFINE(TRACE_SIGNAL_LATENCY, 0)
fi

if test "$enable_profiling_hooks" = "yes"
then AC_DEFINE(PROFILING_HOOKS, 1)
     AC_DEFINE(ACCUM_GF_CACHE_HISTOGRAM,1)
     AC_DEFINE(ACCUM_BYTECODE_CORRELATION,1)
else AC_DEFINE(PROFILING_HOOKS, 0)
     AC_DEFINE(ACCUM_GF_CACHE_HISTOGRAM,0)
     AC_DEFINE(ACCUM_BYTECODE_CORRELATION,0)
fi

if test "$enable_read_barrier" = "yes"
then AC_DEFINE(INCLUDE_READ_BARRIER, 1)
     echo "*** WARNING:  read barrier support is still under development"
else AC_DEFINE(INCLUDE_READ_BARRIER, 0)
fi

if test "$enable_pstore_unmapper" = "yes"
then AC_DEFINE(INCLUDE_PSTORE_UNMAPPER, 1)
else AC_DEFINE(INCLUDE_PSTORE_UNMAPPER, 0)
fi

#
#  NOTE:  full-numeric-tower support is not fully implemented yet!
#         (fixnums roll over to longints, but not to MPs.  Also,
#         the implementation is still sketchy.)
#
if test "$enable_full_numeric_tower" = "yes"
then AC_DEFINE(FULL_NUMERIC_TOWER, 1)
     LDX_FLAGS="$LDX_FLAGS -lgmp"
     echo "*** WARNING:  full numeric tower support is sketchy at best."
     echo "              this option is still under development"
else AC_DEFINE(FULL_NUMERIC_TOWER, 0)
fi

if test "$enable_utf_process_code" = "yes"
then AC_DEFINE(UTF_PROCESS_CODE, 1)
else AC_DEFINE(UTF_PROCESS_CODE, 0)
fi

###############################################################################

# Compilation environment checks

AC_HEADER_DIRENT
AC_CHECK_HEADERS([db3/db_185.h db/db.h db.h unistd.h alloca.h sys/socket.h sys/select.h sys/time.h execinfo.h])

AC_PATH_PROG(AR, ar, ar)
AC_PATH_PROG(RANLIB, ranlib, :)

AC_CHECK_TYPES(long long)
AC_CHECK_TYPE(socklen_t,[AC_DEFINE(HAVE_SOCKLEN_T,1)],[AC_DEFINE(HAVE_SOCKLEN_T,0)],[#include <sys/types.h>
#if HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif])

AC_CHECK_SIZEOF(unsigned short)
AC_CHECK_SIZEOF(unsigned)
AC_CHECK_SIZEOF(unsigned long)

AC_CHECK_MEMBER(struct timeval.tv_usec,
                [AC_DEFINE(HAVE_STRUCT_TIMEVAL,1)],
                [AC_DEFINE(HAVE_STRUCT_TIMEVAL,0)],
                [
#if HAVE_SYS_TIME_H
#include <sys/time.h>
#endif])

AC_CHECK_FUNCS(getcwd getenv gettimeofday getwd \
  memcpy memmove ntohl ntohs setitimer strerror \
  stat mkdir chdir wait waitpid flock lockf getrusage usleep symlink \
  fgetln alloca erand48 backtrace)

dnl Check if the compiler supports computed gotos
AC_CACHE_CHECK(if computed goto works, rs_cv_computed_goto_works,
if test "$with_gc" = "rtgc"
then rs_cv_computed_goto_works=no
else AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[]], [[void *target = &&destination;
destination: goto *target;]])],[rs_cv_computed_goto_works=yes],[rs_cv_computed_goto_works=no])
fi
)

dnl Check to see how to implement fcanget()
AC_CACHE_CHECK(if can use select in fcanget, rs_cv_fcanget_do_select,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/time.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/select.h>
#include <unistd.h>]], [[  
  FILE *strm = stdin;
  fd_set r, w, x;
  int n, fd;
  struct timeval nodelay;
      
  nodelay.tv_sec = 0;
  nodelay.tv_usec = 0;

  fd = fileno( strm );

  FD_ZERO( &r );
  FD_ZERO( &w );
  FD_ZERO( &x );
  FD_SET( fd, &r );

  select( fd+1, &r, &w, &x, &nodelay );
]])],[rs_cv_fcanget_do_select=yes],[rs_cv_fcanget_do_select=no]))

AC_CACHE_CHECK(if FILE* has _IO_read_ptr, rs_cv_fcanget_use_io_read_ptr,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <stdio.h>]], [[FILE *strm = stdin;
int n = strm->_IO_read_end - strm->_IO_read_ptr;]])],[rs_cv_fcanget_use_io_read_ptr=yes],[rs_cv_fcanget_use_io_read_ptr=no]))

AC_CACHE_CHECK(if FILE* has _cnt, rs_cv_fcanget_use_cnt,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <stdio.h>]], [[FILE *strm = stdin;
int n = strm->_cnt;]])],[rs_cv_fcanget_use_cnt=yes],[rs_cv_fcanget_use_cnt=no]))

AC_CACHE_CHECK(if FILE* has _r, rs_cv_fcanget_use_r,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <stdio.h>]], [[FILE *strm = stdin;
int n = strm->_r;]])],[rs_cv_fcanget_use_r=yes],[rs_cv_fcanget_use_r=no]))


dnl Check if we can use the Pentium rdtsc instruction
AC_CACHE_CHECK(if Pentium RDTSC access works, rs_cv_pentium_rdtsc,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[]], [[unsigned long long int t;
   __asm__ volatile( ".byte 0x0f,0x31" : "=A"(t) );]])],[rs_cv_pentium_rdtsc=yes],[rs_cv_pentium_rdtsc=no]))

dnl Check if Berkeley db is available

if test $ac_cv_header_db3_db_185_h = yes
then db_hh="db3/db_185.h"
else if test $ac_cv_header_db_db_h = yes
     then db_hh="db/db.h"
     else if test $ac_cv_header_db_h = yes
	  then db_hh="db.h"
	  else db_hh=""
	  fi
     fi
fi

if test "$db_hh"
then AC_CACHE_CHECK(if Berkeley db, rs_cv_db_works,
     AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <${db_hh}>
#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>]], [[
DB *db;
DBT k, v;
  db = dbopen( "test.db", O_CREAT|O_TRUNC, 0666, DB_BTREE, NULL );
  k.data = "hello";
  k.size = 5;
  v.data = "there";
  v.size = 5;
  db->put( db, &k, &v, R_NOOVERWRITE );
]])],[rs_cv_db_works=yes],[rs_cv_db_works=no]))
fi

if test "$rs_cv_db_works" = yes
then default_pkgs="$default_pkgs db"
fi

AC_MSG_RESULT(Default packages: ${default_pkgs})
AC_SUBST(default_pkgs)

AC_CACHE_CHECK(if ntoh protos are ok, rs_cv_ntoh_proto_ok,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>]], [[extern unsigned long int ntohl( unsigned long int );
                extern unsigned short int ntohs( unsigned short int );]])],[rs_cv_ntoh_proto_ok=yes],[rs_cv_ntoh_proto_ok=no]))

AC_CACHE_CHECK(if <netinet/in.h> has ntoh protos, rs_cv_netinet_has_ntoh,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <netinet/in.h>]], [[return ntohl(2);]])],[rs_cv_netinet_has_ntoh=yes],[rs_cv_netinet_has_ntoh=no]))

if test "$rs_cv_ntoh_proto_ok" = no; then
  AC_DEFINE(NTOH_PROTO_OK, 0)
fi
if test "$rs_cv_netinet_has_ntoh" = yes; then
  AC_DEFINE(USE_NETINET_FOR_NTOH_PROTO, 1)
fi

if test "$rs_cv_pentium_rdtsc" = yes
then AC_DEFINE(USE_TIMEOFDAY_CLOCK,0)
     AC_DEFINE(USE_i586_CLOCK,1)
fi

if test $rs_cv_computed_goto_works = yes; then
  AC_DEFINE(USE_COMPUTED_GOTO, 1)
fi

if test $rs_cv_fcanget_do_select = yes
then AC_DEFINE(FCANGET_DO_SELECT, 1)
else AC_DEFINE(FCANGET_DO_SELECT, 0)
fi

if test $rs_cv_fcanget_use_io_read_ptr = yes
then AC_DEFINE(FCANGET_USE_IO_READ_PTR, 1)
else if test $rs_cv_fcanget_use_cnt = yes
     then AC_DEFINE(FCANGET_USE_CNT, 1)
     else if test $rs_cv_fcanget_use_r = yes
          then AC_DEFINE(FCANGET_USE_R, 1)
          fi
     fi
fi

dnl Check the return type of sprintf.  Kind of ugly ...
AC_CACHE_CHECK(sprintf returns int, rs_cv_sprintf_returns_int,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <stdio.h>
changequote(,)
changequote([,])dnl
]], [[changequote(<,>)dnl
char buf[20]; 
changequote([,])dnl
return (buf + sprintf(buf, "%d", 34))-buf;]])],[rs_cv_sprintf_returns_int=yes],[rs_cv_sprintf_returns_int=no]))

if test $rs_cv_sprintf_returns_int = no; then
  AC_DEFINE(SPRINTF_RETURNS_INT, 0)
fi

dnl Check to see if sigset_t is available (POSIX signals)
AC_CACHE_CHECK(for POSIX signals, rs_cv_posix_signals,
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <signal.h>
changequote(,)
changequote([,])dnl
]], [[sigset_t new_sig, old_sig;
sigfillset( &new_sig );
sigemptyset( &old_sig );
sigprocmask( SIG_BLOCK, &new_sig, &old_sig )]])],[rs_cv_posix_signals=yes],[rs_cv_posix_signals=no]))
if test $rs_cv_posix_signals = no; then
  AC_DEFINE(USE_POSIX_SIGNALS, 0)
fi

###############################################################################

# Create auxiliary configury files

# A file to put build style flags.
# Perhaps buildsty.h should be merged with platform.h.
BUILDSTY_H=install/include/rscheme/buildsty.h

rm -f $BUILDSTY_H \
      install/include/rscheme/platform.h \
      handc/heapi/mapf.c \
      handc/runtime/osglue.c \
      handc/runtime/dynlink.c

mkdir -p install/bin
mkdir -p install/include/rscheme
mkdir -p install/lib
mkdir -p install/resource/buildenv

echo "/* build style parameters */" > $BUILDSTY_H

#
# module preamble.mak, module.mak
#
# TODO: Rename preamble.mak to build-config.mak?
#

cat > install/resource/buildenv/preamble.mak <<EOF
# This is the preamble.mak used when building packages and other addons
#
# The parent Makefile must define INSTALL_DIR.

IFLAGS=\$(USR_IFLAGS) \$(SYS_IFLAGS) -I\$(INSTALL_DIR)/include

LD=$LD
LDR_FLAGS=-r
LDX_FLAGS=-L\$(INSTALL_DIR)/lib -lrs $LDX_FLAGS
EOF

cat > install/resource/buildenv/module.mak <<EOF
# This is the work-engine of module makefiles.
#
# The parent Makefile must define INSTALL_DIR.

OFILES=\$(CFILES:.c=.o)
SOFILES=\$(CFILES:.c=.so)

include \$(INSTALL_DIR)/resource/buildenv/preamble.mak

\$(PRODUCT): \$(OFILES)
	\$(LD) \$(LDR_FLAGS) \$(OFILES) -o \$(PRODUCT)

clean::
	rm -f \$(PRODUCT) \$(OFILES) \$(SOFILES)

\$(INSTALL_DIR)/include/rscheme/pkgs:
	mkdir \$(INSTALL_DIR)/include/rscheme/pkgs

install:: \$(PRODUCT) \$(INSTALL_DIR)/include/rscheme/pkgs
	cp \$(PRODUCT) \$(INSTALL_DIR)/lib
	cp \$(INCFILES) \$(INSTALL_DIR)/include/rscheme/pkgs
	cp \$(MIFBASEFILE).mif \$(INSTALL_DIR)/resource/modules
	cp \$(MIFBASEFILE).mx \$(INSTALL_DIR)/resource/modules
EOF

dnl ... XXX need to figure out how to use libtool to generalize this...
dnl ... XXX currently, dynamic linking is very Linux/GCC specific

if test "$enable_dynamic_linking" = "yes"
then cat >> install/resource/buildenv/module.mak <<"EOF"

SO_PRODUCT=lib$(PRODUCT:.o=.so)
$(SO_PRODUCT): $(SOFILES)
	$(CC) -shared $(SOFILES) -o $(SO_PRODUCT) $(XLFLAGS)

%.so: %.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -fPIC -o $@ $^

install.so: $(SO_PRODUCT)
	cp $(SO_PRODUCT) $(INSTALL_DIR)/resource/modules
	cp $(INCFILES) $(INSTALL_DIR)/include/rscheme/pkgs
	cp $(MIFBASEFILE).mif $(INSTALL_DIR)/resource/modules
	cp $(MIFBASEFILE).mx $(INSTALL_DIR)/resource/modules
EOF
fi

#
# pick up platform-dependent implementations of
# `mapf.c', `osglue.c', and `dynlink.c', if available else use the common ones
#

choose_most_specific() {
  dest=$1
  file=$2
  mkdir -p $dest
  # Compensate for "dest" being "foo/bar".
  case "$srcdir" in
  /*) top_srcdir="$srcdir" ;;
  *) top_srcdir="../../$srcdir" ;;
  esac
  if test -r $top_srcdir/handc/platform/$PLATFORM/$file
  then ln -f -s $top_srcdir/handc/platform/$PLATFORM/$file $dest/$file
  else ln -f -s $top_srcdir/handc/platform/com/$file $dest/$file
  fi
}

choose_most_specific handc/heapi mapf.c
choose_most_specific handc/runtime osglue.c
choose_most_specific handc/runtime dynlink.c

#
#  run some little config scripts, but only
#  if the platform doesn't supply a file
#

if test -r $srcdir/handc/platform/$PLATFORM/modulo.h
then cp $srcdir/handc/platform/$PLATFORM/modulo.h install/include/rscheme
else $COMPILE $srcdir/handc/cfg/mod.c
     test $? -ne 0 && exit 1
     if test -x ./a.exe
     then ax=./a.exe
     else ax=./a.out
     fi
     $ax > install/include/rscheme/modulo.h 
     test $? -ne 0 && exit 1
     rm -f $ax
fi

#
#  collect other compile-time flags
#

if $USE_INLINES
then CFLAGS="$CFLAGS -DINLINES"
     if test $GC = "irc"
     then CFLAGS="$CFLAGS -DGC_MACROS"
     fi
fi

if $PERMIT_APPLY_BACKTRACE
then echo "#define RECORD_CALL_CHAIN" >> $BUILDSTY_H
fi

if $USE_STACK_CACHE
then echo "#define STACK_CACHE" >> $BUILDSTY_H
fi

if $GNU_C
then CFLAGS="$CFLAGS -Wall -Wno-unused"
     if $ASSERTIONS
     then echo "#define USE_CONSTRUCTOR_EXPRS" >> $BUILDSTY_H
     fi
     echo "#define _rs_volatile /* empty */" >> $BUILDSTY_H
     echo "#define _rs_inline inline" >> $BUILDSTY_H
     echo "#define _rs_noreturn __attribute__((__noreturn__))" >> $BUILDSTY_H
else echo "#define _rs_volatile /* empty */" >> $BUILDSTY_H
     echo "#define _rs_inline /* empty */" >> $BUILDSTY_H
     echo "#define _rs_noreturn /* empty */" >> $BUILDSTY_H
fi

if $FAKE_TIME_THREADS
then echo "#define TIMER_IS_MONOTONE_COUNTER" >> $BUILDSTY_H
fi

echo "#define PLATFORM_TYPE \"$PLATFORM\"" >> $BUILDSTY_H

# Finish up preambl.mak.
echo "CC=$COMPILE" >> install/resource/buildenv/preamble.mak
echo "CFLAGS1=$CFLAGS1" >> install/resource/buildenv/preamble.mak
echo "CFLAGS=\$(CFLAGS1) \$(XCFLAGS) \$(IFLAGS)" >> install/resource/buildenv/preamble.mak

###############################################################################

# Finish up

# Comment prefix for excluding GNU-make specific lines.
# Assume GNU make.
# TODO: Support for other makes?
# Use C=# to comment out GNU-make specific lines.
C=
AC_SUBST(C)

#
#............. configure RTGC includes .............
#

if test "$GC" = "rtgc"
then rm -rf install/include/rtgc
     cp -r $srcdir/handc/cfg/gc/rtgc/rtgc install/include
     rm -f install/include/rtgc/langtype.h
     ln -f -s ../rtgc/gcserver.h install/include/rscheme
     ln -f -s ../rscheme/langtype.h install/include/rtgc/langtype.h
     ln -f -s ../rscheme/gcclient1.ci install/include/rtgc/gcclient1.ci
     ln -f -s ../rscheme/gcclient2.ci install/include/rtgc/gcclient2.ci
fi

AC_SUBST(USE_INLINES)

CFLAGS1=$CFLAGS
AC_SUBST(CFLAGS1)

AC_SUBST(LD)
AC_SUBST(LDX_FLAGS)

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([build-config.mak postambl.mak])

# This line is suggested by autoconf.info "Automatic Remaking"
# so ‘config.status’ ensures that ‘config.h’ is considered up to date.
AC_CONFIG_FILES([config.stamp], [echo timestamp > config.stamp])

AC_CONFIG_FILES([handc/Makefile])
AS_IF([test "$ENABLE_STAGE0_BUILD" = yes],
  AC_CONFIG_FILES([stage0/Makefile:modules/Makefile.in]),
  AC_CONFIG_FILES([modules/Makefile]))

# handc subdirs
AC_CONFIG_FILES([
    handc/bci/Makefile:handc/bci/Makefile.in
    handc/dfltmain/Makefile:handc/dfltmain/Makefile.in
    handc/hasht/Makefile:handc/hasht/Makefile.in
    handc/heapi/Makefile:handc/heapi/Makefile.in
    handc/loadboot/Makefile:handc/loadboot/Makefile.in
    handc/runtime/Makefile:handc/runtime/Makefile.in
    handc/rshell/Makefile:handc/rshell/Makefile.in
    handc/unstub/Makefile:handc/unstub/Makefile.in
])

# Set up subdirs that depend on configuration choices.
#
# Autoconf docs recommend always passing literal strings to AC_CONFIG_FILES.
# That gets complicated here as there can only be one invocation of
# AC_CONFIG_FILES per "tag" (eg, rdln/Makefile). Therefore we take an alternate
# approach derived from gdb-18.1/sim/configure.ac:SIM_BUILD_TARGET.
# By the way, the GNU tools gcc,gdb,binutils provide a wealth of examples of
# how to use GNU's autotools.
AC_CONFIG_FILES([handc/rdln/Makefile:handc/cfg/rdln/$RDLN/Makefile.in])
AC_CONFIG_FILES([handc/gc/Makefile:handc/cfg/gc/$GC/Makefile.in])
AC_CONFIG_FILES([handc/gcadapt/Makefile:handc/cfg/gcadapt/$GC/Makefile.in])

# TODO: Finish --with-packages handling
if test "$with_packages" != no
then
  AC_CONFIG_SUBDIRS([packages/rstore])
  AC_CONFIG_SUBDIRS([packages/lss])
fi

AC_CONFIG_FILES([test/Makefile])

# If building stage0 then there are makefiles in stage0 that we need to copy
# to the build directory, and other build-time files to support building
# Rscheme without having an existing copy to bootstrap from.
if test "$ENABLE_STAGE0_BUILD" = yes
then
  for d in `ls -1 $srcdir/stage0`
  do
    if test -f "$srcdir/stage0/$d/Makefile"
    then
      AC_MSG_NOTICE([Installing Makefile for stage0/$d])
      mkdir -p stage0/$d
      rm -f stage0/$d/Makefile
      sed -e "s,^srcdir=.*\$,srcdir=\$(abs_top_srcdir)/stage0/$d," \
          -e "s,^VPATH=.*\$,VPATH=\$(abs_top_srcdir)/stage0/$d," \
          < $srcdir/stage0/$d/Makefile > stage0/$d/Makefile
    fi
  done
  # These files are generated by the Rscheme compiler and saved in stage0.
  # Since they are generated files that need to exist in the build tree
  # we don't use symlinks back to their original copies in the source tree.
  cp $srcdir/stage0/subproj.mak stage0/subproj.mak
  mkdir -p install/include/rscheme handc/bci
  cp $srcdir/stage0/rlseconf.h install/include/rscheme/rlseconf.h
  cp $srcdir/stage0/stdmodul.h install/include/rscheme/stdmodul.h
  cp $srcdir/stage0/bcfrags.ci handc/bci/bcfrags.ci
  cp $srcdir/stage0/bcojump.ci handc/bci/bcojump.ci
  cp $srcdir/stage0/bcpjump.ci handc/bci/bcpjump.ci
  # Rename system.bas so Makefile won't try to rebuild it.
  cp $srcdir/stage0/system.bas stage0-system.bas
fi

AC_OUTPUT

# XYZDJE: This needs config.h. Move up.

sed -e "s/PLATFORM_ANSI/PLATFORM_$PLATCAP/" < config.h \
	> install/include/rscheme/platform.h
