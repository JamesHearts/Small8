library ieee;
use ieee.std_logic_1164.all;

entity ext_bus is -- These bus entities are essentially just muxes.
	generic (
		width  :     positive := 8);
	port(
		in1	    : in std_logic_vector(WIDTH-1 downto 0); 
		in2 	: in std_logic_vector(WIDTH-1 downto 0); 
		int		: in std_logic_vector(WIDTH-1 downto 0); 
		mem 	: in std_logic_vector(WIDTH-1 downto 0);
		sel 	: in std_logic_vector(1 downto 0); 
		output 	: out std_logic_vector(WIDTH-1 downto 0) 
	);
	
end ext_bus;

architecture bhv of ext_bus is
begin

	process(in1, in2, int, mem, sel)
		begin
		
			case(sel) is			
				when "00" =>
					output <= in1;
					
				when "01" =>
					output <= in2;
					
				when "10" =>
					output <= int;
					
				when others =>
					output <= mem;	
					
			end case;
			
	end process;
end bhv;