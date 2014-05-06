PKG_FILE=dwm-6.0-1-x86_64.pkg.tar.xz

all:
	touch ${PKG_FILE}
	rm -v ${PKG_FILE}
	makepkg --skipchecksums

install:
	sudo pacman -U ${PKG_FILE}
