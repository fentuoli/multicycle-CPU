`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/05 20:51:02
// Design Name: 
// Module Name: MEM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


 module memory(
input clock,
input [7:0] ra, wa, 
input [31:0] wd,
output [31:0] rd, 
output [31:0] rd1,
input we 
 ); 
dist_mem_gen_0 internal( 
.a(wa), // input wire [15 : 0] a 10 
.d(wd), // input wire [11 : 0] d 11 
.dpra(ra), // input wire [15 : 0] dpra 12 
.clk(clock), // input wire clk 13 
.we(we), // input wire we 14 
.dpo(rd),
.spo(rd1) ); // output wire [11 : 0] dpo
endmodule 