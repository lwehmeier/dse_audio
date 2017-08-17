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

entity soundgen_square_test is
end soundgen_square_test;

architecture behav of soundgen_square_test is
    signal clk: std_logic;
    signal ce: std_logic;
    signal pcm: pcm_data_t;
    signal volume: volume_t;
    signal counter: unsigned(sample_rate'length - 1 downto 0);
    signal period: unsigned(sample_rate'length - 1 downto 0);
    
    component soundgen_square is
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
    square: soundgen_square port map (
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
        wait for 200ns;
        
        -- generate note A at full volume
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(0, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@0/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(pcm_min, 16)
            report "SoundGen Square: Wrong PCM at index 0 on volume 255"
            severity failure;
        
        -- generate A at half volume
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(128, volume_t'length));
        counter <= to_unsigned(0, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@0/109 vol=128: " & integer'image(to_integer(pcm))
            severity note;
        
        -- will only work for 16 bit PCM, to fix it use pcm_min / 255 * 128 (NO int division here!)
        --  -> as constant floating point operations are not supported you have to calculate it manually
        assert pcm = to_signed(-16384, 16)
            report "SoundGen Square: Wrong PCM at index 0 on volume 128"
            severity failure;
        
        -- generate A at silence
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(0, volume_t'length));
        counter <= to_unsigned(0, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@0/109 vol=0: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(0, 16)
            report "SoundGen Square: Wrong PCM at index 0 on volume 0"
            severity failure;
        
        -- generate A at full volume at half period
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(54, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@54/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(pcm_min, 16)
            report "SoundGen Square: Wrong PCM at index 54 on volume 255"
            severity failure;
        
        -- generate A at full volume at half period + 1
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(55, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@55/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(pcm_max, 16)
            report "SoundGen Square: Wrong PCM at index 55 on volume 255"
            severity failure;

        -- generate A at full volume at full period
        wait until clk = '0';
        period <= to_unsigned(period_from_note(std_logic_vector(to_unsigned(69, 8))), sample_rate'length);
        volume <= std_logic_vector(to_unsigned(256, volume_t'length));
        counter <= to_unsigned(109, sample_rate'length);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@109/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(pcm_max, 16)
            report "SoundGen Square: Wrong PCM at index 109 on volume 255"
            severity failure;

        wait;
    end process;
end architecture;
