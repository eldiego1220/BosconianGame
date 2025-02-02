
module color_mapper (
    input [9:0] DrawX, DrawY,
    input [7:0] keycode,
    input       
      shoot_bullet,
      
      moving,
      VGA_Clk,
      blank,
      sys_clk,
      frame_clk,

    output logic [7:0] 
    Red,
    Green,
    Blue
);
  logic ship_on, bullet_on;

  logic [3:0] Size;
  assign Size = 14;

  // logic [11:0] data_out_fb;
  // logic [11:0] data_in_fb;

  // assign data_in_fb = {Red, Green, Blue};
  // assign Red_out = data_out_fb[11:8];
  // assign Green_out = data_out_fb[7:4];
  // assign Blue_out = data_out_fb[3:0];
  // localparam SCREEN_XDIM = 320;
  // localparam SCREEN_YDIM = 360;

  // framebuffer #(WIDTH = 12, DEPTH = 115200) fb (
  //   .clk_w(sys_clk),
  //   .clk_r(VGA_Clk),
  //   .we(1'b1),
  //   .addr_w(DrawX[9:1] + DrawY[9:1]*640),
  //   .addr_r(DrawX_idx + DrawY_idx*640), 
  //   .d_in(data_in_fb),
  //   .d_out(data_out_fb)
  // );
  parameter [9:0] Ship_TL_Corner_X = 313;
  parameter [9:0] Ship_TL_Corner_Y = 233; 
  always_comb begin : Ship_on
    if ((DrawX >= Ship_TL_Corner_X) && (DrawX <= Ship_TL_Corner_X + Size) && (DrawY >= Ship_TL_Corner_Y) && (DrawY <= Ship_TL_Corner_Y + Size))
      ship_on = 1'b1;
    else ship_on = 1'b0;

    if ( (  ((DrawX >= x_pos_bullet_1 - 1) && (DrawX <= x_pos_bullet_1 + 1) && (DrawY >= y_pos_bullet_1 - 1) && (DrawY <= y_pos_bullet_1 + 1)) || 
            ((DrawX >= x_pos_bullet_2 - 1) && (DrawX <= x_pos_bullet_2 + 1) && (DrawY >= y_pos_bullet_2 - 1) && (DrawY <= y_pos_bullet_2 + 1)) 
         )  && bullets_exist == 1'b1) begin
      bullet_on = 1'b1;
    end 
    else 
      bullet_on = 1'b0;
  end

  always_comb begin : RGB_Display
    if ((ship_on == 1'b1)) begin
      Red   = Red_Ship;
      Green = Green_Ship;
      Blue  = Blue_Ship;
    end else if (bullet_on == 1'b1) begin
      Red   = 8'hFF;
      Green = 8'h00;
      Blue  = 8'h00;
    end else begin
      Red   = Red_scroll;
      Green = Green_scroll;
      Blue  = Blue_scroll;
    end

  end
  // bullet logic
  always_ff @(posedge frame_clk) begin
    if (keycode == 8'h2C && bullets_exist == 1'b0) begin
      shoot <= 1'b1;
    end else if (bullets_exist == 1'b1) begin
      shoot <= 1'b0;
    end
  end

  logic [9:0] DrawX_pos, DrawY_pos, DrawX_idx, DrawY_idx, DrawX_offset, DrawY_offset;
  always_ff @(posedge VGA_Clk) begin
    if (moving == 1'b0) begin
      DrawX_idx <= DrawX;
      DrawY_idx <= DrawY;
    end 
  end

  logic up, left, down, right, bullet_left_right;
  logic [3:0] ship_orientation;
  
  always_ff @(posedge frame_clk) begin
    ship_orientation = {up, down, right, left};

    if (moving) begin
      if (keycode == 8'h1A) begin 
        up <= 1'b1;
        down <= 1'b0;
        left <= 1'b0;
        right <= 1'b0;
      end else if (keycode == 8'h16) begin
        up <= 1'b0;
        down <= 1'b1;
        left <= 1'b0;
        right <= 1'b0;
      end else if (keycode == 8'h04) begin
        up <= 1'b0;
        down <= 1'b0;
        left <= 1'b1;
        right <= 1'b0;
      end else if (keycode == 8'h07) begin
        up <= 1'b0;
        down <= 1'b0;
        left <= 1'b0;
        right <= 1'b1;
      end
      else begin
        left <= left;
        right <= right;
        up <= up;
        down <= down;
      end
    end else begin 
      up <= 1'b0;
      down <= 1'b0;
      left <= 1'b0;
      right <= 1'b0;
    end

  end


  logic [7:0] Red_scroll, Blue_scroll, Green_scroll;

  Boscanian_Background_example bgk (
      .vga_clk(VGA_Clk),
		  .frame_clk(frame_clk),
      .DrawX(DrawX),
      .DrawY(DrawY),
      .direction(ship_orientation),
      .blank(blank),
      .red(Red_scroll),
      .green(Green_scroll),
      .blue(Blue_scroll)
  );

  logic [7:0] Red_Ship, Green_Ship, Blue_Ship;


  spaceship user_ship (
      .VGA_Clk(VGA_Clk),
      .DrawX(DrawX),
      .DrawY(DrawY),
      .draw_enable(ship_on),
      .direction(ship_orientation),
      .Red(Red_Ship),
      .Green(Green_Ship),
      .Blue(Blue_Ship)

  );
  logic [9:0] x_pos_bullet_1, y_pos_bullet_1, x_pos_bullet_2, y_pos_bullet_2;
  logic bullets_exist, shoot;

  bullet bullet1 (
    .shoot_bullet(shoot), 
    .frame_clk(frame_clk),
	  .direction(ship_orientation), // for combinations of directions: up, down, diagonals
	  .x_pos_bullet_1(x_pos_bullet_1), .y_pos_bullet_1(y_pos_bullet_1),
    .x_pos_bullet_2(x_pos_bullet_2), .y_pos_bullet_2(y_pos_bullet_2),
	  .exists(bullets_exist)
  );

endmodule
