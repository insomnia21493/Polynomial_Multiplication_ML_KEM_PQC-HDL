



module devide(input [11:0] A,
              output[11:0] C);

wire signed [12:0] R;
wire signed [12:0] Rq;

wire [12:0] d = 13'd1664 & {13{A[0]}};

assign R = A[11:1] - d;
assign Rq= R + 13'd3329;

assign C = (R[12] == 0) ? R[11:0] : Rq[11:0];

endmodule
