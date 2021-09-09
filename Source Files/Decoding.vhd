
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Decoding is
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
end Decoding;

architecture Behavioral of Decoding is

begin

RegA_Addr <=Instruction(7 downto 5);                                           -- Source Register1
RegB_Addr <=Instruction(4 downto 2);                                           -- Source Register2
Write_Reg_Addr <=Instruction(10 downto 8);                                     -- Destination Register
Data_Imm <=Instruction(13 downto 11) & Instruction(4 downto 0);                -- Immediate Data for ADDI and for shiftleft and shiftright only(Insruction(4 downto 0)
Imm_Load_Addr <=Instruction(7 downto 0);                                       -- Immediate Data Memory Address for LOAD and Immediate Data for LOADI
Store_Addr <=Instruction(10 downto 8) & Instruction(4 downto 0);               -- Destination Memory Address for STORE
PC_Jump_Addr <=Instruction(9 downto 0);                                        -- PC Jump Address for JUMP and JUMPZ Instruction
ALU_Mux_Sel <=Instruction(14);                                                 -- Selection of second input of ALU(1:Immediate Data ,0:Register Data)
PC_Jump_Sel <= '1' when Zero='1' and Instruction(15 downto 11)="00111" else    -- PC_Jump_Sel=> 1:for Jump and Succesful JUMPZ , 0:PC won't jump(normal operation)
               '1' when  Instruction(15 downto 11)="00110" else
               '0';
Reg_Write_Mux_Sel<= "01" when Instruction(15 downto 11)="00101" else           -- When there is need to write in registers(LOAD:01 and LOADI:10 Instrcution) 
                    "10" when Instruction(15 downto 11)="00100" else
                    "00";                   
ALU_Valid<=Instruction(14) or Instruction(15);                                 --indicating a valid ALU operation is going on 
 
end Behavioral;
