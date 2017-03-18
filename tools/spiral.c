#include <stdlib.h>
#include <math.h>
#include "utils/print.h"

int main()
{
    int8_t mulTable[512];
    int i;
    int x, y;

    uint8_t perspective[64];
    float focale = 180.f;//220.f;
    float z0 = -4.f;//-5.f;
    float zscale = 5.f;

    int8_t sinTable[256];
    int8_t cosTable[256];

    uint8_t sprite_size[64] = 
    {
        0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    };
    uint8_t sprite_addr_lo[64] = 
    {
        0x48,0x40,0x38,0x30,0x30,0x28,0x28,0x20,0x20,0x20,0x18,0x18,0x10,0x10,0x10,0x10,
        0x0C,0x0C,0x0C,0x0C,0x0C,0x0A,0x0A,0x0A,0x0A,0x0A,0x08,0x08,0x08,0x08,0x08,0x08,
        0x08,0x08,0x06,0x06,0x06,0x06,0x06,0x06,0x06,0x06,0x06,0x06,0x04,0x04,0x04,0x04,
        0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x02,0x02,0x02 
    };

    uint8_t sprite_2_addr_lo[64];

    for(i=0; i<512; i++) 
    { 
        x = i & 255; 
        if(x > 127) x = 256 - x; 
        y = (x*x) / 64; 
        mulTable[i] = y & 255; 
    }

    for(i=0; i<64; i++)
    {
        perspective[i] = focale / (i/zscale - z0);
    }

    for(int i=0; i<256; i++)
    {
        sinTable[i] = 32. * sin(2.*i*M_PI/256.);
        cosTable[i] = 32. * cos(2.*i*M_PI/256.);
    }

    for(int i=0; i<64; i++)
    {
        sprite_2_addr_lo[i] = 0x2 + round(10 * sin(i * M_PI / 64));
    }

    print_table("spiral_mul", mulTable, 512);
    print_table("spiral_perspective", (int8_t*)perspective, 64);    
    print_table("cos_tbl", cosTable, 256);
    print_table("sin_tbl", sinTable, 256);
    print_table("spiral_size", (int8_t*)sprite_size, 64);
    print_table("spiral_spr_lo", (int8_t*)sprite_addr_lo, 64);
    print_table("spiral_2_spr_lo", (int8_t*)sprite_2_addr_lo, 64);

    for(int i=0; i<88; i++)
    {
        sinTable[i] = 32. * sin(i * 5. * M_PI / 44.0);
        cosTable[i] = 32. * cos(i * 5. * M_PI / 44.0);
    }

    print_table("spiral_2_cos", cosTable, 88);
    print_table("spiral_2_sin", sinTable, 88);

    int8_t t0[256], t1[256];

    for(int i=0; i<256; i++)
    {
        float dt = sin(2.0*i*M_PI/256.0);
        float ds = cos(2.0*i*M_PI/256.0);
        
        float cs = cos(2.0*M_PI*(0.5*dt+0.25)) * (0.25*ds + 0.75);
        float sn = sin(2.0*M_PI*(0.5*dt+0.25)) * (0.25*ds + 0.75);
    
        cosTable[i] = 64. * cs;
        sinTable[i] = 64. * sn;
        
        t0[i] = 64. * dt;
        t1[i] = 64. * ds;
    }

    print_table("spiral_3_dt", t0, 256);
    print_table("spiral_3_ds", t1, 256);
    print_table("spiral_3_cos", cosTable, 256);
    print_table("spiral_3_sin", sinTable, 256);
    
    return EXIT_SUCCESS;
}
