library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ALU_MUX is
    Port ( ALU_MUX_SEL : in STD_LOGIC;                
           RegB_Out : in STD_LOGIC_VECTOR (7 downto 0); -- Register File 2nd input
           Data_Imm : in STD_LOGIC_VECTOR (7 downto 0); --Immediate data extracted from the instruction 
           Reg_B : out STD_LOGIC_VECTOR (7 downto 0));  --2nd input of ALU
end ALU_MUX;

architecture Behavioral of ALU_MUX is

begin

Reg_B<= Data_Imm when ALU_MUX_SEL ='1' else
        RegB_Out;

end Behavioral;
