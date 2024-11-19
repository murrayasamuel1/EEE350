library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all; 


entity datapath is
	generic ( R : integer := 8; -- number of registers
			Md : integer := 8; -- width of address
			Wd : integer := 16 ); -- width of data
	port(reset,clk,read_write,load : in STD_LOGIC;
		 SourceSel : in UNSIGNED (1 downto 0);
		 fixed, ExternaInput : in SIGNED (Wd-1 downto 0);
 		 address : in UNSIGNED(Md-1 downto 0); 
		 loadsel : in INTEGER range 0 to R-1;
 		 OPsel : in integer range 0 to 7;
 		 selectA, selectB : in INTEGER range 0 to R-1;
		 Z,N : out std_logic;
		 ExternaOutput : out SIGNED (Wd-1 downto 0) );
end datapath;

architecture structure of datapath is

	signal I0,I1,I2,I3, dB, dRAM, dALU, dA, dMUX: SIGNED(Wd-1 downto 0);	
begin
	data_memory : entity work.dataRAM(datamemory)
		generic map (
			Md => Md,
			Wd => Wd
		)
		port map (
			CLK => CLK,
			read_write => read_write,
			address => address,
			datain => dB,
			dataout => dRAM
		);		
	Mux_41 : entity work.mux(muxVerstappen)
		port map ( 
		I0 => dALU,
		I1 => fixed,
		I2 => ExternaInput,
		I3 => dRAM,
		SourceSel => SourceSel,
		Dout => dMUX
		);			
	A_L_U : entity work.ALU(arithmetic)	
		port map(
			A=>dA, 
			B=>dB, 
			F=> dALU,
			OPsel=>OPsel
		);				
	status_r_egister : entity work.statusregister(status)
		port map (
			clk=>clk,
			F=>dALU,
			reset=>reset,
			loadSR=>load,
			Z=>Z,
			N=>N		 
		); 		
		register_f_ile : entity work.register_file(lt_algo_rain)  
		port map(
		data=>dMUX,
		loadsel => loadsel,
		load=>load,
		clk=>clk,
		reset=>reset,
		selectA => selectA,
		selectB => selectB,
		A=>dA,
		B=>dB
		);			
end architecture structure;	 



	