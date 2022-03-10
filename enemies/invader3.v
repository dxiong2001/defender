`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:23:07 03/04/2022 
// Design Name: 
// Module Name:    invader3 
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:11:10 03/04/2022 
// Design Name: 
// Module Name:    invader2 
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
module invader3(
 input wire dclk,
	input wire clr,
	input wire clk_1,
	input wire clk_2,
	input wire clk_3,
	input wire clk_4,
	input wire play,
	input wire [7:0]rand,
	input wire destroy,
	input wire [9:0] projectiles_x,
	input wire [9:0] projectiles_y,
	input wire [9:0] player_x,
	input wire [9:0] player_y,
	output reg [9:0]enemy_projectiles_x,
	output reg [9:0]enemy_projectiles_y,
	
	output reg [9:0] enemy_x,
	output reg [9:0] enemy_y,
	output reg collide,
	output reg collision,
	output reg [13:0] score
    );
integer i;
reg shoot;
reg [1:0]clock = 0;
reg [8:0] clock2 = 0;
reg [24:0] clock3 = 0;
reg buffer = 0;
reg [4:0] offset;
reg [5:0]count = 10;
reg direction = 0;
reg odd;
reg np = 1;
always @(posedge clk_4) 
begin
	if(play==0 || np) begin
		if(play==0)
			np <= 0;
		score <= 0;
		shoot<=0;
		odd <=0;
		clock <= 0;
		clock3 <= 0;
		direction <= 0;
		enemy_projectiles_x<=0;
		enemy_projectiles_y<=0;
		collide <= 0;
		collision <= 0;
		enemy_x <= 220;
		enemy_y <= 30;
		
	end
	
	/*
		if (clr) 
		begin	
			collide <= 0;
			enemy_x <= 320;
			enemy_y <= 0;
			
		end
		*/
	if(clock==2'b10) begin
		/*
		if(enemy_y < 480) 
			enemy_y <= enemy_y + 1;
		else begin
			enemy_x <= count * 10;
			enemy_y <= 0;
		end
		*/
		clock <= 0;
		if(player_x > enemy_x) begin
				enemy_x<= enemy_x + 1;
		end else if(player_x < enemy_x) begin
				enemy_x <= enemy_x - 1;
		end
				
		
		
	end
	
	
	if(collide==1)begin
		enemy_x <= 100;
	
		if(count%2==0) begin
			enemy_x <= enemy_x+ 20;
		end
		else
			enemy_x <= count * 5;
		
		
		collide <= ~collide;
	end
	
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
		
	
	score <= rand;
	if(rand == 33) begin
		
		if(enemy_projectiles_y<=0) begin
					shoot<=1;
		end
		
		
	end
	
	if(play) begin
	
		if(shoot==1) begin
		shoot<=0;
		enemy_projectiles_y <= enemy_y;
		enemy_projectiles_x <= enemy_x;
	end
	
	
	if(enemy_projectiles_y > 0) begin
		if(enemy_projectiles_y <= 480 && destroy == 0) begin
			enemy_projectiles_y<= enemy_projectiles_y +1;
			if(player_x > enemy_projectiles_x && clock==2'b10)
				enemy_projectiles_x <= enemy_projectiles_x + 1;
			if(player_x < enemy_projectiles_x && clock==2'b10)
				enemy_projectiles_x <= enemy_projectiles_x - 1;
				
			end
				
		else 
			enemy_projectiles_y <= 0;
	end
	
	end
	
	
	
	count <= count + 1;
	clock <= clock + 1;
	clock2 <= clock2 + 1;
	
	
end

endmodule

