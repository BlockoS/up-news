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
 * Encode sprite
 * author : MooZ
 */ 
#include <errno.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <libgen.h>

#include "utils/png.h"
#include "utils/vram.h"
#include "utils/vce.h"
#include "utils/raw.h"

int main(int argc, char *argv[])
{
    int ret;
    
    char* path;
    char* directory;
    char* prefix;
    
    char out[256];
    
    Image img;
    
    uint8_t* buffer = NULL;
    size_t sz;
    size_t used;

    uint8_t rgb_333[32];
    
    if(argc < 3)
    {
        fprintf(stderr,"Usage: %s input.pcx output_prefix\n",argv[0]);
        return EXIT_FAILURE;
    }
    prefix = argv[2];

    /* Extract path and filename from input file */
    path = strdup(argv[1]);
    directory = dirname (path);
 
    /* Switch current directory to the input file one */
    chdir(directory);

    free(path);

    /* Read image. */
    ret = png_load(argv[1], &img);
    if(!ret)
    {
        fprintf(stderr,"Error while loading %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    /* Sanity check. */
    if(16 != img.height) // [todo] 
    {
        fprintf(stderr, "Invalid image height\n");
        goto end;
    }
    if(img.width & 0x0f)
    {
        fprintf(stderr, "Invalid image width (%d)\n", img.width);
        goto end;
    }
    if(img.color_count > 16)
    {
        fprintf(stderr, "Invalid color count %d\n", img.color_count);
        goto end;
    }
    
    sz = (img.width * img.height) / 2;
    buffer = (uint8_t*)malloc(sz);
    if(NULL == buffer)
    {
        fprintf(stderr, "Failed to allocate sprite buffer: %s\n", strerror(errno));
        goto end;
    }

    printf("%s: %dx%d\n", argv[1], img.width, img.height);

    /* Convert to sprites. */
    ret = image_to_sprites(&img, buffer, &used);
    if(!ret)
    {
        fprintf(stderr, "Failed to convert %s to sprites\n", argv[1]);
        goto end;
    }

    /* Write sprite data. */
    snprintf(out, 256, "%s.bin", prefix);
    ret = write_raw(out, buffer, used);
    if(!ret)
    {
        fprintf(stderr, "Failed to write sprite data: %s\n", out);
        goto end;
    }

    /* Write palette. */
    snprintf(out, 256, "%s.pal", prefix);
    color_convert(img.palette, rgb_333, img.color_count);
    ret = write_raw(out, rgb_333, 32);
    if(!ret)
    {
        fprintf(stderr, "Failed to write palette data: %s\n", out);
        goto end;
    }
    
end:
    if(buffer)
    {
        free(buffer);
    }
    destroy_image(&img);
    return ret ? EXIT_SUCCESS : EXIT_FAILURE;
}
