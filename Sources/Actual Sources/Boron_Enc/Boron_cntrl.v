`timescale 1ns / 1ps

module Boron_Cntrl(
input clk,reset,start,
input [63:0] Prev_Text,
input [79:0] Prev_Key,

input [63:0]Plain_Text,
input [79:0]Key,

output reg[63:0] Current_Text,
output reg[79:0] Current_Key,

output reg[4:0] Permutation_Cycle_Counter,

output reg fin,
output reg [63:0] Cipher_Text,
output reg [79:0] Last_Key
    );
  reg [79:0] Master_master_key;
  reg [63:0] Cipher_Text_2;
  
localparam Idle     = 3'b000,
           Round    = 3'b010,
           Before_Fin =3'b011,
           Finish   = 3'b100;
reg [2:0] Current_State = Idle;
  
   always @(posedge clk) begin
        if(reset == 0)  begin
           if(Current_State == Round) begin
                    if(Permutation_Cycle_Counter < 24 ) 
                        Permutation_Cycle_Counter <=Permutation_Cycle_Counter+1;  
                   else 
                        Permutation_Cycle_Counter <= 0; 
            end
        end else 
             Permutation_Cycle_Counter <= 0;
   end
  
    
    always @(posedge clk) begin
        if(reset == 0) begin
            case(Current_State)
                 Idle    : begin 
                            if(start == 1)  begin
                            fin <= 0;
                                Current_State <= Round;
                                
                                 Current_Text    <=    Plain_Text; 
                                 Current_Key     <=    Key;  
                                
                           end end
                 Round   : begin                                     
                                    Current_Text    <=    Prev_Text;
                                    Current_Key     <=    Prev_Key ;
                                if(Permutation_Cycle_Counter == 23 ) 
                                    Current_State <= Before_Fin;
                                     Last_Key    <=  Prev_Key;
                                     Cipher_Text <= Prev_Text;
                             end
                  Before_Fin: begin 
                                   Master_master_key <= Prev_Key;
                                   Current_Text      <=    Prev_Text;
                                   Cipher_Text_2  <= Prev_Key[63:0] ^ Prev_Text;
                                   Current_State <=  Finish;
                               end
                 Finish  : begin  fin <= 1; Current_State <= Idle;  end
                 default : begin Current_State <= Idle; end
            endcase
        end else begin
            Current_Text   <= 0;
            Current_Key    <= 0;
            Permutation_Cycle_Counter <= 0;
    end end
    
    
endmodule
