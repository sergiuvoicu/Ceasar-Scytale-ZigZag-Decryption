`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:33:04 11/23/2020 
// Design Name: 
// Module Name:    zigzag_decryption 
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
module zigzag_decryption #(
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
			input[KEY_WIDTH - 1 : 0] key,
			
			// Output interface
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o,
			output reg busy
    );

// TODO: Implement ZigZag Decryption here
			reg [D_WIDTH-1:0] string [0:MAX_NOF_CHARS-1]; // vector de 50 de caractere a cate 8 biti fiecare
			reg [5:0] i,j; // registri de populare si accesare a vectorului
			reg flag, is_special; // registri pentru semnalarea resetarii semnalelor si a cazului special
			reg [4:0] div, div3; // registri pentru retinerea numarului de elemente de pe prima si a doua linie ( in cazul a 3 linii)
			
			always @(posedge clk, negedge rst_n) begin
				
				// initializarea semnalelor
				if(!rst_n) begin
				
					busy <= 0;
					valid_o <= 0;
					data_o <= 0;	
					i <= 0;
					j <= 0;
					flag <= 0;
					div <= 0;
					div3 <= 0;
					is_special <= 0;
				
				end
				
				else begin
				
					if(valid_i && !busy) begin
					// popularea stringului cu caracterele primite
						string[i] <= data_i;
						i <= i+1;
						
					// numarul de elemente de pe a doua linie
						div <= i>>1;
						
					// numarul de elemente de pe prima linie
						div3 <= (i-div)>>1;
					
					// daca incriptarea e pe 2 linii, iar nr de elemente este impar, numarul de elemente de pe prima linie se incrementeaza cu 1
						if(key == 2 && i[0] == 1)begin
							div <= div + 1;
						end	
						
					end
					
						if(data_i == START_DECRYPTION_TOKEN) begin
							busy <= 1;
							
						// daca pe linia 1 este cu un caracter mai mult, is_special devine 1
							if(i-div-1-2*div3 == 1 && key == 3) begin
										is_special <= 1;
							end
							
						// daca numarul de caractere este impar, numarul de caractere de pe prima linie se incrementeaza
							if(i-div-1-2*div3 == 0 && key == 3 && i[0] == 1) begin
								is_special <= 1;
								div3 <= div3 + 1;
							end
						end
						
					
						if(busy) begin
						
							valid_o <= 1;
							
							case(key)
									// cazul de 2 linii 
									'h02: begin

											data_o <= string[j];
											
											// daca elementul este pe prima linie, urmatorul este luat de pe a doua linie
											if(j < div) 
												j <= j+div; 
											else
											// daca elementul este pe a doua linie, urmatorul este luat de pe prima
												j <= j+1-div; 
											
											// daca se ajunge la sfarsitul sirului, se reseteaza semnalele 											
											if((j == i-2 && i[0] == 1) || (j+div == i-1 && i[0] == 0)) begin
												flag <= 1;
												i <= 0;
											end

									end
									
									'h03: begin
									
												data_o <= string[j];
												
												// daca elementul se afla pe prima linie, urmatorul va fi luat de pe a doua linie
												if(j < div3)
													j <= 2*j+div3;
													
												// daca elementul se afla pe ultima linie, urmatorul va fi luat de pe a doua linie
												else if(j > div+div3-1 && j < i-1) begin
												
												// verificare caz special
													if(!is_special) begin
													
													// este ales elementul corespunzator de pe a doua linie, in functie de paritate
															if(div[0] == 0)
																j <= j-(i-j+div3-2);
															else 
																j <= j-(i-j+div3-2)+1;
													end
													
													else begin
													// daca este caz special, se alege elementul corespunzator de pe a doua linie, in functie de paritate
															if(div[0] == 1)
																j <= j-(i-j+div3-2);
															else 
																j <= j-(i-j+div3-2)+1;
													end
												end
												
												// daca elementul este pe a doua linie
												else begin
												
												// daca numarul de elemente de pe prima linie este par
													if(div3[0] == 0) begin
														// se alege pozitia de pe linia trei
														if(j[0] == 0)
															j <= j+div-((j-div3)>>1);
														// se lege pozitia de pe linia unu
														else j <= ((j-div3)>>1)+1;
													end
													
													else begin
														// se alege pozitia de pe linia trei
														if(j[0] == 1)
															j <= j+div-((j-div3)>>1);
														// se alege pozitia de pe linia unu
														else j <= ((j-div3)>>1)+1;
													end
													
												end
												
												// conditie de oprire daca nu e un caz special 
												if(!is_special && ((j == i-2 && i[0] == 0) || (j+div3+1 == i-1 && i[0] == 1))) begin
													flag <= 1;
													i <= 0;
												end
												// conditie de oprire pentru caz special
												else if(is_special && ((j == div3+div-1 && i[0] == 1) || (j == div3-1 && i[0] == 0)))begin
													flag <= 1;
													i <= 0;
												end
									end
							endcase
							// resetarea semnalelor
											if(flag) begin
											
												data_o <= 'h00;
												j <= 0;
												valid_o <= 0;
												busy <= 0;
												flag <= 0;
												div <= 0;
												div3 <= 0;
												is_special<=0;
						
											end		
						end		
				end
			end
endmodule
