AS = ~/Dev/bin/pceas
SRCDIR = ./src
INCLUDE = -I . -I ./src/ -I ./include/
EMU = mednafen

main.pce:
	$(AS) -l 3 $(INCLUDE) -I ./src/ramcode/ -raw ./src/ramcode/transform.ramcode.asm
	@bash ./tools/ramcode.sh -o ./data -i ./src/ramcode/transform.ramcode.pce \
		rx ry rz \
		vertice_count \
		vertex_x vertex_y vertex_z \
		out_x out_y out_z \
		transform
	$(AS) -l 3 $(INCLUDE) -I ./src/ramcode/ -raw ./src/ramcode/spiral.ramcode.asm
	@bash ./tools/ramcode.sh -o ./data -i ./src/ramcode/spiral.ramcode.pce \
		spiral spiral_update spiral_update_2 spiral_update_3
	$(AS) -S -l 3 $(INCLUDE) -raw ./src/main.asm 

run:
	$(EMU) $(SRCDIR)/main.pce

clean:
	rm $(SRCDIR)/*.sym
