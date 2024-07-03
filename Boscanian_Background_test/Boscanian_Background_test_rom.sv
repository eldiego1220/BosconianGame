module Boscanian_Background_test_rom (
	input logic clock,
	input logic [18:0] address,
	output logic [1:0] q
);

logic [1:0] memory [0:307199] /* synthesis ram_init_file = "./Boscanian_Background_test/Boscanian_Background_test.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
