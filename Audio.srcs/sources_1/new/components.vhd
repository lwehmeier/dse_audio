----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.08.2017 17:45:59
-- Design Name: 
-- Module Name: components - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package components is

component UART_RX_CTRL is
    Port ( UART_RX : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           DATA : out  STD_LOGIC_VECTOR (7 downto 0);
           READ_DATA_PULSE : out  STD_LOGIC := '0';
           READ_DATA : out  STD_LOGIC := '0'
			  );
end component;
component midi_parser is
    Port ( rxData : in STD_LOGIC_VECTOR (7 downto 0);
           newData : in STD_LOGIC;
           note : out note_vector_t;
           volume : out env_volume_vector_t;
           note_ready : out STD_LOGIC_VECTOR (mix_channel_count - 1 downto 0);
           clk : in STD_LOGIC);  
end component;
component DAC is
    Port ( CLK : in STD_LOGIC;
           CE : in STD_LOGIC;
           PCM_IN : in pcm_data_t;
           DAC_OUT : out dac_out_t);
end component;
component DAC_DDC is
    Port ( INPUT : in STD_LOGIC;
           PCM_OUT : out pcm_data_t);
end component;

component Mixer is
    Port ( PCM_IN_VECT : in mix_pcm_vector_t;
           PCM_OUT : out pcm_data_t;
           reset : in STD_LOGIC;
           CLK : in STD_LOGIC;
           CE : in STD_LOGIC;
           ADD_MASK : in add_mask_t);
end component;
component clk_wiz_0 
port (
  clk_out1 : out std_logic;
  clk_in1 : in std_logic
 );
 end component;
component Filter is
generic (
    filter_type : filter_type_t := filter_PASSTHROUGH
);
    Port ( PCM_IN : in pcm_data_t;
           PCM_OUT : out pcm_data_t;
           CLK : in STD_LOGIC;
           CE : in STD_LOGIC);
end component;
component waveformGen is
Generic (
    wg_type : wg_type_t := wg_SINE
);
    Port ( CLK : in STD_LOGIC;
           CE : in STD_LOGIC;
           PCM_OUT : out pcm_data_t;
           NOTE : in note_t;
           VOLUME : in volume_t;
           RESET : in STD_LOGIC);
end component;

component CEGEN48k is    
    Generic (
        BIT_WIDTH : integer := 16
    );
    Port ( GCLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC;
           ENABLE : in STD_LOGIC;
           TOP_VAL : in STD_LOGIC_VECTOR(BIT_WIDTH-1 downto 0);
           RESET : in STD_LOGIC);
end component;

component Envelope is
    Port (
        -- Clock sources 
        CLK     : in STD_LOGIC;  -- System Clock
        SR      : in STD_LOGIC;  -- Sample Rate
        NOTE    : in STD_LOGIC;  -- New note can be sampled
        RESET   : in STD_LOGIC;  -- Reset the state machine, synchronous to system clock
        
        -- Tone related
        -- the resolution for times is 2.66ms per step
        -- TODO: Maybe add a lookup table to have exponential time steps
        NOTE_IN        : in note_t;                         -- Note Input
        SUSTAIN_VOLUME : in env_volume_t;                       -- Sustain volume
        ATTACK_TIME    : in std_logic_vector(7 downto 0);   -- Attack time
        ATTACK_VOLUME  : in env_volume_t;                       -- Peak volume
        DECAY_TIME     : in std_logic_vector(7 downto 0);   -- Decay time
        RELEASE_TIME   : in std_logic_vector(7 downto 0);   -- Release time
        ATTACK_INCREASE  : in env_volume_t;                       -- Volume per attack step to add
        DECAY_DECREASE   : in env_volume_t;                       -- Volume per decay step to subtract
        RELEASE_DECREASE : in env_volume_t;                       -- Volume per release step to subtract
        
        -- Output volume
        VOL_OUT  : out volume_t;   -- Volume Output
        NOTE_OUT : out note_t     -- Note Output, used to "hold" the note for the release time.  
    );
end component;
end package;
