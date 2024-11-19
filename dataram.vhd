library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;	




entity dataRAM is 
 	generic ( Md : integer := 8; -- width of address
 			  Wd : integer := 16 ); -- width of data	
 
 	port( CLK : in STD_LOGIC; -- activated on rise edge
	 read_write : in STD_LOGIC; -- 1 = read 0 = write
	 address : in unsigned (Md-1 downto 0);
 		datain : in SIGNED (Wd-1 downto 0); 
 		dataout : out SIGNED (Wd-1 downto 0) );
end dataRAM;								   

architecture datamemory of dataRAM is
	type ram_array is array (0 to 255) of signed (Wd-1 downto 0);
	signal RAM:ram_array := (others => (others => '0'));
	
begin
	process(CLK)
	begin
		if(rising_edge(CLK)) then
			case read_write is
				when '0' => RAM(to_integer(address)) <= datain;		   --writes
				when '1' => dataout <= RAM(to_integer(address));	--reads
				when others => dataout <= (others => 'X');
			end case;
		end if;
	end process;
	
end architecture datamemory;