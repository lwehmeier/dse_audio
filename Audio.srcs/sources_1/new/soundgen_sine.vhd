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
use work.sine_package.all;
use work.soundgen_sine_lut;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- The entity for the sine sound generator
entity soundgen_sine is
    port (
        clk: in std_logic;
        ce: in std_logic;
        pcm_out: out pcm_data_t;
        volume: in volume_t;
        counter: in unsigned(sample_rate'length - 1 downto 0);
        period: in unsigned(sample_rate'length - 1 downto 0);
        reset: in std_logic
    );
end soundgen_sine;

-- The architecture for the sine sound generator
architecture behav of soundgen_sine is
signal reg: pcm_data_t;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                reg <= to_signed(0, pcm_data_t'length);
            elsif ce = '1' and period > 0 then
                -- lookup the sine in the sine_package with the calculated index for the current period from the sine_lut
                reg <= sin(to_integer(soundgen_sine_lut.counter_over_period(counter, period)));
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                pcm_out <= to_signed(0, pcm_data_t'length);
            else
                pcm_out <= apply_volume(reg, volume);
            end if;
        end if;
    end process;
end behav;
