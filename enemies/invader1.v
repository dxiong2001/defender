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
	input wire [4:0] destroy,
	input wire [9:0] projectiles_x,
	input wire [9:0] projectiles_y,
	output reg [45:0]enemy_projectiles_x,
	output reg [44:0]enemy_projectiles_y,
	
	output reg [9:0] enemy_x,
	output reg [9:0] enemy_y,
	output reg[4:0] collide,
	output reg collision,
	output reg [13:0] score
    );
integer i;
reg [4:0] shoot;
reg clock = 0;
reg [2:0] clock2 = 0;
reg [4:0] offset;
reg [5:0]count = 10;
reg [3:0] rep;
reg direction = 1;
reg np = 1;
always @(posedge clk_4) 
begin
	if(play==0 || np) begin
		if(play==0)
			np <= 0;
		score <= 0;
		shoot<=0;
		clock <= 0;
		direction <= 1;
		enemy_projectiles_x<=0;
		enemy_projectiles_y<=0;
		collide <= 0;
		collision <= 0;
		enemy_x <= 220;
		enemy_y <= 50;
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
			enemy_y <= enemy_y + 10;
			if(direction) begin
				enemy_x<= enemy_x - 1;
			end else begin
				enemy_x <= enemy_x + 1;
			end
			direction <=  ~direction;
			
		end
	end
	if(collision == 1) begin
		collision <= ~collision;
		score <= score + 10;
	end
	
	if(rep==5) begin
		collide <= 0;
		collision <= 0;
		enemy_x <= 220;
		enemy_y <= 10;
		direction <= 1;
		rep <= 0;
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
			if(collide[0] ==0) begin
				collide[0] <= 1;
				collision <= 1;
				rep <= rep + 1;
			end
		end
		
	if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10 + 40))
		&&(projectiles_x+5 > enemy_x-10 + 40)) && ((projectiles_x+5 > enemy_x-10  + 40)&&(projectiles_x-5 < enemy_x+10 + 40)) 
		)begin
			//enemy_y <= 10;
			if(collide[1] ==0) begin
				collide[1] <= 1;
				collision <= 1;
				rep <= rep + 1;
			end
		end
		
	if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10+ 80))
		&&(projectiles_x+5 > enemy_x-10+ 80)) && ((projectiles_x+5 > enemy_x-10+ 80)&&(projectiles_x-5 < enemy_x+10+ 80)) 
		)begin
			//enemy_y <= 10;
			if(collide[2] ==0) begin
				collide[2] <= 1;
				collision <= 1;
				rep <= rep + 1;
			end
		end
		
	if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10+ 120))
		&&(projectiles_x+5 > enemy_x-10+ 120)) && ((projectiles_x+5 > enemy_x-10+ 120)&&(projectiles_x-5 < enemy_x+10+ 120)) 
		)begin
			//enemy_y <= 10;
			if(collide[3] ==0) begin
				collide[3] <= 1;
				collision <= 1;
				rep <= rep + 1;
			end
		end
		
	if(((projectiles_y - enemy_y < 20) && (projectiles_y > enemy_y)) && ((projectiles_x-5 < (enemy_x+10+ 160))
		&&(projectiles_x+5 > enemy_x-10+ 160)) && ((projectiles_x+5 > enemy_x-10+ 160)&&(projectiles_x-5 < enemy_x+10+ 160)) 
		)begin
			//enemy_y <= 10;
			if(collide[4] ==0) begin
				collide[4] <= 1;
				collision <= 1;
				rep <= rep + 1;
			end
		end
	if(clock2==3'b111) begin
		if(enemy_projectiles_y[8:0]<=0 && collide[0]==0) begin
					shoot[0]<=1;
		end
		if(enemy_projectiles_y[17:9]<=0 && collide[1]==0) begin
					shoot[1]<=1;
		end
		if(enemy_projectiles_y[26:18]<=0 && collide[2]==0) begin
					shoot[2]<=1;
		end
		if(enemy_projectiles_y[35:27]<=0 && collide[3]==0) begin
					shoot[3]<=1;
		end
		if(enemy_projectiles_y[44:36]<=0 && collide[4]==0) begin
					shoot[4]<=1;
		end
	end
	/*
	if(clock2 ==3'b111) begin
		case(rand[2:0])
		0: begin
				if(enemy_projectiles_y[8:0]<=0 && collide[0]==0) begin
					shoot[0]<=1;
				end
			end
		1: begin
				if(enemy_projectiles_y[17:9]<=0&& collide[1]==0) begin
					shoot[1]<=1;
				end
			end
		2: begin
				if(enemy_projectiles_y[26:18]<=0&& collide[2]==0) begin
					shoot[2]<=1;
				end
			end
		3: begin
				if(enemy_projectiles_y[35:27]<=0&& collide[3]==0) begin
					shoot[3]<=1;
				end
			end
		4: begin
				if(enemy_projectiles_y[44:36]<=0&& collide[4]==0) begin
					shoot[4]<=1;
				end
			end
	endcase
	end
	*/
	if(play) begin
	
		if(shoot[0]==1) begin
		shoot[0]<=0;
		enemy_projectiles_y[8:0] <= enemy_y;
		enemy_projectiles_x[8:0] <= enemy_x;
	end
	
	if(shoot[1]==1) begin
		shoot[1]<=0;
		enemy_projectiles_y[17:9] <= enemy_y;
		enemy_projectiles_x[17:9] <= enemy_x + 40;
	end
	
	if(shoot[2]==1) begin
		shoot[2]<=0;
		enemy_projectiles_y[26:18] <= enemy_y;
		enemy_projectiles_x[26:18] <= enemy_x + 80;
	end
	
	if(shoot[3]==1) begin
		shoot[3]<=0;
		enemy_projectiles_y[35:27] <= enemy_y;
		enemy_projectiles_x[35:27] <= enemy_x + 120;
	end
	
	if(shoot[4]==1) begin
		shoot[4]<=0;
		enemy_projectiles_y[44:36] <= enemy_y;
		enemy_projectiles_x[45:36] <= enemy_x + 160;
	end
	if(enemy_projectiles_y[8:0] > 0) begin
		if(enemy_projectiles_y[8:0] <= 480 && destroy[0]==0)
			enemy_projectiles_y[8:0]<= enemy_projectiles_y[8:0] + 1;
		else 
			enemy_projectiles_y[8:0] <= 0;
	end
	
	if(enemy_projectiles_y[17:9] > 0) begin
		if(enemy_projectiles_y[17:9] <= 480 && destroy[1]==0)
			enemy_projectiles_y[17:9]<= enemy_projectiles_y[17:9] + 1;
		else 
			enemy_projectiles_y[17:9] <= 0;
	end
	
	if(enemy_projectiles_y[26:18] > 0) begin
		if(enemy_projectiles_y[26:18] <= 480 && destroy[2]==0)
			enemy_projectiles_y[26:18]<= enemy_projectiles_y[26:18] + 1;
		else 
			enemy_projectiles_y[26:18] <= 0;
	end
	
	if(enemy_projectiles_y[35:27] > 0) begin
		if(enemy_projectiles_y[35:27] <= 480 && destroy[3]==0)
			enemy_projectiles_y[35:27]<= enemy_projectiles_y[35:27] + 1;
		else 
			enemy_projectiles_y[35:27] <= 0;
	end
	if(enemy_projectiles_y[44:36] > 0) begin
		if(enemy_projectiles_y[44:36] <= 480 && destroy[4]==0)
			enemy_projectiles_y[44:36]<= enemy_projectiles_y[44:36] + 1;
		else 
			enemy_projectiles_y[44:36] <= 0;
	end
	end
	
	
	
	count <= count + 1;
	clock <= clock + 1;
	clock2 <= clock2 + 1;
	
	
end

endmodule
