library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity controlunit is
   generic(R : positive := 16;   -- number of registers
           Md: positive:= 8;     -- width of dRAM address 
           Mi: positive:= 8;     -- width of iRAM address
           Wi: positive:= 16);   -- width of instructions
   
   port(     reset,clk,Z,N:  in STD_LOGIC;
    read_write,load,loadSR: out STD_LOGIC;
                 SourceSel: out UNSIGNED (1 downto 0);
                    OPsel : out UNSIGNED(2 downto 0);
           selectA,selectB: out INTEGER range 0 to R-1;
                   loadsel: out INTEGER range 0 to R-1;
                   address: out UNSIGNED(Md-1 downto 0));  
end controlunit;		   
				   
architecture algo of controlunit is
--------------- DECLARATION SECTION ----------------------

-- Instruction memory and loading of instructions

type instructionType is array (0 to 2**Mi-1) of unsigned(Wi-1 downto 0);

-- The following code involves all five kinds of instrucitions
constant instructions: instructionType :=
--	(x"instruction", --BEFORE THIS, LOAD 05FC INTO EXTERNAL INPUT
--	 x"9000",  --dM[3] <= R12   memWRITE
--     x"9001",  -- R0 <= dM[0]    memREAD
--     x"8000",  -- R1 <= dM[1]    memREAD
--	 x"8101", 	
--	 x"1001",
--	 x"C407",
--	 x"1001",
--	 x"9303",
--	 x"
----    x"1C01",  -- R12 <= R0-R1   ALUop 
----    x"C405",  -- JPos 5         JUMP conditional (N flag)
----    x"1C10",  -- R12 <= R1-R0   ALUop
----    x"9C03",  -- dM[3] <= R12   memWRITE
----    x"F000",  -- STOP           exception
--    others => x"F000");


-- Finite State Machine, PC, and IR

type stateType is(start,fetch,decode,stop,writemem,readmem,ALUop,jump);
signal state: stateType := stop;  -- any state but start
signal   PC : unsigned (Mi-1 downto 0); 
signal   IR : unsigned (Wi-1 downto 0);

----------------- BODY SECTION ----------------------
begin

	 -- state transitions
	 process (CLK, reset) 
	 begin
	 if rising_edge(CLK) then
		if reset = '1' then state <= start;
		else
			case state is
				when start =>
					PC <= (others => '0');
					state <= fetch;
				when fetch =>
					IR <= instructions(to_integer(PC));
					PC <= PC + 1;
					state <= decode;
				when decode =>
					if (IR(15) = '0') then
					 state <= ALUop;
					else
						case IR(15 downto 12) is
							when "1000" => state <= readmem;
							when "1001" => state <= writemem;
							when "1100" => state <= jump;
							when "1111" => state <= stop;
							when others => state <= stop;
						end case;
					end if;
				when ALUop | readmem | writemem =>
					state <= fetch;
			 -- JUMP: always, 0, /=0, negative, or positive 
				when jump =>
					 if (IR(11 downto 8) = "0000") or 
					 (IR(11 downto 8) = "0001" and Z = '1') or
					 (IR(11 downto 8) = "0010" and Z = '0') or
					 (IR(11 downto 8) = "0011" and N = '1') or
					(IR(11 downto 8) = "0100" and N = '0')
				 then
					 PC <= IR(7 downto 0);
				end if;
			state <= fetch;
				when stop => state <= stop;
				when others => state <= start;
			end case;
		end if;
	end if;
end process; 
 	address <= IR(7 downto 0);
	read_write <= '0' when state = writemem else '1';
	with state select
	SourceSel <= 
	"00" when Aluop,
	"10" when writemem,
	"11" when readmem, --if it is readmem & load = 1: load from fixed
	"01" when others;
 	loadsel <= to_integer( IR(11 downto 8) );
 	selectA <= to_integer( IR(7 downto 4) );
 	selectB <= to_integer( IR(11 downto 8) ) when state = writemem else to_integer( IR(3 downto 0) );
 	load <= '1' when (state = ALUop or state = readmem or state = writemem) else '0';
 	OPsel <= ( IR(14 downto 12) );
 	loadSR <='1' when state = ALUop else '0';
end algo;

--																																					  ourxdh
--																																			fhdhfdhdfhdfhdfhdfhdfhdfhdfhdfh
																																					 

				   