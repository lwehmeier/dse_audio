library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- pulse generator for 48kHz sample frequency
-- actually a fully configurable CE pulse generator, not fixed to 48kHz

-- GCLK: system clock
-- OUTPUT: CE signal output, pulse length: 1 system clock period
-- ENABLE: enable signal for internal counter
-- RESET: reset internal counter
-- TOP_VAL: maximum counter value, on overflow a CE pulse is generated

-- BIT_WIDTH: generic, counter width for internal timer

entity CEGEN48k is
    Generic (
        BIT_WIDTH : integer := 16
    );
    Port ( 
        GCLK : in STD_LOGIC;
        OUTPUT : out STD_LOGIC;
        ENABLE : in STD_LOGIC;
        TOP_VAL : in STD_LOGIC_VECTOR(BIT_WIDTH-1 downto 0);
        RESET : in STD_LOGIC
    );
end CEGEN48k;

architecture Behavioral of CEGEN48k is
signal COUNT : unsigned(BIT_WIDTH-1 downto 0) := to_unsigned(0, BIT_WIDTH);
begin
process(GCLK)
begin
    if rising_edge(GCLK) then
        if count = unsigned(TOP_VAL) then
            count <= to_unsigned(0, BIT_WIDTH);
            OUTPUT <= '1';
        else
            OUTPUT <= '0';
            if ENABLE='1' then
                COUNT <= COUNT + to_unsigned(1, BIT_WIDTH);
            end if;
        end if;
        if RESET='1' -- reset synchronous to GCLK
        then
            COUNT <= to_unsigned(0, BIT_WIDTH);
        end if;
   end if;
end process;
end Behavioral;