.segment "ZEROPAGE"
.exportzp frame
frame: .res 2
bus_x: .res 1
bus_y: .res 1
bus_tmp: .res 1
bus_max: .res 3

.segment "OAM"
.export sprites
sprites: .res 256

.segment "CODE"
.import music_data_untitled, famistudio_init, famistudio_music_play, screen0, ppu_write, scrolltext_init, scrolltext_update, sin_lut
.importzp scroll_x, ppu_write_ptr, ppu_write_cnt
.export main
main:
    jsr scrolltext_init
    lda #$00 ; PAL
    ldx #.lobyte(music_data_untitled)
    ldy #.hibyte(music_data_untitled)
    jsr famistudio_init
    lda #$00 ; Track 0
    jsr famistudio_music_play
    ; Upload 1kB of PPU data (one full screen)
    lda #.lobyte(screen0)
    sta ppu_write_ptr
    lda #.hibyte(screen0)
    sta ppu_write_ptr+1
    lda #.lobyte($800)
    sta ppu_write_cnt
    lda #.hibyte($800)
    sta ppu_write_cnt+1
    ldx #.lobyte($2000)
    ldy #.hibyte($2000)
    jsr ppu_write
    ; Puked up some party bus setup
    lda #$48
    sta bus_max
    lda #$58
    sta bus_max+1
    lda #$68
    sta bus_max+2
    lda #$01
    sta bus_x
    tax
    lda sin_lut,x
    lsr
    lsr
    clc
    adc #$c0
    sta bus_y
    ; Enable rendering
    bit $2002
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
@loop:
    jsr wait_nmi
    jsr scrolltext_update
    jsr partymobile
    ; Check if we should show the end screen, 2600 frames
    lda frame+1
    cmp #$0a
    bne :+
    lda frame
    cmp #$28
    bne :+
    jmp endscene
:   lda frame
    and #$07
    bne @end
    inc bus_x
    lda bus_x
    cmp #$c8
    bne :+
    jsr shorten_bus
:   cmp #$d0
    bne :+
    jsr shorten_bus
:   cmp #$d8
    bne :+
    jsr shorten_bus
:   cmp #$e0
    bne :+
    jsr shorten_bus
:   cmp #$e8
    bne :+
    jsr shorten_bus
:   cmp #$f0
    bne :+
    jsr shorten_bus
:   cmp #$f8
    bne :+
    jsr shorten_bus
:   cmp #$00
    bne :+
    jsr shorten_bus
:   tax
    lda sin_lut,x
    lsr
    lsr
    clc
    adc #$c0
    sta bus_y
    lda scroll_x
    cmp #$ff
    beq @end
    inc scroll_x
@end:
    jmp @loop

shorten_bus:
    dec bus_max
    dec bus_max+1
    dec bus_max+2
    rts

; $40-$47
; $50-$57
; $60-$67
partymobile:
    lda bus_max
    cmp #$40
    bne @drawbus
    ldx #$00
:   lda #$ff
    sta sprites,x
    inx
    inx
    inx
    inx
    txa
    cmp #$60
    bne :-
    rts
@drawbus:
    ldy #$40
    ldx #$00
    stx bus_tmp
:   lda bus_y
    sta sprites,x
    inx
    tya
    sta sprites,x
    inx
    lda #%00000010
    sta sprites,x
    inx
    lda bus_tmp
    clc
    adc bus_x
    sta sprites,x
    inx
    iny
    lda bus_tmp
    clc
    adc #$08
    sta bus_tmp
    tya
    cmp bus_max
    bne :-
    ldy #$50
    ldx #$20
    lda #$00
    sta bus_tmp
:   lda bus_y
    clc
    adc #$08
    sta sprites,x
    inx
    tya
    sta sprites,x
    inx
    lda #%00000010
    sta sprites,x
    inx
    lda bus_tmp
    clc
    adc bus_x
    sta sprites,x
    inx
    iny
    lda bus_tmp
    clc
    adc #$08
    sta bus_tmp
    tya
    cmp bus_max+1
    bne :-
    ldy #$60
    ldx #$40
    lda #$00
    sta bus_tmp
:   lda bus_y
    clc
    adc #$10
    sta sprites,x
    inx
    tya
    sta sprites,x
    inx
    lda #%00000001
    sta sprites,x
    inx
    lda bus_tmp
    clc
    adc bus_x
    sta sprites,x
    inx
    iny
    lda bus_tmp
    clc
    adc #$08
    sta bus_tmp
    tya
    cmp bus_max+2
    bne :-
    rts

.import end_screen, palette_invitro_c
endscene:
    ; Disable rendering
    lda #%00000000
    lda #$00
    sta $2000
    sta $2001
    lda #.lobyte(end_screen)
    sta ppu_write_ptr
    lda #.hibyte(end_screen)
    sta ppu_write_ptr+1
    lda #.lobyte($400)
    sta ppu_write_cnt
    lda #.hibyte($400)
    sta ppu_write_cnt+1
    ldx #.lobyte($2000)
    ldy #.hibyte($2000)
    jsr ppu_write
    lda #$00
    sta scroll_x
    sta scroll_x+1
    ; Write end-screen palette
    lda #$3f
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
:   lda palette_invitro_c,x
    sta $2007
    inx
    cpx #$10 ; 16 bytes in the palette
    bne :-
    ; Re-enable rendering
    bit $2002
    lda #%10010000
    sta $2000
    lda #%00001110
    sta $2001
@loop:
    jmp @loop

wait_nmi:
    lda frame
:   cmp frame
    beq :-
    rts
