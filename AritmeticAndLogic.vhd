-- MIPS ALU (Arithmetic and Logic Unit)
library ieee;
use ieee.std_logic_1164.all;

entity AritmeticAndLogic is 
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bits input
		 op: in std_logic_vector(3 downto 0); -- 4 bits OPcode
		 q: out std_logic_vector(31 downto 0)); -- 32 bits output
end AritmeticAndLogic;

architecture logic of AritmeticAndLogic is

component AritmeticUnit is 
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bit inputs
		 op: in std_logic_vector(3 downto 0); -- 4 bit OPcode
		 q: out std_logic_vector(31 downto 0)); -- 32 bit output
end component;

component LogicUnit is
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bits input
		 op: in std_logic_vector(3 downto 0); -- 4 bits OPcode
		 q: out std_logic_vector(31 downto 0)); -- 32 bits output
end component;

signal Out_Aritmetic, Out_Logic: std_logic_vector(31 downto 0); -- 32 bits auxiliary signals

begin
	Aritmetic: AritmeticUnit port map (a, b, op, Out_Aritmetic); -- instance of AritmeticUnit component
	Logic: LogicUnit port map (a, b, op, Out_Logic); -- instance of LogicUnit component

	process(a, b, op, Out_Aritmetic, Out_Logic)
	begin
		if (op(2) = '0') then -- if bit 2 of OPcode is 0, then it's an arithmetic operation
			q <= Out_Aritmetic;
		else -- if bit 2 of OPcode is 1, then it's a logic operation
			q <= Out_Logic;
		end if;
	end process;
end logic;