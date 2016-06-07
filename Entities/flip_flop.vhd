library ieee;
use ieee.std_logic_1164.all;

entity flip_flop is
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    en     : in  std_logic;
    input  : in  std_logic;
    output : out std_logic);
end flip_flop;

architecture BHV of flip_flop is
begin

  process(clk, rst)
  begin
   
    if (rst = '1') then
      output   <= '0';
    elsif (rising_edge(clk)) then
 
      if (en = '1') then -- if en is true then we take an input in. en is the enable.
        output <= input;
      end if;
   
   end if;
  end process;
end BHV;