`timescale 1ns / 1ps



module Boron_Wrapper_tb #(parameter Key_Bit_Size     =80, parameter Number_of_Rounds =26)
(    );
localparam clk_per = 2;
reg clk = 0; always #(clk_per /2) clk <= ~clk;
reg start= 0;
reg reset = 1;
reg [79:0] Key;
reg [63:0]Plain_Text;
    
Boron_Wrapper #(.Key_Bit_Size(Key_Bit_Size),   .Number_of_Rounds(Number_of_Rounds) )  
UUT ( .clk(clk),.reset(reset),.start(start), .Key(Key), .Plain_Text(Plain_Text));
 
 
initial begin
#50 start <= 1;
#50 Plain_Text <= 0;
#50 Key <= 0;
#50 reset <= 0;
#250 reset <= 0;

end 
  
endmodule
