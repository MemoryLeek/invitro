FAMISTUDIO_CFG_EXTERNAL = 1
FAMISTUDIO_CFG_C_BINDINGS = 0
FAMISTUDIO_CFG_PAL_SUPPORT = 1

.define FAMISTUDIO_CA65_ZP_SEGMENT   ZEROPAGE
.define FAMISTUDIO_CA65_RAM_SEGMENT  BSS
.define FAMISTUDIO_CA65_CODE_SEGMENT CODE

.include "third-party/famistudio_ca65.s"

.segment "RODATA"
.include "music.inc"