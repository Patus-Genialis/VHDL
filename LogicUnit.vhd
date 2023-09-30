-- MIPS ALU logic unit
library ieee;
use ieee.std_logic_1164.all;

entity LogicUnit is
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bits input
		 op: in std_logic_vector(3 downto 0); -- 4 bits OPcode
		 q: out std_logic_vector(31 downto 0)); -- 32 bits output
end LogicUnit;

architecture logic of LogicUnit is

begin
	process(a, b, op)
	begin
		case op(1 downto 0) is -- op(1 downto 0) select the logic operation
			when "00" => q <= a and b; 
			when "01" => q <= a or b; 
			when "10" => q <= a xor b; 
			when "11" => q <= a nor b;
			when others => q <= x"00000000"; -- default value
		end case;
	end process;
end logic;
