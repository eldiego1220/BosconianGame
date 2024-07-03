//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk,
					input [7:0] keycode,

				output moving);
 
    always_ff @ (posedge Reset or posedge frame_clk ) begin
			  if (Reset)  // Asynchronous Reset
			  begin 
				moving <= 1'b0;
			  end	  
			  else begin 
					case (keycode)
						8'h04 : begin
									moving <= 1'b1;
								  end		  
						8'h07 : begin
								  moving <= 1'b1;
								  end							  
						8'h16 : begin
								  moving <= 1'b1;
								 end								  
						8'h1A : begin
								  moving <= 1'b1;
								 end	 
						default: begin end
					endcase		
			end  
    end
endmodule
