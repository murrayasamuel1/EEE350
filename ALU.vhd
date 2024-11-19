library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	generic(Wd:positive :=16); -- width of data
	port(F: out signed (Wd-1 downto 0);
		 A,B: in signed(Wd-1 downto 0);
	     OPsel: in integer range 0 to 7);
end ALU;

architecture arithmetic of ALU is 
begin	
	with OPsel select F<=	 
		A+B 	 when 0,
		A-B 	 when 1,
		signed(shift_right(unsigned(A),to_integer(B))) when 2,
		signed(shift_left(unsigned(A),to_integer(B))) when 3,
		not(A)   when 4,
		A AND B  when 5,
		A OR B   when 6,
		A		 when 7,
	    (others=>'X')when others;			
end arithmetic;