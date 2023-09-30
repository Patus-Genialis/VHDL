-- this component is used in the MIPS ALU aritmetic unit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity NBitsAddandSub is
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bit inputs
		 op: in std_logic; -- 0 for add, 1 for sub
		 s: out std_logic_vector(31 downto 0)); -- 32 bit output
end NBitsAddandSub;

architecture logic of NBitsAddandSub is

begin
	process(a, b, op) -- process for add/sub
	begin
		if (op = '0') then -- add
			s <= a + b;
		else -- sub
			s <= a - b;
		end if;
	end process;
end logic;