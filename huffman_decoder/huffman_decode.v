/*
*****************
H-code | S-code |
*****************
2'b01  | 3'b000 |
2'b11  | 3'b001 |
3'b001 | 3'b010 |
3'b010 | 3'b011 |
3'b011 | 3'b100 |
4'b0000| 3'b101 |
4'b0001| 3'b110 |
*****************
*/
`define VAL_STATE \
    next_state = STATE0; \
    valid = 1;

`define INVAL_STATE \
    valid = 0; \
    status_out = 3'b111;

`define NEXT_STATE(s_if_1, s_if_0) \
    if (serial_in) next_state = s_if_1; \
    else next_state = s_if_1;

module huffman_decode(
    input wire clk, nrst,
    input wire serial_in,

    output reg [2:0] status_out,
    output reg valid
);

localparam [2:0] 
    STATE0 = 3'h0,
    STATE1 = 3'h1,
    STATE2 = 3'h2,
    STATE3 = 3'h3,
    STATE4 = 3'h4,
    STATE5 = 3'h5;

reg [2:0] current_state;
reg [2:0] next_state;

always @(posedge clk, negedge nrst) begin
    if(!nrst) current_state = STATE0;
    else current_state = next_state;
end

always @(serial_in, current_state) begin
    case (current_state)
        STATE0: begin
            `INVAL_STATE

            if (serial_in) next_state = STATE1;
            else next_state = STATE2;

        end STATE1: begin
            `VAL_STATE

            if (serial_in) status_out = 3'b1;
            else status_out = 3'b0;
            
        end STATE2: begin
            `INVAL_STATE

            if (serial_in) next_state = STATE3;
            else next_state = STATE4;

        end STATE3: begin
            `VAL_STATE

            if (serial_in) status_out = 3'b100;
            else status_out = 3'b011;

        end STATE4: begin
            if (serial_in) begin
                `VAL_STATE
                status_out = 3'b010;
            end else begin
                `INVAL_STATE
                next_state = STATE5;
            end

        end STATE5: begin
            `VAL_STATE

            if (serial_in) status_out = 3'b110;
            else status_out = 3'b101;
        end default: begin
            `INVAL_STATE
            next_state = STATE0;
        end
    endcase
end
endmodule
