module Boscanian_Background_large_test_rom (
	input logic clock,
	input logic [19:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:691199] /* synthesis ram_init_file = "./Boscanian_Background_large_test/Boscanian_Background_large_test.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
