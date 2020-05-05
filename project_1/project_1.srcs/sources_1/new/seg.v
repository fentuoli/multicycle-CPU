`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/20 11:43:40
// Design Name: 
// Module Name: top
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


module segc(
input   clk,
input   rst,
input   [31:0] in,
output  [7:0]   an,
output  [6:0]   seg
    );

wire    rst_n;
wire    cout;
reg     pulse_1hz;
reg     [7:0]   seg_sel;
reg     [3:0]   seg_din;    
reg     [22:0]  cnt;    
 
seg_ctrl        seg_ctrl(
.x              (seg_din),
.sel            (seg_sel),
.an             (an),
.seg            (seg)
    ); 
 
 always@(posedge clk or posedge rst)
 begin
    if(rst)
        cnt <= 23'h0;
    else if(cnt<23'd5000000)
        cnt <= cnt + 1;
    else
        cnt <= 23'h0;
 end

/* always@(posedge clk or negedge rst_n)
 begin
    if(~rst_n)
        pulse_1hz   <= 1'b0;
    else if(cnt==23'd4999999)
        pulse_1hz   <= 1'b1;
    else
        pulse_1hz   <= 1'b0;
end*/

 always@(posedge clk )
begin
     case(cnt[15:13])
        3'b000:
        begin
            seg_sel <= 8'b1111_1110;
            seg_din <= in[3:0];
        end
        3'b001:
        begin
            seg_sel <= 8'b1111_1101;
            seg_din <= in[7:4];
        end
        3'b010:
        begin
            seg_sel <= 8'b1111_1011;
            seg_din <= in[11:8];
        end        
        3'b011:
        begin
            seg_sel <= 8'b1111_0111;
            seg_din <= in[15:12];
        end        
        3'b100:
        begin
            seg_sel <= 8'b1110_1111;
            seg_din <= in[19:16];
        end        
        3'b101:
        begin
            seg_sel <= 8'b1101_1111;
            seg_din <= in[23:20];
        end        
        3'b110:
        begin
            seg_sel <= 8'b1011_1111;
            seg_din <= in[27:24];
        end        
        3'b111:  
        begin
            seg_sel <= 8'b0111_1111;
            seg_din <= in[31:28];
        end        
        endcase      
end   
endmodule

module seg_ctrl(
input [3:0] x,
input[7:0] sel,
output [7:0] an,
output reg [6:0] seg
);
assign an=sel;
always @(x)
begin
case(x)
4'b0000:seg=7'b1000000;
4'b0001:seg=7'b1111001;
4'b0010:seg=7'b0100100;
4'b0011:seg=7'b0110000;
4'b0100:seg=7'b0011001;
4'b0101:seg=7'b0010010;
4'b0110:seg=7'b0000010;
4'b0111:seg=7'b1111000;
4'b1000:seg=7'b0000000;
4'b1001:seg=7'b0010000;
4'b1010:seg=7'b0100000;
4'b1011:seg=7'b0000011;
4'b1100:seg=7'b1000110;
4'b1101:seg=7'b0100001;
4'b1110:seg=7'b0000110;
4'b1111:seg=7'b0001110;
endcase
end
endmodule
