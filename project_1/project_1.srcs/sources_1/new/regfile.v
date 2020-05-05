`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/04 20:08:21
// Design Name: 
// Module Name: regfile
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


module regfile(
input [4:0] ra0,
input [4:0] ra1,
input [4:0] wa,
input [31:0] wd,
input we,
input rst,
input clk,
output reg [31:0] rd0,
output reg [31:0] rd1
    );
    
reg     [22:0]  cnt; 
reg     [31:0] register [0:31];

always @(posedge clk or posedge rst)
begin
     if(rst)
     begin
     register[0]=0;
     register[1]=0;
     register[2]=0;
     register[3]=0;
     register[4]=0;
     register[5]=0;
     register[6]=0;
     register[7]=0;
     register[8]=0;
     register[9]=0;
     register[10]=0;
     register[11]=0;
     register[12]=0;
     register[13]=0;
     register[14]=0;
     register[15]=0;
     register[16]=0;
     register[17]=0;
     register[18]=0;
     register[19]=0;
     register[20]=0;
     register[21]=0;
     register[22]=0;
     register[23]=0;
     register[24]=0;
     register[25]=0;
     register[26]=0;
     register[27]=0;
     register[28]=0;
     register[29]=0;
     register[30]=0;
     register[31]=0;     
     end
     else
     begin
     if(we)
          register[wa]<=wd;
     else
          register[wa]<=register[wa];
     end
end
 
always @(*)
begin
     if(rst)
     begin
        rd0=0;
        rd1=0;
      end
      else
      begin
         rd0=register[ra0];
         rd1=register[ra1];
      end
end         

endmodule