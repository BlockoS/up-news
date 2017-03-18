; sprites:
;       - vignette (live)
;       - channel name
;       - left eye
;       - right eye
;       - mouth
;       - left hand
;       - right hand
;
; scroll:
;       - breaking news ?
;       - main news line
;       - stock line

news:
    ; Clean BAT
    vdc_reg #VDC_MAWR
    vdc_data #$0000
    vdc_reg #VDC_DATA
    st1    #low($2000>>4)
    st2    #high($2000>>4)

    st0    #VDC_DMA_SRC
    st1    #low($0000)
    st2    #high($0000)

    st0    #VDC_DMA_DST
    st1    #low($0001)
    st2    #high($0001)

    st0    #VDC_DMA_LEN
    st1    #low(32*32 - 2)
    st2    #high(32*32 - 2)

    ; [todo] load palettes
    ; [todo] load tiles
    ; [todo] load BAT
    ; [todo] load sprites

    cli
.loop:
        ; [todo] update sprite coordinates
        
        vdc_wait_vsync #$01
        
        decw   <_fx.counter
        ora    <_fx.counter
        bne    .loop
    rts

; [todo] vsync and hsync for news scroller
