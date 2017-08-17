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

entity soundgen_saw is
    port (
        clk: in std_logic;
        ce: in std_logic;
        pcm_out: out pcm_data_t;
        volume: in volume_t;
        counter: in unsigned(sample_rate'length - 1 downto 0);
        period: in unsigned(sample_rate'length - 1 downto 0);
        reset: in std_logic
    );
end soundgen_saw;

architecture behav of soundgen_saw is
begin
    process (clk)
    variable pcm: pcm_data_t;
    begin
        if rising_edge(clk) then
            if ce = '1' and period > 0 then
                pcm := soundgen_saw_lut.counter_over_period(counter, period); 
                pcm_out <= apply_volume(pcm, volume);
            end if;
        end if;
    end process;
end behav;
