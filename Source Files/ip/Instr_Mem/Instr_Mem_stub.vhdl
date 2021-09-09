-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Wed May 26 19:19:22 2021
-- Host        : LAPTOP-BGBH2RQR running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {d:/Mtech_IISC_DESE_2020_2022/2nd Semester/Digital Design With
--               FPGA/FPGA Project/RISC_Project_Final/RISC_Project_Final.gen/sources_1/ip/Instr_Mem/Instr_Mem_stub.vhdl}
-- Design      : Instr_Mem
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Instr_Mem is
  Port ( 
    a : in STD_LOGIC_VECTOR ( 9 downto 0 );
    d : in STD_LOGIC_VECTOR ( 15 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 9 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    dpo : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );

end Instr_Mem;

architecture stub of Instr_Mem is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "a[9:0],d[15:0],dpra[9:0],clk,we,dpo[15:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dist_mem_gen_v8_0_13,Vivado 2020.2";
begin
end;
