library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity statusregister is
    generic (Wd : positive := 16 );
    port (clk, reset    : in std_logic;
            loadSR      : in std_logic;
            F           : in signed (Wd-1 downto 0);
            N, Z        : out std_logic
    );
end statusregister;

architecture status of statusregister is
    signal out2 : std_logic_vector(1 downto 0);
begin
    process(clk, reset, loadSR) is
    begin
        if (reset = '1' and rising_edge(clk)) then
            out2 <= "00";
        elsif (loadSR = '1' and reset = '0'and rising_edge(clk)) then
            if (F = "0000000000000000") then
                out2 <= "01";
            elsif (F < 0) then
                out2 <= "10";
	    else
		out2 <= "00";
            end if;
        end if;
    end process;
    N <= out2(1);
    Z <= out2(0);
end status;
