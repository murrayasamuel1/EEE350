library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
	generic (R:positive:=8; -- number of registers
	Wd:positive:=16); --width of data
	 port( reset : in STD_LOGIC; -- zeroes all registers
 	 clk : in STD_LOGIC; -- activated on rise edge
	 load : in STD_LOGIC; -- to write to a register
	 loadsel : in INTEGER range 0 to R-1; -- written register
	 selectA : in INTEGER range 0 to R-1; -- read register to A
	 selectB : in INTEGER range 0 to R-1; -- read register to B
	 data : in SIGNED (Wd-1 downto 0); 
	 A : out SIGNED (Wd-1 downto 0); 
	 B : out SIGNED (Wd-1 downto 0) );
end register_file; 

architecture lt_algo_rain of register_file is  -- you take that deal? I take that deal. Damn good deal.
type reg_type is ARRAY(0 to R-1) of SIGNED(Wd-1 downto 0);
signal registers: reg_type;
begin
	process(clk,reset)
	begin 
		if rising_edge(clk) then
			if reset='1' then --synchronous reset
				registers <= (others =>(others=> '0'));
			elsif load ='1' then
				registers(loadSel) <= data;
			end if;
		end if;
	end process;
	A <=registers(SelectA);
	B <=registers(SelectB);
end lt_algo_rain; 	