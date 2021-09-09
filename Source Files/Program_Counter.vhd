
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Program_Counter is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           PC_Jump_Addr : in STD_LOGIC_VECTOR (9 downto 0);
           PC_Jump_Sel : in STD_LOGIC;
           PC_Int_save : in Std_logic;
           PC_Sel_Control : in STD_LOGIC_VECTOR (1 downto 0);
           PC : out STD_LOGIC_VECTOR (9 downto 0));
end Program_Counter;

architecture Behavioral of Program_Counter is

signal Pc_Temp,Pc_Temp1,PC_Temp2, pc_save_buff: std_logic_vector(9 downto 0);

begin

Pc_Temp  <= Pc_Jump_Addr  when PC_Jump_Sel ='1' else
            Pc_Temp2+1;

Pc_Temp1 <= b"0000000000" when PC_Sel_Control="00" else -----reset PC_Value            "00"
            PC_Temp when PC_Sel_Control="01" else ----Normal operation         "01"
            b"1100000000" when PC_Sel_Control="10" else  ---Interrupt State           "10"
            pc_save_buff;                         ---Restoring saved PC state  "11"

---Program Counter part
process(clk, Reset)
begin 
if(clk'event and clk='1') then 
    if(Reset='1') then 
        PC_Temp2<=(others =>'0');
    else 
        PC_Temp2<=PC_Temp1;
    end if;
end if;
end process;
PC<=PC_Temp2;


------Saving the PC value to intermediate signal----------
process(clk)
begin 
if(Clk'event and Clk='1') then 
    if(Reset='1')then 
        pc_save_buff<=(Others=>'0');
    else 
       if (PC_int_save='1') then 
            pc_save_buff<=PC_Temp2;
       end if ;
    end if;    
end if;
end process;



end Behavioral;
