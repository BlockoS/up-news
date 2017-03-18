    .include "system.inc"
    .include "irq.inc"
    .include "vce.inc"
    .include "vdc.inc"
    .include "psg.inc"
    .include "macro.inc"
    .include "word.inc"
    .include "memcpy.inc"
    
    .code
    .bank 0
    .org $e000

;    .include "math_tbl.asm"
    .include "data/spiral.inc"
    
    .include "irq_reset.asm"
    .include "vdc.asm"
    .include "vce.asm"
    .include "psg.asm"
    .include "utils.asm"
    .include "map.asm"
    .include "vgm.asm"
    
        .zp
_fx.id      .ds 1
_fx.counter .ds 2
_clean_bat  .ds 1

        .code
main:
    jsr    vgm_setup

    jsr    vdc_xres_256
    jsr    vdc_yres_224

    lda    #VDC_BG_32x64
    jsr    vdc_set_bat_size
    
    stz    <_fx.id
    cli
.loop:
        lda    <_fx.id
        asl    A
        tax
        lda    (fx.duration  ), X
        sta    <_fx.counter
        lda    (fx.duration+1), X
        sta    <_fx.counter+1
        
        bsr    .run.fx

        inc    <_fx.id
        lda    #((fx.duration-fx.proc) / 2)
        cmp    <_fx.id
        bne    .no_reset
            stz    <_fx.id
.no_reset:
        bra    .loop
.run.fx:
    jmp    [fx.proc, X]
    
fx.proc:
    .dw wobbly_news, dr16, spiral.init, spiral.2, spiral.3, spiral.1
    .dw wobbly_weather, dr16, checker.fx
   

fx.duration:
    .dw 400, 0, 0, 1200, 1200, 1200
    .dw 260, 0, 1024
    
checker.fx:
    lda  #bank(checker)
    tam  #$04
    
    lda  #bank(weather.icon.begin)
    tam  #$05
    
    jsr  checker
    rts
    
vgm_setup:
    lda    #low(storm_base_address)
    sta    <vgm_base
    sta    <vgm_ptr
    
    lda    #high(storm_base_address)
    sta    <vgm_base+1
    sta    <vgm_ptr+1
    
    lda    #storm_bank
    sta    <vgm_bank
    
    lda    <vgm_base+1
    clc
    adc    #$20
    sta    <vgm_end
    
    lda    #storm_loop_bank
    sta    <vgm_loop_bank
    stw    #storm_loop, <vgm_loop_ptr
    rts

;-----------------------------------------------------------------------
; Timer interrupt
;-----------------------------------------------------------------------
_timer:
    timer_ack     ; acknowledge timer interrupt
    rti
;-----------------------------------------------------------------------
; IRQ2 interrupt
;-----------------------------------------------------------------------
_irq_2:
    rti
;-----------------------------------------------------------------------
; NMI interrupt
;-----------------------------------------------------------------------
_nmi:
    rti
;-----------------------------------------------------------------------
; IRQ1 interrupt
;-----------------------------------------------------------------------
_irq_1:
    pha                     ; save registers
    phx
    phy

    lda    video_reg        ; get VDC status register
    sta    <vdc_sr

@vsync:                     ; vsync interrupt
    bbr5   <vdc_sr, @hsync
    inc    <irq_cnt         ; update irq counter (for wait_vsync)

    jmp    [vsync_hook]
@hsync:
    bbr2   <vdc_sr, @exit
    jmp    [hsync_hook]

@exit:
;    lda    <vdc_reg         ; restore VDC register index
;    sta    video_reg

_dummy:
    ply
    plx
    pla
    jsr    vgm_update

    rti
@user_hsync:
    jmp    [hsync_hook]
@user_vsync:
    jmp    [vsync_hook]

    .include "wobbly_background.asm"
    .include "transitions/dr16.asm"
    .include "spiral.fx.asm"

;-----------------------------------------------------------------------
; Effect
;-----------------------------------------------------------------------
    .code
    .bank 3
    .org $8000
    .include "checker.asm"

    .data
    .bank 4
    .org $8000
and_now.begin:
and_now.pal:
    .incbin "data/and_now.pal"
and_now.data:
    .incbin "data/and_now.bin"
and_now.end:

weather.begin:
weather.pal:
    .incbin "data/and_now_the_weather.pal"
weather.data:
    .incbin "data/and_now_the_weather.bin"
weather.end:

    .data
    .bank 5
    .org $A000
weather.icon.begin:
weather.icon.pal:
    .incbin "data/weather.pal"
weather.icon.data:
    .incbin "data/weather.bin"
weather.icon.end:

    .include "data/storm/storm.inc"
    
;-----------------------------------------------------------------------
; Vector table
;-----------------------------------------------------------------------
    .data
    .bank 0
    .org $fff6

    .dw _irq_2
    .dw _irq_1
    .dw _timer
    .dw _nmi
    .dw _reset
