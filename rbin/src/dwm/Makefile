custom_config=ryans_dwm_config.h
src=dwm-6.2.tar.gz
srcdir=dwm-6.2

all:
	tar zxf $(src)
	cp -v config.mk $(srcdir)/
	cp -v $(custom_config) $(srcdir)/config.h
	make -C $(srcdir) X11INC=/usr/include/X11 X11LIB=/usr/lib/X11
	install -Dm 755 $(srcdir)/dwm ./dwm

clean:
	rm -rf $(srcdir)
	rm -f dwm
