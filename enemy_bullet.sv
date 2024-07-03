module enemy_bullet(
    input frame_clk, 
    input [9:0] enemy_base_tl_x, enemy_base_tl_y, // TL Corner of base that is always moving
    
    output [9:0] enemy_bullet_x, enemy_bullet_y,
    output show_bullet
);

logic [9:0] enemy_base_x_center;
logic [9:0] enemy_base_y_center;
assign enemy_base_x_center = enemy_base_tl_x + 32;
assign enemy_base_y_center = enemy_base_tl_y + 36;

parameter [9:0] Ship_Center_X = 320;  // Center position on the X axis
parameter [9:0] Ship_Center_Y = 240;  // Center position on the Y axis
logic shoot_bullet;
parameter [7:0] bullet_range = 8'd100;
logic [7:0] bullet_distance_traveled;

// refine where the ship is relative to enemy base, and shoot when it's close
// determine which side of the base L/R the ship is on, to determine bullet direction
logic [1:0] shoot_l_or_r;

always_ff @(posedge frame_clk) begin

    if (shoot_bullet == 1'b0) begin
        if ((Ship_Center_X <= enemy_base_x_center + 100 && Ship_Center_X >= enemy_base_x_center - 100) && 
				(Ship_Center_Y <= enemy_base_y_center + 75 && Ship_Center_Y >= enemy_base_y_center - 75)) begin

            shoot_bullet <= 1'b1;
            show_bullet <= 1'b1;
            enemy_bullet_x <= enemy_base_x_center;
            enemy_bullet_y <= enemy_base_y_center;
        end
    end else begin

       shoot_l_or_r <= (enemy_base_x_center >= Ship_Center_X) ? 2'b10 : 2'b01; // 2'b10 = left , 2'b01 = right
       enemy_bullet_y <= enemy_base_y_center;

       if (bullet_distance_traveled >= bullet_range) begin
            shoot_bullet <= 1'b0;
            show_bullet <= 1'b0;
            bullet_distance_traveled <= 0;
            enemy_bullet_x <= enemy_base_x_center;
       end else begin

            if (shoot_l_or_r == 2'b10) begin           
                enemy_bullet_x <= enemy_bullet_x - 2; 
                bullet_distance_traveled <= bullet_distance_traveled + 2;
            end
            else if (shoot_l_or_r == 2'b01) begin
                
                enemy_bullet_x <= enemy_bullet_x + 2; 
                bullet_distance_traveled <= bullet_distance_traveled + 2;
            end
       end
    end

end

endmodule   