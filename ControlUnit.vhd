-- MIPS Control Unit
library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
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
end ControlUnit;

architecture logic of ControlUnit is

signal q: std_logic_vector(9 downto 0); -- auxilary signal for control unit

begin
	process(Inst)
	begin
		case Inst is
			when "000000" => q <= "1100000100"; -- type-r
			when"100011" => q <= "1010001000"; -- lw
			when"101011" => q <= "0010100000"; -- sw
			when"000100" => q <= "0001000010"; -- beq
			when"001000" => q <= "1010000000"; -- addi
			when"000010" => q <= "0000000001"; -- j
			when others => q <= "XXXXXXXXXX"; -- error
		end case;
	end process;
RegWrite <= q(9); RegDst <= q(8); ALUsrc <= q(7); Branch <= q(6);
MemWrite <= q(5); MemRead	<= q(4); MemtoReg <= q(3); ALUop <= q(2 downto 1);
Jump <= q(0); -- assign signals
end logic;