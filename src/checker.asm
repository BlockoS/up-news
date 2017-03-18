CHECKER_VDC_ENABLE_DISPLAY = VDC_CR_RW_INC_32 | VDC_CR_BG_ENABLE | VDC_CR_SPR_ENABLE | VDC_CR_VBLANK_ENABLE | VDC_CR_HBLANK_ENABLE

WHITE = %0000000_111_111_111
RED   = %0000000_110_110_110
GREEN = %0000000_100_100_100
BLUE  = %0000000_010_010_010
BLACK = %0000000_000_000_000

;;---------------------------------------------------------------------
;; [todo] : new version starts here
;;---------------------------------------------------------------------
PLANE_COUNT = 4

    .zp
checker_rcr        .ds 2
checker_x          .ds PLANE_COUNT
checker_y          .ds PLANE_COUNT
checker_z          .ds 1
checker_mask       .ds PLANE_COUNT
checker_size       .ds PLANE_COUNT
checker_color      .ds 1
checker_scroll_y   .ds 1

checker_x0         .ds PLANE_COUNT
checker_y0         .ds PLANE_COUNT
checker_mx         .ds PLANE_COUNT
checker_my         .ds PLANE_COUNT
checker_dx         .ds PLANE_COUNT
checker_dy         .ds PLANE_COUNT


        .code

checker_start:

;;---------------------------------------------------------------------
;; x_mod_s = (8 - i) % s with i [0,8] and s [0,8]
;;---------------------------------------------------------------------
x_mod_s:
    .db 0, 0, 0, 0, 0, 0, 0, 0, 0
    .db 0, 0, 0, 0, 0, 0, 0, 0, 0
    .db 0, 1, 0, 1, 0, 1, 0, 1, 0
    .db 2, 1, 0, 2, 1, 0, 2, 1, 0
    .db 0, 3, 2, 1, 0, 3, 2, 1, 0
    .db 3, 2, 1, 0, 4, 3, 2, 1, 0
    .db 2, 1, 0, 5, 4, 3, 2, 1, 0
    .db 1, 0, 6, 5, 4, 3, 2, 1, 0
    .db 0, 7, 6, 5, 4, 3, 2, 1, 0
   
;;---------------------------------------------------------------------
;; mul_9 = i * 9 with i [0,10]
;;---------------------------------------------------------------------
mul9:
    .db 0, 9, 18, 27, 36, 45, 54, 63, 72, 81

;;---------------------------------------------------------------------
;; 
;;---------------------------------------------------------------------
checker_pixel_index: 
    .db 0, 1, 2, 4, 7, 11, 16, 22, 29

;;---------------------------------------------------------------------
;; 
;;---------------------------------------------------------------------
checker_pixel_data:    
    .db %00000000                                                                              ; 0
    .db %10101010                                                                              ; 1
    .db %11001100, %01100110                                                                   ; 2
    .db %11100011, %01110001, %00111000                                                        ; 3
    .db %11110000, %01111000, %00111100, %00011110                                             ; 4
    .db %11111000, %01111100, %00111110, %00011111, %00001111                                  ; 5
    .db %11111100, %01111110, %00111111, %00011111, %00001111, %00000111                       ; 6
    .db %11111110, %01111111, %00111111, %00011111, %00001111, %00000111, %00000011            ; 7       
    .db %11111111, %01111111, %00111111, %00011111, %00001111, %00000111, %00000011, %00000001 ; 8
 
;;---------------------------------------------------------------------
;; 
;;---------------------------------------------------------------------


;;---------------------------------------------------------------------
; name : 
; desc : 
;;---------------------------------------------------------------------
checker_ge8 .macro
    ldy    <checker_x+\1
    cpy    #8
    bcc    .checker_ge8_0_\@
        ; x >= 8
        lda    <checker_mask+\1
        sta    \2
        
        tya
        sec
        sbc    #8
        sta    <checker_x+\1
        bra    checker_ge8_end_\@        
.checker_ge8_0_\@:
        ; x < 8
        lda    checker_pixel_data+29, Y
        eor    <checker_mask+\1
        sta    \2
        
        lsr    A
        cla
        bcc    .checker_ge8_1_\@
            dec    A
.checker_ge8_1_\@:
        sta    <checker_mask+\1
        
        lda    <checker_size+\1
        sec
        sbc    #8
        clc
        adc    <checker_x+\1
        sta    <checker_x+\1
checker_ge8_end_\@:
    .endm    
      
;;---------------------------------------------------------------------
; name : 
; desc : 
;;---------------------------------------------------------------------  
checker_lt8 .macro
    ldy    <checker_size+\1
    lda    checker_pixel_index, Y
    clc
    adc    <checker_x+\1
    tay
    lda    checker_pixel_data, Y
    eor    <checker_mask+\1
    sta    \2

    lsr    A
    cla
    bcc   .checker_lt8_0_\@
        dec    A
.checker_lt8_0_\@:
    sta    <checker_mask+\1
   
    ldy    <checker_size+\1
    lda    mul9, Y              ; [todo] this can be precomputed
    clc
    adc    <checker_x+\1
    tay
    lda    x_mod_s, Y
    beq    .checker_lt8_1_\@
        eor    #$ff
        sec
        adc    <checker_size+\1
.checker_lt8_1_\@:
    sta    <checker_x+\1
    .endm
 
;;---------------------------------------------------------------------
; name : 
; desc : 
; size :  
;;---------------------------------------------------------------------      
checker_repeat_8 .macro
    \1 \2, video_data_l
    \1 \3, video_data_h
    \1 \2, video_data_l
    \1 \3, video_data_h
    \1 \2, video_data_l
    \1 \3, video_data_h
    \1 \2, video_data_l
    \1 \3, video_data_h
    \1 \2, video_data_l
    \1 \3, video_data_h
    \1 \2, video_data_l
    \1 \3, video_data_h
    \1 \2, video_data_l
    \1 \3, video_data_h
    \1 \2, video_data_l
    \1 \3, video_data_h
    .endm

checker_repeat_32 .macro
    checker_repeat_8 \1, \2, \3
    checker_repeat_8 \1, \2, \3
    checker_repeat_8 \1, \2, \3
    checker_repeat_8 \1, \2, \3
    .endm
 
checker_lt8_32 .macro 
    checker_repeat_32 checker_lt8, \1, \2
    .endm

checker_ge8_32 .macro 
    checker_repeat_32 checker_ge8, \1, \2
    .endm
    
;---------------------------------------------------------------------
; name : checker_generate_palette
; desc : generate palettes for checker effect.
; in   :
; out  :
;---------------------------------------------------------------------
checker_generate_palette:
    ; Reset color index register
    stwz   color_reg
    ; Copy colors
    stw    #$ff10, <_cx
    
.checker_gen_pal_0:
    ldx    #$10
    
.checker_gen_pal_1:
        inc    <_ch
        
        lda    <_ch
        and    #$0f
        tay
        lda    checker_color_index, Y
        tay
        lda    checker_color_lo, Y
        sta    color_data_lo
        lda    checker_color_hi, Y
        sta    color_data_hi
        
        dex
        bne    .checker_gen_pal_1
    dec    <_ch
    dec    <_cl
    bne    .checker_gen_pal_0

    rts

checker_color_index:
    .db 0,1,2,1,3,1,2,1,4,1,2,1,3,1,2,1 
    
checker_color_lo:
    .db  low(BLACK),  low(WHITE),  low(RED),  low(GREEN),  low(BLUE)
checker_color_hi:
    .db high(BLACK), high(WHITE), high(RED), high(GREEN), high(BLUE)
    
;---------------------------------------------------------------------
; name : checker_generate_bat
; desc : generate background attribute table for checker effect.
;        [todo: explain bat layout]
; in   :
; out  :
;--------------------------------------------------------------------- 
checker_generate_bat:
    ; Set vram address where BAT will be written
    ; 1. The memory address write register ($00)
    ;    will be accessible via port $0002
    st0    #VDC_MAWR
    ; 2. Set vram address where data will be written
    ;    BAT is at vram address $0000
    st1    #$00
    st2    #$00

    ; 1. Map VRAM data register to port $0002
    st0    #VDC_DATA
    ; 2. BAT entry is made as follows:
    ;   CCCCVVVVVVVVVVVV
    ;   C: palette entry
    ;   V: VRAM address divided by #16
    ;    Starting VRAM address is #$1000.
    ;    We'll write 32 entries
    stz    <_di
    lda    #$01
    sta    <_di+1

    ; number of palettes : 16
    ldy   #$10

checker_bat_init_0:
    ; number of blocs : 32
    ldx    #$20
    
    stz    <_di
    lda    <_di+1
    and    #$f0
    ora    #$02
    sta    <_di+1
    
checker_bat_init_1:
        ;    Write BAT entry
        stw    <_di, video_data
        
        ;    Jump 2 bloc farther
        clc
        lda    <_di
        adc    #2
        sta    <_di
        lda    <_di+1
        adc    #0
        sta    <_di+1
        
        dex
        bne    checker_bat_init_1

    clc
    lda    <_di+1
    adc    #$10
    sta    <_di+1
    
    dey
    bne    checker_bat_init_0    
    
    rts
    
;;---------------------------------------------------------------------
; name : checker_clean_line
; desc : clear a horizontal line in vram. As vram is split into 8x8 
;        blocs, the line is drawn per segment of 8 pixels and the 
;        vram write offset is set to jump a complete 8x8 bloc
;        (32 bytes). 
; in   : _si vram address
; out  : 
;;---------------------------------------------------------------------  
checker_clean_line:
    st0    #VDC_MAWR
    stw    <_si, video_data
    
    ldx    #$20
    st0    #VDC_DATA
    st1    #$00
.checker_clean_line_0:
    st2    #$00
    dex
    bne    .checker_clean_line_0
    rts
    
;;---------------------------------------------------------------------
; name : 
; desc : 
; in   : 
; out  : 
;;---------------------------------------------------------------------  
checker:
    ; Disable display and VDC interrupts.
    vdc_reg  #VDC_CR
    vdc_data #$0000
    irq_disable_vec #VSYNC
    irq_disable_vec #HSYNC

    ; Set sprite palette
    stw    #$0100, color_reg
    tia    weather.icon.pal, color_data, 32
    ; Load 16x16 sprites
    vdc_reg  #VDC_MAWR
    vdc_data #AND_NOW_VRAM_ADDR
    vdc_reg  #VDC_DATA
    tia   weather.icon.data, video_data,weather.icon.end-weather.icon.data

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

    jsr    wobbly_txt

    jsr    checker_generate_palette
    lda    #VDC_BG_32x32
    jsr    vdc_set_bat_size
    jsr    checker_generate_bat
    
    ; disable sprites and bg display
    ; set increment to 32 bytes
    vdc_reg  #VDC_CR
    vdc_data #VDC_CR_RW_INC_32
    
    stw    #$2009, <_si
    jsr    checker_clean_line ; [todo] replace with a good old tia or smthing similar
    stw    #$200A, <_si
    jsr    checker_clean_line
    
    ; Set and enable vdc interrupts
    irq_on #INT_IRQ1
    ; set vsync vec
    irq_enable_vec #VSYNC
    irq_set_vec #VSYNC, #checkerVsyncProc
    ; set hsync vec
    irq_enable_vec #HSYNC
    irq_set_vec #HSYNC, #checkerHsyncProc
    
    ; Enable bg, sprite, vertical blanking and scanline interrupt
    vdc_reg  #VDC_CR
    vdc_data #CHECKER_VDC_ENABLE_DISPLAY
        
    ; Set horizontal scrolling coordinate
    vdc_reg  #VDC_BXR
    vdc_data #$0000
    ; Set vertical scrolling coordinate
    vdc_reg  #VDC_BYR
    vdc_data #$0000

    cli
; [todo]
    jsr    checker_linear_init

checker_loop:
; [todo]
    jsr    checker_linear_update

    ; Set vram write position
    vdc_reg  #VDC_MAWR
    vdc_data #$2001

    ; Transfer buffer to vram
    vdc_reg #VDC_DATA
    checker_ge8_32 0, 1

    ; Set vram write position
    vdc_reg #VDC_MAWR
    vdc_data #$2009
    
    ; Transfer buffer to vram
    vdc_reg #VDC_DATA
    checker_ge8_32 2, 3

    vdc_wait_vsync #$01
    
    jsr    vgm_update
    
    decw    <_fx.counter
    lda     <_fx.counter
    ora     <_fx.counter+1
    beq     .end
    
    jmp checker_loop
.end:
    rts

;----------------------------------------------------------------------
; VSYNC (checker)
;----------------------------------------------------------------------
checkerVsyncProc:
    st0    #VDC_RCR         ; restart the scanline counter on the first
    st1    #VDC_RCR_START   ; line
    lda    #VDC_RCR_START
    sta    <checker_rcr
    st2    #$00
    stz    <checker_rcr+1

    lda    #220
    sta    <checker_scroll_y

    stz    <checker_color

    ; set horizontal scrolling coordinate
    st0    #VDC_BXR
    st1    #$00
    st2    #$00
    
    ply
    plx
    pla
    rti

;----------------------------------------------------------------------
; HSYNC (checker)
;----------------------------------------------------------------------
checkerHsyncProc:
    clc

    ; set vertical scrolling coordinate
    st0    #VDC_BYR
    ldx    <checker_color
    lda    checker_bat_y, X ; [todo] <= ?!?!
    sta    video_data_l
    st2    #$00

    ; set background color
    stwz   color_reg
    ldy    checker_color_index,X
    lda    checker_color_lo,Y
    sta    color_data_lo
    lda    checker_color_hi,Y
    sta    color_data_hi
    
    txa
    ; swap palette colors if needed
checkerHsyncProcUpdate .macro
    ldy    <checker_y+\1
    bne    .checkerHsyncProcUpdate_\1
        ldx    <checker_size+\1
        stx    <checker_y+\1
        eor    #(1<<\1)
.checkerHsyncProcUpdate_\1:
    dec    <checker_y+\1
    .endm
    
    checkerHsyncProcUpdate 0
    checkerHsyncProcUpdate 1
    checkerHsyncProcUpdate 2
    checkerHsyncProcUpdate 3

    sta    <checker_color
    
    ; jump to next scanline
    st0    #VDC_RCR
    incw   <checker_rcr
    stw    <checker_rcr, video_data

    ply
    plx
    pla
    rti

checker_bat_y:
    .db 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120


;----------------------------------------------------------------------
; Linear init
;----------------------------------------------------------------------
checker_linear_init:
    lda    #128
    sta    <checker_size
    lda    #92
    sta    <checker_size+1
    lda    #32
    sta    <checker_size+2
    lda    #8
    sta    <checker_size+3

    lda    <checker_size
    sta    <checker_x0
    sta    <checker_y0
    stz    <checker_mx
    stz    <checker_my

    lda    <checker_size+1
    sta    <checker_x0+1
    sta    <checker_y0+1
    stz    <checker_mx+1
    stz    <checker_my+1

    lda    <checker_size+2
    sta    <checker_x0+2
    sta    <checker_y0+2
    stz    <checker_mx+2
    stz    <checker_my+2

    lda    <checker_size+3
    sta    <checker_x0+3
    sta    <checker_y0+3
    stz    <checker_mx+3
    stz    <checker_my+3

    stz    checker_dx
    lda    #$02
    sta    checker_dy
    lda    #(-1)
    sta    checker_dx+1
    stz    checker_dy+1
    lda    #1
    sta    checker_dx+2
    lda    #1
    sta    checker_dy+2
    lda    #(-1)
    sta    checker_dx+3
    lda    #(-1)
    sta    checker_dy+3

    rts

;----------------------------------------------------------------------
; Linear update
;----------------------------------------------------------------------
checker_linear_update:
    phy
        ldx    #3
.update:
        lda    <checker_x0,X
        sta    <checker_x,X
        lda    <checker_y0,X
        sta    <checker_y,X
        lda    <checker_mx,X
        eor    <checker_my,X
        sta    <checker_mask,X

        lda    <checker_x0,X
        clc
        adc    <checker_dx,X
        bne    .l0
            lda    <checker_mx,X
            eor    #$ff
            sta    <checker_mx,X
            lda    <checker_size,X
            bra    .l1
.l0:
        cmp    <checker_size,X
        bcc    .l1
            lda    <checker_mx,X
            eor    #$ff
            sta    <checker_mx,X
            lda    #00
.l1:
        sta    <checker_x0,X

        lda    <checker_y0,X
        clc
        adc    <checker_dy,X
        bne    .l2
            lda    <checker_my,X
            eor    #$ff
            sta    <checker_my,X
            lda    <checker_size,X
            bra    .l3
.l2:
        cmp    <checker_size,X
        bcc    .l3
            lda    <checker_my,X
            eor    #$ff
            sta    <checker_my,X
            lda    #00
.l3:
        sta    <checker_y0,X

        dex
        bpl    .update

    ply

    rts

checker_end:
    
