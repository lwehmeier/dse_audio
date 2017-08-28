----------------------------------------------------------------------------------
-- Company:
-- Engineer: Fin Christensen
--
-- Create Date: 15.08.2017 11:49:14
-- Design Name:
-- Module Name: test_mixer - Behavioral
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
use work.components.all;
use work.typedefs.all;
use work.soundgen.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- The simulation entity for the saw waveform generator
entity soundgen_saw_test is
end soundgen_saw_test;

-- This architecture contains the test for the saw waveform generator. This
-- test validates if the saw generator produces a correct saw signal.
architecture behav of soundgen_saw_test is
    -- The clock signal for this simulation running at 100Mhz
    signal clk: std_logic;

    -- The clock enable signal for this simulation.
    -- This signal gets set manually by the simulation.
    signal ce: std_logic;

    -- The output pcm signal for the saw waveform.
    signal pcm: pcm_data_t;

    -- The volume of the saw signal.
    signal volume: volume_t;

    -- This counter describes the current sampling position of the current note.
    -- This counter ranges from 0 to period - 1.
    signal counter: unsigned(sample_rate'length - 1 downto 0);

    -- The period length of the current note in clock enable cycles.
    signal period: unsigned(sample_rate'length - 1 downto 0);

    -- The saw waveform generator component.
    component soundgen_saw is
        port (
            clk: in std_logic;
            ce: in std_logic;
            pcm_out: out pcm_data_t;
            volume: in volume_t;
            counter: in unsigned(sample_rate'length - 1 downto 0);
            period: in unsigned(sample_rate'length - 1 downto 0);
            reset: in std_logic
        );
    end component;

begin
    -- instantiation of the saw waveform generator
    saw: soundgen_saw port map (
        clk => clk,
        ce => ce,
        pcm_out => pcm,
        volume => volume,
        counter => counter,
        period => period,
        reset => '0'
    );

    -- generate a 100Mhz clock signal
    process
    begin
        clk <= '0'; --100mhz
        wait for 5 ns;
        clk <= '1'; --100mhz
        wait for 5 ns;
    end process;

    process
    begin
        wait for 200ns;

        -- generate A at period start
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(0, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@0/109 vol=256: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(pcm_min, 16)
            report "SoundGen Square: Wrong PCM at index 0 on volume 255"
            severity failure;

        -- generate A at half period
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(55, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@55/109 vol=256: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(300, 16)
            report "SoundGen Square: Wrong PCM at index 55 on volume 255"
            severity failure;

        -- generate A at full period
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(109, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@109/109 vol=256: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(pcm_max, 16)
            report "SoundGen Square: Wrong PCM at index 109 on volume 255"
            severity failure;

        wait;
    end process;
end architecture;
