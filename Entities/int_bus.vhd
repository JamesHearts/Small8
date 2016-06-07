library ieee;
use ieee.std_logic_1164.all;

entity int_bus is -- This entity gives us the ability to switch between multiple registers and send it to the output.

  generic (
    width  :     positive := 8);
  port (
     sel    			: in  std_logic_vector(2 downto 0);
	 
	 ext_reg			: in std_logic_vector(WIDTH-1 downto 0);
	 acc_reg			: in std_logic_vector(WIDTH-1 downto 0);
	 data_reg			: in std_logic_vector(WIDTH-1 downto 0);
	 alu_reg			: in std_logic_vector(WIDTH-1 downto 0);
	 PC_reg				: in std_logic_vector(15 downto 0);
	 
     output		 		: out std_logic_vector(WIDTH-1 downto 0)
	 );
	 
end int_bus;

architecture bhv of int_bus is
begin

	process(sel, data_reg, alu_reg, PC_reg, ext_reg, acc_reg )
	begin
	
	case(sel) is
		when "000" =>
			output <= acc_reg;
			
		when "001" =>
			output <= data_reg;
			
		when "010" =>
			output <= alu_reg;
			
		when "011" =>
			output <= ext_reg;
			
		when "100" =>
			output <= PC_reg(7 downto 0);
			
		when "101" =>
			output <= PC_reg(15 downto 8);
			
		when others =>
			output  <= (others => '0');
			
	end case;
	
	end process;

end bhv;
