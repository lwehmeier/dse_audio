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
-- The calculation needs 3 clock cycles.
architecture behav of soundgen_triangle is
signal reg1: unsigned(sample_rate'length - 1 downto 0);
signal reg2: pcm_data_t;
begin
    process (clk)
    variable period_over_2: unsigned(sample_rate'length - 1 downto 0) := to_unsigned(0, sample_rate'length);
    variable idx: unsigned(sample_rate'length - 1 downto 0) := to_unsigned(0, sample_rate'length);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                reg1 <= to_unsigned(0, sample_rate'length);
            elsif ce = '1' and period > 0 then
                -- get the index for the saw lut
                period_over_2 := shift_right(period, 1);
                if counter < period_over_2 then
                    idx := resize(shift_left(counter, 1), sample_rate'length);
                else
                    idx := resize(shift_left((period - counter), 1), sample_rate'length);
                end if;

                if idx > period then
                    idx := period;
                end if;

                reg1 <= idx;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                reg2 <= to_signed(0, pcm_data_t'length);
            else
                -- get the sample from the saw lut for the previously
                -- calculated index.
                reg2 <= soundgen_saw_lut.counter_over_period(reg1, period);
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                pcm_out <= to_signed(0, pcm_data_t'length);
            else
                -- apply the currently set volume to the signal
                pcm_out <= apply_volume(reg2, volume);
            end if;
        end if;
    end process;

end behav;
