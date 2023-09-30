-- 5-bit mux used in the register file address
library ieee;
use ieee.std_logic_1164.all;

entity mux_5b is
	port(a, b: in std_logic_vector(4 downto 0); -- 5-bit inputs
		 sel: in std_logic; -- 1-bit select
		 q: out std_logic_vector(4 downto 0)); -- 5-bit output
end mux_5b;

architecture logic of mux_5b is

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