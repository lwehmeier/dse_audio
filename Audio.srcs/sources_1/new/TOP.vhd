----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.08.2017 17:43:28
-- Design Name: 
-- Module Name: TOP - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port ( gclk : in STD_LOGIC;
           dac_out : out STD_LOGIC;
           midi_rx : in STD_LOGIC;
           reset : in STD_LOGIC;
           BTN : in STD_LOGIC_VECTOR (4 downto 0);
           PCM_OUT : out std_logic_vector(15 downto 0);
           UART_RX_OUT : out std_logic_vector(7 downto 0);
           AUDIO_GAIN : out STD_LOGIC;
           AUDIO_SHDN : out STD_LOGIC; -- bootup
           SWITCHES : in STD_LOGIC_VECTOR (7 downto 0));
end TOP;

architecture Behavioral of TOP is
constant wg_types_vect : wg_type_vector_t := (wg_SQUARE, wg_TRIANGLE, wg_SAW, wg_SINE);--wg_SQUARE, wg_SAW, wg_TRIANGLE);

signal wg2filter : mix_pcm_vector_t;
signal wgfilter2mix : mix_pcm_vector_t;
signal mix2mixfilter : pcm_data_t;
signal mixfilter2DAC : pcm_data_t;
signal mixCtrl : add_mask_t := "1111";
signal tg_note : note_vector_t;
signal tg_volume : volume_vector_t;
signal tg2_note : note_vector_t;
signal tg2_volume : volume_vector_t;
signal note_ready : std_logic_vector(mix_channel_count - 1 downto 0);
signal CLK : std_logic;
signal ce48k : std_logic;
signal uartDR : std_logic;
signal uartData : std_logic_vector(7 downto 0);

begin
AUDIO_GAIN <= '1';
AUDIO_SHDN <= '1'; -- bootup
PCM_OUT<=std_logic_vector(mixfilter2dac);

--tg_volume(0)<="10111111";
--tg_note(0)<=std_logic_vector(to_unsigned(62,8));
--tg_volume(1)<="11111111";
--tg_note(1)<=std_logic_vector(to_unsigned(68,8));
--tg_volume(1)<="10111111";
--tg_note(1)<=std_logic_vector(to_unsigned(61,8));
--tg_volume(1)<="11111111";
--tg_note(1)<=std_logic_vector(to_unsigned(70,8));


clk_gen: clk_wiz_0 port map(clk_out1 => CLK, clk_in1 => gclk);
rxUart: UART_RX_CTRL port map (CLK     => CLK, UART_RX => midi_rx, DATA => uartData, READ_DATA => uartDR); --might need to fix baudrate and start bit?
midi: midi_parser port map (CLK     => CLK, rxData => uartData,  newData => uartDR,volume => tg_volume, note => tg_note, note_ready => note_ready);
ce_gen: CEGEN48k generic map(BIT_WIDTH => 16) port map(GCLK => CLK, OUTPUT => ce48k, ENABLE => '1', RESET => reset, TOP_VAL => std_logic_vector(to_unsigned(2047,16)));
wg_gen_loop : for i in 0 to mix_channel_count-1 generate
    m_env : Envelope port map (
        -- Clock sources 
        CLK     => CLK,
        SR      => ce48k,
        NOTE    => note_ready(i),
        RESET   => reset,
        
        -- Tone related
        -- the resolution for times is 2.66ms per step
        -- TODO: Maybe add a lookup table to have exponential time steps
        NOTE_IN          => tg_note(i),                         -- Note Input
        SUSTAIN_VOLUME   => tg_volume(i),                       -- Sustain volume
        ATTACK_TIME      => x"00",   -- Attack time
        ATTACK_VOLUME    => x"ff",                       -- Peak volume
        DECAY_TIME       => x"00",   -- Decay time
        RELEASE_TIME     => x"00",   -- Release time
        ATTACK_INCREASE  => to_volume_t(1),                       -- Volume per attack step to add
        DECAY_DECREASE   => to_volume_t(1),                       -- Volume per decay step to subtract
        RELEASE_DECREASE => to_volume_t(1),                       -- Volume per release step to subtract
        
        -- Output volume
        VOL_OUT  => tg2_volume(i),   -- Volume Output
        NOTE_OUT => tg2_note(i)     -- Note Output, used to "hold" the note for the release time.  
    );
    
    m_wg_x : waveformGen generic map (
        wg_type => wg_types_vect(i)
    )
    Port map (
        CLK => CLK,
        CE => ce48k,
        PCM_OUT => wg2filter(i),
        NOTE => tg2_note(i),
        VOLUME =>tg2_volume(i),
        RESET => reset
    );
end generate wg_gen_loop;

filter_gen_loop : for i in 0 to mix_channel_count-1 generate
    m_wgfilter_x : filter generic map (filter_type => filter_PASSTHROUGH) port map( PCM_IN => wg2filter(i), PCM_OUT => wgfilter2mix(i), CLK => CLK, CE => ce48k);
end generate filter_gen_loop;
m_mix: Mixer port map (PCM_IN_VECT => wgfilter2mix,PCM_OUT=>mix2mixfilter,reset=>reset,CLK=>CLK,CE=>ce48k, ADD_MASK=>mixCtrl);
m_mixfilter: filter generic map (filter_type => filter_PASSTHROUGH) port map( PCM_IN => mix2mixfilter, PCM_OUT => mixfilter2dac, CLK => CLK, CE => ce48k);
m_dac: entity work.DAC(PWMDAC) port map ( CLK=>CLK, CE => ce48k, PCM_IN => mixfilter2dac, DAC_OUT => dac_out);

debug : process(CLK)
begin
    if rising_edge(CLK) and uartDR='1' then
        UART_RX_OUT<=uartData;
    end if;
end process;


end Behavioral;
