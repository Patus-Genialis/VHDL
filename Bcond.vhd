-- MIPS ALU Bcond operation
library ieee;
use ieee.std_logic_1164.all;

entity Bcond is
	port(x: in std_logic_vector(31 downto 0); -- 32 bit input
		 Bcond: out std_logic); -- Bcond flag
end Bcond;

architecture logic of Bcond is

begin
	process(x)
	begin
		if (x = x"00000000") then -- if x is zero then set Bcond to 1
			Bcond <= '1';
		else -- else set Bcond to 0
			Bcond <= '0';
		end if;
	end process;
end logic;
