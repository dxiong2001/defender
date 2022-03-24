`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:27:49 02/25/2022 
// Design Name: 
// Module Name:    vga_display 
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
module vga_display(
   input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	input wire [9:0] player_x,
	input wire [9:0] player_y,
	input wire [9:0] enemy_x,
	input wire [9:0] enemy2_y,
	input wire [9:0] enemy2_x,
	input wire [9:0] enemy_y,
	input wire [9:0] enemy3_y,
	input wire [9:0] enemy3_x,
	input wire [9:0] projectiles_x,
	input wire [9:0] projectiles_y,
	input wire [45:0] enemy1_projectiles_x,
	input wire [44:0] enemy1_projectiles_y,
	input wire [45:0] enemy2_projectiles_x,
	input wire [44:0] enemy2_projectiles_y,
	input wire [9:0] enemy3_projectiles_x,
	input wire [9:0] enemy3_projectiles_y,
	input wire [2:0] lives,
	input wire play,
	input wire [4:0]collide,
	input wire [4:0]collide2,
	input wire [4:0]collide3,
	input wire gameover,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;
reg [1:0] explode = 0;
reg gameover2 = 0;
reg[9:0] tempx;
reg[9:0] tempy;
reg[9:0] tempx2;
reg[9:0] tempy2;

//wire [16:0]x_1[0:16];
//wire [16:0]y_1[0:16];
integer i;
reg [1:0]it;

reg offset;
reg start = 0;
/*
assign x_1[0] = pos_x[16*0+15:16*0];
assign x_1[1] = pos_x[16*1+15:16*1];
assign x_1[2] = pos_x[16*2+15:16*2];
assign x_1[3] = pos_x[16*3+15:16*3];
assign y_1[0] = pos_y[16*0+15:16*0];
assign y_1[1] = pos_y[16*1+15:16*1];
assign y_1[2] = pos_y[16*2+15:16*2];
assign y_1[3] = pos_y[16*3+15:16*3]; 
*/
reg [24:0] counter = 0;
reg blink1 = 0;
always @(posedge dclk) begin
	if(counter < 25'b0001000000000000000000000) begin
		blink1 <= 0;
	end
	else
		blink1 <= 1;
	counter <= counter + 1;

end
// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	
	
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
		
		
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
	
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
	// first check if we're within vertical active video range
	
	if (vc >= vbp && vc < vfp)
	begin
		// now display different colors every 80 pixels
		// while we're within the active horizontal range
		// -----------------
		// display white bar
		if (hc >= hbp && hc < (hbp+80))
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		else if (hc >= (hbp+80) && hc < (hbp+560))
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
		else if (hc >= (hbp+560) && hc < (hbp+640))
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end 
		/*
		// display cyan bar
		else if (hc >= (hbp+160) && hc < (hbp+240))
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b11;
		end
		// display green bar
		else if (hc >= (hbp+240) && hc < (hbp+320))
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b00;
		end
		// display magenta bar
		else if (hc >= (hbp+320) && hc < (hbp+420))
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b11;
		end
		// display red bar
		else if (hc >= (hbp+420) && hc < (hbp+480))
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b00;
		end
		// display blue bar
		else if (hc >= (hbp+480) && hc < (hbp+560))
		begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b11;
		end
		// display black bar
		else if (hc >= (hbp+560) && hc < (hbp+640))
		begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
		end */
		// we're outside active horizontal range so display black
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
		//DEFENDER
		if(play==0 || start == 0) begin
			gameover2 <= 0;
			if(play==0)
				start <= 1;
			if (hc >= hbp+20+5+220 && hc <= hbp+20+5+335 && vc <= vbp+200+35 && vc >= vbp+230)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			//D
			if (hc >= hbp+20+200 && hc <= hbp+20+200+10+5 && vc <= vbp+200+25+10 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end
			if (hc >= hbp+20+210+5 && hc <= hbp+20+210+5+5 && vc <= vbp+200+20+10 && vc >= vbp+205)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end
			//E
			if (hc >= hbp+20+5+220 && hc <= hbp+20+5+225 && vc <= vbp+200+25 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+225 && hc <= hbp+20+5+235 && vc <= vbp+200+5 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+225 && hc <= hbp+20+5+235 && vc <= vbp+200+15 && vc >= vbp+210)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+225 && hc <= hbp+20+5+235 && vc <= vbp+200+25 && vc >= vbp+220)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			
			
			//F
			if (hc >= hbp+20+5+240 && hc <= hbp+20+5+245 && vc <= vbp+200+25 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+240 && hc <= hbp+20+5+255 && vc <= vbp+200+5 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+240 && hc <= hbp+20+5+255 && vc <= vbp+200+15 && vc >= vbp+210)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			
			
			//E
			if (hc >= hbp+20+5+260 && hc <= hbp+20+5+265 && vc <= vbp+200+25 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+265 && hc <= hbp+20+5+275 && vc <= vbp+200+5 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+265 && hc <= hbp+20+5+275 && vc <= vbp+200+15 && vc >= vbp+210)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+265 && hc <= hbp+20+5+275 && vc <= vbp+200+25 && vc >= vbp+220)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			
			//N
			if (hc >= hbp+20+5+280 && hc <= hbp+20+5+285 && vc <= vbp+200+25 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+285 && hc <= hbp+20+5+290 && vc <= vbp+200+5 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+290 && hc <= hbp+20+5+295 && vc <= vbp+200+25 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			//D
			if (hc >= hbp+20+5+300 && hc <= hbp+20+5+310 && vc <= vbp+200+25 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end
			if (hc >= hbp+20+5+310 && hc <= hbp+20+5+315 && vc <= vbp+200+20 && vc >= vbp+205)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end
			//E
			
			if (hc >= hbp+20+5+320 && hc <= hbp+20+5+325 && vc <= vbp+200+25 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+325 && hc <= hbp+20+5+335 && vc <= vbp+200+5 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+325 && hc <= hbp+20+5+335 && vc <= vbp+200+15 && vc >= vbp+210)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+325 && hc <= hbp+20+5+335 && vc <= vbp+200+25 && vc >= vbp+220)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			//R
			if (hc >= hbp+20+5+340 && hc <= hbp+20+5+345 && vc <= vbp+200+35 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+345 && hc <= hbp+20+5+350 && vc <= vbp+200+5 && vc >= vbp+200)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+5+345 && hc <= hbp+20+5+350 && vc <= vbp+220 && vc >= vbp+215)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+350 + 5 && hc <= hbp+20+5+355 && vc <= vbp+200+15 && vc >= vbp+205)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			if (hc >= hbp+20+350 + 5 && hc <= hbp+20+5+355&& vc <= vbp+200+35 && vc >= vbp+220)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end

		end
		else begin
			if (hc >= (hbp+80) && hc < (hbp+560))
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
		//display enemy and player and projectiles
		end
		if(enemy3_y >= 480 || enemy2_y >= 480 || enemy2_y >= 480)begin
			gameover2<=1;
		end
		if(play==1 && (gameover ==1 || gameover2==1)) begin
			if (hc >= (hbp+80) && hc < (hbp+560))
			begin
				red = 3'b111;
				green = 0;
				blue = 0;
			end
		
		end
		
		if(play==1 && gameover ==0 && start ==1 && gameover2==0) begin
            if(lives==5) begin
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+20+10 && vc >= vbp+20-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+60+10 && vc >= vbp+60-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+100+10 && vc >= vbp+100-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
                
                if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+140+10 && vc >= vbp+140-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
                
                if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+180+10 && vc >= vbp+180-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
			end
            if(lives==4) begin
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+20+10 && vc >= vbp+20-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+60+10 && vc >= vbp+60-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+100+10 && vc >= vbp+100-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
                
                if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+140+10 && vc >= vbp+140-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
			end
			if(lives==3) begin
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+20+10 && vc >= vbp+20-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+60+10 && vc >= vbp+60-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+100+10 && vc >= vbp+100-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
			end
			if(lives==2) begin
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+20+10 && vc >= vbp+20-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+60+10 && vc >= vbp+60-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				
			end
			if(lives==1) begin
				if (hc >= hbp+40-10 && hc <= hbp+40+10 && vc <= vbp+20+10 && vc >= vbp+20-10)
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				
			end
			if (hc >= hbp+player_x-10 && hc <= hbp+player_x+10 && vc <= vbp+player_y+10 && vc >= vbp+player_y-10)
			begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			
			if (hc >= hbp+enemy3_x-10 && hc <= hbp+enemy3_x+10 && vc <= vbp+enemy3_y+10 && vc >= vbp+enemy3_y-10)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b11;
			end
		
		
			if(collide[0] == 0) begin
				if (hc >= (hbp+enemy_x-10) && hc <= (hbp+enemy_x+10) 
				&& vc <= vbp+enemy_y+10  && vc >= vbp+enemy_y-10 )
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
				end
				
			end
			
			if(collide[1] == 0) begin
				if (hc >= (hbp+enemy_x-10 + 40) && hc <= (hbp+enemy_x+10 + 40) 
				&& vc <= vbp+enemy_y+10  && vc >= vbp+enemy_y-10 )
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
				end
				
			end
			
			if(collide[2] == 0) begin
				if (hc >= (hbp+enemy_x-10 + 80) && hc <= (hbp+enemy_x+10 + 80) 
				&& vc <= vbp+enemy_y+10  && vc >= vbp+enemy_y-10 )
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
				end
				
			end
			
			if(collide[3] == 0) begin
				if (hc >= (hbp+enemy_x-10 + 120) && hc <= (hbp+enemy_x+10 + 120) 
				&& vc <= vbp+enemy_y+10  && vc >= vbp+enemy_y-10 )
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
				end
				
			end
			
			if(collide[4] == 0) begin
				if (hc >= (hbp+enemy_x-10 + 160) && hc <= (hbp+enemy_x+10 + 160) 
				&& vc <= vbp+enemy_y+10  && vc >= vbp+enemy_y-10 )
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
				end
				
			end
			
		if(collide2[0] == 0) begin
				if (hc >= (hbp+enemy2_x-10) && hc <= (hbp+enemy2_x+10) 
				&& vc <= vbp+enemy2_y+10  && vc >= vbp+enemy2_y-10 )
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
				end
				
			end
			
			if(collide2[1] == 0) begin
				if (hc >= (hbp+enemy2_x-10 + 40) && hc <= (hbp+enemy2_x+10 + 40) 
				&& vc <= vbp+enemy2_y+10  && vc >= vbp+enemy2_y-10 )
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
				end
				
			end
			
			if(collide2[2] == 0) begin
				if (hc >= (hbp+enemy2_x-10 + 80) && hc <= (hbp+enemy2_x+10 + 80) 
				&& vc <= vbp+enemy2_y+10  && vc >= vbp+enemy2_y-10 )
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
				end
				
			end
			
			if(collide2[3] == 0) begin
				if (hc >= (hbp+enemy2_x-10 + 120) && hc <= (hbp+enemy2_x+10 + 120) 
				&& vc <= vbp+enemy2_y+10  && vc >= vbp+enemy2_y-10 )
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
				end
				
			end
			
			if(collide2[4] == 0) begin
				if (hc >= (hbp+enemy2_x-10 + 160) && hc <= (hbp+enemy2_x+10 + 160) 
				&& vc <= vbp+enemy2_y+10  && vc >= vbp+enemy2_y-10 )
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
				end
				
			end
		
		//for(i=0; i< 4; i=i+1) begin
		/////////////////////////////////////////////////Player projectiles
			if(projectiles_y <= player_y )begin
				if (hc >= hbp+projectiles_x-5 && hc <= hbp+projectiles_x+5 
				&& vc <= vbp+projectiles_y+10 && vc >= vbp+projectiles_y-10)
				begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
					
				end
			end
		///////////////////////////////////////////////Enemy1 Projectiles	
			if(enemy1_projectiles_y[8:0] > 0 )begin
				if (hc >= hbp+enemy1_projectiles_x[8:0]-5 && hc <= hbp+enemy1_projectiles_x[8:0]+5 
				&& vc <= vbp+enemy1_projectiles_y[8:0]+10 && vc >= vbp+enemy1_projectiles_y[8:0]-10)
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
					
				end
			end
			if(enemy1_projectiles_y[17:9] > 0 )begin
				if (hc >= hbp+enemy1_projectiles_x[17:9]-5 && hc <= hbp+enemy1_projectiles_x[17:9]+5 
				&& vc <= vbp+enemy1_projectiles_y[17:9]+10 && vc >= vbp+enemy1_projectiles_y[17:9]-10)
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
					
				end
			end
			if(enemy1_projectiles_y[26:18] > 0 )begin
				if (hc >= hbp+enemy1_projectiles_x[26:18]-5 && hc <= hbp+enemy1_projectiles_x[26:18]+5 
				&& vc <= vbp+enemy1_projectiles_y[26:18]+10 && vc >= vbp+enemy1_projectiles_y[26:18]-10)
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
					
				end
			end
			if(enemy1_projectiles_y[35:27] > 0 )begin
				if (hc >= hbp+enemy1_projectiles_x[35:27] -5 && hc <= hbp+enemy1_projectiles_x[35:27] +5 
				&& vc <= vbp+enemy1_projectiles_y[35:27] +10 && vc >= vbp+enemy1_projectiles_y[35:27] -10)
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
					
				end
			end
			if(enemy1_projectiles_y[44:36]  > 0 )begin
				if (hc >= hbp+enemy1_projectiles_x[45:36]-5 && hc <= hbp+enemy1_projectiles_x[45:36]+5 
				&& vc <= vbp+enemy1_projectiles_y[44:36]+10 && vc >= vbp+enemy1_projectiles_y[44:36]-10)
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
					
				end
			end
		/////////////////////////////////////////////////////Enemy2 projectiles	
			if(enemy2_projectiles_y[8:0] > 0 )begin
				if (hc >= hbp+enemy2_projectiles_x[8:0]-5 && hc <= hbp+enemy2_projectiles_x[8:0]+5 
				&& vc <= vbp+enemy2_projectiles_y[8:0]+10 && vc >= vbp+enemy2_projectiles_y[8:0]-10)
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
					
				end
			end
			if(enemy2_projectiles_y[17:9] > 0 )begin
				if (hc >= hbp+enemy2_projectiles_x[17:9]-5 && hc <= hbp+enemy2_projectiles_x[17:9]+5 
				&& vc <= vbp+enemy2_projectiles_y[17:9]+10 && vc >= vbp+enemy2_projectiles_y[17:9]-10)
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
					
				end
			end
			if(enemy2_projectiles_y[26:18] > 0 )begin
				if (hc >= hbp+enemy2_projectiles_x[26:18]-5 && hc <= hbp+enemy2_projectiles_x[26:18]+5 
				&& vc <= vbp+enemy2_projectiles_y[26:18]+10 && vc >= vbp+enemy2_projectiles_y[26:18]-10)
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
					
				end
			end
			if(enemy2_projectiles_y[35:27] > 0 )begin
				if (hc >= hbp+enemy2_projectiles_x[35:27] -5 && hc <= hbp+enemy2_projectiles_x[35:27] +5 
				&& vc <= vbp+enemy2_projectiles_y[35:27] +10 && vc >= vbp+enemy2_projectiles_y[35:27] -10)
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
					
				end
			end
			if(enemy2_projectiles_y[44:36]  > 0 )begin
				if (hc >= hbp+enemy2_projectiles_x[45:36]-5 && hc <= hbp+enemy2_projectiles_x[45:36]+5 
				&& vc <= vbp+enemy2_projectiles_y[44:36]+10 && vc >= vbp+enemy2_projectiles_y[44:36]-10)
				begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b00;
					
				end
			end
			
			///////////////////////////Enemy 3 projectiles
			if(enemy3_projectiles_y > 0 )begin
				if (hc >= hbp+enemy3_projectiles_x-5 && hc <= hbp+enemy3_projectiles_x+5 
				&& vc <= vbp+enemy3_projectiles_y+5 && vc >= vbp+enemy3_projectiles_y-5)
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b11;
					
				end
			end
			
		end
			/*
			for (i=0;i<16;i=i+1) begin
				if(pos_y[i] < 300)begin
					
					if (hc >= hbp+pos_x[i]-10 && hc <= hbp+pos_x[i]+10 
					&& vc <= vbp+pos_y[i]+10 && vc >= vbp+pos_y[i]-10)
					begin
						red = 3'b111;
						green = 3'b000;
						blue = 2'b00;
						
					end
				end
			end
			*/
		
		/*	
		if(collide == 0) begin
			tempx <= enemy_x;
			tempy <= enemy_y;
			explode<=4;
		end
		if(collide == 1) begin
			tempx2 <= tempx;
			tempy2 <= tempy;
			explode <= 4;
		end	
		if(explode > 0)begin
			if (hc >= hbp+tempx-50 && hc <= hbp+tempx+50 && vc <= vbp+tempy+50 && vc >= vbp+tempy-50)
						begin
							red = 3'b111;
							green = 3'b111;
							blue = 2'b00;
						end
			case(explode)
				1: begin
						if (hc >= hbp+tempx-30 && hc <= hbp+tempx+30 && vc <= vbp+tempy+30 && vc >= vbp+tempy-30)
						begin
							red = 3'b111;
							green = 3'b111;
							blue = 2'b00;
						end
					end
				2: begin
						if (hc >= hbp+tempx-25 && hc <= hbp+tempx+25 && vc <= vbp+tempy+25 && vc >= vbp+tempy-25)
						begin
							red = 3'b111;
							green = 3'b111;
							blue = 2'b00;
						end
					end
				3: begin
						if (hc >= hbp+tempx-15 && hc <= hbp+tempx+15 && vc <= vbp+tempy+15 && vc >= vbp+tempy-15)
						begin
							red = 3'b111;
							green = 3'b111;
							blue = 2'b00;
						end
					end
				4: begin
						if (hc >= hbp+tempx-5 && hc <= hbp+tempx+5 && vc <= vbp+tempy+5 && vc >= vbp+tempy-5)
						begin
							red = 3'b111;
							green = 3'b111;
							blue = 2'b00;
						end
					end
			endcase
			explode <= explode - 1;
		end
		*/
		//end
		/*
		else if (hc >= (hbp+player_x-25) && hc <= (hbp+player_x) && vc >= vbp+player_y && vc <= vbp+player_y+25 && vc-player_y-vbp == player_x+hbp-hc)
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b11;
		end
		else if (hc >= (hbp+player_x) && hc <= (hbp+player_x+25) && vc >= vbp+player_y && vc <= vbp+player_y+25 && vc-player_y-vbp == hc-player_x-hbp)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b00;
		end
		*/
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule