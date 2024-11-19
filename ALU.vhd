library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	generic(Wd:positive :=16); -- width of data
	port(F: out signed (Wd-1 downto 0);
		 A,B: in signed(Wd-1 downto 0);
	     OPsel: in UNSIGNED(2 downto 0));
end ALU;

architecture arithmetic of ALU is 
begin	
	with OPsel select F<=	 
		A+B 	 when "000",
		A-B 	 when "001",
		signed(shift_right(unsigned(A),to_integer(B))) when "010",
		signed(shift_left(unsigned(A),to_integer(B))) when "011",
		not(A)   when "100",
		A AND B  when "101",
		A OR B   when "110",
		A		 when "111",
	    (others=>'X')when others;			
end arithmetic;