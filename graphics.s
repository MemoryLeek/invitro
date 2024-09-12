.segment "ZEROPAGE"
.exportzp scroll_x, scroll_y, ppu_write_ptr, ppu_write_cnt
scroll_x: .res 1
scroll_y: .res 1
ppu_write_ptr: .res 2
ppu_write_cnt: .res 2

.segment "CODE"
.export ppu_write
; Takes the low byte of the PPU address in X and the high byte in Y.
; Writes ppu_write_cnt bytes from the address in ppu_write_ptr to the PPU.
ppu_write:
    bit $2002
    sty $2006
    stx $2006
    ldy #$00
@loop:
    lda (ppu_write_ptr),y
    sta $2007
    inc ppu_write_ptr
    bne :+
    inc ppu_write_ptr+1
:   dec ppu_write_cnt
    bne @loop
    dec ppu_write_cnt+1
    bne @loop
    rts

.segment "RODATA"
.export palette_invitro_a, screen0
palette_invitro_a:
    .byte $11,$00,$10,$30
    .byte $11,$0c,$21,$30
    .byte $11,$05,$30,$0f
    .byte $11,$0b,$1a,$29
screen0:
    .incbin "assets/scr0.nam"
    .incbin "assets/scr0.nam"

.segment "GRAPHICS"
.incbin "assets/chr0.chr"
.incbin "assets/chr1.chr"
