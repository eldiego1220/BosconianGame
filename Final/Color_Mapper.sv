//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
	 logic shape_on;
	 logic shape2_on;
	 logic shape3_on;
	 logic [10:0] shape_x = 300;
	 logic [10:0] shape_y = 300;
	 logic [10:0] shape_size_x = 15;
	 logic [10:0] shape_size_y = 15;
	 logic [10:0] shape2_x = 150;
	 logic [10:0] shape2_y = 150;
	 logic [10:0] shape2_size_x = 100;
	 logic [10:0] shape2_size_y = 100;
	 logic [10:0] shape3_x = 500;
	 logic [10:0] shape3_y = 100;
	 logic [10:0] shape3_size_x = 15;
	 logic [10:0] shape3_size_y = 15;
	 
	 always_comb
    begin:Ball_on_proc
		  if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
				
        if (DrawX >= shape_x && DrawX < shape_x + shape_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape_size_y) 
		  begin
				shape_on = 1'b1;
            shape2_on = 1'b0;
				shape3_on = 1'b0;
		  end 
		  else if (DrawX >= shape2_x && DrawX < shape2_x + shape2_size_x &&
				DrawY >= shape2_y && DrawY < shape2_y + shape2_size_y)  
		  begin
				shape_on = 1'b0;
            shape2_on = 1'b1;
				shape3_on = 1'b0;
		  end
		  else if (DrawX >= shape3_x && DrawX < shape3_x + shape3_size_x &&
				DrawY >= shape3_y && DrawY < shape3_y + shape3_size_y)  
		  begin
				shape_on = 1'b0;
            shape2_on = 1'b0;
				shape3_on = 1'b1;
		  end
		  else
		  begin
				shape_on = 1'b0;
            shape2_on = 1'b0;
				shape3_on = 1'b0;
		  end
	 end
	 
    always_comb
    begin:RGB_Display
		  if ((ball_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end      
        else if ((shape_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h55;
        end       
        else if ((shape2_on == 1'b1))
        begin 
            Red = 8'h00; 
            Green = 8'hff;
            Blue = 8'h00;
        end
		  else if ((shape3_on == 1'b1))
        begin 
            Red = 8'hff; 
            Green = 8'h00;
            Blue = 8'h55;
		  end
		  else
		  begin
//				Red = 8'h4f - DrawX[9:3]; 
//            Green = 8'h00;
//            Blue = 8'h44;
				Red = 8'h4f - DrawX[9:3]; 
            Green = 8'h00;
            Blue = 8'h44;
		  end
    end 

//    always_comb
//    begin:Ball_on_proc
//        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
//            ball_on = 1'b1;
//        else 
//            ball_on = 1'b0;
//     end 
//       
//    always_comb
//    begin:RGB_Display
//        if ((ball_on == 1'b1)) 
//        begin 
//            Red = 8'hff;
//            Green = 8'h55;
//            Blue = 8'h00;
//        end       
//        else 
//        begin 
//            Red = 8'h00; 
//            Green = 8'h00;
//            Blue = 8'h7f - DrawX[9:3];
//        end      
//    end 
    
endmodule
