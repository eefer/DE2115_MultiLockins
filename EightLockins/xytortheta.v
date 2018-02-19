// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module xytortheta (
	// define ports here
	aclr,
	clk,
	ena,
	clk_sig_in,
	x,
	y,
	//r,
	//r_remainder,
	//xsqPlusYsq,
	//xsquared,
	//ysquared,
	//theta,
	r_out,
	theta_out);

	// input/outputs and wires defined here
	input	  aclr;
	input	  clk;
	input	  ena;
	input	  clk_sig_in;
	input	signed [15:0]  x;	// lock-in x
	input signed [15:0] y;	// lock-in y
	//output	[15:0]  r;	// lock-in magnitude (radius)
	//output	[15:0]  r_remainder;
	//output	[32:0]  xsqPlusYsq;
	//output	[31:0]  xsquared;
	//output	[31:0]  ysquared;
	//output signed	[10:0]  theta;
	//output reg	[15:0]  r_out;
	output	[15:0]  r_out;
	reg	[15:0]  r_out;
	//output reg signed	[10:0]  theta_out;
	output signed	[10:0]  theta_out;
	reg signed	[10:0]  theta_out;
	
	//  define wires
	wire signed [10:0] theta;
	wire [15:0] sub_wire0;
	wire [15:0] sub_wire1;
	wire [15:0] remainder = sub_wire0[15:0];
	wire [15:0] r = sub_wire1[15:0];
	reg signed [31:0] xsquared;
	reg signed [31:0] ysquared;
	reg signed [32:0] xsqPlusYsq;

	
	// calculate x^2 + y^2
	always @(posedge clk ) 
	begin
		xsquared <= x * x;
		ysquared <= y * y;
		xsqPlusYsq <= xsquared + ysquared;
	end
		
	// calculate square root
	
	altsqrt	altsqrt_component (
				.radical (xsqPlusYsq),
				.ena (ena),
				.aclr (aclr),
				.clk (clk),
				.remainder (sub_wire0),
				.q (sub_wire1));
				
	always @(posedge clk_sig_in)
	begin
		r_out <= r;
		theta_out <= theta;
	end
	
	defparam
		altsqrt_component.pipeline = 2,
		altsqrt_component.q_port_width = 16, // quotient (output)
		altsqrt_component.r_port_width = 16, // remainder (output)
		altsqrt_component.width = 33;         // radical (input)
		
	atan atan_component(
		.areset( aclr ), // areset.reset
		.clk( clk ),    //    clk.clk
		.q(theta),      //      q.q
		.x(x),      //      x.x
		.y(y)       //      y.y
	);

		
endmodule 