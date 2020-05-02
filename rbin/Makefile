CC?=cc

EXE=we dwmstatus simple_uptime ao dns

all: $(EXE) dwm slock

dwm:
	make -C./src/dwm
	install -Dm 775 ./src/dwm/dwm ./dwm
	make -C./src/dwm clean
slock:
	make -C./src/slock
	install -Dm 775 ./src/slock/slock ./slock
	make -C./src/slock clean

dwmstatus: src/dwmstatus.c
	$(CC) -Wall -O2 -std=c99 -pedantic $^\
		-lX11 `pkg-config --cflags --libs libnotify` -o $@

%: src/%.c
	$(CC) -Wall -O2 -std=c99 -pedantic $^ -o $@

clean:
	rm -f $(EXE) dwm slock

.PHONY: clean
