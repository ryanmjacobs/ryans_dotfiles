CC?=gcc
STRIP?=strip

EXE=we dwmstatus simple_uptime

all: dwm strip we dwmstatus simple_uptime dns

dwm:
	make -C./src/dwm
	mv ./src/dwm/dwm .
	make -C./src/dwm clean

we: src/we.c
	$(CC) -Wall -O2 -std=c89 -pedantic src/we.c -o we
dns: src/dns.c
	$(CC) -Wall -O2 -std=c89 -pedantic src/dns.c -o dns
dwmstatus: src/dwmstatus.c
	$(CC) -Wall -O2 -std=c89 -pedantic src/dwmstatus.c -lX11 -o dwmstatus
simple_uptime: src/simple_uptime.c
	$(CC) -Wall -O2 -std=c89 -pedantic src/simple_uptime.c -o simple_uptime

strip: dwm $(EXE)
	$(STRIP) $(EXE) dwm

clean:
	rm -f $(EXE) dwm

.PHONY: strip clean dwm
