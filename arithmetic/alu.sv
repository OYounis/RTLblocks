/*
    ALU module
    I designed this module mainly to compare between 
    enum based and conventional design synthesis 
*/

typedef enum {ADD, SUB, SLL, SRL, SRA, XOR, OR, AND} opcode_e;

module alu #(parameter WIDTH = 32)(
    input opcode_e operation_i,
    input logic [WIDTH-1 : 0] operand_a_i,
    input logic [WIDTH-1 : 0] operand_b_i,

    output logic [31:0] result_o
);
    //ADD
    logic negate_operand_b;

    logic [WIDTH-1 : 0] adder_result; 
    logic [WIDTH-1: 0] operand_a_add;
    logic [WIDTH-1 : 0] operand_b_add;

    assign  negate_operand_b = (operation_i == SUB);
    assign operand_b_add = {32{negate_operand_b}} ^ operand_b_i;
    assign operand_a_add = operand_a_i;
    assign adder_result = operand_a_add + operand_b_add + negate_operand_b;

    //SHIFT
    logic [WIDTH - 1 : 0] shift_operand_a;
    logic [WIDTH - 1 : 0] shift_logic;
    logic [WIDTH - 1 : 0] shift_arith, shifter_result;
    logic [$clog2(WIDTH) - 1 : 0] shift_amt;

    logic left_shift;
    
    assign left_shift = (operation_i == SLL);
    assign shift_operand_a = (left_shift)? {<<{operand_a_i}} : operand_a_i;
    assign shift_amt = operand_b_i[$clog2(WIDTH) - 1 : 0];
    assign shifter_result = shift_operand_a >> shift_amt;
    assign shift_logic = (left_shift)? {<<{shifter_result}} : shifter_result;
    
    assign shift_arith = operand_a_i >>> shift_amt;

    always_comb begin
        unique case (operation_i) 
        //Arithmetic Operations
        ADD, SUB: result_o = adder_result;
        //Shift Operations
        SLL, SRL: result_o = shift_logic;
        SRA: result_o = shift_arith;
        //Logical Operations
        XOR: result_o = operand_a_i ^ operand_b_i;
        OR: result_o = operand_a_i | operand_b_i;
        AND: result_o = operand_a_i & operand_b_i;
        endcase
    end
endmodule
