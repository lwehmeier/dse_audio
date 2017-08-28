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

-- The entity for a lfsr based noise sound generator
entity soundgen_noise is
    port (
        clk: in std_logic;
        ce: in std_logic;
        pcm_out: out pcm_data_t;
        volume: in volume_t;
        reset: in std_logic
    );
end soundgen_noise;

-- The architecture for the noise sound generator
architecture behav of soundgen_noise is
    signal rnd32: std_logic_vector (31 downto 0) := (others=>'0');
    signal rnd16: std_logic_vector (15 downto 0) := (others=>'0');
    signal rnd8: std_logic_vector (7 downto 0) := (others=>'0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if ce = '1' then
                -- 8Bit
                rnd8(7 downto 1) <= rnd8(6 downto 0);
                rnd8(0) <= not(rnd8(7) xor rnd8(6) xor rnd8(4));

                -- 16Bit
                rnd16(15 downto 1) <= rnd16(14 downto 0);
                rnd16(0) <= not(rnd16(15) xor rnd16(14) xor rnd16(13) xor rnd16(4));

                -- 32 Bit
                rnd32(31 downto 1) <= rnd32(30 downto 0);
                rnd32(0) <= not(rnd32(31) xor rnd32(22) xor rnd32(2) xor rnd32(1));

                pcm_out <= apply_volume(signed(rnd16), volume);
            end if;
        end if;
    end process;
end behav;
