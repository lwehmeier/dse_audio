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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
package typedefs is
    constant pcm_data_width: integer := 16;
    constant mix_channel_count: integer := 4;
    constant system_frequency: unsigned := to_unsigned(98304000, 32);
    constant sample_rate: unsigned := to_unsigned(48000, 16);
    
    type wg_type_t is (
        wg_SQUARE, wg_TRIANGLE, wg_SAW, wg_NOISE, wg_SINE
    );
    type wg_type_vector_t is array(mix_channel_count-1 downto 0) of wg_type_t;
    
    type filter_type_t is (
        filter_BIQUAD, filter_PASSTHROUGH
    );
    
    subtype pcm_data_t is signed(pcm_data_width - 1 downto 0);
    function to_pcm_data_t(x: integer) return pcm_data_t;
    type mix_pcm_vector_t is array(mix_channel_count-1 downto 0) of pcm_data_t;
    constant pcm_min: integer := -32768;
    constant pcm_max: integer := 32767;
    
    subtype note_t is std_logic_vector(7 downto 0);
    type note_vector_t is array(mix_channel_count-1 downto 0) of note_t;
    constant note_empty : note_t := x"00";
    
    subtype volume_t is std_logic_vector(8 downto 0);
    type volume_vector_t is array(mix_channel_count-1 downto 0) of volume_t;
    
    subtype env_volume_t is std_logic_vector(7 downto 0);
    type env_volume_vector_t is array(mix_channel_count - 1 downto 0) of env_volume_t;
    constant env_volume_zero : env_volume_t := x"00";
    function to_env_volume_t(x: integer) return env_volume_t;
    
    subtype add_mask_t is std_logic_vector(mix_channel_count-1 downto 0);
    subtype dac_out_t is std_logic;
    
end package;

package body typedefs is
    function to_pcm_data_t(x: integer) return pcm_data_t is
    begin
        return to_signed(x, pcm_data_width);
    end to_pcm_data_t;
    
    function to_env_volume_t(x: integer) return env_volume_t is
    begin
        return std_logic_vector(to_unsigned(x, env_volume_t'length));
    end to_env_volume_t;
end typedefs;
