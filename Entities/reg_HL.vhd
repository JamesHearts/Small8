library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_HL is
  generic (
    width  :     positive := 8);
  port (
   
   		clk 		: in std_logic;
		rst		    : in std_logic;
		
		H_en		: in std_logic;									
		L_en		: in std_logic;
		
		H_in		: in std_logic_vector(WIDTH-1 downto 0);	
		L_in		: in std_logic_vector(WIDTH-1 downto 0);
		
		H_out 	: buffer std_logic_vector(WIDTH-1 downto 0); 
		L_out 	: buffer std_logic_vector(WIDTH-1 downto 0);
		
		inc		: in std_logic_vector(1 downto 0); 
		dec		: in std_logic_vector(1 downto 0);
		
		jump_en 	: in std_logic; 						  
		jump_val 	: in std_logic_vector(7 downto 0)  
   
   );
end reg_HL;

architecture bhv of reg_HL is
begin

  process(clk, rst)
  
	variable temp : unsigned(15 downto 0):= (others => '0');
	
  begin
   
    if(rst = '1') then
			H_out <= (others => '0');
			L_out <= (others => '0');
			
		elsif(rising_edge(clk)) then
			if(H_en = '1') then		
				H_out <= H_in;
			end if;
			
			if(L_en = '1') then		
				L_out <= L_in;
			end if;
			
			if(inc = "01") then	
					temp := unsigned(H_out & L_out) + 1;
					H_out <= std_logic_vector(temp(15 downto 8));
					L_out <= std_logic_vector(temp(7 downto 0));	
			elsif(inc = "10") then
					temp := unsigned(H_out & L_out) + 2;
					H_out <= std_logic_vector(temp(15 downto 8));
					L_out <= std_logic_vector(temp(7 downto 0));
			elsif(inc = "11") then
					temp := unsigned(H_out & L_out) + 3;
					H_out <= std_logic_vector(temp(15 downto 8));
					L_out <= std_logic_vector(temp(7 downto 0));
			else		
			end if;
			
			if(dec = "01") then	
					temp := unsigned(H_out & L_out) - 1;
					H_out <= std_logic_vector(temp(15 downto 8));
					L_out <= std_logic_vector(temp(7 downto 0));	
			elsif(dec = "10") then
					temp := unsigned(H_out & L_out) - 2;
					H_out <= std_logic_vector(temp(15 downto 8));
					L_out <= std_logic_vector(temp(7 downto 0));
			elsif(dec = "11") then
					temp := unsigned(H_out & L_out) - 3;
					H_out <= std_logic_vector(temp(15 downto 8));
					L_out <= std_logic_vector(temp(7 downto 0));
			else
			end if;
			
			if(jump_en = '1') then	
				temp := unsigned(H_out & L_out) + unsigned("00000000" & jump_val);
				H_out <= std_logic_vector(temp(15 downto 8));
				L_out <= std_logic_vector(temp(7 downto 0));
			end if;
		end if;
		
  end process;
  
end bhv;