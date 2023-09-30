-- MIPS Instruction Memory
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity InstructionMemory is
	port(A: in std_logic_vector(5 downto 0); -- address
	     RD: out std_logic_vector(31 downto 0)); -- read data
end InstructionMemory;
		  
architecture logic of InstructionMemory is

type t_array is array (0 to 63) of std_logic_vector(31 downto 0); -- 64 words of 32 bits

impure function init(FileName : in string) return t_array is
  file     fl  : text open read_mode is FileName; -- file to read
  variable ln    : line; -- line read from file
  variable temp_bv  : std_logic_vector(31 downto 0); -- temporary bit vector
  variable temp_mem : t_array; -- temporary memory
  begin
    for i in t_array'range loop
		if not endfile(fl) then
			readline(fl, ln); -- read line from file
			hread(ln, temp_bv); -- convert hex line to bit vector
			temp_mem(i) := temp_bv(31 downto 0); -- store in memory
		else
			report "End of File." severity note; -- end of file
			return temp_mem; -- return memory
		end if;
    end loop;
    return temp_mem; -- return memory
  end;
  
constant mem : t_array := init("mem.txt"); -- initialize memory

begin
  RD <= mem(to_integer(unsigned(A))); -- read memory
end logic;