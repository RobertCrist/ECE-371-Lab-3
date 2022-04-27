/* Filter module
*	Ports:
*		dataIn:	Data input from audio file (24-bit)
*		en:		Enable signal (1-bit)
*		reset:	Reset signal (1-bit)
*		clk:	Clock input (1-bit)
*		dataOut:Filtered data output (24-bit)
*/
module FIR_Filter #(parameter SIZE)(dataIn, en, reset, clk, dataOut);
	input logic reset, clk;
	input logic en;
	input logic [23:0] dataIn;
	
	output logic [23:0] dataOut;
	
	logic [23:0] divIn, fifoOut, negFifoOut, divInFifoSum, accumulator;
	
	//N divisor
	parameter n = $clog2(SIZE);

	//RTL for division
	assign divIn =  {{n{dataIn[24-1]}}, dataIn[24-1:n]};

	//Sending data to FIFO buffer
	fifo #(.DATA_WIDTH(24), .ADDR_WIDTH(n)) BUFFER(.clk, .reset, .rd(en), .wr(en), .empty(), .full(), .w_data(divIn), .r_data(fifoOut));
	
	//Negating fifo outpput
	assign negFifoOut = ~fifoOut + 1'b1;
	//Adding negative fifo output with divisor sum
	assign divInFifoSum = negFifoOut + divIn;
	
	//Accumulator, adds upon itself and adds itself to divisor addition output
	always_ff @(posedge clk)
		if(reset)
			accumulator <= 0;
		else if(en)
			accumulator <= accumulator + divInFifoSum;
	//Output of filter	
	assign dataOut = accumulator + divInFifoSum;
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