`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2024 01:42:07 PM
// Design Name: 
// Module Name: up_count_tb
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


module up_count_tb;
    reg clk;
    reg en;
    wire [11:0] count;
    
    up_count uut(clk, en, count);
    
    initial
    begin
    clk = 0;
    en = 0;
    forever #1 clk = ~clk;
        
    end
    initial begin
    forever begin
        #5 en = 1;
        #1 en = 0;
    end
    end
    

endmodule
