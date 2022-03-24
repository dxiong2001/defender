`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

// Company: 

// Engineer: 

// 

// Create Date:    10:30:51 02/25/2022 

// Design Name: 

// Module Name:    clock 

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

module clock(

    input wire clk,		//master clock: 50MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output wire segclk,	//7-segment clock: 381.47Hz
	output wire clk_1,
	output wire clk_2,
	output wire clk_3,
	output wire clk_4,
	output wire clk_score,
	output wire clk_blink
	);

// 17-bit counter variable
reg [16:0] q;

// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
always @(posedge clk or posedge clr)
begin
	// reset condition
	if (clr == 1)
		q <= 0;
	// increment counter by one
	else
		q <= q + 1;
end

// 50Mhz  2^17 = 381.47Hz
assign segclk = q[16];

// 50Mhz  2^1 = 25MHz
assign dclk = q[1];


reg [31:0] a;
reg c1;
always @ (posedge clk)
	if (clr) begin
		a <= 32'b0;
		c1 <= 1'b0;
	end
	else if (a == 32'b10111110101111000001111111) begin
		a <= 32'b0;
		c1 <= ~c1;
	end
	else
		a <= a + 1'b1;

reg [31:0] b;
reg c2;
always @ (posedge clk)
	if (clr)
	begin
		b <= 32'b0;
		c2 <= 1'b0;
	end
	else if (b == 32'b1011111010111100000111111)
	begin
		b <= 32'b0;
		c2 <= ~c2;
	end
	else
		b <= b + 1'b1;

reg [31:0] c;
reg c4;
always @ (posedge clk)
	if (clr)
	begin
		c <= 32'b0;
		c4 <= 1'b0;
	end
	else if (c == 32'b101111101011110000011111)
	begin
		c <= 32'b0;
		c4 <= ~c4;
	end
	else
		c <= c + 1'b1;

reg [31:0] d;
reg c400;
always @ (posedge clk)
	if (clr)
	begin
		d <= 32'b0;
		c400 <= 1'b0;
	end
	else if (d == 32'b11110100001000111)
	begin
		d <= 32'b0;
		c400 <= ~c400;
	end
	else
		d <= d + 1'b1;

assign clk_1 = c1;
assign clk_2 = c2;
assign clk_3 = c4;
assign clk_4 = c400;

reg [31:0] e;
reg cscore;
always @ (posedge clk)
	if (clr)
	begin
		e <= 32'b0;
		cscore <= 1'b0;
	end
	else if (e == 32'd50000000)
	begin
		e <= 32'd0;
		cscore <= ~c400;
	end
	else
		e <= e + 1'd1;
		
reg [31:0] f;
reg cblink;
always @ (posedge clk)
	if (clr)
	begin
		f <= 32'b0;
		cblink <= 1'b0;
	end
	else if (f == 32'd10000000)
	begin
		f <= 32'd0;
		cblink <= ~c400;
	end
	else
		f <= f + 1'd1;

assign clk_score = cscore;
assign clk_blink = cblink;

endmodule