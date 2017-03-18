#include <stdlib.h>
#include <math.h>

#include "utils/print.h"

int main()
{
    int8_t zdiv[256];
    int i;

    float focale = 280.;
    float z0 = -4.;

    for(i=0; i<256; i++)
    {
        float z = i;
        if(z > 127.0) z = z - 256.0;
        z = focale / (z/64.0f - z0);
        zdiv[i] = (uint8_t)round(z);
    }
    print_table("zdiv_tbl", zdiv, 256);

    return EXIT_SUCCESS;
}
