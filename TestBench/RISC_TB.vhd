
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee. std_logic_textio.all;
use IEEE.std_logic_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RISC_TB is
--  Port ( );
end RISC_TB;

architecture Behavioral of RISC_TB is

component  RISC_Main is
 Port (    clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           interrupt : in STD_LOGIC;
           
           -------Instruction Memory related---------------------------
           
           instruction : out STD_LOGIC_VECTOR (15 downto 0); ---from instruction memory 
           Pc_value    : out STD_LOGIC_VECTOR (9 downto 0);    --- to instruction memory
           Im_WA    : in STD_LOGIC_VECTOR (9 downto 0); 
           Im_WE    : in STD_LOGIC;
           Im_WD    : in STD_LOGIC_VECTOR (15 downto 0);
           --------data memory related---------------------------------
           
           data_memory_read : out std_logic_vector(7 downto 0); ---read data from data memory
           mem_write_en     : out STD_LOGIC;                   ---- to data memory 
           mem_read_add     : out std_logic_vector(7 downto 0);
           mem_write_add    : out std_logic_vector(7 downto 0);
           mem_write_data   : out std_logic_vector(7 downto 0)
           
           ------ALU Output (just for debugging)------------------------
         --  ALU_Output       : out std_logic_vector(7 downto 0)      
          
         ); 
end component  RISC_Main;

signal clk,interrupt, IM_WE : STD_LOGIC:='0';
signal rst : STD_LOGIC:='1';
signal mem_write_en: std_logic;
signal instruction:STD_LOGIC_VECTOR (15 downto 0);
signal Pc_value: STD_LOGIC_VECTOR (9 downto 0);
signal data_memory_read,mem_read_add,mem_write_add,mem_write_data:std_logic_vector(7 downto 0);
signal Im_WA:STD_LOGIC_VECTOR (9 downto 0):="0000000000";
signal Im_WD:STD_LOGIC_VECTOR (15 downto 0):=x"0000";

constant period:time := 20 ns;
constant setup: time := 4  ns;


begin

DUT: RISC_Main port map
           (  clk=>clk,
           rst =>rst,
           interrupt=>interrupt,
           
           -------Instruction Memory related---------------------------
           
           instruction=>instruction, 
           Pc_value=>Pc_value,
           Im_WA=>Im_WA, 
           Im_WE=> Im_WE,
           Im_WD=>Im_WD,
           --------data memory related---------------------------------
           
           data_memory_read=>data_memory_read,
           mem_write_en =>mem_write_en   ,
           mem_read_add =>mem_read_add  ,
           mem_write_add=>mem_write_add   ,
           mem_write_data =>mem_write_data            
           ------ALU Output (just for debugging)------------------------
        --   ALU_Output   =>ALU_Output         
          
         ); 



process
begin 
wait for 100ns;
cloop: loop 
Clk<='0';
wait for (period/2) ;
Clk<='1';
wait for (period/2);
end loop;
end process;


process 
file test_vector                : text open read_mode is "Instr.txt";
variable row                    : line;
variable address                : integer;
variable instr_data             : std_logic_vector(15 downto 0);

begin 
wait for 500ns;
wait for (5*period) ;

while( not endfile(test_vector)) loop
readline(test_vector,row);
read(row,address);
read(row,instr_data); 
Im_WA<=std_logic_vector(to_unsigned(address, Im_WA'length));
Im_WD<=instr_data;
Im_WE<='1';
wait for (2*period);
end loop;
Im_WA<="0000000000";
Im_WD<=x"0000";
Im_WE<='0';
wait for (2*period);
wait for (period/2- setup);
Rst<='0';
wait for 100 ns;
interrupt<='1';
wait for 3 ns;
interrupt<='0';
wait ;
 
end process;




end Behavioral;
