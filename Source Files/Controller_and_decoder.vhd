library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Controller_and_decoder is
    Port ( clk : in STD_LOGIC;
           Instruction_temp : in STD_LOGIC_VECTOR (4 downto 0);
           reset : in STD_LOGIC;
           Int_Syn_Pulse : in STD_LOGIC;
     -------Output Signals---------------------------------------
           PC_Sel_Control : out STD_LOGIC_VECTOR(1 downto 0);
           PC_Int_Save : out STD_LOGIC;
           ALU_Op_Sel : out STD_LOGIC_VECTOR (2 downto 0);
           Reg_Write_En : out STD_LOGIC;
           Memory_Write_En : out STD_LOGIC);
end Controller_and_decoder;

architecture Behavioral of Controller_and_decoder is

type state is (s0,s1,s2,s3,s4);
signal pr_state,next_state : state;

begin
FSM_Block:process(clk)
begin
if(clk'event and clk='1')then
--State Registers
    if(reset='1') then
         pr_state<=s0;
    else
         pr_state<=next_state;
    end if;    
end if;
end process;

FSM_Combinational_Block: process(reset,pr_state,Int_Syn_Pulse,Instruction_temp)
begin
case pr_state is 
---State 0
    when s0 =>
       PC_Sel_Control <= "00";
       PC_Int_Save <='0';

       if (reset='0') then     
            next_state<= s1;
       else 
            next_state<= s0; 
       end if;
---State 1   
    when s1=>   
       PC_Sel_Control <= "01";
       PC_Int_Save <='0';
       
       if(Int_Syn_Pulse='1') then 
            next_state<= s2;
       else 
            next_state<=s1;
       end if;
---State 2    
    when s2=>
       PC_Sel_Control <= "10";
       PC_Int_Save <='1';
       
       next_state<= s3;
---State 3   
    when s3=>       
       PC_Sel_Control <= "01";
       PC_Int_Save <='0';
       
        if(Instruction_temp ="00001") then   
            next_state<=s4;
        else 
            next_state <=s3;
        end if;
---State 4       
     when s4=>       
       PC_Sel_Control <= "11";
       PC_Int_Save <='0';
              
       next_state <=s1;

    when others=>
       PC_Sel_Control <= "00";
       PC_Int_Save <='0';
        next_state<=s0;

end case;
end process;

ALU_Op_Sel <= "111" when pr_state=s2 or pr_state=s4 else
              "000" when Instruction_temp(4)='1' and Instruction_temp(3)='1' else
              Instruction_temp(2 downto 0);
              
Reg_Write_En <= '0' when pr_state=s2 or pr_state=s4 else
                '1' when Instruction_temp(4)='1' or Instruction_temp(3)='1' or Instruction_temp(2 downto 0)="101" or Instruction_temp(2 downto 0)="100" else
                '0';
               
Memory_Write_En <= '0' when pr_state=s2 or pr_state=s4 else
                   '1' when Instruction_temp(4 downto 0)="00011" else
                   '0'; 
end Behavioral;
