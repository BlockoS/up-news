spiral_mul:
    .db $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$02,$02,$03,$03
    .db $04,$04,$05,$05,$06,$06,$07,$08,$09,$09,$0a,$0b,$0c,$0d,$0e,$0f
    .db $10,$11,$12,$13,$14,$15,$16,$17,$19,$1a,$1b,$1c,$1e,$1f,$21,$22
    .db $24,$25,$27,$28,$2a,$2b,$2d,$2f,$31,$32,$34,$36,$38,$3a,$3c,$3e
    .db $40,$42,$44,$46,$48,$4a,$4c,$4e,$51,$53,$55,$57,$5a,$5c,$5f,$61
    .db $64,$66,$69,$6b,$6e,$70,$73,$76,$79,$7b,$7e,$81,$84,$87,$8a,$8d
    .db $90,$93,$96,$99,$9c,$9f,$a2,$a5,$a9,$ac,$af,$b2,$b6,$b9,$bd,$c0
    .db $c4,$c7,$cb,$ce,$d2,$d5,$d9,$dd,$e1,$e4,$e8,$ec,$f0,$f4,$f8,$fc
    .db $00,$fc,$f8,$f4,$f0,$ec,$e8,$e4,$e1,$dd,$d9,$d5,$d2,$ce,$cb,$c7
    .db $c4,$c0,$bd,$b9,$b6,$b2,$af,$ac,$a9,$a5,$a2,$9f,$9c,$99,$96,$93
    .db $90,$8d,$8a,$87,$84,$81,$7e,$7b,$79,$76,$73,$70,$6e,$6b,$69,$66
    .db $64,$61,$5f,$5c,$5a,$57,$55,$53,$51,$4e,$4c,$4a,$48,$46,$44,$42
    .db $40,$3e,$3c,$3a,$38,$36,$34,$32,$31,$2f,$2d,$2b,$2a,$28,$27,$25
    .db $24,$22,$21,$1f,$1e,$1c,$1b,$1a,$19,$17,$16,$15,$14,$13,$12,$11
    .db $10,$0f,$0e,$0d,$0c,$0b,$0a,$09,$09,$08,$07,$06,$06,$05,$05,$04
    .db $04,$03,$03,$02,$02,$01,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$02,$02,$03,$03
    .db $04,$04,$05,$05,$06,$06,$07,$08,$09,$09,$0a,$0b,$0c,$0d,$0e,$0f
    .db $10,$11,$12,$13,$14,$15,$16,$17,$19,$1a,$1b,$1c,$1e,$1f,$21,$22
    .db $24,$25,$27,$28,$2a,$2b,$2d,$2f,$31,$32,$34,$36,$38,$3a,$3c,$3e
    .db $40,$42,$44,$46,$48,$4a,$4c,$4e,$51,$53,$55,$57,$5a,$5c,$5f,$61
    .db $64,$66,$69,$6b,$6e,$70,$73,$76,$79,$7b,$7e,$81,$84,$87,$8a,$8d
    .db $90,$93,$96,$99,$9c,$9f,$a2,$a5,$a9,$ac,$af,$b2,$b6,$b9,$bd,$c0
    .db $c4,$c7,$cb,$ce,$d2,$d5,$d9,$dd,$e1,$e4,$e8,$ec,$f0,$f4,$f8,$fc
    .db $00,$fc,$f8,$f4,$f0,$ec,$e8,$e4,$e1,$dd,$d9,$d5,$d2,$ce,$cb,$c7
    .db $c4,$c0,$bd,$b9,$b6,$b2,$af,$ac,$a9,$a5,$a2,$9f,$9c,$99,$96,$93
    .db $90,$8d,$8a,$87,$84,$81,$7e,$7b,$79,$76,$73,$70,$6e,$6b,$69,$66
    .db $64,$61,$5f,$5c,$5a,$57,$55,$53,$51,$4e,$4c,$4a,$48,$46,$44,$42
    .db $40,$3e,$3c,$3a,$38,$36,$34,$32,$31,$2f,$2d,$2b,$2a,$28,$27,$25
    .db $24,$22,$21,$1f,$1e,$1c,$1b,$1a,$19,$17,$16,$15,$14,$13,$12,$11
    .db $10,$0f,$0e,$0d,$0c,$0b,$0a,$09,$09,$08,$07,$06,$06,$05,$05,$04
    .db $04,$03,$03,$02,$02,$01,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00
spiral_perspective:
    .db $2d,$2a,$28,$27,$25,$24,$22,$21,$20,$1f,$1e,$1d,$1c,$1b,$1a,$19
    .db $19,$18,$17,$17,$16,$15,$15,$14,$14,$14,$13,$13,$12,$12,$12,$11
    .db $11,$10,$10,$10,$10,$0f,$0f,$0f,$0f,$0e,$0e,$0e,$0e,$0d,$0d,$0d
    .db $0d,$0d,$0c,$0c,$0c,$0c,$0c,$0c,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a
cos_tbl:
    .db $20,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1e,$1e,$1e,$1e,$1d
    .db $1d,$1d,$1c,$1c,$1c,$1b,$1b,$1b,$1a,$1a,$19,$19,$18,$18,$17,$17
    .db $16,$16,$15,$14,$14,$13,$13,$12,$11,$11,$10,$0f,$0f,$0e,$0d,$0c
    .db $0c,$0b,$0a,$0a,$09,$08,$07,$07,$06,$05,$04,$03,$03,$02,$01,$00
    .db $00,$00,$ff,$fe,$fd,$fd,$fc,$fb,$fa,$f9,$f9,$f8,$f7,$f6,$f6,$f5
    .db $f4,$f4,$f3,$f2,$f1,$f1,$f0,$ef,$ef,$ee,$ed,$ed,$ec,$ec,$eb,$ea
    .db $ea,$e9,$e9,$e8,$e8,$e7,$e7,$e6,$e6,$e5,$e5,$e5,$e4,$e4,$e4,$e3
    .db $e3,$e3,$e2,$e2,$e2,$e2,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1
    .db $e0,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e2,$e2,$e2,$e2,$e3
    .db $e3,$e3,$e4,$e4,$e4,$e5,$e5,$e5,$e6,$e6,$e7,$e7,$e8,$e8,$e9,$e9
    .db $ea,$ea,$eb,$ec,$ec,$ed,$ed,$ee,$ef,$ef,$f0,$f1,$f1,$f2,$f3,$f4
    .db $f4,$f5,$f6,$f6,$f7,$f8,$f9,$f9,$fa,$fb,$fc,$fd,$fd,$fe,$ff,$00
    .db $00,$00,$01,$02,$03,$03,$04,$05,$06,$07,$07,$08,$09,$0a,$0a,$0b
    .db $0c,$0c,$0d,$0e,$0f,$0f,$10,$11,$11,$12,$13,$13,$14,$14,$15,$16
    .db $16,$17,$17,$18,$18,$19,$19,$1a,$1a,$1b,$1b,$1b,$1c,$1c,$1c,$1d
    .db $1d,$1d,$1e,$1e,$1e,$1e,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f
sin_tbl:
    .db $00,$00,$01,$02,$03,$03,$04,$05,$06,$07,$07,$08,$09,$0a,$0a,$0b
    .db $0c,$0c,$0d,$0e,$0f,$0f,$10,$11,$11,$12,$13,$13,$14,$14,$15,$16
    .db $16,$17,$17,$18,$18,$19,$19,$1a,$1a,$1b,$1b,$1b,$1c,$1c,$1c,$1d
    .db $1d,$1d,$1e,$1e,$1e,$1e,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f
    .db $20,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1f,$1e,$1e,$1e,$1e,$1d
    .db $1d,$1d,$1c,$1c,$1c,$1b,$1b,$1b,$1a,$1a,$19,$19,$18,$18,$17,$17
    .db $16,$16,$15,$14,$14,$13,$13,$12,$11,$11,$10,$0f,$0f,$0e,$0d,$0c
    .db $0c,$0b,$0a,$0a,$09,$08,$07,$07,$06,$05,$04,$03,$03,$02,$01,$00
    .db $00,$00,$ff,$fe,$fd,$fd,$fc,$fb,$fa,$f9,$f9,$f8,$f7,$f6,$f6,$f5
    .db $f4,$f4,$f3,$f2,$f1,$f1,$f0,$ef,$ef,$ee,$ed,$ed,$ec,$ec,$eb,$ea
    .db $ea,$e9,$e9,$e8,$e8,$e7,$e7,$e6,$e6,$e5,$e5,$e5,$e4,$e4,$e4,$e3
    .db $e3,$e3,$e2,$e2,$e2,$e2,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1
    .db $e0,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e1,$e2,$e2,$e2,$e2,$e3
    .db $e3,$e3,$e4,$e4,$e4,$e5,$e5,$e5,$e6,$e6,$e7,$e7,$e8,$e8,$e9,$e9
    .db $ea,$ea,$eb,$ec,$ec,$ed,$ed,$ee,$ef,$ef,$f0,$f1,$f1,$f2,$f3,$f4
    .db $f4,$f5,$f6,$f6,$f7,$f8,$f9,$f9,$fa,$fb,$fc,$fd,$fd,$fe,$ff,$00
spiral_size:
    .db $11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
spiral_spr_lo:
    .db $48,$40,$38,$30,$30,$28,$28,$20,$20,$20,$18,$18,$10,$10,$10,$10
    .db $0c,$0c,$0c,$0c,$0c,$0a,$0a,$0a,$0a,$0a,$08,$08,$08,$08,$08,$08
    .db $08,$08,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04,$04,$04,$04
    .db $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$02,$02,$02
spiral_2_spr_lo:
    .db $02,$02,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07,$08,$08,$08,$09
    .db $09,$09,$0a,$0a,$0a,$0b,$0b,$0b,$0b,$0b,$0c,$0c,$0c,$0c,$0c,$0c
    .db $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$09
    .db $09,$09,$08,$08,$08,$07,$07,$06,$06,$05,$05,$04,$04,$03,$03,$02
spiral_2_cos:
    .db $20,$1d,$18,$0f,$04,$fa,$ef,$e7,$e2,$e1,$e3,$ea,$f3,$fe,$09,$13
    .db $1a,$1f,$1f,$1c,$14,$0b,$00,$f5,$ec,$e4,$e1,$e1,$e6,$ed,$f7,$02
    .db $0d,$16,$1d,$1f,$1e,$19,$11,$06,$fc,$f1,$e8,$e3,$e0,$e3,$e8,$f1
    .db $fc,$06,$11,$19,$1e,$1f,$1d,$16,$0d,$02,$f7,$ed,$e6,$e1,$e1,$e4
    .db $ec,$f5,$00,$0b,$14,$1c,$1f,$1f,$1a,$13,$09,$fe,$f3,$ea,$e3,$e1
    .db $e2,$e7,$ef,$fa,$04,$0f,$18,$1d
spiral_2_sin:
    .db $00,$0b,$14,$1c,$1f,$1f,$1a,$13,$09,$fe,$f3,$ea,$e3,$e1,$e2,$e7
    .db $ef,$fa,$04,$0f,$18,$1d,$20,$1d,$18,$0f,$04,$fa,$ef,$e7,$e2,$e1
    .db $e3,$ea,$f3,$fe,$09,$13,$1a,$1f,$1f,$1c,$14,$0b,$00,$f5,$ec,$e4
    .db $e1,$e1,$e6,$ed,$f7,$02,$0d,$16,$1d,$1f,$1e,$19,$11,$06,$fc,$f1
    .db $e8,$e3,$e0,$e3,$e8,$f1,$fc,$06,$11,$19,$1e,$1f,$1d,$16,$0d,$02
    .db $f7,$ed,$e6,$e1,$e1,$e4,$ec,$f5
spiral_3_dt:
    .db $e4,$e7,$e9,$ec,$ee,$f1,$f4,$f7,$fa,$fd,$00,$02,$04,$07,$0a,$0d
    .db $0f,$12,$14,$16,$18,$1a,$1c,$1d,$1f,$20,$21,$22,$22,$23,$23,$24
    .db $24,$24,$24,$24,$23,$23,$23,$22,$22,$21,$20,$20,$1f,$1e,$1e,$1d
    .db $1c,$1b,$1b,$1a,$19,$19,$18,$18,$17,$17,$16,$16,$16,$15,$15,$15
    .db $15,$14,$14,$14,$14,$14,$14,$14,$14,$14,$15,$15,$15,$15,$15,$15
    .db $16,$16,$16,$16,$16,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$16
    .db $16,$16,$15,$15,$14,$13,$13,$12,$11,$10,$0f,$0e,$0d,$0c,$0a,$09
    .db $08,$06,$05,$04,$02,$01,$00,$ff,$fd,$fc,$fa,$f9,$f7,$f6,$f5,$f4
    .db $f2,$f1,$f1,$f0,$ef,$ee,$ee,$ed,$ed,$ed,$ec,$ec,$ec,$ed,$ed,$ed
    .db $ee,$ee,$ef,$f0,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f8,$f9,$fa,$fb,$fc
    .db $fd,$ff,$00,$00,$01,$02,$03,$05,$06,$07,$08,$09,$0a,$0a,$0b,$0c
    .db $0d,$0e,$0e,$0f,$10,$10,$11,$11,$12,$12,$13,$13,$14,$14,$14,$14
    .db $15,$15,$15,$15,$15,$15,$15,$15,$14,$14,$14,$14,$13,$13,$12,$12
    .db $11,$10,$0f,$0e,$0d,$0c,$0b,$0a,$08,$07,$05,$04,$02,$00,$ff,$fe
    .db $fc,$fa,$f7,$f5,$f3,$f1,$ef,$ed,$eb,$e9,$e7,$e5,$e3,$e1,$e0,$de
    .db $dd,$dc,$db,$da,$da,$d9,$d9,$d9,$da,$da,$db,$dc,$dd,$df,$e1,$e2
spiral_3_ds:
    .db $1c,$1e,$1f,$21,$23,$24,$25,$26,$26,$27,$27,$27,$26,$26,$25,$24
    .db $23,$22,$20,$1f,$1d,$1b,$19,$17,$15,$13,$11,$0f,$0d,$0b,$09,$06
    .db $04,$02,$01,$00,$fe,$fc,$fb,$f9,$f8,$f6,$f5,$f4,$f3,$f2,$f1,$f0
    .db $ef,$ee,$ee,$ed,$ed,$ec,$ec,$ec,$ec,$eb,$eb,$eb,$eb,$eb,$eb,$eb
    .db $eb,$ec,$ec,$ec,$ec,$ed,$ed,$ee,$ee,$ef,$ef,$f0,$f0,$f1,$f2,$f2
    .db $f3,$f4,$f5,$f6,$f6,$f7,$f8,$f9,$fa,$fb,$fd,$fe,$ff,$00,$00,$01
    .db $03,$04,$05,$06,$07,$08,$0a,$0b,$0c,$0d,$0e,$0f,$10,$10,$11,$12
    .db $12,$13,$13,$13,$14,$14,$14,$13,$13,$13,$12,$12,$11,$10,$0f,$0f
    .db $0e,$0c,$0b,$0a,$09,$07,$06,$04,$03,$01,$00,$ff,$fe,$fc,$fb,$fa
    .db $f8,$f7,$f6,$f4,$f3,$f2,$f1,$f0,$ef,$ee,$ed,$ed,$ec,$eb,$eb,$ea
    .db $ea,$ea,$e9,$e9,$e9,$e9,$e9,$e9,$e9,$e9,$e9,$e9,$ea,$ea,$ea,$ea
    .db $ea,$eb,$eb,$eb,$eb,$eb,$eb,$ec,$ec,$ec,$ec,$ec,$ec,$ec,$ec,$ec
    .db $eb,$eb,$eb,$eb,$ea,$ea,$ea,$e9,$e9,$e8,$e8,$e7,$e7,$e6,$e5,$e5
    .db $e4,$e3,$e2,$e2,$e1,$e0,$e0,$df,$de,$de,$dd,$dd,$dd,$dc,$dc,$dc
    .db $dc,$dc,$dd,$dd,$de,$de,$df,$e0,$e1,$e3,$e4,$e6,$e8,$ea,$ec,$ee
    .db $f1,$f3,$f6,$f9,$fc,$fe,$00,$03,$06,$09,$0c,$0f,$12,$14,$17,$19
spiral_3_cos:
    .db $00,$fc,$f7,$f2,$ed,$e9,$e4,$e0,$dc,$d8,$d5,$d1,$ce,$cc,$ca,$c8
    .db $c6,$c5,$c4,$c3,$c3,$c3,$c3,$c3,$c4,$c5,$c6,$c8,$c9,$cb,$cd,$cf
    .db $d1,$d4,$d6,$d8,$da,$dd,$df,$e1,$e4,$e6,$e8,$ea,$ec,$ee,$f0,$f2
    .db $f4,$f5,$f7,$f8,$f9,$fb,$fc,$fd,$fd,$fe,$ff,$ff,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$ff,$ff,$fe,$fe,$fd,$fc,$fc,$fb,$fa,$f9,$f8
    .db $f7,$f5,$f4,$f3,$f2,$f1,$ef,$ee,$ed,$eb,$ea,$e9,$e8,$e7,$e5,$e4
    .db $e3,$e2,$e1,$e1,$e0,$df,$df,$df,$de,$de,$de,$de,$df,$df,$e0,$e1
    .db $e2,$e3,$e4,$e5,$e7,$e8,$ea,$ec,$ee,$f0,$f2,$f4,$f7,$f9,$fc,$fe
    .db $00,$02,$04,$07,$09,$0c,$0e,$10,$12,$14,$16,$18,$19,$1b,$1c,$1d
    .db $1e,$1f,$20,$21,$21,$22,$22,$22,$22,$21,$21,$21,$20,$1f,$1f,$1e
    .db $1d,$1c,$1b,$19,$18,$17,$16,$15,$13,$12,$11,$0f,$0e,$0d,$0c,$0b
    .db $09,$08,$07,$06,$05,$04,$04,$03,$02,$02,$01,$01,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$01,$01,$02,$03,$03,$04,$05,$07,$08,$09,$0b
    .db $0c,$0e,$10,$12,$14,$16,$18,$1a,$1c,$1f,$21,$23,$26,$28,$2a,$2c
    .db $2f,$31,$33,$35,$37,$38,$3a,$3b,$3c,$3d,$3d,$3d,$3d,$3d,$3c,$3b
    .db $3a,$38,$36,$34,$32,$2f,$2b,$28,$24,$20,$1c,$17,$13,$0e,$09,$04
spiral_3_sin:
    .db $40,$3f,$3f,$3e,$3c,$3b,$39,$36,$34,$31,$2d,$2a,$26,$22,$1e,$1a
    .db $16,$12,$0e,$09,$05,$01,$fe,$fa,$f6,$f2,$ee,$eb,$e8,$e5,$e2,$df
    .db $dd,$da,$d8,$d6,$d5,$d3,$d2,$d0,$cf,$cf,$ce,$cd,$cd,$cc,$cc,$cc
    .db $cc,$cc,$cc,$cc,$cc,$cd,$cd,$cd,$cd,$ce,$ce,$cf,$cf,$cf,$d0,$d0
    .db $d0,$d1,$d1,$d2,$d2,$d2,$d3,$d3,$d4,$d4,$d5,$d5,$d6,$d6,$d7,$d7
    .db $d8,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e4,$e5,$e7,$e9
    .db $ea,$ec,$ee,$f0,$f2,$f4,$f6,$f8,$fa,$fd,$ff,$00,$03,$05,$07,$09
    .db $0b,$0e,$10,$12,$14,$15,$17,$19,$1a,$1b,$1c,$1d,$1e,$1f,$1f,$1f
    .db $20,$1f,$1f,$1f,$1e,$1d,$1c,$1b,$1a,$19,$17,$15,$14,$12,$10,$0e
    .db $0b,$09,$07,$05,$03,$00,$ff,$fd,$fa,$f8,$f6,$f4,$f2,$f0,$ee,$ec
    .db $ea,$e9,$e7,$e5,$e4,$e2,$e1,$e0,$df,$de,$dd,$dc,$db,$da,$d9,$d8
    .db $d8,$d7,$d7,$d6,$d6,$d5,$d5,$d4,$d4,$d3,$d3,$d2,$d2,$d2,$d1,$d1
    .db $d0,$d0,$d0,$cf,$cf,$cf,$ce,$ce,$cd,$cd,$cd,$cd,$cc,$cc,$cc,$cc
    .db $cc,$cc,$cc,$cc,$cd,$cd,$ce,$cf,$cf,$d0,$d2,$d3,$d5,$d6,$d8,$da
    .db $dd,$df,$e2,$e5,$e8,$eb,$ee,$f2,$f6,$fa,$fe,$01,$05,$09,$0e,$12
    .db $16,$1a,$1e,$22,$26,$2a,$2d,$31,$34,$36,$39,$3b,$3c,$3e,$3f,$3f