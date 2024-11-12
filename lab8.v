`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2024 01:38:46 PM
// Design Name: 
// Module Name: lab8
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


module lab8(
    input clk,
    output [6:0] seg,
    output [3:0] an
    );
    
    wire [11:0] count;
    reg div_strobe = 0;
    wire [15:0] bcd;
    reg en = 0;
    reg [32:0] div_count = 0;
    wire rdy;
    
    up_count uut1(clk, div_strobe, count);
    bin2bcd uut2(clk, en, count, bcd, rdy);
    lab5 uut3(bcd, clk, seg, an);
    
    always @(posedge clk)
    begin
        if(div_count==50000000)
        begin
            div_count <= 0;
            div_strobe<=1;
        end
        else
        begin
            div_count <= div_count+1;
            div_strobe<=0;
        end
    end

    always @(*)
    begin
        if(rdy)
            en=0;
        if(div_count==2)
            en=1;
    end

endmodule






module up_count(
    input clk, en,
    output reg [11:0] count=0
    );
    
    always @(posedge clk)
    begin
        if(en)
        begin
            if(&count)
                count<=0;
            else
                count <= count +1;
        end
    end
endmodule










module bin2bcd(
    input clk, en,
    input [11:0] bin,
    output reg [15:0] bcd,
    output reg rdy
    );
    parameter [2:0] idle = 0, setup = 1, add = 2, shift = 3, done = 4;
    reg [2:0] ps = 0,ns;
    parameter [3:0] max_shift = 12;
    reg [3:0] shifts = 0;
    reg busy;
    reg [27:0] bcd_bin, bcd_bin_mem;
    always @(posedge clk)
    begin
        ps<=ns;
        bcd_bin_mem<=bcd_bin;
        if(!en)begin
            shifts <= 0;
            bcd_bin_mem <= {16'b0,bin};
        end
        
        if(rdy)
        begin
            bcd<=bcd_bin_mem[27:12];
        end
        
        if(ns==shift)
            shifts<=shifts+1;
    end
    

    
    always @(*)
    begin
        bcd_bin = bcd_bin_mem;
        case(ps)
        
            idle:
            begin
                busy = 0;
                rdy = 0;
                if(en)
                    ns=setup;
                else
                    ns = idle;
            end
            
            setup:
            begin
                busy = 1;
                rdy = 0;
                if(en)
                    ns=add;
                else
                    ns = idle;
            end
            
            add:
            begin
                busy = 1;
                rdy = 0;
                if(bcd_bin_mem[15:12] > 4)
                    bcd_bin[27:12] = bcd_bin_mem[27:12] + 3;
                if(bcd_bin_mem[19:16] > 4)
                    bcd_bin[27:16] = bcd_bin_mem[27:16] + 3;  
                if(bcd_bin_mem[23:20] > 4)
                    bcd_bin[27:20] = bcd_bin_mem[27:20] + 3;
                if(bcd_bin_mem[27:24] > 4)
                    bcd_bin[27:24] = bcd_bin_mem[27:24] + 3;
                    
                    
                if(en)
                    ns=shift;
                if(!en)
                    ns = idle;
            end

            
            shift:
            begin
                //shifts = shifts+1;
                busy = 1;
                rdy = 0;
                bcd_bin = {bcd_bin_mem[26:0], 1'b0};
                if(en && shifts==max_shift)
                    ns = done;
                if(en && shifts<max_shift)
                    ns = setup;
                if(!en)
                    ns = idle;
            end
            
            done:
            begin
                busy = 1;
                rdy = 1;  
                if(en)
                begin
                    ns=done;
                end
                else
                    ns = idle;
                
                
            end
        endcase
    end
    
endmodule















module lab5(
    input [15:0]num,
    input clk,
    output [6:0]seg,
    output [3:0]an
    );
    
    wire [3:0]an_w, bcd;
    wire en;
    anode_gen uut1(clk,en,an_w);
    bcd_mux uut2(num,en,an_w,bcd);
    led_7seg uut3(clk,bcd,seg);
    assign an = ~(an_w);
endmodule






module led_7seg(
    input clk,
    input [3:0]i,
    output reg [6:0]seg
    );
    
    always @(*)
    begin
        case(i)
            0: seg = 7'b1000000;
            1: seg = 7'b1111001;
            2: seg = 7'b0100100;
            3: seg = 7'b0110000;
            4: seg = 7'b0011001;
            5: seg = 7'b0010010;
            6: seg = 7'b0000010;
            7: seg = 7'b1111000;
            8: seg = 7'b0000000;
            9: seg = 7'b0010000;
            10: seg = 7'b0000000;
            11: seg = 7'b0000000;
        endcase
    end
            
endmodule


module bcd_mux(
    input [15:0]num,
    input en,
    input [3:0]sel,
    output reg [3:0]bcd
    );
    
    
    always @(*)
    begin
    if(en) begin
        case(sel)
            4'b1000: bcd = num[15:12];
            4'b0100: bcd = num[11:8];
            4'b0010: bcd = num[7:4];
            4'b0001: bcd = num[3:0];
        endcase
    end
    end 
    
endmodule





module anode_gen(
    input clk,
    output reg en,
    output reg [3:0] an
);

     reg [7:0]count;
    initial
    begin
        an = 4'b0001;
        count = 0;
        en=1'b0;
    end
    
    
    always @(posedge clk)
    begin
        if(en)begin
        count<=count+1;
        end
        en <= 1'b1;
            
        if(count==8'd255)
        begin
          en = 1'b1;
            count<=0;                
            if(an==4'b0001)
                an<=4'b1000;
            else
                an <= an>>1;
        end

    end
    
endmodule


