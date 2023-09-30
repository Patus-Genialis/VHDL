-- Jump Address Generator
library ieee;
use ieee.std_logic_1164.all;

entity jump_address is
	port(inst: in std_logic_vector(27 downto 0); -- 28 bits of instruction	
		 pc: in std_logic_vector(3 downto 0); -- 4 bits of pc
		 q: out std_logic_vector(31 downto 0)); -- 32 bits output
end jump_address;

architecture logic of jump_address is

begin
	q <= pc & inst; -- concatenate pc and inst
end logic;