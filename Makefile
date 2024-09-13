PROGRAM = brown2024
SOURCES = init.s main.s music.s graphics.s scrolltext.s

AS = ca65
ASFLAGS = -g
LD = ld65
LDFLAGS = -C cfg/nrom-128.cfg -m $(PROGRAM).map --dbgfile $(PROGRAM).dbg

OBJ = $(SOURCES:.s=.o)
OBJ := $(OBJ:.c=.o)

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

$(PROGRAM): $(OBJ)
	$(LD) -o $@.nes $(LDFLAGS) $^

.PHONY: all clean

all: $(PROGRAM)

clean:
	$(RM) $(OBJ) $(PROGRAM) $(PROGRAM).map $(PROGRAM).dbg
