-- MIPS ALU aritmetic unit
library ieee;
use ieee.std_logic_1164.all;

entity AritmeticUnit is 
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bit inputs
		 op: in std_logic_vector(3 downto 0); -- 4 bit OPcode
		 q: out std_logic_vector(31 downto 0)); -- 32 bit output
end AritmeticUnit;

architecture logic of AritmeticUnit is

component NBitsAddandSub is
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bit inputs
		 op: in std_logic; -- 0 for add, 1 for sub
		 s: out std_logic_vector(31 downto 0)); -- 32 bit output
end component;

component ALUExtender is
	port(x: in std_logic_vector(31 downto 0); -- 32 bit input
		 q: out std_logic_vector(31 downto 0)); -- 32 bit output
end component;

signal Out_Adder, Out_Extend: std_logic_vector(31 downto 0);

begin
	Add_Sub: NBitsAddandSub port map(a, b, op(1), Out_Adder); -- op(1) is the second bit of the OPcode that select add or sub
	Extend: ALUExtender port map(Out_Adder, Out_Extend);

	process(a, b, op, Out_Adder, Out_Extend)
	begin
		if(op(3) = '0') then -- op(3) is the fourth bit of the OPcode that select between add/sub and extend
			q <= Out_Adder; 
		else
			q <= Out_Extend;
		end if;
	end process;
end logic;
