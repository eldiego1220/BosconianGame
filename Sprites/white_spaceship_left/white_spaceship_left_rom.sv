module white_spaceship_left_rom (
	input logic clock,
	input logic [7:0] address,
	output logic [1:0] q
);

logic [1:0] memory [0:195] /* synthesis ram_init_file = "./Sprites/white_spaceship_left/white_spaceship_left.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
