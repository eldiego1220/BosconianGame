module test_rom (
	input logic clock,
	input logic [18:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:524288] /* synthesis ram_init_file = "./test/test.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
