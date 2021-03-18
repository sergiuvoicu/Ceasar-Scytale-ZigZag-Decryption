`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:49 11/23/2020 
// Design Name: 
// Module Name:    decryption_regfile 
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
module decryption_regfile #(
			parameter addr_witdth = 8,
			parameter reg_width 	 = 16
		)(
			// Clock and reset interface
			input clk, 
			input rst_n,
			
			// Register access interface
			input[addr_witdth - 1:0] addr,
			input read,
			input write,
			input [reg_width -1 : 0] wdata,
			output reg [reg_width -1 : 0] rdata,
			output reg done,
			output reg error,
			
			// Output wires
			output reg[reg_width - 1 : 0] select,
			output reg[reg_width - 1 : 0] caesar_key,
			output reg[reg_width - 1 : 0] scytale_key,
			output reg[reg_width - 1 : 0] zigzag_key
    );
	 
	// TODO implementati bancul de registre.
	
		reg [reg_width - 1: 0] select_register;
		reg [reg_width - 1: 0] caesar_key_register;
		reg [reg_width - 1: 0] scytale_key_register;
		reg [reg_width - 1: 0] zigzag_key_register;
		
		// flag scriere
		reg wtb;
		// flag citire
		reg rdb;
		// flag eroare
		reg err;
		
		always @(posedge clk, negedge rst_n) begin
		   
			// valorile de reset specifice fiecarui registru
			if(!rst_n) begin
				select_register <= 16'h0;
				caesar_key_register <= 16'h0;
				scytale_key_register <= 16'hFFFF;
				zigzag_key_register <= 16'h02;
			end 
			
			else begin
			
			// daca in ciclul de ceas precedent s-a produs o scriere sau o citire 
			// pe ciclul de ceas curent, flag-urile de verificare a functionalitatii se reseteaza,
			//	iar done este 1
				if(wtb || rdb) begin
					done <= 1;
					wtb <= 0;
					rdb <= 0;
				end
				
			// daca s-a incercat accesarea unui registru inexistent pe ciclul de ceas precedent,
			// done este 1 si eroarea este 1 pe ciclul de ceas curent, altfel sunt 0		
				else if(err) begin
					done <= 1;
					error <= 1;
					err <= 0;
				end
				else begin 
					error <= 0;
					done <= 0;
				end
		
			// switch in functie de adresa in hexadecimal	
				case(addr)
				
					8'h0: begin
						// scriere pe switch_register
						if(write) begin
							select_register[0] <= wdata[0];
							select_register[1] <= wdata[1];
							wtb <= 1;
						end
						// citire de pe switch register
						else if(read) begin
							rdata <= select_register;
							rdb <= 1;
						end
					end
					
					8'h10: begin
						// scriere pe caesar_register
						if(write) begin	
							caesar_key_register <= wdata;
							wtb <= 1;
						end
						// citire de pe caesar_register
						else if (read) begin
							rdata <= caesar_key_register;
							rdb <= 1;
						end
					end
						
					8'h12: begin
						// scriere pe scytale_register
						if(write) begin
							scytale_key_register <= wdata;
							wtb <= 1;
						end
						// citire de pe scytale_register
						else if (read) begin
							rdata <= scytale_key_register;
							rdb <= 1;
						end
					end
					
					8'h14: begin
						// scriere pe zigzag_register
						if(write) begin
							zigzag_key_register <= wdata;
							wtb <= 1;
						end
						// citire de pe zigzag_register
						else if(read) begin
							rdata <= zigzag_key_register;
							rdb <= 1;
						end
					end
						// orice alta adresa
					default: err <= 1;
	
				endcase
			end
		end
		
		// atribuire asincrona a registrelor catre iesiri
		always @(*) begin
			select = select_register;
			caesar_key = caesar_key_register;
			scytale_key = scytale_key_register;
			zigzag_key = zigzag_key_register;
		end

endmodule
