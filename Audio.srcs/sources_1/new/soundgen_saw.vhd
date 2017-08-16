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

entity soundgen_saw is
    port (
        clk: in std_logic;
        ce: in std_logic;
        pcm_out: out pcm_data_t;
        note: in note_t;
        volume: in volume_t;
        counter: in unsigned(sample_rate'length - 1 downto 0);
        reset: in std_logic
    );
end soundgen_saw;

architecture behav of soundgen_saw is
begin
    process (clk)
    variable period: integer;
    variable p_counter: integer;
    begin
        if rising_edge(clk) then
            if ce = '1' then
                period := period_from_note(note);
                
                if period > 0 then
                    p_counter := to_integer(counter) mod period; 
                    pcm_out <= resize(pcm_min + (pcm_max - pcm_min) * to_signed(p_counter, sample_rate'length + 1) / period, pcm_data_t'length);
                end if;
            end if;
        end if;
    end process;
end behav;
