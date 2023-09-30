-- MIPS PC
library ieee;
use ieee.std_logic_1164.all;

entity PC is
  port(din: in std_logic_vector(31 downto 0); -- 32 bits input
		clk, clr: in std_logic; -- clock and reset
		dout: out std_logic_vector(31 downto 0)); -- 32 bits output
end PC;

architecture logic of PC is
begin
  process(clk, clr, din)
	begin
		if (clr = '1') then -- reset
			dout <= x"00000000";
		else 
			if (rising_edge(clk)) then -- saves the input value in the output when the clock rises
				dout <= din; 
			end if;
		end if;
	end process;
end logic;