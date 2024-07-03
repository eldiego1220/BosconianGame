module spaceship(
    input logic VGA_Clk, 
    input logic [9:0] DrawX, DrawY,
    input logic draw_enable, collision,
    input [3:0] direction,
	 output logic [1:0] data,
    output logic [7:0] Red, Green, Blue);

always_comb begin
	 if(collision) begin
		Red = R_ship_exp;
		Green = G_ship_exp;
		Blue = B_ship_exp;
		data = data_up;
	 end	
	 else begin
    case (direction)   

        4'b1000: begin
            Red   = R_ship_up;
            Green = G_ship_up;
            Blue  = B_ship_up;
				data = data_up;
        end
        4'b0100: begin
            Red   = R_ship_down;
            Green = G_ship_down;
            Blue  = B_ship_down;
				data = data_down;
        end
        4'b0010: begin
            Red   = R_ship_right;
            Green = G_ship_right;
            Blue  = B_ship_right;
				data = data_right;
        end
        4'b0001: begin
            Red   = R_ship_left;
            Green = G_ship_left;
            Blue  = B_ship_left;
				data = data_left;
        end
        default: begin
				Red   = R_ship_up;
            Green = G_ship_up;
            Blue  = B_ship_up;
				data = data_up;
        end
		  
    endcase
	 end
end

 logic [7:0] R_ship_up, G_ship_up, B_ship_up;
 logic [1:0] data_up;

white_spaceship_up_example up (
	.vga_clk(VGA_Clk),
	.DrawX(DrawX-5), .DrawY(DrawY),
	.blank(draw_enable),
	.rom(data_up),
	.red(R_ship_up), .green(G_ship_up), .blue(B_ship_up)
);

 logic [7:0] R_ship_down, G_ship_down, B_ship_down;
 logic [1:0] data_down;
white_spaceship_down_example down (
	.vga_clk(VGA_Clk),
	.DrawX(DrawX-4), .DrawY(DrawY),
	.blank(draw_enable),
	.rom(data_down),
	.red(R_ship_down), .green(G_ship_down), .blue(B_ship_down)
);            

 logic [7:0] R_ship_right, G_ship_right, B_ship_right;
 logic [1:0] data_right;
white_spaceship_right_example right (
	.vga_clk(VGA_Clk),
	.DrawX(DrawX-5), .DrawY(DrawY),
	.blank(draw_enable),
	.rom(data_right),
	.red(R_ship_right), .green(G_ship_right), .blue(B_ship_right)
);           

logic [7:0] R_ship_left, G_ship_left, B_ship_left;
logic [1:0] data_left;
white_spaceship_left_example left (
	.vga_clk(VGA_Clk),
	.DrawX(DrawX + 303), .DrawY(DrawY + 234),
	.blank(draw_enable),
	.rom(data_left),
	.red(R_ship_left), .green(G_ship_left), .blue(B_ship_left)
);  

logic [7:0] R_ship_exp, G_ship_exp, B_ship_exp;

spaceship_explosion_example explosion (
      .vga_clk(VGA_Clk),
      .DrawX(DrawX + 300),
      .DrawY(DrawY + 232),
      .blank(draw_enable),
      .red(R_ship_exp),
      .green(G_ship_exp),
      .blue(B_ship_exp)
);		
 
endmodule