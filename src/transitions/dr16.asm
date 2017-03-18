DR16_VDC_DISPLAY_FLAG = VDC_CR_RW_INC_1 | VDC_CR_BG_ENABLE | VDC_CR_VBLANK_ENABLE 
DR16_VRAM_ADDR = $2000

; [todo] main fx routine : init + dr16

; [todo] if it takes too much cpu time, use a 64x32 BAT, draw the complete
; [todo] sequence to the 1st 32x32 and scroll back horizontally from the 
; [todo] 2nd 32x32 area.

;;---------------------------------------------------------------------
; name : dr16_draw_col
; desc : set a column in BAT for the 16x16 rotating square transition. 
; in   : Y 
;        
; out  : 
;;---------------------------------------------------------------------  
dr16_draw_col:
    cpy    #$08
    bcc    .l2
    beq    .l2
    
    ; if the column size is greater than 8, jump until the remain size
    ; is 8
.l0:
    tya
    sec
    sbc    #$08
    sta    <_ah
    cla
    lsr    <_ah
    ror    A
    lsr    <_ah
    ror    A
    clc
    adc    <_di
    sta    <_di
    lda    <_ah
    adc    <_di+1
    sta    <_di+1
    
    ldy    #$08

.l2:
    ; draw a column of 8 16x16 tiles with the rotating square tiles
    sty    <_cl
.l1:
    vdc_reg  #VDC_MAWR
    lda    <_di
    sta    video_data_l
    clc
    adc    #32
    sta    <_di
    lda    <_di+1
    sta    video_data_h
    adc    #$00
    sta    <_di+1
    
    lda   <_cl
    asl   A
    asl   A
    tay
    
    vdc_reg #VDC_DATA    
    sty    video_data_l
    stx    video_data_h
    iny
    
    sty    video_data_l
    stx    video_data_h
    iny
    
    vdc_reg  #VDC_MAWR
    lda    <_di
    sta    video_data_l
    clc
    adc    #32
    sta    <_di
    lda    <_di+1
    sta    video_data_h
    adc    #$00
    sta    <_di+1
    
    vdc_reg #VDC_DATA    
    sty    video_data_l
    stx    video_data_h
    iny
    
    sty    video_data_l
    stx    video_data_h
    iny
    
    dec    <_cl
    bpl    .l1
    
    rts

;;---------------------------------------------------------------------
dr16.init:
    vdc_reg  #VDC_CR
    vdc_data #DR16_VDC_DISPLAY_FLAG

    irq_on #INT_IRQ1
    irq_enable_vec #VSYNC
    irq_set_vec #VSYNC, #_dummy
    irq_disable_vec #HSYNC
    
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

    ; Load palette
    stwz   color_reg
    tia    dr16.pal, color_data, 32
    
    ; Load tiles
    vdc_reg  #VDC_MAWR
    vdc_data #DR16_VRAM_ADDR
    vdc_reg  #VDC_DATA
    tia      dr16.gfx, video_data, dr16.end-dr16.gfx

    ; Set scrolling coordinates
    vdc_reg  #VDC_BXR
    vdc_data #$0000

    vdc_reg  #VDC_BYR
    vdc_data #$0000

    stwz    <_bl

    cli
    
    rts

;;---------------------------------------------------------------------
; name : dr16
; desc : 16x16 rotating square transition. 
;        [todo]
; in   : 
; out  : 
;;---------------------------------------------------------------------  
dr16:
; [todo] review zp var 
; [todo] make it 1 pass ? 
; [todo] SPRITES
    jsr    dr16.init
    
.l0:
    stwz   <_si

    lda    <_bl
    beq    .l2
    sta    <_bh
    cla
.l1:
        pha
        stw    <_si, <_di
        ldy    <_bh
        ldx    #$02
        jsr    dr16_draw_col

        adcw   #$02, <_si
        pla
        inc    A
        cmp    #16
        beq    .l2
        dec    <_bh
        bne    .l1
.l2:
    vdc_wait_vsync #$03

    inc   <_bl
    lda   <_bl
    cmp   #37
    bne   .l0

    stwz   color_reg
    stwz   color_data

    rts
    
dr16.pal:
    .incbin "data/squares.pal"
dr16.gfx:
    .incbin "data/squares.dat"
dr16.end:
