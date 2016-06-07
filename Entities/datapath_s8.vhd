library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_s8 is --did not have time to comment this for first 2 deliveries.

	generic (
		width  :     positive := 8);
	port(
		clk 			: in std_logic;
		rst 			: in std_logic;
		
		-- I/O --
		input1			: in std_logic_vector(7 downto 0);
		input2			: in std_logic_vector(7 downto 0); 
		
		output1			: out std_logic_vector(7 downto 0); 
		output2			: out std_logic_vector(7 downto 0);
		
		--int_bus--
		int_sel  	  	: in  std_logic_vector(2 downto 0);
		
		--ext_bus-- 
		ext_sel 		: in std_logic_vector(1 downto 0); 
		
		--alu--
		alu_sel     	: in std_logic_vector(3 downto 0);
		alu_out_en  	: in std_logic;
		
		--addr_mux--
		addr_sel    	: in std_logic_vector(1 downto 0);
		
		--status_regs--
		C_en   			: in  std_logic;
		V_en		    : in  std_logic;
		S_en   			: in  std_logic;
		Z_en 			: in  std_logic;
		
		--acc&data_mux & reg--
		acc_en			: in std_logic;	
		acc_sel 		: in std_logic;
		data_sel		: in std_logic;
		data_en 		: in std_logic;
		
		--pc_reg--
		pc_en 			: in std_logic_vector(1 downto 0); 
		pc_inc			: in std_logic_vector(1 downto 0);
		pc_dec			: in std_logic_vector(1 downto 0);
		pc_jump_en		: in std_logic;
		
		--sp_reg--
		sp_en			: in std_logic_vector(1 downto 0);
		sp_inc			: in std_logic_vector(1 downto 0);
		sp_dec			: in std_logic_vector(1 downto 0);
		sp_jump_en		: in std_logic;
		
		--index_reg--
		x_en		    : in std_logic_vector(1 downto 0);
		x_inc			: in std_logic_vector(1 downto 0);
		x_dec			: in std_logic_vector(1 downto 0);
		x_jump_en		: in std_logic;
		
		--memoryaddr_reg--
		mar_en			: in std_logic_vector(1 downto 0);
		mar_inc			: in std_logic_vector(1 downto 0);
		mar_dec			: in std_logic_vector(1 downto 0);	
		mar_jump_en		: in std_logic;
		
		--int_reg--
		ir_en : in std_logic;
		--ext_reg--
		ext_en			: in std_logic;					
		
		--external_outputs---
		status 			: out std_logic_vector(3 downto 0); 
		address 		: out std_logic_vector(15 downto 0); 
		ir          	: out std_logic_vector(7 downto 0); 
		ram_out    		: out std_logic_vector(7 downto 0);
		
		-- input busses --
		--control 		: in std_logic_vector(7 downto 0); 	
		ram_in			: in std_logic_vector(7 downto 0)
		
		-- ram control --
		--wren 			: in std_logic
	);
	
end datapath_s8;

architecture str of datapath_s8 is

	signal acc_reg 		: std_logic_vector(7 downto 0) := (others => '0');
	signal data_reg		: std_logic_vector(7 downto 0) := (others => '0'); 
	signal alu_out_reg	: std_logic_vector(7 downto 0) := (others => '0'); 
	signal alu_out_temp	: std_logic_vector(7 downto 0) := (others => '0'); 
	
	signal x_reg 		: std_logic_vector(15 downto 0):= (others => '0'); 
	signal pc_reg		: std_logic_vector(15 downto 0):= (others => '0');
	signal sp_reg 		: std_logic_vector(15 downto 0):= (others => '0');
	signal mar_reg		: std_logic_vector(15 downto 0):= (others => '0');
	
	signal int_bus		: std_logic_vector(7 downto 0):= (others => '0'); 
	signal ext_bus		: std_logic_vector(7 downto 0):= (others => '0'); 
	signal ext_reg		: std_logic_vector(7 downto 0):= (others => '0');
	
	
	signal C			: std_logic := '0';
	signal S			: std_logic := '0';
	signal V			: std_logic := '0';
	signal Z			: std_logic := '0';
	
	signal C_temp		: std_logic := '0';
	
	signal acc_mux_out	: std_logic_vector(7 downto 0);
	signal data_mux_out	: std_logic_vector(7 downto 0);
	
    --signal address 		: std_logic_vector(15 downto 0);

	
begin
	
		
	ALU	: entity work.alu_ns
		port map(
		
			acc	    => unsigned(acc_reg),
			data	=> unsigned(data_reg),		
			sel		=> alu_sel(3  downto 0),
			cin		=> C_temp,	
			output	=> alu_out_temp,
			cout	=> C,
			vout	=> V,
			sout	=> S,
			zout    => Z	
		);
		
	ALU_REG : entity work.reg
		port map(
			clk 	=> clk,
			rst	    => rst,
			input	=> alu_out_temp,
			output	=> alu_out_reg,
			en		=> alu_out_en
		);
		
	C_REG : entity work.flip_flop
		port map(
			clk 	=> clk,
			rst	    => rst,
			input	=> C,
			output	=> C_temp,
			en		=> C_en
		);

	V_REG : entity work.flip_flop
		port map(
			clk 	=> clk,
			rst	    => rst,
			input	=> V,
			output	=> status(2),
			en		=> V_en
		);	

	S_REG : entity work.flip_flop
		port map(
			clk 	=> clk,
			rst	    => rst,
			input	=> S,
			output	=> status(0),
			en		=> S_en
		);		

	Z_REG : entity work.flip_flop
		port map(
			clk 	=> clk,
			rst	    => rst,
			input	=> Z,
			output	=> status(1),
			en		=> Z_en
		);	
	
	
	
	EXTL_BUS : entity work.ext_bus
		port map(
			in1			=> input1,
			in2			=> input2,
			int			=> int_bus,
			mem			=> ram_in,
			sel			=> ext_sel,
			output		=> ext_bus
		);
		
	EXTL_REG	: entity work.reg
		port map(
			clk			=> clk,
			rst			=> rst,	
			input		=> ext_bus,
			output		=> ext_reg,
			en			=> ext_en
		);
		
	INTL_BUS : entity work.int_bus
		port map(
			sel			=> int_sel,
			acc_reg 	=> acc_reg, 	
			data_reg	=> data_reg,	
			alu_reg		=> alu_out_reg,
			ext_reg 	=> ext_reg, 	
			PC_reg		=> pc_reg,	
			output	 	=> int_bus
		);
		
	ACCU_REG : entity work.reg
		port map(
			clk   		=> clk,
			rst 		=> rst,
			input 		=> acc_mux_out,
			output 		=> acc_reg, 
			en			=> acc_en
		);
		
	DAT_REG : entity work.reg
		port map(
			clk 		=> clk,
			rst 		=> rst,		
			input 		=> data_mux_out,
			output 		=> data_reg,
			en 			=> data_en
		);
		
	ACC_MUX : entity work.mux_2x1
		port map(
			in1 	=> int_bus,
			in2	    => "00000000",
			sel		=> acc_sel,	
			output	=> acc_mux_out
		);
			
	DATA_MUX : entity work.mux_2x1
		port map(
			in1 	=> int_bus,
			in2		=> "00000000",
			sel		=> data_sel,	
			output	=> data_mux_out
		);
		
	INST_REG : entity work.reg
		port map(
			clk 	=> clk,
			rst 	=> rst,
			input	=> int_bus,
			output	=> ir,
			en		=> ir_en
		);
		
	SP : entity work.reg_HL
		port map(
			clk 		=> clk,
			rst 		=> rst,
			
			H_in        => int_bus,
			L_in 		=> int_bus,
			
			H_en 		=> sp_en(1),
			L_en		=> sp_en(0),
			
			inc		    => sp_inc(1 downto 0),
			dec			=> sp_dec(1 downto 0),
			
			H_out	 	=> sp_reg(15 downto 8),
			L_out		=> sp_reg(7 downto 0),
			
			jump_en     => sp_jump_en,
			jump_val	=> int_bus
		);
		
	X : entity work.reg_HL
		port map(
			clk 		=> clk,
			rst 		=> rst,
			
			H_in		=> int_bus,
			L_in 		=> int_bus,
			
			H_en 		=> x_en(1),
			L_en		=> x_en(0),
			
			inc		    => x_inc(1 downto 0),
			dec			=> x_dec(1 downto 0),
			
			H_out		=> x_reg(15 downto 8),
			L_out		=> x_reg(7 downto 0),
			
			jump_en 	=> x_jump_en,
			jump_val	=> int_bus
		);
		
	PC : entity work.reg_HL
		port map(
			clk 		=> clk,
			rst 		=> rst,
			
			H_in 		=> int_bus,
			L_in		=> int_bus,
			
			inc			=> pc_inc(1 downto 0),
			dec			=> pc_dec(1 downto 0),
			
			H_en 		=> pc_en(1),
			L_en		=> pc_en(0),
			
			H_out		=> pc_reg(15 downto 8),
			L_out		=> pc_reg(7 downto 0),
			
			jump_en 	=> pc_jump_en,
			jump_val	=> int_bus
		);
		
	MEM_ADDR_REG : entity work.reg_HL
		port map(
			clk 		=> clk,
			rst 		=> rst,
			
			H_in	    => int_bus,
			L_in	    => int_bus,
			
			inc			=> mar_inc(1 downto 0),
			dec			=> mar_dec(1 downto 0),
			
			H_en		=> mar_en(1),
			L_en		=> mar_en(0),
			
			H_out		=> mar_reg(15 downto 8),
			L_out		=> mar_reg(7 downto 0),
			
			jump_en		=> mar_jump_en,
			jump_val	=> int_bus
		);
		
	ADDR_MUX : entity work.mux_4x1
		port map(
			in1 	=> pc_reg,
			in2		=> sp_reg,
			in3 	=> x_reg,
			in4		=> mar_reg,
			
			sel		=> addr_sel,
			output	=> address(15 downto 0)
		);
		
		status(3)    <= C_temp;
		ram_out      <= ext_bus;
		output1		 <= ext_bus;
		output2		 <= ext_bus;
end str;