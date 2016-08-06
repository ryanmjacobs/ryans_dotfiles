custom_config=ryans_dwm_config.h
src=dwm-56a31dc.tar.gz
srcdir=dwm-56a31dc

all:
	tar zxf $(src)
	cp $(custom_config) $(srcdir)/config.h
	make -C $(srcdir)
	cp $(srcdir)/dwm .

clean:
	rm -rf $(srcdir)
	rm -f dwm
