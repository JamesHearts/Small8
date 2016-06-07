library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top_level_s8 is
	port(
		signal clk, rst 		: in std_logic;
		signal input1, input2 	: in std_logic_vector(7 downto 0);
		signal output1, output2 : out std_logic_vector(7 downto 0);
		
		signal input1_en    : in std_logic;
		signal input2_en    : in std_logic;
		signal rst1			: in std_logic;
		signal rst2			: in std_logic
		
	);
end top_level_s8;

architecture STR of top_level_s8 is
		
	 signal ir_n : std_logic_vector(7 downto 0) := (others => '0');
	 signal status : std_logic_vector(3 downto 0) := (others => '0');
	 signal int_sel_n : std_logic_vector(2 downto 0) := "011";
	 signal ext_sel_n : std_logic_vector(1 downto 0) := "11";
	 signal	alu_sel_n : std_logic_vector(3 downto 0) := (others => '0');
	 signal alu_out_en_n : std_logic := '0';
	 signal addr_sel_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal status_n : std_logic_vector(3 downto 0) := (others => '0');
	 signal acc_en_n : std_logic := '0';
	 signal acc_sel_n : std_logic := '0';
	 signal data_sel_n : std_logic := '0';
	 signal data_en_n : std_logic := '0';
	 signal pc_en_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal	pc_inc_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal	pc_dec_n : std_logic_vector(1 downto 0) := (others => '0') ;
	 signal	pc_jump_en_n : std_logic;
	 signal sp_en_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal sp_inc_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal sp_dec_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal sp_jump_en_n : std_logic;
	 signal x_en_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal	x_inc_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal	x_dec_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal	x_jump_en_n : std_logic;
	 signal mar_en_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal mar_inc_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal mar_dec_n : std_logic_vector(1 downto 0) := (others => '0');
	 signal mar_jump_en_n : std_logic;
	 signal ir_en_n : std_logic := '0';        
     signal ext_en_n : std_logic := '0';							
	 signal wren_n : std_logic := '0'; 
	 signal address_n : std_logic_vector(15 downto 0) := (others => '0');
	 signal ram_in_n : std_logic_vector(7 downto 0) := (others => '0');
	 signal ram_out_n : std_logic_vector(7 downto 0) := (others => '0');
	 
	 signal input1_n : std_logic_vector(7 downto 0) := (others => '0');
	 signal input2_n : std_logic_vector(7 downto 0) := (others => '0');
	 signal output1_n : std_logic_vector(7 downto 0) := (others => '0');
	 signal output2_n : std_logic_vector(7 downto 0) := (others => '0');
	 signal output1_en : std_logic := '0';
	 signal output2_en : std_logic := '0';
	 
		
begin
	
	Controller : entity work.controller_s8 
		port map(
		clk => clk,
		rst => rst,		
		ir  => ir_n(7 downto 0), 
		status => status(3 downto 0), 
		
		--int_bus--
		int_sel  =>	int_sel_n(2 downto 0),
		
		--ext_bus-- 
		ext_sel => ext_sel_n(1 downto 0), 
		
		--alu--
		alu_sel => alu_sel_n(3 downto 0),
		alu_out_en => alu_out_en_n,	
		
		--addr_mux--
		addr_sel => addr_sel_n(1 downto 0),
		
		--status_regs--
		C_en => status_n(3),
		V_en => status_n(2), 
		Z_en => status_n(1),
		S_en => status_n(0),	
					
		
		--acc&data_mux & reg--
		acc_en => acc_en_n,	
		acc_sel => acc_sel_n,
		data_sel => data_sel_n,		
		data_en => data_en_n,	
		
		--pc_reg--
		pc_en => pc_en_n(1 downto 0), 
		pc_inc => pc_inc_n(1 downto 0),
		pc_dec => pc_dec_n(1 downto 0),
		pc_jump_en => pc_jump_en_n,		
		
		--sp_reg--
		sp_en => sp_en_n(1 downto 0),
		sp_inc => sp_inc_n(1 downto 0),
		sp_dec => sp_dec_n(1 downto 0),
		sp_jump_en => sp_jump_en_n,	
		
		--index_reg--
		x_en =>	x_en_n(1 downto 0),
		x_inc => x_inc_n(1 downto 0),
		x_dec => x_dec_n(1 downto 0),
		x_jump_en => x_jump_en_n,		
		
		--memoryaddr_reg--
		mar_en => mar_en_n(1 downto 0),
		mar_inc => mar_inc_n(1 downto 0),
		mar_dec => mar_dec_n(1 downto 0),
		mar_jump_en => mar_jump_en_n,		
		
		--int_reg--
		
		ir_en => ir_en_n,       
		--ext_reg--
		
		ext_en => ext_en_n,							
		
		-- ram_control --
		wren => wren_n,

		output1_en => output1_en,
		output2_en => output2_en,
		
		address => address_n(15 downto 0)
			
		);
		
	Datapath : entity work.datapath_s8
		port map(
					
		clk => clk,
		rst => rst,			
		
		-- I/O --
		input1 => input1_n(7 downto 0),	
		input2 => input2_n(7 downto 0),
		
		output1	=> output1_n(7 downto 0),	
		output2	=> output2_n(7 downto 0),	
		
		--int_bus--
		int_sel => int_sel_n(2 downto 0),  	  	
		
		--ext_bus-- 
		ext_sel => ext_sel_n(1 downto 0),
		
		--alu--
		alu_sel => alu_sel_n(3 downto 0),     	
		alu_out_en => alu_out_en_n,
		
		--addr_mux--
		addr_sel => addr_sel_n(1 downto 0), 	
		
		--status_regs--
		C_en => status_n(3), 			
		V_en => status_n(2),	
		Z_en => status_n(1),
		S_en => status_n(0),  			
					
		
		--acc&data_mux & reg--
		acc_en => acc_en_n,		
		acc_sel => acc_sel_n,		
		data_sel => data_sel_n,	
		data_en => data_en_n,	
		
		--pc_reg--
		pc_en => pc_en_n(1 downto 0),			
		pc_inc => pc_inc_n(1 downto 0),			
		pc_dec => pc_dec_n(1 downto 0),			
		pc_jump_en => pc_jump_en_n,	
		
		--sp_reg--
		sp_en => sp_en_n(1 downto 0),
		sp_inc => sp_inc_n(1 downto 0),
		sp_dec => sp_dec_n(1 downto 0),
		sp_jump_en => sp_jump_en_n,			
		
		--index_reg--
		x_en =>	x_en_n(1 downto 0),
		x_inc => x_inc_n(1 downto 0),
		x_dec => x_dec_n(1 downto 0),
		x_jump_en => x_jump_en_n,			
		
		--memoryaddr_reg--
		mar_en => mar_en_n(1 downto 0),
		mar_inc => mar_inc_n(1 downto 0),
		mar_dec => mar_dec_n(1 downto 0),
		mar_jump_en => mar_jump_en_n,		
		
		--int_reg--
		ir_en => ir_en_n,
		--ext_reg--
		ext_en => ext_en_n,						
		
		--external_outputs---
		status => status(3 downto 0),		
		address => address_n(15 downto 0), 
		ir => ir_n(7 downto 0),      
		ram_out => ram_in_n(7 downto 0),    		
		
		-- input busses --	 	
		ram_in => ram_out_n(7 downto 0)	
		
		-- ram control --
		--wren => wren_n			
		);	

	RAM : entity work.RAM_s8_2
		port map(
		address	=>  address_n(7 downto 0),
		clock	=>	clk,
		data	=>  ram_in_n(7 downto 0),
		wren	=>	wren_n,
		q		=>  ram_out_n(7 downto 0)
		
		);
		
	IOPORT : entity work.io_s8
	port map(
		clk		    => clk,
		rst		    => rst,
		
		input1		=> input1(7 downto 0), 			-- from Small8
		input2		=> input2(7 downto 0),
		
		input1_n	=> input1_n(7 downto 0), 		-- to Datapath
		input2_n	=> input2_n(7 downto 0),	
		
		input1_en   => input1_en,		-- from external switch
		input2_en   => input2_en,
		
		rst1		=> rst1,		-- from external switch
		rst2		=> rst2,
		
		output1_n	=> output1_n(7 downto 0),		-- from Datapath
		output2_n   => output2_n(7 downto 0),
		
		output1		=> output1(7 downto 0),			-- to external LED
		output2 	=> output2(7 downto 0),
		
		output1_en 	=> output1_en, -- from Controller
		output2_en  => output2_en
	);
			
end STR;