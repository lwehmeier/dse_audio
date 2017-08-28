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

-- The simulation entity for the triangle waveform generator.
entity soundgen_triangle_test is
end soundgen_triangle_test;

-- This architecture contains the test for triangle waveform generator. This
-- test validates if the triangle generator produces a correct triangle signal.
architecture behav of soundgen_triangle_test is
    -- The clock signal for this simulation running at 100Mhz.
    signal clk: std_logic;

    -- The clock enable signal for this simulation.
    signal ce: std_logic;

    -- The output pcm signal for the triangle waveform.
    signal pcm: pcm_data_t;

    -- The input signal for the volume of the triangle signal.
    signal volume: volume_t;

    -- This counter describes the current sampling position of the current
    -- note. This counter ranges from 0 to period - 1.
    signal counter: unsigned(sample_rate'length - 1 downto 0);

    -- The period length of the current note in clock enable cycles.
    signal period: unsigned(sample_rate'length - 1 downto 0);

    -- The reset signal for the waveform generator.
    signal reset: std_logic;

    -- The component of the triangle generator.
    component soundgen_triangle is
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
    -- instantiate a triangle generator.
    triangle: soundgen_triangle port map (
        clk => clk,
        ce => ce,
        pcm_out => pcm,
        volume => volume,
        counter => counter,
        period => period,
        reset => reset
    );

    -- generate a 100Mhz clock with a clock enable signal every 4 clock cycles.
    process
    begin
        clk <= '0'; --100mhz
        wait for 5 ns;
        clk <= '1'; --100mhz
        ce <= '0';
        wait for 5 ns;

        clk <= '0'; --100mhz
        wait for 5 ns;
        clk <= '1'; --100mhz
        wait for 5 ns;

        clk <= '0'; --100mhz
        wait for 5 ns;
        clk <= '1'; --100mhz
        wait for 5 ns;

        clk <= '0'; --100mhz
        wait for 5 ns;
        clk <= '1'; --100mhz
        wait for 5 ns;

        clk <= '0'; --100mhz
        wait for 5 ns;
        clk <= '1'; --100mhz
        ce <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        -- note: these tests currently only work for 16 bit pcm (pcm_min and pcm_max are not used)!
        wait for 200ns;

        reset <= '1';
        -- wait for reset
        wait until ce = '0';
        wait until ce = '1';
        wait until ce = '0';
        wait until ce = '1';

        -- generate note A at period start
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(0, sample_rate'length);

        wait until ce = '0';
        wait until ce = '1';
        reset <= '0';
        wait until ce = '0';
        wait until ce = '1';

        report "PCM@0/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(-32768, 16)
            report "SoundGen Triangle: Wrong PCM at period start"
            severity failure;

        wait until ce = '0';

        -- generate note A at 1/8
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(13, sample_rate'length);

        wait until ce = '1';
        wait until ce = '0';
        wait until ce = '1';

        report "PCM@13/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(-17136, 16)
            report "SoundGen Triangle: Wrong PCM at 1/8 period"
            severity failure;

        wait until ce = '0';

        -- generate A at 1/4 period
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(27, sample_rate'length);

        wait until ce = '1';
        wait until ce = '0';
        wait until ce = '1';

        report "PCM@27/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(-302, 16)
            report "SoundGen Triangle: Wrong PCM at 1/4 period"
            severity failure;

        wait until ce = '0';

        -- generate note A at 3/8
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(40, sample_rate'length);

        wait until ce = '1';
        wait until ce = '0';
        wait until ce = '1';

        report "PCM@40/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(15331, 16)
            report "SoundGen Triangle: Wrong PCM at 3/8 period"
            severity failure;

        wait until ce = '0';

        -- generate A at 2/4 period
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(54, sample_rate'length);

        wait until ce = '1';
        wait until ce = '0';
        wait until ce = '1';

        report "PCM@54/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(32767, 16)
            report "SoundGen Triangle: Wrong PCM at 2/4 period"
            severity failure;

        wait until ce = '0';

        -- generate note A at 5/8
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(67, sample_rate'length);

        wait until ce = '1';
        wait until ce = '0';
        wait until ce = '1';

        report "PCM@67/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(17736, 16)
            report "SoundGen Triangle: Wrong PCM at 5/8 period"
            severity failure;

        wait until ce = '0';

        -- generate A at 3/4 period
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(81, sample_rate'length);

        wait until ce = '1';
        wait until ce = '0';
        wait until ce = '1';

        report "PCM@81/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(901, 16)
            report "SoundGen Triangle: Wrong PCM at 3/4 period"
            severity failure;

        wait until ce = '0';

        -- generate note A at 7/8
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(94, sample_rate'length);

        wait until ce = '1';
        wait until ce = '0';
        wait until ce = '1';

        report "PCM@94/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(-14731, 16)
            report "SoundGen Triangle: Wrong PCM at 7/8 period"
            severity failure;

        wait until ce = '0';

        -- generate A at 4/4 period
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(108, sample_rate'length);

        wait until ce = '1';
        wait until ce = '0';
        wait until ce = '1';

        report "PCM@108/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;

        assert pcm = to_signed(-31566, 16)
            report "SoundGen Triangle: Wrong PCM at 4/4 period"
            severity failure;

        wait;
    end process;
end architecture;
