-- MIPS ALU control unit
library ieee;
use ieee.std_logic_1164.all;

entity ALUControlUnit is
	port(Func: in std_logic_vector(5 downto 0); -- funct field
		 ALUop: in std_logic_vector(1 downto 0); -- ALUop field
		 q: out std_logic_vector(3 downto 0)); -- ALU control output
end ALUControlUnit;

architecture logic of ALUControlUnit is
begin
	process(Func, ALUop)
		begin
			case ALUop is
				when "00" => q <= "0000"; -- lw, sw, j, 
				when "01" => q <= "0010"; -- beq
				when others => case Func is
					when "100000" => q <= "0000"; -- add
					when "100010" => q <= "0010"; -- sub
					when "100100" => q <= "0100"; -- and
					when "100101" => q <= "0101"; -- or 
					when "100110" => q <= "0110"; -- xor
					when "100111" => q <= "0111"; -- nor
					when "101010" => q <= "1010"; --slt
					when others => q <= "XXXX"; -- invalid
			end case;
		end case;
	end process;
end logic;