-- complete MIPS ALU
library ieee;
use ieee.std_logic_1164.all;

entity ALU is 
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bits input
		 op: in std_logic_vector(3 downto 0); -- 4 bits OPcode
		 result: out std_logic_vector(31 downto 0); -- 32 bits output
		 Bc: out std_logic); -- Bcond flag
end ALU;

architecture logic of ALU is

component AritmeticAndLogic is 
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bits input
		 op: in std_logic_vector(3 downto 0); -- 4 bits OPcode
		 q: out std_logic_vector(31 downto 0)); -- 32 bits output
end component;

component Bcond is
	port(x: in std_logic_vector(31 downto 0); -- 32 bit input
		 Bcond: out std_logic); -- Bcond flag
end component;

signal Out_ALU: std_logic_vector(31 downto 0) := x"00000000"; -- 32 bits auxiliary signal inicialized with 0
signal Out_Bcond: std_logic := '0'; -- Bcond flag auxiliary signal inicialized with 0

begin
	AritAndLogic: AritmeticAndLogic port map(a, b, op, Out_ALU); -- instance of AritmeticAndLogic component
	Branch: Bcond port map(Out_ALU, Out_Bcond); -- instance of Bcond component

	result <= Out_ALU;
	Bc <= Out_Bcond;
end logic;