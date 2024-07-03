module framebuffer #(
    parameter WIDTH=4,  // 4 bits per pixel RGB, these pixels index into a color palette
    parameter DEPTH=256, // 320 * 360
    parameter INIT_F="",
    localparam ADDR_WIDTH = $clog2(DEPTH)
    ) (
    input logic clk_w,               // write clock (port a) = 50MHz clock
    input logic clk_r,                // read clock (port b) = VGA CLK
    input logic we,                    // write enable (port a)
    input logic [ADDR_WIDTH-1:0] addr_w,   // write address (port a)
    input logic [ADDR_WIDTH-1:0] addr_r,    // read address (port b)
    input logic [WIDTH-1:0] d_in,     // data in (port a)
    output     logic [WIDTH-1:0] d_out     // data out (port b)
    );

    logic [WIDTH-1:0] memory [DEPTH];

    initial begin
        if (INIT_F != 0) begin
            $display("Loading memory init file '%s' into bram_sdp.", INIT_F);
            $readmemh(INIT_F, memory);
        end
    end

    // Port A: Sync Write
    always_ff @(posedge clk_w) begin
        if (we) memory[addr_w] <= d_in;
    end

    // Port B: Sync Read
    always_ff @(posedge clk_r) begin
        d_out <= memory[addr_r];
    end
endmodule