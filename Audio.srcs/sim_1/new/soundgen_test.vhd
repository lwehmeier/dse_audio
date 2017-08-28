----------------------------------------------------------------------------------
-- Company:
-- Engineer: Fin Christensen
--
-- Create Date: 16.08.2017 13:54:42
-- Design Name:
-- Module Name: soundgen_test - Behavioral
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
use work.components.all;
use work.soundgen.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- The simulation entity for all waveform generators.
entity soundgen_test is
end soundgen_test;

-- This architecture contains a test for all waveform generators listed in the
-- generators constant. It can be used to easily visualize the generated
-- waveforms in a waveform view.
architecture behav of soundgen_test is
    -- The generators array type used for the generators constant.
    type generators_t is array(4 downto 0) of wg_type_t;
    -- The generators that get instantiated by the soundgen_loop.
    constant generators: generators_t := (wg_SQUARE, wg_TRIANGLE, wg_SAW, wg_NOISE, wg_SINE);
    -- The array type for the produced pcm signals by the generators.
    type pcm_vector_t is array(generators'length - 1 downto 0) of pcm_data_t;

    -- The clock signal for this simulation running at 100Mhz.
    signal clk: std_logic;

    -- The clock enable signal for this simulation. This signal comes with
    -- every clock cycle.
    signal ce: std_logic;

    -- The output pcm signals for the generators.
    signal pcm: pcm_vector_t;

    -- The input signal for the note that the generators should generate.
    signal note_sig: note_t;

    -- The input signal for the volume the generated signals should have.
    signal volume: volume_t;

begin
    -- instantiate all generators listes in the generators constant
    soundgen_loop : for i in 0 to generators'length - 1 generate
        soundgen_x : waveformGen generic map (
            wg_type => generators(i)
        )
        port map (
            clk => clk,
            ce => ce,
            pcm_out => pcm(i),
            note => note_sig,
            volume => volume,
            reset => '0'
        );
    end generate soundgen_loop;

    -- generate a 100Mhz clock signal with a clock enable signal
    process
    begin
        clk <= '0'; --100mhz
        ce <= '0';
        wait for 5 ns;
        clk <= '1'; --100mhz
        ce <= '1';
        wait for 5 ns;
    end process;
    process
        variable vol: integer := 256;
    begin
        wait for 200ns;

        -- setup a test scenario with different volumes and a fixed note
        wait until clk = '0';
        note_sig <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(vol, 9));

        for i in 0 to 1000 loop
            vol := vol - 1;
            if vol <= 0 then
                vol := 256;
            end if;

            report "vol: " & integer'image(vol)
                severity note;

            volume <= std_logic_vector(to_unsigned(vol, 9));
            wait until clk = '1';
            wait until clk = '0';
        end loop;

        vol := 256;
        volume <= std_logic_vector(to_unsigned(vol, 9));

        wait;
    end process;
end behav;
