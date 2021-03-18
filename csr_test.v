`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:22:06 12/08/2020
// Design Name:   ceasar_decryption
// Module Name:   C:/Users/sergi/Desktop/tema2/csr_test.v
// Project Name:  decryption_skel
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ceasar_decryption
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module csr_test;

	// Inputs
	reg clk;
	reg rst_n;
	reg [7:0] data_i;
	reg valid_i;
	reg [15:0] key;

	// Outputs
	wire [7:0] data_o;
	wire valid_o;

	// Instantiate the Unit Under Test (UUT)
	ceasar_decryption uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.data_i(data_i), 
		.valid_i(valid_i), 
		.key(key), 
		.data_o(data_o), 
		.valid_o(valid_o)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		data_i = 0;
		valid_i = 0;
		key = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

