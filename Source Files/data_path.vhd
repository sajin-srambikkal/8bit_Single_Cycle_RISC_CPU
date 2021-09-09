
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_path is

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
end data_path;

architecture Behavioral of data_path is



--signal declaration for Register file
signal temp_Write_Reg_Data : std_logic_vector (7 downto 0); -- this contains the output of register_write mux block,
signal temp_RegA_Out : std_logic_vector (7 downto 0);
signal temp_RegB_Out : std_logic_vector (7 downto 0);

-- signal declaration for alu mux sel out 
signal alu_mux_sel_out : std_logic_vector (7 downto 0);

--signal declaration for alu output
signal temp_alu_outdata : std_logic_vector (7 downto 0);
signal Int_zero_restore: std_logic;

---Signal Declaration for Decoding----------------------
signal temp_RegAaddr, temp_RegBaddr,temp_write_Reg_addr : STD_LOGIC_VECTOR (2 downto 0);
signal temp_pc_jump_addr :STD_LOGIC_VECTOR (9 downto 0);
signal temp_pc_branch_sel :std_logic;
signal temp_Imm_Load_Addr,temp_data_imm: STD_LOGIC_VECTOR (7 downto 0);
signal temp_reg_write_mux_sel: STD_LOGIC_VECTOR(1 downto 0);
signal temp_ALU_Mux_Sel : std_logic;
signal temp_zero,temp_ALU_Valid      : std_logic;


component Decoding is
    Port ( Instruction : in STD_LOGIC_VECTOR (15 downto 0);
           Zero : in STD_LOGIC;
           RegA_Addr : out STD_LOGIC_VECTOR (2 downto 0);
           RegB_Addr : out STD_LOGIC_VECTOR (2 downto 0);
           Write_Reg_Addr : out STD_LOGIC_VECTOR (2 downto 0);
           Data_Imm : out STD_LOGIC_VECTOR (7 downto 0);
           Imm_Load_Addr : out STD_LOGIC_VECTOR (7 downto 0);
           Store_Addr : out STD_LOGIC_VECTOR (7 downto 0);
           PC_Jump_Addr : out STD_LOGIC_VECTOR (9 downto 0);
           ALU_Mux_Sel : out STD_LOGIC;
           ALU_Valid   :out std_logic;
           PC_Jump_Sel : out STD_LOGIC;
           Reg_Write_Mux_Sel : out STD_LOGIC_VECTOR(1 downto 0));
end component Decoding;


component Program_Counter is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           PC_Jump_Addr : in STD_LOGIC_VECTOR (9 downto 0);
           PC_Jump_Sel : in STD_LOGIC;
           PC_Int_save : in Std_logic;
           PC_Sel_Control : in STD_LOGIC_VECTOR (1 downto 0);
           PC : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component Register_File is
    Port ( Clk : in STD_LOGIC;                                  --Clk  input
           Write_Reg_Data : in STD_LOGIC_VECTOR (7 downto 0);   --data to write
           RegA_Addr : in STD_LOGIC_VECTOR (2 downto 0);        --RegA address to read
           RegB_Addr : in STD_LOGIC_VECTOR (2 downto 0);        --RegB address to read
           Write_Reg_Addr : in STD_LOGIC_VECTOR (2 downto 0);   --Write register address
           Write_En : in STD_LOGIC;                             --Register Write enable 
           RegA_Out : out STD_LOGIC_VECTOR (7 downto 0);         --Register A data
           RegB_Out : out STD_LOGIC_VECTOR (7 downto 0));        --Register B data
end component;

component ALU_MUX is
    Port ( ALU_MUX_SEL : in STD_LOGIC;                
           RegB_Out : in STD_LOGIC_VECTOR (7 downto 0); -- Register File 2nd input
           Data_Imm : in STD_LOGIC_VECTOR (7 downto 0); --Immediate data extracted from the instruction 
           Reg_B : out STD_LOGIC_VECTOR (7 downto 0));  --2nd input of ALU
end component;

component ALU_unit is
  
  Port (   Clk, Reset  : in std_logic;
           ALU_Valid   :in std_logic;
           Int_Save, Int_Restore    : In std_logic;
           data_in1 : in STD_LOGIC_VECTOR (7 downto 0);
           data_in2 : in STD_LOGIC_VECTOR (7 downto 0);
           data_output : out STD_LOGIC_VECTOR (7 downto 0);
           zero_flag : out STD_LOGIC;
           alu_op_sel : in STD_LOGIC_VECTOR (2 downto 0));
end component;

component reg_write_mux is
    Port ( ALU_out :       in STD_LOGIC_VECTOR (7 downto 0);
           memory_out :    in STD_LOGIC_VECTOR (7 downto 0);
           imm_load :      in STD_LOGIC_VECTOR (7 downto 0);
           reg_write_mux : in STD_LOGIC_VECTOR (1 downto 0);
           write_reg_data :out STD_LOGIC_VECTOR (7 downto 0));
end component;


begin



 
dut1 : Program_Counter port map (Clk => clk ,
                                Reset => rst ,
                                PC_Jump_Addr => temp_pc_jump_addr, 
                                PC_Jump_Sel => temp_pc_branch_sel ,
                                PC_Int_save => pc_int_save , 
                                PC_Sel_Control => pc_mux_Sel , 
                                PC => pc);
                                 
dut2 : Register_File port map ( Clk => clk , 
                                Write_Reg_Data => temp_Write_Reg_Data , 
                                RegA_Addr => temp_RegAaddr , 
                                RegB_Addr => temp_RegBaddr,
                                Write_Reg_Addr => temp_write_Reg_addr , 
                                Write_En => reg_write_en , 
                                RegA_Out => temp_RegA_Out , 
                                RegB_Out => temp_RegB_Out);

dut3 : ALU_MUX port map ( ALU_MUX_SEL => temp_alu_mux_sel , 
                          RegB_Out => temp_RegB_Out , 
                          Data_Imm => temp_data_imm , 
                          Reg_B => alu_mux_sel_out);

dut4 : ALU_unit port map( Clk => clk ,
                          Reset => rst, 
                          ALU_Valid=>temp_ALU_Valid,
                          Int_save => pc_int_save,
                          Int_Restore => Int_zero_restore,
                          data_in1 => temp_RegA_Out , 
                          data_in2 => alu_mux_sel_out , 
                          alu_op_sel => alu_cntrl_sel,
                          zero_flag => temp_zero , 
                          data_output => temp_alu_outdata);
                          
dut5 : reg_write_mux port map ( ALU_out => temp_alu_outdata , 
                               memory_out => data_memory_read, 
                               imm_load => temp_Imm_Load_Addr , 
                               reg_write_mux => temp_reg_write_mux_sel ,
                               write_reg_data => temp_Write_Reg_Data ) ; 

dut6: Decoding port map( 
           Instruction =>Instruction,
           Zero =>temp_Zero,
           RegA_Addr =>temp_RegAAddr,
           RegB_Addr =>temp_RegBAddr,
           Write_Reg_Addr => temp_Write_Reg_Addr, 
           Data_Imm => temp_Data_Imm,
           Imm_Load_Addr =>temp_Imm_Load_Addr,
           Store_Addr => Store_Addr,
           PC_Jump_Addr =>temp_PC_Jump_Addr,
           ALU_Mux_Sel => temp_ALU_Mux_Sel,
           ALU_Valid   => temp_ALU_Valid,
           PC_Jump_Sel => temp_pc_branch_sel,
           Reg_Write_Mux_Sel =>temp_Reg_Write_Mux_Sel
                        );



mem_write_data<=temp_RegA_Out;
Int_zero_restore<=pc_mux_Sel(1) and pc_mux_Sel(0);
Imm_Load_Addr <=temp_Imm_Load_Addr;


end Behavioral;
