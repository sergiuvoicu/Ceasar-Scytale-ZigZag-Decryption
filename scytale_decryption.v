`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:12 11/27/2020 
// Design Name: 
// Module Name:    scytale_decryption 
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
module scytale_decryption #(
			parameter D_WIDTH = 8, 
			parameter KEY_WIDTH = 8, 
			parameter MAX_NOF_CHARS = 50,
			parameter START_DECRYPTION_TOKEN = 8'hFA
		)(
			// Clock and reset interface
			input clk,
			input rst_n,
			
			// Input interface
			input[D_WIDTH - 1:0] data_i,
			input valid_i,
			
			// Decryption Key
			input[KEY_WIDTH - 1 : 0] key_N,
			input[KEY_WIDTH - 1 : 0] key_M,
			
			// Output interface
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o,
			output reg busy
    );
			reg [D_WIDTH-1:0] string [0:MAX_NOF_CHARS-1]; // vector de 50 de caractere a cate 8 biti fiecare
			reg [5:0] i,j; // registri pentru popularea si accesarea datelor
			reg flag; // registru pentru resetarea semnalelor pe ceasul urmator

// TODO: Implement Scytale Decryption here
			always @(posedge clk, negedge rst_n) begin
			
			// initializarea semnalelor
				if(!rst_n) begin
				
					busy <= 0;
					valid_o <= 0;
					data_o <= 0;	
					i <= 0;
					j <= 0;
					flag <= 0;
					
				end
				
				else begin
				
					// popularea vectorului cu caracterele primite
					if(valid_i && !busy) begin
						string[i] <= data_i;
						i <= i+1;
					end
					
					// daca se ajunge la finalul stringului, adica la caracterul 0xFA, busy devine 1
					if(data_i == START_DECRYPTION_TOKEN) begin
						busy <= 1;
					end
	
					
					if(busy) begin
							
							valid_o <= 1;
							
						// atribuirea caracterului de la pozitia j, iesirii
							data_o <= string[j];
							
						// verificare depasirea numarului de caractere din string
							if(j+key_N > i-2)
							
									// intoarcere la pozitia j+1 fata de ultima pozitie de plecare (initial 0)
									j <= j+key_N+2-i;
									
							else 
									// incrementare cu nr de linii
									j <= j+key_N;
							
							// daca se ajunge la ultimul caracter, se vor reseta semnalele pe ciclul de ceas urmator
							if(j == i-2) begin
								flag <= 1;
								i <= 0;
							end
							
							// resetarea semnalelor
							if(flag) begin
							
								data_o <= 'h00;
								j <= 0;
								valid_o <= 0;
								busy <= 0;
								flag <= 0;
								
							end
							
					end
		
				end
			
			end


endmodule
