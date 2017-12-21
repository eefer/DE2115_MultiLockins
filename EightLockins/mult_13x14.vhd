-- megafunction wizard: %LPM_MULT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: lpm_mult 

-- ============================================================
-- File Name: mult_13x14.vhd
-- Megafunction Name(s):
-- 			lpm_mult
--
-- Simulation Library Files(s):
-- 			lpm
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 16.1.0 Build 196 10/24/2016 SJ Lite Edition
-- ************************************************************


--Copyright (C) 2016  Intel Corporation. All rights reserved.
--Your use of Intel Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Intel Program License 
--Subscription Agreement, the Intel Quartus Prime License Agreement,
--the Intel MegaCore Function License Agreement, or other 
--applicable license agreement, including, without limitation, 
--that your use is for the sole purpose of programming logic 
--devices manufactured by Intel and sold by Intel or its 
--authorized distributors.  Please refer to the applicable 
--agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY lpm;
USE lpm.all;

ENTITY mult_13x14 IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (26 DOWNTO 0)
	);
END mult_13x14;


ARCHITECTURE SYN OF mult_13x14 IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (26 DOWNTO 0);



	COMPONENT lpm_mult
	GENERIC (
		lpm_hint		: STRING;
		lpm_pipeline		: NATURAL;
		lpm_representation		: STRING;
		lpm_type		: STRING;
		lpm_widtha		: NATURAL;
		lpm_widthb		: NATURAL;
		lpm_widthp		: NATURAL
	);
	PORT (
			clock	: IN STD_LOGIC ;
			dataa	: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
			datab	: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
			result	: OUT STD_LOGIC_VECTOR (26 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	result    <= sub_wire0(26 DOWNTO 0);

	lpm_mult_component : lpm_mult
	GENERIC MAP (
		lpm_hint => "MAXIMIZE_SPEED=5",
		lpm_pipeline => 1,
		lpm_representation => "SIGNED",
		lpm_type => "LPM_MULT",
		lpm_widtha => 13,
		lpm_widthb => 14,
		lpm_widthp => 27
	)
	PORT MAP (
		clock => clock,
		dataa => dataa,
		datab => datab,
		result => sub_wire0
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: AutoSizeResult NUMERIC "1"
-- Retrieval info: PRIVATE: B_isConstant NUMERIC "0"
-- Retrieval info: PRIVATE: ConstantB NUMERIC "0"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
-- Retrieval info: PRIVATE: LPM_PIPELINE NUMERIC "1"
-- Retrieval info: PRIVATE: Latency NUMERIC "1"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
-- Retrieval info: PRIVATE: SignedMult NUMERIC "1"
-- Retrieval info: PRIVATE: USE_MULT NUMERIC "1"
-- Retrieval info: PRIVATE: ValidConstant NUMERIC "0"
-- Retrieval info: PRIVATE: WidthA NUMERIC "13"
-- Retrieval info: PRIVATE: WidthB NUMERIC "14"
-- Retrieval info: PRIVATE: WidthP NUMERIC "27"
-- Retrieval info: PRIVATE: aclr NUMERIC "0"
-- Retrieval info: PRIVATE: clken NUMERIC "0"
-- Retrieval info: PRIVATE: new_diagram STRING "1"
-- Retrieval info: PRIVATE: optimize NUMERIC "0"
-- Retrieval info: LIBRARY: lpm lpm.lpm_components.all
-- Retrieval info: CONSTANT: LPM_HINT STRING "MAXIMIZE_SPEED=5"
-- Retrieval info: CONSTANT: LPM_PIPELINE NUMERIC "1"
-- Retrieval info: CONSTANT: LPM_REPRESENTATION STRING "SIGNED"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MULT"
-- Retrieval info: CONSTANT: LPM_WIDTHA NUMERIC "13"
-- Retrieval info: CONSTANT: LPM_WIDTHB NUMERIC "14"
-- Retrieval info: CONSTANT: LPM_WIDTHP NUMERIC "27"
-- Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
-- Retrieval info: USED_PORT: dataa 0 0 13 0 INPUT NODEFVAL "dataa[12..0]"
-- Retrieval info: USED_PORT: datab 0 0 14 0 INPUT NODEFVAL "datab[13..0]"
-- Retrieval info: USED_PORT: result 0 0 27 0 OUTPUT NODEFVAL "result[26..0]"
-- Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
-- Retrieval info: CONNECT: @dataa 0 0 13 0 dataa 0 0 13 0
-- Retrieval info: CONNECT: @datab 0 0 14 0 datab 0 0 14 0
-- Retrieval info: CONNECT: result 0 0 27 0 @result 0 0 27 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL mult_13x14.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL mult_13x14.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL mult_13x14.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL mult_13x14.bsf FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL mult_13x14_inst.vhd FALSE
-- Retrieval info: LIB_FILE: lpm
