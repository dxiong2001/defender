`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:25:34 02/25/2022 
// Design Name: 
// Module Name:    invader 
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
module vertical_invader(
   input wire dclk,
	input wire clr,
	input wire clk_1,
	input wire clk_2,
	input wire clk_3,
	input wire clk_4,
	input wire play,
	input wire [9:0] projectiles_x,
	input wire [9:0] projectiles_y,
	output reg [9:0] enemy_x = 0,
	output reg [9:0] enemy_y = 0,
	output reg[9:0] collide,
	output reg collision,
	output reg [13:0] score
    );
integer i;
reg clock = 0;
reg [3:0] offset;
reg [5:0]count = 10'b1010101010;
reg direction = 1;
reg np = 1;
always @(posedge clk_4) 
begin
	if(play==0 || np) begin
		if(play==0)
			np <= 0;
		score <= 0;
		collide <= ;
		collision <= 0;
		enemy_x <= 100;
		enemy_y <= 10;
	end
	
	/*
		if (clr) 
		begin	
			collide <= 0;
			enemy_x <= 320;
			enemy_y <= 0;
			
		end
		*/
	if(clock==1) begin
		/*
		if(enemy_y < 480) 
			enemy_y <= enemy_y + 1;
		else begin
			enemy_x <= count * 10;
			enemy_y <= 0;
		end
		*/
		if(enemy_x < 390 && enemy_x > 95) begin
			if(direction) begin
				enemy_x<= enemy_x + 1;
			end else begin
				enemy_x <= enemy_x - 1;
			end
		end
		else begin
			enemy_y <= enemy_y + 5;
			if(direction) begin
				enemy_x<= enemy_x - 1;
			end else begin
				enemy_x <= enemy_x + 1;
			end
			direction =  ~direction;
			
		end
	end
	if(collision == 1) begin
		collision <= ~collision;
		score <= score + 50;
	end
	/*
	
	if(collide==1)begin
		enemy_x <= 100;
	
		if(count%2==0) begin
			enemy_x <= enemy_x+ 20;
		end
		else
			enemy_x <= count * 5;
		
		
		collide <= ~collide;
	end
	*/	
	/*
	for(i = 0; i< 4 ; i = i+ 1) begin
		offset = i * 'd40;
		if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10+offset))
		&&(projectiles_x+5 > enemy_x-10 + offset)) && ((projectiles_x+5 > enemy_x-10 + offset)&&(projectiles_x-5 < enemy_x+10 + offset)) 
		)begin
			//enemy_y <= 10;
			collide[i] <= 1;
			collision <= 1;
		end
	
	end
	*/
	if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10))
		&&(projectiles_x+5 > enemy_x-10)) && ((projectiles_x+5 > enemy_x-10)&&(projectiles_x-5 < enemy_x+10)) 
		)begin
			//enemy_y <= 10;
			if(collide[1:0] > 0) begin
				collide[1:0] <= collide[1:0]-1;
            end else begin
                collision <= 1;
            end
		end
		
	if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10 + 40))
		&&(projectiles_x+5 > enemy_x-10 + 40)) && ((projectiles_x+5 > enemy_x-10  + 40)&&(projectiles_x-5 < enemy_x+10 + 40)) 
		)begin
			//enemy_y <= 10;
			if(collide[3:2] > 0) begin
				collide[3:2] <= collide[3:2]-1;
            end else begin
                collision <= 1;
            end
		end
		
	if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10+ 80))
		&&(projectiles_x+5 > enemy_x-10+ 80)) && ((projectiles_x+5 > enemy_x-10+ 80)&&(projectiles_x-5 < enemy_x+10+ 80)) 
		)begin
			//enemy_y <= 10;
			if(collide[5:4] > 0) begin
				collide[5:4] <= collide[5:4]-1;
            end else begin
                collision <= 1;
            end
		end
		
	if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10+ 120))
		&&(projectiles_x+5 > enemy_x-10+ 120)) && ((projectiles_x+5 > enemy_x-10+ 120)&&(projectiles_x-5 < enemy_x+10+ 120)) 
		)begin
			//enemy_y <= 10;
			if(collide[7:6] > 0) begin
				collide[7:6] <= collide[7:6]-1;
            end else begin
                collision <= 1;
            end
		end
		
	if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10+ 160))
		&&(projectiles_x+5 > enemy_x-10+ 160)) && ((projectiles_x+5 > enemy_x-10+ 160)&&(projectiles_x-5 < enemy_x+10+ 160)) 
		)begin
			//enemy_y <= 10;
			if(collide[9:8] > 0) begin
				collide[9:8] <= collide[9:8]-1;
            end else begin
                collision <= 1;
            end
		end
	
	
	count <= count + 1;
	clock <= clock + 1;
	
	
end

endmodule
