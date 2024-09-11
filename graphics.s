.segment "ZEROPAGE"
.exportzp scroll_x, scroll_y, ppu_write_ptr
scroll_x: .res 1
scroll_y: .res 1
ppu_write_ptr: .res 2

.segment "CODE"
.export ppu_write
; Takes the low byte of the PPU address in X and the high byte in Y
; and the number of bytes to write in A.
; Writes the bytes from the address in ppu_write_ptr to the PPU.
ppu_write:
    bit $2002
    sty $2006
    stx $2006
    tax ; X now holds number of bytes to write
    ldy #$00
:   lda (ppu_write_ptr),y
    sta $2007
    iny
    dex
    bne :-
    rts

.segment "RODATA"
.export palette_invitro_a, screen0
palette_invitro_a:
    .byte $07,$00,$10,$37
    .byte $07,$0c,$21,$30
    .byte $07,$05,$16,$0f
    .byte $07,$0b,$1a,$29
screen0:
    .incbin "assets/scr0.nam"

.segment "GRAPHICS"
.incbin "assets/chr0.chr"
.incbin "assets/chr1.chr"
