`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:04:25 12/01/2020
// Design Name:   decryption_regfile
// Module Name:   C:/Users/sergi/Desktop/tema2/dec_tst.v
// Project Name:  decryption_skel
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: decryption_regfile
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dec_tst;

	// Inputs
	reg clk;
	reg rst_n;
	reg [7:0] addr;
	reg read;
	reg write;
	reg [15:0] wdata;

	// Outputs
	wire [15:0] rdata;
	wire done;
	wire error;
	wire [15:0] select;
	wire [15:0] caesar_key;
	wire [15:0] scytale_key;
	wire [15:0] zigzag_key;

	// Instantiate the Unit Under Test (UUT)
	decryption_regfile uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.addr(addr), 
		.read(read), 
		.write(write), 
		.wdata(wdata), 
		.rdata(rdata), 
		.done(done), 
		.error(error), 
		.select(select), 
		.caesar_key(caesar_key), 
		.scytale_key(scytale_key), 
		.zigzag_key(zigzag_key)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		addr = 8'h21;
		read = 0;
		write = 0;
		wdata = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

