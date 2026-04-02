module ALU(A,B,Result,ALUControl,OverFlow,Carry,Zero,Negative);

    input [31:0]A,B;
    input [2:0]ALUControl;
    output Carry,OverFlow,Zero,Negative;
    output [31:0]Result;

    wire Cout;
    wire [31:0]Sum;

    assign Sum = (ALUControl[0] == 1'b0) ? A + B : (A + ((~B)+1)) ;
    assign {Cout,Result} =  (ALUControl == 3'b000) ? Sum :
                            (ALUControl == 3'b001) ? Sum :
                            (ALUControl == 3'b010) ? A & B :
                            (ALUControl == 3'b011) ? A | B :
                            (ALUControl == 3'b101) ? {{32{1'b0}},(Sum[31])} :
                            // (ALUControl == 3'b101) ? {31'b0, Sum[31]} :
                            {33{1'b0}};
    assign OverFlow = ((Sum[31] ^ A[31]) & (~(ALUControl[0] ^ B[31] ^ A[31])) & (~ALUControl[1]));

    // assign OverFlow = (ALUControl == 3'b000) ? 
    //                  ((A[31] & B[31] & ~Result[31]) | (~A[31] & ~B[31] & Result[31])) :
    //                  (ALUControl == 3'b001) ? 
    //                  ((A[31] & ~B[31] & ~Result[31]) | (~A[31] & B[31] & Result[31])) :
    //                  1'b0;
    assign Carry = ((~ALUControl[1]) & Cout);
    assign Zero = &(~Result);
    // assign Zero = (Result == 32'b0);
    assign Negative = Result[31];

endmodule