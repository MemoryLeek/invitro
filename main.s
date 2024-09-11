.segment "ZEROPAGE"
.exportzp frame
frame: .res 2

.segment "OAM"
.export sprites
sprites: .res 256

.segment "CODE"
.import music_data_untitled, famistudio_init, famistudio_music_play, screen0, ppu_write, scrolltext_init, scrolltext_update
.importzp scroll_x, ppu_write_ptr
.export main
main:
    jsr scrolltext_init
    lda #$00 ; PAL
    ldx #.lobyte(music_data_untitled)
    ldy #.hibyte(music_data_untitled)
    jsr famistudio_init
    lda #$00 ; Track 0
    jsr famistudio_music_play
    ; Upload PPU data (4x 256B chunks), yeah, this should be refactored
    lda #.lobyte(screen0)
    sta ppu_write_ptr
    lda #.hibyte(screen0)
    sta ppu_write_ptr+1
    ldx #.lobyte($2000)
    ldy #.hibyte($2000)
    lda #$00
    jsr ppu_write
    lda #.lobyte(screen0+$100)
    sta ppu_write_ptr
    lda #.hibyte(screen0+$100)
    sta ppu_write_ptr+1
    ldx #.lobyte($2100)
    ldy #.hibyte($2100)
    lda #$00
    jsr ppu_write
    lda #.lobyte(screen0+$200)
    sta ppu_write_ptr
    lda #.hibyte(screen0+$200)
    sta ppu_write_ptr+1
    ldx #.lobyte($2200)
    ldy #.hibyte($2200)
    lda #$00
    jsr ppu_write
    lda #.lobyte(screen0+$300)
    sta ppu_write_ptr
    lda #.hibyte(screen0+$300)
    sta ppu_write_ptr+1
    ldx #.lobyte($2300)
    ldy #.hibyte($2300)
    lda #$00
    jsr ppu_write
    ; Enable rendering
    bit $2002
    lda #%10001000
    sta $2000
    lda #%00011110
    sta $2001
@loop:
    jsr wait_nmi
    jsr scrolltext_update
    lda frame
    and #$03
    bne :+
    inc scroll_x
:   jmp @loop

wait_nmi:
    lda frame
:   cmp frame
    beq :-
    rts
