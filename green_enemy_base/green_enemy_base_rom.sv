module green_enemy_base_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:4607] /* synthesis ram_init_file = "./green_enemy_base/green_enemy_base.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
