;; Brutal 8x8 tilemap load
;;    X - BAT x position.
;;    A - BAT y position.
;;  _al - tilemap width. 
;;  _ah - tilemap height.
;;  _si - tilemap (must have been previously mapped)
put_map:
    jsr    vdc_calc_addr
    
@loop.y:
    jsr    vdc_set_write
    ldx    <_al
@loop.x:
        cly
        lda    [_si], Y
        sta    video_data_l
        iny
        lda    [_si], Y
        sta    video_data_h
        
        addw   #$02, <_si
        dex
        bne    @loop.x
        
    addw   vdc_bat_width, <_di
    
    dec    <_ah
    bne    @loop.y

    rts
