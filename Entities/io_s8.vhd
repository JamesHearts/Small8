library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity io_s8 is
	port(
	
		clk		: in std_logic;
		rst		: in std_logic;
		
		input1 		: in std_logic_vector(7 downto 0); 
		input2 		: in std_logic_vector(7 downto 0);
		
		input1_n	: out std_logic_vector(7 downto 0); 
		input2_n	    : out std_logic_vector(7 downto 0);
		
		input1_en 	: in std_logic;
		input2_en 	: in std_logic;
		
		rst1		: in std_logic;  
		rst2		: in std_logic;
		
		output1_n 	: in std_logic_vector(7 downto 0); 
		output2_n	: in std_logic_vector(7 downto 0);
		
		output1 	: out std_logic_vector(7 downto 0); 
		output2 	: out std_logic_vector(7 downto 0);
		
		output1_en 	: in std_logic;	
		output2_en 	: in std_logic
		
	);
end io_s8;

architecture STR of io_s8 is
begin

	IN1_REG : entity work.reg
		port map(
			clk => clk,
			rst => rst1,
			input	=> input1,
			output	=> input1_n,
			en => input1_en
		);
		
	IN2_REG : entity work.reg
		port map(
			clk => clk,
			rst => rst2,
			input	=> input2,
			output 	=> input2_n,
			en => input2_en
		);
	
	OUT1_REG : entity work.reg
		port map(
			clk => clk,
			rst => rst,
			input	=> output1_n,
			output 	=> output1,
			en => output1_en
		);
	
	OUT2_REG : entity work.reg
		port map(
			clk => clk,
			rst => rst,
			input	=> output2_n,
			output	=> output2,
			en => output2_en
		);	
end STR;

