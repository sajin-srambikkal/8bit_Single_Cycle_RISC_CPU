
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity ALU_unit is
generic(size : integer := 8;
         no_bit : integer := 3);
    Port ( Clk, Reset  : in std_logic;
           ALU_Valid   :in std_logic;
           Int_Save, Int_Restore    : In std_logic;
           data_in1 : in STD_LOGIC_VECTOR (size-1 downto 0);
           data_in2 : in STD_LOGIC_VECTOR (size-1 downto 0);
           data_output : out STD_LOGIC_VECTOR (size-1 downto 0);
           zero_flag : out STD_LOGIC;
           alu_op_sel : in STD_LOGIC_VECTOR (no_bit-1 downto 0));
end ALU_unit;

architecture Behavioral of ALU_unit is
 
signal zero_f3,zero_f2,zero_f1,zero_temp,zero_buff: std_logic;
signal data_out : std_logic_vector (size-1 downto 0);
begin

zero_f1 <= '1' when (data_out="00") else '0'; 
zero_f2<=zero_f1 when ALU_Valid='1' else zero_temp;
zero_f3<=zero_buff when Int_Restore='1' else zero_f2;

process(clk)
begin
    if(clk'event and clk='1') then 
        if(Reset='1') then 
            zero_temp<='0';
        else
            zero_temp<=zero_f3;
        end if;
    end if;
end process;


process(clk)
begin
    if(clk'event and clk='1') then 
        if(Reset='1') then 
            zero_buff<='0';
        else
            if(Int_Save='1') then 
            zero_buff<=zero_temp;
            end if;
        end if;
    end if;
end process;

zero_flag<=zero_temp;
data_output <=  data_out;
process(data_in1 , data_in2 , alu_op_sel)
begin

case alu_op_sel is 

   when "000" =>
     data_out <= data_in1 + data_in2 ;
     
   when "001" =>
     data_out <= data_in1 + (not(data_in2) + 1);
      
   when "010" =>
     data_out <= data_in1 xor data_in2 ;
    
   when "011" =>
     data_out <= data_in1 or data_in2;
     
   when "100" =>
     data_out <= data_in1 and data_in2;
     
   when "101" =>
   
      case data_in2(2 downto 0) is 
        when "000" =>
          data_out <= data_in1(7 downto 0);
        when "001" =>
          data_out <= data_in1(6 downto 0) & '0';   
        when "010" =>
          data_out <= data_in1(5 downto 0) & "00";
        when "011" =>
          data_out <= data_in1(4 downto 0) & "000";
        when "100" =>
          data_out <= data_in1(3 downto 0) & "0000"; 
        when "101" =>
          data_out <= data_in1(2 downto 0) & "00000";
        when "110" =>
          data_out <= data_in1(1 downto 0) & "000000";
        when "111" =>
          data_out <= data_in1(0) & "0000000";
        when others => 
         data_out <= (others => '0');  
                  
        end case;  
        
        
      
  when "110" =>
        
      case data_in2(2 downto 0) is 
        when "000" =>
          data_out <= data_in1(7 downto 0);
        when "001" =>
          data_out <=  '0' & data_in1(7 downto 1);   
        when "010" =>
          data_out <= "00" & data_in1(7 downto 2);
        when "011" =>
          data_out <= "000" & data_in1(7 downto 3);
        when "100" =>
          data_out <= "0000" & data_in1(7 downto 4) ; 
        when "101" =>
          data_out <= "00000" & data_in1(7 downto 5) ;
        when "110" =>
          data_out <= "000000" & data_in1(7 downto 6);
        when "111" =>
          data_out <= "0000000" & data_in1(7);    
        
       when others => 
        data_out <= (others => '0');        
        end case;  
      
   when others => 
     data_out <= (others => '0');
     
   end case;
  end process;    
end Behavioral;
