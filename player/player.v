`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:11 02/25/2022 
// Design Name: 
// Module Name:    player 
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
module player(
	input wire dclk,
	input wire clr,
	input wire clk_1,
	input wire clk_2,
	input wire clk_3,
	input wire clk_4,
	input wire left,
	input wire right,
	input wire [3:0] KeypadInput,
	input wire shoot,
	input wire play,
	input wire collide,
	output reg [9:0] projectiles_x,
	output reg [9:0] projectiles_y,
	output reg [9:0] player_x,
	output reg [9:0] player_y
	
    );


reg [5:0]count = 0;
reg np = 1;
always @(posedge clk_4) 
begin
	if(play == 0 || np) begin
		if(play==0)
			np <= 0;
		count <= 0;
		player_x <= 320;
		player_y <= 420;
		//for(i=0; i< 4; i = i+1) begin
		projectiles_x <= 0;
		projectiles_y <= 470;
		//end
	end
	else begin
		if (clr) 
		begin	
			count <= 0;
			player_x <= 320;
			player_y <= 420;
			//for(i=0; i< 4; i = i+1) begin
			projectiles_x <= 0;
			projectiles_y <= 470;
			//end
		end
		//KeypadInput == 4'b0001
		else if (left)
		begin
			if(player_x > 90)
				player_x <= player_x - 1'b1;
		end
		//KeypadInput == 4'b0011
		else if (right)
		begin
			if(player_x < 550)
				player_x <= player_x + 1'b1;
		end
		//KeypadInput == 4'b1010
		if(shoot) begin
			if(projectiles_y>player_y) begin
				projectiles_x<=player_x;
				projectiles_y<=player_y;
				
			end
		end
		if(collide == 1 ) begin
			projectiles_y <= 470;
			projectiles_x <= 0;
		end
		//for(i=0; i< 4; i = i+1) begin
			if(projectiles_y <= player_y && collide == 0) begin
				projectiles_y <= projectiles_y - 2;
				if(projectiles_y <= 0) begin
					projectiles_y <= 470;
					projectiles_x <= 0;
					
				end
			end
		//end
		end
end

endmodule
