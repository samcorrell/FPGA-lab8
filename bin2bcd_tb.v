`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2024 02:23:38 PM
// Design Name: 
// Module Name: bin2bcd_tb
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


module bin2bcd_tb;
    reg clk,en;
    reg [11:0] bin;
    wire rdy;
    wire [15:0] bcd;
    
    bin2bcd uut(clk,en,bin,bcd,rdy);
    
    initial begin
        en=0; clk=0; bin=3456; forever #5 clk = ~clk;
    end
    
    initial begin
        #20;
        en = 1;
        #1000;
        en = 0;
        #500 $stop;
    end
    
   
endmodule
