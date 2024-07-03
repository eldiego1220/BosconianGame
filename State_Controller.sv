module State_Controller (
    input Reset,
    input [9:0] DrawX, DrawY,
    input [7:0] keycode,
    input shoot_bullet, VGA_Clk, blank, sys_clk, frame_clk,
    output [1:0] State_out,
    output collision_test,
    output [7:0] Red, Green, Blue
);

enum logic [2:0] {START_SCREEN, PLAY, WIN, LOSE, PAUSE_LOST, PAUSE_WIN} State, Next_state;
assign State_out = State;
assign collision_test = lost;
logic win, lost, moving, clkdiv;
logic [9:0] count_timer;
logic [9:0] clk_divider;

always_ff @(posedge VGA_Clk) begin
	if (clk_divider >= 10'd1000) begin 
		clk_divider <= 0;
		
		count_timer <= count_timer + 1;
		clkdiv <= ~clkdiv;
	end
	else begin
		clk_divider <= clk_divider + 1;
	end
end


always_ff @ (posedge Reset or posedge VGA_Clk) begin
			  if (Reset)  // Asynchronous Reset
			    begin 
			       State <= START_SCREEN;
				   moving <= 1'b0;
			    end
			  else if (lost) begin
				State <= LOSE;
				moving <= 1'b0;
			  end
			  else if (win) begin
				State <= WIN;
				moving <= 1'b0;
			  end
			  else begin 
			  		State <= Next_state;
					if (keycode == 8'h04 || keycode == 8'h07 || keycode == 8'h16 || keycode == 8'h1a ) begin
						moving <= 1'b1;
					end else if (lost == 1'b1) begin
						moving <= 1'b0;
					end
				
			end  
    end


always_comb begin
    Next_state = State;
	Red = 8'h00;
    Blue = 8'h00;
    Green = 8'h00;
	 
	 unique case (State)
		START_SCREEN:
			if (moving)
				Next_state = PLAY;
		PLAY:
			if (win)
				Next_state = WIN;
           else if (lost) 
             Next_state = LOSE;   
           else
             Next_state = PLAY;
		WIN:
			Next_state = WIN;
		PAUSE_LOST: begin
		 if (clkdiv) begin
			Next_state = LOSE;
		 end else begin
			Next_state = PAUSE_LOST;
		 end
		end
		PAUSE_WIN: begin
		 if (count_timer >= 10'd1022) begin
			Next_state = WIN;
		 end else begin
			Next_state = PAUSE_WIN;
		 end
		end
		LOSE: 
			Next_state = LOSE;
		default : ;
	 endcase
	 
	 case (State)
		START_SCREEN:
			begin
				Red = Red_start;
			   Blue = Blue_start;
				Green = Green_start;
			end
		PLAY:
			begin
				Red = Red_game;
				Blue = Blue_game;
				Green = Green_game;
			end
		WIN:
			begin
				Red = Red_win;
				Blue = Blue_win;
				Green = Green_win;
			end
		PAUSE_LOST:
			begin
				Red = Red_game;
				Blue = Blue_game;
				Green = Green_game;
			end
		LOSE:
			begin
				Red = Red_lose;
				Blue = Blue_lose;
				Green = Green_lose;
			end
		default : ;
	 endcase

end

logic [7:0] Red_game, Green_game, Blue_game, Red_start, Green_start, Blue_start, 
				Red_win, Green_win, Blue_win, Red_lose, Green_lose, Blue_lose;

//start
start_example start_screen(
	.vga_clk(VGA_Clk),
	.DrawX(DrawX), .DrawY(DrawY),
	.blank(blank), .start_screen((State == START_SCREEN) ? 1'b1 : 1'b0),
	.red(Red_start), .green(Green_start), .blue(Blue_start)
);

//win
win_example win_screen(
	.vga_clk(VGA_Clk),
	.DrawX(DrawX), .DrawY(DrawY),
	.blank(blank), .end_screen((State == WIN) ? 1'b1 : 1'b0),
	.red(Red_win), .green(Green_win), .blue(Blue_win)
);

//lose
lose_example lose_screen(
	.vga_clk(VGA_Clk),
	.DrawX(DrawX), .DrawY(DrawY),
	.blank(blank), .end_screen((State == LOSE) ? 1'b1 : 1'b0),
	.red(Red_lose), .green(Green_lose), .blue(Blue_lose)
);

//game screen 
display_game game (.moving(moving), .VGA_Clk(VGA_Clk), .blank(blank), .keycode(keycode), .frame_clk(frame_clk),
	    .lost(lost), .Reset(Reset), .win(win), .DrawX(DrawX), .DrawY(DrawY), .sys_clk(sys_clk), .Red(Red_game), .Green(Green_game), .Blue(Blue_game));
	

// instantiate 
endmodule