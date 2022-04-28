/*
	*NOTE* This module is not used but was used to test the accumulator
	
	This module stores a 24 bit value and adds dataIn to the stored value anytime en is high on a posedge of clk
	Ports:	
		dataIn: 	The data you would like to add to the accumulator
		en:		Enabling the value to be added
		dataOut:	dataIn + the value stored in the accumulator
		clk: 		The clock used for timing
		reset:	A signal to reset the system
*/

module accumulator(dataIn, en, dataOut, clk, reset);
	//Input wires
	input logic en, clk, reset;
	input logic [23:0] dataIn;
	
	//Output wire
	output logic [23:0] dataOut;
	
	//The data that is stored
	logic [23:0] accumulator;
	
	//Flipflops to store the data
	always_ff @(posedge clk)
		if(reset)
			accumulator <= 0;
		else if(en)
			accumulator <= accumulator + dataIn;
		
	assign dataOut = accumulator + dataIn;
endmodule //accumulator

module accumulator_testbench();
	logic clk, en, reset;
	logic [23:0] dataIn;

	logic [23:0] dataOut;
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	accumulator dut(.*);
	
	initial begin
		reset <= 1;	en <= 0; dataIn <= 24'd0;	@(posedge clk);
		reset <= 0;  									@(posedge clk);
		en <= 1; dataIn <= 24'd10;					@(posedge clk);
		repeat(2)										@(posedge clk);
		dataIn <= 24'd1;								@(posedge clk);
		en <= 0; 										@(posedge clk);
		repeat(3)										@(posedge clk);
		$stop;
	end //initial
	
endmodule //accumulator_testbench
