----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.08.2017 13:32:49
-- Design Name: 
-- Module Name: soundgen - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package soundgen is
    function period_from_note(note: note_t) return integer;
    function apply_volume(pcm: pcm_data_t; volume: volume_t) return pcm_data_t;
end package soundgen;

package body soundgen is

    function period_from_note(note: note_t) return integer is
    begin
        case to_integer(unsigned(note)) is
            -- C 3.822ms * 48000 / 1000ms
            when 60 => return 183;
            
            -- C# 3.608ms * 48000 / 1000ms
            when 61 => return 173;
            
            -- D 3.405ms * 48000 / 1000ms
            when 62 => return 163;
            
            -- D# 3.214ms * 48000 / 1000ms
            when 63 => return 154;
            
            -- E 3.034ms * 48000 / 1000ms
            when 64 => return 146;
            
            -- F 2.863ms * 48000 / 1000ms
            when 65 => return 137;
            
            -- F# 2.703ms * 48000 / 1000ms
            when 66 => return 130;
            
            -- G 2.551ms * 48000 / 1000ms
            when 67 => return 122;
            
            -- G# 2.408ms * 48000 / 1000ms
            when 68 => return 116;
            
            -- A 2.273ms * 48000 / 1000ms
            when 69 => return 109;
            
            -- A# 2.145ms * 48000 / 1000ms
            when 70 => return 103;
            
            -- B 2.025ms * 48000 / 1000ms
            when 71 => return 97;
            
            -- A 2.273ms * 48000 / 1000ms
            when others => return 109;
        end case;
    end period_from_note;
    
    function apply_volume(pcm: pcm_data_t; volume: volume_t) return pcm_data_t is
    begin
        -- this is linear for now
        --return resize(pcm * signed('0' & volume) / to_signed(256, pcm_data_t'length + volume_t'length), 16);
        return resize(shift_right(shift_left(resize(pcm, pcm_data_t'length + 9), 8) * signed('0' & volume), 16), pcm_data_t'length);
    end apply_volume;
end package body;
