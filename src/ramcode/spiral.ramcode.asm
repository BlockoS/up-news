    .include "../../include/config.inc"
    .include "word.inc"

_z0 = $20a0                                                     ; [todo]
_z1 = $20a2                                                     ; [todo]
_tmp0 = $20a3                                                   ; [todo]
_tmp1 = $20a4                                                   ; [todo]
_tmp2 = $20a5                                                   ; [todo]
_tmp3 = $20a6                                                   ; [todo]

_x0 = $2040
_x  = $2042
_y0 = $2044
_y  = $2046
_du = $2048
_dv = $204a

spiral_mul         = $e000                                      ; [todo]
spiral_perspective = $e200                                      ; [todo] 
cos_tbl = $e240
sin_tbl = $e340

spiral_size = $e440
spiral_spr_lo = $e480
spiral_spr_hi = $e4c0

spiral_3_dt = $e5b0
spiral_3_ds = $e6b0
spiral_3_cos = $e7b0
spiral_3_sin = $e8b0

    .bank   0
    .org    spiral
spiral.ramcode_begin:
    .include "spiral.asm"
spiral.ramcode_end:
