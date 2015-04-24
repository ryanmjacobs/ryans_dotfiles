CC?=gcc
STRIP?=strip
CFLAGS+=-Wall -O2

SOURCES=$(shell find src/ -type f -name '*.c')
EXE:=$(subst src,.,$(SOURCES))
EXE:=$(subst .c,,$(EXE))

all: $(EXE)

$(EXE): $(SOURCES)
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -o $@
	$(STRIP) $@

clean:
	rm -f simple_uptime

.PHONY: clean
