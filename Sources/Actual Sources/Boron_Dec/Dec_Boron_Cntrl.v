module  Dec_Boron_Cntrl(
input clk,reset,start,
input [63:0] Prev_Text,
input [79:0] Prev_Key,

input [63:0]Cipher_Text,
input [79:0]Key,

output Key_Gen_S,Start_Round_one_S,

output reg[63:0] Current_Text,
output reg[79:0] Current_Key,

output reg[4:0] Dec_Permutation_Cycle_Counter,

output reg Fin,
output reg [63:0] message,
output reg [79:0] key
    );

localparam Idle     = 3'b000,
           Round    = 3'b010,
           Key_Gen  = 3'b011,
           Start_Round_one = 3'b101,
           Start_Round_two = 3'b110,
           Finish   = 3'b100;

reg [2:0] Current_State = Idle;
reg [79:0]Master_Key; 
// One Further From Master
           
assign Key_Gen_S = (Current_State == Key_Gen) ?  1'b1: 1'b0 ;
assign Start_Round_one_S = (Current_State == Start_Round_two ) ? 1'b1: 1'b0 ;

   always @(posedge clk) begin
        if(reset == 0)  begin
           if(Current_State == Key_Gen) begin
                    if(Dec_Permutation_Cycle_Counter <= 23 ) 
                        Dec_Permutation_Cycle_Counter <=Dec_Permutation_Cycle_Counter +1;  
            end else if(Current_State == Round) begin
                       if(Dec_Permutation_Cycle_Counter >= 1 )
                        Dec_Permutation_Cycle_Counter <=Dec_Permutation_Cycle_Counter -1; 
            end 
        end
        else 
             Dec_Permutation_Cycle_Counter <= 0;
   end
  
    
    always @(posedge clk) begin
        if(reset == 0) begin
            case(Current_State)
                 Idle    : begin 
                            Fin      <= 0;
                            if(start == 1)  begin
                                Current_State <= Key_Gen;
//                                 Current_Text    <=    Cipher_Text; 
                                 Current_Key     <=    Key;  
                                
                           end end 
                 Key_Gen: begin       if(Dec_Permutation_Cycle_Counter == 24 ) begin
                                            Current_State <= Start_Round_one;
                                            Master_Key   <= Prev_Key ;
                                            Current_Key  <= Prev_Key ;
                                        end else begin
                                               Current_Key  <= Prev_Key ;
                                        end
                                        
                          end
                 Start_Round_one: begin
                 
                                     Current_Text    <=  Cipher_Text;
                                     Current_Key    <=   Master_Key;

                                      Current_State <= Start_Round_two ;
                            end 
                 Start_Round_two: begin
                 
                                     Current_Text    <=  Cipher_Text;
                                     Current_Key    <=   Master_Key;

                                      Current_State <= Round ;
                            end              
                            
                                    
                 Round   : begin                                     
                                    Current_Text    <=    Prev_Text;
                                    Current_Key     <=    Prev_Key ;
                                if(Dec_Permutation_Cycle_Counter == 0 ) 
                                    Current_State <= Finish;
                             end
                 Finish  : begin
                                message     <=     Current_Text ;
                                key         <=     Current_Key  ;
                                Fin      <= 1;
                           end
                 default : begin Current_State <= Idle; end
            endcase
        end else begin
            Current_Text   <= 0;
            Current_Key    <= 0;
            Dec_Permutation_Cycle_Counter <= 0;
    end end
    
    
endmodule