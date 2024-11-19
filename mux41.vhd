library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
	generic(Wd: positive:=16);  --width of data
	port(
	I0,I1,I2,I3: in signed (Wd-1 downto 0);	
	SourceSel: in unsigned(1 downto 0);
	Dout: out signed(wd-1 downto 0));
end mux; 


architecture muxVerstappen of mux is
begin
	with SourceSel select
		Dout<=
		   I0 when "00", 
		   I1 when "01",
		   I2 when "10",
		   I3 when "11",
		   "XX" when others; 
end muxVerstappen;	