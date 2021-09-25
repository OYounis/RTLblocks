//Assossiative byte addressable memory

`define DEUL_PORT
`define INITIALIZE
`timescale 1ns/1ns

module sparse_mem #(
    parameter XLEN  = 32,       //word and adddress length
    parameter BADDR = 2        //byte address
)(
    input logic clk_i,
    input logic gwe_i, rd_i,
    input logic bw0_i, bw1_i, bw2_i, bw3_i,
    input logic [XLEN - 1: 0] addr_i, data_i,

`ifdef DEUL_PORT
    //port b
    input logic bgwe_i, brd_i,
    input logic bbw0_i, bbw1_i, bbw2_i, bbw3_i,
    input logic [XLEN - 1: 0] baddr_i, bdata_i,

    output logic [XLEN - 1: 0] bdata_o,
`endif

    output logic [XLEN - 1: 0] data_o
);

localparam BC    = XLEN / 8;
localparam EADDR = XLEN - BADDR; 

logic [BC - 1: 0][7: 0] MEM [*];

logic [EADDR - 1: 0] waddr;  
logic [BADDR - 1: 0] baddr; 
assign waddr = addr_i [XLEN - 1: BADDR];
assign baddr = addr_i [BADDR - 1: 0];

`ifdef INITIALIZE
logic[XLEN - 1: 0] index;
logic[XLEN - 1: 0] start = 31'h40000000;
initial begin
    $readmemh("mem.hex", MEM, start);
    #1
    $display("\tNumber of entries in MEM is %0d",MEM.num());
    $display("--- Associative array entries and Values are ---");
    foreach(MEM[i]) $display("\tMEM[%0d] \t = %0d",i,MEM[i]);
    $display("--------------------------------------------------------");
     
    //first()-Associative array method
    MEM.first(index);
    $display("\First entry is \t MEM[%0d] = %0d",index,MEM[index]);
 
    //last()-Associative array method
    MEM.last(index);
    $display("\Last entry is \t MEM[%0d] = %0d",index,MEM[index]);
end
`endif

always_ff @(posedge clk_i) begin
    if (rd_i) data_o = MEM[waddr];
    if (gwe_i) MEM[waddr] = data_i;
    else begin
        case (baddr)
        2'b00: begin        //half and byte writes
            if (bw0_i) MEM[waddr][0] = data_i[7:0];
            if (bw1_i) MEM[waddr][1] = data_i[15:8];
        end 2'b01: begin   //byte write only
            if (bw1_i) MEM[waddr][1] = data_i[7:0];
        end 2'b10: begin   //half and byte writes
            if (bw2_i) MEM[waddr][2] = data_i[7:0];     
            if (bw3_i) MEM[waddr][3] = data_i[15:8];
        end 2'b11: begin
            if (bw3_i) MEM[waddr][3] = data_i[7:0];
        end
        endcase
    end
end

`ifdef DEUL_PORT
logic [EADDR - 1: 0] bwaddr;  
logic [BADDR - 1: 0] bbaddr; 
assign bwaddr = baddr_i [XLEN - 1: BADDR];
assign bbaddr = baddr_i [BADDR - 1: 0];

always_ff @(posedge clk_i) begin
    if (brd_i) bdata_o = MEM[bwaddr];
    if (bgwe_i) MEM[bwaddr] = bdata_i;
    else begin
        case (bbaddr)
        2'b00: begin        //half and byte writes
            if (bbw0_i) MEM[bwaddr][0] = bdata_i[7:0];
            if (bbw1_i) MEM[bwaddr][1] = bdata_i[15:8];
        end 2'b01: begin   //byte write only
            if (bbw1_i) MEM[bwaddr][1] = bdata_i[7:0];
        end 2'b10: begin   //half and byte writes
            if (bbw2_i) MEM[bwaddr][2] = bdata_i[7:0];     
            if (bbw3_i) MEM[bwaddr][3] = bdata_i[15:8];
        end 2'b11: begin
            if (bbw3_i) MEM[bwaddr][3] = bdata_i[7:0];
        end
        endcase
    end
end
`endif
endmodule
