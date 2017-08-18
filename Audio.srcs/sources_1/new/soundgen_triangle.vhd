----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.08.2017 13:41:53
-- Design Name: 
-- Module Name: soundgen_square - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.typedefs.all;
use work.soundgen.all;
use work.soundgen_saw_lut;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- The entity for a triangle sound generator
entity soundgen_triangle is
    port (
        clk: in std_logic;
        ce: in std_logic;
        pcm_out: out pcm_data_t;
        volume: in volume_t;
        counter: in unsigned(sample_rate'length - 1 downto 0);
        period: in unsigned(sample_rate'length - 1 downto 0);
        reset: in std_logic
    );
end soundgen_triangle;

-- architecture for the triangle generator
architecture behav of soundgen_triangle is
begin
    process (clk)
    variable period_over_2: integer := 0;
    variable pcm: pcm_data_t := to_signed(0, pcm_data_t'length);
    variable idx: unsigned(sample_rate'length - 1 downto 0) := to_unsigned(0, sample_rate'length); 
    begin
        if rising_edge(clk) then
            if ce = '1' and period > 0 then
                -- use the saw lut to generate a triangle wave
                period_over_2 := to_integer(period) / 2;
                if counter < period_over_2 then
                    idx := resize(counter * 2, sample_rate'length);
                    if idx > period then
                        idx := period;
                    end if;
                    pcm := soundgen_saw_lut.counter_over_period(idx, period);
                else
                    idx := resize((period - counter) * 2, sample_rate'length);
                    if idx > period then
                        idx := period;
                    end if;
                    pcm := soundgen_saw_lut.counter_over_period(idx, period);
                end if;
                pcm_out <= apply_volume(pcm, volume);
            end if;
        end if;
    end process;
end behav;
