`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:12:06 03/02/2022 
// Design Name: 
// Module Name:    ss_display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module score_keeper(
	input wire clk_score,
	input wire play,
	input wire clr,
  	input wire [13:0] enemy1_score,
	output reg [13:0] score
	);

always @(posedge clk_score) begin  
	if (clr) begin
		score <= 14'd0;
	end
	else if (!play) begin
	
	end
	else begin
      	
      score <= enemy1_score;     
		//score <= score + 14'd1;
	end
	
	
end

endmodule



module score_display(
	input wire clk_in_display,
 	input wire clk_in_blink,
	input wire play,
	input wire clr,
	input wire [13:0] score, 	
	output reg [7:0] C,
	output reg [3:0] A
	);
	

reg [1:0] counter = 0;
reg [5:0] temp, temp2, temp3, temp4, hold;	
reg show_digit = 1;
  
initial begin
	show_digit = 1'b1;
end
	  
always @(posedge clk_in_blink) begin  
	if (play == 1)
		show_digit <= 1'b1;
	else
		show_digit <= show_digit + 1'b1;
end
	  
	
always @(posedge clk_in_display) begin

	//score reset: do it in a score_keeper module
			
		
	temp <= score % 'd10;
	temp2 <= (score / 'd10)% 10;
	temp3 <= (score / 'd100)%10;
	temp4 <= (score / 'd1000);
			
	case (counter)
		2'd0: begin 
		A <= 4'b0111;
		hold <= temp;
		end
		2'd1:begin 
		A <= 4'b1110;
		hold <= temp2;
		end
		2'd2:begin 
		A <= 4'b1101;
		hold <= temp3;
		end
		2'd3:begin 
		A <= 4'b1011;
		hold <= temp4;
		end		
	endcase
		
	case (hold)
		4'd0: C <= 8'b00000011;
		4'd1: C <= 8'b10011111;
		4'd2: C <= 8'b00100101;
		4'd3: C <= 8'b00001101;
		4'd4: C <= 8'b10011001;
		4'd5: C <= 8'b01001001;
		4'd6: C <= 8'b01000001;
		4'd7: C <= 8'b00011111;
		4'd8: C <= 8'b00000001;
		4'd9: C <= 8'b00001001;
		default: C <= 8'b11111111;
		
	endcase
	//assigned digit to display
	
	//flashing when game is over
	if (play == 0) begin
		if (show_digit == 0)
			C <= 8'b11111111;
	end
      
		counter <= counter + 1;
	end
endmodule
