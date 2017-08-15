----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.08.2017 17:10:32
-- Design Name: 
-- Module Name: typedefs - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
package typedefs is
constant mix_channel_count : integer := 4;
    type wg_type_t is (
        wg_SINE, wg_SQUARE, wg_SAW, wg_TRIANGLE
    );
    type wg_type_vector_t is array(mix_channel_count-1 downto 0) of wg_type_t;
    
    type filter_type_t is (
        filter_BIQUAD, filter_PASSTHROUGH
    );
    
    subtype pcm_data_t is std_logic_vector(15 downto 0);
    type mix_pcm_vector_t is array(mix_channel_count-1 downto 0) of pcm_data_t;
    
    subtype note_t is std_logic_vector(7 downto 0);
    type note_vector_t is array(mix_channel_count-1 downto 0) of note_t;
    
    subtype volume_t is std_logic_vector(7 downto 0);
    type volume_vector_t is array(mix_channel_count-1 downto 0) of volume_t;
    
    subtype add_mask_t is std_logic_vector(mix_channel_count-1 downto 0);
    subtype dac_out_t is std_logic;
    
end package;
