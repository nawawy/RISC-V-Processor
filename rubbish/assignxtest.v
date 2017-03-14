module test(
    input x,
    input clk,
    output reg [3 : 0] y
);

    always @(posedge clk)
        case(x)
        1'b1:
            y = 2;
        default:
            y = 4'b1111;
        endcase
endmodule