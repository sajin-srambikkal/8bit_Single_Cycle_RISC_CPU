
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RISC_CPU  is
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
end RISC_CPU;

architecture Behavioral of RISC_CPU is

component Interrupt_Synchr is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Interrupt : in STD_LOGIC;
           Int_Syn_Pulse : out STD_LOGIC
           );

end component;


component Controller_and_decoder is
    Port ( clk : in STD_LOGIC;
           Instruction_temp : in STD_LOGIC_VECTOR (4 downto 0);
           reset : in STD_LOGIC;
           Int_Syn_Pulse : in STD_LOGIC;
           PC_Sel_Control : out STD_LOGIC_VECTOR(1 downto 0);
           PC_Int_Save : out STD_LOGIC;
           ALU_Op_Sel : out STD_LOGIC_VECTOR (2 downto 0);
           Reg_Write_En : out STD_LOGIC;
           Memory_Write_En : out STD_LOGIC);
end Component;

component data_path is

    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Instruction:in std_logic_vector(15 downto 0);
           --from Controller----
           reg_write_en : in STD_LOGIC;
           pc_int_save : in std_logic;
           pc_mux_Sel : in STD_LOGIC_VECTOR (1 downto 0);
           alu_cntrl_sel : in STD_LOGIC_VECTOR (2 downto 0);
           --from memory-------------------------------------           
           data_memory_read: in std_logic_vector(7 downto 0);
           --to memory-----
           Imm_Load_Addr : out STD_LOGIC_VECTOR (7 downto 0);
           Store_Addr : out STD_LOGIC_VECTOR (7 downto 0);
           mem_write_data: out std_logic_vector(7 downto 0); 
           pc : out STD_LOGIC_VECTOR (9 downto 0)
           
           );
end component data_path;

-- interrupt block signal
signal temp_int_syn_pulse : std_logic;

---
 signal temp_reg_write_en : std_logic;
 signal temp_pc_mux_sel : std_logic_vector(1 downto 0);
 signal temp_alu_cntrl_sel :std_logic_vector(2 downto 0);
 signal temp_pc_int_save : std_logic;
----
    
begin


uut1 : Interrupt_Synchr port map ( --input signals
                                  clk => clk , reset => rst , interrupt => interrupt , 
                                  -- output signa
                                int_syn_pulse => temp_int_syn_pulse);

uut2 : Controller_and_decoder port map ( 
                                         -- input signals of controller
                                         clk => clk, reset => rst ,
                                         Instruction_temp => instruction (15 downto 11),  
                                         Int_Syn_Pulse => temp_int_syn_pulse,
                                         
                                         --output signals of controller
                                         PC_Sel_Control => temp_pc_mux_sel ,
                                         PC_Int_Save =>  temp_pc_int_save,
                                         ALU_Op_Sel => temp_alu_cntrl_sel,
                                         Reg_Write_En => temp_reg_write_en,
                                         Memory_Write_En => mem_write_en); 

uut3: data_path   port map ( clk => clk,
           rst =>rst,
           Instruction=>Instruction,
           --from Controller----
           reg_write_en =>temp_reg_write_en,
           pc_int_save =>  temp_pc_int_save,
           pc_mux_Sel => temp_pc_mux_sel ,
           alu_cntrl_sel => temp_alu_cntrl_sel,
           --from memory-------------------------------------           
           data_memory_read=>data_memory_read,
           --to memory-----
           Imm_Load_Addr =>mem_read_add,
           Store_Addr=> mem_write_add,
           mem_write_data=>mem_write_data, 
           pc =>Pc_value
           );

end Behavioral;
