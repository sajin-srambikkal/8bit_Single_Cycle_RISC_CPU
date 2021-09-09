
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
    Port ( Clk : in STD_LOGIC;                                  --Clk  input
           Write_Reg_Data : in STD_LOGIC_VECTOR (7 downto 0);   --data to write
           RegA_Addr : in STD_LOGIC_VECTOR (2 downto 0);        --RegA address to read
           RegB_Addr : in STD_LOGIC_VECTOR (2 downto 0);        --RegB address to read
           Write_Reg_Addr : in STD_LOGIC_VECTOR (2 downto 0);   --Write register address
           Write_En : in STD_LOGIC;                             --Register Write enable 
           RegA_Out : out STD_LOGIC_VECTOR (7 downto 0);         --Register A data
           RegB_Out : out STD_LOGIC_VECTOR (7 downto 0));        --Register B data
end Register_File;

architecture Behavioral of Register_File is

type ramtype is array (7 downto 0) of std_logic_vector(7 downto 0);
signal mem1 : ramtype;

begin
--Write to all regsiter
process(clk)
begin 
    if(clk'event and clk='1') then 
        --if(Reset='0') then    No reset value...Registeres can be initiated using Load and LoadI instructions
        --  mem1<=((others=> (others=>'0'))); ---initialized to 0
         if(Write_En ='1') then 
            mem1(to_integer(unsigned(Write_Reg_Addr )))<=Write_Reg_Data;
        end if;
    end if;
end process;

---Read Register------------------
RegA_Out<= mem1(to_integer(unsigned(RegA_Addr )));
RegB_Out<= mem1(to_integer(unsigned(RegB_Addr )));

end Behavioral;
