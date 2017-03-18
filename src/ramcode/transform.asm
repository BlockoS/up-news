  .include "vdc.inc"
  
  .macro matrix_store
    sta    \1_0
    eor    #$ff
    inc    A
    sta    \1_1
  .endmacro

    .code
transform:
    ; compute_rotation_matrix:
    ; t0 = ry - rz
ry = * + 1
    lda    #$00
    tax
    sec
rz = * + 1
    sbc    #$00
    sta    @t0
    ; t1 = ry + rz
    txa
    clc
    adc    rz
    sta    @t1
    ; t8 = ry - rx 
    txa
    sec
rx = * + 1
    sbc    #$00
    sta    @t8
    
    ; m02 =  sin(ry)
    lda    sin_tbl, X
    clc
    adc    sin_tbl, X
    matrix_store m02

    ; t9 = ry + rx
    txa
    clc
    adc    rx
    sta    @t9
    
    ; t2 = rx + rz
    lda    rx
    tax
    clc
    adc    rz
    sta    @t2
    ; t3 = rx - rz
    txa
    sec
    sbc    rz
    sta    @t3
    ; t4 = rx - ry - rz = rx - t1
    txa
    sec
    sbc    @t1
    sta    @t4
    ; t5 = rx + ry - rz = rx + t0
    txa
    clc
    adc    @t0
    sta    @t5
    ; t6 = rx - ry + rz = rx - t0
    txa
    sec
    sbc    @t0
    sta    @t6
    ; t7 = rx + ry + rz = rx + t1
    txa
    clc
    adc    @t1
    sta    @t7
    
@t0 = * + 1
    ldx    #$00
@t1 = * + 1
    ldy    #$00
    ; A = (cos(t0) + cos(t1)) / 2
    lda    cos_tbl, X
    clc
    adc    cos_tbl, Y
    matrix_store m00

    ; B = (sin(t0) - sin(t1)) / 2
    lda    sin_tbl, X
    sec
    sbc    sin_tbl, Y
    matrix_store m01

@t8 = * + 1
    ldx    #$00
@t9 = * + 1
    ldy    #$00
    ; F = (sin(t8) - sin(t9)) / 2
    lda    sin_tbl, X
    sec
    sbc    sin_tbl, Y
    matrix_store m12

    ; I = (cos(t8) + cos(t9)) / 2
    lda    cos_tbl, X
    clc
    adc    cos_tbl, Y
    matrix_store m22

@t2 = * + 1
    ldx    #$00
@t3 = * + 1
    ldy    #$00
    ; D'= ( sin(t2) - sin(t3)) / 2
    lda    sin_tbl, X
    sec
    sbc    sin_tbl, Y
    sta    @m10_
    ; H'= ( sin(t2) + sin(t3)) / 2
    lda    sin_tbl, X
    clc
    adc    sin_tbl, Y
    sta    @m21_
    ; E'= ( cos(t2) + cos(t3)) / 2
    lda    cos_tbl, X
    clc
    adc    cos_tbl, Y
    sta    @m11_
    ; G'= (-cos(t2) + cos(t3)) / 2
    lda    cos_tbl, Y
    sec
    sbc    cos_tbl, X
    sta    @m20_
    
@t4 = * + 1
    ldx    #$00
@t5 = * + 1
    ldy    #$00
    ; tmp0 = (cos(t4) - cos(t5)) / 2
    lda    cos_tbl, X
    sec
    sbc    cos_tbl, Y
    sta    @tmp0
    ; tmp2 = (sin(t4) - sin(t5)) / 2
    lda    sin_tbl, X
    sec
    sbc    sin_tbl, Y
    sta    @tmp2
    
@t6 = * + 1
    ldx    #$00
@t7 = * + 1
    ldy    #$00
    ; tmp1 = (cos(t6) - cos(t7)) / 2
    lda    cos_tbl, X
    sec
    sbc    cos_tbl, Y
    sta    @tmp1
    ; tmp3 = (sin(t6) - sin(t7)) / 2
    lda    sin_tbl, X
    sec
    sbc    sin_tbl, Y
    sta    @tmp3

    ; m10 = @m10_ + ( tmp0 + tmp1) / 2
@tmp0 = * + 1
    lda    #$00
    clc
@tmp1 = * + 1
    adc    #$00
    cmp    #$80
    ror    A
    clc
@m10_ = * + 1
    adc    #$00
    matrix_store m10

    ; m21 = @m21 + (-tmp0 + tmp1) / 2
    lda    @tmp1
    sec
    sbc    @tmp0
    cmp    #$80
    ror    A
    clc
@m21_ = * + 1
    adc    #$00
    matrix_store m21

    ; E = E' + ( tmp2 - tmp3) / 2
@tmp2 = * + 1
    lda    #$00
    sec
@tmp3 = * + 1
    sbc    #$00
    cmp    #$80
    ror    A
    clc
@m11_ = * + 1
    adc    #$00
    matrix_store m11

    ; G = G' + ( tmp2 + tmp3) / 2
    lda    @tmp2
    clc
    adc    @tmp3
    cmp    #$80
    ror    A
    clc
@m20_ = * + 1
    adc    #$00
    matrix_store m20

vertice_count = * + 1
    ldx    #0
@l0:
    phx
    
vertex_z = * + 1
    ldy    vertex_z, X
    ; m02 * z
m02_0 = * + 1
    lda    mul_tbl, Y
    sec
m02_1 = * + 1
    sbc    mul_tbl, Y
    sta    @z0
    ; m12 * z
m12_0 = * + 1
    lda    mul_tbl, Y
    sec
m12_1 = * + 1
    sbc    mul_tbl, Y
    sta    @z1
    ; m22 * z
m22_0 = * + 1
    lda    mul_tbl, Y
    sec
m22_1 = * + 1
    sbc    mul_tbl, Y
    sta    @z2

vertex_y = * + 1
    ldy    vertex_y, X
vertex_x = * + 1
    lda    vertex_x, X
    tax
    
@z2 = * + 1
    lda    #$00
    ; m20 * x
m20_0 = * + 1
    adc    mul_tbl, X
m20_1 = * + 1
    sbc    mul_tbl, X
    ; m21 * z
m21_0 = * + 1
    adc    mul_tbl, Y
m21_1 = * + 1
    sbc    mul_tbl, Y
    sta    @_z
    
@z0 = * + 1
    lda    #$00
    ; m00 * x
m00_0 = * + 1
    adc    mul_tbl, X
m00_1 = * + 1
    sbc    mul_tbl, X
    ; m01 * y
m01_0 = * + 1
    adc    mul_tbl, Y
m01_1 = * + 1
    sbc    mul_tbl, Y
    sta    @_x
    
@z1 = * + 1
    lda    #$00
    ; m10 * x
m10_0 = * + 1
    adc    mul_tbl, X
m10_1 = * + 1
    sbc    mul_tbl, X
    ; m11 * y
m11_0 = * + 1
    adc    mul_tbl, Y
m11_1 = * + 1
    sbc    mul_tbl, Y

    plx
    sta    out_y, X
@_x = * + 1
    lda    #$00
    sta    out_x, X
@_z = * + 1
    lda    #$00
    sta    out_z, X

    dex
    bmi    @l1
    jmp    @l0
@l1
    rts

out_x = *
out_y = out_x + MAX_POINT_COUNT
out_z = out_y + MAX_POINT_COUNT
