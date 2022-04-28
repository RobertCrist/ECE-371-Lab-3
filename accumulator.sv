module accumulator(dataIn, en, dataOut, clk, reset);
	input logic en, clk, reset;
	input logic [23:0] dataIn;

	output logic [23:0] dataOut;
	
	logic [23:0] accumulator;
	
	
	always_ff @(posedge clk)
		if(reset)
			accumulator <= 0;
		else if(en)
			accumulator <= accumulator + dataIn;
		
	assign dataOut = accumulator + dataIn;
endmodule

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
	end
endmodule
