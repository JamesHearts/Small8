library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_s8 is

	generic (
		width  :     positive := 8);
	port(
		clk 			: in std_logic;
		rst 			: in std_logic;
		ir          	: in std_logic_vector(7 downto 0); 
		status 			: in std_logic_vector(3 downto 0); 
		
		--int_bus--
		int_sel  	  	: out std_logic_vector(2 downto 0);
		
		--ext_bus-- 
		ext_sel 		: out std_logic_vector(1 downto 0); 
		
		--alu--
		alu_sel     	: out std_logic_vector(3 downto 0);
		alu_out_en  	: out std_logic;
		
		--addr_mux--
		addr_sel    	: out std_logic_vector(1 downto 0);
		
		--status_regs--
		C_en   			: out  std_logic;
		V_en		    : out  std_logic;
		S_en   			: out  std_logic;
		Z_en 			: out  std_logic;
		
		--acc&data_mux & reg--
		acc_en			: out std_logic;	
		acc_sel 		: out std_logic;
		data_sel		: out std_logic;
		data_en 		: out std_logic;
		
		--pc_reg--
		pc_en 			: out std_logic_vector(1 downto 0); 
		pc_inc			: out std_logic_vector(1 downto 0);
		pc_dec			: out std_logic_vector(1 downto 0);
		pc_jump_en		: out std_logic;
		
		--sp_reg--
		sp_en			: out std_logic_vector(1 downto 0);
		sp_inc			: out std_logic_vector(1 downto 0);
		sp_dec			: out std_logic_vector(1 downto 0);
		sp_jump_en		: out std_logic;
		
		--index_reg--
		x_en		    : out std_logic_vector(1 downto 0);
		x_inc			: out std_logic_vector(1 downto 0);
		x_dec			: out std_logic_vector(1 downto 0);
		x_jump_en		: out std_logic;
		
		--memoryaddr_reg--
		mar_en			: out std_logic_vector(1 downto 0);
		mar_inc			: out std_logic_vector(1 downto 0);
		mar_dec			: out std_logic_vector(1 downto 0);
		mar_jump_en		: out std_logic;
		
		--int_reg--
		
		ir_en           : out std_logic;
		--ext_reg--
		
		ext_en			: out std_logic;				
		
		-- ram_control --
		wren 			: out std_logic;
		
		output1_en      : out std_logic;
		output2_en      : out std_logic;
		address 		: in std_logic_vector(15 downto 0)
	);
	
end controller_s8;

architecture bhv of controller_s8 is 

	type state_type is (init_state, oc_init_prefetch, oc_init_fetch, oc_prefetch, oc_fetch, oc_decode, LDAI, LDAI_a, LDAA, LDAA_a,
                     	LDAA_b, LDAA_c, LDAA_d, LDAA_e, LDAD, STAA, STAA_a, STAA_b, STAA_c, STAA_d, STAA_e, STAA_f, STAR, ADCR_D,
						ADCR_D_a, SBCR_D, SBCR_D_a, CMPR_D, ANDR_D, ANDR_D_a, ORR_D, ORR_D_a, XORR_D, XORR_D_a, SLRL, SLRL_a, SRRL, SRRL_a,
						ROLC, ROLC_a, RORC, RORC_a, Branch, Branch_a, Branch_b, Branch_c, DECA, DECA_a, INCA, INCA_a, SETC, 
						CLRC, LDSI, LDSI_a, LDSI_b, LDSI_c, CALL, CALL_a, CALL_b, CALL_c, CALL_d, CALL_e, CALL_f, RET, RET_a,
						RET_b, RET_c, RET_d, LDXI, LDXI_a, LDXI_b, LDXI_c, LDXI_d, LDAA_X, LDAA_X_a, LDAA_X_b, LDAA_X_c, LDAA_X_d,
						STAA_X, STAA_X_a, STAA_X_b, STAA_X_c, INCX, INCX_a, DECX, DECX_a, Branch_d);
						
	signal state      : state_type;
	signal next_state : state_type;
	signal wren_temp       : std_logic := '0';

begin

	process(clk, rst)
	
	begin 	
		if(rst = '1') then
			state <= init_state;
		elsif(rising_edge(clk)) then 
			state <= next_state;
		end if;
	end process;
	
	
	process(state, ir, status)
	
	begin 
		--int_bus--
		int_sel <= "011";	  	
		--ext_bus-- 
		--ext_sel <=	"11"; 
		--alu--
		alu_sel <= "0000";	
		alu_out_en <= '0';
		--addr_mux--
		addr_sel <= "00";
		--status_regs--
		C_en <= '0';			
		V_en <= '0';
		S_en <= '0'; 
		Z_en <= '0';
		--acc&data_mux & reg--
		acc_en <= '0';
		acc_sel <= '0';
		data_sel <= '0';
		data_en <= '0';
		--pc_reg--
		pc_en <= "00";
		pc_inc <= "00";
		pc_dec <= "00";	
		pc_jump_en <= '0';
		--sp_reg--
		sp_en <= "00";	
		sp_inc <= "00";
		sp_dec <= "00";
		sp_jump_en <= '0';
		--index_reg--
		x_en <= "00";	  
		x_inc <= "00";	
		x_dec <= "00";	
		x_jump_en <= '0';
		--memoryaddr_reg--
		mar_en <= "00";
		mar_inc <= "00";	
		mar_dec	<= "00";		
		mar_jump_en <= '0';		
		--int_reg--
		ir_en <= '0';       
		--ext_reg--
		--ext_en <= '0';					
		-- ram_control --
		wren_temp <= '0';
		
		next_state <= state; 	

		case(state) is

		when init_state =>
		    
			next_state <= oc_init_prefetch;
			
		when oc_init_prefetch =>
		
			--ext_en <= '1';
			next_state <= oc_init_fetch;
			
		when oc_init_fetch =>
		
			ir_en <= '1';
			pc_inc <= "01";
			
			next_state <= oc_decode;
			
		when oc_prefetch =>
		
			pc_inc <= "01";
			--ext_en <= '1';
			
			next_state <= oc_fetch;
			
		when oc_fetch =>
			
			ir_en <= '1';
			next_state <= oc_decode;
		
		when oc_decode =>
		
			case(ir) is 	
			when "10000100" => -- LDAI
				pc_inc <= "01";
				next_state <= LDAI;
			when "10001000" => -- LDAA
				pc_inc <= "01";
				next_state <= LDAA;
			when "10000001" => -- LDAD
				next_state <= LDAD;
			when "11110110" => -- STAA
				pc_inc <= "01";
				next_state <= STAA;
			when "11110001" => -- STAR
				next_state <= STAR;
			when "00000001" => -- ADCR_D
				next_state <= ADCR_D;
			when "00010001" => -- SBCR_D
				next_state <= SBCR_D;
			when "10010001" => --CMPR_D
				next_state <= CMPR_D; 
			when "00100001" => -- ANDR_D
				next_state <= ANDR_D; 
			when "00110001" => -- ORR_D
				next_state <= ORR_D;
			when "01000001" => -- XORR_D
				next_state <= XORR_D;
			when "01010001" => -- SLRL
				next_state <= SLRL;
			when "01100001" => -- SRRL
				next_state <= SRRL;
			when "01010010" => -- ROLC
				next_state <= ROLC;
		    when "01100010" => -- RORC
				next_state <= RORC;
				
			when "10110000" => -- BCCA
				if(status(3) = '0') then 
					next_state	<= Branch;
					pc_inc		<= "01";
				else
					next_state 	<= Branch_c;
					pc_inc		<= "10";
				end if;
				
			when "10110001" => --BCSA
				if(status(3) = '1') then 
					next_state	<= Branch;
					pc_inc		<= "01";
				else
					next_state 	<= Branch_c;
					pc_inc		<= "10";
				end if;
				
			when "10110010" => --BEQA
				if(status(1) = '1') then 
					next_state	<= Branch;
					pc_inc		<= "01";
				else
					next_state 	<= Branch_c;
					pc_inc		<= "10";
				end if;
				
			when "10110011" => --BMIA
				if(status(0) = '1') then 
					next_state	<= Branch;
					pc_inc		<= "01";
				else
					next_state 	<= Branch_c;
					pc_inc		<= "10";
				end if;
				
			when "10110100" => --BNEA
				if(status(1) = '0') then 
					next_state	<= Branch;
					pc_inc		<= "01";
				else
					next_state 	<= Branch_c;
					pc_inc		<= "10";
				end if;
				
			when "10110101" => --BPLA
				if(status(0) = '0') then 
					next_state	<= Branch;
					pc_inc		<= "01";
				else
					next_state 	<= Branch_c;
					pc_inc		<= "10";
				end if;
				
			when "10110110" => --BVCA
				if(status(2) = '0') then 
					next_state	<= Branch;
					pc_inc		<= "01";
				else
					next_state 	<= Branch_c;
					pc_inc		<= "10";
				end if;
				
			when "10110111" => --BVSA
					if(status(2) = '1') then 
					next_state	<= Branch;
					pc_inc		<= "01";
				else
					next_state 	<= Branch_c;
					pc_inc		<= "10";
				end if;
				
			when "11111011" => -- DECA
				next_state <= DECA;
			when "11111010" => -- INCA
				next_state <= INCA;
			when "11111000" => -- SETC
				next_state <= SETC;
			when "11111001" => -- CLRC
				next_state <= CLRC;
				
			when "10001001" => -- LDSI
				pc_inc <= "01";
				next_state <= LDSI;
			when "11001000" => -- CALL
				pc_inc <= "10";
				next_state <= CALL;
			when "11000000" =>
				pc_inc <= "10";
				next_state <= RET;
				
			when "10001010" => -- LDXI
				pc_inc <= "01";
				next_state <= LDXI;
			when "10111100" => -- LDAA_x
				pc_inc <= "01";
				next_state <= LDAA_X;
			when "11101100" => -- STAA_X
				pc_inc <= "01";
				next_state <= STAA_X;
			when "11111100" => -- INCX
				next_state <= INCX;
			when "11111101" => -- DECX
				next_state <= DECX;
			when others =>
				next_state <= init_state;
			end case;
		
		when LDAI => -- LDAI
			--ext_en <= '1';
			next_state <= LDAI_a;
		when LDAI_a =>
		    acc_en <= '1';
			next_state <= oc_prefetch;
			
			
		when LDAA => -- LDAA
			next_state <= LDAA_a;
		when LDAA_a =>
			mar_en <= "01";
			next_state <= LDAA_b;
		when LDAA_b => 
			mar_en <= "10";
			next_state <= LDAA_c;
		when LDAA_c => 
			addr_sel <= "11";
			pc_inc <= "01";
			next_state <= LDAA_d;
		when LDAA_d =>
			addr_sel <= "11";
			next_state <= LDAA_e;
		when LDAA_e =>
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when LDAD => -- LDAD
			int_sel <= "001";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
			
		when STAA => -- STAA
			next_state <= STAA_a;
		when STAA_a =>
			mar_en <= "01";
			next_state <= STAA_b;
		when STAA_b =>
			mar_en <= "10";
			next_state <= STAA_c;
		when STAA_c =>
			mar_en <= "10";
			next_state <= STAA_d;
		when STAA_d =>
			addr_sel <= "11";
			pc_inc <= "01";
			next_state <= STAA_e;
		when STAA_e =>
			int_sel <= "000";
			addr_sel <= "11";
			wren_temp <= '1';
			next_state <= STAA_f;
		when STAA_f =>
			next_state <= oc_prefetch;
			
			
		when STAR => -- STAR
			int_sel <= "000";
			data_en <= '1';
			next_state <= oc_prefetch;
			
			
		when ADCR_D => -- ADCR_D
			alu_sel <= "0000";
			alu_out_en <= '1';
			C_en <= '1';			
	     	V_en <= '1';
	    	S_en <= '1'; 
		    Z_en <= '1';
			next_state <= ADCR_D_a;
		when ADCR_D_a =>
	    	int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when SBCR_D => -- SBCR_D
			alu_sel <= "0001";
			alu_out_en <= '1';
			C_en <= '1';			
		    V_en <= '1';
		    S_en <= '1'; 
		    Z_en <= '1';
			next_state <= SBCR_D_a;
		when SBCR_D_a =>
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when CMPR_D => -- CMPR_D
			alu_sel <= "0010";
			C_en <= '1';			
			V_en <= '1';
			S_en <= '1'; 
			Z_en <= '1';
			next_state <= oc_prefetch;
			
		when ANDR_D => -- ANDR_D
			alu_sel <= "0011";
			alu_out_en <= '1';
			Z_en <= '1';
			S_en <= '1'; 
			next_state <= ANDR_D_a;
		when ANDR_D_a =>
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when ORR_D  => -- ORR_D
			alu_sel <= "0100";
			alu_out_en <= '1';
			Z_en <= '1';
			S_en <= '1';
			next_state <= ORR_D_a;
	    when ORR_D_a =>
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when XORR_D => -- XORR_D
			alu_sel <= "0101";
			alu_out_en <= '1';
			Z_en <= '1';
			S_en <= '1';
			next_state <= XORR_D_a;
		when XORR_D_a => 
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when SLRL => -- SLRL
			alu_sel <= "0110";
			alu_out_en <= '1';
			C_en <= '1';
			Z_en <= '1';
			S_en <= '1';
			next_state <= SLRL_a;
		when SLRL_a =>
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when SRRL => -- SRRL
			alu_sel <= "0111";
			alu_out_en <= '1';
			C_en <= '1';
			Z_en <= '1';
			S_en <= '1';
			next_state <= SRRL_a;
		when SRRL_a => 
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when ROLC => -- ROLC
			alu_sel <= "1000";
			alu_out_en <= '1';
			C_en <= '1';
			Z_en <= '1';
			S_en <= '1';
			next_state <= ROLC_a;
		when ROLC_a =>
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when RORC => -- RORC
			alu_sel <= "1001";
			alu_out_en <= '1';
			C_en <= '1';
			Z_en <= '1';
			S_en <= '1';
			next_state <= RORC_a;
		when RORC_a =>
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
			
		when Branch => -- Branch
			next_state <= Branch_a;
		when Branch_a =>
			pc_en  <= "01";
			next_state <= Branch_b;
		when Branch_b =>
		    pc_en <= "10";
			next_state <= Branch_c;
		when Branch_c =>
			next_state <= Branch_d;
		when Branch_d =>
			next_state <= oc_prefetch;
			
		
		when DECA => -- DECA
			alu_sel <= "1011";
			alu_out_en <= '1';
			Z_en <= '1';
			S_en <= '1';
			next_state <= DECA_a;
		when DECA_a =>
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
	
		when INCA => -- INCA
			alu_sel <= "1010";
			alu_out_en <= '1';
			Z_en <= '1';
			S_en <= '1';
			next_state <= INCA_a;
		when INCA_a => 
			int_sel <= "010";
			acc_en <= '1';
			next_state <= oc_prefetch;
			
		when SETC => -- SETC
			alu_sel <= "1100";
			C_en <= '1';
			next_state <= oc_prefetch;
			
		when CLRC => -- CLRC
			alu_sel <= "1101";
			C_en <= '1';
			next_state <= oc_prefetch;
			
		when LDSI => -- LDSI
			--ext_en <= '1';
			next_state <= LDSI_a;
		when LDSI_a =>
			sp_en <= "01";
			pc_inc <= "01";
			next_state <= LDSI_b;
		when LDSI_b =>
			sp_en <= "10";
			next_state <= LDSI_c;
		when LDSI_c =>
			next_state <= oc_prefetch;
			
			
			
			
		when CALL => -- CALL
			addr_sel <= "01"; --sel sp
			wren_temp <= '1';
			int_sel <= "100";
			mar_en <= "01";
			sp_dec <= "01";
			next_state <= CALL_a;
		when CALL_a =>
			addr_sel <= "01";
			wren_temp <= '1';
			int_sel <= "100";
			mar_en <= "10";
			mar_dec <= "10";
			next_state <= CALL_b;
		when CALL_b =>
			addr_sel <= "11";
			mar_inc <= "01";
			next_state <= CALL_c;
		when CALL_c =>
			addr_sel <= "11";
			sp_dec <= "01";
			next_state <= CALL_d;
		when CALL_d =>
			pc_en <= "01";
			addr_sel <= "11";
			mar_inc <= "01";
			next_state <= CALL_e;
		when CALL_e =>
			pc_en <= "10";
			next_state <= CALL_f;
		when CALL_f =>
			next_state <= oc_prefetch;
			
			
		when RET  =>
			addr_sel <= "01";
			sp_inc <= "01";
			next_state <= RET_a;
		when RET_a =>
			addr_sel <= "01";
			next_state <= RET_b;
		when RET_b =>
			addr_sel <= "01";
			pc_en <= "10";
			next_state <= RET_c;
		when RET_c =>
			addr_sel <= "01";
			pc_en <= "01";
			next_state <= RET_d;
		when RET_d =>
			next_state <= oc_prefetch;
			
			
			
		when LDXI => -- LDXI
			--ext_en <= '1';
			next_state <= LDXI_a;
		when LDXI_a =>
			x_en <= "01";
			pc_inc <= "01";
			next_state <= LDXI_b;
		when LDXI_b =>
			--ext_en <= '1';
			next_state <= LDXI_c;
		when LDXI_c =>
			x_en <= "10";
			next_state <= LDXI_d;
		when LDXI_d =>
			next_state <= oc_prefetch;
			
			
			
		when LDAA_X => -- LDAA_X
			--ext_en <= '1';
			next_state <= LDAA_X_a;
		when LDAA_X_a =>
			x_jump_en <= '1';
			next_state <= LDAA_X_b;
		when LDAA_X_b =>
			addr_sel <= "10";
			next_state <= LDAA_X_c;
		when LDAA_X_c =>
		    --ext_en <= '1';
			next_state <= LDAA_X_d;
		when LDAA_X_d =>
			acc_en <= '1';
			next_state <= oc_prefetch;
			
			
		when STAA_X => -- STAA_X
			--ext_en <= '1';
			next_state <= STAA_X_a;
		when STAA_X_a =>
			x_jump_en <= '1';
			next_state <= STAA_X_b;
		when STAA_X_b =>
			int_sel <= "000";
			--ext_sel <= "10";
			addr_sel <= "10";
			wren_temp <= '1';
			next_state <= STAA_X_c;
		when STAA_X_c =>
			next_state <= oc_prefetch;
			
			
		when INCX => -- INCX
			int_sel <= "010";
			x_inc <= "01";
			next_state <= INCX_a;
		when INCX_a =>
			next_state <= oc_prefetch;
		
			
		when DECX => -- DECX
			int_sel <= "010";
			x_inc <= "01";
			next_state <= DECX_a;
		when DECX_a => 
			next_state <= oc_prefetch;
			
		when others =>
			next_state <= oc_prefetch;
		end case;
		
	end process;
	
	process(address, wren_temp)
	begin
		
		ext_sel <= "11";
		ext_en <= '0';
		output1_en <= '0';
		output2_en <= '0';
		
		if(address = x"FFFE") then 
			if(wren_temp = '0') then
				ext_sel <= "00";
				ext_en <= '1';
				wren <= '0';
			else 
				ext_sel <= "10";
				output1_en <= '1';
				wren <= '1';
			end if;
		
		elsif(address = x"FFFF") then 
			if(wren_temp = '0') then
				ext_sel <= "01";
				ext_en <= '1';
				wren <= '0';
			else 
				ext_sel <= "10";
				output2_en <= '1';
				wren <= '1';
			end if;
			
		else
			if(wren_temp = '0') then
				ext_sel <= "11";
				ext_en <= '1';
				wren <= '0';
			else 
				ext_sel <= "10";
				wren <= '1';
			end if;
		end if;
	end process;
				


end bhv;