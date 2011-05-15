SUBDIRS	= po intl src

ACLOCAL_AMFLAGS = -I m4

EXTRA_DIST = m4/ChangeLog

VER=r3
PND_MAKE=$(HOME)/pandora-dev/sdk_utils/pnd_make.sh
pnd: src/mednafen
	rm -rf tmp
	mkdir -p tmp/lib
	cp src/.libs/mednafen tmp
	$(STRIP) tmp/mednafen
	cp libcdio/usr/lib/libcdio.so.10.0.0 tmp/lib/libcdio.so.10
	cp libSDL/libSDL-1.2.so.0 tmp/lib
	cp -r pandora/* tmp
	cp picklelauncher/build/picklelauncher tmp
	cp picklelauncher/build/DejaVuSansMono-Bold.ttf tmp

	$(PND_MAKE) -p mednafen-pce_$(VER).pnd -d tmp -x pandora/PXML.xml -i pandora/icon.png -c
source: 
	make clean
	make -C picklelauncher clean
	rm -f *.pnd
	rm -rf tmp
	cd .. && tar --exclude-vcs -cjvf mednafen-pce_$(VER)-src.tar.bz2 mednafen-0.9.16-wip
