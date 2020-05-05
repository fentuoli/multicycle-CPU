`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/04 20:03:33
// Design Name: 
// Module Name: CPU
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


module CPU(
input cont,
input step,
input mem,
input inc,
input dec,
input clk,
input choose,
input rst,
output [7:0] an,
output [6:0] seg,
//output reg [7:0] DDU_addr,
output [7:0] MEMORY
    );
    
wire [31:0] data;
reg [7:0] DDU_addr;
reg [7:0] DDU;
reg run;
reg step_ctr;   
reg inc_ctr;
reg dec_ctr; 
reg [3:0] current_state;
reg [3:0] next_state;
reg [31:0] PC,IR;
reg PCwrite;
reg IorD;
reg IRwrite;
reg ALUsrcA;
reg [31:0] writedata_mem;
reg PC_change;
reg [31:0] PCsource_mux;
reg memwrite1;
reg [31:0] ALUsrcB_mux;
reg [31:0] shift_left2;
wire [5:0] opcode_DDU;
wire cpuclk;
wire [2:0] ALUsrcB;
wire [31:0] ALUout_shift;
wire [2:0] PCsource;
wire PCwritecond;
wire addi;
wire j;
wire memread;
wire memwrite;
wire memtoreg;
wire [1:0] ALUop;
wire regwrite;
wire regdst;
wire [31:0] A,B;
wire [31:0] readdata;
wire [31:0] readdata1;
wire [4:0] readaddr_reg;
wire [31:0] MDR;
wire zero;
wire set_1;
wire [3:0] aluctr;
wire [7:0] readaddr_mem,writeaddr_mem;
wire [31:0] sign_extend;
wire [5:0] opcode,funct;
wire [4:0] rs,rt,rd,shamt;
wire [15:0] imm;
wire [25:0] jump;
wire [31:0] jump_shift;
wire [31:0] ALUout;
wire [31:0] writedata_mux,ALUsrcA_mux;
wire [7:0] IorD_mux;
wire [4:0] writereg_mux;
wire locked;
wire clk_50;
wire [3:0] IF,ID,EX_R,EX_I1,EX_LW,EX_SW,EX_I3,EX_J,MEM_R,MEM_I1,WB_LW,MEM_SW,MEM_I3,MEM_LW;

//定义状态 
assign IF=4'd1,
ID = 4'd2,
EX_R = 4'd3,
EX_I1 = 4'd4,
EX_LW = 4'd5,
EX_I3 = 4'd6,
EX_J = 4'd7,
MEM_R = 4'd8,
MEM_I1 = 4'd9,
MEM_LW = 4'd10,
MEM_SW = 4'd11,
MEM_I3 = 4'd12,
WB_LW = 4'd13,
EX_SW = 4'd14;
//定义操作数
assign opcode=IR[31:26],
funct = IR[5:0],
rs = IR[25:21],
rt = IR[20:16],
rd = IR[15:11],
shamt = IR[10:6],
imm = IR[15:0],
jump = IR[25:0];

segc  segc(
.clk  (clk_50),
.rst  (rst),
.in   (data),
.an   (an),
.seg  (seg)); 
    
//例化内存
dist_mem_gen_0 memory( 
.a(writeaddr_mem), // input wire [15 : 0] a 10 
.d(B), // input wire [11 : 0] d 11 
.dpra(readaddr_mem), // input wire [15 : 0] dpra 12 
.clk(cpuclk), // input wire clk 13 
.we(memwrite1), // input wire we 14 
.dpo(readdata),
.spo(readdata1) ); // output wire [11 : 0] dpo

//例化时钟
clk_wiz_0 clk_wiz_0( 
.clk_in1(clk), 
.clk_out1(clk_50), 
.locked(locked), 
.reset(rst)  
); 

//例化寄存器堆
regfile REGFILE(
.ra0(readaddr_reg),
.ra1(rt),
.wa(writereg_mux),
.wd(writedata_mux),
.we(regwrite),
.rst(rst),
.clk(cpuclk),
.rd0(A),
.rd1(B));

//例化控制信号
control_code CONTROL(
.opcode(opcode),
.funct(funct),
.clk(cpuclk),
.regdst(regdst),
.memtoreg(memtoreg),
.regwrite(regwrite),
.memread(memread),
.memwrite(memwrite),
.ALUop(ALUop),
.pcwritecond(PCwritecond),
.pcsource(PCsource),
.j(j),
.addi(addi),
.alusrcB(ALUsrcB));

//例化ALU
alu ALU(
.input1(ALUsrcA_mux),
.input2(ALUsrcB_mux),
.ALUop(ALUop),
.funct(funct),
.opcode(opcode),
.aluctr(aluctr),
.clk(cpuclk),
.rst(rst),
.alures(ALUout),
.zero(zero));

assign opcode_DDU=readdata1[31:26];
assign MEMORY=PC[9:2];
assign cpuclk=cont?clk_50:step;
assign readaddr_reg =(choose & ~mem)?DDU_addr[4:0]:rs;
assign readaddr_mem=(choose & mem)?DDU_addr:IorD_mux;
//assign writeaddr_mem = (choose & mem)?DDU_addr:ALUout[9:2];
assign writeaddr_mem = ALUout[9:2];
assign MDR = IorD?readdata:MDR;
//扩展位操作
assign sign_extend=(imm[15]&(addi|PCwritecond))?{16'hffff,imm}:{16'h0000,imm};
//移位操作
//assign shift_left2=(PC+(sign_extend<<2));
assign jump_shift={PC[31:28],jump,2'b00};

//多路选择器
assign IorD_mux = IorD?ALUout[9:2]:PC[9:2];
assign writereg_mux = regdst?rd:rt;
assign writedata_mux = memtoreg?MDR:ALUout;
assign ALUsrcA_mux = A;
assign data=mem?readdata:A;
//assign data=readdata1;

always @(posedge clk_50 or posedge rst)
begin
     if(rst)
     begin
        inc_ctr<=1;
        dec_ctr<=1;
        DDU_addr<=8'd0;
     end
     else
     begin
         if(inc & inc_ctr)
         begin
            DDU_addr<=DDU_addr+1;
            inc_ctr<=0;
         end
         if(~inc & ~inc_ctr)
             inc_ctr<=1;
         if(dec & dec_ctr)
         begin
              DDU_addr<=DDU_addr-1;
              dec_ctr<=0;
         end
        if(~dec & ~dec_ctr)
              dec_ctr<=1;
     end
end

always @(posedge cpuclk)
begin
     if(ALUsrcB==3'b000)
        ALUsrcB_mux=B;
     else if(ALUsrcB==3'b001)
        ALUsrcB_mux=32'd4;
     else if(ALUsrcB==3'b010)
        ALUsrcB_mux=sign_extend;
     else if(ALUsrcB==3'b011)
        ALUsrcB_mux=shift_left2;
end

//PCwritecond&zero
always @(current_state,PC_change,PCwritecond,zero,opcode)
begin
    if(current_state==EX_I3)
    begin
    if(opcode==6'b000100)
       PC_change=PCwritecond & zero ;
    else if(opcode==6'b000101)
       PC_change=PCwritecond & ~zero;
    else
       PC_change=0;
    end
    else
       PC_change=0;
end

always @(posedge cpuclk or posedge rst)
begin
     if(rst)
     begin
        current_state=4'd1;      
         PC<=32'h0000_0000;
         IorD<=0;
    end
     else
     begin
     case(current_state)
     IF:
     begin
        IorD<=0;
        PC<=PC+4;
        IR<=readdata;
        memwrite1<=0;
        current_state<=ID;
     end
     ID:
     begin  
       if(IR==32'h0000)
            current_state<=IF;
        else
        begin
         if(opcode==6'd0)
             current_state<=EX_R;
         else if(opcode==6'b100011)
             current_state<=EX_LW;
         else if(opcode==6'b101011)
             current_state<=EX_SW;    
         else if(opcode==6'b000100 || opcode==6'b000101)
             current_state<=EX_I3;
         else if(opcode==6'b000010)
             current_state<=EX_J;
         else
             current_state<=EX_I1;
         end
       end
       EX_R:
       begin
           current_state<=MEM_R;
        end
        MEM_R:
            current_state<=IF;
        EX_I1:
        begin
            current_state<=MEM_I1;
         end
         MEM_I1:
             current_state<=IF;
         EX_LW:
         begin
              current_state<=MEM_LW;
           end
           EX_SW:
           begin
               current_state<=MEM_SW;
           end
           MEM_LW:
           begin 
               IorD<=1;
               current_state<=WB_LW;
            end
            WB_LW:
            begin
                IorD<=0;
                current_state<=IF;
            end
            MEM_SW:
            begin                
                 memwrite1<=1;
                 current_state<=IF;
            end
            EX_I3:
            begin
                if(PC_change)
                begin
                     shift_left2=(PC+(sign_extend<<2));
                     PC<=shift_left2;
                end
                IorD<=0;
                current_state<=MEM_I3;
            end
            MEM_I3:
            begin
                 current_state<=IF;
            end
            EX_J:
            begin
                PC<=jump_shift;
                IorD<=0;
   
    current_state<=IF;
            end
          endcase
       end
   end 
endmodule
