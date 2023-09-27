module adder (
    input 		[31:0]  	a,
    input 		[31:0]  	b,
    output reg 	[31:0] 		sum,
	output reg 		 		carry
);

    integer i;

    always @(*) begin
        carry = 0;
        for (i = 0; i < 32; i = i + 1) begin
            sum[i] = a[i] ^ b[i] ^ carry;
            carry = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry);
        end
    end

endmodule