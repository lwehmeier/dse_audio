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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

architecture behav of soundgen_triangle is
begin
    process (clk)
    variable period_over_4: integer := 0;
    variable pcm: pcm_data_t := to_signed(0, pcm_data_t'length);
    begin
        if rising_edge(clk) then
            if ce = '1' and period > 0 then
                period_over_4 := to_integer(period) / 4;
                if counter >= 0 and counter < period_over_4 then
                    pcm := resize(pcm_max * signed('0' & counter) / period_over_4, pcm_data_t'length);
                elsif counter >= period_over_4 and counter < 2 * period_over_4 then
                    pcm := resize(pcm_max - (pcm_max * (signed('0' & counter) - period_over_4) / period_over_4), pcm_data_t'length);
                elsif counter >= 2 * period_over_4 and counter < 3 * period_over_4 then
                    pcm := resize(-(-pcm_min * (signed('0' & counter) - 2 * period_over_4) / period_over_4), pcm_data_t'length);
                else
                    pcm := resize(pcm_min + (-pcm_min * (signed('0' & counter) - 3 * period_over_4) / period_over_4), pcm_data_t'length);
                end if;
                pcm_out <= apply_volume(pcm, volume);
            end if;
        end if;
    end process;
end behav;
