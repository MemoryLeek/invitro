.segment "RODATA"
.export palette_invitro_a
palette_invitro_a:
    .byte $0f,$00,$10,$30
    .byte $0f,$0c,$21,$32
    .byte $0f,$05,$16,$27
    .byte $0f,$0b,$1a,$29

.segment "GRAPHICS"
.incbin "assets/chr0.chr"
.incbin "assets/chr1.chr"
