#include <errno.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <unistd.h>
#include <libgen.h>


#include "utils/png.h"
#include "utils/vram.h"
#include "utils/vce.h"
#include "utils/raw.h"

int isPow2(int x)
{
    return ((x != 0) && !(x & (x - 1)));
}

int main(int argc, char* const argv[])
{
    int ret;
    uint8_t *buffer = NULL;
    uint8_t *tmp = NULL;
    
    char *path[2];
    char *directory;
    char *filename;

    size_t size;
    Image img;

    // Extract path and filename from input json file.
    path[0] = strdup(argv[1]);
    path[1] = strdup(argv[1]);

    directory = dirname (path[0]);
    filename  = basename(path[1]);

    // The path of the json file is now the current working directory. 
    chdir(directory);

    free(path[0]);
    
    ret = png_load(filename, &img);
    if(!ret)
    {
        fprintf(stderr, "failed to load %s\n", filename);
    }
    else if((1 != img.bytes_per_pixel) || (img.color_count > 16))
    {
        fprintf(stderr, "invalid image color depth (expected 16 colors indexed image)\n", filename);
        ret = 0;
    }
    else
    {
        /*
        tmp = (uint8_t*)malloc(img.width * img.height);
        
        for(int i=0; i<img.width; i+=8)
        {
            for(j=0; j<2; j++)
            {
                for(y=0; y<8; y++)
                {
                    for(x=0; x<8; x++)
                    {
                        tmp[(i*8) + x + (j*8) + (y*img.width*2)] = img->data[(i*8) + x+ ((y+j*8)*img.width)];
                    }
                }
            }
        }
        
        free(img.data);
        img.data = tmp;
        img.width *= 2;
        img.height = 8;
        */
        char out[256];
        snprintf(out, 256, "%s.tiles", filename);
        
        buffer = realloc(buffer, img.width * img.height * 4);
        ret = image_to_tiles(&img, 8, 16, buffer, &size);
        if(ret)
        {
            ret = write_raw(out, buffer, size);
            if(!ret)
            {
                fprintf(stderr, "failed to write %s\n", out);
            }
        }

        if(ret)
        {
            uint8_t rgb_333[32];
            snprintf(out, 256, "%s.pal", filename);
            color_convert(img.palette, rgb_333, img.color_count);
            ret = write_raw(out, rgb_333, 32);
            if(!ret)
            {
                fprintf(stderr, "failed to write %s\n", out);
            }
        }
    }
    destroy_image(&img);
    free(buffer);

    return ret ? EXIT_SUCCESS : EXIT_FAILURE;
}
