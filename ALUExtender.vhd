-- this component is used in the MIPS ALU aritmetic unit
library ieee;
use ieee.std_logic_1164.all;

entity ALUExtender is
	port(x: in std_logic_vector(31 downto 0); -- 32 bit input
		 q: out std_logic_vector(31 downto 0)); -- 32 bit output
end ALUExtender;

architecture logic of ALUExtender is

begin
	process(x)
	begin
		if (x(31) = '1') then -- if the MSB is 1, then extend with 01
			q <= x"00000001";
		else -- if the MSB is 0, then extend with 00
			q <= x"00000000";
		end if;
	end process;
end logic;
