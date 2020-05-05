`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/04 20:08:37
// Design Name: 
// Module Name: ALU
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


module CTR(
input [1:0] ALUop,
input [5:0] funct,
input [5:0] opcode,
output reg [3:0] ALUctr);
always @(ALUop or funct)
casex({ALUop,funct})
     8'b10100000:ALUctr=4'b0000;//add
     8'b10100010:ALUctr=4'b0001;//sub
     8'b10100100:ALUctr=4'b0010;//and
     8'b10100101:ALUctr=4'b0011;//or
     8'b10100110:ALUctr=4'b0100;//xor
     8'b10100111:ALUctr=4'b0101;//nor
     8'b10101010:ALUctr=4'b0110;//slt,slti
     8'b01xxxxxx:ALUctr=4'b0001;//beq,bne
     8'b00xxxxxx:ALUctr=4'b0000;//lw,sw
     8'b11xxxxxx:
     begin
     casex({ALUop,opcode})
     8'b11001000:ALUctr=4'b0000;//addi
     8'b11001100:ALUctr=4'b0010;//andi
     8'b11001101:ALUctr=4'b0011;//ori  
     8'b11001110:ALUctr=4'b0100;//xori
     8'b11001010:ALUctr=4'b0110;//slti  
     endcase
     end
endcase
endmodule 

module alu(
input [31:0] input1,
input [31:0] input2,
input [1:0] ALUop,
input [5:0] funct,
input [5:0] opcode,
input [3:0] aluctr,
input clk,
input rst,
output reg[31:0] alures,
//output reg rd,
output reg zero);
CTR control(.ALUop(ALUop),.funct(funct),.opcode(opcode),.ALUctr(aluctr));
always @(*)
begin
    if(rst)
    alures=32'h0000;
    else
    begin
    case(aluctr)
       4'b0000://add
           alures=input1+input2;
       4'b0001://sub
       begin
           alures=input1-input2;
           if(alures==0)
               zero=1;
            else
                zero=0;
        end
        4'b0010://and
             alures=input1 & input2;
        4'b0011://or
             alures=input1 | input2;
        4'b0100://xor
             alures=input1 ^ input2;
        4'b0101://nor
             alures=~(input1 | input2);    
        4'b0110://slt
        begin
             if(input1 < input2)
                 alures=32'd1;
             else
                 alures=32'd0;
        end
     endcase
   end
 end       
endmodule
