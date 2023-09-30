library ieee;
use ieee.std_logic_1164.all;

entity MIPSProcessor is
	port(clk, clear: in std_logic; -- clock and reset
		 Instruction: in std_logic_vector(31 downto 0); -- 32 bits instruction
		 ReadData_DM: in std_logic_vector(31 downto 0); -- data read from the data memory
		 ReadAddress: out std_logic_vector(31 downto 0); -- address of the instruction to be read from the instruction memory
		 Address_DM: out std_logic_vector(31 downto 0); -- address for the data memory
		 WriteData_DM: out std_logic_vector(31 downto 0); -- data to be written in the data memory
		 MemRead, MemWrite: out std_logic); -- read and write signals for the data memory
end MIPSProcessor;

architecture logic of MIPSProcessor is

component shift_26_28 is
	port(a: in std_logic_vector(25 downto 0); -- 26 bit input
	     q: out std_logic_vector(27 downto 0)); -- 28 bit output
end component;

component ALU is 
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bits input
		 op: in std_logic_vector(3 downto 0); -- 4 bits OPcode
		 result: out std_logic_vector(31 downto 0); -- 32 bits output
		 Bc: out std_logic); -- Bcond flag
end component;

component RegisterFile is
  port( WE3, clk:  in std_logic; -- WE3 = write enable for register 3
		  A1, A2, A3: in std_logic_vector(4 downto 0); -- A1 = address for register 1, A2 = address for register 2, A3 = address for register 3
		  WD3: in std_logic_vector(31 downto 0); -- WD3 = write data for register 3
		  RD1 , RD2: out std_logic_vector(31 downto 0); -- RD1 = read data for register 1, RD2 = read data for register 2
		  reset: in std_logic); -- reset = reset signal
end component;

component PC is
  port(din: in std_logic_vector(31 downto 0); -- 32 bits input
		clk, clr: in std_logic; -- clock and reset
		dout: out std_logic_vector(31 downto 0)); -- 32 bits output
end component;

component NBitsAddandSub is
	port(a, b: in std_logic_vector(31 downto 0); -- 32 bit inputs
		 op: in std_logic; -- 0 for add, 1 for sub
		 s: out std_logic_vector(31 downto 0)); -- 32 bit output
end component;

component mux_32b is
	port(a, b: in std_logic_vector(31 downto 0); -- 32-bit inputs
		 sel: in std_logic; -- 1-bit select
		 q: out std_logic_vector(31 downto 0)); -- 32-bit output
end component;

component mux_5b is
	port(a, b: in std_logic_vector(4 downto 0); -- 5-bit inputs
		 sel: in std_logic; -- 1-bit select
		 q: out std_logic_vector(4 downto 0)); -- 5-bit output
end component;

component extender_16_32 is
	port(x: in std_logic_vector(15 downto 0); -- 16-bit input
		 q: out std_logic_vector(31 downto 0)); -- 32-bit output
end component;

component jump_address is
	port(inst: in std_logic_vector(27 downto 0); -- 28 bits of instruction	
		 pc: in std_logic_vector(3 downto 0); -- 4 bits of pc
		 q: out std_logic_vector(31 downto 0)); -- 32 bits output
end component;

component shift_32_32 is 
	port(a: in std_logic_vector(31 downto 0); -- 32-bit input
		 q: out std_logic_vector(31 downto 0)); -- 32-bit output
end component;

component ControlUnit is
	port(Inst: in std_logic_vector(5 downto 0); -- instruction 
		 RegDst: out std_logic; -- select register destination
		 Jump: out std_logic; -- jump
		 Branch: out std_logic; -- branch
	     MemWrite: out std_logic; -- write memory
		 MemtoReg: out std_logic; -- select memory destination
		 ALUop: out std_logic_vector(1 downto 0); -- select ALU operation
		 ALUsrc: out std_logic; -- select ALU source
		 RegWrite: out std_logic; -- write register
		 MemRead: out std_logic); -- read memory
end component;

component ALUControlUnit is
	port(Func: in std_logic_vector(5 downto 0); -- funct field
		 ALUop: in std_logic_vector(1 downto 0); -- ALUop field
		 q: out std_logic_vector(3 downto 0)); -- ALU control output
end component;

signal out_PC, out_PC_Fadder, out_Jump, out_RD1, out_RD2, out_extender_16_32: std_logic_vector(31 downto 0);
signal out_mux_32b_RD, out_ALU, out_shift_32_32, out_mux_32b_BR, out_mux_32b_Jump, out_mux_32b_DM: std_logic_vector(31 downto 0);
signal out_BR_Fadder: std_logic_vector(31 downto 0);
signal out_shift_26_28: std_logic_vector(27 downto 0);
signal RegDst, Jump, Branch, ALUsrc, MemtoReg, RegWrite, bcond, BrTaken: std_logic;
signal ALUop: std_logic_vector(1 downto 0);
signal ALUoperation: std_logic_vector(3 downto 0);
signal out_mux_5b: std_logic_vector(4 downto 0);

begin
	PCRun: PC port map(out_mux_32b_Jump, clk, clear, out_PC); -- PC is the program counter
	ReadAddress <= out_PC; -- ReadAddress is the address of the instruction to be read from the instruction memory
	PCAdder: NBitsAddandSub port map(out_PC, x"00000004", '0', out_PC_Fadder); -- PCAdder adds 4 to the PC
	ShiftForJump: shift_26_28 port map(Instruction(25 downto 0), out_shift_26_28); -- shift_26_28 shifts the 26 bit jump address to the left by 2
	PCAndJump: jump_address port map(out_shift_26_28, out_PC_Fadder(31 downto 28), out_Jump); -- jump_address concatenates the 4 most significant bits of the PC with the 26 bit jump address
	Control: ControlUnit port map(Instruction(31 downto 26), RegDst, Jump, Branch, MemWrite, MemtoReg, ALUop, ALUsrc, RegWrite, MemRead); -- control unit
	ALUControl: ALUControlUnit port map(Instruction(5 downto 0), ALUop, ALUoperation); -- ALU_control unit
	RegisterDest: mux_5b port map(Instruction(20 downto 16), Instruction(15 downto 11), RegDst, out_mux_5b); -- mux_5b selects the register destination
	RegisterF: registerFile port map(RegWrite, clk, Instruction(25 downto 21), Instruction(20 downto 16), out_mux_5b, out_mux_32b_DM, out_RD1, out_RD2, clear); -- registerFile
	Imediate: extender_16_32 port map(Instruction(15 downto 0), out_extender_16_32); -- extender_16_32 extends the 16 bit immediate to 32 bits
	ALUSignalB: mux_32b port map(out_RD2, out_extender_16_32, ALUsrc, out_mux_32b_RD); -- mux_32b selects the second operand for the ALU
	ALUu: ALU port map(out_RD1, out_mux_32b_RD, ALUoperation, out_ALU, bcond); -- ALU
	OffsetPC: shift_32_32 port map(out_extender_16_32, out_shift_32_32); -- shift_32_32 shifts the 32 bit immediate to the left by 2
	PCPlusOffset: NBitsAddandSub port map(out_PC_Fadder, out_shift_32_32, '0', out_BR_Fadder); -- PCAdder adds the shifted immediate to the PC
    BrTaken <= Branch and bcond; -- BrTaken is the signal that indicates if the branch is taken
	BranchOrPC: mux_32b port map(out_PC_Fadder, out_BR_Fadder, BrTaken, out_mux_32b_BR); -- mux_32b selects the address for the branch or the next instruction
	JumpOrPrevious: mux_32b port map(out_mux_32b_BR, out_Jump, Jump, out_mux_32b_Jump); -- mux_32b selects the address for the jump or the previous output
	Address_DM <= out_ALU; -- Address_DM is the address for the data memory
	WriteData_DM <= out_RD2; -- WriteData_DM is the data to be written in the data memory
	DataToRegister: mux_32b port map(out_ALU, ReadData_DM, MemtoReg, out_mux_32b_DM); -- mux_32b selects the data to be written in the register
end logic;