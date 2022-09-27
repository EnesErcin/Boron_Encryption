
module Dec_Boron_Wrapper #(parameter Key_Bit_Size     =80, parameter Number_of_Rounds =26) 
(
input clk,reset,start,
input [79:0] Key,
input [63:0] Cipher_Text
  );
  
wire  [79:0] Updated_Key,Updated_Key_Make,Updated_Key_Dec;
wire  [4:0] Permutation_Cycle_Counter;
wire  [63:0]   Current_Text,Dec_Rnd_Text;
wire  [79:0]   Current_Key;
wire  [63:0]   Update_Text, Update_Text_Round;

wire [63:0]Xored_State,Xored_State_two;
wire Key_Gen_S,Start_Round_one_S;


wire [63:0] Xor_Cipher_Text_S,Xor_Cipher_Text,Master_Key;

assign Updated_Key = (Key_Gen_S == 1'b1) ? Updated_Key_Make:Updated_Key_Dec ;

Dec_Key_Scheduler #(.Key_Bit_Size(Key_Bit_Size ),.Number_of_Rounds(Number_of_Rounds)) 
Dec_Key_Scheduler 
(
.Dec_Counter        (Permutation_Cycle_Counter),
.Prev_Key           (Current_Key)       ,
.Dec_Updated_Key    (Updated_Key_Dec)    
 );

Key_Scheduler #(.Key_Bit_Size(Key_Bit_Size ),.Number_of_Rounds(Number_of_Rounds)) 
Key_Scheduler
(
.Counter        (Permutation_Cycle_Counter),
.Prev_Key           (Current_Key)       ,
.Updated_Key    (Updated_Key_Make)    
 );
 
assign Update_Text = (Key_Gen_S == 1'b1) ? Xor_Cipher_Text: Update_Text_Round;  
 
Generic_Xor  #(.bit_size(64)) Xor_Cipher_INT
(
 .Xor_Layer_op_1( Current_Text         )            ,
 .Xor_Layer_out (Xor_Cipher_Text       )                       ,
 .Xor_Layer_op_2( Current_Key           )
 );

Dec_Boron_Cntrl Boron_Cntrl(
.clk(clk),.reset(reset),.start(start),
.Prev_Text(  Update_Text       )  ,
.Prev_Key (  Updated_Key       )  ,
.Key_Gen_S(Key_Gen_S),
.Cipher_Text(Cipher_Text),
.Key(Key),

.Start_Round_one_S(Start_Round_one_S),
.Current_Text(Current_Text),
.Current_Key(Current_Key),
.Dec_Permutation_Cycle_Counter(Permutation_Cycle_Counter)
    );
    
Generic_Xor  #(.bit_size(64)) Xor_Key_Text
(
 .Xor_Layer_op_1( Current_Text        )            ,
 .Xor_Layer_out (Xored_State)                       ,
 .Xor_Layer_op_2( Current_Key[63:0]    )
 );

Dec_Round  Round_Text(
.Current_Text(Xored_State),
.Updated_Text(Dec_Rnd_Text)
);

assign Update_Text = (Start_Round_one_S == 1'b1) ? Xored_State_two: Dec_Rnd_Text;

Generic_Xor  #(.bit_size(64)) Xor_Key_Again
(
 .Xor_Layer_op_1(Dec_Rnd_Text       )            ,
 .Xor_Layer_out (Xored_State_two)                       ,
 .Xor_Layer_op_2( Updated_Key    )
 );

     

//Dec_Boron_Cntrl Boron_Cntrl(
//.clk(clk),.reset(reset),.start(start),
//.Prev_Text(  Update_Text       )  ,
//.Prev_Key (  Updated_Key       )  ,
//.Key_Gen_S(Key_Gen_S),
//.Cipher_Text(Cipher_Text),
//.Key(Key),

//.Current_Text(Current_Text),
//.Current_Key(Current_Key),
//.Dec_Permutation_Cycle_Counter(Permutation_Cycle_Counter)
//    );
    
//Generic_Xor  #(.bit_size(64)) Xor_Key_Text
//(
// .Xor_Layer_op_1( Current_Text         )            ,
// .Xor_Layer_out (Xored_State)                       ,
// .Xor_Layer_op_2( Current_Key[63:0]    )
// );

//Dec_Round  Round_Text(
//.Current_Text(Xored_State),
//.Updated_Text(Update_Text_Round)
//);

endmodule
