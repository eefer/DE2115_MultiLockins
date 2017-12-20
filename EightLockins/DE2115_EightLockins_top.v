//`timescale 20 ns / 0.01 ns
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE2115_EightLockins_top(

	//////////// CLOCK //////////
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,

	//////////// LED //////////
	LEDG,
	LEDR,

	//////////// KEY //////////
	KEY,

	//////////// SW //////////
	SW,

	//////////// SEG7 //////////
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,

	//////////// LCD //////////
	LCD_BLON,
	LCD_DATA,
	LCD_EN,
	LCD_ON,
	LCD_RS,
	LCD_RW,
	
		//////// GPIO //////////
	GPIO,

	//////////// SDCARD //////////
	SD_CLK,
	SD_CMD,
	SD_DAT,
	SD_WP_N,

	//////////// I2C for HSMC  //////////
	I2C_SCLK,
	I2C_SDAT,

	//////////// Flash //////////
	FL_ADDR,
	FL_CE_N,
	FL_DQ,
	FL_OE_N,
	FL_RST_N,
	FL_RY,
	FL_WE_N,
	FL_WP_N,
	
	//////////// SRAM //////////
	SRAM_ADDR,
	SRAM_CE_N,
	SRAM_DQ,
	SRAM_LB_N,
	SRAM_OE_N,
	SRAM_UB_N,
	SRAM_WE_N,
	
		// Ethernet 0
//  ENET0_MDC,
//  ENET0_MDIO,
//  ENET0_RESET_N,
//	
//	// Ethernet 1
//  ENET1_GTX_CLK,
//  ENET1_MDC,
//  ENET1_MDIO,
//  ENET1_RESET_N,
//  ENET1_RX_CLK,
//  ENET1_RX_DATA,
//  ENET1_RX_DV,
//  ENET1_TX_DATA,
//   ENET1_TX_EN,

	//////////// HSMC, HSMC connect to DCC - High Speed ADC/DAC //////////
	AD_SCLK,
	AD_SDIO,
	ADA_D,
	ADA_DCO,
	ADA_OE,
	ADA_OR,
	ADA_SPI_CS,
	ADB_D,
	ADB_DCO,
	ADB_OE,
	ADB_OR,
	ADB_SPI_CS,
	AIC_BCLK,
	AIC_DIN,
	AIC_DOUT,
	AIC_LRCIN,
	AIC_LRCOUT,
	AIC_SPI_CS,
	AIC_XCLK,
	CLKIN1,
	CLKOUT0,
	DA,
	DB,
	FPGA_CLK_A_N,
	FPGA_CLK_A_P,
	FPGA_CLK_B_N,
	FPGA_CLK_B_P,
	J1_152,
	XT_IN_N,
	XT_IN_P
//	NCO_OUT,
// clk_1khz,
//	ast_source_data,
//	ast_source_valid,
//	ast_source_error,
//	DFF_ast_source_data,
//	CLOCK_20,
//	test_out_data,
//	adaptive_out_data,
//	error_adaptive_out,
//	emu
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_50;
input 		          		CLOCK2_50;
input 		          		CLOCK3_50;

//////////// LED //////////
output		     [8:0]		LEDG;
output		    [17:0]		LEDR;

//////////// KEY //////////
input 		     [3:0]		KEY;

//////////// SW //////////
input 		    [17:0]		SW;

//////////// SEG7 //////////
output		     [6:0]		HEX0;
output		     [6:0]		HEX1;
output		     [6:0]		HEX2;
output		     [6:0]		HEX3;
output		     [6:0]		HEX4;
output		     [6:0]		HEX5;
output		     [6:0]		HEX6;
output		     [6:0]		HEX7;

//////////// LCD //////////
output		          		LCD_BLON;
inout 		     [7:0]		LCD_DATA;
output		          		LCD_EN;
output		          		LCD_ON;
output		          		LCD_RS;
output		          		LCD_RW;

//////////// SDCARD //////////
output		          		SD_CLK;
inout 		          		SD_CMD;
inout 		     [3:0]		SD_DAT;
input 		          		SD_WP_N;

//////////// GPIO //////////
inout		        [35:0]		GPIO;

//////////// SRAM //////////
output		    [19:0]		SRAM_ADDR;
output		          		SRAM_CE_N;
inout 		    [15:0]		SRAM_DQ;
output		          		SRAM_LB_N;
output		          		SRAM_OE_N;
output		          		SRAM_UB_N;
output		          		SRAM_WE_N;

//////////// I2C for HSMC  //////////
output		          		I2C_SCLK;
inout 		          		I2C_SDAT;

//////////// Flash //////////
output		    [22:0]		FL_ADDR;
output		          		FL_CE_N;
inout 		     [7:0]		FL_DQ;
output		          		FL_OE_N;
output		          		FL_RST_N;
input 		          		FL_RY;
output		          		FL_WE_N;
output		          		FL_WP_N;

//////////// HSMC, HSMC connect to DCC - High Speed ADC/DAC //////////
inout 		          		AD_SCLK;
inout 		          		AD_SDIO;
input 		    [13:0]		ADA_D;
input 		          		ADA_DCO;
output		          		ADA_OE;
input 		          		ADA_OR;
output		          		ADA_SPI_CS;
input 		    [13:0]		ADB_D;
input 		          		ADB_DCO;
output		          		ADB_OE;
input 		          		ADB_OR;
output		          		ADB_SPI_CS;
inout 		          		AIC_BCLK;
output		          		AIC_DIN;
input 		          		AIC_DOUT;
inout 		          		AIC_LRCIN;
inout 		          		AIC_LRCOUT;
output		          		AIC_SPI_CS;
output		          		AIC_XCLK;
input 		          		CLKIN1;
output		          		CLKOUT0;
output		    [13:0]		DA;
output		    [13:0]		DB;
inout 		          		FPGA_CLK_A_N;
inout 		          		FPGA_CLK_A_P;
inout 		          		FPGA_CLK_B_N;
inout 		          		FPGA_CLK_B_P;
inout 		          		J1_152;
input 		          		XT_IN_N;
input 		          		XT_IN_P;

		// Ethernet 0
//output        ENET0_MDC;
//inout         ENET0_MDIO;
//output        ENET0_RESET_N;
//	
//	// Ethernet 1
//output        ENET1_GTX_CLK;
//output        ENET1_MDC;
//inout         ENET1_MDIO;
//output        ENET1_RESET_N;
//input         ENET1_RX_CLK;
//input  [3: 0] ENET1_RX_DATA;
//input         ENET1_RX_DV;
//output [3: 0] ENET1_TX_DATA;
//output        ENET1_TX_EN;


//=======================================================
//  REG/WIRE declarations
//=======================================================

wire					reset_n;
wire					sys_clk;
reg		[13:0]	per_a2da_d;
reg		[13:0]	a2da_data;
//reg			[13:0]	per_a2db_d;
//reg			[13:0]	a2db_data;
reg 		[13:0]  dac_out_a;
reg		[13:0]  dac_out_b; 
reg 		[13:0]  dac_out_a_unsigned;
reg		[13:0]  dac_out_b_unsigned;

	
reg l_CLOCK_50;
reg ll_CLOCK_50;
reg lll_CLOCK_50;
reg [1:0] temp_counter = 2'd0;




//=======================================================
//  Structural coding
//=======================================================

//--- global signal assign
assign	reset_n			= KEY[3];
assign   sys_clk = CLOCK_50;
assign	FPGA_CLK_A_P	=  ~CLOCK_50;
assign	FPGA_CLK_A_N	=  CLOCK_50;
assign	FPGA_CLK_B_P	=  ~CLOCK_50;
assign	FPGA_CLK_B_N	=  CLOCK_50;

assign	LEDG[1]			=	1'b0;
assign	LEDG[2]			=	1'b0;
assign	LEDG[3]			=  ADA_OR;
assign	LEDG[4]			=  ADB_OR;

assign 	LEDG[8:5]		=  4'b0;
assign 	LEDR[17:1]		=  17'b0;


assign	HEX0[6:0]		=	7'b1111111;
assign  	HEX1[6:0]		=	7'b1111111;
assign	HEX2[6:0]		=	7'b1111111;
assign	HEX3[6:0]		=	7'b1111111;
assign	HEX4[6:0]		=	7'b1111111;
assign	HEX5[6:0]		=	7'b1111111;
assign	HEX6[6:0]		=	7'b1111111;
assign  	HEX7[6:0]		=	7'b1111111;

 // assign for ADC control signal
assign	AD_SCLK			= 1'b1;			// (DFS)Data Format Select
assign	AD_SDIO			= 1'b1;			// (DCS)Duty Cycle Stabilizer Select
assign	ADA_OE			= 1'b0;				// enable ADA output
assign	ADA_SPI_CS		= 1'b1;				// disable ADA_SPI_CS (CSB)
assign	ADB_OE			= 1'b0;				// enable ADA output
assign	ADB_SPI_CS		= 1'b1;				// disable ADA_SPI_CS (CSB)



// REG/WIRE Declarations for DUalLockin System I/O

wire		[13:0]	adc_data_in;
assign		adc_data_in  =  a2da_data;
wire		[13:0]	dac_out_a_wire;
wire		[13:0]	dac_out_b_wire;
wire 		[11:0]	nco_sync_o; 

wire 		[15:0]	lia_out_x_1;		// lock-in x output signal for lockin_1
wire		[15:0]	lia_out_y_1;		// lock-in y output signal for lockin_1
wire		[15:0]	lia_out_x_2;		// lock-in x output signal for lockin_2
wire		[15:0]	lia_out_y_2;		// lock-in y output signal for lockin_2
wire		[15:0]	lia_out_x_3;		// lock-in x output signal for lockin_2
wire		[15:0]	lia_out_y_3;
wire		[15:0]	lia_out_x_4;		// lock-in x output signal for lockin_2
wire		[15:0]	lia_out_y_4;
wire		[15:0]	lia_out_x_5;		// lock-in x output signal for lockin_2
wire		[15:0]	lia_out_y_5;
wire		[15:0]	lia_out_x_6;		// lock-in x output signal for lockin_2
wire		[15:0]	lia_out_y_6;
wire		[15:0]	lia_out_x_7;		// lock-in x output signal for lockin_2
wire		[15:0]	lia_out_y_7;
wire		[15:0]	lia_out_x_8;		// lock-in x output signal for lockin_2
wire		[15:0]	lia_out_y_8;
wire 		lia_out_valid;

 
 
//--- analog to digital converter capture and sync
	//--- Channel A
always @(negedge reset_n or posedge ADA_DCO)
begin
	if (!reset_n) begin
		per_a2da_d	<= 14'd0;
	end
	else begin
		per_a2da_d	<=  ADA_D;
	end
end

always @(negedge reset_n or posedge sys_clk)
begin
	if (!reset_n) begin
		a2da_data	<= 14'd0;
	end
	else begin
		a2da_data	<=  per_a2da_d;
	end
end



/*	//--- Channel B
always @(negedge reset_n or posedge ADB_DCO)
begin
	if (!reset_n) begin
		per_a2db_d	<= 14'd0;
	end
	else begin
		per_a2db_d	<=  ADB_D;
	end
end

always @(negedge reset_n or posedge sys_clk)
begin
	if (!reset_n) begin
		a2db_data	<= 14'd0;
	end
	else begin
		a2db_data	<=  per_a2db_d;
	end
end
 
 */
 
// assign for DAC output data
   assign	DA =  dac_out_a;
   assign	DB =  dac_out_b;
	


		
always @(negedge reset_n or posedge FPGA_CLK_B_P) //DAC output should be run using the DAC clock
begin
	if (!reset_n) begin
		dac_out_a	<= 14'd0;
		dac_out_b   <= 14'd0;
	end
	else begin
		dac_out_a	<= dac_out_a_wire ;
		dac_out_b	<= dac_out_b_wire ;
	end
end
								


								
								



///////////////////////////PROTOCOL To transfer data to a Rasp Pi/////////////////////
//From Saurabh Gupta's adaptive filter design

//reg [127:0] encoded_data = 128'd0;
//
//always @ (negedge lia_out_valid)
//begin
//encoded_data <= {	temp_counter,2'b11,lia_out_y_8[3:0],
//						temp_counter,2'b11,lia_out_y_8[7:4],
//						temp_counter,2'b11,lia_out_y_8[11:8],
//						temp_counter,2'b11,lia_out_y_8[15:12],
//						
//						temp_counter,2'b10,lia_out_x_8[3:0],
//						temp_counter,2'b10,lia_out_x_8[7:4],
//						temp_counter,2'b10,lia_out_x_8[11:8],
//						temp_counter,2'b10,lia_out_x_8[15:12],
//						
//						temp_counter,2'b11,lia_out_y_7[3:0],
//						temp_counter,2'b11,lia_out_y_7[7:4],
//						temp_counter,2'b11,lia_out_y_7[11:8],
//						temp_counter,2'b11,lia_out_y_7[15:12],
//						
//						temp_counter,2'b10,lia_out_x_6[3:0],
//						temp_counter,2'b10,lia_out_x_6[7:4],
//						temp_counter,2'b10,lia_out_x_6[11:8],
//						temp_counter,2'b10,lia_out_x_6[15:12],
//						
//						temp_counter,2'b11,lia_out_y_5[3:0],
//						temp_counter,2'b11,lia_out_y_5[7:4],
//						temp_counter,2'b11,lia_out_y_5[11:8],
//						temp_counter,2'b11,lia_out_y_5[15:12],
//						
//						temp_counter,2'b10,lia_out_x_5[3:0],
//						temp_counter,2'b10,lia_out_x_5[7:4],
//						temp_counter,2'b10,lia_out_x_5[11:8],
//						temp_counter,2'b10,lia_out_x_5[15:12],
//						
//						temp_counter,2'b11,lia_out_y_4[3:0],
//						temp_counter,2'b11,lia_out_y_4[7:4],
//						temp_counter,2'b11,lia_out_y_4[11:8],
//						temp_counter,2'b11,lia_out_y_4[15:12],
//						
//						temp_counter,2'b10,lia_out_x_4[3:0],
//						temp_counter,2'b10,lia_out_x_4[7:4],
//						temp_counter,2'b10,lia_out_x_4[11:8],
//						temp_counter,2'b10,lia_out_x_4[15:12],
//						
//						temp_counter,2'b11,lia_out_y_3[3:0],
//						temp_counter,2'b11,lia_out_y_3[7:4],
//						temp_counter,2'b11,lia_out_y_3[11:8],
//						temp_counter,2'b11,lia_out_y_3[15:12],
//						
//						temp_counter,2'b10,lia_out_x_3[3:0],
//						temp_counter,2'b10,lia_out_x_3[7:4],
//						temp_counter,2'b10,lia_out_x_3[11:8],
//						temp_counter,2'b10,lia_out_x_3[15:12],						
//												
//						temp_counter,2'b11,lia_out_y_2[3:0],
//						temp_counter,2'b11,lia_out_y_2[7:4],
//						temp_counter,2'b11,lia_out_y_2[11:8],
//						temp_counter,2'b11,lia_out_y_2[15:12],
//						
//						temp_counter,2'b10,lia_out_x_2[3:0],
//						temp_counter,2'b10,lia_out_x_2[7:4],
//						temp_counter,2'b10,lia_out_x_2[11:8],
//						temp_counter,2'b10,lia_out_x_2[15:12],
//						
//						temp_counter,2'b01,lia_out_y_1[3:0],
//						temp_counter,2'b01,lia_out_y_1[7:4],
//						temp_counter,2'b01,lia_out_y_1[11:8],
//						temp_counter,2'b01,lia_out_y_1[15:12],
//						
//						temp_counter,2'b00,lia_out_x_1[3:0],
//						temp_counter,2'b00,lia_out_x_1[7:4],
//						temp_counter,2'b00,lia_out_x_1[11:8],
//						temp_counter,2'b00,lia_out_x_1[15:12]		//MSB				
//							
//						};
//end

reg [127:0] encoded_data = 128'd0;

always @ (negedge lia_out_valid)
begin
encoded_data <= {	lia_out_y_8,lia_out_x_8,

						lia_out_y_7,lia_out_x_6,

						lia_out_y_5,lia_out_x_5,

						lia_out_y_4,lia_out_x_4,

						lia_out_y_3,lia_out_x_3,						

						lia_out_y_2,lia_out_x_2,
						
					   lia_out_y_1, lia_out_x_1		//MSB				
							
						};
end



//pass to FIFO


 FIFO fifo_1 (
	.data(encoded_data),
	.rdclk(GPIO[8]),
	.rdreq(1'b1),
	.wrclk(lia_out_valid),
	.wrreq(1'b1),
	.q(GPIO[7:0]),   
	.rdempty(GPIO[11]),
	.wrfull(GPIO[10])
	);
	
always @ (posedge lia_out_valid)	
begin
temp_counter = temp_counter + 2'b01;
end



////////////Transfer to SRAM////////////////////////////

(*noprune*) reg [21:0] sram_address = 22'd0;


sram_access sram_abc (
							.bridge_input_conduit_address((sram_write_done) ? 21'bzzzzzzzzzzzzzzzzzzzz : sram_address),     // bridge_input_conduit.address
							.bridge_input_conduit_byte_enable((sram_write_done) ? 2'bzz : 2'b11), //                     .byte_enable
							.bridge_input_conduit_read(),        //                     .read
							.bridge_input_conduit_write((sram_write_done) ? 1'bz : lia_out_valid),       //                     .write
							.bridge_input_conduit_write_data((sram_write_done) ? 16'bzzzzzzzzzzzzzzzz : out_data),  //                     .write_data
							.bridge_input_conduit_acknowledge(), //                     .acknowledge
							.bridge_input_conduit_read_data(),   //                     .read_data
							.clk_clk(CLOCK_50),                          //                  clk.clk
							.sram_conduit_DQ(SRAM_DQ),                  //         sram_conduit.DQ
							.sram_conduit_ADDR(SRAM_ADDR),                //                     .ADDR
							.sram_conduit_LB_N(SRAM_LB_N),                //                     .LB_N
							.sram_conduit_UB_N(SRAM_UB_N),                //                     .UB_N
							.sram_conduit_CE_N(SRAM_CE_N),                //                     .CE_N
							.sram_conduit_OE_N(SRAM_OE_N),                //                     .OE_N
							.sram_conduit_WE_N(SRAM_WE_N),                 //                     .WE_N
//							.vga_conduit_CLK(VGA_CLK),                  //          vga_conduit.CLK
//							.vga_conduit_HS(VGA_HS),                   //                     .HS
//							.vga_conduit_VS(VGA_VS),                   //                     .VS
//							.vga_conduit_BLANK(VGA_BLANK_N),                //                     .BLANK
//							.vga_conduit_SYNC(VGA_SYNC_N),                 //                     .SYNC
//							.vga_conduit_R(VGA_R),                    //                     .R
//							.vga_conduit_G(VGA_G),                    //                     .G
//							.vga_conduit_B(VGA_B)   
	);


reg  delay1_out_valid;
reg reg_reset_frame;
reg l_reg_reset_frame;
parameter INIT  = 1'd0,INCREMENT = 1'd1;
wire reset_frame;

	
always @ (posedge CLOCK_50)
begin
reg_reset_frame <= reset_frame;
l_reg_reset_frame <= reg_reset_frame;
delay1_out_valid <= lia_out_valid;
end

////////////////////////////////////STATE MACHINE FOR SRAM DATA TRANSFER////////////////////////////
reg state_mach = 1'd0;
reg sram_write_done = 1'b0;
//(*keep*) output wire test_bool;
//assign test_bool = (reg_reset_frame == 1'b0 || sram_address >= 22'd2097152);

always @ (posedge CLOCK_50)
begin

case (state_mach)

INIT:
begin
if (reg_reset_frame == 1'b1 && l_reg_reset_frame == 1'b0) begin
	sram_address <= 22'd0;
	state_mach <= INCREMENT;
	sram_write_done <= 1'b0;
end
end

INCREMENT:
begin
if (lia_out_valid == 1'b0 && delay1_out_valid== 1'b1) begin // if neg edge of out_valid
	sram_address <= sram_address + 2'b10;
	end

if (reg_reset_frame == 1'b0 || sram_address >= 22'd2097152) begin
	state_mach <= INIT;
	sram_write_done <= 1'b1;
end

end
endcase
end

//////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////

	

DE2115_EightLockins_system DE2115_EightLockins_system_inst(
				.clock_50			(CLOCK_50),
				.fpga_resetn		(reset_n),
				.reg_p_cosines		(dac_out_a_wire),
				.reg_n_cosines		(dac_out_b_wire),
				.lia_out_x_1 		(lia_out_x_1),		// lock-in x output signal for lockin_1
				.lia_out_y_1 		(lia_out_y_1),		// lock-in y output signal for lockin_1
				.lia_out_x_2 		(lia_out_x_2),		// lock-in x output signal for lockin_2
				.lia_out_y_2 		(lia_out_y_2),		// lock-in y output signal for lockin_2
				.lia_out_x_3 		(lia_out_x_3),		// lock-in x output signal for lockin_2
				.lia_out_y_3 		(lia_out_y_3),
				.lia_out_x_4 		(lia_out_x_4),		// lock-in x output signal for lockin_2
				.lia_out_y_4 		(lia_out_y_4),
				.lia_out_x_5 		(lia_out_x_5),		// lock-in x output signal for lockin_2
				.lia_out_y_5 		(lia_out_y_5),
				.lia_out_x_6 		(lia_out_x_6),		// lock-in x output signal for lockin_2
				.lia_out_y_6 		(lia_out_y_6),
				.lia_out_x_7 		(lia_out_x_7),		// lock-in x output signal for lockin_2
				.lia_out_y_7 		(lia_out_y_7),
				.lia_out_x_8 		(lia_out_x_8),		// lock-in x output signal for lockin_2
				.lia_out_y_8 		(lia_out_y_8),
				.lia_out_valid 	(lia_out_valid),				
				.adc_data			(adc_data_in),
				.adc_clk				(ADA_DCO),
				.heartbeat_led		(LEDG[0]),
				.overflow			(LEDR[0])
				
);
				
endmodule
