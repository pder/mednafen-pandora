AC_INIT([src/mednafen.cpp])
AC_GNU_SOURCE
AC_USE_SYSTEM_EXTENSIONS
AC_CONFIG_MACRO_DIR([m4])

#
# Avoid trailing and leading zeroes in the decimal version components to avoid confusing not-so-learned people.
#
MEDNAFEN_VERSION='0.9.17.1'
MEDNAFEN_VERSION_NUMERIC=0x000917

AC_CANONICAL_HOST
AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE([mednafen], $MEDNAFEN_VERSION)
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES])
AM_CONFIG_HEADER([include/config.h:include/config.h.in])

AC_PROG_CC
AC_PROG_CPP
AM_PROG_AS
AM_PROG_CC_C_O
AC_PROG_CXX
AC_PROG_CXXCPP
AC_LANG_CPLUSPLUS
AM_PROG_LIBTOOL
AC_PROG_INSTALL

gl_VISIBILITY

AC_SYS_LARGEFILE
AC_FUNC_FSEEKO

# sizeof tests need to come after largefile support macros

AC_CHECK_TYPE(ptrdiff_t,long)
AC_TYPE_SIZE_T
AC_CHECK_SIZEOF(short)
AC_CHECK_SIZEOF(int)
AC_CHECK_SIZEOF(long)
AC_CHECK_SIZEOF(long long)
AC_CHECK_SIZEOF(double)
AC_CHECK_SIZEOF(__int64)
AC_CHECK_SIZEOF(void *)
AC_CHECK_SIZEOF(size_t)
AC_CHECK_SIZEOF(ptrdiff_t)
AC_CHECK_SIZEOF(off_t)
AC_C_CONST
AC_CHECK_FUNCS(memcmp memcpy memmove memset mmap munmap madvise signal sigaction fcntl getenv putenv setenv gettimeofday getpwuid getuid usleep strerror strerror_r ftello fopen64 fseeko64 ftello64 fstat64)
AC_CHECK_HEADERS(fcntl.h)
AC_FUNC_MKDIR
PKG_PROG_PKG_CONFIG

#
# Check for any libraries that need to be linked against for clock_gettime().
#
# (posix4 is apparently used by much older versions of Solaris according to tar, pre-7, so maybe it's not necessary
#  for Mednafen?)
AC_SEARCH_LIBS(clock_gettime, [rt posix4])
AC_CHECK_FUNCS(clock_gettime)

AC_DEFINE(MINILZO_HAVE_CONFIG_H, [1], [Define if config.h is present])

AC_CHECK_HEADER([OpenGL/gl.h],HAVE_OPENGL_GL_H=true, HAVE_OPENGL_GL_H=false)
if $HAVE_OPENGL_GL_H
then
 AC_DEFINE(HAVE_APPLE_OPENGL_FRAMEWORK, [1], [Define if we should include from OpenGL instead of GL])
else
 AC_PATH_X
 CFLAGS="-I${x_includes} ${CFLAGS}"
 CPPFLAGS="-I${x_includes} ${CFLAGS}"

 AC_CHECK_HEADER([GL/gl.h],HAVE_GL_GL_H=true, HAVE_GL_GL_H=false)

 if test x$HAVE_GL_GL_H = xfalse; then
  AC_MSG_ERROR([*** OpenGL header file not found!])
 fi
fi

AM_ICONV
AM_GNU_GETTEXT

AC_SUBST(LIBICONV)
AC_SUBST(LIBINTL)

dnl Check for zlib
AC_CHECK_LIB([z], [zlibVersion],[], AC_MSG_ERROR([*** zlib not found!]))
LIBS="$LIBS -lz"

dnl -fno-unit-at-a-time

OPTIMIZER_FLAGS=""

dnl MATH_OPTIMIZER_FLAGS is used in the automake files where it doesn't break code
MATH_OPTIMIZER_FLAGS="-ffast-math"
AC_SUBST(MATH_OPTIMIZER_FLAGS)

AX_CFLAGS_GCC_OPTION([-fomit-frame-pointer], OPTIMIZER_FLAGS)
AX_CFLAGS_GCC_OPTION([-finline-limit=6000], OPTIMIZER_FLAGS)
AX_CFLAGS_GCC_OPTION([--param large-function-growth=800], OPTIMIZER_FLAGS)
AX_CFLAGS_GCC_OPTION([--param inline-unit-growth=175], OPTIMIZER_FLAGS)
AX_CFLAGS_GCC_OPTION([--param max-inline-insns-single=10000], OPTIMIZER_FLAGS)
AX_CFLAGS_GCC_OPTION([-fno-strict-overflow], OPTIMIZER_FLAGS)

WARNING_FLAGS=""
AX_CFLAGS_GCC_OPTION([-Wall], WARNING_FLAGS)
AX_CFLAGS_GCC_OPTION([-Winline], WARNING_FLAGS)
AX_CFLAGS_GCC_OPTION([-Wshadow], WARNING_FLAGS)
AX_CFLAGS_GCC_OPTION([-Wempty-body], WARNING_FLAGS)
AX_CFLAGS_GCC_OPTION([-Wignored-qualifiers], WARNING_FLAGS)

GBA_EXTRA_FLAGS=""
AX_CFLAGS_GCC_OPTION([-fno-unit-at-a-time], GBA_EXTRA_FLAGS)
AC_SUBST(GBA_EXTRA_FLAGS)

MDFN_COMPAT_FLAGS=""
AX_CFLAGS_GCC_OPTION([-fsigned-char], MDFN_COMPAT_FLAGS)

CFLAGS="$MDFN_COMPAT_FLAGS $WARNING_FLAGS $OPTIMIZER_FLAGS $CFLAGS"
CPPFLAGS="$MDFN_COMPAT_FLAGS $WARNING_FLAGS $OPTIMIZER_FLAGS $CPPFLAGS"

AM_CONDITIONAL(WANT_DEBUGGER, false)

AC_ARG_ENABLE(debugger,
 AC_HELP_STRING([--enable-debugger], [build with internal debugger [[default=yes]]]),
                  , enable_debugger=yes)

if test x$enable_debugger = xyes; then
                AC_DEFINE([WANT_DEBUGGER], [1], [Define if we are compiling with debugger.])
		AM_CONDITIONAL(WANT_DEBUGGER, true)
fi

AC_ARG_ENABLE(cjk-fonts,
 AC_HELP_STRING([--enable-cjk-fonts], [build with internal CJK(Chinese, Japanese, Korean) fonts [[default=yes]]]),
                  , enable_cjk_fonts=yes)

if test x$enable_cjk_fonts = xyes; then
                AC_DEFINE([WANT_INTERNAL_CJK], [1], [Define if we are compiling with internal CJK fonts.])
fi

dnl
dnl The code that uses $enable_altivec is lower, in the CPU architecture section.
dnl
AC_ARG_ENABLE(altivec,
 AC_HELP_STRING([--enable-altivec], [use AltiVec extensions on PowerPC/POWER ISA processors [[default=yes]]]),
                  , enable_altivec=yes)


AM_CONDITIONAL(WANT_GB_EMU, false)
AM_CONDITIONAL(WANT_GBA_EMU, false)
AM_CONDITIONAL(WANT_LYNX_EMU, false)
AM_CONDITIONAL(WANT_MD_EMU, false)
AM_CONDITIONAL(WANT_SMS_EMU, false)
AM_CONDITIONAL(WANT_NES_EMU, false)
AM_CONDITIONAL(WANT_NGP_EMU, false)
AM_CONDITIONAL(WANT_PCE_EMU, false)
AM_CONDITIONAL(WANT_PCE_FAST_EMU, false)
AM_CONDITIONAL(WANT_PCFX_EMU, false)
AM_CONDITIONAL(WANT_SMS_EMU, false)
AM_CONDITIONAL(WANT_SNES_EMU, false)
AM_CONDITIONAL(WANT_WSWAN_EMU, false)

AC_ARG_ENABLE(gb,
 AC_HELP_STRING([--enable-gb], [build with GameBoy emulation [[default=yes]]]),
                  , enable_gb=yes)

if test x$enable_gb = xyes; then
                AC_DEFINE([WANT_GB_EMU], [1], [Define if we are compiling with GB emulation.])
		AM_CONDITIONAL(WANT_GB_EMU, true)
fi

AC_ARG_ENABLE(gba,
 AC_HELP_STRING([--enable-gba], [build with GameBoy Advance emulation [[default=yes]]]),
                  , enable_gba=yes)

if test x$enable_gba = xyes; then
                AC_DEFINE([WANT_GBA_EMU], [1], [Define if we are compiling with GBA emulation.])
		AM_CONDITIONAL(WANT_GBA_EMU, true)
fi

AC_ARG_ENABLE(lynx,
 AC_HELP_STRING([--enable-lynx], [build with Atari Lynx emulation [[default=yes]]]),
                  , enable_lynx=yes)

if test x$enable_lynx = xyes; then
                AC_DEFINE([WANT_LYNX_EMU], [1], [Define if we are compiling with Lynx emulation.])
		AM_CONDITIONAL(WANT_LYNX_EMU, true)
fi

AC_ARG_ENABLE(md,
 AC_HELP_STRING([--enable-md], [build with Sega Genesis/MegaDrive emulation [[default=yes]]]),
                  , enable_md=yes)

if test x$enable_md = xyes; then
                AC_DEFINE([WANT_MD_EMU], [1], [Define if we are compiling with Sega Genesis/MegaDrive emulation.])
                AM_CONDITIONAL(WANT_MD_EMU, true)
fi

AC_ARG_ENABLE(nes,
 AC_HELP_STRING([--enable-nes], [build with Nintendo Entertainment System emulation [[default=yes]]]),
                  , enable_nes=yes)

if test x$enable_nes = xyes; then
                AC_DEFINE([WANT_NES_EMU], [1], [Define if we are compiling with NES emulation.])
                AM_CONDITIONAL(WANT_NES_EMU, true)
fi

AC_ARG_ENABLE(ngp,
 AC_HELP_STRING([--enable-ngp], [build with Neo Geo Pocket emulation [[default=yes]]]),
                  , enable_ngp=yes)

if test x$enable_ngp = xyes; then
                AC_DEFINE([WANT_NGP_EMU], [1], [Define if we are compiling with NGP emulation.])
		AM_CONDITIONAL(WANT_NGP_EMU, true)
fi

AC_ARG_ENABLE(pce,
 AC_HELP_STRING([--enable-pce], [build with PC Engine(TurboGrafx 16) emulation [[default=yes]]]),
                  , enable_pce=yes)

if test x$enable_pce = xyes; then
                AC_DEFINE([WANT_PCE_EMU], [1], [Define if we are compiling with PCE emulation.])
		AM_CONDITIONAL(WANT_PCE_EMU, true)
fi

AC_ARG_ENABLE(pce-fast,
 AC_HELP_STRING([--enable-pce-fast], [build the separate, fast PC Engine(TurboGrafx 16) emulation [[default=yes]]]),
                  , enable_pce_fast=yes)

if test x$enable_pce_fast = xyes; then
                AC_DEFINE([WANT_PCE_FAST_EMU], [1], [Define if we are compiling with separate fast PCE emulation.])
                AM_CONDITIONAL(WANT_PCE_FAST_EMU, true)
fi

AC_ARG_ENABLE(pcfx,
 AC_HELP_STRING([--enable-pcfx], [build with PC-FX emulation [[default=yes]]]),
                  , enable_pcfx=yes)

if test x$enable_pcfx = xyes; then
                AC_DEFINE([WANT_PCFX_EMU], [1], [Define if we are compiling with PC-FX emulation.])
		AM_CONDITIONAL(WANT_PCFX_EMU, true)
fi

AC_ARG_ENABLE(sms,
 AC_HELP_STRING([--enable-sms], [build with SMS+GG emulation [[default=yes]]]),
                  , enable_sms=yes)

if test x$enable_sms = xyes; then
                AC_DEFINE([WANT_SMS_EMU], [1], [Define if we are compiling with SMS+GG emulation.])
                AM_CONDITIONAL(WANT_SMS_EMU, true)
fi

AC_ARG_ENABLE(snes,
 AC_HELP_STRING([--enable-snes], [build with SNES emulation [[default=yes]]]),
                  , enable_snes=yes)

if test x$enable_snes = xyes; then
                AC_DEFINE([WANT_SNES_EMU], [1], [Define if we are compiling with SNES emulation.])
                AM_CONDITIONAL(WANT_SNES_EMU, true)
fi

AC_ARG_ENABLE(vb,
 AC_HELP_STRING([--enable-vb], [build with Virtual Boy emulation [[default=yes]]]),
                  , enable_vb=yes)

if test x$enable_vb = xyes; then
                AC_DEFINE([WANT_VB_EMU], [1], [Define if we are compiling with Virtual Boy emulation.])
                AM_CONDITIONAL(WANT_VB_EMU, true)
fi


AC_ARG_ENABLE(wswan,
 AC_HELP_STRING([--enable-wswan], [build with WonderSwan emulation [[default=yes]]]),
                  , enable_wswan=yes)

if test x$enable_wswan = xyes; then
                AC_DEFINE([WANT_WSWAN_EMU], [1], [Define if we are compiling with WonderSwan emulation.])
                AM_CONDITIONAL(WANT_WSWAN_EMU, true)
fi

AM_CONDITIONAL(HAVE_OSSDSP, false)
AM_CONDITIONAL(HAVE_ALSA, false)
AM_CONDITIONAL(HAVE_DIRECTSOUND, false)
AM_CONDITIONAL(HAVE_SDL, false)
AM_CONDITIONAL(HAVE_JACK, false)

dnl Check* functions ripped from SDL's autoconf file, with heavy modifications
dnl See if the ALSA audio interface is supported

CheckALSA()
{
    AC_ARG_ENABLE(alsa,
AC_HELP_STRING([--enable-alsa], [support the ALSA audio API [[default=yes]]]),
                  , enable_alsa=yes)
    if test x$enable_alsa = xyes; then
        AM_PATH_ALSA(1.0.0, have_alsa=yes, have_alsa=no)

        # Restore all flags from before the ALSA detection runs
        CFLAGS="$alsa_save_CFLAGS"
        LDFLAGS="$alsa_save_LDFLAGS"
        LIBS="$alsa_save_LIBS"

        if test x$have_alsa = xyes; then
		AM_CONDITIONAL(HAVE_ALSA, true)
		AC_DEFINE([HAVE_ALSA], [1], [Define if we are compiling with ALSA support.])
		LIBS="$LIBS $ALSA_LIBS"
		CFLAGS="$CFLAGS $ALSA_CFLAGS"
		CPPFLAGS="$CPPFLAGS $ALSA_CFLAGS"
	fi
    fi
}

CheckJACK()
{
    AC_ARG_ENABLE(jack,
AC_HELP_STRING([--enable-jack], [support the JACK audio API [[default=yes]]]),
                  , enable_jack=yes)
    if test x$enable_jack = xyes; then
        PKG_CHECK_MODULES(JACK, jack, [have_jack=yes], [have_jack=no])

        if test x$have_jack = xyes; then
                AM_CONDITIONAL(HAVE_JACK, true)
                AC_DEFINE([HAVE_JACK], [1], [Define if we are compiling with JACK support.])
                LIBS="$LIBS $JACK_LIBS"
                CFLAGS="$CFLAGS $JACK_CFLAGS"
                CPPFLAGS="$CPPFLAGS $JACK_CFLAGS"
        fi
    fi
}

CheckALSA
CheckJACK

SDL_VERSION=1.2.0
AM_PATH_SDL($SDL_VERSION, HAVE_SDL=true, HAVE_SDL=false)
if $HAVE_SDL
then
	AM_CONDITIONAL(HAVE_SDL, true)
	AC_DEFINE([HAVE_SDL], [1], [Define if we are compiling with SDL sound support.])
	AC_SUBST(SDL_LIBS)
	AC_SUBST(SDL_CFLAGS)
else
	AC_MSG_ERROR([*** SDL 1.2.x not found!])
fi


AC_ARG_WITH([libcdio],
            [AS_HELP_STRING([--with-libcdio],
              [support physical CD reading @<:@default=yes@:>@])],
            [],
            [with_libcdio=yes])

AC_ARG_WITH([libsndfile],
            [AS_HELP_STRING([--with-libsndfile],
              [support various sound file formats in ripped CD images @<:@default=yes@:>@])],
            [],
            [with_libsndfile=yes])

#AC_ARG_WITH([ogg-vorbis],
#           [AS_HELP_STRING([--with-ogg-vorbis],
#              [support Ogg Vorbis playback for ripped CD images @<:@default=yes@:>@])],
#            [],
#            [with_oggvorbis=yes])


AM_CONDITIONAL(WIN32, false)
AM_CONDITIONAL(UNIX, false)
if expr x"$target" : 'x.*-mingw*' > /dev/null; then
	CFLAGS="$CFLAGS"
	CPPFLAGS="$CPPFLAGS"
        AC_CHECK_HEADER([dsound.h],HAVE_DIRECTSOUND=true, HAVE_DIRECTSOUND=false)

        if $HAVE_DIRECTSOUND
        then
                AM_CONDITIONAL(HAVE_DIRECTSOUND,true)
                AC_DEFINE([HAVE_DIRECTSOUND], [1], [Define if we are compiling with DirectSound support.])
                LIBS="-ldxguid -lwinmm -ldsound $LIBS"
        fi

        AC_DEFINE([PSS_STYLE],[2], [Defines the filesystem path-separator type.])
	AC_DEFINE([WIN32], [1], [Define if we are compiling for Win32.])
	AM_CONDITIONAL(WIN32, true)

	LIBS="-mwindows -lwsock32 $LIBS -ldsound -lwinmm"

        if test x$with_libcdio = xyes; then
		LIBS="$LIBS -lcdio"
		AC_DEFINE([HAVE_LIBCDIO], [1], [Define if we are compiling with libcdio support.])
	fi

        if test x$with_libsndfile = xyes; then
                SNDFILE_LIBS="-lsndfile"
                SNDFILE_CFLAGS=""
                AC_DEFINE([HAVE_LIBSNDFILE], [1], [Define if we are compiling with libsndfile support.])
        fi
else
	CFLAGS="$CFLAGS"
	CPPFLAGS="$CPPFLAGS"

	if test x$with_libcdio = xyes; then
		PKG_CHECK_MODULES(LIBCDIO, libcdio, [], AC_MSG_ERROR([*** libcdio not found!]))
                AC_DEFINE([HAVE_LIBCDIO], [1], [Define if we are compiling with libcdio support.])

	fi

	if test x$with_libsndfile = xyes; then
		PKG_CHECK_MODULES(SNDFILE, sndfile >= 1.0.2, [], AC_MSG_ERROR([*** libsndfile >= 1.0.2 not found!]))
                AC_DEFINE([HAVE_LIBSNDFILE], [1], [Define if we are compiling with libsndfile support.])
	fi

        AC_DEFINE([PSS_STYLE],[1], [Defines the filesystem path-separator type.])
	AC_CHECK_HEADER([sys/soundcard.h],[AM_CONDITIONAL(HAVE_OSSDSP,true) AC_DEFINE([HAVE_OSSDSP], [1], [Define if we are compiling with OSS support.])])

	if expr x"$target" : 'x.*beos' > /dev/null; then
        	CFLAGS="-no-fpic $CFLAGS"
	        CPPFLAGS="-no-fpic $CPPFLAGS"
	fi
fi

dnl Check for SDL_net for net play
HAS_SDL_NET=yes

dnl FIXME:  The following library check breaks cross-compiling for Win32
dnl AC_CHECK_LIB([SDL_net], [SDLNet_Init],[],[HAS_SDL_NET=no])

CFLAGS_SDLNET_BACK="$CFLAGS"
CPPFLAGS_SDLNET_BACK="$CPPFLAGS"
CFLAGS="$CFLAGS $SDL_CFLAGS"
CPPFLAGS="$CFLAGS $SDL_CFLAGS"
AC_CHECK_HEADER([SDL_net.h],[], [HAS_SDL_NET=no])
if test x$HAS_SDL_NET = xno; then
	AC_MSG_ERROR([*** SDL_net not found!])	
fi
CFLAGS="$CFLAGS_SDLNET_BACK"
CPPFLAGS="$CPPFLAGS_SDLNET_BACK"

AC_DEFINE([NETWORK],[1], [Define if we are compiling with network play code.])
LIBS="$LIBS -lSDL_net"

AM_CONDITIONAL(ARCH_X86, false)
AM_CONDITIONAL(ARCH_POWERPC, false)
AM_CONDITIONAL(ARCH_POWERPC_ALTIVEC, false)

TRIO_CFLAGS=""

if expr x"$target_cpu" : 'xi.86' > /dev/null; then
        AC_DEFINE([ARCH_X86], [1], [Define if we are compiling for x86 architectures.])
        AM_CONDITIONAL(ARCH_X86, true)
elif expr x"$target_cpu" : 'xx86*' > /dev/null; then
        AC_DEFINE([ARCH_X86], [1], [Define if we are compiling for x86 architectures.])
        AM_CONDITIONAL(ARCH_X86, true)
elif expr x"$target_cpu" : 'xpowerpc' > /dev/null; then

	AC_DEFINE([ARCH_POWERPC], [1], [Define if we are compiling for PPC architectures.])
	AM_CONDITIONAL(ARCH_POWERPC, true)

	if test x$enable_altivec = xyes; then
		ALTIVEC_FLAGS=""
		AX_CFLAGS_GCC_OPTION([-faltivec], ALTIVEC_FLAGS)
		AX_CFLAGS_GCC_OPTION([-maltivec], ALTIVEC_FLAGS)
		if test "x$ALTIVEC_FLAGS" != "x"; then
			CFLAGS="$CFLAGS $ALTIVEC_FLAGS"
			CPPFLAGS="$CFLAGS $ALTIVEC_FLAGS"
		        AC_DEFINE([ARCH_POWERPC_ALTIVEC], [1], [Define if we are compiling with AltiVec usage.])
		        AM_CONDITIONAL(ARCH_POWERPC_ALTIVEC, true)
		fi
	fi

elif expr x"$target_cpu" : 'x*alpha*' > /dev/null; then
	AX_CFLAGS_GCC_OPTION([-mieee], TRIO_CFLAGS)
fi

AC_SUBST(TRIO_CFLAGS)

AC_C_BIGENDIAN([AC_DEFINE([MSB_FIRST],[1],[Define on big-endian platforms.])], 
[
 AC_DEFINE([LSB_FIRST],[1],[Define on little-endian platforms.])
 AC_DEFINE([MPC_LITTLE_ENDIAN],[1],[Define on little-endian platforms.])
])
AC_DEFINE_UNQUOTED([MEDNAFEN_VERSION],"$MEDNAFEN_VERSION", [Mednafen version definition.])
AC_DEFINE_UNQUOTED([MEDNAFEN_VERSION_NUMERIC],$MEDNAFEN_VERSION_NUMERIC, [Mednafen version numeric.])

AC_DEFINE([MPC_FIXED_POINT], [1], [Define to use fixed-point MPC decoder.])

AC_DEFINE([BLIP_BUFFER_ACCURACY], [20], [Blip Buffer resample ratio accuracy.])
AC_DEFINE([BLIP_PHASE_BITS], [8], [Blip Buffer phase bits count.])
AC_DEFINE([BLIP_MAX_QUALITY], [32], [Blip Buffer maximum quality.])

LIBS="$SNDFILE_LIBS $LIBCDIO_LIBS $LIBS"
CFLAGS="$LIBCDIO_CFLAGS $SNDFILE_CFLAGS $CFLAGS"
CPPFLAGS="$LIBCDIO_CFLAGS $SNDFILE_CFLAGS $CPPFLAGS"

dnl Output Makefiles
AC_OUTPUT([Makefile src/Makefile src/drivers/Makefile src/sexyal/Makefile src/tremor/Makefile src/mpcdec/Makefile src/trio/Makefile src/gb/Makefile src/gba/Makefile src/lynx/Makefile src/pce/Makefile src/pce_fast/Makefile src/pcfx/Makefile src/sms/Makefile src/vb/Makefile src/wswan/Makefile src/nes/Makefile src/snes/Makefile src/ngp/Makefile src/sound/Makefile src/hw_cpu/Makefile src/hw_misc/Makefile src/hw_sound/Makefile src/hw_video/Makefile src/md/Makefile src/demo/Makefile src/desa68/Makefile po/Makefile.in  intl/Makefile])
