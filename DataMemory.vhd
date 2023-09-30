-- MIPS Data Memory
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
  port( WE, clk:  in std_logic; -- WE = 1 => write
		A: in std_logic_vector(5 downto 0); -- address
		WD: in std_logic_vector(31 downto 0); -- write data
	    RD: out std_logic_vector(31 downto 0)); -- read data
end DataMemory;

architecture logic of DataMemory is

type t_array is array (0 to 63) of std_logic_vector(31 downto 0); -- 64 words of 32 bits
signal mem : t_array := (others => (others => '0')); -- initialize memory with 0

begin
  process(clk, WE)
  begin
		if (WE = '1') then -- write
			if (rising_edge(clk)) then -- write on rising edge
				mem(to_integer(unsigned(A))) <= WD;
			end if;
		end if;
  end process;
	RD <= mem(to_integer(unsigned(A))); -- read
end logic;