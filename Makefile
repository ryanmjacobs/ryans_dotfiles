CC?=gcc
CFLAGS+=-Wall

all: simple_uptime

simple_uptime: src/simple_uptime.c
	$(CC) $(CPPFLAGS) $(CFLAGS) src/simple_uptime.c -o simple_uptime

clean:
	rm -f simple_uptime

.PHONY: clean
