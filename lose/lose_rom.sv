module lose_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [0:0] q
);

logic [0:0] memory [0:115199] /* synthesis ram_init_file = "./lose/lose.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
