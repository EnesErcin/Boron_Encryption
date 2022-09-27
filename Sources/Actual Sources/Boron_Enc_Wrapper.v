`timescale 1ns / 1ps

module Boron_Wrapper #(parameter Key_Bit_Size     =80, parameter Number_of_Rounds =26) 
(
input clk,reset,start,
input [79:0] Key,
input [63:0] Plain_Text
  );
    
wire  [79:0] Updated_Key;
wire  [4:0] Permutation_Cycle_Counter;
wire  [63:0]   Current_Text;
wire  [79:0]   Current_Key;
wire  [63:0]   Update_Text;

wire [63:0]Xored_Key_Text;

Key_Scheduler #(.Key_Bit_Size(Key_Bit_Size ),.Number_of_Rounds(Number_of_Rounds)) 
Key_Scheduler 
(
.Counter    (Permutation_Cycle_Counter),
.Prev_Key   (Current_Key)       ,
.Updated_Key(Updated_Key)    ,
.Round_Key  ()
    );
    

Boron_Cntrl Boron_Cntrl(
.clk(clk),.reset(reset),.start(start),
.Prev_Text(  Update_Text       )  ,
.Prev_Key (  Updated_Key       )  ,

.Plain_Text(Plain_Text),
.Key(Key),

.Current_Text(Current_Text),
.Current_Key(Current_Key),
.Permutation_Cycle_Counter(Permutation_Cycle_Counter)
    );
    
Generic_Xor  #(.bit_size(64)) Xor_Key_Text
(
 .Xor_Layer_op_1(Current_Text)           ,
 .Xor_Layer_out (Xored_Key_Text)                       ,
 .Xor_Layer_op_2(Current_Key [63:0])
 );


Round  Round_Text(
.Current_Text(Xored_Key_Text),
.Updated_Text(Update_Text )
);
 
    
//Add_Round_Key Add_Round_Key( 
//.Round_Key(Current_Key[63:0]),
//.Current_Text(Current_Text),
//.Updated_Cipher_Text(Update_Text)
//);   
    
endmodule
