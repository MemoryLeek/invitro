.segment "ZEROPAGE"
.exportzp frame
frame: .res 2

.segment "OAM"
.export sprites
sprites: .res 256

.segment "CODE"
.import music_data_untitled, famistudio_init, famistudio_music_play, scrolltext_init, scrolltext_update
.export main
main:
    jsr scrolltext_init
    lda #$00 ; PAL
    ldx #.lobyte(music_data_untitled)
    ldy #.hibyte(music_data_untitled)
    jsr famistudio_init
    lda #$00 ; Track 0
    jsr famistudio_music_play
    lda #%10001000
    sta $2000
    lda #%00011000
    sta $2001
@loop:
    jsr wait_nmi
    jsr scrolltext_update
    jmp @loop

wait_nmi:
    lda frame
:   cmp frame
    beq :-
    rts
