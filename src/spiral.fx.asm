    .zp
breaking_news  .ds 2
news_start     .ds 2
news_limit     .ds 1
news_delta     .ds 1
news_delay     .ds 1
news_rcr       .ds 2
news_str.ptr   .ds 2
news_str.idx   .ds 1
    .code

SPIRAL_VDC_DISPLAY_FLAG = VDC_CR_RW_INC_1 | VDC_CR_BG_ENABLE | VDC_CR_SPR_ENABLE | VDC_CR_VBLANK_ENABLE | VDC_CR_HBLANK_ENABLE

SPIRAL_16x16_VRAM_ADDR  = $2040
SPIRAL_32x32_VRAM_ADDR  = $2200

SPIRAL_BREAKING_NEWS_VRAM_ADDR = $2a00
SPIRAL_BREAKING_NEWS_WIDTH     = 16
SPIRAL_BREAKING_NEWS_HEIGHT    = 1
SPIRAL_BREAKING_NEWS_X         = 0
SPIRAL_BREAKING_NEWS_Y         = 24
SPIRAL_BREAKING_NEWS_PAL       = 1
SPIRAL_BREAKING_NEWS_BASE      = ((SPIRAL_BREAKING_NEWS_PAL << 12) | (SPIRAL_BREAKING_NEWS_VRAM_ADDR  >> 4))

SPIRAL_LIVE_VRAM_ADDR = $2b00
SPIRAL_LIVE_WIDTH     = 4
SPIRAL_LIVE_HEIGHT    = 2
SPIRAL_LIVE_X         = 0
SPIRAL_LIVE_Y         = 2
SPIRAL_LIVE_PAL       = 2
SPIRAL_LIVE_BASE      = ((SPIRAL_LIVE_PAL << 12) | (SPIRAL_LIVE_VRAM_ADDR  >> 4))

SPIRAL_NEWS_VRAM_ADDR = $2b80
SPIRAL_NEWS_WIDTH     = 32
SPIRAL_NEWS_HEIGHT    = 5 
SPIRAL_NEWS_X         = 0
SPIRAL_NEWS_Y         = SPIRAL_BREAKING_NEWS_Y+1
SPIRAL_NEWS_PAL       = 3
SPIRAL_NEWS_BASE      = ((SPIRAL_NEWS_PAL << 12) | (SPIRAL_NEWS_VRAM_ADDR  >> 4))
SPIRAL_NEWS_BAT_ADDR  = SPIRAL_NEWS_X + (SPIRAL_NEWS_Y * 32)
SPIRAL_NEWS_DELAY     = 200

spiral_fg:
    ; Load "breaking_news" gfx palette
    stw    #16, color_reg
    tia    breaking_news.pal, color_data, 32
    ; Load "live" gfx palette
    tia    live.pal, color_data, 32
    ; Load "font" gfx palette
    tia    news.font.pal, color_data, 32
    
    ; Load "breaking_news" tiles
    vdc_reg #VDC_MAWR
    vdc_data #SPIRAL_BREAKING_NEWS_VRAM_ADDR
    vdc_reg #VDC_DATA
    tia     breaking_news.tiles, video_data, breaking_news.end-breaking_news.tiles
    ; Load "live" tiles
    tia     live.tiles, video_data, live.end-live.tiles
    ; Loaf "font" tiles
    tia     news.font.tiles, video_data, news.font.end-news.font.tiles

    ; "Draw breaking news"
    ldx    #SPIRAL_BREAKING_NEWS_X
    lda    #SPIRAL_BREAKING_NEWS_Y
    jsr    vdc_calc_addr
    jsr    vdc_set_write   
    ldy    #02
.l0:
        stw    #SPIRAL_BREAKING_NEWS_BASE, <_si
        ldx    #16
.l1:
        stw    <_si, video_data
        incw   <_si
        dex
        bne    .l1
    dey
    bne    .l0

    ; "Draw live"
    ldx    #SPIRAL_LIVE_X
    lda    #SPIRAL_LIVE_Y
    jsr    vdc_calc_addr
    jsr    vdc_set_write
    
    st1    #low(SPIRAL_LIVE_BASE)
    st2    #high(SPIRAL_LIVE_BASE)
    
    st1    #low(SPIRAL_LIVE_BASE+1)
    st2    #high(SPIRAL_LIVE_BASE+1)
    
    st1    #low(SPIRAL_LIVE_BASE+2)
    st2    #high(SPIRAL_LIVE_BASE+2)
    
    st1    #low(SPIRAL_LIVE_BASE+3)
    st2    #high(SPIRAL_LIVE_BASE+3)

    vdc_reg  #VDC_MAWR
    addw   <_di, vdc_bat_width, video_data
    vdc_reg  #VDC_DATA

    st1    #low(SPIRAL_LIVE_BASE+4)
    st2    #high(SPIRAL_LIVE_BASE+4)
    
    st1    #low(SPIRAL_LIVE_BASE+5)
    st2    #high(SPIRAL_LIVE_BASE+5)
    
    st1    #low(SPIRAL_LIVE_BASE+6)
    st2    #high(SPIRAL_LIVE_BASE+6)
    
    st1    #low(SPIRAL_LIVE_BASE+7)
    st2    #high(SPIRAL_LIVE_BASE+7)

    ; "Draw news panel"
    vdc_reg #VDC_MAWR
    vdc_data #SPIRAL_NEWS_BAT_ADDR
    vdc_reg #VDC_DATA

    ldy    #SPIRAL_NEWS_HEIGHT
.l2:
        ldx    #32
.l3:
        st1    #low(SPIRAL_NEWS_BASE)
        st2    #high(SPIRAL_NEWS_BASE)
        dex
        bne    .l3
    dey
    bne    .l2

    rts

spiral.init:
    vdc_reg  #VDC_CR
    vdc_data #$0000

    vdc_reg  #VDC_CR
    vdc_data #SPIRAL_VDC_DISPLAY_FLAG

    irq_on #INT_IRQ1
    irq_enable_vec #VSYNC
    irq_set_vec #VSYNC, #spiral.vsync
    irq_enable_vec #HSYNC
    irq_set_vec #HSYNC, #spiral.hsync

    ; Clear tile
    vdc_reg #VDC_MAWR
    vdc_data #$2000
    vdc_reg #VDC_DATA
    st1   #$00
    ldx   #32
.clear:
    st2   #$00
    dex
    bne   .clear
    
    ; Clear BAT
    vdc_reg #VDC_MAWR
    vdc_data #$0000
    vdc_reg #VDC_DATA
    st1    #low($2000>>4)
    st2    #high($2000>>4)
    st2    #high($2000>>4)

    st0    #VDC_DMA_SRC
    st1    #low($0000)
    st2    #high($0000)

    st0    #VDC_DMA_DST
    st1    #low($0002)
    st2    #high($0002)

    st0    #VDC_DMA_LEN
    st1    #low(32*32 - 2)
    st2    #high(32*32 - 2)

    ; Map data banks
    lda    #bank(spiral_data)
    tam    #$04
    
    inc    A
    tam    #$05

    ; Set sprite palette
    stw    #$0100, color_reg
    tia    spiral_sprites.pal, color_data, 32

    ; Load 16x16 sprites
    vdc_reg  #VDC_MAWR
    vdc_data #SPIRAL_16x16_VRAM_ADDR
    vdc_reg  #VDC_DATA
    tia   spiral_sprites_16.bin, video_data, spiral_sprites_32.bin-spiral_sprites_16.bin

    ; Load 32x32 sprite
    vdc_reg  #VDC_MAWR
    vdc_data #SPIRAL_32x32_VRAM_ADDR
    vdc_reg  #VDC_DATA
    tia   spiral_sprites_32.bin, video_data, spiral_sprites_end-spiral_sprites_32.bin

    jsr    spiral_fg

    ; Load ramcode
    tii    ramcode_begin, spiral, ramcode_end-ramcode_begin

    st0    #$0f     ; Enable VRAM SATB DMA
    st1    #$10 
    st2    #$00
    
    st0    #$13     ; Set SATB address
    st1    #low($4000)              ; [todo]
    st2    #high($4000)             ; [todo]

    st0    #$07
    st1    #$00
    st2    #$00

    st0    #$08
    st1    #$00
    st2    #$00

    jsr    spiral.start

    lda    news.count
    sta    <news_str.idx
    stw    #news.txt, <news_str.ptr
    jsr    spiral.print
    
    rts

spiral.news.update:

        lda    <news_delta
        cmp    #$ff
        beq    .l0
        cmp    #$00
        beq    .l1
        ; down
        lda    <news_start
        cmp    <news_limit
        bne    .end
.l3:
        lda    <news_delay
        beq    .l4
            dec    <news_delay
            bne    .end
                lda    #(SPIRAL_NEWS_HEIGHT * 8)
                sta    <news_start
                stz    <news_limit
                lda    #$ff
                sta    <news_delta
;                bra    .end
                jmp    spiral.print
.l4:
        lda    #60
        sta    <news_delay
        bra    .end
        ; display
.l1:
        lda    <news_delay
        beq    .l2
            dec    <news_delay
            bra    .end
.l2:
        lda    #$01
        sta    <news_delta
        lda    #(SPIRAL_NEWS_HEIGHT * 8)
        sta    <news_limit
        bra    .end
        ; up
.l0:
        lda    <news_start
        bne    .end
            lda    #SPIRAL_NEWS_DELAY
            sta    <news_delay
            stz    <news_delta
.end:
    rts

spiral.start:
    stz    <breaking_news

    lda    #(SPIRAL_NEWS_HEIGHT * 8)
    sta    <news_start

    stz    <news_limit
    
    lda    #$ff
    sta    <news_delta
    
    stz    <news_delay

    rts

spiral.print:
    stw    #(SPIRAL_NEWS_BAT_ADDR), <_di
    cly    
.l0:
    vdc_reg #VDC_MAWR
    vdc_data <_di
    vdc_reg #VDC_DATA
.l1:
    clc
    lda    [news_str.ptr], Y
    bmi    .l2
    adc    #low(SPIRAL_NEWS_BASE)
    sta    video_data_l
    cla
    adc    #high(SPIRAL_NEWS_BASE)
    sta    video_data_h
    iny
    cpy    #32
    bne    .l1
        addw   #64, <_di
        bra    .l0
.l2:

    stw    #(SPIRAL_NEWS_BAT_ADDR+32), <_di
    cly    
.l3:
    vdc_reg #VDC_MAWR
    vdc_data <_di
    vdc_reg #VDC_DATA
.l4:
    clc
    lda    [news_str.ptr], Y
    bmi    .l5
    adc    #low(SPIRAL_NEWS_BASE+1)
    sta    video_data_l
    cla
    adc    #high(SPIRAL_NEWS_BASE+1)
    sta    video_data_h
    iny
    cpy    #32
    bne    .l4
        addw   #64, <_di
        bra    .l3
.l5:
    dec    <news_str.idx
    beq    .reset
        iny
        tya
        clc
        adc    <news_str.ptr
        sta    <news_str.ptr
        bcc    .l6
            inc    <news_str.ptr+1
.l6:
    rts
.reset:
    lda    news.count
    sta    <news_str.idx
    stw    #news.txt, <news_str.ptr
    rts

spiral.1:
;    jsr    spiral.start
    cli
.loop:
        jsr    spiral_update
        
        vdc_wait_vsync #$01

        jsr    spiral.news.update

        decw   <_fx.counter
        ora    <_fx.counter
        bne    .loop
    rts

spiral.2:
;    jsr    spiral.start
    cli
.loop:
        jsr    spiral_update_2
        
        vdc_wait_vsync #$01

        jsr    spiral.news.update

        decw   <_fx.counter
        ora    <_fx.counter
        bne    .loop
    rts

spiral.3:
;    jsr    spiral.start
    cli
.loop:
        jsr    spiral_update_3
        
        vdc_wait_vsync #$01
 
        jsr    spiral.news.update

        decw   <_fx.counter
        ora    <_fx.counter
        bne    .loop
    rts

spiral.vsync:
    st0    #VDC_BXR
    st1    #$00
    st2    #$00
    
    st0    #VDC_BYR
    st1    #$00
    st2    #$00

    lda    #HSYNC
    asl    A
    tax
    lda    #low(spiral.hsync)
    sta    user_hook, X
    inx
    lda    #high(spiral.hsync)
    sta    user_hook, X

    inc    <breaking_news

    st0    #VDC_RCR
    st1    #low(VDC_RCR_START + (SPIRAL_BREAKING_NEWS_Y*8))
    st2    #high(VDC_RCR_START + (SPIRAL_BREAKING_NEWS_Y*8))

    lda    <news_start
    sta    <news_start+1
    cmp    <news_limit
    beq    .l0
        lda    <news_start
        clc
        adc    <news_delta
        sta    <news_start
.l0:

    jsr    vgm_update
    
    ply
    plx
    pla
    rti

spiral.hsync:
    st0    #VDC_BXR
    lda    <breaking_news
    sta    video_data
    st2    #$00

    lda    #HSYNC
    asl    A
    tax
    lda    #low(spiral.hsync.news)
    sta    user_hook, X
    inx
    lda    #high(spiral.hsync.news)
    sta    user_hook, X

    st0    #VDC_RCR
    st1    #low(VDC_RCR_START + (SPIRAL_NEWS_Y*8) + 2)
    st2    #high(VDC_RCR_START + (SPIRAL_NEWS_Y*8) + 2)
    
    lda    #low(VDC_RCR_START + (SPIRAL_NEWS_Y*8) + 2)
    sta    <news_rcr
    lda    #high(VDC_RCR_START + (SPIRAL_NEWS_Y*8) + 2)
    sta    <news_rcr+1
    
    ply
    plx
    pla
    rti

spiral.hsync.news:
    st0    #VDC_BXR
    st1    #$00
    st2    #$00

    st0    #VDC_BYR
    st1    #low(SPIRAL_NEWS_Y*8)
    st2    #high(SPIRAL_NEWS_Y*8)
    
    lda    <news_start+1
    beq    .nothing
        dec    <news_start+1
        
        incw   <news_rcr
        st0    #VDC_RCR
        stw    <news_rcr, video_data    
.nothing:
    ply
    plx
    pla
    rti

    .data
    .bank 1
    .org $8000
spiral_data:
ramcode_begin:
    .incbin "data/spiral.ramcode.bin"
ramcode_end:
    .include "data/spiral.ramcode.inc"

breaking_news.pal:
    .incbin "data/news/breaking_news_0000.pal"
breaking_news.tiles:
    .incbin "data/news/breaking_news_0000.tiles"
breaking_news.end:

live.pal:
    .incbin "data/news/live_0000.pal"
live.tiles:
    .incbin "data/news/live_0000.tiles"
live.end:

news.font.pal:
    .incbin "data/news/font.pal"
news.font.tiles:
    .incbin "data/news/font.tiles"
news.font.end:
news.txt:
    .db $26,$2e,$0a,$08,$0a,$1c,$54,$00,$00,$00,$1e,$1c,$06,$0a,$00,$00
    .db $02,$0e,$02,$12,$1c,$00,$00,$2a,$20,$24,$1e,$2a,$0e,$10,$00,$00
    .db $24,$0a,$18,$0a,$02,$26,$0a,$08,$00,$00,$02,$00,$00,$24,$2a,$26
    .db $10,$0a,$08,$00,$00,$20,$24,$1e,$08,$2a,$06,$28,$12,$1e,$1c,$00
    .db $ff
    .db $1e,$1c,$00,$20,$06,$00,$0a,$1c,$0e,$12,$1c,$0a,$4c,$00,$00,$28
    .db $10,$0a,$00,$24,$1e,$32,$02,$18,$00,$0c,$02,$1a,$12,$18,$32,$00
    .db $08,$0a,$06,$18,$02,$24,$0a,$08,$00,$28,$10,$02,$28,$00,$1c,$0a
    .db $30,$28,$00,$28,$12,$1a,$0a,$4a,$00,$28,$10,$0a,$32,$00,$00,$00
    .db $ff
    .db $2e,$12,$18,$18,$00,$02,$18,$18,$00,$04,$0a,$00,$08,$0a,$20,$1e
    .db $24,$28,$0a,$08,$00,$28,$1e,$00,$08,$0a,$1c,$1a,$02,$24,$16,$00
    .db $2e,$12,$28,$10,$00,$1c,$1e,$00,$2a,$1c,$08,$0a,$24,$2e,$0a,$02
    .db $24,$50,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $ff
    .db $1a,$1e,$1e,$34,$00,$00,$02,$1c,$08,$00,$00,$1e,$06,$28,$02,$20
    .db $2a,$26,$00,$02,$24,$0a,$00,$1c,$1e,$2e,$00,$2a,$1c,$08,$0a,$24
    .db $28,$10,$0a,$00,$00,$26,$06,$24,$2a,$28,$12,$1c,$12,$28,$32,$00
    .db $00,$1e,$0c,$00,$28,$10,$0a,$00,$26,$2e,$0a,$08,$12,$26,$10,$00
    .db $ff
    .db $1c,$12,$1c,$14,$02,$00,$06,$1e,$1a,$1a,$02,$1c,$08,$1e,$26,$4c
    .db $00,$00,$32,$1e,$2a,$00,$16,$1c,$1e,$2e,$00,$2e,$10,$02,$28,$00
    .db $32,$1e,$2a,$00,$02,$24,$0a,$00,$2a,$20,$00,$28,$1e,$00,$20,$2a
    .db $1c,$16,$26,$50,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $ff
    .db $28,$10,$0a,$00,$00,$06,$0a,$1c,$28,$0a,$24,$00,$00,$0c,$1e,$24
    .db $00,$00,$02,$20,$20,$24,$1e,$30,$12,$1a,$02,$28,$12,$2c,$0a,$00
    .db $26,$06,$12,$0a,$1c,$28,$12,$0c,$12,$06,$00,$00,$26,$28,$2a,$08
    .db $12,$0a,$26,$00,$00,$02,$1c,$1c,$1e,$2a,$1c,$06,$0a,$08,$00,$00
    .db $ff
    .db $28,$10,$02,$28,$00,$00,$1a,$2a,$26,$28,$02,$06,$10,$0a,$26,$00
    .db $02,$24,$0a,$00,$1c,$1e,$28,$00,$1a,$02,$08,$0a,$00,$1e,$0c,$00
    .db $02,$18,$12,$0a,$1c,$00,$00,$2e,$1e,$24,$1a,$26,$4c,$00,$00,$28
    .db $10,$0a,$32,$00,$02,$24,$0a,$00,$12,$1c,$00,$0c,$02,$06,$28,$00
    .db $ff
    .db $1a,$02,$08,$0a,$00,$1e,$2a,$28,$00,$1e,$0c,$00,$18,$0a,$0c,$28
    .db $00,$1e,$2c,$0a,$24,$00,$26,$20,$02,$0e,$10,$0a,$28,$28,$12,$00
    .db $32,$1e,$2a,$00,$02,$24,$0a,$00,$02,$08,$2c,$12,$26,$0a,$08,$00
    .db $1c,$1e,$28,$00,$28,$1e,$00,$0a,$02,$28,$00,$28,$10,$0a,$1a,$4c
    .db $ff
    .db $0a,$2c,$0a,$1c,$00,$2e,$12,$28,$10,$00,$06,$10,$12,$18,$12,$00
    .db $26,$02,$2a,$06,$0a,$4c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $ff
    .db $06,$1e,$1c,$26,$12,$08,$0a,$24,$00,$32,$1e,$2a,$24,$26,$0a,$18
    .db $0c,$00,$0e,$24,$0a,$0a,$28,$0a,$08,$4c,$00,$00,$00,$00,$00,$00
    .db $12,$0c,$00,$1c,$1e,$28,$4a,$00,$18,$1e,$1e,$16,$00,$12,$1c,$28
    .db $1e,$00,$32,$1e,$2a,$24,$00,$20,$1e,$06,$16,$0a,$28,$26,$4c,$00
    .db $ff
    .db $28,$10,$0a,$24,$0a,$00,$1a,$12,$0e,$10,$28,$00,$04,$0a,$00,$26
    .db $1e,$1a,$0a,$28,$10,$12,$1c,$0e,$00,$0c,$1e,$24,$00,$32,$1e,$2a
    .db $08,$1e,$2e,$1c,$00,$28,$10,$0a,$24,$0a,$4c,$00,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $ff
news.count:
    .db $0b


    .data
    .bank 2
    .org $A000

spiral_sprites.pal:
    .incbin "data/spiral_sprites.pal"
spiral_sprites_16.bin:
    .incbin "data/spiral_sprites_16.bin"
spiral_sprites_32.bin:
    .incbin "data/spiral_sprites_32.bin"
spiral_sprites_end:
