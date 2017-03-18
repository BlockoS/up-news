BG_SUPER_TILE_SIZE = 24
PHI_INC = 640
THETA_INC = 5376

WOBBLY_VDC_FLAG = VDC_CR_BG_ENABLE | VDC_CR_SPR_ENABLE | VDC_CR_VBLANK_ENABLE | VDC_CR_HBLANK_ENABLE
AND_NOW_VRAM_ADDR=$2400

    .zp
_phi     .ds 2
_theta   .ds 2
_x       .ds 1
_y       .ds 1
_ty      .ds 1
_and_x   .ds 2
_and_y   .ds 2
_and_pat .ds 2

    .code

wobbly_news:
    vdc_reg  #VDC_CR
    vdc_data #$00
    ; Map data banks
    lda    #bank(and_now.begin)
    tam    #$04
    ; Set sprite palette
    stw    #$0100, color_reg
    tia    and_now.pal, color_data, 32
    ; Load 16x16 sprites
    vdc_reg  #VDC_MAWR
    vdc_data #AND_NOW_VRAM_ADDR
    vdc_reg  #VDC_DATA
    tia   and_now.data, video_data, and_now.end-and_now.data
    jmp    wobbly

wobbly_weather:
    vdc_reg  #VDC_CR
    vdc_data #$00
    ; Map data banks
    lda    #bank(and_now.begin)
    tam    #$04
    ; Set sprite palette
    stw    #$0100, color_reg
    tia    weather.pal, color_data, 32
    ; Load 16x16 sprites
    vdc_reg  #VDC_MAWR
    vdc_data #AND_NOW_VRAM_ADDR
    vdc_reg  #VDC_DATA
    tia    weather.data, video_data, weather.end-weather.data
    jmp    wobbly

wobbly_init:    
    lda    #VDC_BG_32x64
    jsr    vdc_set_bat_size
    
    ; [todo] load image
    ldx    #00
    lda    <_ty
    jsr    vdc_calc_addr
    jsr    vdc_set_write

    lda    vdc_bat_width
    lsr    A
    sta    <_cl
    tax
@x0:
    st1    #low($2200>>4)
    st2    #high($2200>>4)
    st1    #low($2210>>4)
    st2    #high($2210>>4)
    dex
    bne    @x0
    
    ldx    <_cl
@x1:
    st1    #low($2210>>4)
    st2    #high($2210>>4)
    st1    #low($2200>>4)
    st2    #high($2200>>4)
    dex
    bne    @x1

    ldx    <_cl
@x2:
    st1    #low($2200>>4)
    st2    #high($2200>>4)
    st1    #low($2210>>4)
    st2    #high($2210>>4)
    dex
    bne    @x2

    ldx    <_cl
@x3:
    st1    #low($2210>>4)
    st2    #high($2210>>4)
    st1    #low($2200>>4)
    st2    #high($2200>>4)
    dex
    bne    @x3
    
    ldx    <_cl
@x4:
    st1    #low($2200>>4)
    st2    #high($2200>>4)
    st1    #low($2210>>4)
    st2    #high($2210>>4)
    dex
    bne    @x4
                                        ; [todo] load gfx
    vdc_reg #VDC_MAWR
    st1    #low($2200)
    st2    #high($2200)
    vdc_reg #VDC_DATA
    st1    #%1111_0000
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st1    #%0000_1111
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    
    st1    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00

    st1    #%1111_0000
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st1    #%0000_1111
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    
    st1    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    
    stwz   color_reg
    stw    #(6 | (3 << 3) | (4 << 6)), color_data
    stw    #(7 | (2 << 3) | (5 << 6)), color_data

    stz    <irq_m
    
    irq_on #INT_IRQ1
    ; set vsync vec
    irq_enable_vec #VSYNC
    irq_set_vec #VSYNC, #wobbly_background_vsync
    ; set hsync vec
    irq_enable_vec #HSYNC
    irq_set_vec #HSYNC, #wobbly_background_hsync
    
    st0    #$0f     ; Enable VRAM SATB DMA
    st1    #$10 
    st2    #$00
    
    st0    #$13     ; Set SATB address
    st1    #low($4000)              ; [todo]
    st2    #high($4000)             ; [todo]
 
    ; Brutally clear SATB
    st0    #VDC_MAWR
    st1    #low($4000)
    st2    #high($4000)
    
    st0    #VDC_DATA
    st1    #$00
    ldx    #64
.brutal_clear:
    st2    #$00
    st2    #$00
    st2    #$00
    st2    #$00
    dex
    bne    .brutal_clear
    
    ; enable background display
    vdc_reg  #VDC_CR
    vdc_data #WOBBLY_VDC_FLAG
    
    stz    <irq_cnt
   
    rts

wobbly_background_init:
    stwz   <_phi
    stwz   <_theta
    stz    <_x
    stz    <_y
    stz    <_ty
    rts

wobbly_background_vsync:
    ; theta  = phi
    ; phi   += phi_inc
    clc
    lda    <_phi
    sta    <_theta
    tax
    adc    #low(PHI_INC)
    sta    <_phi
    lda    <_phi+1
    sta    <_theta+1
    adc    #high(PHI_INC)
    sta    <_phi+1

    ; reset tile offset
    cly

    ; compute y scroll
    ldx    <_theta+1
    lda    sin_16_tbl, X
    bmi    @l0
    beq    @l0
        ldy    #(-BG_SUPER_TILE_SIZE)
        subw   #(THETA_INC), <_theta
        tax
        lda    sin_16_tbl, X
        sec
        sbc    #(BG_SUPER_TILE_SIZE)
@l0:
    eor    #$ff
    inc    A
    st0    #VDC_BYR
    sta    video_data_l
    st2    #$00
    
    ; compute x displacement
    ldx    <_theta+1
    lda    cos_16_tbl, X
    clc
    adc    #BG_SUPER_TILE_SIZE
    ; set x scroll
    st0    #VDC_BXR
    sta    video_data_l
    st2    #$00

    ; compute next scanline coordinate
    ; -- increment tile offset
    tya
    clc
    adc    #(BG_SUPER_TILE_SIZE)
    sta    <_ty
    ; -- increment angle
    addw   #THETA_INC, <_theta
    tax
    ; -- compute rcr (this rcr value will always be < 256)
    lda    sin_16_tbl, X
    clc
    adc    <_ty
    clc
    adc    #VDC_RCR_START
    st0    #VDC_RCR
    sta    video_data_l
    st2    #$00
    
    jsr    vgm_update
    
    ply
    plx
    pla
    rti
    
wobbly_background_hsync:
    ; y scroll is always on the first line
    st0    #VDC_BYR
    st1    #$ff
    st2    #$ff
    
    ; compute x displacement
    addw   #(THETA_INC), <_theta
    ldx    <_theta+1
    lda    cos_16_tbl, X
    clc
    adc    #BG_SUPER_TILE_SIZE
    ; set x scroll
    st0    #VDC_BXR
    sta    video_data_l
    st2    #$00

    ; compute next scanline coordinate    
    lda    <_ty
    clc
    adc    #(BG_SUPER_TILE_SIZE)
    sta    <_ty
    
    lda    sin_16_tbl, X
    clx
    bpl    @l0
        dex
@l0:
    clc
    adc    <_ty
    bcc    @l1
        inx
@l1:
    st0    #VDC_RCR
    clc
    adc    #VDC_RCR_START
    sta    video_data_l
    bcc    @l2
        inx
@l2:
    stx    video_data_h

    ply
    plx
    pla
    rti
    
wobbly:
    jsr    wobbly_background_init
    jsr    wobbly_init
    
    cli
.loop:
        jsr    wobbly_txt
        vdc_wait_vsync #$01
        
        decw   <_fx.counter
        ora    <_fx.counter
        bne    .loop

    clx
.fade:
        phx
        jsr    wobbly_txt
        vdc_wait_vsync #$01
        plx
        
        txa
        lsr A
        lsr A
        tay
        
        stwz   color_reg
        lda    wobbly_pal.0.lo, Y
        sta    color_data_lo
        lda    wobbly_pal.0.hi, Y
        sta    color_data_hi
        
        lda    wobbly_pal.1.lo, Y
        sta    color_data_lo
        lda    wobbly_pal.1.hi, Y
        sta    color_data_hi
        
        inx
        cpx    #40
        bne    .fade

    rts
    
wobbly_txt:
    st0    #VDC_MAWR
    st1    #low($4000)
    st2    #high($4000)
    st0    #VDC_DATA
    
    stw    #$120, <_and_pat
    stw    #140, <_and_y
    
    clx
.l0:
    stw    #112, <_and_x

    cly
.l1:
    ; y
    stw    <_and_y, video_data

    ; x
    lda    <_and_x
    sta    video_data_l
    clc
    adc    #16
    sta    <_and_x
    lda    <_and_x+1
    sta    video_data_h
    adc    #0
    sta    <_and_x+1
    
    lda    <_and_pat
    sta    video_data_l
    clc
    adc    #$02
    sta    <_and_pat
    lda    <_and_pat+1
    sta    video_data_h
    adc    #$00
    sta    <_and_pat+1

    ; size
    st1    #$80
    st2    #$00

    iny
    cpy    #6
    bne    .l1

    addw   #16,<_and_y

    inx
    cpx    #4
    bne    .l0
    rts

    
wobbly_pal.0.lo:
    .dwl (6 | (3 << 3) | (4 << 6))
    .dwl (6 | (3 << 3) | (4 << 6))
    .dwl (6 | (4 << 3) | (5 << 6))
    .dwl (6 | (4 << 3) | (5 << 6))
    .dwl (6 | (5 << 3) | (5 << 6))
    .dwl (7 | (5 << 3) | (6 << 6))
    .dwl (7 | (6 << 3) | (6 << 6))
    .dwl (7 | (6 << 3) | (7 << 6))
    .dwl (7 | (7 << 3) | (7 << 6))
    .dwl (7 | (7 << 3) | (7 << 6))
wobbly_pal.0.hi:
    .dwh (6 | (3 << 3) | (4 << 6))
    .dwh (6 | (3 << 3) | (4 << 6))
    .dwh (6 | (4 << 3) | (5 << 6))
    .dwh (6 | (4 << 3) | (5 << 6))
    .dwh (6 | (5 << 3) | (5 << 6))
    .dwh (7 | (5 << 3) | (6 << 6))
    .dwh (7 | (6 << 3) | (6 << 6))
    .dwh (7 | (6 << 3) | (7 << 6))
    .dwh (7 | (7 << 3) | (7 << 6))
    .dwh (7 | (7 << 3) | (7 << 6))
    
wobbly_pal.1.lo:
    .dwl (7 | (2 << 3) | (6 << 6))
    .dwl (7 | (2 << 3) | (6 << 6))
    .dwl (7 | (3 << 3) | (6 << 6))
    .dwl (7 | (3 << 3) | (6 << 6))
    .dwl (7 | (4 << 3) | (6 << 6))
    .dwl (7 | (4 << 3) | (7 << 6))
    .dwl (7 | (5 << 3) | (7 << 6))
    .dwl (7 | (5 << 3) | (7 << 6))
    .dwl (7 | (7 << 3) | (7 << 6))
    .dwl (7 | (7 << 3) | (7 << 6))
wobbly_pal.1.hi:
    .dwh (7 | (2 << 3) | (6 << 6))
    .dwh (7 | (2 << 3) | (6 << 6))
    .dwh (7 | (3 << 3) | (6 << 6))
    .dwh (7 | (3 << 3) | (6 << 6))
    .dwh (7 | (4 << 3) | (6 << 6))
    .dwh (7 | (4 << 3) | (7 << 6))
    .dwh (7 | (5 << 3) | (7 << 6))
    .dwh (7 | (5 << 3) | (7 << 6))
    .dwh (7 | (7 << 3) | (7 << 6))
    .dwh (7 | (7 << 3) | (7 << 6))
    
    .include "sin_16_tbl.inc"
