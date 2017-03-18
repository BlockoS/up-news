    .include "vdc.inc"

    .code
spiral_update:
    
    stz    .perspective

    lda    <_z0
    sta    .i0
    inc    <_z0

    st0    #VDC_MAWR
    st1    #low(SATB_ADDRESS)
    st2    #high(SATB_ADDRESS)

    st0    #VDC_DATA
.loop:
.i0 = *+1
    lda    #$00
    asl    A
    tax
    asl    A
    asl    A
    asl    A
    tay
    
    ; x
    lda    cos_tbl, X
    cmp    #$80
    ror    A
    cmp    #$80
    ror    A
    cmp    #$80
    ror    A
    cmp    #$80
    ror    A
    clc
    adc    cos_tbl, X
    cmp    #$80
    ror    A
    clc
    adc    cos_tbl, Y
    sta    .x0
    eor    #$ff
    inc    A
    sta    .x1
        
    ; y
    lda    sin_tbl, X
    cmp    #$80
    ror    A
    cmp    #$80
    ror    A
    cmp    #$80
    ror    A
    cmp    #$80
    ror    A
    clc
    adc    sin_tbl, X
    cmp    #$80
    ror    A
    clc
    adc    sin_tbl, Y
    sta    .y0
    eor    #$ff
    inc    A
    sta    .y1
    
.perspective = *+1
    ldx    spiral_perspective

.y0 = *+1
    lda    spiral_mul, X
    sec
.y1 = *+1
    sbc    spiral_mul, X    
    sta    <_tmp0
    cla
    sbc    #$00
    sta    <_tmp1

    lda    <_tmp0
    clc
    adc    #(112+32)
    sta    video_data_l
    
    lda    <_tmp1
    adc    #00
    sta    video_data_h

.x0 = *+1
    lda    spiral_mul, X
    sec
.x1 = *+1
    sbc    spiral_mul, X
    sta    <_tmp0

    cla
    sbc    #$00
    sta    <_tmp1

    lda    <_tmp0
    clc
    adc    #(128+32)
    sta    video_data_l
    tax
    
    lda    <_tmp1
    adc    #00
    sta    video_data_h

    ldx    .perspective
    lda    spiral_spr_lo, X
    sta    video_data_l
    st2    #$01

    st1    #$00
    lda    spiral_size, X
    sta    video_data_h
    
    inc   .i0
    
    inc   .perspective
    lda   .perspective
    cmp   #64
    beq   .end
    jmp   .loop
.end:
    rts

spiral_update_2:
.spiral_2_spr_lo  = $e4c0
.spiral_2_cos     = $e500
.spiral_2_sin     = $e558

.i0 = *+1
    lda    #88
    bne    .l0
        lda    #88
.l0:
    dec    A
    sta    .i0
    sta    .i1

    st0    #VDC_MAWR
    st1    #low(SATB_ADDRESS)
    st2    #high(SATB_ADDRESS)

    st0    #VDC_DATA

    ldx    #63
.loop:

.i1 = *+1
    lda    #0
    cmp    #88
    bcc    .l1
        lda    #87
        sta    .i1
.l1:

    txa
    clc
    adc    #$0f
    sta    .x0
    sta    .y0
    eor    #$ff
    inc    A
    sta    .x1
    sta    .y1

    phx
    
    ldy    .i1
    ldx    .spiral_2_sin, Y
.y0 = *+1
    lda    spiral_mul, X
    sec
.y1 = *+1
    sbc    spiral_mul, X    
    sta    <_tmp0
    cla
    sbc    #$00
    lsr    A
    ror    <_tmp0
    sta    .y2
    ldx    <_tmp0
    
    lsr    A
    ror    <_tmp0
    lsr    A
    ror    <_tmp0
    pha
    
    txa
    clc
    adc    <_tmp0
    sta    .y3
    pla
.y2 = *+1
    adc    #$00
    tax
    
.y3 = *+1
    lda    #$00
    clc
    adc    #(112+32+8)
    sta    video_data_l
    txa
    adc    #$00
    sta    video_data_h
       
    ldx    .spiral_2_cos, Y
.x0 = *+1
    lda    spiral_mul, X
    sec
.x1 = *+1
    sbc    spiral_mul, X
    sta    <_tmp0
    cla
    sbc    #$00
    lsr    A
    ror    <_tmp0
    sta    .x2
    ldx    <_tmp0
    
    lsr    A
    ror    <_tmp0
    lsr    A
    ror    <_tmp0
    pha
    
    txa
    clc
    adc    <_tmp0
    sta    .x3
    pla
.x2 = *+1
    adc    #$00
    tax
    
.x3 = *+1
    lda    #$00
    clc
    adc    #(128+32)
    sta    video_data_l
    txa
    adc    #$00
    sta    video_data_h
    
    plx
    lda    .spiral_2_spr_lo, X
    sta    video_data_l
    st2    #$01
    
    st1    #$00
    st2    #$00

    dec    .i1

    dex
    bmi   .end
    jmp   .loop
.end:
    rts

; arg... nearly no use of self modiying code here :| 
spiral_update_3:
.spiral_2_spr_lo  = $e4c0
    
.i0 = *+1
    ldx   #$00
   
    ; du = cos[i0]
    lda   spiral_3_cos, X
    sta   <_du
    cly
    cmp   #$80
    bcc   .l0
        dey
.l0:
    sty   <_du+1

    ; dv = sin[i0]
    lda   spiral_3_sin, X
    sta   <_dv
    cly
    cmp   #$80
    bcc   .l1
        dey
.l1:
    sty   <_dv+1

    ; x0
    lda   <_du
    clc
    adc   <_dv
    sta   <_x0
    sta   <_tmp0

    lda   <_du+1
    adc   <_dv+1
    sta   <_tmp1
    
    asl   <_x0
    rol   A
    asl   <_x0
    rol   A
    sta   <_x0+1

    lda   <_tmp0+1
    cmp   #$80
    ror   A
    ror   <_tmp0
    sta   <_tmp0+1
    
    lda   <_x0
    sec
    sbc   <_tmp0
    sta   <_x0
    lda   <_x0+1
    sbc   <_tmp0+1
    
    ; x0 = -x0
    eor   #$ff
    sta   <_x0+1
    lda   <_x0
    eor   #$ff
    inc   A
    sta   <_x0
    bne   .l3
        inc   <_x0+1
.l3:

    ; y0
    lda   <_du
    sec
    sbc   <_dv
    sta   <_y0
    sta   <_tmp0
    lda   <_du+1
    sbc   <_dv+1
    sta   <_tmp0+1
    
    asl   <_y0
    rol   A
    asl   <_y0
    rol   A
    sta   <_y0+1

    lda   <_tmp0+1
    cmp   #$80
    ror   A
    ror   <_tmp0
    sta   <_tmp0+1
    
    lda   <_y0
    sec
    sbc   <_tmp0
    sta   <_y0
    lda   <_y0+1
    sbc   <_tmp0+1

    ; y0 = -y0
    eor   #$ff
    sta   <_y0+1
    lda   <_y0
    eor   #$ff
    inc   A
    sta   <_y0
    bne   .l5
        inc   <_y0+1
.l5:

    inc   .i0

    st0    #VDC_MAWR
    st1    #low(SATB_ADDRESS)
    st2    #high(SATB_ADDRESS)

    st0    #VDC_DATA

    ldy    #$08
.ly:
    ; compute size
    tya
    asl    A
    asl    A
    clc
    adc    .i0
    asl    1
    tax
    lda    cos_tbl, X
    clc
    adc    #$3f
    and    #$3f
    sta    .index

    ; y0
    lda    <_y0
    sta    <_y
    clc
    adc    <_du
    sta    <_y0
    lda    <_y0+1
    sta    <_y+1
    adc    <_du+1
    sta    <_y0+1

    ; x0
    lda    <_x0
    sta    <_x
    clc
    adc    <_dv
    sta    <_x0
    lda    <_x0+1
    sta    <_x+1
    adc    <_dv+1
    sta    <_x0+1
    
    lda     #$08
    sta     <$30
.lx:
    ; y
    lda    <_y
    clc
    adc    #(112+32)         ; [todo]
    sta    video_data_l
    lda    <_y+1
    adc    #$00
    sta    video_data_h
    
    lda    <_y
    sec
    sbc    <_dv
    sta    <_y
    lda    <_y+1
    sbc    <_dv+1
    sta    <_y+1
    
    ; x
    lda    <_x
    clc
    adc    #(128+32)         ; [todo]
    sta    video_data_l
    lda    <_x+1
    adc    #$00
    sta    video_data_h

    lda    <_x
    clc
    adc    <_du
    sta    <_x
    lda    <_x+1
    adc    <_du+1
    sta    <_x+1

    ; pattern
.index = *+1
    ldx    #$00
    lda    .spiral_2_spr_lo, X
    sta    video_data_l
    st2    #$01

    ; size
    st1    #$00
    st2    #$00

    dec    <$30
    bne    .lx
    
    dey
    beq    .end
    jmp    .ly

.end:

    rts
