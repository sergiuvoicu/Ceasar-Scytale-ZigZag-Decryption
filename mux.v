`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:53:30 11/26/2020 
// Design Name: 
// Module Name:    mux 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mux #(
		parameter D_WIDTH = 8
	)(
		// Clock and reset interface
		input clk,
		input rst_n,
		
		//Select interface
		input[15:0] select,
		
		// Output interface
		output reg[D_WIDTH - 1 : 0] data_o,
		output reg						 valid_o,
				
		//output interfaces
		input [D_WIDTH - 1 : 0] 	data0_i,
		input   							valid0_i,
		
		input [D_WIDTH - 1 : 0] 	data1_i,
		input   							valid1_i,
		
		input [D_WIDTH - 1 : 0] 	data2_i,
		input     						valid2_i
    );
	
	//TODO: Implement MUX logic here

	always @(posedge clk, negedge rst_n) begin
		// initializarea iesirilor
		if(!rst_n) begin
			data_o <= 0;
			valid_o <= 0;

		end
		else begin
			// rutarea intrarilor catre iesire in functie de select
			case(select)
				'h00:begin
					data_o <= data0_i;
					if(data0_i != 'h00)
						valid_o <= 1;
						
					// resetarea semnalelor
					if(data0_i == 'h00 && valid_o) begin 
						valid_o <= 0;
						data_o <= 0;
					end
				end
				'h01:begin
					data_o <= data1_i;
					if(data1_i != 'h00)
						valid_o <= 1;
					
					if(data1_i == 'h00 && valid_o) begin
						valid_o <= 0;
						data_o <= 0;
					end
				end
				'h02:begin
					data_o <= data2_i;
					if(data2_i != 'h00)
						valid_o <= 1;
					
					
					if(data2_i == 'h00 && valid_o) begin
						valid_o <= 0;
						data_o <= 0;
					end
				end
			endcase
			
		end
	end

endmodule
