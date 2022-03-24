`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:20:49 02/25/2022 
// Design Name: 
// Module Name:    interface 
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
module interface(
input wire clk,			//master clock = 50MHz
	input wire clr,			//right-most pushbutton for reset
	input wire left,
	inout [7:0] JC,
	input wire right,
	input wire shoot,
	input wire play,
	output wire [7:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	output wire dp,			//7-segment display decimal point
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync,			//vertical sync out
	output wire test
	);
integer i,j;
wire [9:0] projectiles_x;
wire [9:0] projectiles_y;


// 7-segment clock interconnect
wire segclk;

// VGA display clock interconnect
wire dclk;
wire notplay;
assign notplay = ~play;
// disable the 7-segment decimal points
assign dp = 1;
assign test = (left)? 1:0;

wire [4:0]collide;
wire collision;
wire [4:0]collide2;
wire collision2;
wire collide3;
wire collision3;
wire gameover;
// generate 7-segment clock & display clock
wire clk_1, clk_2, clk_3, clk_4, clk_blink, clk_score;
clock U1(
	.clk(clk),
	.clr(clr),
	.segclk(segclk),
	.dclk(dclk),
	.clk_1(clk_1),
	.clk_2(clk_2),
	.clk_3(clk_3),
	.clk_4(clk_4),
	.clk_score(clk_score),
	.clk_blink(clk_blink)
	);
	
wire [7:0] rand;
rand R0 (
	.clock(segclk),
	.reset(notplay),
	.rnd(rand)
);

wire [3:0] KeypadInput;
Decoder D0(
		.clk(clk),
		.Row(JC[7:4]),
		.Col(JC[3:0]),
		.DecodeOut(KeypadInput)
);


// VGA controller
wire [45:0] enemy1_projectiles_x;
wire [44:0] enemy1_projectiles_y;
wire [45:0] enemy2_projectiles_x;
wire [44:0] enemy2_projectiles_y;
wire [9:0] enemy3_projectiles_x;
wire [9:0] enemy3_projectiles_y;
wire [9:0] player_x;
wire [9:0] player_y;
wire [9:0] enemy_x;
wire [9:0] enemy_y;
wire [9:0] enemy2_x;
wire [9:0] enemy2_y;
wire [9:0] enemy3_x;
wire [9:0] enemy3_y;
wire [2:0] lives;
wire [4:0] destroy1;
wire [4:0] destroy2;
wire destroy3;
vga_display U2(
	.dclk(dclk),
	.clr(clr),
	.player_x(player_x),
	.player_y(player_y),
	.projectiles_x(projectiles_x),
	.projectiles_y(projectiles_y),
	.enemy1_projectiles_x(enemy1_projectiles_x),
	.enemy1_projectiles_y(enemy1_projectiles_y),
	.enemy2_projectiles_x(enemy2_projectiles_x),
	.enemy2_projectiles_y(enemy2_projectiles_y),
	.enemy3_projectiles_x(enemy3_projectiles_x),
	.enemy3_projectiles_y(enemy3_projectiles_y),
	.play(play),
	.lives(lives),
	.enemy_x(enemy_x),
	.enemy_y(enemy_y),
	.enemy2_x(enemy2_x),
	.enemy2_y(enemy2_y),
	.enemy3_x(enemy3_x),
	.enemy3_y(enemy3_y),
	.gameover(gameover),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue),
	.collide(collide),
	.collide2(collide2)
	);

player U3(
	.dclk(dclk),
	.clr(clr),
	.clk_1(clk_1),
	.clk_2(clk_2),
	.clk_3(clk_3),
	.clk_4(clk_4),
	.KeypadInput(KeypadInput),
	.left(left),
	.right(right),
	.shoot(shoot),
	.play(play),
	.player_x(player_x),
	.player_y(player_y),
	.projectiles_x(projectiles_x),
	.projectiles_y(projectiles_y),
	.enemy1_x(enemy1_x),
	.enemy1_y(enemy1_y),
	.enemy1_projectiles_x(enemy1_projectiles_x),
	.enemy1_projectiles_y(enemy1_projectiles_y),
	.enemy2_x(enemy2_x),
	.enemy2_y(enemy2_y),
	.enemy2_projectiles_x(enemy2_projectiles_x),
	.enemy2_projectiles_y(enemy2_projectiles_y),
	.enemy3_projectiles_x(enemy3_projectiles_x),
	.enemy3_projectiles_y(enemy3_projectiles_y),
	.collide(collision),
	.collide2(collision2),
	.lives(lives),
	.gameover(gameover),
    .destroy1(destroy1),
    .destroy2(destroy2),
    .destroy3(destroy3)
	);
wire [13:0] score;
wire [13:0] score2;
wire [13:0] score3;
wire [13:0] total_score;

vertical_invader U4(
	.dclk(dclk),
	.clr(clr),
	.clk_1(clk_1),
	.clk_2(clk_2),
	.clk_3(clk_3),
	.clk_4(clk_4),
	.play(play),
	.projectiles_x(projectiles_x),
	.projectiles_y(projectiles_y),
	.enemy_projectiles_x(enemy1_projectiles_x),
	.enemy_projectiles_y(enemy1_projectiles_y),
	.enemy_x(enemy_x),
	.enemy_y(enemy_y),
	.collide(collide),
	.collision(collision),
	.score(score),
    .destroy(destroy1)
	);
	
invader2 U5(
	.dclk(dclk),
	.clr(clr),
	.clk_1(clk_1),
	.clk_2(clk_2),
	.clk_3(clk_3),
	.clk_4(clk_4),
	.play(play),
	.projectiles_x(projectiles_x),
	.projectiles_y(projectiles_y),
	.enemy_projectiles_x(enemy2_projectiles_x),
	.enemy_projectiles_y(enemy2_projectiles_y),
	.enemy_x(enemy2_x),
	.enemy_y(enemy2_y),
	.collide(collide2),
	.collision(collision2),
	.score(score2),
    .destroy(destroy2)
	);	
invader3 U6(
	.dclk(dclk),
	.clr(clr),
	.clk_1(clk_1),
	.clk_2(clk_2),
	.clk_3(clk_3),
	.clk_4(clk_4),
	.play(play),
	.player_x(player_x),
	.player_y(player_y),
	.projectiles_x(projectiles_x),
	.projectiles_y(projectiles_y),
	.enemy_projectiles_x(enemy3_projectiles_x),
	.enemy_projectiles_y(enemy3_projectiles_y),
	.enemy_x(enemy3_x),
	.enemy_y(enemy3_y),
	.collide(collide3),
	.collision(collision3),
	.score(score3),
	.rand(rand),
    .destroy(destroy3)
	);	


score_keeper S1(
	.clk_score(clk_1),
	.play(play),
	.clr(clr),
  	.enemy1_score(score),
	.enemy2_score(score2),
	.enemy3_score(score3),
	.score(total_score),
	.gameover(gameover)
);

score_display S2(
	.clk_in_display(segclk),
	.clk_in_blink(clk_2), 
	.play(play),
	.clr(clr),
  	.score(total_score), 	
	.C(seg),
	.A(an)	
);

	/*
horizontal_invader U5(
	.dclk(dclk),
	.clr(clr),
	.clk_1(clk_1),
	.clk_2(clk_2),
	.clk_3(clk_3),
	.clk_4(clk_4),
	.projectiles_x(projectiles_x),
	.projectiles_y(projectiles_y),
	.pos_x(pos_x),
	.pos_y(pos_y),
	.collide(collide)
	);
*/
endmodule
