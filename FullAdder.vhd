library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
	port(a, b, cin: in std_logic; -- inputs
		 s, cout: out std_logic); -- outputs
end FullAdder;

architecture logic of FullAdder is

begin
    s <= a xor b xor cin; -- sum
    cout <= (a and b) or ((a xor b) and cin); -- carry
end logic;