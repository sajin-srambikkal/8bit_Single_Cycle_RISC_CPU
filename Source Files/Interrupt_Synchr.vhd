
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Interrupt_Synchr is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Interrupt : in STD_LOGIC;
           Int_Syn_Pulse : out STD_LOGIC);
end Interrupt_Synchr;

architecture Behavioral of Interrupt_Synchr is
Signal I,I1, I2, I3 : std_logic;

begin

--Plse to level signal----
process(Interrupt, Reset)
begin
if(Reset='1') then 
I<='0';
elsif(Interrupt'event and Interrupt='1') then 
I<= not I;
end if;
end process;

---Synchronizer
process(clk,Reset)
begin 
if(Reset='1')then
    I1<='0';
    I2<='0';
    I3<='0';
elsif(clk'event and clk='1') then 
    I1<=I;
    I2<=I1;
    I3<=I2;
end if;
end process;

Int_Syn_Pulse<=I2 xor I3;

end Behavioral;
