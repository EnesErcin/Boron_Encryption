`timescale 1ns / 1ps


module Boron_Complete_Wrapper  #(parameter Key_Bit_Size     =80, parameter Number_of_Rounds =26)  (

input clk,reset,start,    
input wire [79:0] Key,         
input wire [63:0] Cipher_Text  ,
        
input wire [63:0] Plain_Text  ,

input wire enc_dec
);
 
 
 wire Start_Dec   ,Start_Enc ;
 assign  Start_Dec=(enc_dec  == 1'b1 & start == 1'b1 )? 1'b1: 1'b0 ;
 assign  Start_Enc=(enc_dec  == 1'b0 & start == 1'b1 )? 1'b1: 1'b0;
  
 Dec_Boron_Wrapper #(.Key_Bit_Size(Key_Bit_Size ),.Number_of_Rounds(Number_of_Rounds))  Dec_Boron_Wrapper 
(
.clk(clk),.reset(reset),.start(Start_Dec),
.Key         (Key)          ,
.Cipher_Text (Cipher_Text  )
  );
  
    
    
 Boron_Wrapper #(.Key_Bit_Size(Key_Bit_Size ),.Number_of_Rounds(Number_of_Rounds))  Boron_Wrapper
(
.clk(clk),.reset(reset),.start(Start_Enc),
.Key         (Key)      ,
.Plain_Text  (Plain_Text)
  );
    
    
    
endmodule
