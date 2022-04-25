module FIR_Filter #(parameter N)(dataIn, en, reset, clk, dataOut);
	input logic reset, clk;
	input logic en;
	input logic [23:0] dataIn;
	
	output logic [23:0] dataOut;

	logic [23:0] divIn, fifoOut, negFifoOut, divInFifoSum, accumulator;
	
	assign divIn = {{N{dataIn[24-1], dataIn[23:N]}}};

	fifo #(.DATA_WIDTH(24), .ADDR_WIDTH(N)) BUFFER(.clk, .reset, .rd(en), .wr(en), .empty(), .full(), .w_data(divIn), .r_data(fifoOut));
	
	assign negFifoOut = ~fifoOut + 1'b1;
	assign divInFifoSum = negFifoOut + divIn;
	
	always_ff @(posedge clk)
		if(reset)
			accumulator <= 0;
		else if(en)
			accumulator <= accumulator + divInFifoSum;
		
	assign dataOut = accumulator;
endmodule
