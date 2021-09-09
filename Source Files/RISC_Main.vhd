
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RISC_Main is
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
end RISC_Main;

architecture Behavioral of RISC_Main is

signal temp_data_memory_read,temp_mem_read_add,temp_mem_write_add:std_logic_vector(7 downto 0);
signal temp_mem_write_data,temp_ALU_Output:std_logic_vector(7 downto 0);
signal temp_instruction:STD_LOGIC_VECTOR (15 downto 0);
signal temp_pc_value   :STD_LOGIC_VECTOR (9 downto 0);
signal Temp_mem_write_en:std_logic;


component Risc_CPU is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           interrupt : in STD_LOGIC;
           
           -------Instruction Memory related---------------------------
           instruction : in STD_LOGIC_VECTOR (15 downto 0); ---from instruction memory 
           Pc_value    : out STD_LOGIC_VECTOR (9 downto 0);    --- to instruction memory
           
           --------data memory related---------------------------------
           
           data_memory_read : in std_logic_vector(7 downto 0); ---read data from data memory
           mem_write_en     : out STD_LOGIC;                   ---- to data memory 
           mem_read_add    : out std_logic_vector(7 downto 0);
           mem_write_add    : out std_logic_vector(7 downto 0);
           mem_write_data   : out std_logic_vector(7 downto 0)
          
          
         );
end component Risc_CPU;

COMPONENT Instr_Mem
  PORT (
    a : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    dpra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    dpo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Data_Mem
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dpra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    dpo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

begin


U1: Data_Mem
  PORT MAP (
    a => temp_mem_write_add,
    d => temp_mem_write_data,
    dpra => temp_mem_read_add,
    clk => clk,
    we => Temp_mem_write_en,
    dpo => temp_data_memory_read
  );
  
U2: Instr_Mem
  PORT MAP (
    a => IM_WA,
    d => IM_WD,
    dpra => temp_pc_value,
    clk => clk,
    we => IM_WE,
    dpo => temp_instruction
  );
  
  U3: Risc_CPU PORT MAP
           ( clk =>clk,
           rst =>rst,
           interrupt =>     interrupt,
           
           -------Instruction Memory related---------------------------
           instruction =>    temp_instruction,
           Pc_value    =>    temp_pc_value,
           
           --------data memory related---------------------------------
           
           data_memory_read =>  temp_data_memory_read,
           mem_write_en     =>  Temp_mem_write_en,
           mem_read_add     =>  temp_mem_read_add,
           mem_write_add    =>  temp_mem_write_add,
           mem_write_data   =>  temp_mem_write_data
           

          
         );


--ALU_Output<=temp_ALU_Output;
data_memory_read <=  temp_data_memory_read;
mem_write_en     <=  Temp_mem_write_en;
mem_read_add     <=  temp_mem_read_add;
mem_write_add    <=  temp_mem_write_add;
mem_write_data   <=  temp_mem_write_data;
instruction <=    temp_instruction;
Pc_value    <=    temp_pc_value;


end Behavioral;
