/* 
 *           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, December 2004
 *  
 * Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
 * 
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 *  
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 *  
 *  0. You just DO WHAT THE FUCK YOU WANT TO.
 */
/* 
 * Convert image to vram formats (tile and sprite).
 * author : MooZ
 */
#include "vram.h"

#include <stdio.h>
#include <string.h>

int bitmap_to_tile(uint8_t *in, uint8_t *out, int stride)
{
    int y;
    for(y=0; y<8; y++, in+=stride, out+=2)
    {
        int x;
        uint8_t *src = in;
        out[0] = out[1] = out[16] = out[17] = 0;
        for(x=7; x>=0; x--)
        {
            uint8_t byte = *src++;
            if(byte >= 16)
            {
                fprintf(stderr, "invalid input. The image must contain at most 16 colors.\n");
                return 0;
            }
            out[ 0] |= ((byte   ) & 0x01) << x;
            out[ 1] |= ((byte>>1) & 0x01) << x;
            out[16] |= ((byte>>2) & 0x01) << x;
            out[17] |= ((byte>>3) & 0x01) << x;
        }
    }
    return 1;   
}

int bitmap_to_sprite(uint8_t *out, uint8_t *in, int stride)
{
    int y;
    for(y=0; y<16; y++, in+=stride, out+=7)
    {
        int l;
        uint8_t *src = in;
        for(l=0; l<2; l++, out++)
        {
            int x;
            out[0] = out[2] = out[4] = out[6] = 0;
            for(x=7; x>=0; x--)
            {
                uint8_t byte = *src++;
                if(byte >= 16)
                {
                    fprintf(stderr, "invalid input. The image must contain at most 16 colors.\n");
                    return 0;
                }
                out[0] |= ((byte   ) & 0x01) << x;
                out[2] |= ((byte>>1) & 0x01) << x;
                out[4] |= ((byte>>2) & 0x01) << x;
                out[6] |= ((byte>>3) & 0x01) << x;
            }
        }
    }
    return 1;
}

int image_to_tiles(Image *img, int bloc_width, int bloc_height, uint8_t *buffer, size_t *size)
{
    *size = 0;
    if((img->height & 7) && (img->width & 7))
    {
        fprintf(stderr, "input width and height should be a multiple of 8 (%d,%d)\n", img->width, img->height);
        return 0;
    }
    
    if((bloc_width & 7) || (bloc_height & 7))
    {
        fprintf(stderr, "bloc width and height must be a multiple of 8 (%d, %d)\n", bloc_width, bloc_height);
        return 0;
    }
    
    int ret = 1;
    uint8_t *out = buffer;

    int stride = img->width*8;

    uint8_t *bloc_line = img->data;
    int bloc_stride = img->width * bloc_height;
    int by;
    for(by=0; ret && (by<img->height); by+=bloc_height, bloc_line+=bloc_stride)
    {
        uint8_t *bloc_ptr = bloc_line;
        int bx;
        for(bx=0; ret && (bx<img->width); bx+=bloc_width, bloc_ptr+=bloc_width)
        {
            uint8_t *line = bloc_ptr;   
            int j;
            for(j=0; ret && (j<bloc_height); j+=8, line+=stride)
            {
                int i;
                uint8_t *in = line;
                for(i=0; ret && (i<bloc_width); i+=8, out+=32, in+=8)
                {
                    ret = bitmap_to_tile(in, out, img->width);
                }
            }
        }
    }

    *size = out - buffer;
    return 1;
}

int image_to_sprites(Image *img, uint8_t *buffer, size_t *size)
{
    int j;
    uint8_t *out;
    
    *size = 0;
    
    if((img->height & 15) && (img->width & 15))
    {
        fprintf(stderr, "input width and height should be a multiple of 16 (%d,%d)\n", img->width, img->height);
        return 0;
    }
    
    out = buffer;
    for(j=0; j<img->height; j+=16)
    {
        int i;
        for(i=0; i<img->width; i+=16, out+=128)
        {
            int y;
            memset(out, 0, 128);
            for(y=0; y<16; y++)
            {
                int x;
                for(x=0; x<8; x++)
                {
                    uint8_t byte = img->data[(x+i) + ((y+j)*img->width)];
                    if(byte >= 16)
                    {
                        fprintf(stderr, "invalid input. The image must contain at most 16 colors.\n");
                        return 0;
                    }
                    
                    out[ 1 + y*2] |= ((byte & 0x01)     ) << (7-x);
                    out[33 + y*2] |= ((byte & 0x02) >> 1) << (7-x);
                    out[65 + y*2] |= ((byte & 0x04) >> 2) << (7-x);
                    out[97 + y*2] |= ((byte & 0x08) >> 3) << (7-x);
                }
                
                for(x=8; x<16; x++)
                {
                    uint8_t byte = img->data[(x+i) + ((y+j)*img->width)];
                    if(byte >= 16)
                    {
                        fprintf(stderr, "invalid input. The image must contain at most 16 colors.\n");
                        return 0;
                    }
                    out[ 0 + y*2] |= ((byte & 0x01)     ) << (15-x);
                    out[32 + y*2] |= ((byte & 0x02) >> 1) << (15-x);
                    out[64 + y*2] |= ((byte & 0x04) >> 2) << (15-x);
                    out[96 + y*2] |= ((byte & 0x08) >> 3) << (15-x);
                }
            }
        }
    }
    *size = out - buffer;
    return 1;
}
