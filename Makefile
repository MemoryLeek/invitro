PROGRAM = invitro.nes
SOURCES = init.s main.s music.s graphics.s scrolltext.s

AS = ca65
ASFLAGS = -g
LD = ld65
LDFLAGS = -C cfg/nrom-256.cfg -m invitro.map --dbgfile invitro.dbg

OBJ = $(SOURCES:.s=.o)
OBJ := $(OBJ:.c=.o)

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

$(PROGRAM): $(OBJ)
	$(LD) -o $@ $(LDFLAGS) $^

.PHONY: all clean

all: $(PROGRAM)

clean:
	$(RM) $(OBJ) $(PROGRAM) invitro.map invitro.dbg
