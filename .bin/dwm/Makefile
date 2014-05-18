custom_config="ryans_dwm_config.h"
src="dwm-6.0.tar.gz"
srcdir="dwm-6.0"

all:
	tar zxf ${src}
	cp ${custom_config} ${srcdir}/config.h
	sed -i 's/CPPFLAGS =/CPPFLAGS +=/g'         ${srcdir}/config.mk
	sed -i 's/^CFLAGS = -g/#CFLAGS += -g/g'     ${srcdir}/config.mk
	sed -i 's/^#CFLAGS = -std/CFLAGS += -std/g' ${srcdir}/config.mk
	sed -i 's/^LDFLAGS = -g/#LDFLAGS += -g/g'   ${srcdir}/config.mk
	sed -i 's/^#LDFLAGS = -s/LDFLAGS += -s/g'   ${srcdir}/config.mk
	make -C ${srcdir} X11INC=/usr/include/X11 X11LIB=/usr/lib/X11

clean:
	rm -rf ${srcdir}
	rm -f dwm

install:
	cp ${srcdir}/dwm .
