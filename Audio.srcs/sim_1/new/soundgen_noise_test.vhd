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

entity soundgen_noise_test is
end soundgen_noise_test;

architecture behav of soundgen_noise_test is
    signal clk: std_logic;
    signal ce: std_logic;
    signal pcm: pcm_data_t;
    signal volume: volume_t;
    
    component soundgen_noise is
        port (
            clk: in std_logic;
            ce: in std_logic;
            pcm_out: out pcm_data_t;
            volume: in volume_t;
            reset: in std_logic
        );
    end component;

begin
    noise: soundgen_noise port map (
        clk => clk,
        ce => ce,
        pcm_out => pcm,
        volume => volume,
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
        
        -- generate noise
        wait until clk = '0';
        volume <= std_logic_vector(to_unsigned(255, 8));
        ce <= '1';

        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
            
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
            
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
            
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
            
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
            
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
            
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
            
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
        
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
            
        wait until clk = '1';
        wait until clk = '0';
            
        report "PCM noise vol=255: " & integer'image(to_integer(pcm))
            severity note;
        
        wait;
    end process;
end architecture;