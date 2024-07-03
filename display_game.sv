module display_game (
    input [9:0] DrawX, DrawY,
    input [7:0] keycode,
    input       
      shoot_bullet,
      moving,
      VGA_Clk,
      blank,
      sys_clk,
      frame_clk, Reset,
    output lost, win,
    output logic [7:0] 
    Red,
    Green,
    Blue
);
  logic ship_on, bullet_on, enemy_base_one_on, enemy_base_two_on, collision;
  logic [1:0] data_ship;
  logic [2:0] data_base_one, data_base_two;

  logic [3:0] Size;
  assign Size = 14;

  
  //Ship
  parameter [9:0] Ship_TL_Corner_X = 313;
  parameter [9:0] Ship_TL_Corner_Y = 233; 
    always_ff @(posedge VGA_Clk) begin : Ship_on
    if (((DrawX >= Ship_TL_Corner_X) && (DrawX <= Ship_TL_Corner_X + Size) && 
		  (DrawY >= Ship_TL_Corner_Y) && (DrawY <= Ship_TL_Corner_Y + Size)) &&
		  data_ship > 2'b00)
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
  
  
  //Green Enemy Base
  logic [9:0] Base_TL_Corner_X_ONE;
  logic [9:0] Base_TL_Corner_Y_ONE;
  logic [9:0] Base_TL_Corner_X_TWO;
  logic [9:0] Base_TL_Corner_Y_TWO;

  logic [9:0] Base_size_x = 64; 
  logic [9:0] Base_size_y = 72;
  always_ff @(posedge VGA_Clk) begin : Base_on
    if (((DrawX >= Base_TL_Corner_X_ONE) && (DrawX <= Base_TL_Corner_X_ONE + Base_size_x) && 
		  (DrawY >= Base_TL_Corner_Y_ONE) && (DrawY <= Base_TL_Corner_Y_ONE + Base_size_y)) &&
		  data_base_one > 3'b001)

      enemy_base_one_on = 1'b1;
    else enemy_base_one_on = 1'b0;

    if (((DrawX >= Base_TL_Corner_X_TWO) && (DrawX <= Base_TL_Corner_X_TWO + Base_size_x) && 
		  (DrawY >= Base_TL_Corner_Y_TWO) && (DrawY <= Base_TL_Corner_Y_TWO + Base_size_y)) &&
		  data_base_two > 3'b001)

      enemy_base_two_on = 1'b1;
    else enemy_base_two_on = 1'b0;


  end

  assign lost = collision || enemy_b1_bullet_collision || enemy_b2_bullet_collision;
  always_ff @(posedge VGA_Clk) begin : Collision_Detector
    if ((ship_on == 1'b1) && (((enemy_base_one_on == 1'b1) && enemy_one_base_hit == 1'b0 ) 
         || (enemy_base_two_on == 1'b1 && enemy_two_base_hit == 1'b0 ) )) begin
          
      collision = 1'b1;
    end
    else begin 
	    collision = 1'b0;
	 end

    if ((ship_on == 1'b1) && (enemy_base_one_shoot_bullet == 1'b1) && enemy_one_base_hit == 1'b0) begin
      enemy_b1_bullet_collision = 1'b1;
    end
    else begin 
	    enemy_b1_bullet_collision = 1'b0;
	 end

    if ((ship_on == 1'b1) && (enemy_base_two_shoot_bullet == 1'b1)  && enemy_two_base_hit == 1'b0) begin
      enemy_b2_bullet_collision = 1'b1;
    end
    else begin 
	    enemy_b2_bullet_collision = 1'b0;
	 end


  end
  

  //Colors
always_ff @(posedge VGA_Clk) begin : RGB_Display // try frame-clk
    if ((ship_on == 1'b1)) begin
      Red   = Red_Ship;
      Green = Green_Ship;
      Blue  = Blue_Ship;
    end else if (bullet_on == 1'b1) begin
      Red   = 8'hFF;
      Green = 8'h00;
      Blue  = 8'h00;
	 end 
   else if (enemy_base_one_shoot_bullet == 1'b1 && enemy_one_base_hit == 1'b0) begin
      Red   = 8'hFF;
      Green = 8'hFF;
      Blue  = 8'hFF;
   end
    else if (enemy_base_two_shoot_bullet == 1'b1  && enemy_two_base_hit == 1'b0) begin
      Red   = 8'hFF;
      Green = 8'hFF;
      Blue  = 8'hFF;
   end
   else if ((enemy_base_two_on == 1'b1)) begin
		// bullet logic
		
		if (enemy_two_base_hit == 1'b1) begin
        Red   = Red_scroll;
        Green = Green_scroll;
        Blue  = Blue_scroll;
        
      end else begin 
        Red   = Red_base_2;
        Green = Green_base_2;
        Blue  = Blue_base_2;
      end
		
    end
    else if ((enemy_base_one_on == 1'b1)) begin
      if (enemy_one_base_hit == 1'b1) begin
        Red   = Red_scroll;
        Green = Green_scroll;
        Blue  = Blue_scroll;
        
      end else begin 
        Red   = Red_base;
        Green = Green_base;
        Blue  = Blue_base;
      end

    end 
    else begin
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

  // enemy bullet logic
  always_ff @(posedge VGA_Clk) begin : enemy_bullet
    if (enemy_base_one_show_bullet == 1'b1 && ((DrawX >=  enemy_one_bullet_x - 1) && (DrawX <=  enemy_one_bullet_x + 1 ) && 
		  (DrawY >= enemy_one_bullet_y - 1 ) && (DrawY <=  enemy_one_bullet_y + 1 )) )
      enemy_base_one_shoot_bullet = 1'b1;
    else enemy_base_one_shoot_bullet = 1'b0;

    if (enemy_base_two_show_bullet == 1'b1 && ((DrawX >=  enemy_two_bullet_x - 1) && (DrawX <=  enemy_two_bullet_x + 1 ) && 
		  (DrawY >= enemy_two_bullet_y - 1 ) && (DrawY <=  enemy_two_bullet_y + 1 )) )
      enemy_base_two_shoot_bullet = 1'b1;
    else enemy_base_two_shoot_bullet = 1'b0;
  end
  
  //Ship Orientation
  logic up, left, down, right, bullet_left_right;
  logic [3:0] ship_orientation;
  
  always_ff @(posedge frame_clk) begin
    ship_orientation = {up, down, right, left};
    if (collision) begin 
      up <= 1'b0;
      down <= 1'b0;
      left <= 1'b0;
      right <= 1'b0;
    end else begin
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
  end

  // keeps track of what enemy bases have been hit
  logic enemy_one_base_hit = 1'b0; // creates a register for this signal
  logic enemy_two_base_hit = 1'b0; // creates a register for this signal
  assign win = enemy_one_base_hit && enemy_two_base_hit;
  always_ff @(posedge frame_clk or posedge Reset) begin
      if (Reset) begin
        enemy_one_base_hit <= 1'b0;
        enemy_two_base_hit <= 1'b0;
      end
		else begin
			if (enemy_hit_one) begin 
			  enemy_one_base_hit <= 1'b1;
			end
			if (enemy_hit_two) begin 
			  enemy_two_base_hit <= 1'b1;
			end
		end

  end

  //Module Instantiation
  logic [7:0] Red_scroll, Blue_scroll, Green_scroll;
  Boscanian_Background_example bgk (
      .vga_clk(VGA_Clk),
		.frame_clk(frame_clk),
      .DrawX(DrawX),
      .DrawY(DrawY),
      .collided(collision),
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
		  .collision(collision),
      .direction(ship_orientation),
		  .data(data_ship),
      .Red(Red_Ship),
      .Green(Green_Ship),
      .Blue(Blue_Ship)

  );
  logic [9:0] x_pos_bullet_1, y_pos_bullet_1, x_pos_bullet_2, y_pos_bullet_2;
  logic bullets_exist, shoot;

  bullet spaceship_bullets (
    .shoot_bullet(shoot), 
    .frame_clk(frame_clk),
	  .direction(ship_orientation), // for combinations of directions: up, down, diagonals
	  .x_pos_bullet_1(x_pos_bullet_1), .y_pos_bullet_1(y_pos_bullet_1),
    .x_pos_bullet_2(x_pos_bullet_2), .y_pos_bullet_2(y_pos_bullet_2),
	  .exists(bullets_exist)
  );
  
  logic [7:0] Red_base, Blue_base, Green_base,  Red_base_2, Blue_base_2, Green_base_2;
  logic [9:0] Base_X, Base_Y;
  green_enemy_base_example enemy_base_one (
      .vga_clk(VGA_Clk),
		.frame_clk(frame_clk),
      .DrawX(DrawX), //-7
      .DrawY(DrawY), // 24
      .collided(collision),
      .direction(ship_orientation),
      .blank(blank),
	  	.draw_enable(enemy_base_one_on),
		.rom(data_base_one),
		.Base_X(Base_TL_Corner_X_ONE), 
		.Base_Y(Base_TL_Corner_Y_ONE),
      .red(Red_base),
      .green(Green_base),
      .blue(Blue_base)
  );

logic enemy_hit_one;
user_bullet_collision base_one (
    .frame_clk(frame_clk),
    .Base_TL_Corner_X(Base_TL_Corner_X_ONE), 
    .Base_TL_Corner_Y(Base_TL_Corner_Y_ONE),
    .x_pos_bullet_1(x_pos_bullet_1), 
    .x_pos_bullet_2(x_pos_bullet_2), 
    .y_pos_bullet_1(y_pos_bullet_1),
    .y_pos_bullet_2(y_pos_bullet_2),
    .enemy_hit (enemy_hit_one)
);

logic [9:0] enemy_one_bullet_x, enemy_one_bullet_y;
logic enemy_base_one_shoot_bullet, enemy_base_one_show_bullet, enemy_b1_bullet_collision;
enemy_bullet base_enemy_bullet (
  .frame_clk(frame_clk), 
  .enemy_base_tl_x(Base_TL_Corner_X_ONE), .enemy_base_tl_y(Base_TL_Corner_Y_ONE),
  .enemy_bullet_x(enemy_one_bullet_x), .enemy_bullet_y(enemy_one_bullet_y), .show_bullet(enemy_base_one_show_bullet)
);

  green_enemy_base_example_two enemy_base_two (
      .vga_clk(VGA_Clk),
		 .frame_clk(frame_clk),
      .DrawX(DrawX), //-7
      .DrawY(DrawY), // 24
      .collided(collision),
      .direction(ship_orientation),
      .blank(blank),
	  	.draw_enable(enemy_base_two_on),
		.rom(data_base_two),
		.Base_X(Base_TL_Corner_X_TWO), 
		.Base_Y(Base_TL_Corner_Y_TWO),
      .red(Red_base_2),
      .green(Green_base_2),
      .blue(Blue_base_2)
  );

logic enemy_hit_two;
user_bullet_collision base_two (
    .frame_clk(frame_clk), 
    .Base_TL_Corner_X(Base_TL_Corner_X_TWO), 
    .Base_TL_Corner_Y(Base_TL_Corner_Y_TWO),
    .x_pos_bullet_1(x_pos_bullet_1), 
    .x_pos_bullet_2(x_pos_bullet_2), 
    .y_pos_bullet_1(y_pos_bullet_1),
    .y_pos_bullet_2(y_pos_bullet_2),
    .enemy_hit (enemy_hit_two)
);

logic [9:0] enemy_two_bullet_x, enemy_two_bullet_y;
logic enemy_base_two_shoot_bullet, enemy_base_two_show_bullet, enemy_b2_bullet_collision;
enemy_bullet base_enemy_bullet_2 (
  .frame_clk(frame_clk),
  .enemy_base_tl_x(Base_TL_Corner_X_TWO), .enemy_base_tl_y(Base_TL_Corner_Y_TWO),
  .enemy_bullet_x(enemy_two_bullet_x), .enemy_bullet_y(enemy_two_bullet_y), .show_bullet(enemy_base_two_show_bullet)
);

endmodule