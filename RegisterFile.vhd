-- MIPS Register File
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
  port( WE3, clk:  in std_logic; -- WE3 = write enable for register 3
		  A1, A2, A3: in std_logic_vector(4 downto 0); -- A1 = address for register 1, A2 = address for register 2, A3 = address for register 3
		  WD3: in std_logic_vector(31 downto 0); -- WD3 = write data for register 3
		  RD1 , RD2: out std_logic_vector(31 downto 0); -- RD1 = read data for register 1, RD2 = read data for register 2
		  reset: in std_logic); -- reset = reset signal
end RegisterFile;

architecture logic of RegisterFile is

type t_array is array (0 to 31) of std_logic_vector(31 downto 0); -- 32 registers, each 32 bits wide
signal mem : t_array := (others => (others => '0')); -- initialize all registers to 0

begin
  process(clk, reset) -- process for writing to register 3
  begin
		if (reset = '1') then -- reset all registers to 0
			mem <= (others => (others => '0'));
		elsif (WE3 = '1') then -- write to register 3
			if (rising_edge(clk)) then
				mem(to_integer(unsigned(A3))) <= WD3; -- write data to register 3
			end if;
		end if;
  end process;
  
	process (WE3, clk,A1, A2, A3, WD3, reset) -- process for reading from registers 1 and 2
	begin
		if (to_integer(unsigned(A1)) = 0) then -- if address is 0, read 0
				rd1 <= X"00000000";
		else 
			rd1 <= mem(to_integer(unsigned(A1))); -- read data from register 1
		end if;
		if (to_integer(unsigned(A2)) = 0) then -- if address is 0, read 0
			rd2 <= X"00000000";
		else
			rd2 <= mem(to_integer(unsigned(A2))); -- read data from register 2
		end if;
	end process;
end logic;