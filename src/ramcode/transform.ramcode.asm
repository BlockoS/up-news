    .include "../../include/config.inc"
    
mul_tbl = $e000                                                 ; [todo]
sin_tbl = $e200
cos_tbl = $e240

zdiv_tbl = $e340

_z0 = $20a0                                                     ; [todo]
_z1 = $20a2                                                     ; [todo]
  
    .bank   0
    .org    transform_points
transform.ramcode_begin:
    .include "transform.asm"
transform.ramcode_end:

