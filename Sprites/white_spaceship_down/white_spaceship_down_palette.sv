module white_spaceship_down_palette (
	input logic [1:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:3][11:0] palette = {
	{4'h0, 4'h0, 4'h0},
	{4'hF, 4'hF, 4'hF},
	{4'hE, 4'h0, 4'h0},
	{4'h8, 4'h8, 4'h8}
};

assign {red, green, blue} = palette[index];

endmodule
