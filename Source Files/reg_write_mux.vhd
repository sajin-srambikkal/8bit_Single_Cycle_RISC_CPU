
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reg_write_mux is
    Port ( ALU_out :       in STD_LOGIC_VECTOR (7 downto 0);
           memory_out :    in STD_LOGIC_VECTOR (7 downto 0);
           imm_load :      in STD_LOGIC_VECTOR (7 downto 0);
           reg_write_mux : in STD_LOGIC_VECTOR (1 downto 0);
           write_reg_data :out STD_LOGIC_VECTOR (7 downto 0));
end reg_write_mux;

architecture Behavioral of reg_write_mux is
begin

write_reg_data<= ALU_out    when reg_write_mux ="00" else
                 memory_out when reg_write_mux ="01" else
                 imm_load   when reg_write_mux ="10" else
                 ALU_out;
end Behavioral;
