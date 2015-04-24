CC?=gcc
STRIP?=strip
CFLAGS+=-Wall -O2

SOURCES=$(shell find src/ -type f -name '*.c')
EXE:=$(subst src,.,$(SOURCES))
EXE:=$(subst .c,,$(EXE))

all: $(EXE) strip

$(EXE): $(SOURCES)
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -o $@

strip:
	$(STRIP) $(EXE)

clean:
	rm -f $(EXE)

.PHONY: strip clean
