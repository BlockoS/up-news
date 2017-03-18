CC      := gcc
ECHO    := echo
RM      := rm
CD      := cd
TAR     := tar

CFLAGS  := -Wall -Wextra -Wshadow -std=gnu11 -I .
DEBUG   ?= 0
ifeq ($(DEBUG), 1)
    OUTDIR := $(OUTDIR)/Debug
    CFLAGS += -g -DDEBUG
else
    OUTDIR := $(OUTDIR)/Release
    CFLAGS += -O2
endif

LIBS   := -lm -lpng

SRC := utils/print.c utils/image.c utils/pcx.c utils/png.c utils/vram.c utils/raw.c utils/vce.c
OBJ := $(SRC:.c=.o)

DEPEND = .depend

all: $(OBJ) tiled2bat zdiv_table encode_sprite encode_8x16_tiles checker_tables

zdiv_table: zdiv_table.c utils/print.o
	@$(ECHO) "  LD        $@"
	@$(CC) -o $@ $^ -lm

tiled2bat: tiled2bat.c $(OBJ)
	@$(ECHO) "  LD        $@"
	@$(CC) -o $@ $^ $(LIBS) -ljansson

encode_sprite: encode_sprite.c $(OBJ)
	@$(ECHO) "  LD        $@"
	@$(CC) -o $@ $^ $(LIBS)

encode_8x16_tiles: encode_8x16_tiles.c $(OBJ)
	@$(ECHO) "  LD        $@"
	@$(CC) -o $@ $^ $(LIBS)

checker_tables: checker_tables.c $(OBJ)
	@$(ECHO) "  LD        $@"
	@$(CC) -o $@ $^ $(LIBS)

%.o: %.c
	@$(ECHO) "  CC        $@"
	@$(CC) $(CFLAGS) -c -o $@ $<

clean:
	@$(ECHO) "  CLEAN     object files"
	@find . -name "*.o" -exec $(RM) -f {} \;
