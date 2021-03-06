`timescale 1 ps / 1 ps
/* Counter module 
*	Ports:
*		WIDTH:	Parameter of how many bits the counter needs to be (WIDTH-bits)
*		incr:	Increment signal to incremenet counter. Controlled by write of codec (1-bit) 
*		reset:	Reset signal to reset counter (1-bit)
*		clk:	Clock input (1-bit)
*		out:	Output of the counter (WIDTH-bits)
*/
module counter #(parameter WIDTH = 4)(incr, reset, clk, out);
	input logic incr, reset, clk;
	output logic [WIDTH - 1: 0] out;

	//Incrementer to count timer
	always_ff @(posedge clk) begin
		if(reset | out == 48000)
			out <= 0;
		else if(incr)
			out <= out + 1;
		else
			out <= out;
	end //always_ff
		
endmodule //counter

module counter_testbench();
	logic reset, clk;
	logic incr;
	logic[3:0] out;
	
	counter #(.WIDTH(4)) dut(.incr, .reset, .clk, .out);
	
	//Setting up the clock
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	integer i;
	initial begin
		reset <= 1;	@(posedge clk);
		reset <= 0; incr <= 0;	@(posedge clk);
		repeat(2) 	@(posedge clk);
		
		for(int i = 0; i < 32; i++)begin
			//Increment to 16 and check that it doesnt go over
			incr <= 1; 	@(posedge clk);
			incr <= 0; 	@(posedge clk);
		end

		$stop;
	end //initial
	
endmodule //counter_testbench