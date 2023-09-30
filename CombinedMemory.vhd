-- Instruction Memory and Data Memory
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CombinedMemory is
  port( WE, RE, clk:  in std_logic; -- WE = 1 => write, RE = 1 => read
		  A_DM: in std_logic_vector(5 downto 0); -- address data memory
		  WD: in std_logic_vector(31 downto 0); -- write data data memory
		  A_inst: in std_logic_vector(5 downto 0); -- address instruction memory
		  RD: out std_logic_vector(31 downto 0); -- read data data memory
		  Inst: out std_logic_vector(31 downto 0)); -- read data instruction memory
end CombinedMemory;

architecture logic of CombinedMemory is

component DataMemory is
  port( WE, clk:  in std_logic; -- WE = 1 => write
		A: in std_logic_vector(5 downto 0); -- address
		WD: in std_logic_vector(31 downto 0); -- write data
	    RD: out std_logic_vector(31 downto 0)); -- read data
end component;

component InstructionMemory is
	port(A: in std_logic_vector(5 downto 0); -- address
	     RD: out std_logic_vector(31 downto 0)); -- read data
end component;

begin
	Instruct: instructionMemory port map (A_inst, Inst); -- instance of instruction memory
	DM: dataMemory port map (WE, clk, A_DM, WD, RD); -- instance of data memory
end logic;