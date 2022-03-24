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
	input wire collide2,
	input wire [45:0]enemy1_projectiles_x,
	input wire [44:0]enemy1_projectiles_y,
	input wire [9:0] enemy1_x,
	input wire [9:0] enemy1_y,
	input wire [45:0]enemy2_projectiles_x,
	input wire [44:0]enemy2_projectiles_y,
	input wire [9:0] enemy2_x,
	input wire [9:0] enemy2_y,
	input wire [9:0] enemy3_projectiles_x,
	input wire [9:0] enemy3_projectiles_y,
	output reg [9:0] projectiles_x,
	output reg [9:0] projectiles_y,
	output reg [4:0] destroy1,
	output reg [4:0] destroy2,
	output reg [4:0] destroy3,
	output reg [9:0] player_x,
	output reg [9:0] player_y,
	output reg gameover,
	output reg [2:0] lives
    );


reg [5:0]count = 0;
reg np = 1;
always @(posedge clk_4) 
	if(play == 0 || np) begin
		if(play==0)
			np <= 0;
		count <= 0;
		lives <= 5;
		gameover <= 0;
		player_x <= 320;
		player_y <= 420;
		destroy1 <= 0;
		destroy2 <= 0;
		destroy3 <= 0;
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
		if(collide == 1 || collide2 == 1 ) begin
			
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
		
		//reset destroy vars back to 0
		if(destroy1 != 0) begin
			destroy1 <= 0;
			lives <= lives -1;

		end
		if(destroy2 != 0) begin
			destroy2 <= 0;
			lives <= lives -1;

		end
		if(destroy3 != 0) begin
			destroy3 <= 0;
			lives <= lives -1;

		end
			
		if(destroy1 == 0 && destroy2 == 0 && destroy3 == 0) begin

			if(((player_y -enemy1_projectiles_y[8:0]  < 20) && (enemy1_projectiles_y[8:0] < player_y)) && 
			((enemy1_projectiles_x[8:0]-5 < (player_x+10))
			&&(enemy1_projectiles_x[8:0]+5 > player_x-10)) && ((enemy1_projectiles_x[8:0]+5 > player_x-10)
			&&(enemy1_projectiles_x[8:0]-5 < player_x+10)) 
			)begin
				destroy1[0] <= 1;
				
			end
			if(((player_y -enemy1_projectiles_y[17:9] < 20) && (enemy1_projectiles_y[17:9] < player_y)) && 
			((enemy1_projectiles_x[17:9]-5 < (player_x+10))
			&&(enemy1_projectiles_x[17:9]+5 > player_x-10)) && ((enemy1_projectiles_x[17:9]+5 > player_x-10)
			&&(enemy1_projectiles_x[17:9]-5 < player_x+10)) 
			)begin
				destroy1[1] <= 1;
				
			end
			if(((player_y - enemy1_projectiles_y[26:18] < 20) && (enemy1_projectiles_y[26:18] < player_y)) && 
			((enemy1_projectiles_x[26:18]-5 < (player_x+10))
			&&(enemy1_projectiles_x[26:18]+5 > player_x-10)) && ((enemy1_projectiles_x[26:18]+5 > player_x-10)
			&&(enemy1_projectiles_x[26:18]-5 < player_x+10)) 
			)begin
				destroy1[2] <= 1;
				
			end
			if(((player_y -enemy1_projectiles_y[35:27] < 20) && (enemy1_projectiles_y[35:27] < player_y)) && 
			((enemy1_projectiles_x[35:27]-5 < (player_x+10))
			&&(enemy1_projectiles_x[35:27]+5 > player_x-10)) && ((enemy1_projectiles_x[35:27]+5 > player_x-10)
			&&(enemy1_projectiles_x[35:27]-5 < player_x+10)) 
			)begin
				destroy1[3] <= 1;
				
			end
			if(((player_y -enemy1_projectiles_y[44:36] < 20) && (enemy1_projectiles_y[44:36] < player_y)) && 
			((enemy1_projectiles_x[45:36]-5 < (player_x+10))
			&&(enemy1_projectiles_x[45:36]+5 > player_x-10)) && ((enemy1_projectiles_x[45:36]+5 > player_x-10)
			&&(enemy1_projectiles_x[45:36]-5 < player_x+10)) 
			)begin
				destroy1[4] <= 1;
				
			end
			//checking collision with enemy2 projectiles
			if(((player_y -enemy2_projectiles_y[8:0]  < 20) && (enemy2_projectiles_y[8:0] < player_y)) && 
			((enemy2_projectiles_x[8:0]-5 < (player_x+10))
			&&(enemy2_projectiles_x[8:0]+5 > player_x-10)) && ((enemy2_projectiles_x[8:0]+5 > player_x-10)
			&&(enemy2_projectiles_x[8:0]-5 < player_x+10)) 
			)begin
				destroy2[0] <= 1;
				
			end
			if(((player_y -enemy2_projectiles_y[17:9] < 20) && (enemy2_projectiles_y[17:9] < player_y)) && 
			((enemy2_projectiles_x[17:9]-5 < (player_x+10))
			&&(enemy2_projectiles_x[17:9]+5 > player_x-10)) && ((enemy2_projectiles_x[17:9]+5 > player_x-10)
			&&(enemy2_projectiles_x[17:9]-5 < player_x+10)) 
			)begin
				destroy2[1] <= 1;
				
			end
			if(((player_y - enemy2_projectiles_y[26:18] < 20) && (enemy2_projectiles_y[26:18] < player_y)) && 
			((enemy2_projectiles_x[26:18]-5 < (player_x+10))
			&&(enemy2_projectiles_x[26:18]+5 > player_x-10)) && ((enemy2_projectiles_x[26:18]+5 > player_x-10)
			&&(enemy2_projectiles_x[26:18]-5 < player_x+10)) 
			)begin
				destroy2[2] <= 1;
				
			end
			if(((player_y -enemy2_projectiles_y[35:27] < 20) && (enemy2_projectiles_y[35:27] < player_y)) && 
			((enemy2_projectiles_x[35:27]-5 < (player_x+10))
			&&(enemy2_projectiles_x[35:27]+5 > player_x-10)) && ((enemy2_projectiles_x[35:27]+5 > player_x-10)
			&&(enemy2_projectiles_x[35:27]-5 < player_x+10)) 
			)begin
				destroy2[3] <= 1;
				
			end
			if(((player_y -enemy2_projectiles_y[44:36] < 20) && (enemy2_projectiles_y[44:36] < player_y)) && 
			((enemy2_projectiles_x[45:36]-5 < (player_x+10))
			&&(enemy2_projectiles_x[45:36]+5 > player_x-10)) && ((enemy2_projectiles_x[45:36]+5 > player_x-10)
			&&(enemy2_projectiles_x[45:36]-5 < player_x+10)) 
			)begin
				destroy2[4] <= 1;
				
			end
			
			if(((player_y -enemy3_projectiles_y < 20) && (enemy3_projectiles_y < player_y)) && 
			((enemy3_projectiles_x-5 < (player_x+10))
			&&(enemy3_projectiles_x+5 > player_x-10)) && ((enemy3_projectiles_x+5 > player_x-10)
			&&(enemy3_projectiles_x-5 < player_x+10)) 
			)begin
				destroy3 <= 1;
			end

		end
		
		if(lives <= 0) begin
			gameover <= 1;
		end
        
		
end

endmodule
