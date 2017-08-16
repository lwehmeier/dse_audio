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

entity soundgen_noise is
    port (
        clk: in std_logic;
        ce: in std_logic;
        pcm_out: out pcm_data_t;
        volume: in volume_t;
        reset: in std_logic
    );
end soundgen_noise;

architecture behav of soundgen_noise is
begin
    process (clk)
    constant poly: signed(pcm_data_t'length downto 0) := to_signed(65521, pcm_data_t'length + 1);
    variable lfsr: signed(pcm_data_t'length downto 0) := to_signed(1, pcm_data_t'length + 1);
    variable temp: signed(pcm_data_t'length downto 0);
    variable rslt: signed(pcm_data_t'length - 1 downto 0);
    begin
        if rising_edge(clk) then
            if ce = '1' then
                if lfsr = 0 then
                    lfsr := to_signed(1, pcm_data_t'length + 1);
                end if;
                
                temp := lfsr;
                lfsr := shift_right(lfsr, 1);
                lfsr := lfsr xor (-temp and poly);
                
                rslt := apply_volume(temp(pcm_data_t'length - 1 downto 0), volume);
                pcm_out <= rslt;
            end if;
        end if;
    end process;
end behav;
