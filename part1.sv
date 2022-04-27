`timescale 1 ps / 1 ps
/* Top-Level module for testing different audio outputs
*	Ports:
*		KEY: Input for control of the KEYs on the DE1_SoC (4-bit)
*		SW: Input for switch control (10-bit)
*		CLOCK_50: 50Mhz clock (1-bit)
*		FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, 
*		AUD_BCLK, AUD_ADCDAT, AUD_DACDAT: Audio Codec ports
 */
module part1 (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	input [9:0]SW;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	
	
	/*
	*********************************
	PART 1
	*********************************
	*/

//	Wire assignments for connecting audio codec to our implementation
//	assign writedata_left = readdata_left;
//	assign writedata_right = readdata_right;
//	assign read = write;
//	assign write = read_ready & write_ready;

	/*
	*********************************
	PART 2
	*********************************
	*/
//	
//	wire [15:0] counterOut;
//	
//	wire [23:0] tone;
//	
//	Counter to count up to 48000
//	Output of counter is the address input of our Memory module
//	counter #(.WIDTH(16)) UPCOUNTER(.incr(write), .reset(reset), .clk(CLOCK_50), .out(counterOut));  
//
//	Memory module to contain the values from our tone file
//	tonemem TONEMEMORY(.address(counterOut), .clock(CLOCK_50), .data(), .wren(1'b0), .q(tone));
//	
//	RTL mux to switch between using the generated tone and audio file
//	assign writedata_left = SW[9] ? tone:readdata_left;
//	assign writedata_right = SW[9] ? tone:readdata_right;

//	Audio codec wire ports
//	assign read = write;
//	assign write = read_ready & write_ready;
	
	/*
	*********************************
	PART 3
	*********************************
	*/
	
//	Filter wires
	wire[23:0] filteredLeft, filteredRight, leftData, rightData;
	
//	Counter Wire
	wire [15:0] counterOut;
	
//	tone wire
	wire [23:0] tone;
	
	wire SW9C1, SW9C2, SW8C1, SW8C2, KEY0C1, KEY0C2;
	
//	Switch assignment to control audio outputs	
	always_ff @(posedge CLOCK_50) begin
		SW9C1 <= SW[9];
		SW9C2 <= SW9C1;
		
		SW8C1 <= SW[8];
		SW8C2 <= SW8C1;
		
		KEY0C1 <= ~KEY[0];
		KEY0C2 <= KEY0C1;
	end

//	reset key 	
	assign reset = KEY0C2;

//	Counter to count up to 48000
//	Output of counter is the address input of our Memory module
	counter #(.WIDTH(16)) UPCOUNTER(.incr(write), .reset(reset), .clk(CLOCK_50), .out(counterOut));  

//	Memory module to contain the values from our tone file	
	tonemem TONEMEMORY(.address(counterOut), .clock(CLOCK_50), .data(), .wren(1'b0), .q(tone));

//	RTL mux to pick between tone or filtered/unfiltered audio file	
	assign leftData = SW9C2 ? tone:readdata_left;
	assign rightData = SW9C2 ? tone:readdata_right;
	
//	Sending audio output to filter
//	Left and Right channels seperatley
	FIR_Filter #(.SIZE(16)) leftFilter(.dataIn(leftData), .en(read_ready & write_ready), .reset(reset), .clk(CLOCK_50), .dataOut(filteredLeft));
	FIR_Filter #(.SIZE(16)) rightFilter(.dataIn(rightData), .en(read_ready & write_ready), .reset(reset), .clk(CLOCK_50), .dataOut(filteredRight));
	
//	RTL mux to switch between using the generated tone and audio file
	assign writedata_left = SW8C2 ? filteredLeft:leftData;
	assign writedata_right = SW8C2 ? filteredRight:rightData;

//	Audio codec wires
	assign read = write;
	assign write = read_ready & write_ready;
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


