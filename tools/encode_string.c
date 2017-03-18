#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

int main(int argc, char **argv)
{
    int i, j;
    const char *txt[] =
    {
        "SWEDEN:   ONCE  AGAIN  UPROUGH  "
        "RELEASED  A  RUSHED  PRODUCTION ",
        
        "ON PC ENGINE.  THE ROYAL FAMILY "
        "DECLARED THAT NEXT TIME, THEY   ",
        
        "WILL ALL BE DEPORTED TO DENMARK "
        "WITH NO UNDERWEAR!              ",
        
        "MOOZ  AND  OCTAPUS ARE NOW UNDER"
        "THE  SCRUTINITY  OF THE SWEDISH ",

        "NINJA COMMANDOS.  YOU KNOW WHAT "
        "YOU ARE UP TO PUNKS!            ",

        "THE  CENTER  FOR  APPROXIMATIVE "
        "SCIENTIFIC  STUDIES  ANNOUNCED  ",

        "THAT  MUSTACHES ARE NOT MADE OF "
        "ALIEN  WORMS.  THEY ARE IN FACT ",

        "MADE OUT OF LEFT OVER SPAGHETTI "
        "YOU ARE ADVISED NOT TO EAT THEM.",

        "EVEN WITH CHILI SAUCE.          "
        "                                ",

        "CONSIDER YOURSELF GREETED.      "
        "IF NOT, LOOK INTO YOUR POCKETS. ",

        "THERE MIGHT BE SOMETHING FOR YOU"
        "DOWN THERE.                     ",

        NULL
    };

    printf("news.txt:\n");
    for(j=0; txt[j] != NULL; j++)
    {
        printf("    .db ");
        for(i=0; i<strlen(txt[j]); i++)
        {
            char c = txt[j][i];
            if(isalpha(c))
            {
                c = 1 + toupper(c) - 'A';
            }
            else if(isdigit(c))
            {
                c = 27 + c - '0';
            }
            else if(c == ' ')
            {
                c = 0;
            }
            else if(c == ',')
            {
                c = 37;
            }
            else if(c == '.')
            {
                c = 38;
            }
            else if(c == '-')
            {
                c = 39;
            }
            else if(c == '!')
            {
                c = 40;
            }
            else if(c == '?')
            {
                c = 41;
            }
            else if(c == ':')
            {
                c = 42;
            }
            else if(c == '%')
            {
                c = 43;
            }
            else
            {
                c = 0;
            }
            int data = c * 2;
            printf("$%02x", data);
            if(i && (0 == ((i+1)&0x0f)))
            {
                printf("\n    .db ");
            }
            else
            {
                printf(",");
            }
        }
        printf("$ff\n");
    }
    printf("news.count:\n    .db $%02x\n", j);
    return EXIT_SUCCESS;
}
