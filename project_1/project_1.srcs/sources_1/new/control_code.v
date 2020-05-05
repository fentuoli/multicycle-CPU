`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/04 20:09:20
// Design Name: 
// Module Name: control_code
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


module control_code(
input [5:0] opcode,
input [5:0] funct,
input clk,
output reg regdst,
output reg memtoreg,
output reg regwrite,
output reg memread,
output reg memwrite,
output reg [1:0] ALUop,
output reg pcwritecond,
output reg [2:0] pcsource,
output reg j,
output reg addi,
output reg [2:0] alusrcB
    );
always @(opcode,funct)
begin
    case(opcode)
    6'b000000://RÐÍ
    begin
       if(funct==6'd0)
           regwrite=0;
       else
           regwrite=1;
        regdst=1;
        memtoreg=0;
        memread=0;
        memwrite=0;
        ALUop=10;
        pcwritecond=0;
        pcsource=3'b000;
        j=0;
        addi=0;
        alusrcB=3'b000;
     end
     
     6'b100011://lw
     begin
         regdst=0;
         memtoreg=1;
         regwrite=1;
         memread=1;
         memwrite=0;
         ALUop=00;
         pcwritecond=0;
         pcsource=3'b000;
         j=0;
         addi=0;
         alusrcB=3'b010;
      end
      
      6'b101011://sw
      begin
          regdst=0;
          memtoreg=0;
          regwrite=0;
          memread=0;
          memwrite=1;
          ALUop=00;
          pcwritecond=0;
          pcsource=3'b000;
          j=0;
          addi=0;
          alusrcB=3'b010;
       end
       
       6'b000100,6'b000101://beq,bne
       begin
           regdst=0;
           memtoreg=0;
           regwrite=0;
           memread=0;
           memwrite=0;
           ALUop=01;
           pcwritecond=1;
           pcsource=3'b001;
           j=0;
           addi=0;
           alusrcB=3'b000;
        end
       
       6'b000010://j
       begin
           regdst=0;
           memtoreg=0;
           regwrite=0;
           memread=0;
           memwrite=0;
           ALUop=01;           
           pcwritecond=0;
           pcsource=3'b010;
           j=1;
           addi=0;
           alusrcB=3'b011;
       end
       
       default://IÐÍ
       begin
           regdst=0;
           memtoreg=0;
           regwrite=1;
           memread=0;
           memwrite=0;
           ALUop=11;
           pcwritecond=0;
           pcsource=3'b000;
           j=0;
           if(opcode==6'b001000)
           addi=1;
           else
           addi=0;
           alusrcB=3'b010;
        end
    endcase
end

endmodule
