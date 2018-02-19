-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 17.0 (Release Build #595)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2017 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from atan_CORDIC_0
-- VHDL created on Thu Jan 25 15:23:48 2018


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity atan_CORDIC_0 is
    port (
        x : in std_logic_vector(15 downto 0);  -- sfix16_en10
        y : in std_logic_vector(15 downto 0);  -- sfix16_en10
        q : out std_logic_vector(10 downto 0);  -- sfix11_en8
        clk : in std_logic;
        areset : in std_logic
    );
end atan_CORDIC_0;

architecture normal of atan_CORDIC_0 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal constantZero_uid6_atan2Test_q : STD_LOGIC_VECTOR (15 downto 0);
    signal signX_uid7_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signY_uid8_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal invSignX_uid9_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal absXE_uid10_atan2Test_a : STD_LOGIC_VECTOR (17 downto 0);
    signal absXE_uid10_atan2Test_b : STD_LOGIC_VECTOR (17 downto 0);
    signal absXE_uid10_atan2Test_o : STD_LOGIC_VECTOR (17 downto 0);
    signal absXE_uid10_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal absXE_uid10_atan2Test_q : STD_LOGIC_VECTOR (16 downto 0);
    signal invSignY_uid11_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal absYE_uid12_atan2Test_a : STD_LOGIC_VECTOR (17 downto 0);
    signal absYE_uid12_atan2Test_b : STD_LOGIC_VECTOR (17 downto 0);
    signal absYE_uid12_atan2Test_o : STD_LOGIC_VECTOR (17 downto 0);
    signal absYE_uid12_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal absYE_uid12_atan2Test_q : STD_LOGIC_VECTOR (16 downto 0);
    signal absX_uid13_atan2Test_in : STD_LOGIC_VECTOR (15 downto 0);
    signal absX_uid13_atan2Test_b : STD_LOGIC_VECTOR (15 downto 0);
    signal absY_uid14_atan2Test_in : STD_LOGIC_VECTOR (15 downto 0);
    signal absY_uid14_atan2Test_b : STD_LOGIC_VECTOR (15 downto 0);
    signal yNotZero_uid15_atan2Test_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal yNotZero_uid15_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal yZero_uid16_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xNotZero_uid17_atan2Test_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal xNotZero_uid17_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xZero_uid18_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstArcTan2Mi_0_uid22_atan2Test_q : STD_LOGIC_VECTOR (19 downto 0);
    signal xip1E_1_uid23_atan2Test_a : STD_LOGIC_VECTOR (16 downto 0);
    signal xip1E_1_uid23_atan2Test_b : STD_LOGIC_VECTOR (16 downto 0);
    signal xip1E_1_uid23_atan2Test_o : STD_LOGIC_VECTOR (16 downto 0);
    signal xip1E_1_uid23_atan2Test_q : STD_LOGIC_VECTOR (16 downto 0);
    signal yip1E_1_uid24_atan2Test_a : STD_LOGIC_VECTOR (16 downto 0);
    signal yip1E_1_uid24_atan2Test_b : STD_LOGIC_VECTOR (16 downto 0);
    signal yip1E_1_uid24_atan2Test_o : STD_LOGIC_VECTOR (16 downto 0);
    signal yip1E_1_uid24_atan2Test_q : STD_LOGIC_VECTOR (16 downto 0);
    signal lowRangeB_uid25_atan2Test_in : STD_LOGIC_VECTOR (18 downto 0);
    signal lowRangeB_uid25_atan2Test_b : STD_LOGIC_VECTOR (18 downto 0);
    signal highBBits_uid26_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_1_uid28_atan2Test_q : STD_LOGIC_VECTOR (21 downto 0);
    signal aip1E_uid31_atan2Test_in : STD_LOGIC_VECTOR (20 downto 0);
    signal aip1E_uid31_atan2Test_b : STD_LOGIC_VECTOR (20 downto 0);
    signal xMSB_uid32_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal cstArcTan2Mi_1_uid36_atan2Test_q : STD_LOGIC_VECTOR (20 downto 0);
    signal invSignOfSelectionSignal_uid37_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_2NA_uid39_atan2Test_q : STD_LOGIC_VECTOR (17 downto 0);
    signal xip1E_2sumAHighB_uid40_atan2Test_a : STD_LOGIC_VECTOR (20 downto 0);
    signal xip1E_2sumAHighB_uid40_atan2Test_b : STD_LOGIC_VECTOR (20 downto 0);
    signal xip1E_2sumAHighB_uid40_atan2Test_o : STD_LOGIC_VECTOR (20 downto 0);
    signal xip1E_2sumAHighB_uid40_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_2sumAHighB_uid40_atan2Test_q : STD_LOGIC_VECTOR (19 downto 0);
    signal yip1E_2NA_uid42_atan2Test_q : STD_LOGIC_VECTOR (17 downto 0);
    signal yip1E_2sumAHighB_uid43_atan2Test_a : STD_LOGIC_VECTOR (19 downto 0);
    signal yip1E_2sumAHighB_uid43_atan2Test_b : STD_LOGIC_VECTOR (19 downto 0);
    signal yip1E_2sumAHighB_uid43_atan2Test_o : STD_LOGIC_VECTOR (19 downto 0);
    signal yip1E_2sumAHighB_uid43_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_2sumAHighB_uid43_atan2Test_q : STD_LOGIC_VECTOR (18 downto 0);
    signal aip1E_2CostZeroPaddingA_uid45_atan2Test_q : STD_LOGIC_VECTOR (1 downto 0);
    signal aip1E_2NA_uid46_atan2Test_q : STD_LOGIC_VECTOR (22 downto 0);
    signal aip1E_2sumAHighB_uid47_atan2Test_a : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_2sumAHighB_uid47_atan2Test_b : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_2sumAHighB_uid47_atan2Test_o : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_2sumAHighB_uid47_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_2sumAHighB_uid47_atan2Test_q : STD_LOGIC_VECTOR (23 downto 0);
    signal xip1_2_uid48_atan2Test_in : STD_LOGIC_VECTOR (17 downto 0);
    signal xip1_2_uid48_atan2Test_b : STD_LOGIC_VECTOR (17 downto 0);
    signal yip1_2_uid49_atan2Test_in : STD_LOGIC_VECTOR (17 downto 0);
    signal yip1_2_uid49_atan2Test_b : STD_LOGIC_VECTOR (17 downto 0);
    signal aip1E_uid50_atan2Test_in : STD_LOGIC_VECTOR (22 downto 0);
    signal aip1E_uid50_atan2Test_b : STD_LOGIC_VECTOR (22 downto 0);
    signal xMSB_uid51_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal cstArcTan2Mi_2_uid55_atan2Test_q : STD_LOGIC_VECTOR (21 downto 0);
    signal invSignOfSelectionSignal_uid56_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_3NA_uid58_atan2Test_q : STD_LOGIC_VECTOR (19 downto 0);
    signal xip1E_3sumAHighB_uid59_atan2Test_a : STD_LOGIC_VECTOR (22 downto 0);
    signal xip1E_3sumAHighB_uid59_atan2Test_b : STD_LOGIC_VECTOR (22 downto 0);
    signal xip1E_3sumAHighB_uid59_atan2Test_o : STD_LOGIC_VECTOR (22 downto 0);
    signal xip1E_3sumAHighB_uid59_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_3sumAHighB_uid59_atan2Test_q : STD_LOGIC_VECTOR (21 downto 0);
    signal yip1E_3NA_uid61_atan2Test_q : STD_LOGIC_VECTOR (19 downto 0);
    signal yip1E_3sumAHighB_uid62_atan2Test_a : STD_LOGIC_VECTOR (21 downto 0);
    signal yip1E_3sumAHighB_uid62_atan2Test_b : STD_LOGIC_VECTOR (21 downto 0);
    signal yip1E_3sumAHighB_uid62_atan2Test_o : STD_LOGIC_VECTOR (21 downto 0);
    signal yip1E_3sumAHighB_uid62_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_3sumAHighB_uid62_atan2Test_q : STD_LOGIC_VECTOR (20 downto 0);
    signal aip1E_3NA_uid65_atan2Test_q : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_3sumAHighB_uid66_atan2Test_a : STD_LOGIC_VECTOR (26 downto 0);
    signal aip1E_3sumAHighB_uid66_atan2Test_b : STD_LOGIC_VECTOR (26 downto 0);
    signal aip1E_3sumAHighB_uid66_atan2Test_o : STD_LOGIC_VECTOR (26 downto 0);
    signal aip1E_3sumAHighB_uid66_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_3sumAHighB_uid66_atan2Test_q : STD_LOGIC_VECTOR (25 downto 0);
    signal xip1_3_uid67_atan2Test_in : STD_LOGIC_VECTOR (19 downto 0);
    signal xip1_3_uid67_atan2Test_b : STD_LOGIC_VECTOR (19 downto 0);
    signal yip1_3_uid68_atan2Test_in : STD_LOGIC_VECTOR (18 downto 0);
    signal yip1_3_uid68_atan2Test_b : STD_LOGIC_VECTOR (18 downto 0);
    signal aip1E_uid69_atan2Test_in : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_uid69_atan2Test_b : STD_LOGIC_VECTOR (24 downto 0);
    signal xMSB_uid70_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal cstArcTan2Mi_3_uid74_atan2Test_q : STD_LOGIC_VECTOR (22 downto 0);
    signal invSignOfSelectionSignal_uid75_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_4CostZeroPaddingA_uid76_atan2Test_q : STD_LOGIC_VECTOR (2 downto 0);
    signal xip1E_4NA_uid77_atan2Test_q : STD_LOGIC_VECTOR (22 downto 0);
    signal xip1E_4sumAHighB_uid78_atan2Test_a : STD_LOGIC_VECTOR (25 downto 0);
    signal xip1E_4sumAHighB_uid78_atan2Test_b : STD_LOGIC_VECTOR (25 downto 0);
    signal xip1E_4sumAHighB_uid78_atan2Test_o : STD_LOGIC_VECTOR (25 downto 0);
    signal xip1E_4sumAHighB_uid78_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_4sumAHighB_uid78_atan2Test_q : STD_LOGIC_VECTOR (24 downto 0);
    signal yip1E_4NA_uid80_atan2Test_q : STD_LOGIC_VECTOR (21 downto 0);
    signal yip1E_4sumAHighB_uid81_atan2Test_a : STD_LOGIC_VECTOR (23 downto 0);
    signal yip1E_4sumAHighB_uid81_atan2Test_b : STD_LOGIC_VECTOR (23 downto 0);
    signal yip1E_4sumAHighB_uid81_atan2Test_o : STD_LOGIC_VECTOR (23 downto 0);
    signal yip1E_4sumAHighB_uid81_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_4sumAHighB_uid81_atan2Test_q : STD_LOGIC_VECTOR (22 downto 0);
    signal aip1E_4NA_uid84_atan2Test_q : STD_LOGIC_VECTOR (26 downto 0);
    signal aip1E_4sumAHighB_uid85_atan2Test_a : STD_LOGIC_VECTOR (28 downto 0);
    signal aip1E_4sumAHighB_uid85_atan2Test_b : STD_LOGIC_VECTOR (28 downto 0);
    signal aip1E_4sumAHighB_uid85_atan2Test_o : STD_LOGIC_VECTOR (28 downto 0);
    signal aip1E_4sumAHighB_uid85_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_4sumAHighB_uid85_atan2Test_q : STD_LOGIC_VECTOR (27 downto 0);
    signal xip1_4_uid86_atan2Test_in : STD_LOGIC_VECTOR (22 downto 0);
    signal xip1_4_uid86_atan2Test_b : STD_LOGIC_VECTOR (22 downto 0);
    signal yip1_4_uid87_atan2Test_in : STD_LOGIC_VECTOR (20 downto 0);
    signal yip1_4_uid87_atan2Test_b : STD_LOGIC_VECTOR (20 downto 0);
    signal aip1E_uid88_atan2Test_in : STD_LOGIC_VECTOR (26 downto 0);
    signal aip1E_uid88_atan2Test_b : STD_LOGIC_VECTOR (26 downto 0);
    signal xMSB_uid89_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal cstArcTan2Mi_4_uid93_atan2Test_q : STD_LOGIC_VECTOR (23 downto 0);
    signal invSignOfSelectionSignal_uid94_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_5CostZeroPaddingA_uid95_atan2Test_q : STD_LOGIC_VECTOR (3 downto 0);
    signal xip1E_5NA_uid96_atan2Test_q : STD_LOGIC_VECTOR (26 downto 0);
    signal xip1E_5sumAHighB_uid97_atan2Test_a : STD_LOGIC_VECTOR (29 downto 0);
    signal xip1E_5sumAHighB_uid97_atan2Test_b : STD_LOGIC_VECTOR (29 downto 0);
    signal xip1E_5sumAHighB_uid97_atan2Test_o : STD_LOGIC_VECTOR (29 downto 0);
    signal xip1E_5sumAHighB_uid97_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_5sumAHighB_uid97_atan2Test_q : STD_LOGIC_VECTOR (28 downto 0);
    signal yip1E_5NA_uid99_atan2Test_q : STD_LOGIC_VECTOR (24 downto 0);
    signal yip1E_5sumAHighB_uid100_atan2Test_a : STD_LOGIC_VECTOR (26 downto 0);
    signal yip1E_5sumAHighB_uid100_atan2Test_b : STD_LOGIC_VECTOR (26 downto 0);
    signal yip1E_5sumAHighB_uid100_atan2Test_o : STD_LOGIC_VECTOR (26 downto 0);
    signal yip1E_5sumAHighB_uid100_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_5sumAHighB_uid100_atan2Test_q : STD_LOGIC_VECTOR (25 downto 0);
    signal aip1E_5NA_uid103_atan2Test_q : STD_LOGIC_VECTOR (28 downto 0);
    signal aip1E_5sumAHighB_uid104_atan2Test_a : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_5sumAHighB_uid104_atan2Test_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_5sumAHighB_uid104_atan2Test_o : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_5sumAHighB_uid104_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_5sumAHighB_uid104_atan2Test_q : STD_LOGIC_VECTOR (29 downto 0);
    signal xip1_5_uid105_atan2Test_in : STD_LOGIC_VECTOR (26 downto 0);
    signal xip1_5_uid105_atan2Test_b : STD_LOGIC_VECTOR (26 downto 0);
    signal yip1_5_uid106_atan2Test_in : STD_LOGIC_VECTOR (23 downto 0);
    signal yip1_5_uid106_atan2Test_b : STD_LOGIC_VECTOR (23 downto 0);
    signal aip1E_uid107_atan2Test_in : STD_LOGIC_VECTOR (28 downto 0);
    signal aip1E_uid107_atan2Test_b : STD_LOGIC_VECTOR (28 downto 0);
    signal xMSB_uid108_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid112_atan2Test_b : STD_LOGIC_VECTOR (22 downto 0);
    signal twoToMiSiYip_uid113_atan2Test_b : STD_LOGIC_VECTOR (19 downto 0);
    signal cstArcTan2Mi_5_uid114_atan2Test_q : STD_LOGIC_VECTOR (24 downto 0);
    signal invSignOfSelectionSignal_uid115_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_6NA_uid117_atan2Test_q : STD_LOGIC_VECTOR (27 downto 0);
    signal xip1E_6sumAHighB_uid118_atan2Test_a : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_6sumAHighB_uid118_atan2Test_b : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_6sumAHighB_uid118_atan2Test_o : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_6sumAHighB_uid118_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_6sumAHighB_uid118_atan2Test_q : STD_LOGIC_VECTOR (29 downto 0);
    signal yip1E_6NA_uid120_atan2Test_q : STD_LOGIC_VECTOR (24 downto 0);
    signal yip1E_6sumAHighB_uid121_atan2Test_a : STD_LOGIC_VECTOR (26 downto 0);
    signal yip1E_6sumAHighB_uid121_atan2Test_b : STD_LOGIC_VECTOR (26 downto 0);
    signal yip1E_6sumAHighB_uid121_atan2Test_o : STD_LOGIC_VECTOR (26 downto 0);
    signal yip1E_6sumAHighB_uid121_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_6sumAHighB_uid121_atan2Test_q : STD_LOGIC_VECTOR (25 downto 0);
    signal aip1E_6NA_uid124_atan2Test_q : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_6sumAHighB_uid125_atan2Test_a : STD_LOGIC_VECTOR (32 downto 0);
    signal aip1E_6sumAHighB_uid125_atan2Test_b : STD_LOGIC_VECTOR (32 downto 0);
    signal aip1E_6sumAHighB_uid125_atan2Test_o : STD_LOGIC_VECTOR (32 downto 0);
    signal aip1E_6sumAHighB_uid125_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_6sumAHighB_uid125_atan2Test_q : STD_LOGIC_VECTOR (31 downto 0);
    signal xip1_6_uid126_atan2Test_in : STD_LOGIC_VECTOR (27 downto 0);
    signal xip1_6_uid126_atan2Test_b : STD_LOGIC_VECTOR (27 downto 0);
    signal yip1_6_uid127_atan2Test_in : STD_LOGIC_VECTOR (23 downto 0);
    signal yip1_6_uid127_atan2Test_b : STD_LOGIC_VECTOR (23 downto 0);
    signal aip1E_uid128_atan2Test_in : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid128_atan2Test_b : STD_LOGIC_VECTOR (30 downto 0);
    signal xMSB_uid129_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid133_atan2Test_b : STD_LOGIC_VECTOR (21 downto 0);
    signal twoToMiSiYip_uid134_atan2Test_b : STD_LOGIC_VECTOR (17 downto 0);
    signal cstArcTan2Mi_6_uid135_atan2Test_q : STD_LOGIC_VECTOR (25 downto 0);
    signal invSignOfSelectionSignal_uid136_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_7_uid137_atan2Test_a : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_7_uid137_atan2Test_b : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_7_uid137_atan2Test_o : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_7_uid137_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_7_uid137_atan2Test_q : STD_LOGIC_VECTOR (29 downto 0);
    signal yip1E_7_uid138_atan2Test_a : STD_LOGIC_VECTOR (25 downto 0);
    signal yip1E_7_uid138_atan2Test_b : STD_LOGIC_VECTOR (25 downto 0);
    signal yip1E_7_uid138_atan2Test_o : STD_LOGIC_VECTOR (25 downto 0);
    signal yip1E_7_uid138_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_7_uid138_atan2Test_q : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_7NA_uid141_atan2Test_q : STD_LOGIC_VECTOR (32 downto 0);
    signal aip1E_7sumAHighB_uid142_atan2Test_a : STD_LOGIC_VECTOR (34 downto 0);
    signal aip1E_7sumAHighB_uid142_atan2Test_b : STD_LOGIC_VECTOR (34 downto 0);
    signal aip1E_7sumAHighB_uid142_atan2Test_o : STD_LOGIC_VECTOR (34 downto 0);
    signal aip1E_7sumAHighB_uid142_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_7sumAHighB_uid142_atan2Test_q : STD_LOGIC_VECTOR (33 downto 0);
    signal xip1_7_uid143_atan2Test_in : STD_LOGIC_VECTOR (27 downto 0);
    signal xip1_7_uid143_atan2Test_b : STD_LOGIC_VECTOR (27 downto 0);
    signal yip1_7_uid144_atan2Test_in : STD_LOGIC_VECTOR (22 downto 0);
    signal yip1_7_uid144_atan2Test_b : STD_LOGIC_VECTOR (22 downto 0);
    signal aip1E_uid145_atan2Test_in : STD_LOGIC_VECTOR (32 downto 0);
    signal aip1E_uid145_atan2Test_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xMSB_uid146_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid150_atan2Test_b : STD_LOGIC_VECTOR (20 downto 0);
    signal twoToMiSiYip_uid151_atan2Test_b : STD_LOGIC_VECTOR (15 downto 0);
    signal cstArcTan2Mi_7_uid152_atan2Test_q : STD_LOGIC_VECTOR (26 downto 0);
    signal invSignOfSelectionSignal_uid153_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_8_uid154_atan2Test_a : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_8_uid154_atan2Test_b : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_8_uid154_atan2Test_o : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_8_uid154_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_8_uid154_atan2Test_q : STD_LOGIC_VECTOR (29 downto 0);
    signal yip1E_8_uid155_atan2Test_a : STD_LOGIC_VECTOR (24 downto 0);
    signal yip1E_8_uid155_atan2Test_b : STD_LOGIC_VECTOR (24 downto 0);
    signal yip1E_8_uid155_atan2Test_o : STD_LOGIC_VECTOR (24 downto 0);
    signal yip1E_8_uid155_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_8_uid155_atan2Test_q : STD_LOGIC_VECTOR (23 downto 0);
    signal aip1E_8NA_uid158_atan2Test_q : STD_LOGIC_VECTOR (34 downto 0);
    signal aip1E_8sumAHighB_uid159_atan2Test_a : STD_LOGIC_VECTOR (36 downto 0);
    signal aip1E_8sumAHighB_uid159_atan2Test_b : STD_LOGIC_VECTOR (36 downto 0);
    signal aip1E_8sumAHighB_uid159_atan2Test_o : STD_LOGIC_VECTOR (36 downto 0);
    signal aip1E_8sumAHighB_uid159_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_8sumAHighB_uid159_atan2Test_q : STD_LOGIC_VECTOR (35 downto 0);
    signal xip1_8_uid160_atan2Test_in : STD_LOGIC_VECTOR (27 downto 0);
    signal xip1_8_uid160_atan2Test_b : STD_LOGIC_VECTOR (27 downto 0);
    signal yip1_8_uid161_atan2Test_in : STD_LOGIC_VECTOR (21 downto 0);
    signal yip1_8_uid161_atan2Test_b : STD_LOGIC_VECTOR (21 downto 0);
    signal aip1E_uid162_atan2Test_in : STD_LOGIC_VECTOR (34 downto 0);
    signal aip1E_uid162_atan2Test_b : STD_LOGIC_VECTOR (34 downto 0);
    signal xMSB_uid163_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid167_atan2Test_b : STD_LOGIC_VECTOR (19 downto 0);
    signal twoToMiSiYip_uid168_atan2Test_b : STD_LOGIC_VECTOR (13 downto 0);
    signal cstArcTan2Mi_8_uid169_atan2Test_q : STD_LOGIC_VECTOR (27 downto 0);
    signal invSignOfSelectionSignal_uid170_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_9_uid171_atan2Test_a : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_9_uid171_atan2Test_b : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_9_uid171_atan2Test_o : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1E_9_uid171_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_9_uid171_atan2Test_q : STD_LOGIC_VECTOR (29 downto 0);
    signal yip1E_9_uid172_atan2Test_a : STD_LOGIC_VECTOR (23 downto 0);
    signal yip1E_9_uid172_atan2Test_b : STD_LOGIC_VECTOR (23 downto 0);
    signal yip1E_9_uid172_atan2Test_o : STD_LOGIC_VECTOR (23 downto 0);
    signal yip1E_9_uid172_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_9_uid172_atan2Test_q : STD_LOGIC_VECTOR (22 downto 0);
    signal aip1E_9NA_uid175_atan2Test_q : STD_LOGIC_VECTOR (36 downto 0);
    signal aip1E_9sumAHighB_uid176_atan2Test_a : STD_LOGIC_VECTOR (38 downto 0);
    signal aip1E_9sumAHighB_uid176_atan2Test_b : STD_LOGIC_VECTOR (38 downto 0);
    signal aip1E_9sumAHighB_uid176_atan2Test_o : STD_LOGIC_VECTOR (38 downto 0);
    signal aip1E_9sumAHighB_uid176_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_9sumAHighB_uid176_atan2Test_q : STD_LOGIC_VECTOR (37 downto 0);
    signal xip1_9_uid177_atan2Test_in : STD_LOGIC_VECTOR (27 downto 0);
    signal xip1_9_uid177_atan2Test_b : STD_LOGIC_VECTOR (27 downto 0);
    signal yip1_9_uid178_atan2Test_in : STD_LOGIC_VECTOR (20 downto 0);
    signal yip1_9_uid178_atan2Test_b : STD_LOGIC_VECTOR (20 downto 0);
    signal aip1E_uid179_atan2Test_in : STD_LOGIC_VECTOR (36 downto 0);
    signal aip1E_uid179_atan2Test_b : STD_LOGIC_VECTOR (36 downto 0);
    signal xMSB_uid180_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid184_atan2Test_b : STD_LOGIC_VECTOR (18 downto 0);
    signal cstArcTan2Mi_9_uid186_atan2Test_q : STD_LOGIC_VECTOR (28 downto 0);
    signal yip1E_10_uid189_atan2Test_a : STD_LOGIC_VECTOR (22 downto 0);
    signal yip1E_10_uid189_atan2Test_b : STD_LOGIC_VECTOR (22 downto 0);
    signal yip1E_10_uid189_atan2Test_o : STD_LOGIC_VECTOR (22 downto 0);
    signal yip1E_10_uid189_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_10_uid189_atan2Test_q : STD_LOGIC_VECTOR (21 downto 0);
    signal invSignOfSelectionSignal_uid190_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_10NA_uid192_atan2Test_q : STD_LOGIC_VECTOR (38 downto 0);
    signal aip1E_10sumAHighB_uid193_atan2Test_a : STD_LOGIC_VECTOR (40 downto 0);
    signal aip1E_10sumAHighB_uid193_atan2Test_b : STD_LOGIC_VECTOR (40 downto 0);
    signal aip1E_10sumAHighB_uid193_atan2Test_o : STD_LOGIC_VECTOR (40 downto 0);
    signal aip1E_10sumAHighB_uid193_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_10sumAHighB_uid193_atan2Test_q : STD_LOGIC_VECTOR (39 downto 0);
    signal yip1_10_uid195_atan2Test_in : STD_LOGIC_VECTOR (19 downto 0);
    signal yip1_10_uid195_atan2Test_b : STD_LOGIC_VECTOR (19 downto 0);
    signal aip1E_uid196_atan2Test_in : STD_LOGIC_VECTOR (38 downto 0);
    signal aip1E_uid196_atan2Test_b : STD_LOGIC_VECTOR (38 downto 0);
    signal xMSB_uid197_atan2Test_b : STD_LOGIC_VECTOR (0 downto 0);
    signal cstArcTan2Mi_10_uid203_atan2Test_q : STD_LOGIC_VECTOR (29 downto 0);
    signal invSignOfSelectionSignal_uid207_atan2Test_q : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_11NA_uid209_atan2Test_q : STD_LOGIC_VECTOR (40 downto 0);
    signal aip1E_11sumAHighB_uid210_atan2Test_a : STD_LOGIC_VECTOR (42 downto 0);
    signal aip1E_11sumAHighB_uid210_atan2Test_b : STD_LOGIC_VECTOR (42 downto 0);
    signal aip1E_11sumAHighB_uid210_atan2Test_o : STD_LOGIC_VECTOR (42 downto 0);
    signal aip1E_11sumAHighB_uid210_atan2Test_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_11sumAHighB_uid210_atan2Test_q : STD_LOGIC_VECTOR (41 downto 0);
    signal aip1E_uid213_atan2Test_in : STD_LOGIC_VECTOR (40 downto 0);
    signal aip1E_uid213_atan2Test_b : STD_LOGIC_VECTOR (40 downto 0);
    signal alphaPreRnd_uid214_atan2Test_b : STD_LOGIC_VECTOR (11 downto 0);
    signal alphaPostRndhigh_uid220_atan2Test_a : STD_LOGIC_VECTOR (11 downto 0);
    signal alphaPostRndhigh_uid220_atan2Test_b : STD_LOGIC_VECTOR (11 downto 0);
    signal alphaPostRndhigh_uid220_atan2Test_o : STD_LOGIC_VECTOR (11 downto 0);
    signal alphaPostRndhigh_uid220_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal alphaPostRnd_uid221_atan2Test_q : STD_LOGIC_VECTOR (12 downto 0);
    signal atanRes_uid222_atan2Test_in : STD_LOGIC_VECTOR (11 downto 0);
    signal atanRes_uid222_atan2Test_b : STD_LOGIC_VECTOR (11 downto 0);
    signal cstZeroOutFormat_uid223_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal constPiP2uE_uid224_atan2Test_q : STD_LOGIC_VECTOR (10 downto 0);
    signal constPio2P2u_mergedSignalTM_uid227_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal concXZeroYZero_uid229_atan2Test_q : STD_LOGIC_VECTOR (1 downto 0);
    signal atanResPostExc_uid230_atan2Test_s : STD_LOGIC_VECTOR (1 downto 0);
    signal atanResPostExc_uid230_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal concSigns_uid231_atan2Test_q : STD_LOGIC_VECTOR (1 downto 0);
    signal constPiP2u_uid232_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal constPi_uid233_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal constantZeroOutFormat_uid234_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal constantZeroOutFormatP2u_uid235_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal firstOperand_uid237_atan2Test_s : STD_LOGIC_VECTOR (1 downto 0);
    signal firstOperand_uid237_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal secondOperand_uid238_atan2Test_s : STD_LOGIC_VECTOR (1 downto 0);
    signal secondOperand_uid238_atan2Test_q : STD_LOGIC_VECTOR (11 downto 0);
    signal outResExtended_uid239_atan2Test_a : STD_LOGIC_VECTOR (12 downto 0);
    signal outResExtended_uid239_atan2Test_b : STD_LOGIC_VECTOR (12 downto 0);
    signal outResExtended_uid239_atan2Test_o : STD_LOGIC_VECTOR (12 downto 0);
    signal outResExtended_uid239_atan2Test_q : STD_LOGIC_VECTOR (12 downto 0);
    signal atanResPostRR_uid240_atan2Test_b : STD_LOGIC_VECTOR (10 downto 0);
    signal lowRangeA_uid218_atan2Test_merged_bit_select_b : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeA_uid218_atan2Test_merged_bit_select_c : STD_LOGIC_VECTOR (10 downto 0);
    signal redist0_atanRes_uid222_atan2Test_b_1_q : STD_LOGIC_VECTOR (11 downto 0);
    signal redist1_alphaPreRnd_uid214_atan2Test_b_1_q : STD_LOGIC_VECTOR (11 downto 0);
    signal redist2_xMSB_uid197_atan2Test_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_aip1E_uid196_atan2Test_b_1_q : STD_LOGIC_VECTOR (38 downto 0);
    signal redist4_twoToMiSiXip_uid184_atan2Test_b_1_q : STD_LOGIC_VECTOR (18 downto 0);
    signal redist5_aip1E_uid179_atan2Test_b_1_q : STD_LOGIC_VECTOR (36 downto 0);
    signal redist6_yip1_9_uid178_atan2Test_b_1_q : STD_LOGIC_VECTOR (20 downto 0);
    signal redist7_aip1E_uid162_atan2Test_b_1_q : STD_LOGIC_VECTOR (34 downto 0);
    signal redist8_yip1_8_uid161_atan2Test_b_1_q : STD_LOGIC_VECTOR (21 downto 0);
    signal redist9_xip1_8_uid160_atan2Test_b_1_q : STD_LOGIC_VECTOR (27 downto 0);
    signal redist10_aip1E_uid145_atan2Test_b_1_q : STD_LOGIC_VECTOR (32 downto 0);
    signal redist11_yip1_7_uid144_atan2Test_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist12_xip1_7_uid143_atan2Test_b_1_q : STD_LOGIC_VECTOR (27 downto 0);
    signal redist13_aip1E_uid128_atan2Test_b_1_q : STD_LOGIC_VECTOR (30 downto 0);
    signal redist14_yip1_6_uid127_atan2Test_b_1_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist15_xip1_6_uid126_atan2Test_b_1_q : STD_LOGIC_VECTOR (27 downto 0);
    signal redist16_aip1E_uid107_atan2Test_b_1_q : STD_LOGIC_VECTOR (28 downto 0);
    signal redist17_yip1_5_uid106_atan2Test_b_1_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist18_xip1_5_uid105_atan2Test_b_1_q : STD_LOGIC_VECTOR (26 downto 0);
    signal redist19_aip1E_uid88_atan2Test_b_1_q : STD_LOGIC_VECTOR (26 downto 0);
    signal redist20_yip1_4_uid87_atan2Test_b_1_q : STD_LOGIC_VECTOR (20 downto 0);
    signal redist21_xip1_4_uid86_atan2Test_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist22_aip1E_uid69_atan2Test_b_1_q : STD_LOGIC_VECTOR (24 downto 0);
    signal redist23_yip1_3_uid68_atan2Test_b_1_q : STD_LOGIC_VECTOR (18 downto 0);
    signal redist24_xip1_3_uid67_atan2Test_b_1_q : STD_LOGIC_VECTOR (19 downto 0);
    signal redist25_aip1E_uid50_atan2Test_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist26_yip1_2_uid49_atan2Test_b_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal redist27_xip1_2_uid48_atan2Test_b_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal redist28_xNotZero_uid17_atan2Test_q_13_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist29_yNotZero_uid15_atan2Test_q_13_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist30_absY_uid14_atan2Test_b_1_q : STD_LOGIC_VECTOR (15 downto 0);
    signal redist31_absX_uid13_atan2Test_b_1_q : STD_LOGIC_VECTOR (15 downto 0);
    signal redist32_signY_uid8_atan2Test_b_13_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist33_signX_uid7_atan2Test_b_13_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- constPi_uid233_atan2Test(CONSTANT,232)
    constPi_uid233_atan2Test_q <= "110010010001";

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- constPiP2uE_uid224_atan2Test(CONSTANT,223)
    constPiP2uE_uid224_atan2Test_q <= "11001001010";

    -- constPio2P2u_mergedSignalTM_uid227_atan2Test(BITJOIN,226)@13
    constPio2P2u_mergedSignalTM_uid227_atan2Test_q <= GND_q & constPiP2uE_uid224_atan2Test_q;

    -- cstZeroOutFormat_uid223_atan2Test(CONSTANT,222)
    cstZeroOutFormat_uid223_atan2Test_q <= "000000000010";

    -- alphaPostRndhigh_uid220_atan2Test(ADD,219)@12
    alphaPostRndhigh_uid220_atan2Test_a <= STD_LOGIC_VECTOR("0" & lowRangeA_uid218_atan2Test_merged_bit_select_c);
    alphaPostRndhigh_uid220_atan2Test_b <= STD_LOGIC_VECTOR("00000000000" & VCC_q);
    alphaPostRndhigh_uid220_atan2Test_o <= STD_LOGIC_VECTOR(UNSIGNED(alphaPostRndhigh_uid220_atan2Test_a) + UNSIGNED(alphaPostRndhigh_uid220_atan2Test_b));
    alphaPostRndhigh_uid220_atan2Test_q <= alphaPostRndhigh_uid220_atan2Test_o(11 downto 0);

    -- xMSB_uid180_atan2Test(BITSELECT,179)@10
    xMSB_uid180_atan2Test_b <= STD_LOGIC_VECTOR(redist6_yip1_9_uid178_atan2Test_b_1_q(20 downto 20));

    -- xMSB_uid146_atan2Test(BITSELECT,145)@8
    xMSB_uid146_atan2Test_b <= STD_LOGIC_VECTOR(redist11_yip1_7_uid144_atan2Test_b_1_q(22 downto 22));

    -- signX_uid7_atan2Test(BITSELECT,6)@0
    signX_uid7_atan2Test_b <= STD_LOGIC_VECTOR(x(15 downto 15));

    -- invSignX_uid9_atan2Test(LOGICAL,8)@0
    invSignX_uid9_atan2Test_q <= not (signX_uid7_atan2Test_b);

    -- constantZero_uid6_atan2Test(CONSTANT,5)
    constantZero_uid6_atan2Test_q <= "0000000000000000";

    -- absXE_uid10_atan2Test(ADDSUB,9)@0
    absXE_uid10_atan2Test_s <= invSignX_uid9_atan2Test_q;
    absXE_uid10_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 16 => constantZero_uid6_atan2Test_q(15)) & constantZero_uid6_atan2Test_q));
    absXE_uid10_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 16 => x(15)) & x));
    absXE_uid10_atan2Test_combproc: PROCESS (absXE_uid10_atan2Test_a, absXE_uid10_atan2Test_b, absXE_uid10_atan2Test_s)
    BEGIN
        IF (absXE_uid10_atan2Test_s = "1") THEN
            absXE_uid10_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(absXE_uid10_atan2Test_a) + SIGNED(absXE_uid10_atan2Test_b));
        ELSE
            absXE_uid10_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(absXE_uid10_atan2Test_a) - SIGNED(absXE_uid10_atan2Test_b));
        END IF;
    END PROCESS;
    absXE_uid10_atan2Test_q <= absXE_uid10_atan2Test_o(16 downto 0);

    -- absX_uid13_atan2Test(BITSELECT,12)@0
    absX_uid13_atan2Test_in <= absXE_uid10_atan2Test_q(15 downto 0);
    absX_uid13_atan2Test_b <= absX_uid13_atan2Test_in(15 downto 0);

    -- redist31_absX_uid13_atan2Test_b_1(DELAY,273)
    redist31_absX_uid13_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 16, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => absX_uid13_atan2Test_b, xout => redist31_absX_uid13_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- signY_uid8_atan2Test(BITSELECT,7)@0
    signY_uid8_atan2Test_b <= STD_LOGIC_VECTOR(y(15 downto 15));

    -- invSignY_uid11_atan2Test(LOGICAL,10)@0
    invSignY_uid11_atan2Test_q <= not (signY_uid8_atan2Test_b);

    -- absYE_uid12_atan2Test(ADDSUB,11)@0
    absYE_uid12_atan2Test_s <= invSignY_uid11_atan2Test_q;
    absYE_uid12_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 16 => constantZero_uid6_atan2Test_q(15)) & constantZero_uid6_atan2Test_q));
    absYE_uid12_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 16 => y(15)) & y));
    absYE_uid12_atan2Test_combproc: PROCESS (absYE_uid12_atan2Test_a, absYE_uid12_atan2Test_b, absYE_uid12_atan2Test_s)
    BEGIN
        IF (absYE_uid12_atan2Test_s = "1") THEN
            absYE_uid12_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(absYE_uid12_atan2Test_a) + SIGNED(absYE_uid12_atan2Test_b));
        ELSE
            absYE_uid12_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(absYE_uid12_atan2Test_a) - SIGNED(absYE_uid12_atan2Test_b));
        END IF;
    END PROCESS;
    absYE_uid12_atan2Test_q <= absYE_uid12_atan2Test_o(16 downto 0);

    -- absY_uid14_atan2Test(BITSELECT,13)@0
    absY_uid14_atan2Test_in <= absYE_uid12_atan2Test_q(15 downto 0);
    absY_uid14_atan2Test_b <= absY_uid14_atan2Test_in(15 downto 0);

    -- redist30_absY_uid14_atan2Test_b_1(DELAY,272)
    redist30_absY_uid14_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 16, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => absY_uid14_atan2Test_b, xout => redist30_absY_uid14_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- yip1E_1_uid24_atan2Test(SUB,23)@1 + 1
    yip1E_1_uid24_atan2Test_a <= STD_LOGIC_VECTOR("0" & redist30_absY_uid14_atan2Test_b_1_q);
    yip1E_1_uid24_atan2Test_b <= STD_LOGIC_VECTOR("0" & redist31_absX_uid13_atan2Test_b_1_q);
    yip1E_1_uid24_atan2Test_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            yip1E_1_uid24_atan2Test_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            yip1E_1_uid24_atan2Test_o <= STD_LOGIC_VECTOR(UNSIGNED(yip1E_1_uid24_atan2Test_a) - UNSIGNED(yip1E_1_uid24_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_1_uid24_atan2Test_q <= yip1E_1_uid24_atan2Test_o(16 downto 0);

    -- xMSB_uid32_atan2Test(BITSELECT,31)@2
    xMSB_uid32_atan2Test_b <= STD_LOGIC_VECTOR(yip1E_1_uid24_atan2Test_q(16 downto 16));

    -- xip1E_1_uid23_atan2Test(ADD,22)@1 + 1
    xip1E_1_uid23_atan2Test_a <= STD_LOGIC_VECTOR("0" & redist31_absX_uid13_atan2Test_b_1_q);
    xip1E_1_uid23_atan2Test_b <= STD_LOGIC_VECTOR("0" & redist30_absY_uid14_atan2Test_b_1_q);
    xip1E_1_uid23_atan2Test_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            xip1E_1_uid23_atan2Test_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            xip1E_1_uid23_atan2Test_o <= STD_LOGIC_VECTOR(UNSIGNED(xip1E_1_uid23_atan2Test_a) + UNSIGNED(xip1E_1_uid23_atan2Test_b));
        END IF;
    END PROCESS;
    xip1E_1_uid23_atan2Test_q <= xip1E_1_uid23_atan2Test_o(16 downto 0);

    -- yip1E_2NA_uid42_atan2Test(BITJOIN,41)@2
    yip1E_2NA_uid42_atan2Test_q <= yip1E_1_uid24_atan2Test_q & GND_q;

    -- yip1E_2sumAHighB_uid43_atan2Test(ADDSUB,42)@2
    yip1E_2sumAHighB_uid43_atan2Test_s <= xMSB_uid32_atan2Test_b;
    yip1E_2sumAHighB_uid43_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 18 => yip1E_2NA_uid42_atan2Test_q(17)) & yip1E_2NA_uid42_atan2Test_q));
    yip1E_2sumAHighB_uid43_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "00" & xip1E_1_uid23_atan2Test_q));
    yip1E_2sumAHighB_uid43_atan2Test_combproc: PROCESS (yip1E_2sumAHighB_uid43_atan2Test_a, yip1E_2sumAHighB_uid43_atan2Test_b, yip1E_2sumAHighB_uid43_atan2Test_s)
    BEGIN
        IF (yip1E_2sumAHighB_uid43_atan2Test_s = "1") THEN
            yip1E_2sumAHighB_uid43_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_2sumAHighB_uid43_atan2Test_a) + SIGNED(yip1E_2sumAHighB_uid43_atan2Test_b));
        ELSE
            yip1E_2sumAHighB_uid43_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_2sumAHighB_uid43_atan2Test_a) - SIGNED(yip1E_2sumAHighB_uid43_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_2sumAHighB_uid43_atan2Test_q <= yip1E_2sumAHighB_uid43_atan2Test_o(18 downto 0);

    -- yip1_2_uid49_atan2Test(BITSELECT,48)@2
    yip1_2_uid49_atan2Test_in <= STD_LOGIC_VECTOR(yip1E_2sumAHighB_uid43_atan2Test_q(17 downto 0));
    yip1_2_uid49_atan2Test_b <= STD_LOGIC_VECTOR(yip1_2_uid49_atan2Test_in(17 downto 0));

    -- redist26_yip1_2_uid49_atan2Test_b_1(DELAY,268)
    redist26_yip1_2_uid49_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 18, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yip1_2_uid49_atan2Test_b, xout => redist26_yip1_2_uid49_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xMSB_uid51_atan2Test(BITSELECT,50)@3
    xMSB_uid51_atan2Test_b <= STD_LOGIC_VECTOR(redist26_yip1_2_uid49_atan2Test_b_1_q(17 downto 17));

    -- invSignOfSelectionSignal_uid37_atan2Test(LOGICAL,36)@2
    invSignOfSelectionSignal_uid37_atan2Test_q <= not (xMSB_uid32_atan2Test_b);

    -- xip1E_2NA_uid39_atan2Test(BITJOIN,38)@2
    xip1E_2NA_uid39_atan2Test_q <= xip1E_1_uid23_atan2Test_q & GND_q;

    -- xip1E_2sumAHighB_uid40_atan2Test(ADDSUB,39)@2
    xip1E_2sumAHighB_uid40_atan2Test_s <= invSignOfSelectionSignal_uid37_atan2Test_q;
    xip1E_2sumAHighB_uid40_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "00" & xip1E_2NA_uid39_atan2Test_q));
    xip1E_2sumAHighB_uid40_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 17 => yip1E_1_uid24_atan2Test_q(16)) & yip1E_1_uid24_atan2Test_q));
    xip1E_2sumAHighB_uid40_atan2Test_combproc: PROCESS (xip1E_2sumAHighB_uid40_atan2Test_a, xip1E_2sumAHighB_uid40_atan2Test_b, xip1E_2sumAHighB_uid40_atan2Test_s)
    BEGIN
        IF (xip1E_2sumAHighB_uid40_atan2Test_s = "1") THEN
            xip1E_2sumAHighB_uid40_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_2sumAHighB_uid40_atan2Test_a) + SIGNED(xip1E_2sumAHighB_uid40_atan2Test_b));
        ELSE
            xip1E_2sumAHighB_uid40_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_2sumAHighB_uid40_atan2Test_a) - SIGNED(xip1E_2sumAHighB_uid40_atan2Test_b));
        END IF;
    END PROCESS;
    xip1E_2sumAHighB_uid40_atan2Test_q <= xip1E_2sumAHighB_uid40_atan2Test_o(19 downto 0);

    -- xip1_2_uid48_atan2Test(BITSELECT,47)@2
    xip1_2_uid48_atan2Test_in <= xip1E_2sumAHighB_uid40_atan2Test_q(17 downto 0);
    xip1_2_uid48_atan2Test_b <= xip1_2_uid48_atan2Test_in(17 downto 0);

    -- redist27_xip1_2_uid48_atan2Test_b_1(DELAY,269)
    redist27_xip1_2_uid48_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 18, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xip1_2_uid48_atan2Test_b, xout => redist27_xip1_2_uid48_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_2CostZeroPaddingA_uid45_atan2Test(CONSTANT,44)
    aip1E_2CostZeroPaddingA_uid45_atan2Test_q <= "00";

    -- yip1E_3NA_uid61_atan2Test(BITJOIN,60)@3
    yip1E_3NA_uid61_atan2Test_q <= redist26_yip1_2_uid49_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- yip1E_3sumAHighB_uid62_atan2Test(ADDSUB,61)@3
    yip1E_3sumAHighB_uid62_atan2Test_s <= xMSB_uid51_atan2Test_b;
    yip1E_3sumAHighB_uid62_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 20 => yip1E_3NA_uid61_atan2Test_q(19)) & yip1E_3NA_uid61_atan2Test_q));
    yip1E_3sumAHighB_uid62_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000" & redist27_xip1_2_uid48_atan2Test_b_1_q));
    yip1E_3sumAHighB_uid62_atan2Test_combproc: PROCESS (yip1E_3sumAHighB_uid62_atan2Test_a, yip1E_3sumAHighB_uid62_atan2Test_b, yip1E_3sumAHighB_uid62_atan2Test_s)
    BEGIN
        IF (yip1E_3sumAHighB_uid62_atan2Test_s = "1") THEN
            yip1E_3sumAHighB_uid62_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_3sumAHighB_uid62_atan2Test_a) + SIGNED(yip1E_3sumAHighB_uid62_atan2Test_b));
        ELSE
            yip1E_3sumAHighB_uid62_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_3sumAHighB_uid62_atan2Test_a) - SIGNED(yip1E_3sumAHighB_uid62_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_3sumAHighB_uid62_atan2Test_q <= yip1E_3sumAHighB_uid62_atan2Test_o(20 downto 0);

    -- yip1_3_uid68_atan2Test(BITSELECT,67)@3
    yip1_3_uid68_atan2Test_in <= STD_LOGIC_VECTOR(yip1E_3sumAHighB_uid62_atan2Test_q(18 downto 0));
    yip1_3_uid68_atan2Test_b <= STD_LOGIC_VECTOR(yip1_3_uid68_atan2Test_in(18 downto 0));

    -- redist23_yip1_3_uid68_atan2Test_b_1(DELAY,265)
    redist23_yip1_3_uid68_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 19, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yip1_3_uid68_atan2Test_b, xout => redist23_yip1_3_uid68_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xMSB_uid70_atan2Test(BITSELECT,69)@4
    xMSB_uid70_atan2Test_b <= STD_LOGIC_VECTOR(redist23_yip1_3_uid68_atan2Test_b_1_q(18 downto 18));

    -- invSignOfSelectionSignal_uid56_atan2Test(LOGICAL,55)@3
    invSignOfSelectionSignal_uid56_atan2Test_q <= not (xMSB_uid51_atan2Test_b);

    -- xip1E_3NA_uid58_atan2Test(BITJOIN,57)@3
    xip1E_3NA_uid58_atan2Test_q <= redist27_xip1_2_uid48_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- xip1E_3sumAHighB_uid59_atan2Test(ADDSUB,58)@3
    xip1E_3sumAHighB_uid59_atan2Test_s <= invSignOfSelectionSignal_uid56_atan2Test_q;
    xip1E_3sumAHighB_uid59_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "00" & xip1E_3NA_uid58_atan2Test_q));
    xip1E_3sumAHighB_uid59_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 18 => redist26_yip1_2_uid49_atan2Test_b_1_q(17)) & redist26_yip1_2_uid49_atan2Test_b_1_q));
    xip1E_3sumAHighB_uid59_atan2Test_combproc: PROCESS (xip1E_3sumAHighB_uid59_atan2Test_a, xip1E_3sumAHighB_uid59_atan2Test_b, xip1E_3sumAHighB_uid59_atan2Test_s)
    BEGIN
        IF (xip1E_3sumAHighB_uid59_atan2Test_s = "1") THEN
            xip1E_3sumAHighB_uid59_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_3sumAHighB_uid59_atan2Test_a) + SIGNED(xip1E_3sumAHighB_uid59_atan2Test_b));
        ELSE
            xip1E_3sumAHighB_uid59_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_3sumAHighB_uid59_atan2Test_a) - SIGNED(xip1E_3sumAHighB_uid59_atan2Test_b));
        END IF;
    END PROCESS;
    xip1E_3sumAHighB_uid59_atan2Test_q <= xip1E_3sumAHighB_uid59_atan2Test_o(21 downto 0);

    -- xip1_3_uid67_atan2Test(BITSELECT,66)@3
    xip1_3_uid67_atan2Test_in <= xip1E_3sumAHighB_uid59_atan2Test_q(19 downto 0);
    xip1_3_uid67_atan2Test_b <= xip1_3_uid67_atan2Test_in(19 downto 0);

    -- redist24_xip1_3_uid67_atan2Test_b_1(DELAY,266)
    redist24_xip1_3_uid67_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 20, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xip1_3_uid67_atan2Test_b, xout => redist24_xip1_3_uid67_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xip1E_4CostZeroPaddingA_uid76_atan2Test(CONSTANT,75)
    xip1E_4CostZeroPaddingA_uid76_atan2Test_q <= "000";

    -- yip1E_4NA_uid80_atan2Test(BITJOIN,79)@4
    yip1E_4NA_uid80_atan2Test_q <= redist23_yip1_3_uid68_atan2Test_b_1_q & xip1E_4CostZeroPaddingA_uid76_atan2Test_q;

    -- yip1E_4sumAHighB_uid81_atan2Test(ADDSUB,80)@4
    yip1E_4sumAHighB_uid81_atan2Test_s <= xMSB_uid70_atan2Test_b;
    yip1E_4sumAHighB_uid81_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 22 => yip1E_4NA_uid80_atan2Test_q(21)) & yip1E_4NA_uid80_atan2Test_q));
    yip1E_4sumAHighB_uid81_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000" & redist24_xip1_3_uid67_atan2Test_b_1_q));
    yip1E_4sumAHighB_uid81_atan2Test_combproc: PROCESS (yip1E_4sumAHighB_uid81_atan2Test_a, yip1E_4sumAHighB_uid81_atan2Test_b, yip1E_4sumAHighB_uid81_atan2Test_s)
    BEGIN
        IF (yip1E_4sumAHighB_uid81_atan2Test_s = "1") THEN
            yip1E_4sumAHighB_uid81_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_4sumAHighB_uid81_atan2Test_a) + SIGNED(yip1E_4sumAHighB_uid81_atan2Test_b));
        ELSE
            yip1E_4sumAHighB_uid81_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_4sumAHighB_uid81_atan2Test_a) - SIGNED(yip1E_4sumAHighB_uid81_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_4sumAHighB_uid81_atan2Test_q <= yip1E_4sumAHighB_uid81_atan2Test_o(22 downto 0);

    -- yip1_4_uid87_atan2Test(BITSELECT,86)@4
    yip1_4_uid87_atan2Test_in <= STD_LOGIC_VECTOR(yip1E_4sumAHighB_uid81_atan2Test_q(20 downto 0));
    yip1_4_uid87_atan2Test_b <= STD_LOGIC_VECTOR(yip1_4_uid87_atan2Test_in(20 downto 0));

    -- redist20_yip1_4_uid87_atan2Test_b_1(DELAY,262)
    redist20_yip1_4_uid87_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 21, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yip1_4_uid87_atan2Test_b, xout => redist20_yip1_4_uid87_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xMSB_uid89_atan2Test(BITSELECT,88)@5
    xMSB_uid89_atan2Test_b <= STD_LOGIC_VECTOR(redist20_yip1_4_uid87_atan2Test_b_1_q(20 downto 20));

    -- invSignOfSelectionSignal_uid75_atan2Test(LOGICAL,74)@4
    invSignOfSelectionSignal_uid75_atan2Test_q <= not (xMSB_uid70_atan2Test_b);

    -- xip1E_4NA_uid77_atan2Test(BITJOIN,76)@4
    xip1E_4NA_uid77_atan2Test_q <= redist24_xip1_3_uid67_atan2Test_b_1_q & xip1E_4CostZeroPaddingA_uid76_atan2Test_q;

    -- xip1E_4sumAHighB_uid78_atan2Test(ADDSUB,77)@4
    xip1E_4sumAHighB_uid78_atan2Test_s <= invSignOfSelectionSignal_uid75_atan2Test_q;
    xip1E_4sumAHighB_uid78_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "00" & xip1E_4NA_uid77_atan2Test_q));
    xip1E_4sumAHighB_uid78_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 19 => redist23_yip1_3_uid68_atan2Test_b_1_q(18)) & redist23_yip1_3_uid68_atan2Test_b_1_q));
    xip1E_4sumAHighB_uid78_atan2Test_combproc: PROCESS (xip1E_4sumAHighB_uid78_atan2Test_a, xip1E_4sumAHighB_uid78_atan2Test_b, xip1E_4sumAHighB_uid78_atan2Test_s)
    BEGIN
        IF (xip1E_4sumAHighB_uid78_atan2Test_s = "1") THEN
            xip1E_4sumAHighB_uid78_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_4sumAHighB_uid78_atan2Test_a) + SIGNED(xip1E_4sumAHighB_uid78_atan2Test_b));
        ELSE
            xip1E_4sumAHighB_uid78_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_4sumAHighB_uid78_atan2Test_a) - SIGNED(xip1E_4sumAHighB_uid78_atan2Test_b));
        END IF;
    END PROCESS;
    xip1E_4sumAHighB_uid78_atan2Test_q <= xip1E_4sumAHighB_uid78_atan2Test_o(24 downto 0);

    -- xip1_4_uid86_atan2Test(BITSELECT,85)@4
    xip1_4_uid86_atan2Test_in <= xip1E_4sumAHighB_uid78_atan2Test_q(22 downto 0);
    xip1_4_uid86_atan2Test_b <= xip1_4_uid86_atan2Test_in(22 downto 0);

    -- redist21_xip1_4_uid86_atan2Test_b_1(DELAY,263)
    redist21_xip1_4_uid86_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xip1_4_uid86_atan2Test_b, xout => redist21_xip1_4_uid86_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xip1E_5CostZeroPaddingA_uid95_atan2Test(CONSTANT,94)
    xip1E_5CostZeroPaddingA_uid95_atan2Test_q <= "0000";

    -- yip1E_5NA_uid99_atan2Test(BITJOIN,98)@5
    yip1E_5NA_uid99_atan2Test_q <= redist20_yip1_4_uid87_atan2Test_b_1_q & xip1E_5CostZeroPaddingA_uid95_atan2Test_q;

    -- yip1E_5sumAHighB_uid100_atan2Test(ADDSUB,99)@5
    yip1E_5sumAHighB_uid100_atan2Test_s <= xMSB_uid89_atan2Test_b;
    yip1E_5sumAHighB_uid100_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 25 => yip1E_5NA_uid99_atan2Test_q(24)) & yip1E_5NA_uid99_atan2Test_q));
    yip1E_5sumAHighB_uid100_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000" & redist21_xip1_4_uid86_atan2Test_b_1_q));
    yip1E_5sumAHighB_uid100_atan2Test_combproc: PROCESS (yip1E_5sumAHighB_uid100_atan2Test_a, yip1E_5sumAHighB_uid100_atan2Test_b, yip1E_5sumAHighB_uid100_atan2Test_s)
    BEGIN
        IF (yip1E_5sumAHighB_uid100_atan2Test_s = "1") THEN
            yip1E_5sumAHighB_uid100_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_5sumAHighB_uid100_atan2Test_a) + SIGNED(yip1E_5sumAHighB_uid100_atan2Test_b));
        ELSE
            yip1E_5sumAHighB_uid100_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_5sumAHighB_uid100_atan2Test_a) - SIGNED(yip1E_5sumAHighB_uid100_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_5sumAHighB_uid100_atan2Test_q <= yip1E_5sumAHighB_uid100_atan2Test_o(25 downto 0);

    -- yip1_5_uid106_atan2Test(BITSELECT,105)@5
    yip1_5_uid106_atan2Test_in <= STD_LOGIC_VECTOR(yip1E_5sumAHighB_uid100_atan2Test_q(23 downto 0));
    yip1_5_uid106_atan2Test_b <= STD_LOGIC_VECTOR(yip1_5_uid106_atan2Test_in(23 downto 0));

    -- redist17_yip1_5_uid106_atan2Test_b_1(DELAY,259)
    redist17_yip1_5_uid106_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 24, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yip1_5_uid106_atan2Test_b, xout => redist17_yip1_5_uid106_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xMSB_uid108_atan2Test(BITSELECT,107)@6
    xMSB_uid108_atan2Test_b <= STD_LOGIC_VECTOR(redist17_yip1_5_uid106_atan2Test_b_1_q(23 downto 23));

    -- invSignOfSelectionSignal_uid94_atan2Test(LOGICAL,93)@5
    invSignOfSelectionSignal_uid94_atan2Test_q <= not (xMSB_uid89_atan2Test_b);

    -- xip1E_5NA_uid96_atan2Test(BITJOIN,95)@5
    xip1E_5NA_uid96_atan2Test_q <= redist21_xip1_4_uid86_atan2Test_b_1_q & xip1E_5CostZeroPaddingA_uid95_atan2Test_q;

    -- xip1E_5sumAHighB_uid97_atan2Test(ADDSUB,96)@5
    xip1E_5sumAHighB_uid97_atan2Test_s <= invSignOfSelectionSignal_uid94_atan2Test_q;
    xip1E_5sumAHighB_uid97_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "00" & xip1E_5NA_uid96_atan2Test_q));
    xip1E_5sumAHighB_uid97_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((29 downto 21 => redist20_yip1_4_uid87_atan2Test_b_1_q(20)) & redist20_yip1_4_uid87_atan2Test_b_1_q));
    xip1E_5sumAHighB_uid97_atan2Test_combproc: PROCESS (xip1E_5sumAHighB_uid97_atan2Test_a, xip1E_5sumAHighB_uid97_atan2Test_b, xip1E_5sumAHighB_uid97_atan2Test_s)
    BEGIN
        IF (xip1E_5sumAHighB_uid97_atan2Test_s = "1") THEN
            xip1E_5sumAHighB_uid97_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_5sumAHighB_uid97_atan2Test_a) + SIGNED(xip1E_5sumAHighB_uid97_atan2Test_b));
        ELSE
            xip1E_5sumAHighB_uid97_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_5sumAHighB_uid97_atan2Test_a) - SIGNED(xip1E_5sumAHighB_uid97_atan2Test_b));
        END IF;
    END PROCESS;
    xip1E_5sumAHighB_uid97_atan2Test_q <= xip1E_5sumAHighB_uid97_atan2Test_o(28 downto 0);

    -- xip1_5_uid105_atan2Test(BITSELECT,104)@5
    xip1_5_uid105_atan2Test_in <= xip1E_5sumAHighB_uid97_atan2Test_q(26 downto 0);
    xip1_5_uid105_atan2Test_b <= xip1_5_uid105_atan2Test_in(26 downto 0);

    -- redist18_xip1_5_uid105_atan2Test_b_1(DELAY,260)
    redist18_xip1_5_uid105_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 27, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xip1_5_uid105_atan2Test_b, xout => redist18_xip1_5_uid105_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- twoToMiSiXip_uid112_atan2Test(BITSELECT,111)@6
    twoToMiSiXip_uid112_atan2Test_b <= redist18_xip1_5_uid105_atan2Test_b_1_q(26 downto 4);

    -- yip1E_6NA_uid120_atan2Test(BITJOIN,119)@6
    yip1E_6NA_uid120_atan2Test_q <= redist17_yip1_5_uid106_atan2Test_b_1_q & GND_q;

    -- yip1E_6sumAHighB_uid121_atan2Test(ADDSUB,120)@6
    yip1E_6sumAHighB_uid121_atan2Test_s <= xMSB_uid108_atan2Test_b;
    yip1E_6sumAHighB_uid121_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 25 => yip1E_6NA_uid120_atan2Test_q(24)) & yip1E_6NA_uid120_atan2Test_q));
    yip1E_6sumAHighB_uid121_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000" & twoToMiSiXip_uid112_atan2Test_b));
    yip1E_6sumAHighB_uid121_atan2Test_combproc: PROCESS (yip1E_6sumAHighB_uid121_atan2Test_a, yip1E_6sumAHighB_uid121_atan2Test_b, yip1E_6sumAHighB_uid121_atan2Test_s)
    BEGIN
        IF (yip1E_6sumAHighB_uid121_atan2Test_s = "1") THEN
            yip1E_6sumAHighB_uid121_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_6sumAHighB_uid121_atan2Test_a) + SIGNED(yip1E_6sumAHighB_uid121_atan2Test_b));
        ELSE
            yip1E_6sumAHighB_uid121_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_6sumAHighB_uid121_atan2Test_a) - SIGNED(yip1E_6sumAHighB_uid121_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_6sumAHighB_uid121_atan2Test_q <= yip1E_6sumAHighB_uid121_atan2Test_o(25 downto 0);

    -- yip1_6_uid127_atan2Test(BITSELECT,126)@6
    yip1_6_uid127_atan2Test_in <= STD_LOGIC_VECTOR(yip1E_6sumAHighB_uid121_atan2Test_q(23 downto 0));
    yip1_6_uid127_atan2Test_b <= STD_LOGIC_VECTOR(yip1_6_uid127_atan2Test_in(23 downto 0));

    -- redist14_yip1_6_uid127_atan2Test_b_1(DELAY,256)
    redist14_yip1_6_uid127_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 24, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yip1_6_uid127_atan2Test_b, xout => redist14_yip1_6_uid127_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xMSB_uid129_atan2Test(BITSELECT,128)@7
    xMSB_uid129_atan2Test_b <= STD_LOGIC_VECTOR(redist14_yip1_6_uid127_atan2Test_b_1_q(23 downto 23));

    -- invSignOfSelectionSignal_uid136_atan2Test(LOGICAL,135)@7
    invSignOfSelectionSignal_uid136_atan2Test_q <= not (xMSB_uid129_atan2Test_b);

    -- twoToMiSiYip_uid134_atan2Test(BITSELECT,133)@7
    twoToMiSiYip_uid134_atan2Test_b <= STD_LOGIC_VECTOR(redist14_yip1_6_uid127_atan2Test_b_1_q(23 downto 6));

    -- invSignOfSelectionSignal_uid115_atan2Test(LOGICAL,114)@6
    invSignOfSelectionSignal_uid115_atan2Test_q <= not (xMSB_uid108_atan2Test_b);

    -- twoToMiSiYip_uid113_atan2Test(BITSELECT,112)@6
    twoToMiSiYip_uid113_atan2Test_b <= STD_LOGIC_VECTOR(redist17_yip1_5_uid106_atan2Test_b_1_q(23 downto 4));

    -- xip1E_6NA_uid117_atan2Test(BITJOIN,116)@6
    xip1E_6NA_uid117_atan2Test_q <= redist18_xip1_5_uid105_atan2Test_b_1_q & GND_q;

    -- xip1E_6sumAHighB_uid118_atan2Test(ADDSUB,117)@6
    xip1E_6sumAHighB_uid118_atan2Test_s <= invSignOfSelectionSignal_uid115_atan2Test_q;
    xip1E_6sumAHighB_uid118_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "00" & xip1E_6NA_uid117_atan2Test_q));
    xip1E_6sumAHighB_uid118_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 20 => twoToMiSiYip_uid113_atan2Test_b(19)) & twoToMiSiYip_uid113_atan2Test_b));
    xip1E_6sumAHighB_uid118_atan2Test_combproc: PROCESS (xip1E_6sumAHighB_uid118_atan2Test_a, xip1E_6sumAHighB_uid118_atan2Test_b, xip1E_6sumAHighB_uid118_atan2Test_s)
    BEGIN
        IF (xip1E_6sumAHighB_uid118_atan2Test_s = "1") THEN
            xip1E_6sumAHighB_uid118_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_6sumAHighB_uid118_atan2Test_a) + SIGNED(xip1E_6sumAHighB_uid118_atan2Test_b));
        ELSE
            xip1E_6sumAHighB_uid118_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_6sumAHighB_uid118_atan2Test_a) - SIGNED(xip1E_6sumAHighB_uid118_atan2Test_b));
        END IF;
    END PROCESS;
    xip1E_6sumAHighB_uid118_atan2Test_q <= xip1E_6sumAHighB_uid118_atan2Test_o(29 downto 0);

    -- xip1_6_uid126_atan2Test(BITSELECT,125)@6
    xip1_6_uid126_atan2Test_in <= xip1E_6sumAHighB_uid118_atan2Test_q(27 downto 0);
    xip1_6_uid126_atan2Test_b <= xip1_6_uid126_atan2Test_in(27 downto 0);

    -- redist15_xip1_6_uid126_atan2Test_b_1(DELAY,257)
    redist15_xip1_6_uid126_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 28, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xip1_6_uid126_atan2Test_b, xout => redist15_xip1_6_uid126_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xip1E_7_uid137_atan2Test(ADDSUB,136)@7
    xip1E_7_uid137_atan2Test_s <= invSignOfSelectionSignal_uid136_atan2Test_q;
    xip1E_7_uid137_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "00" & redist15_xip1_6_uid126_atan2Test_b_1_q));
    xip1E_7_uid137_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 18 => twoToMiSiYip_uid134_atan2Test_b(17)) & twoToMiSiYip_uid134_atan2Test_b));
    xip1E_7_uid137_atan2Test_combproc: PROCESS (xip1E_7_uid137_atan2Test_a, xip1E_7_uid137_atan2Test_b, xip1E_7_uid137_atan2Test_s)
    BEGIN
        IF (xip1E_7_uid137_atan2Test_s = "1") THEN
            xip1E_7_uid137_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_7_uid137_atan2Test_a) + SIGNED(xip1E_7_uid137_atan2Test_b));
        ELSE
            xip1E_7_uid137_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_7_uid137_atan2Test_a) - SIGNED(xip1E_7_uid137_atan2Test_b));
        END IF;
    END PROCESS;
    xip1E_7_uid137_atan2Test_q <= xip1E_7_uid137_atan2Test_o(29 downto 0);

    -- xip1_7_uid143_atan2Test(BITSELECT,142)@7
    xip1_7_uid143_atan2Test_in <= xip1E_7_uid137_atan2Test_q(27 downto 0);
    xip1_7_uid143_atan2Test_b <= xip1_7_uid143_atan2Test_in(27 downto 0);

    -- redist12_xip1_7_uid143_atan2Test_b_1(DELAY,254)
    redist12_xip1_7_uid143_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 28, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xip1_7_uid143_atan2Test_b, xout => redist12_xip1_7_uid143_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- twoToMiSiXip_uid150_atan2Test(BITSELECT,149)@8
    twoToMiSiXip_uid150_atan2Test_b <= redist12_xip1_7_uid143_atan2Test_b_1_q(27 downto 7);

    -- twoToMiSiXip_uid133_atan2Test(BITSELECT,132)@7
    twoToMiSiXip_uid133_atan2Test_b <= redist15_xip1_6_uid126_atan2Test_b_1_q(27 downto 6);

    -- yip1E_7_uid138_atan2Test(ADDSUB,137)@7
    yip1E_7_uid138_atan2Test_s <= xMSB_uid129_atan2Test_b;
    yip1E_7_uid138_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 24 => redist14_yip1_6_uid127_atan2Test_b_1_q(23)) & redist14_yip1_6_uid127_atan2Test_b_1_q));
    yip1E_7_uid138_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000" & twoToMiSiXip_uid133_atan2Test_b));
    yip1E_7_uid138_atan2Test_combproc: PROCESS (yip1E_7_uid138_atan2Test_a, yip1E_7_uid138_atan2Test_b, yip1E_7_uid138_atan2Test_s)
    BEGIN
        IF (yip1E_7_uid138_atan2Test_s = "1") THEN
            yip1E_7_uid138_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_7_uid138_atan2Test_a) + SIGNED(yip1E_7_uid138_atan2Test_b));
        ELSE
            yip1E_7_uid138_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_7_uid138_atan2Test_a) - SIGNED(yip1E_7_uid138_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_7_uid138_atan2Test_q <= yip1E_7_uid138_atan2Test_o(24 downto 0);

    -- yip1_7_uid144_atan2Test(BITSELECT,143)@7
    yip1_7_uid144_atan2Test_in <= STD_LOGIC_VECTOR(yip1E_7_uid138_atan2Test_q(22 downto 0));
    yip1_7_uid144_atan2Test_b <= STD_LOGIC_VECTOR(yip1_7_uid144_atan2Test_in(22 downto 0));

    -- redist11_yip1_7_uid144_atan2Test_b_1(DELAY,253)
    redist11_yip1_7_uid144_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yip1_7_uid144_atan2Test_b, xout => redist11_yip1_7_uid144_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- yip1E_8_uid155_atan2Test(ADDSUB,154)@8
    yip1E_8_uid155_atan2Test_s <= xMSB_uid146_atan2Test_b;
    yip1E_8_uid155_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 23 => redist11_yip1_7_uid144_atan2Test_b_1_q(22)) & redist11_yip1_7_uid144_atan2Test_b_1_q));
    yip1E_8_uid155_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000" & twoToMiSiXip_uid150_atan2Test_b));
    yip1E_8_uid155_atan2Test_combproc: PROCESS (yip1E_8_uid155_atan2Test_a, yip1E_8_uid155_atan2Test_b, yip1E_8_uid155_atan2Test_s)
    BEGIN
        IF (yip1E_8_uid155_atan2Test_s = "1") THEN
            yip1E_8_uid155_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_8_uid155_atan2Test_a) + SIGNED(yip1E_8_uid155_atan2Test_b));
        ELSE
            yip1E_8_uid155_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_8_uid155_atan2Test_a) - SIGNED(yip1E_8_uid155_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_8_uid155_atan2Test_q <= yip1E_8_uid155_atan2Test_o(23 downto 0);

    -- yip1_8_uid161_atan2Test(BITSELECT,160)@8
    yip1_8_uid161_atan2Test_in <= STD_LOGIC_VECTOR(yip1E_8_uid155_atan2Test_q(21 downto 0));
    yip1_8_uid161_atan2Test_b <= STD_LOGIC_VECTOR(yip1_8_uid161_atan2Test_in(21 downto 0));

    -- redist8_yip1_8_uid161_atan2Test_b_1(DELAY,250)
    redist8_yip1_8_uid161_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 22, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yip1_8_uid161_atan2Test_b, xout => redist8_yip1_8_uid161_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xMSB_uid163_atan2Test(BITSELECT,162)@9
    xMSB_uid163_atan2Test_b <= STD_LOGIC_VECTOR(redist8_yip1_8_uid161_atan2Test_b_1_q(21 downto 21));

    -- invSignOfSelectionSignal_uid170_atan2Test(LOGICAL,169)@9
    invSignOfSelectionSignal_uid170_atan2Test_q <= not (xMSB_uid163_atan2Test_b);

    -- twoToMiSiYip_uid168_atan2Test(BITSELECT,167)@9
    twoToMiSiYip_uid168_atan2Test_b <= STD_LOGIC_VECTOR(redist8_yip1_8_uid161_atan2Test_b_1_q(21 downto 8));

    -- invSignOfSelectionSignal_uid153_atan2Test(LOGICAL,152)@8
    invSignOfSelectionSignal_uid153_atan2Test_q <= not (xMSB_uid146_atan2Test_b);

    -- twoToMiSiYip_uid151_atan2Test(BITSELECT,150)@8
    twoToMiSiYip_uid151_atan2Test_b <= STD_LOGIC_VECTOR(redist11_yip1_7_uid144_atan2Test_b_1_q(22 downto 7));

    -- xip1E_8_uid154_atan2Test(ADDSUB,153)@8
    xip1E_8_uid154_atan2Test_s <= invSignOfSelectionSignal_uid153_atan2Test_q;
    xip1E_8_uid154_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "00" & redist12_xip1_7_uid143_atan2Test_b_1_q));
    xip1E_8_uid154_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 16 => twoToMiSiYip_uid151_atan2Test_b(15)) & twoToMiSiYip_uid151_atan2Test_b));
    xip1E_8_uid154_atan2Test_combproc: PROCESS (xip1E_8_uid154_atan2Test_a, xip1E_8_uid154_atan2Test_b, xip1E_8_uid154_atan2Test_s)
    BEGIN
        IF (xip1E_8_uid154_atan2Test_s = "1") THEN
            xip1E_8_uid154_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_8_uid154_atan2Test_a) + SIGNED(xip1E_8_uid154_atan2Test_b));
        ELSE
            xip1E_8_uid154_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_8_uid154_atan2Test_a) - SIGNED(xip1E_8_uid154_atan2Test_b));
        END IF;
    END PROCESS;
    xip1E_8_uid154_atan2Test_q <= xip1E_8_uid154_atan2Test_o(29 downto 0);

    -- xip1_8_uid160_atan2Test(BITSELECT,159)@8
    xip1_8_uid160_atan2Test_in <= xip1E_8_uid154_atan2Test_q(27 downto 0);
    xip1_8_uid160_atan2Test_b <= xip1_8_uid160_atan2Test_in(27 downto 0);

    -- redist9_xip1_8_uid160_atan2Test_b_1(DELAY,251)
    redist9_xip1_8_uid160_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 28, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xip1_8_uid160_atan2Test_b, xout => redist9_xip1_8_uid160_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xip1E_9_uid171_atan2Test(ADDSUB,170)@9
    xip1E_9_uid171_atan2Test_s <= invSignOfSelectionSignal_uid170_atan2Test_q;
    xip1E_9_uid171_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "00" & redist9_xip1_8_uid160_atan2Test_b_1_q));
    xip1E_9_uid171_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 14 => twoToMiSiYip_uid168_atan2Test_b(13)) & twoToMiSiYip_uid168_atan2Test_b));
    xip1E_9_uid171_atan2Test_combproc: PROCESS (xip1E_9_uid171_atan2Test_a, xip1E_9_uid171_atan2Test_b, xip1E_9_uid171_atan2Test_s)
    BEGIN
        IF (xip1E_9_uid171_atan2Test_s = "1") THEN
            xip1E_9_uid171_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_9_uid171_atan2Test_a) + SIGNED(xip1E_9_uid171_atan2Test_b));
        ELSE
            xip1E_9_uid171_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_9_uid171_atan2Test_a) - SIGNED(xip1E_9_uid171_atan2Test_b));
        END IF;
    END PROCESS;
    xip1E_9_uid171_atan2Test_q <= xip1E_9_uid171_atan2Test_o(29 downto 0);

    -- xip1_9_uid177_atan2Test(BITSELECT,176)@9
    xip1_9_uid177_atan2Test_in <= xip1E_9_uid171_atan2Test_q(27 downto 0);
    xip1_9_uid177_atan2Test_b <= xip1_9_uid177_atan2Test_in(27 downto 0);

    -- twoToMiSiXip_uid184_atan2Test(BITSELECT,183)@9
    twoToMiSiXip_uid184_atan2Test_b <= xip1_9_uid177_atan2Test_b(27 downto 9);

    -- redist4_twoToMiSiXip_uid184_atan2Test_b_1(DELAY,246)
    redist4_twoToMiSiXip_uid184_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 19, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => twoToMiSiXip_uid184_atan2Test_b, xout => redist4_twoToMiSiXip_uid184_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- twoToMiSiXip_uid167_atan2Test(BITSELECT,166)@9
    twoToMiSiXip_uid167_atan2Test_b <= redist9_xip1_8_uid160_atan2Test_b_1_q(27 downto 8);

    -- yip1E_9_uid172_atan2Test(ADDSUB,171)@9
    yip1E_9_uid172_atan2Test_s <= xMSB_uid163_atan2Test_b;
    yip1E_9_uid172_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 22 => redist8_yip1_8_uid161_atan2Test_b_1_q(21)) & redist8_yip1_8_uid161_atan2Test_b_1_q));
    yip1E_9_uid172_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000" & twoToMiSiXip_uid167_atan2Test_b));
    yip1E_9_uid172_atan2Test_combproc: PROCESS (yip1E_9_uid172_atan2Test_a, yip1E_9_uid172_atan2Test_b, yip1E_9_uid172_atan2Test_s)
    BEGIN
        IF (yip1E_9_uid172_atan2Test_s = "1") THEN
            yip1E_9_uid172_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_9_uid172_atan2Test_a) + SIGNED(yip1E_9_uid172_atan2Test_b));
        ELSE
            yip1E_9_uid172_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_9_uid172_atan2Test_a) - SIGNED(yip1E_9_uid172_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_9_uid172_atan2Test_q <= yip1E_9_uid172_atan2Test_o(22 downto 0);

    -- yip1_9_uid178_atan2Test(BITSELECT,177)@9
    yip1_9_uid178_atan2Test_in <= STD_LOGIC_VECTOR(yip1E_9_uid172_atan2Test_q(20 downto 0));
    yip1_9_uid178_atan2Test_b <= STD_LOGIC_VECTOR(yip1_9_uid178_atan2Test_in(20 downto 0));

    -- redist6_yip1_9_uid178_atan2Test_b_1(DELAY,248)
    redist6_yip1_9_uid178_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 21, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yip1_9_uid178_atan2Test_b, xout => redist6_yip1_9_uid178_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- yip1E_10_uid189_atan2Test(ADDSUB,188)@10
    yip1E_10_uid189_atan2Test_s <= xMSB_uid180_atan2Test_b;
    yip1E_10_uid189_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 21 => redist6_yip1_9_uid178_atan2Test_b_1_q(20)) & redist6_yip1_9_uid178_atan2Test_b_1_q));
    yip1E_10_uid189_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000" & redist4_twoToMiSiXip_uid184_atan2Test_b_1_q));
    yip1E_10_uid189_atan2Test_combproc: PROCESS (yip1E_10_uid189_atan2Test_a, yip1E_10_uid189_atan2Test_b, yip1E_10_uid189_atan2Test_s)
    BEGIN
        IF (yip1E_10_uid189_atan2Test_s = "1") THEN
            yip1E_10_uid189_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_10_uid189_atan2Test_a) + SIGNED(yip1E_10_uid189_atan2Test_b));
        ELSE
            yip1E_10_uid189_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_10_uid189_atan2Test_a) - SIGNED(yip1E_10_uid189_atan2Test_b));
        END IF;
    END PROCESS;
    yip1E_10_uid189_atan2Test_q <= yip1E_10_uid189_atan2Test_o(21 downto 0);

    -- yip1_10_uid195_atan2Test(BITSELECT,194)@10
    yip1_10_uid195_atan2Test_in <= STD_LOGIC_VECTOR(yip1E_10_uid189_atan2Test_q(19 downto 0));
    yip1_10_uid195_atan2Test_b <= STD_LOGIC_VECTOR(yip1_10_uid195_atan2Test_in(19 downto 0));

    -- xMSB_uid197_atan2Test(BITSELECT,196)@10
    xMSB_uid197_atan2Test_b <= STD_LOGIC_VECTOR(yip1_10_uid195_atan2Test_b(19 downto 19));

    -- redist2_xMSB_uid197_atan2Test_b_1(DELAY,244)
    redist2_xMSB_uid197_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid197_atan2Test_b, xout => redist2_xMSB_uid197_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- invSignOfSelectionSignal_uid207_atan2Test(LOGICAL,206)@11
    invSignOfSelectionSignal_uid207_atan2Test_q <= not (redist2_xMSB_uid197_atan2Test_b_1_q);

    -- cstArcTan2Mi_10_uid203_atan2Test(CONSTANT,202)
    cstArcTan2Mi_10_uid203_atan2Test_q <= "011111111111111111111101010101";

    -- invSignOfSelectionSignal_uid190_atan2Test(LOGICAL,189)@10
    invSignOfSelectionSignal_uid190_atan2Test_q <= not (xMSB_uid180_atan2Test_b);

    -- cstArcTan2Mi_9_uid186_atan2Test(CONSTANT,185)
    cstArcTan2Mi_9_uid186_atan2Test_q <= "01111111111111111111010101011";

    -- cstArcTan2Mi_8_uid169_atan2Test(CONSTANT,168)
    cstArcTan2Mi_8_uid169_atan2Test_q <= "0111111111111111110101010101";

    -- cstArcTan2Mi_7_uid152_atan2Test(CONSTANT,151)
    cstArcTan2Mi_7_uid152_atan2Test_q <= "011111111111111101010101011";

    -- cstArcTan2Mi_6_uid135_atan2Test(CONSTANT,134)
    cstArcTan2Mi_6_uid135_atan2Test_q <= "01111111111111010101010110";

    -- cstArcTan2Mi_5_uid114_atan2Test(CONSTANT,113)
    cstArcTan2Mi_5_uid114_atan2Test_q <= "0111111111110101010101110";

    -- cstArcTan2Mi_4_uid93_atan2Test(CONSTANT,92)
    cstArcTan2Mi_4_uid93_atan2Test_q <= "011111111101010101101111";

    -- cstArcTan2Mi_3_uid74_atan2Test(CONSTANT,73)
    cstArcTan2Mi_3_uid74_atan2Test_q <= "01111111010101101110101";

    -- cstArcTan2Mi_2_uid55_atan2Test(CONSTANT,54)
    cstArcTan2Mi_2_uid55_atan2Test_q <= "0111110101101101110110";

    -- cstArcTan2Mi_1_uid36_atan2Test(CONSTANT,35)
    cstArcTan2Mi_1_uid36_atan2Test_q <= "011101101011000110100";

    -- cstArcTan2Mi_0_uid22_atan2Test(CONSTANT,21)
    cstArcTan2Mi_0_uid22_atan2Test_q <= "01100100100001111111";

    -- highBBits_uid26_atan2Test(BITSELECT,25)@2
    highBBits_uid26_atan2Test_b <= STD_LOGIC_VECTOR(cstArcTan2Mi_0_uid22_atan2Test_q(19 downto 19));

    -- lowRangeB_uid25_atan2Test(BITSELECT,24)@2
    lowRangeB_uid25_atan2Test_in <= cstArcTan2Mi_0_uid22_atan2Test_q(18 downto 0);
    lowRangeB_uid25_atan2Test_b <= lowRangeB_uid25_atan2Test_in(18 downto 0);

    -- aip1E_1_uid28_atan2Test(BITJOIN,27)@2
    aip1E_1_uid28_atan2Test_q <= STD_LOGIC_VECTOR((2 downto 1 => highBBits_uid26_atan2Test_b(0)) & highBBits_uid26_atan2Test_b) & lowRangeB_uid25_atan2Test_b;

    -- aip1E_uid31_atan2Test(BITSELECT,30)@2
    aip1E_uid31_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_1_uid28_atan2Test_q(20 downto 0));
    aip1E_uid31_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid31_atan2Test_in(20 downto 0));

    -- aip1E_2NA_uid46_atan2Test(BITJOIN,45)@2
    aip1E_2NA_uid46_atan2Test_q <= aip1E_uid31_atan2Test_b & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_2sumAHighB_uid47_atan2Test(ADDSUB,46)@2
    aip1E_2sumAHighB_uid47_atan2Test_s <= invSignOfSelectionSignal_uid37_atan2Test_q;
    aip1E_2sumAHighB_uid47_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 23 => aip1E_2NA_uid46_atan2Test_q(22)) & aip1E_2NA_uid46_atan2Test_q));
    aip1E_2sumAHighB_uid47_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 21 => cstArcTan2Mi_1_uid36_atan2Test_q(20)) & cstArcTan2Mi_1_uid36_atan2Test_q));
    aip1E_2sumAHighB_uid47_atan2Test_combproc: PROCESS (aip1E_2sumAHighB_uid47_atan2Test_a, aip1E_2sumAHighB_uid47_atan2Test_b, aip1E_2sumAHighB_uid47_atan2Test_s)
    BEGIN
        IF (aip1E_2sumAHighB_uid47_atan2Test_s = "1") THEN
            aip1E_2sumAHighB_uid47_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_2sumAHighB_uid47_atan2Test_a) + SIGNED(aip1E_2sumAHighB_uid47_atan2Test_b));
        ELSE
            aip1E_2sumAHighB_uid47_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_2sumAHighB_uid47_atan2Test_a) - SIGNED(aip1E_2sumAHighB_uid47_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_2sumAHighB_uid47_atan2Test_q <= aip1E_2sumAHighB_uid47_atan2Test_o(23 downto 0);

    -- aip1E_uid50_atan2Test(BITSELECT,49)@2
    aip1E_uid50_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_2sumAHighB_uid47_atan2Test_q(22 downto 0));
    aip1E_uid50_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid50_atan2Test_in(22 downto 0));

    -- redist25_aip1E_uid50_atan2Test_b_1(DELAY,267)
    redist25_aip1E_uid50_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid50_atan2Test_b, xout => redist25_aip1E_uid50_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_3NA_uid65_atan2Test(BITJOIN,64)@3
    aip1E_3NA_uid65_atan2Test_q <= redist25_aip1E_uid50_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_3sumAHighB_uid66_atan2Test(ADDSUB,65)@3
    aip1E_3sumAHighB_uid66_atan2Test_s <= invSignOfSelectionSignal_uid56_atan2Test_q;
    aip1E_3sumAHighB_uid66_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 25 => aip1E_3NA_uid65_atan2Test_q(24)) & aip1E_3NA_uid65_atan2Test_q));
    aip1E_3sumAHighB_uid66_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 22 => cstArcTan2Mi_2_uid55_atan2Test_q(21)) & cstArcTan2Mi_2_uid55_atan2Test_q));
    aip1E_3sumAHighB_uid66_atan2Test_combproc: PROCESS (aip1E_3sumAHighB_uid66_atan2Test_a, aip1E_3sumAHighB_uid66_atan2Test_b, aip1E_3sumAHighB_uid66_atan2Test_s)
    BEGIN
        IF (aip1E_3sumAHighB_uid66_atan2Test_s = "1") THEN
            aip1E_3sumAHighB_uid66_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_3sumAHighB_uid66_atan2Test_a) + SIGNED(aip1E_3sumAHighB_uid66_atan2Test_b));
        ELSE
            aip1E_3sumAHighB_uid66_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_3sumAHighB_uid66_atan2Test_a) - SIGNED(aip1E_3sumAHighB_uid66_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_3sumAHighB_uid66_atan2Test_q <= aip1E_3sumAHighB_uid66_atan2Test_o(25 downto 0);

    -- aip1E_uid69_atan2Test(BITSELECT,68)@3
    aip1E_uid69_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_3sumAHighB_uid66_atan2Test_q(24 downto 0));
    aip1E_uid69_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid69_atan2Test_in(24 downto 0));

    -- redist22_aip1E_uid69_atan2Test_b_1(DELAY,264)
    redist22_aip1E_uid69_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 25, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid69_atan2Test_b, xout => redist22_aip1E_uid69_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_4NA_uid84_atan2Test(BITJOIN,83)@4
    aip1E_4NA_uid84_atan2Test_q <= redist22_aip1E_uid69_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_4sumAHighB_uid85_atan2Test(ADDSUB,84)@4
    aip1E_4sumAHighB_uid85_atan2Test_s <= invSignOfSelectionSignal_uid75_atan2Test_q;
    aip1E_4sumAHighB_uid85_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((28 downto 27 => aip1E_4NA_uid84_atan2Test_q(26)) & aip1E_4NA_uid84_atan2Test_q));
    aip1E_4sumAHighB_uid85_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((28 downto 23 => cstArcTan2Mi_3_uid74_atan2Test_q(22)) & cstArcTan2Mi_3_uid74_atan2Test_q));
    aip1E_4sumAHighB_uid85_atan2Test_combproc: PROCESS (aip1E_4sumAHighB_uid85_atan2Test_a, aip1E_4sumAHighB_uid85_atan2Test_b, aip1E_4sumAHighB_uid85_atan2Test_s)
    BEGIN
        IF (aip1E_4sumAHighB_uid85_atan2Test_s = "1") THEN
            aip1E_4sumAHighB_uid85_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_4sumAHighB_uid85_atan2Test_a) + SIGNED(aip1E_4sumAHighB_uid85_atan2Test_b));
        ELSE
            aip1E_4sumAHighB_uid85_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_4sumAHighB_uid85_atan2Test_a) - SIGNED(aip1E_4sumAHighB_uid85_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_4sumAHighB_uid85_atan2Test_q <= aip1E_4sumAHighB_uid85_atan2Test_o(27 downto 0);

    -- aip1E_uid88_atan2Test(BITSELECT,87)@4
    aip1E_uid88_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_4sumAHighB_uid85_atan2Test_q(26 downto 0));
    aip1E_uid88_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid88_atan2Test_in(26 downto 0));

    -- redist19_aip1E_uid88_atan2Test_b_1(DELAY,261)
    redist19_aip1E_uid88_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 27, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid88_atan2Test_b, xout => redist19_aip1E_uid88_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_5NA_uid103_atan2Test(BITJOIN,102)@5
    aip1E_5NA_uid103_atan2Test_q <= redist19_aip1E_uid88_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_5sumAHighB_uid104_atan2Test(ADDSUB,103)@5
    aip1E_5sumAHighB_uid104_atan2Test_s <= invSignOfSelectionSignal_uid94_atan2Test_q;
    aip1E_5sumAHighB_uid104_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 29 => aip1E_5NA_uid103_atan2Test_q(28)) & aip1E_5NA_uid103_atan2Test_q));
    aip1E_5sumAHighB_uid104_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 24 => cstArcTan2Mi_4_uid93_atan2Test_q(23)) & cstArcTan2Mi_4_uid93_atan2Test_q));
    aip1E_5sumAHighB_uid104_atan2Test_combproc: PROCESS (aip1E_5sumAHighB_uid104_atan2Test_a, aip1E_5sumAHighB_uid104_atan2Test_b, aip1E_5sumAHighB_uid104_atan2Test_s)
    BEGIN
        IF (aip1E_5sumAHighB_uid104_atan2Test_s = "1") THEN
            aip1E_5sumAHighB_uid104_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_5sumAHighB_uid104_atan2Test_a) + SIGNED(aip1E_5sumAHighB_uid104_atan2Test_b));
        ELSE
            aip1E_5sumAHighB_uid104_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_5sumAHighB_uid104_atan2Test_a) - SIGNED(aip1E_5sumAHighB_uid104_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_5sumAHighB_uid104_atan2Test_q <= aip1E_5sumAHighB_uid104_atan2Test_o(29 downto 0);

    -- aip1E_uid107_atan2Test(BITSELECT,106)@5
    aip1E_uid107_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_5sumAHighB_uid104_atan2Test_q(28 downto 0));
    aip1E_uid107_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid107_atan2Test_in(28 downto 0));

    -- redist16_aip1E_uid107_atan2Test_b_1(DELAY,258)
    redist16_aip1E_uid107_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 29, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid107_atan2Test_b, xout => redist16_aip1E_uid107_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_6NA_uid124_atan2Test(BITJOIN,123)@6
    aip1E_6NA_uid124_atan2Test_q <= redist16_aip1E_uid107_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_6sumAHighB_uid125_atan2Test(ADDSUB,124)@6
    aip1E_6sumAHighB_uid125_atan2Test_s <= invSignOfSelectionSignal_uid115_atan2Test_q;
    aip1E_6sumAHighB_uid125_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => aip1E_6NA_uid124_atan2Test_q(30)) & aip1E_6NA_uid124_atan2Test_q));
    aip1E_6sumAHighB_uid125_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 25 => cstArcTan2Mi_5_uid114_atan2Test_q(24)) & cstArcTan2Mi_5_uid114_atan2Test_q));
    aip1E_6sumAHighB_uid125_atan2Test_combproc: PROCESS (aip1E_6sumAHighB_uid125_atan2Test_a, aip1E_6sumAHighB_uid125_atan2Test_b, aip1E_6sumAHighB_uid125_atan2Test_s)
    BEGIN
        IF (aip1E_6sumAHighB_uid125_atan2Test_s = "1") THEN
            aip1E_6sumAHighB_uid125_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_6sumAHighB_uid125_atan2Test_a) + SIGNED(aip1E_6sumAHighB_uid125_atan2Test_b));
        ELSE
            aip1E_6sumAHighB_uid125_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_6sumAHighB_uid125_atan2Test_a) - SIGNED(aip1E_6sumAHighB_uid125_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_6sumAHighB_uid125_atan2Test_q <= aip1E_6sumAHighB_uid125_atan2Test_o(31 downto 0);

    -- aip1E_uid128_atan2Test(BITSELECT,127)@6
    aip1E_uid128_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_6sumAHighB_uid125_atan2Test_q(30 downto 0));
    aip1E_uid128_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid128_atan2Test_in(30 downto 0));

    -- redist13_aip1E_uid128_atan2Test_b_1(DELAY,255)
    redist13_aip1E_uid128_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 31, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid128_atan2Test_b, xout => redist13_aip1E_uid128_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_7NA_uid141_atan2Test(BITJOIN,140)@7
    aip1E_7NA_uid141_atan2Test_q <= redist13_aip1E_uid128_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_7sumAHighB_uid142_atan2Test(ADDSUB,141)@7
    aip1E_7sumAHighB_uid142_atan2Test_s <= invSignOfSelectionSignal_uid136_atan2Test_q;
    aip1E_7sumAHighB_uid142_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 33 => aip1E_7NA_uid141_atan2Test_q(32)) & aip1E_7NA_uid141_atan2Test_q));
    aip1E_7sumAHighB_uid142_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 26 => cstArcTan2Mi_6_uid135_atan2Test_q(25)) & cstArcTan2Mi_6_uid135_atan2Test_q));
    aip1E_7sumAHighB_uid142_atan2Test_combproc: PROCESS (aip1E_7sumAHighB_uid142_atan2Test_a, aip1E_7sumAHighB_uid142_atan2Test_b, aip1E_7sumAHighB_uid142_atan2Test_s)
    BEGIN
        IF (aip1E_7sumAHighB_uid142_atan2Test_s = "1") THEN
            aip1E_7sumAHighB_uid142_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_7sumAHighB_uid142_atan2Test_a) + SIGNED(aip1E_7sumAHighB_uid142_atan2Test_b));
        ELSE
            aip1E_7sumAHighB_uid142_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_7sumAHighB_uid142_atan2Test_a) - SIGNED(aip1E_7sumAHighB_uid142_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_7sumAHighB_uid142_atan2Test_q <= aip1E_7sumAHighB_uid142_atan2Test_o(33 downto 0);

    -- aip1E_uid145_atan2Test(BITSELECT,144)@7
    aip1E_uid145_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_7sumAHighB_uid142_atan2Test_q(32 downto 0));
    aip1E_uid145_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid145_atan2Test_in(32 downto 0));

    -- redist10_aip1E_uid145_atan2Test_b_1(DELAY,252)
    redist10_aip1E_uid145_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 33, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid145_atan2Test_b, xout => redist10_aip1E_uid145_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_8NA_uid158_atan2Test(BITJOIN,157)@8
    aip1E_8NA_uid158_atan2Test_q <= redist10_aip1E_uid145_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_8sumAHighB_uid159_atan2Test(ADDSUB,158)@8
    aip1E_8sumAHighB_uid159_atan2Test_s <= invSignOfSelectionSignal_uid153_atan2Test_q;
    aip1E_8sumAHighB_uid159_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((36 downto 35 => aip1E_8NA_uid158_atan2Test_q(34)) & aip1E_8NA_uid158_atan2Test_q));
    aip1E_8sumAHighB_uid159_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((36 downto 27 => cstArcTan2Mi_7_uid152_atan2Test_q(26)) & cstArcTan2Mi_7_uid152_atan2Test_q));
    aip1E_8sumAHighB_uid159_atan2Test_combproc: PROCESS (aip1E_8sumAHighB_uid159_atan2Test_a, aip1E_8sumAHighB_uid159_atan2Test_b, aip1E_8sumAHighB_uid159_atan2Test_s)
    BEGIN
        IF (aip1E_8sumAHighB_uid159_atan2Test_s = "1") THEN
            aip1E_8sumAHighB_uid159_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_8sumAHighB_uid159_atan2Test_a) + SIGNED(aip1E_8sumAHighB_uid159_atan2Test_b));
        ELSE
            aip1E_8sumAHighB_uid159_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_8sumAHighB_uid159_atan2Test_a) - SIGNED(aip1E_8sumAHighB_uid159_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_8sumAHighB_uid159_atan2Test_q <= aip1E_8sumAHighB_uid159_atan2Test_o(35 downto 0);

    -- aip1E_uid162_atan2Test(BITSELECT,161)@8
    aip1E_uid162_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_8sumAHighB_uid159_atan2Test_q(34 downto 0));
    aip1E_uid162_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid162_atan2Test_in(34 downto 0));

    -- redist7_aip1E_uid162_atan2Test_b_1(DELAY,249)
    redist7_aip1E_uid162_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 35, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid162_atan2Test_b, xout => redist7_aip1E_uid162_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_9NA_uid175_atan2Test(BITJOIN,174)@9
    aip1E_9NA_uid175_atan2Test_q <= redist7_aip1E_uid162_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_9sumAHighB_uid176_atan2Test(ADDSUB,175)@9
    aip1E_9sumAHighB_uid176_atan2Test_s <= invSignOfSelectionSignal_uid170_atan2Test_q;
    aip1E_9sumAHighB_uid176_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((38 downto 37 => aip1E_9NA_uid175_atan2Test_q(36)) & aip1E_9NA_uid175_atan2Test_q));
    aip1E_9sumAHighB_uid176_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((38 downto 28 => cstArcTan2Mi_8_uid169_atan2Test_q(27)) & cstArcTan2Mi_8_uid169_atan2Test_q));
    aip1E_9sumAHighB_uid176_atan2Test_combproc: PROCESS (aip1E_9sumAHighB_uid176_atan2Test_a, aip1E_9sumAHighB_uid176_atan2Test_b, aip1E_9sumAHighB_uid176_atan2Test_s)
    BEGIN
        IF (aip1E_9sumAHighB_uid176_atan2Test_s = "1") THEN
            aip1E_9sumAHighB_uid176_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_9sumAHighB_uid176_atan2Test_a) + SIGNED(aip1E_9sumAHighB_uid176_atan2Test_b));
        ELSE
            aip1E_9sumAHighB_uid176_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_9sumAHighB_uid176_atan2Test_a) - SIGNED(aip1E_9sumAHighB_uid176_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_9sumAHighB_uid176_atan2Test_q <= aip1E_9sumAHighB_uid176_atan2Test_o(37 downto 0);

    -- aip1E_uid179_atan2Test(BITSELECT,178)@9
    aip1E_uid179_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_9sumAHighB_uid176_atan2Test_q(36 downto 0));
    aip1E_uid179_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid179_atan2Test_in(36 downto 0));

    -- redist5_aip1E_uid179_atan2Test_b_1(DELAY,247)
    redist5_aip1E_uid179_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 37, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid179_atan2Test_b, xout => redist5_aip1E_uid179_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_10NA_uid192_atan2Test(BITJOIN,191)@10
    aip1E_10NA_uid192_atan2Test_q <= redist5_aip1E_uid179_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_10sumAHighB_uid193_atan2Test(ADDSUB,192)@10
    aip1E_10sumAHighB_uid193_atan2Test_s <= invSignOfSelectionSignal_uid190_atan2Test_q;
    aip1E_10sumAHighB_uid193_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((40 downto 39 => aip1E_10NA_uid192_atan2Test_q(38)) & aip1E_10NA_uid192_atan2Test_q));
    aip1E_10sumAHighB_uid193_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((40 downto 29 => cstArcTan2Mi_9_uid186_atan2Test_q(28)) & cstArcTan2Mi_9_uid186_atan2Test_q));
    aip1E_10sumAHighB_uid193_atan2Test_combproc: PROCESS (aip1E_10sumAHighB_uid193_atan2Test_a, aip1E_10sumAHighB_uid193_atan2Test_b, aip1E_10sumAHighB_uid193_atan2Test_s)
    BEGIN
        IF (aip1E_10sumAHighB_uid193_atan2Test_s = "1") THEN
            aip1E_10sumAHighB_uid193_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_10sumAHighB_uid193_atan2Test_a) + SIGNED(aip1E_10sumAHighB_uid193_atan2Test_b));
        ELSE
            aip1E_10sumAHighB_uid193_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_10sumAHighB_uid193_atan2Test_a) - SIGNED(aip1E_10sumAHighB_uid193_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_10sumAHighB_uid193_atan2Test_q <= aip1E_10sumAHighB_uid193_atan2Test_o(39 downto 0);

    -- aip1E_uid196_atan2Test(BITSELECT,195)@10
    aip1E_uid196_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_10sumAHighB_uid193_atan2Test_q(38 downto 0));
    aip1E_uid196_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid196_atan2Test_in(38 downto 0));

    -- redist3_aip1E_uid196_atan2Test_b_1(DELAY,245)
    redist3_aip1E_uid196_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 39, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid196_atan2Test_b, xout => redist3_aip1E_uid196_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- aip1E_11NA_uid209_atan2Test(BITJOIN,208)@11
    aip1E_11NA_uid209_atan2Test_q <= redist3_aip1E_uid196_atan2Test_b_1_q & aip1E_2CostZeroPaddingA_uid45_atan2Test_q;

    -- aip1E_11sumAHighB_uid210_atan2Test(ADDSUB,209)@11
    aip1E_11sumAHighB_uid210_atan2Test_s <= invSignOfSelectionSignal_uid207_atan2Test_q;
    aip1E_11sumAHighB_uid210_atan2Test_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((42 downto 41 => aip1E_11NA_uid209_atan2Test_q(40)) & aip1E_11NA_uid209_atan2Test_q));
    aip1E_11sumAHighB_uid210_atan2Test_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((42 downto 30 => cstArcTan2Mi_10_uid203_atan2Test_q(29)) & cstArcTan2Mi_10_uid203_atan2Test_q));
    aip1E_11sumAHighB_uid210_atan2Test_combproc: PROCESS (aip1E_11sumAHighB_uid210_atan2Test_a, aip1E_11sumAHighB_uid210_atan2Test_b, aip1E_11sumAHighB_uid210_atan2Test_s)
    BEGIN
        IF (aip1E_11sumAHighB_uid210_atan2Test_s = "1") THEN
            aip1E_11sumAHighB_uid210_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_11sumAHighB_uid210_atan2Test_a) + SIGNED(aip1E_11sumAHighB_uid210_atan2Test_b));
        ELSE
            aip1E_11sumAHighB_uid210_atan2Test_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_11sumAHighB_uid210_atan2Test_a) - SIGNED(aip1E_11sumAHighB_uid210_atan2Test_b));
        END IF;
    END PROCESS;
    aip1E_11sumAHighB_uid210_atan2Test_q <= aip1E_11sumAHighB_uid210_atan2Test_o(41 downto 0);

    -- aip1E_uid213_atan2Test(BITSELECT,212)@11
    aip1E_uid213_atan2Test_in <= STD_LOGIC_VECTOR(aip1E_11sumAHighB_uid210_atan2Test_q(40 downto 0));
    aip1E_uid213_atan2Test_b <= STD_LOGIC_VECTOR(aip1E_uid213_atan2Test_in(40 downto 0));

    -- alphaPreRnd_uid214_atan2Test(BITSELECT,213)@11
    alphaPreRnd_uid214_atan2Test_b <= aip1E_uid213_atan2Test_b(40 downto 29);

    -- redist1_alphaPreRnd_uid214_atan2Test_b_1(DELAY,243)
    redist1_alphaPreRnd_uid214_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 12, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => alphaPreRnd_uid214_atan2Test_b, xout => redist1_alphaPreRnd_uid214_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- lowRangeA_uid218_atan2Test_merged_bit_select(BITSELECT,241)@12
    lowRangeA_uid218_atan2Test_merged_bit_select_b <= redist1_alphaPreRnd_uid214_atan2Test_b_1_q(0 downto 0);
    lowRangeA_uid218_atan2Test_merged_bit_select_c <= redist1_alphaPreRnd_uid214_atan2Test_b_1_q(11 downto 1);

    -- alphaPostRnd_uid221_atan2Test(BITJOIN,220)@12
    alphaPostRnd_uid221_atan2Test_q <= alphaPostRndhigh_uid220_atan2Test_q & lowRangeA_uid218_atan2Test_merged_bit_select_b;

    -- atanRes_uid222_atan2Test(BITSELECT,221)@12
    atanRes_uid222_atan2Test_in <= alphaPostRnd_uid221_atan2Test_q(11 downto 0);
    atanRes_uid222_atan2Test_b <= atanRes_uid222_atan2Test_in(11 downto 0);

    -- redist0_atanRes_uid222_atan2Test_b_1(DELAY,242)
    redist0_atanRes_uid222_atan2Test_b_1 : dspba_delay
    GENERIC MAP ( width => 12, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => atanRes_uid222_atan2Test_b, xout => redist0_atanRes_uid222_atan2Test_b_1_q, clk => clk, aclr => areset );

    -- xNotZero_uid17_atan2Test(LOGICAL,16)@0 + 1
    xNotZero_uid17_atan2Test_qi <= "1" WHEN x /= "0000000000000000" ELSE "0";
    xNotZero_uid17_atan2Test_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xNotZero_uid17_atan2Test_qi, xout => xNotZero_uid17_atan2Test_q, clk => clk, aclr => areset );

    -- redist28_xNotZero_uid17_atan2Test_q_13(DELAY,270)
    redist28_xNotZero_uid17_atan2Test_q_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 12, reset_kind => "ASYNC" )
    PORT MAP ( xin => xNotZero_uid17_atan2Test_q, xout => redist28_xNotZero_uid17_atan2Test_q_13_q, clk => clk, aclr => areset );

    -- xZero_uid18_atan2Test(LOGICAL,17)@13
    xZero_uid18_atan2Test_q <= not (redist28_xNotZero_uid17_atan2Test_q_13_q);

    -- yNotZero_uid15_atan2Test(LOGICAL,14)@0 + 1
    yNotZero_uid15_atan2Test_qi <= "1" WHEN y /= "0000000000000000" ELSE "0";
    yNotZero_uid15_atan2Test_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yNotZero_uid15_atan2Test_qi, xout => yNotZero_uid15_atan2Test_q, clk => clk, aclr => areset );

    -- redist29_yNotZero_uid15_atan2Test_q_13(DELAY,271)
    redist29_yNotZero_uid15_atan2Test_q_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 12, reset_kind => "ASYNC" )
    PORT MAP ( xin => yNotZero_uid15_atan2Test_q, xout => redist29_yNotZero_uid15_atan2Test_q_13_q, clk => clk, aclr => areset );

    -- yZero_uid16_atan2Test(LOGICAL,15)@13
    yZero_uid16_atan2Test_q <= not (redist29_yNotZero_uid15_atan2Test_q_13_q);

    -- concXZeroYZero_uid229_atan2Test(BITJOIN,228)@13
    concXZeroYZero_uid229_atan2Test_q <= xZero_uid18_atan2Test_q & yZero_uid16_atan2Test_q;

    -- atanResPostExc_uid230_atan2Test(MUX,229)@13
    atanResPostExc_uid230_atan2Test_s <= concXZeroYZero_uid229_atan2Test_q;
    atanResPostExc_uid230_atan2Test_combproc: PROCESS (atanResPostExc_uid230_atan2Test_s, redist0_atanRes_uid222_atan2Test_b_1_q, cstZeroOutFormat_uid223_atan2Test_q, constPio2P2u_mergedSignalTM_uid227_atan2Test_q)
    BEGIN
        CASE (atanResPostExc_uid230_atan2Test_s) IS
            WHEN "00" => atanResPostExc_uid230_atan2Test_q <= redist0_atanRes_uid222_atan2Test_b_1_q;
            WHEN "01" => atanResPostExc_uid230_atan2Test_q <= cstZeroOutFormat_uid223_atan2Test_q;
            WHEN "10" => atanResPostExc_uid230_atan2Test_q <= constPio2P2u_mergedSignalTM_uid227_atan2Test_q;
            WHEN "11" => atanResPostExc_uid230_atan2Test_q <= cstZeroOutFormat_uid223_atan2Test_q;
            WHEN OTHERS => atanResPostExc_uid230_atan2Test_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- constantZeroOutFormat_uid234_atan2Test(CONSTANT,233)
    constantZeroOutFormat_uid234_atan2Test_q <= "000000000000";

    -- redist33_signX_uid7_atan2Test_b_13(DELAY,275)
    redist33_signX_uid7_atan2Test_b_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 13, reset_kind => "ASYNC" )
    PORT MAP ( xin => signX_uid7_atan2Test_b, xout => redist33_signX_uid7_atan2Test_b_13_q, clk => clk, aclr => areset );

    -- redist32_signY_uid8_atan2Test_b_13(DELAY,274)
    redist32_signY_uid8_atan2Test_b_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 13, reset_kind => "ASYNC" )
    PORT MAP ( xin => signY_uid8_atan2Test_b, xout => redist32_signY_uid8_atan2Test_b_13_q, clk => clk, aclr => areset );

    -- concSigns_uid231_atan2Test(BITJOIN,230)@13
    concSigns_uid231_atan2Test_q <= redist33_signX_uid7_atan2Test_b_13_q & redist32_signY_uid8_atan2Test_b_13_q;

    -- secondOperand_uid238_atan2Test(MUX,237)@13 + 1
    secondOperand_uid238_atan2Test_s <= concSigns_uid231_atan2Test_q;
    secondOperand_uid238_atan2Test_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            secondOperand_uid238_atan2Test_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (secondOperand_uid238_atan2Test_s) IS
                WHEN "00" => secondOperand_uid238_atan2Test_q <= constantZeroOutFormat_uid234_atan2Test_q;
                WHEN "01" => secondOperand_uid238_atan2Test_q <= atanResPostExc_uid230_atan2Test_q;
                WHEN "10" => secondOperand_uid238_atan2Test_q <= atanResPostExc_uid230_atan2Test_q;
                WHEN "11" => secondOperand_uid238_atan2Test_q <= constPi_uid233_atan2Test_q;
                WHEN OTHERS => secondOperand_uid238_atan2Test_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- constPiP2u_uid232_atan2Test(CONSTANT,231)
    constPiP2u_uid232_atan2Test_q <= "110010010100";

    -- constantZeroOutFormatP2u_uid235_atan2Test(CONSTANT,234)
    constantZeroOutFormatP2u_uid235_atan2Test_q <= "000000000100";

    -- firstOperand_uid237_atan2Test(MUX,236)@13 + 1
    firstOperand_uid237_atan2Test_s <= concSigns_uid231_atan2Test_q;
    firstOperand_uid237_atan2Test_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            firstOperand_uid237_atan2Test_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (firstOperand_uid237_atan2Test_s) IS
                WHEN "00" => firstOperand_uid237_atan2Test_q <= atanResPostExc_uid230_atan2Test_q;
                WHEN "01" => firstOperand_uid237_atan2Test_q <= constantZeroOutFormatP2u_uid235_atan2Test_q;
                WHEN "10" => firstOperand_uid237_atan2Test_q <= constPiP2u_uid232_atan2Test_q;
                WHEN "11" => firstOperand_uid237_atan2Test_q <= atanResPostExc_uid230_atan2Test_q;
                WHEN OTHERS => firstOperand_uid237_atan2Test_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- outResExtended_uid239_atan2Test(SUB,238)@14
    outResExtended_uid239_atan2Test_a <= STD_LOGIC_VECTOR("0" & firstOperand_uid237_atan2Test_q);
    outResExtended_uid239_atan2Test_b <= STD_LOGIC_VECTOR("0" & secondOperand_uid238_atan2Test_q);
    outResExtended_uid239_atan2Test_o <= STD_LOGIC_VECTOR(UNSIGNED(outResExtended_uid239_atan2Test_a) - UNSIGNED(outResExtended_uid239_atan2Test_b));
    outResExtended_uid239_atan2Test_q <= outResExtended_uid239_atan2Test_o(12 downto 0);

    -- atanResPostRR_uid240_atan2Test(BITSELECT,239)@14
    atanResPostRR_uid240_atan2Test_b <= STD_LOGIC_VECTOR(outResExtended_uid239_atan2Test_q(12 downto 2));

    -- xOut(GPOUT,4)@14
    q <= atanResPostRR_uid240_atan2Test_b;

END normal;
