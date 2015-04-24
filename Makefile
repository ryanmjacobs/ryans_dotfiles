CC?=gcc
STRIP?=strip
CFLAGS+=-Wall -O2

SOURCES=$(shell find src/ -type f -name '*.c')
EXE:=$(subst src,.,$(SOURCES))
EXE:=$(subst .c,,$(EXE))

all: $(EXE) dwm strip

$(EXE): $(SOURCES)
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -o $@

dwm:
	make -C./src/dwm
	mv ./src/dwm/dwm .
	make -C./src/dwm clean

strip:
	$(STRIP) $(EXE) dwm

clean:
	rm -f $(EXE) dwm

.PHONY: strip clean dwm
