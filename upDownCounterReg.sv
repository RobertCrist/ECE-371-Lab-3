/*
*	upDownCounterReg Keeps track of how many cars are present in the parking lot. Max of 16. 
				Can add or subtract cars based on incr and decr signals.
*	Ports:
*		incr, decr: if true will either +1 or -1 the current value respectively. [1-bit]
*		reset: Will reset current count back to 0 [1-bit]
*		clk: System clock for muxes and registers [1-bit]
*		out: Will return the current amount of cars present in the parking lot [5-bit]
*/
`timescale 1 ps / 1 ps
module upDownCounterReg(incr, reset, clk, out);
	input logic reset, clk;
	input logic incr;
	
	output logic[4:0] out;
	
	logic[4:0] sum;
	
	
	//5-bit register to hold the current value of the counter. Will only change if incr or decr are true
	//You cannot decrement lower than 0 or increment higher than 1
	registerNb register5b_0(.out, .data(sum), .enable(incr), .reset, .clk);
	
	//5-bit fulladder that will add two 5-bit values together
	fullAdder_NBit fullAdder_5Bit_0(.a(5'b00001), .b(out), .sum);
	
endmodule //unDownCounterReg

module upDownCounterReg_testbench();
	logic reset, clk;
	logic incr;
	
	logic[4:0] out;
	
	upDownCounterReg dut(.incr, .reset, .clk, .out);
	
	//Setting up the clock
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	integer i;
	initial begin
		reset <= 1;	@(posedge clk);
		reset <= 0; incr <= 0; @(posedge clk);
		repeat(2) 	@(posedge clk);
		
		for(int i = 0; i < 32; i++)begin
			//Increment to 16 and check that it doesnt go over
			incr <= 1; 	@(posedge clk);
			incr <= 0; 	@(posedge clk);
		end
		$stop;
	end //initial
	
endmodule //upDownCounterReg_testbench
		