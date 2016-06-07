library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_ns is
generic (
			WIDTH : positive := 8);
	port (
		acc  : in unsigned(WIDTH-1 downto 0);
		data : in unsigned(WIDTH-1 downto 0);
		sel  : in std_logic_vector(3 downto 0);
		cin  : in std_logic := '0';
		output : out std_logic_vector(WIDTH-1 downto 0);
		cout : out std_logic;
		vout : out std_logic;
		sout : out std_logic;
		zout : out std_logic
		);

end alu_ns;

architecture ALU of alu_ns is

begin

	
process (acc, data, cin, sel)

	variable temp_result : unsigned(WIDTH downto 0);
	variable temp_boolean : unsigned(WIDTH-1 downto 0);
	variable temp_rotate : unsigned(WIDTH downto 0);
	variable temp : unsigned(WIDTH downto 0);
	variable temp_shift : unsigned(WIDTH-1 downto 0);
	
	begin
	
	vout <= '0';
	cout <= '0';
	sout <= '0';
	zout <= '0';
	output <= (others => '0');
	
		case sel is
			when "0000" => --ADD
				if(cin = '1') then
					temp_result := ('0' & acc) + ('0' & data) + 1;
				else
					temp_result := ('0' & acc) + ('0' & data);
				end if;
				
				output <= std_logic_vector(temp_result(WIDTH-1 downto 0));
				cout <= temp_result(WIDTH);
				vout <= '0';
				
				if(acc(WIDTH-1) = '1' and data(WIDTH-1) = '1') then
					if(temp_result(WIDTH-1) = '0') then
						vout <= '1';
					end if;
				elsif(acc(WIDTH-1) = '0' and data(WIDTH-1) = '0') then
					if(temp_result(WIDTH-1) = '1') then
						vout <='1';
					end if;
				end if;
				
				sout <= temp_result(WIDTH-1);
				
				if(temp_result = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
					
			when "0001" => --SUB
				if(cin = '1') then
					temp_result := ('0' & acc) + not('0' & data) + 1;
				else
					temp_result := ('0' & acc) + not('0' & data) + 1;
				end if;
				
				output <= std_logic_vector(temp_result(WIDTH-1 downto 0));
				cout <= temp_result(WIDTH);
				
				if(acc(WIDTH-1) = '1' and data(WIDTH-1) = '1') then
					if(temp_result(WIDTH-1) = '0') then
						vout <= '1';
					end if;
				elsif(acc(WIDTH-1) = '0' and data(WIDTH-1) = '0') then
					if(temp_result(WIDTH-1) = '1') then
						vout <='1';
					end if;
				end if;
				
				sout <= temp_result(WIDTH-1);
				
				if(temp_result = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
				
			when "0010" => --COMP	
				temp_result := ('0' & acc) + not('0' & data) + 1;
				cout <= temp_result(WIDTH);
				
				if(acc(WIDTH-1) = '1' and data(WIDTH-1) = '1') then
					if(temp_result(WIDTH-1) = '0') then
						vout <= '1';
					end if;
				elsif(acc(WIDTH-1) = '0' and data(WIDTH-1) = '0') then
					if(temp_result(WIDTH-1) = '1') then
						vout <='1';
					end if;
				end if;
				
				sout <= temp_result(WIDTH-1);
				
				if(temp_result = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
						
			when "0011" => --AND
				temp_boolean := acc and data;
				sout <= temp_boolean(WIDTH-1);
				
				if(temp_boolean = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
				
				output <= std_logic_vector(temp_boolean);
				
			when "0100" => --OR
				temp_boolean := acc or data;
				sout <= temp_boolean(WIDTH-1);
				
				if(temp_boolean = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
				
				output <= std_logic_vector(temp_boolean);
				
			when "0101" => --XOR
				temp_boolean := acc xor data;
				sout <= temp_boolean(WIDTH-1);
				
				if(temp_boolean = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
				
				output <= std_logic_vector(temp_boolean);
				
			when "0110" => --SL
				temp_shift := shift_left(acc, 1);
				cout <= acc(WIDTH-1);
				
				sout <= temp_shift(WIDTH-1);
				
				if(temp_shift = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
				
				output <= std_logic_vector(temp_shift);
				
			when "0111" => --SR
				temp_shift := shift_right(acc, 1);
				cout <= acc(WIDTH-WIDTH);
				
				sout <= temp_shift(WIDTH-1);
				
				if(temp_shift = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
				
				output <= std_logic_vector(temp_shift);
				
			when "1000" => --RL
				temp_rotate := (cin & acc);
				temp := rotate_right(temp_rotate, 1);
				cout <= acc(WIDTH-1);
				
				sout <= temp(WIDTH-1);
				
				if(temp = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
				
				output <= std_logic_vector(temp(WIDTH-1 downto 0));
				
			when "1001" => --RR
				temp := (cin & acc);
				temp := rotate_right(temp, 1);
				cout <= temp(WIDTH);
				
				sout <= temp(WIDTH-1);
				
				if(temp(WIDTH-1 downto 0) = 0) then
					zout <= '1';
				else 
					zout <= '1';
				end if;
				
				output <= std_logic_vector(temp(WIDTH-1 downto 0));
				
			when "1010" => --INCA
				temp_result := ('0' & acc) + 1;
				
				output <= std_logic_vector(temp_result(WIDTH-1 downto 0));
				
				if(temp_result = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
				
				sout <= temp_result(WIDTH-1);
				
				
			when "1011" => --DECA
				temp_result := ('0' & acc) - 1;
				output <= std_logic_vector(temp_result(WIDTH-1 downto 0));
				
				if(temp_result = 0) then
					zout <= '1';
				else 
					zout <= '0';
				end if;
				
				sout <= temp_result(WIDTH-1);
			
			when "1100" => --SETC
				cout <= '1';
				
			when "1101" => --CLRC
				cout <= '0';
				
			when others =>
		
		end case;
		
end process;

end ALU;
