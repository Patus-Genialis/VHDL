-- 32-bit mux used in various places in the processor
library ieee;
use ieee.std_logic_1164.all;

entity mux_32b is
	port(a, b: in std_logic_vector(31 downto 0); -- 32-bit inputs
		 sel: in std_logic; -- 1-bit select
		 q: out std_logic_vector(31 downto 0)); -- 32-bit output
end mux_32b;

architecture logic of mux_32b is

begin
	process(sel, a, b)
	begin
		if (sel = '0') then -- if sel is 0, output a
			q <= a;
		else -- if sel is 1, output b
			q <= b;
		end if;
	end process;
end logic;