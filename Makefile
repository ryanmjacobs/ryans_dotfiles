CC?=gcc
CFLAGS+=-Wall

SOURCES=$(shell find src/ -type f -name '*.c')
EXE:=$(subst src,.,$(SOURCES))
EXE:=$(subst .c,,$(EXE))

all: simple_uptime

$(EXE): $(SOURCES)
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -o $@

clean:
	rm -f simple_uptime

.PHONY: clean
