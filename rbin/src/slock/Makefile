src=slock-1.4.tar.gz
srcdir=slock-1.4
custom_config=ryans_slock_config.h

all:
	tar zxf $(src)
	cp -v $(custom_config) $(srcdir)/config.h
	make -C $(srcdir) X11INC=/usr/include/X11 X11LIB=/usr/lib/X11
	install -Dm 755 $(srcdir)/slock ./slock

clean:
	rm -rf $(srcdir)
	rm -f slock
