----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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

entity soundgen_triangle_test is
end soundgen_triangle_test;

architecture behav of soundgen_triangle_test is
    signal clk: std_logic;
    signal ce: std_logic;
    signal pcm: pcm_data_t;
    signal volume: volume_t;
    signal counter: unsigned(sample_rate'length - 1 downto 0);
    signal period: unsigned(sample_rate'length - 1 downto 0);
    
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
    triangle: soundgen_triangle port map (
        clk => clk,
        ce => ce,
        pcm_out => pcm,
        volume => volume,
        counter => counter,
        period => period,
        reset => '0'
    );
    
    process
    begin
        clk <= '0'; --100mhz
        wait for 5 ns;
        clk <= '1'; --100mhz
        wait for 5 ns;
    end process;

    process
    begin
        -- note: these tests currently only work for 16 bit pcm (pcm_min and pcm_max are not used)!
        wait for 200ns;
        
        -- generate note A at period start
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(0, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@0/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(-32768, 16)
            report "SoundGen Triangle: Wrong PCM at period start"
            severity failure;
        
        -- generate note A at 1/8
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(13, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@13/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(-17136, 16)
            report "SoundGen Triangle: Wrong PCM at 1/8 period"
            severity failure;
        
        -- generate A at 1/4 period
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(27, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@27/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(-302, 16)
            report "SoundGen Triangle: Wrong PCM at 1/4 period"
            severity failure;
        
        -- generate note A at 3/8
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(40, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@40/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(15331, 16)
            report "SoundGen Triangle: Wrong PCM at 3/8 period"
            severity failure;
        
        -- generate A at 2/4 period
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(54, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@54/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(32767, 16)
            report "SoundGen Triangle: Wrong PCM at 2/4 period"
            severity failure;

        -- generate note A at 5/8
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(67, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@67/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(17736, 16)
            report "SoundGen Triangle: Wrong PCM at 5/8 period"
            severity failure;
        
        -- generate A at 3/4 period
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(81, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@81/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(901, 16)
            report "SoundGen Triangle: Wrong PCM at 3/4 period"
            severity failure;

        -- generate note A at 7/8
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(94, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@94/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(-14731, 16)
            report "SoundGen Triangle: Wrong PCM at 7/8 period"
            severity failure;
        
        -- generate A at 4/4 period
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(108, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@108/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(-31566, 16)
            report "SoundGen Triangle: Wrong PCM at 4/4 period"
            severity failure;

        wait;
    end process;
end architecture;
