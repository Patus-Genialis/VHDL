library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity NBitsAdder is
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bits imput
		 s: out std_logic_vector(31 downto 0)); -- 32 bits output
end NBitsAdder;

architecture logic of NBitsAdder is

begin
	s <= a + b; -- adder
end logic;