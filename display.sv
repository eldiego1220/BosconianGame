
module display (
    input        [9:0] DrawX,DrawY,
    input        [7:0] keycode,
    input              shoot_bullet,
    moving,
    VGA_Clk,
    blank,
    sys_clk,

    output logic [7:0] 
    Red_out,
    Green_out,
    Blue_out
);

  logic ball_on, bullet_on, shoot;

  logic [3:0] Size, Red, Green, Blue;
  assign Size = 6;

  logic [11:0] data_out_fb;
  logic [11:0] data_in_fb;
  assign data_in_fb = {Red, Green, Blue};
  assign Red_out = data_out_fb[11:8];
  assign Green_out = data_out_fb[7:4];
  assign Blue_out = data_out_fb[3:0];
  localparam SCREEN_XDIM = 320;
  localparam SCREEN_YDIM = 360;

  framebuffer #(WIDTH = 12, DEPTH = 115200) fb (
    .clk_w(sys_clk),
    .clk_r(VGA_Clk),
    .we(1'b1),
    .addr_w(DrawX[9:1] + DrawY[9:1]*640),
    .addr_r(DrawX_idx + DrawY_idx*640), 
    .d_in(data_in_fb),
    .d_out(data_out_fb)
  );

  parameter [9:0] Ball_X_Center = 320;  // Center position on the X axis
  parameter [9:0] Ball_Y_Center = 240;  // Center position on the Y axis
  logic [9:0] bullet_pos_x, bullet_pos_y;

  always_comb begin : Ball_on_proc
    if ((DrawX >= Ball_X_Center - Size) && (DrawX <= Ball_X_Center + Size) &&
      (DrawY >= Ball_Y_Center - Size) && (DrawY <= Ball_Y_Center + Size))
        ball_on = 1'b1;
    else ball_on = 1'b0;

    if (DrawX_pos == bullet_pos_x && 
        DrawY_pos <= bullet_pos_y + 1 && DrawY_pos >= bullet_pos_y - 1 && 
        shoot == 1'b1) begin
      bullet_on = 1'b1;
    end else bullet_on = 1'b0;

  end

  always_comb begin : RGB_Display
    if ((ball_on == 1'b1)) begin
      Red   = 8'hff;
      Green = 8'h55;
      Blue  = 8'h00;
    end else if (bullet_on == 1'b1) begin
      Red   = 8'h00;
      Green = 8'hff;
      Blue  = 8'h00;
    end else begin
      Red   = Red_scroll;
      Green = Green_scroll;
      Blue  = Blue_scroll;
    end

  end
//   logic [5:0] bullet_length;
// // bullet logic
//   always_ff @(posedge VGA_Clk) begin
//     if (keycode == 8'h2C) begin
//       shoot <= 1'b1;
//       bullet_pos_x <= Ball_X_Center;
//       bullet_pos_y <= Ball_Y_Center;
//       bullet_length <= 6'd64;
//     end

//     if (shoot == 1'b1) begin
//       bullet_length <= bullet_length - 1;

//       if (bullet_length <= 5'd1) begin
//         shoot <= 0;
//       end

//       if (up) begin
//         bullet_pos_x <= bullet_pos_x;
//         bullet_pos_y <= bullet_pos_y + 1;
//       end else if (down) begin
//         bullet_pos_x <= bullet_pos_x;
//         bullet_pos_y <= bullet_pos_y - 1;
//       end else if (left) begin
//         bullet_pos_x <= bullet_pos_x - 1;
//         bullet_pos_y <= bullet_pos_y;
//       end else if (right) begin
//         bullet_pos_x <= bullet_pos_x + 1;
//         bullet_pos_y <= bullet_pos_y;
//       end

//     end
//   end
  logic [9:0] DrawX_temp, DrawY_temp, DrawX_pos, DrawY_pos, DrawX_idx, DrawY_idx;
  logic clkdiv;
  logic [1:0] clk_cnt;

  always_ff @(posedge sys_clk) begin
    if (moving == 1'b0) begin
      DrawX_pos <= DrawX;
      DrawY_pos <= DrawY;
    end else begin

      if (DrawX_pos >= 10'd637) begin
        DrawX_pos <= 10'd160;
        DrawY_pos <= DrawY_pos + 1;
      end else if (DrawY_pos >= 10'd477) begin
        DrawY_pos <= 10'd60;
      end else begin
        DrawX_pos <= DrawX_pos + 1;
      end

    end
  end

  logic up, left, down, right, bullet_left_right;

  always_ff @(posedge sys_clk) begin

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
    end else begin
      left <= left;
      right <= right;
      up <= up;
      down <= down;
    end


    if (left == 1'b1) begin
      DrawX_idx <= DrawX_pos - 1;
    end else if (right == 1'b1) begin
      DrawX_idx <= DrawX_pos + 1;
    end else begin
      DrawX_idx <= DrawX_pos;
    end

    if (up == 1'b1) begin
      DrawY_idx <= DrawY_pos - 1;
    end else if (down == 1'b1) begin
      DrawY_idx <= DrawY_pos + 1;
    end else begin
      DrawY_idx <= DrawY_pos;
    end

  end


  logic [7:0] Red_scroll, Blue_scroll, Green_scroll;

  Boscanian_Background_example bgk (

      .vga_clk(sys_clk),
      .DrawX(DrawX_idx),
      .DrawY(DrawY_idx),
      .blank(blank),
      .red(Red_scroll),
      .green(Green_scroll),
      .blue(Blue_scroll)

  );


endmodule
