module Boscanian_Background_rom (
	input logic clock,
	input logic [18:0] address,
	output logic [0:0] q
);

logic [0:0] memory [0:307199] /* synthesis ram_init_file = "./Boscanian_Background/Boscanian_Background.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
