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
    signal sig_note: note_t;
    signal volume: volume_t;
    signal counter: unsigned(sample_rate'length - 1 downto 0);
    
    component soundgen_triangle is
        port (
            clk: in std_logic;
            ce: in std_logic;
            pcm_out: out pcm_data_t;
            note: in note_t;
            volume: in volume_t;
            counter: in unsigned(sample_rate'length - 1 downto 0);
            reset: in std_logic
        );
    end component;

begin
    triangle: soundgen_triangle port map (
        clk => clk,
        ce => ce,
        pcm_out => pcm,
        note => sig_note,
        volume => volume,
        counter => counter,
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
        sig_note <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(255, 8));
        counter <= to_unsigned(0, 16);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@0/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(0, 16)
            report "SoundGen Triangle: Wrong PCM at period start"
            severity failure;
        
        -- generate note A at 1/8
        wait until clk = '0';
        sig_note <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(255, 8));
        counter <= to_unsigned(13, 16);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@13/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(15776, 16)
            report "SoundGen Triangle: Wrong PCM at 1/8 period"
            severity failure;
        
        -- generate A at 1/4 period
        wait until clk = '0';
        sig_note <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(255, 8));
        counter <= to_unsigned(27, 16);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@27/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(32767, 16)
            report "SoundGen Triangle: Wrong PCM at 1/4 period"
            severity failure;
        
        -- generate note A at 3/8
        wait until clk = '0';
        sig_note <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(255, 8));
        counter <= to_unsigned(40, 16);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@40/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(16991, 16)
            report "SoundGen Triangle: Wrong PCM at 3/8 period"
            severity failure;
        
        -- generate A at 2/4 period
        wait until clk = '0';
        sig_note <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(255, 8));
        counter <= to_unsigned(54, 16);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@54/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(0, 16)
            report "SoundGen Triangle: Wrong PCM at 2/4 period"
            severity failure;

        -- generate note A at 5/8
        wait until clk = '0';
        sig_note <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(255, 8));
        counter <= to_unsigned(67, 16);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@67/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(-15777, 16)
            report "SoundGen Triangle: Wrong PCM at 5/8 period"
            severity failure;
        
        -- generate A at 3/4 period
        wait until clk = '0';
        sig_note <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(255, 8));
        counter <= to_unsigned(81, 16);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@81/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(-32768, 16)
            report "SoundGen Triangle: Wrong PCM at 3/4 period"
            severity failure;

        -- generate note A at 7/8
        wait until clk = '0';
        sig_note <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(255, 8));
        counter <= to_unsigned(94, 16);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';

        report "PCM@94/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(-16991, 16)
            report "SoundGen Triangle: Wrong PCM at 7/8 period"
            severity failure;
        
        -- generate A at 4/4 period
        wait until clk = '0';
        sig_note <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(255, 8));
        counter <= to_unsigned(108, 16);
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM@108/109 vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        assert pcm = to_signed(0, 16)
            report "SoundGen Triangle: Wrong PCM at 4/4 period"
            severity failure;

        wait;
    end process;
end architecture;