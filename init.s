.include "third-party/nes2header.inc"
nes2mapper 0 ; NROM
nes2prg 32768 ; NROM-256
nes2chr 8192
nes2mirror 'V'
nes2tv 'P'
nes2end

.segment "VECTORS"
.word nmi
.word reset
.word irq

.segment "CODE"
.import main, sprites, palette_invitro_a
reset:
    sei
    cld
    lda #$40
    sta $4017
    lda #$00
    sta $2000
    sta $2001
    sta $4010
    sta $4015
    ldx #$ff
    txs
    inx
    ; Wait for first vblank
    bit $2002
:   bit $2002
    bpl :-
    ; Clear RAM
:   sta $0000,x
    sta $0100,x
    sta $0200,x
    sta $0300,x
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne :-
    ; Move all sprites off screen
    lda #255
:   sta sprites,x
    inx
    inx
    inx
    inx
    bne :-
    ; Wait for second vblank
:   bit $2002
    bpl :-
    ; Set up the background palette
    lda #$3f
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
:   lda palette_invitro_a,x
    sta $2007
    inx
    cpx #$10 ; 16 bytes in the palette
    bne :-
    ; Set up the sprite palette
    lda #$3f
    sta $2006
    lda #$10
    sta $2006
    ldx #$00
:   lda palette_invitro_a,x
    sta $2007
    inx
    cpx #$10 ; 16 bytes in the palette
    bne :-
    jmp main

.import famistudio_update
.importzp scroll_x, scroll_y, frame
nmi:
    pha
    txa
    pha
    tya
    pha
    ; Perform OAM DMA transfer
    lda #$00
    sta $2003
    lda #.hibyte(sprites)
    sta $4014
    ; Reset scroll - this must ALWAYS be done after ANY write to $2006
    bit $2002
    lda scroll_x
    sta $2005
    lda scroll_y
    sta $2005
    ; Run the music engine
    jsr famistudio_update
    ; Increment frame counter
    inc frame
    bne :+
    inc frame+1
:   pla
    tay
    pla
    tax
    pla
    rti

irq:
    rti
