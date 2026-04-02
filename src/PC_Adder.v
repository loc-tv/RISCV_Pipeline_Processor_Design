module PC_Adder (a,b,c);

    input [31:0]a,b;
    output [31:0]c;

    assign c = a + b;
    
endmodule

// module PC_Adder (
//     input  [31:0] PC,
//     input  [31:0] offset,
//     output [31:0] PC_out
// );
//     assign PC_out = PC + offset;
// endmodule