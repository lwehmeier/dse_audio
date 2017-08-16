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
        note: in note_t;
        volume: in volume_t;
        counter: in unsigned(sample_rate'length - 1 downto 0);
        reset: in std_logic
    );
end soundgen_triangle;

architecture behav of soundgen_triangle is
begin
    process (clk)
    variable period: integer;
    variable p_counter: integer;
    variable period_over_4: integer := 0;
    variable pcm: pcm_data_t := to_signed(0, pcm_data_t'length);
    begin
        if rising_edge(clk) then
            if ce = '1' then
                period := period_from_note(note);
                
                if period > 0 then
                    p_counter := to_integer(counter) mod period; 
                    period_over_4 := period / 4;
                    if p_counter >= 0 and p_counter < period_over_4 then
                        pcm := resize(pcm_max * to_signed(p_counter, sample_rate'length) / period_over_4, pcm_data_t'length);
                    elsif p_counter >= period_over_4 and p_counter < 2 * period_over_4 then
                        pcm := resize(pcm_max - (pcm_max * (to_signed(p_counter, sample_rate'length) - period_over_4) / period_over_4), pcm_data_t'length);
                    elsif p_counter >= 2 * period_over_4 and p_counter < 3 * period_over_4 then
                        pcm := resize(-(-pcm_min * (to_signed(p_counter, sample_rate'length) - 2 * period_over_4) / period_over_4), pcm_data_t'length);
                    else
                        pcm := resize(pcm_min + (-pcm_min * (to_signed(p_counter, sample_rate'length) - 3 * period_over_4) / period_over_4), pcm_data_t'length);
                    end if;
                    pcm_out <= pcm;
                end if;
            end if;
        end if;
    end process;
end behav;
