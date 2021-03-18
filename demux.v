`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:12:00 11/23/2020 
// Design Name: 
// Module Name:    demux 
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

module demux #(
		parameter MST_DWIDTH = 32,
		parameter SYS_DWIDTH = 8
	)(
		// Clock and reset interface
		input clk_sys,
		input clk_mst,
		input rst_n,
		
		//Select interface
		input[15:0] select,
		
		// Input interface
		input [MST_DWIDTH -1  : 0]	 data_i,
		input 						 	 valid_i,
		
		//output interfaces
		output reg [SYS_DWIDTH - 1 : 0] 	data0_o,
		output reg     						valid0_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data1_o,
		output reg     						valid1_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data2_o,
		output reg     						valid2_o
    );
		reg [SYS_DWIDTH+1:0] i,j;
		reg [0:(MST_DWIDTH*SYS_DWIDTH*2)-1] data;
		
	// TODO: Implement DEMUX logic
	always @( negedge rst_n, posedge clk_sys) begin
	
		// initializarea registrilor si iesirilor
		if(!rst_n) begin
			data0_o <= 0;
			valid0_o <= 0;
			data1_o <= 0;
			valid1_o <= 0;
			data2_o <= 0;
			valid2_o <= 0;
			data <= 0;
			i <= 0;
			j <= 0;
		end
		else if(clk_sys) begin
			
			if(valid_i) begin
			// popularea registrului cu date pe 32 de biti cand se ajunge pe clk_mst, adica la 4 cicli clk_sys
				if(i-(4*(i>>2)) == 0)
					data[(i>>2)*MST_DWIDTH +: MST_DWIDTH] <= data_i;
				i <= i+1;
			end
			// daca s-a produs popularea registrului cu cel putin o intrare, se incepe citirea
			if( i>2 ) begin
					// rutarea iesirii in functie de cheie		
					case(select)
						'h00:begin			
							valid0_o <= 1;
							// atribuirea pe iesire caracter cu caracter a datelor din registru
							data0_o <= data[j*SYS_DWIDTH +: SYS_DWIDTH];
							j <= j+1;
							
							// resetarea registrilor si iesirilor
							if(j == i && i != 0) begin
								valid0_o <= 0;
								data0_o <=0;
								i <= 0;
								j <= 0;
								data <= 0;
							end
					
						end
						'h01:begin
						
							valid1_o <= 1;
							data1_o <= data[j*SYS_DWIDTH +: SYS_DWIDTH];
							j <= j+1;
							
							if(j == i && i != 0) begin
								valid1_o <= 0;
								i <= 0;
								j <= 0;
								data1_o <=0;
								data <= 0;
							end
						end
						'h02:begin
						
							valid2_o <= 1;
							data2_o <= data[j*SYS_DWIDTH +: SYS_DWIDTH];
							j <= j+1;
							
							if(j == i && i != 0) begin
								valid2_o <= 0;
								i <= 0;
								j <= 0;
								data2_o <=0;
								data<= 0;
							end
						end
					endcase
			end
		end
	end

endmodule
