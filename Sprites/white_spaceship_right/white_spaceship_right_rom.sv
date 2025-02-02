module white_spaceship_right_rom (
	input logic clock,
	input logic [7:0] address,
	output logic [1:0] q
);

logic [1:0] memory [0:195] /* synthesis ram_init_file = "./Sprites/white_spaceship_right/white_spaceship_right.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
