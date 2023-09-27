module CarryLookaheadAdder (
    input  	wire	[3:0]	  	a,
    input 	wire	[3:0]  		b,
	input 	wire				cin,
    output 	wire 	[3:0] 		sum,
	output	wire				Gm,
	output 	wire				Pm
);
	wire	[3:0]	c;
	wire	[3:0]	G = a & b;
	wire	[3:0]	P = a ^ b;
	assign c[0] = cin;
	assign sum = P ^ c;

	assign c[1] = G[0] | (P[0] & c[0]);
	assign c[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c[0]);
	assign c[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & c[0]);
	assign Gm = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
	assign Pm = P[3] & P[2] & P[1] & P[0];

endmodule

module adder16(
	input	wire	[15:0]		a,
	input	wire	[15:0]		b,
	input	wire				cin,
	output	wire	[15:0]		sum,
	output	wire				carry
);
	wire	[3:0]	G;
	wire	[3:0]	P;
	wire	[3:0]	c;
	assign c[0] = cin;
    assign c[1] = G[0] | (P[0] & c[0]);
    assign c[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c[0]);
    assign c[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & c[0]);
    assign carry = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & c[0]);
	CarryLookaheadAdder adder0(a[3:0], b[3:0], c[0], sum[3:0], G[0], P[0]);
	CarryLookaheadAdder adder1(a[7:4], b[7:4], c[1], sum[7:4], G[1], P[1]);
	CarryLookaheadAdder adder2(a[11:8], b[11:8], c[2], sum[11:8], G[2], P[2]);
	CarryLookaheadAdder adder3(a[15:12], b[15:12], c[3], sum[15:12], G[3], P[3]);

endmodule

module Add(
	input	wire	[31:0]		a,
	input	wire	[31:0]		b,
	output	reg		[31:0]		sum,
	output	wire				carry
);
	wire	[31:0]	res;
	wire			c;
	adder16 adder0(a[15:0], b[15:0], 1'b0, res[15:0], c);
	adder16 adder1(a[31:16], b[31:16], c, res[31:16], carry);
	always @(*) begin
		sum <= res;
	end

endmodule