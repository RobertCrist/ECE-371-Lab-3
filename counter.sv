`timescale 1 ps / 1 ps

module counter #(parameter WIDTH = 4, TOP = 2**WIDTH)(incr, reset, clk, out);
	input logic incr, reset, clk;
	output logic [WIDTH - 1: 0] out;
	
	always_ff @(posedge clk) begin
		if(reset)
			out <= 0;
		else if(out == (TOP))
			out <= 0;
		else if(incr && (out != TOP))
			out <= out + 1;
		else
			out <= out;
	end
endmodule

module counter_testbench();
	logic reset, clk;
	logic incr;
	
	logic[3:0] out;
	
	counter #(.WIDTH(4), .TOP(7)) dut(.incr, .reset, .clk, .out);
	
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