-- 32-bit shift left by 2 used for the 32-bit adder in PC + offset 
library ieee;
use ieee.std_logic_1164.all;

entity shift_32_32 is 
	port(a: in std_logic_vector(31 downto 0); -- 32-bit input
		 q: out std_logic_vector(31 downto 0)); -- 32-bit output
end shift_32_32;

architecture logic of shift_32_32 is

begin
	q <= a(29 downto 0) & "00"; -- shift left by 2
end logic;