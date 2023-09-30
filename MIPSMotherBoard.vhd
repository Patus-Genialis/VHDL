-- MotherBoard that connects the processor and the memory
library ieee;
use ieee.std_logic_1164.all;

entity MIPSMotherBoard is
	port(clk, clear: in std_logic; -- clock and reset
		 writedata, dataadr: buffer STD_LOGIC_VECTOR(31 downto 0); -- data to be written in the data memory and address for the data memory
		 memwrite: buffer STD_LOGIC; -- write signal for the data memory
		 i, pc: buffer std_logic_vector(31 downto 0)); -- instruction to be executed and program counter
end MIPSMotherBoard;

architecture logic of MIPSMotherBoard is

component MIPSProcessor is
	port(clk, clear: in std_logic; -- clock and reset
		 Instruction: in std_logic_vector(31 downto 0); -- 32 bits instruction
		 ReadData_DM: in std_logic_vector(31 downto 0); -- data read from the data memory
		 ReadAddress: out std_logic_vector(31 downto 0); -- address of the instruction to be read from the instruction memory
		 Address_DM: out std_logic_vector(31 downto 0); -- address for the data memory
		 WriteData_DM: out std_logic_vector(31 downto 0); -- data to be written in the data memory
		 MemRead, MemWrite: out std_logic); -- read and write signals for the data memory
end component;

component CombinedMemory is
  port( WE, RE, clk:  in std_logic; -- WE = 1 => write, RE = 1 => read
		  A_DM: in std_logic_vector(5 downto 0); -- address data memory
		  WD: in std_logic_vector(31 downto 0); -- write data data memory
		  A_inst: in std_logic_vector(5 downto 0); -- address instruction memory
		  RD: out std_logic_vector(31 downto 0); -- read data data memory
		  Inst: out std_logic_vector(31 downto 0)); -- read data instruction memory
end component;

signal RE: std_logic; -- read signal for the data memory
signal out_DM: std_logic_vector(31 downto 0); -- data read from the data memory

begin
	Processor: MIPSProcessor port map(clk, clear, i, out_DM, pc , dataadr, writedata, RE, memwrite); -- instantiation of the processor
	Memory: CombinedMemory port map(memwrite, RE, clk, dataadr(7 downto 2), writedata, pc( 7 downto 2), out_DM, i); -- instantiation of the memory
end logic;