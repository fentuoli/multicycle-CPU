`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 17:45:39
// Design Name: 
// Module Name: CPU_t
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


module CPU_t(

    );
reg cont, step, mem, inc, dec, clk, choose, rst;
wire [7:0] an;
wire [6:0] seg;
wire [7:0] MEMORY;
integer i,j;
CPU cpu(.cont(cont), .step(step), .mem(mem),.inc(inc),.dec(dec),.clk_50(clk),.choose(choose),.rst(rst),.an(an),.seg(seg),.MEMORY(MEMORY));
initial
begin
clk=1;
step=1;
while(1)
begin
#5 clk=~clk;
step=~step;
end
end

initial
begin
rst=1;
#20 rst=0;
end

initial
begin
cont=0;
mem=0;
choose=0;
#1000 cont=1;
#1000 mem=1;
choose=1;
end

/*initial
begin
cont=1;
step=0;
#3000
cont=0;
//while(1)
//#10 step=~step;
end*/

initial
begin
inc=0;
dec=0;
#3000
for(i=0;1;i=i+1)
begin
#10 inc=~inc;
end
end

endmodule
