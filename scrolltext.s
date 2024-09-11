.segment "ZEROPAGE"
offset: .res 1
ptr: .res 2
tmp: .res 1

.segment "SCROLLER" ; Nice hack if I say so myself, putting it last and having it zero-filled so I don't have to bother ending it
text:
    .res 32 ; Padding so the text starts off screen, I'm lazy like that
    .asciiz " Hello, World! This is a scrolling text demo. Watch the text go. See how it scrolls. Isn't it lame?"

.segment "CODE"
.import sprites
.importzp frame
.export scrolltext_init, scrolltext_update
scrolltext_init:
    ; Reset text pointer
    lda #.lobyte(text)
    sta ptr
    lda #.hibyte(text)
    sta ptr+1
    ; Position sprites along the X axis
    lda #$00
    ldx #$83 ; Use the last 32 sprites
:   sta sprites,x ; Byte 3 is the X position
    inx
    inx
    inx
    inx
    clc
    adc #$08
    cmp #$00
    bne :-
    rts
scrolltext_update:
    ; Update the Y position
    lda #$00
    ldx #$80 ; Use the last 32 sprites
:   pha
    clc
    adc offset
    tay
    lda sin_lut,y ; Per-letter sine wave
    sta tmp
    lda frame
    tay
    lda sin_lut,y ; Add global sine wave
    asl
    clc
    adc tmp
    sta sprites,x ; Byte 0 is the Y position
    pla
    inx
    inx
    inx
    pha
    clc
    adc offset
    sta sprites,x ; Byte 3 is the X position
    pla
    inx
    clc
    adc #$08
    cmp #$00
    bne :-
    ; Update the letters
    ldx #$81 ; Use the last 32 sprites, byte 1 is the tile index
    ldy #$00 ; Used as pointer offset
:   lda (ptr),y
    sta sprites,x
    inx
    inx
    inx
    inx
    iny
    tya
    cmp #$20
    bne :-
    ; Update the text pointer
    dec offset
    bpl :+
    lda #$07
    sta offset
    inc ptr
    bne :+
    inc ptr+1
:   rts

.segment "RODATA"
sin_lut:
    .byte $20 ,$20 ,$21 ,$22 ,$23 ,$23 ,$24 ,$25 ,$26 ,$27 ,$27 ,$28 ,$29 ,$2a ,$2a ,$2b
    .byte $2c ,$2c ,$2d ,$2e ,$2f ,$2f ,$30 ,$31 ,$31 ,$32 ,$33 ,$33 ,$34 ,$34 ,$35 ,$36
    .byte $36 ,$37 ,$37 ,$38 ,$38 ,$39 ,$39 ,$3a ,$3a ,$3b ,$3b ,$3b ,$3c ,$3c ,$3c ,$3d
    .byte $3d ,$3d ,$3e ,$3e ,$3e ,$3e ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f
    .byte $40 ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f ,$3f ,$3e ,$3e ,$3e ,$3e ,$3d
    .byte $3d ,$3d ,$3c ,$3c ,$3c ,$3b ,$3b ,$3b ,$3a ,$3a ,$39 ,$39 ,$38 ,$38 ,$37 ,$37
    .byte $36 ,$36 ,$35 ,$34 ,$34 ,$33 ,$33 ,$32 ,$31 ,$31 ,$30 ,$2f ,$2f ,$2e ,$2d ,$2c
    .byte $2c ,$2b ,$2a ,$2a ,$29 ,$28 ,$27 ,$27 ,$26 ,$25 ,$24 ,$23 ,$23 ,$22 ,$21 ,$20
    .byte $20 ,$1f ,$1e ,$1d ,$1c ,$1c ,$1b ,$1a ,$19 ,$18 ,$18 ,$17 ,$16 ,$15 ,$15 ,$14
    .byte $13 ,$13 ,$12 ,$11 ,$10 ,$10 ,$0f ,$0e ,$0e ,$0d ,$0c ,$0c ,$0b ,$0b ,$0a ,$09
    .byte $09 ,$08 ,$08 ,$07 ,$07 ,$06 ,$06 ,$05 ,$05 ,$04 ,$04 ,$04 ,$03 ,$03 ,$03 ,$02
    .byte $02 ,$02 ,$01 ,$01 ,$01 ,$01 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00
    .byte $00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$01 ,$01 ,$01 ,$01 ,$02
    .byte $02 ,$02 ,$03 ,$03 ,$03 ,$04 ,$04 ,$04 ,$05 ,$05 ,$06 ,$06 ,$07 ,$07 ,$08 ,$08
    .byte $09 ,$09 ,$0a ,$0b ,$0b ,$0c ,$0c ,$0d ,$0e ,$0e ,$0f ,$10 ,$10 ,$11 ,$12 ,$13
    .byte $13 ,$14 ,$15 ,$15 ,$16 ,$17 ,$18 ,$18 ,$19 ,$1a ,$1b ,$1c ,$1c ,$1d ,$1e ,$1f
