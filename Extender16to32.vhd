-- 16-bit extender to 32-bit used in type I instructions
library ieee;
use ieee.std_logic_1164.all;

entity extender_16_32 is
	port(x: in std_logic_vector(15 downto 0); -- 16-bit input
		 q: out std_logic_vector(31 downto 0)); -- 32-bit output
end extender_16_32;

architecture logic of extender_16_32 is

begin
	process(x) 
	begin
		if (x(15) = '1') then -- sign extension
			q <= x"FFFF" & x;
		else
			q <= x"0000" & x;
		end if;
	end process;
end logic;