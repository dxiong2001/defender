`timescale 1ns / 1ps 

module rand (
    input clock,
    input reset,
    output [7:0] rnd 
    );

wire feedback = random[7] ^ random[5] ^ random[4] ^ random[3]; 

reg [7:0] random, random_next, random_done;
reg [2:0] count, count_next; //to keep track of the shifts

always @ (posedge clock or posedge reset)
begin
 if (reset)
 begin
  random <= 8'hF; //An LFSR cannot have an all 0 state, thus reset to FF
  count <= 0;
 end
 
 else
 begin
  random <= random_next;
  count <= count_next;
 end
end

always @ (*)
begin
 random_next = random; //default state stays the same
 count_next = count;
  
  random_next = {random[5:0], feedback}; //shift left the xor'd every posedge clock
  count_next = count + 1;

 if (count == 7)
 begin
  random_done = random; //assign the random number to output after 13 shifts
 end
 
end


assign rnd = random_done;

endmodule