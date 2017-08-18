----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.08.2017 17:02:01
-- Design Name: 
-- Module Name: waveformGen - Behavioral
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

-- This entity is a meta entity used for easier instantiation of the sound generator (generic based)
entity waveformGen is
    generic (
        wg_type: wg_type_t := wg_SINE
    );
    port (
        clk: in std_logic;
        ce: in std_logic;
        pcm_out: out pcm_data_t;
        note: in note_t;
        volume: in volume_t;
        reset: in std_logic
    );
end waveformGen;

architecture behav of waveformGen is
    -- This signal is used in the sound generator to get the current position in the period of the current note
    signal counter: unsigned(sample_rate'length - 1 downto 0) := to_unsigned(0, sample_rate'length);
    -- The sample count of one period of the current note
    signal period: unsigned(sample_rate'length - 1 downto 0) := to_unsigned(0, sample_rate'length);
    
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
    
    component soundgen_sine is
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
    square_gen: if wg_type = wg_SQUARE generate
        square: soundgen_square port map (
            clk => clk,
            ce => ce,
            pcm_out => pcm_out,
            volume => volume,
            counter => counter,
            period => period,
            reset => reset
        );
    end generate square_gen;
    
    triangle_gen: if wg_type = wg_TRIANGLE generate
        triangle: soundgen_triangle port map (
            clk => clk,
            ce => ce,
            pcm_out => pcm_out,
            volume => volume,
            counter => counter,
            period => period,
            reset => reset
        );
    end generate triangle_gen;
    
    saw_gen: if wg_type = wg_SAW generate
        saw: soundgen_saw port map (
            clk => clk,
            ce => ce,
            pcm_out => pcm_out,
            volume => volume,
            counter => counter,
            period => period,
            reset => reset
        );
    end generate saw_gen;

    noise_gen: if wg_type = wg_NOISE generate
        noise: soundgen_noise port map (
            clk => clk,
            ce => ce,
            pcm_out => pcm_out,
            volume => volume,
            reset => reset
        );
    end generate noise_gen;
    
    sine_gen: if wg_type = wg_SINE generate
        sine: soundgen_sine port map (
            clk => clk,
            ce => ce,
            pcm_out => pcm_out,
            volume => volume,
            counter => counter,
            period => period,
            reset => reset
        );
    end generate sine_gen;

    process (clk)
    variable my_period: unsigned(sample_rate'length - 1 downto 0);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter <= to_unsigned(0, sample_rate'length);
                period <= to_unsigned(0, sample_rate'length);
            elsif ce = '1' then
                my_period := to_unsigned(period_from_note(note), sample_rate'length);
                period <= my_period;
        
                if counter < my_period then
                    counter <= counter + 1;
                else
                    counter <= to_unsigned(0, sample_rate'length);
                end if;
            end if;
        end if;
    end process;
end behav;
