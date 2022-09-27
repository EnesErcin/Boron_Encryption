`timescale 1ns / 1ps


module Dec_Round_tb(

    );
    
   reg  [63:0]Current_Text;
   reg [79:0] Key;
wire [63:0] Updated_Text;


 round_teset UUT(
.Key         (Key)  , 
.Current_Text(Current_Text)  ,
.Updated_Text(Updated_Text)
);
 
    
initial begin
Current_Text <=  64'h8afaa49b773bd03;       
Key          <=  80'h497c41fec3b69bcbf171;  
#300
Current_Text <=64'h3bd8f07913e117f4;
Key          <=80'hef0e726f2fc5c524d10a;

end


endmodule
