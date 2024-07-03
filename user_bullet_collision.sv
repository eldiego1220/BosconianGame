module user_bullet_collision (
    input frame_clk,
    input [9:0] Base_TL_Corner_X, Base_TL_Corner_Y,
    x_pos_bullet_1, x_pos_bullet_2, y_pos_bullet_1,
    y_pos_bullet_2,
    output enemy_hit

);

parameter [9:0] Base_size_x = 64; 
parameter [9:0] Base_size_y = 72;

logic [9:0] Base_center_x; 
logic [9:0] Base_center_y;

assign Base_center_x = Base_TL_Corner_X + 32; 
assign Base_center_y = Base_TL_Corner_Y + 36;


always_ff @(posedge frame_clk) begin //try vga clk after change RGB_Display to frame_clk
    //assumption that all enemy bases are horizontally oriented
    if ((Base_center_y  + 5 >= y_pos_bullet_1  && Base_center_y - 5 <= y_pos_bullet_1 ) ||
        (Base_center_y  + 5 >= y_pos_bullet_2 && Base_center_y - 5 <= y_pos_bullet_2)) begin // see if it's horizontal first

        if ((Base_center_x  + 5 >= x_pos_bullet_1  && Base_center_x - 5 <= x_pos_bullet_1 ) ||
             (Base_center_x  + 5 >= x_pos_bullet_2 && Base_center_x - 5 <= x_pos_bullet_2)) begin   
            enemy_hit <= 1'b1;
        end else begin 
            enemy_hit <= 1'b0; 
        end
      
    end 
    else begin 
        enemy_hit <= 1'b0;
    end
    

end

endmodule