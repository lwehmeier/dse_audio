library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.typedefs.all;
use work.components.all;
use work.sine_package.all;

entity dacMixTest is
    Port ( gclk : in STD_LOGIC;
           dac_out : out STD_LOGIC;
           --midi_rx : in STD_LOGIC;
           reset : in STD_LOGIC;
           BTN : in STD_LOGIC_VECTOR (3 downto 0);
           AUDIO_SHDN : out std_logic;
           AUDIO_GAIN : out std_logic;
           SWITCHES : in STD_LOGIC_VECTOR (7 downto 0));
end dacMixTest;

architecture Behavioral of dacMixTest is

	component sinerom is
		Port (
			addr: in std_logic_vector(7 downto 0);
			sin:   out signed(15 downto 0)
		);
	end component;



constant wg_types_vect : wg_type_vector_t := (wg_SINE, wg_SQUARE, wg_SAW, wg_TRIANGLE);

signal wgfilter2mix : mix_pcm_vector_t;
signal mixfilter2DAC : pcm_data_t;
signal mixCtrl : add_mask_t := "1111";
signal CLK : std_logic;
signal ce48k : std_logic;
signal addrCntr : unsigned(7 downto 0) := to_unsigned(0,8);
--signal addrCntr2 : unsigned(7 downto 0) := to_unsigned(0,8);
--signal addrCntr3 : unsigned(7 downto 0) := to_unsigned(0,8);

begin
AUDIO_GAIN <= '1';
AUDIO_SHDN <= '1'; -- bootup
process(clk)
begin
    if rising_edge(clk) and ce48k='1'
    then
            addrCntr<=addrCntr+1;
--                addrCntr2<=addrCntr2+1;
--                        addrCntr3<=addrCntr3+3;
    end if;
end process;

clk_gen : clk_wiz_0 port map(clk_out1 => CLK, reset => reset, clk_in1 => gclk);
ce_gen : CEGEN48k generic map(BIT_WIDTH => 16) port map(GCLK => CLK, OUTPUT => ce48k, ENABLE => '1', RESET => reset, TOP_VAL => std_logic_vector(to_unsigned(2047,16)));

wgfilter2mix(0)<=to_pcm_data_t(get_table_value(to_integer(addrCntr)));
--wgfilter2mix(1)<=to_pcm_data_t(get_table_value(to_integer(addrCntr2)));
--wgfilter2mix(1)<=to_pcm_data_t(get_table_value(to_integer(addrCntr3)));
m_mix : Mixer port map (PCM_IN_VECT => wgfilter2mix,PCM_OUT=>mixfilter2DAC,reset=>reset,CLK=>CLK,CE=>ce48k, ADD_MASK=>mixCtrl);
m_dac : DAC port map ( CLK=>CLK, CE => ce48k, PCM_IN => mixfilter2dac, DAC_OUT => dac_out);
end Behavioral;
