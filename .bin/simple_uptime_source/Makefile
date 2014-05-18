src=simple_uptime-1.1.tar.gz
srcdir=simple_uptime-1.1

all:
	tar zxf ${src}
	make -C ${srcdir}

clean:
	rm -rf ${srcdir}

install:
	cp ${srcdir}/simple_uptime ${HOME}/.bin
