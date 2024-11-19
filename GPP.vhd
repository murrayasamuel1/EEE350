library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity processor is
-- Warning: Initial values are used by processor and components
	generic (  R : positive:= 16 ;   -- number of registers
	          Md : positive:= 8;     -- width of data_MEM address bus
	          Mi : positive:= 8;     -- width of inst_MEM address bus
	          Wd : positive:= 16;    -- width of datapath data
	          Wi : positive:= 16         );
	
   port(reset,clk:  in STD_LOGIC ;
	  fixed,ExternaInput :  in SIGNED(Wd-1 downto 0) ;
	       ExternaOutput : out SIGNED (Wd-1 downto 0));		   
end processor;

architecture doesntmatter of processor is 
signal load, read_write, Z, N,loadSR: STD_LOGIC;
signal loadSel,  selectA, selectB : INTEGER;
signal address : UNSIGNED(Md-1 downto 0);  
signal SourceSel : UNSIGNED(1 downto 0);
signal OPsel: UNSIGNED(2 downto 0);
begin
	controller : entity work.controlunit(algo)
		generic map (
		R => R,
		Mi => Mi,
		Wi => Wi,
		Md => Md 
		)
		port map (
		CLK => CLK,
		reset => reset,
		Z => Z,
		N => N,
		read_write => read_write, 
		load => load,
		loadSR => loadSR,
		SourceSel => SourceSel,
		OPsel => OPsel,
		selectA => selectA,
		selectB => selectB,
		loadsel => loadsel,
		address => address
		);
	logic : entity work.datapath(structure)
		generic map (
		R => R,
		Wd => Wd,
		Md => Md 
		)
		port map (
		CLK => CLK,
		reset => reset,
		Z => Z,
		N => N,
		fixed => fixed,
		ExternaInput => ExternaInput,
		ExternaOutput => ExternaOutput,
		read_write => read_write, 
		load => load,
		loadSR => loadSR,
		SourceSel => SourceSel,
		OPsel => OPsel,
		selectA => selectA,
		selectB => selectB,
		loadsel => loadsel,
		address => address
		);
end doesntmatter;