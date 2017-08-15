library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.typedefs.all;
use work.components.all;

entity TOP is
    Port ( gclk : in STD_LOGIC;
           dac_out : out STD_LOGIC;
           midi_rx : in STD_LOGIC;
           midi_tx : out STD_LOGIC;
           reset : in STD_LOGIC;
           BTN : in STD_LOGIC_VECTOR (4 downto 0);
           SWITCHES : in STD_LOGIC_VECTOR (7 downto 0));
end TOP;

architecture Behavioral of TOP is





constant wg_types_vect : wg_type_vector_t := (wg_SINE, wg_SQUARE, wg_SAW, wg_TRIANGLE);

signal wg2filter : mix_pcm_vector_t;
signal wgfilter2mix : mix_pcm_vector_t;
signal mix2mixfilter : pcm_data_t;
signal mixfilter2DAC : pcm_data_t;
signal mixCtrl : add_mask_t := "1111";
signal tg_note : note_vector_t;
signal tg_volume : volume_vector_t;
signal CLK : std_logic;
signal ce48k : std_logic;

begin
clk_gen : clk_wiz_0 port map(clk_out1 => CLK, reset => reset, clk_in1 => gclk);
ce_gen : CEGEN48k generic map(BIT_WIDTH => 16) port map(GCLK => CLK, OUTPUT => ce48k, ENABLE => '1', RESET => reset, TOP_VAL => std_logic_vector(to_unsigned(2047,16)));
wg_gen_loop : for i in 0 to mix_channel_count-1 generate
    m_wg_x : waveformGen generic map (
        wg_type => wg_types_vect(i)
    )
    Port map (
        CLK => CLK,
        CE => ce48k,
        PCM_OUT => wg2filter(i),
        NOTE => tg_note(i),
        VOLUME =>tg_volume(i),
        RESET => reset
    );
end generate wg_gen_loop;

filter_gen_loop : for i in 0 to mix_channel_count-1 generate
    m_wgfilter_x : filter generic map (filter_type => filter_PASSTHROUGH) port map( PCM_IN => wg2filter(i), PCM_OUT => wgfilter2mix(i), CLK => CLK, CE => ce48k);
end generate filter_gen_loop;


m_mix : Mixer port map (PCM_IN_VECT => wgfilter2mix,PCM_OUT=>mix2mixfilter,reset=>reset,CLK=>CLK,CE=>ce48k, ADD_MASK=>mixCtrl);
m_mixfilter : filter generic map (filter_type => filter_PASSTHROUGH) port map( PCM_IN => mix2mixfilter, PCM_OUT => mixfilter2dac, CLK => CLK, CE => ce48k);
m_dac : DAC port map ( CLK=>CLK, CE => ce48k, PCM_IN => mixfilter2dac, DAC_OUT => dac_out);
end Behavioral;
