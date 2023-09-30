-- 26 bit shift left by 2
library ieee;
use ieee.std_logic_1164.all;

entity shift_26_28 is
	port(a: in std_logic_vector(25 downto 0); -- 26 bit input
	     q: out std_logic_vector(27 downto 0)); -- 28 bit output
end shift_26_28;

architecture logic of shift_26_28 is

begin
	q <= a & "00"; -- concatenate 2 zeros to the end of the input (shift left by 2) 
end logic;