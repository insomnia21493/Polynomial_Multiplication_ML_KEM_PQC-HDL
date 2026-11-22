module modadd(input [11:0] A,B,
              output[11:0] C);

wire        [12:0] R;
wire signed [13:0] Rq;

assign R = A + B;
assign Rq= R - 13'd3329;

assign C = (Rq[13] == 0) ? Rq[11:0] : R[11:0];

endmodule
