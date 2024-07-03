module green_enemy_base_vert_example (
	input logic vga_clk, frame_clk,
	input logic [9:0] DrawX, DrawY,
	input [3:0] direction,
	input logic blank, draw_enable, collided,
	output logic [2:0] rom,
	output logic [9:0] Base_X, Base_Y,
	output logic [3:0] red, green, blue
);

logic [12:0] rom_address;
logic [2:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
assign rom_address = ((DrawX - TL_Corner_X) % 72) + ((DrawY - TL_Corner_Y) % 64) * 72;
assign rom = rom_q;

logic  [9:0] TL_Corner_X = 300;
logic  [9:0] TL_Corner_Y = 300; 
logic [9:0] x_offset, y_offset;
always_ff @ (posedge frame_clk) begin

	if (collided) begin
		TL_Corner_Y <= TL_Corner_Y;
		TL_Corner_X <= TL_Corner_X;
	end
	case (direction)   

        4'b1000: begin // up
			TL_Corner_Y <= TL_Corner_Y + 1;
        end
        4'b0100: begin // down
			TL_Corner_Y <= TL_Corner_Y - 1;
        end
        4'b0010: begin // right
			TL_Corner_X <= TL_Corner_X - 1;
        end
        4'b0001: begin // left
			TL_Corner_X <= TL_Corner_X + 1;
        end
        default: begin

			TL_Corner_X <= 10'd300;
			TL_Corner_Y <= 10'd300;
        end
		  
    endcase
end

assign Base_X = TL_Corner_X;
assign Base_Y = TL_Corner_Y;

always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank && draw_enable) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
	end
end

green_enemy_base_vert_rom green_enemy_base_vert_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

green_enemy_base_vert_palette green_enemy_base_vert_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
