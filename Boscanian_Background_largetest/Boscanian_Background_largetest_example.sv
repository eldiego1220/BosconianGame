module Boscanian_Background_largetest_example (
	input logic vga_clk, frame_clk,  collided,
	input [1:0] direction,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	output logic [3:0] red, green, blue
);

logic [19:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
//assign rom_address = ((DrawX * 960) / 640) + (((DrawY * 720) / 480) * 960);
assign rom_address = (DrawX + x_offset)  % 640 + ((DrawY[9:0] + y_offset ) % 480) * 960;

logic [9:0] x_offset, y_offset;
always_ff @ (posedge frame_clk) begin


	case (direction)   

        4'b1000: begin // up
			y_offset <= y_offset - 1;
        end
        4'b0100: begin // down
			y_offset <= y_offset + 1;
        end
        4'b0010: begin // right
			x_offset <= x_offset + 1;
        end
        4'b0001: begin // left
			x_offset <= x_offset - 1;
        end
        default: begin
			x_offset <= 10'd0;
			y_offset <= 10'd0;
        end
		  
    endcase
end


always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
	end
end

Boscanian_Background_largetest_rom Boscanian_Background_largetest_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

Boscanian_Background_largetest_palette Boscanian_Background_largetest_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
