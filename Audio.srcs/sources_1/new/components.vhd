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
component DAC is
    Port ( CLK : in STD_LOGIC;
           CE : in STD_LOGIC;
           PCM_IN : in pcm_data_t;
           DAC_OUT : out dac_out_t);
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
  reset   : in std_logic;
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
    Port ( gclk : in STD_LOGIC;
           output : out STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;
end package;
