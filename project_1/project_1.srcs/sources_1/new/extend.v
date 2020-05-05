`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/05 22:29:09
// Design Name: 
// Module Name: extend
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


module extend(
input [15:0] in,
input sign,
output reg [31:0] out
    );
always @(*)
begin
   if(sign)
   begin
      if(in[15])
         out={16'hffff,in};
      else 
         out={16'h0000,in};
   end
   else
       out={16'h0000,in};
end
   
endmodule
