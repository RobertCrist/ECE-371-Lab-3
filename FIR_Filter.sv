module FIR_Filter #(parameter SIZE)(dataIn, en, reset, clk, dataOut);
	input logic reset, clk;
	input logic en;
	input logic [23:0] dataIn;
	
	output logic [23:0] dataOut;
	
	parameter n = $clog2(SIZE);
	
	logic [23:0] divIn, fifoOut, negFifoOut, divInFifoSum, accumulator;
	
	assign divIn =  {{n{dataIn[24-1]}}, dataIn[24-1:n]};

	fifo #(.DATA_WIDTH(24), .ADDR_WIDTH(n)) BUFFER(.clk, .reset, .rd(en), .wr(en), .empty(), .full(), .w_data(divIn), .r_data(fifoOut));
	
	assign negFifoOut = ~fifoOut + 1'b1;
	assign divInFifoSum = negFifoOut + divIn;
	
	always_ff @(posedge clk)
		if(reset)
			accumulator <= 0;
		else if(en)
			accumulator <= accumulator + divInFifoSum;
		
	assign dataOut = accumulator;
endmodule

module FIR_Filter_testbench();
	logic reset, clk;
	logic en;
	logic [23:0] dataIn;
	
	logic [23:0] dataOut;
	
	FIR_Filter #(.SIZE(4)) dut(.*);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	integer i;
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		for(i = 0; i < 10; i++)begin 
			dataIn <= 4*i; @(posedge clk);
			en <= 1; @(posedge clk);
			en <= 0; @(posedge clk);
		end
		
		@(posedge clk);
		
		$stop;
	end
endmodule