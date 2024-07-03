module bullet (
    input logic shoot_bullet,
    frame_clk,
    vga_clk,
    input logic [3:0] direction,  // for combinations of directions: up, down, diagonals

    output logic [9:0] x_pos_bullet_1,
    y_pos_bullet_1,
    x_pos_bullet_2,
    y_pos_bullet_2,
    output logic exists

);
  parameter [6:0] bullet_range = 7'd120;
  logic [6:0] bullet_distance_traveled, y_offset, x_offset, change_x, change_y;
  parameter [9:0] Ship_Center_X = 320;  // Center position on the X axis
  parameter [9:0] Ship_Center_Y = 240;  // Center position on the Y axis
  logic shoot_left_right;

  always_ff @(posedge frame_clk) begin
    if (shoot_bullet) begin
      bullet_distance_traveled <= 7'd0;
      exists <= 1'b1;
      x_pos_bullet_1 <= Ship_Center_X;
      y_pos_bullet_1 <= Ship_Center_Y;

      x_pos_bullet_2 <= Ship_Center_X;
      y_pos_bullet_2 <= Ship_Center_Y;
      y_offset <= 0;
      x_offset <= 0;
      change_x <= 0;
      change_y <= 0;

      if (direction == 4'b1000 || direction == 4'b0100) begin  // up down
        shoot_left_right <= 1'b0;
      end else begin  // left right
        shoot_left_right <= 1'b1;
      end
    end else if (exists) begin
      if (bullet_distance_traveled >= bullet_range) begin
        exists <= 1'b0;
        bullet_distance_traveled <= 0;
      end else begin
        bullet_distance_traveled <= bullet_distance_traveled + 2;

        if (shoot_left_right == 1'b1) begin  // left right
          x_offset <= x_offset + 2;
          x_pos_bullet_1 <= (Ship_Center_X + x_offset);
          x_pos_bullet_2 <= (Ship_Center_X - x_offset);
          if (direction == 4'b1000) begin  // case where ship changes direction mid bullet shot
            change_y <= (change_y + 1);
            change_x <= 0;
            y_pos_bullet_1 <= (Ship_Center_Y + change_y);
            y_pos_bullet_2 <= (Ship_Center_Y + change_y);
          end else if (direction == 4'b0100) begin
            change_y <= (change_y + 1);
            change_x <= 0;
            y_pos_bullet_1 <= (Ship_Center_Y - change_y);
            y_pos_bullet_2 <= (Ship_Center_Y - change_y);

          end else begin
            y_offset <= 0;
            y_pos_bullet_1 <= (Ship_Center_Y);
            y_pos_bullet_2 <= (Ship_Center_Y);
          end

        end else begin
          y_offset <= y_offset + 2;
          y_pos_bullet_1 <= (Ship_Center_Y + y_offset);
          y_pos_bullet_2 <= (Ship_Center_Y - y_offset);
          if (direction == 4'b0010) begin  // case where ship changes direction mid bullet shot
            change_x <= (change_x + 1);
            change_y <= 0;
            x_pos_bullet_1 <= (Ship_Center_X  - change_x);
            x_pos_bullet_2 <= (Ship_Center_X  - change_x);

          end else if (direction == 4'b0001) begin
            change_x <= (change_x + 1);
            change_y <= 0;
            x_pos_bullet_1 <= (Ship_Center_X  + change_x);
            x_pos_bullet_2 <= (Ship_Center_X  + change_x);
          end else begin
            x_offset <= 0;
            x_pos_bullet_1 <= (Ship_Center_X );
            x_pos_bullet_2 <= (Ship_Center_X );
          end
        end
      end

    end
  end


endmodule
