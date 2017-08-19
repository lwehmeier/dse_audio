library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.typedefs.all;
use work.components.all;

-- top level file for synthesizer
-- allows for a configurable number (in typedefs.vhd) of generators specified as constant wg_types_vect array of waveform generators.
-- Configuration and data input: midi over 9600 baud UART connected to midi_rx pin (Currently PMOD A7)
-- 
-- UART data is received by the UART_RX_CTRL instance, which waits for the start bit and then samples 8 bit from the midi_rx pin
-- UART setting: 9600 baud, 8N1 to 8N2
-- The received data is stored in the uartData register and a one sysclock long uartDR pulse is generated
-- The uartDR signal is connected to a midi_parser instance which implements a statemachine able to parse simple midi command:
-- note on (volume, tone) or in midi speak: velocity and pitch
-- note off
-- controller change commands for configuring the envelope generator
-- All MIDI commands MUST be exactly 3 byte long
-- The parsed midi commands are fed to a number of envelope generators with midi-configurable attack, decay, sustain and release times and levels
-- The envelope generators then modify the velocity according to the configured levels and times which is then fed to the waveform generators.
-- Envelope generator input ports:
-- volume: midi velocity from note on cmd
-- note: midi pitch from note on cmd
-- CLK: design clock
-- SR: sample rate, connected to 48kHz pulse
-- PARAMS: struct containing ATTACK_TIME, ATTACK_VOLUME, DECAY_TIME, RELEASE_TIME, ATTACK_INCREASE, RELEASE_DECREASE. Default configuration: No attack, no decay and immediate release. Sustain level==midi velocity
-- Outputs:
-- VOL_OUT: volume to be applied by waveform generator
-- NOTE_OUT
-- Function:
  -- Morphs the volume to create a ramp.
  -- Stage 1: Attack  - output volume ranges from zero to ATTACK_VOLUME in ATTACK_TIME*TIMESTEP
  -- Stage 2: Decay   - output volume will range from ATTACK_VOLUME to SUSTAIN_VOLUME in DECAY_TIME*TIMESTEP
  -- Stage 3: Sustain - output volume will stay constant while NOTE_IN remains constant.
  -- Stage 4: Release - output volume will decay to zero in RELEASE_TIME*TIMESTEP
-- Each envelope generator is followed by a waveform generator  of a type specified in wg_types_vect
-- Available generator types are
-- wg_SQUARE
-- wg_TRIANGLE
-- wg_SAW
-- wg_SINE
-- wg_NOISE
-- All generators have a common interface:
-- CLK: design clock
-- CE: music sample frequency, here: 48kHz
-- reset: synchronous reset
-- NOTE: tone to be generated
-- VOLUME: scale 0 to 255
-- PCM_OUT: outputs generated pcm-encoded waveform of type pcm_data_t
-- wg_type: generic specifying generator type, e.g. wg_SINE
-- each waveform generator's pcm output is connected to a filter which is currently implemented as simple passthrough
-- the filtered pcm-data is then summed up by an instance of the mixer component:
-- Inputs: PCM_VECT_T: array of pcm_data_t, width configured by waveform generator count in typedefs.vhd
-- Output: PCM_OUT
-- The mixer is again followed by a filter stage
-- The filtered and mixed signal is then passed to the DAC for output
-- The DAC is configurable as PWMDAC or 1-stage delta sigma DAC (DSDAC)
-- Inputs: CLK, CE, pcm_data
-- Output: 1-Bit DAC signal, connected to output port dac_out of top level design

entity TOP is
    Port ( gclk : in STD_LOGIC; -- clock input
           dac_out : out STD_LOGIC; -- dac output pin
           midi_rx : in STD_LOGIC; -- midi uart input pin (9600 baud)
           reset : in STD_LOGIC;
           BTN : in STD_LOGIC_VECTOR (4 downto 0); -- zedboard button inputs for debug
           PCM_OUT : out std_logic_vector(15 downto 0); -- pcm output mapped to PMOD C and D for debug purposes
           UART_RX_OUT : out std_logic_vector(7 downto 0); -- received uart byte output, debug. PMOD B
           AUDIO_GAIN : out STD_LOGIC; -- amplifier gain configuration pin
           AUDIO_SHDN : out STD_LOGIC; -- enable amplifier connected to PMOD A (upper half)
           SWITCHES : in STD_LOGIC_VECTOR (7 downto 0)); -- zedboard switch input, debug purposes
          -- ports marked as debug can easily be removed->remove usage from TOP.vhd, debug ports are only used there
end TOP;

architecture Behavioral of TOP is
constant wg_types_vect : wg_type_vector_t := (wg_SQUARE, wg_TRIANGLE, wg_SAW, wg_SINE, wg_NOISE);--wg_SQUARE, wg_SAW, wg_TRIANGLE);

signal wg2filter : mix_pcm_vector_t;
signal wgfilter2mix : mix_pcm_vector_t;
signal mix2mixfilter : pcm_data_t;
signal mixfilter2DAC : pcm_data_t;
signal tg_note : note_vector_t;
signal tg_volume : env_volume_vector_t;
signal tg2_note : note_vector_t;
signal tg2_volume : volume_vector_t;
signal note_ready : std_logic_vector(mix_channel_count - 1 downto 0);
signal env_params : envelope_params_vector_t := (others => default_envelope_params);
signal CLK : std_logic;
signal ce48k : std_logic;
signal uartDR : std_logic;
signal uartData : std_logic_vector(7 downto 0);

begin
AUDIO_GAIN <= '1';
AUDIO_SHDN <= '1'; -- bootup
PCM_OUT<=std_logic_vector(mixfilter2dac);


clk_gen: clk_wiz_0 port map(clk_out1 => CLK, clk_in1 => gclk);
rxUart: UART_RX_CTRL port map (CLK     => CLK, UART_RX => midi_rx, DATA => uartData, READ_DATA => uartDR); --might need to fix baudrate and start bit?
midi: midi_parser port map (CLK     => CLK, rxData => uartData,  newData => uartDR,volume => tg_volume, note => tg_note, note_ready => note_ready, envelope_params => env_params);
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
        PARAMS           => env_params(i),                      -- parameter passthrough
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
m_mix: Mixer port map (PCM_IN_VECT => wgfilter2mix,PCM_OUT=>mix2mixfilter,reset=>reset,CLK=>CLK,CE=>ce48k);
m_mixfilter: filter generic map (filter_type => filter_PASSTHROUGH) port map( PCM_IN => mix2mixfilter, PCM_OUT => mixfilter2dac, CLK => CLK, CE => ce48k);
m_dac: entity work.DAC(PWMDAC) port map ( CLK=>CLK, CE => ce48k, PCM_IN => mixfilter2dac, DAC_OUT => dac_out);

debug : process(CLK)
begin
    if rising_edge(CLK) and uartDR='1' then
        UART_RX_OUT<=uartData;
    end if;
end process;


end Behavioral;
