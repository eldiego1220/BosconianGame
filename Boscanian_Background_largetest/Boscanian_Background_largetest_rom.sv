module Boscanian_Background_largetest_rom (
	input logic clock,
	input logic [19:0] address,
	output logic [1:0] q
);

logic [1:0] memory [0:691199] /* synthesis ram_init_file = "./Boscanian_Background_largetest/Boscanian_Background_largetest.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
