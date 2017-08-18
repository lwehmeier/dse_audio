library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This package contains type definitions for easier interfacing between the modules
package typedefs is
    -- The width of the pcm_data_t type
    constant pcm_data_width: integer := 16;
    constant mix_channel_count: integer := 5;
    constant system_frequency: unsigned := to_unsigned(98304000, 32);
    -- The sample rate
    constant sample_rate: unsigned := to_unsigned(48000, 16);
    
    -- This enum contains all waveform generator types (soundgens)
    type wg_type_t is (
        wg_SQUARE, wg_TRIANGLE, wg_SAW, wg_NOISE, wg_SINE
    );
    -- This vector is used for interfacing with the mixer
    type wg_type_vector_t is array(mix_channel_count-1 downto 0) of wg_type_t;
    
    -- This enum contains all filter types
    type filter_type_t is (
        filter_BIQUAD, filter_PASSTHROUGH
    );
        
    -- This is the type for PCM data used for interfacing with other modules
    subtype pcm_data_t is signed(pcm_data_width - 1 downto 0);
    -- Convert an integer value to pcm data
    function to_pcm_data_t(x: integer) return pcm_data_t;
    -- The PCM vector used for interfacing with the mixer
    type mix_pcm_vector_t is array(mix_channel_count-1 downto 0) of pcm_data_t;
    -- The minimum pcm value
    constant pcm_min: integer := -32768;
    -- The maximum pcm value
    constant pcm_max: integer := 32767;
    
    -- The type used to describe a midi-note
    subtype note_t is std_logic_vector(7 downto 0);
    -- This vector is used for interfacing with the mixer
    type note_vector_t is array(mix_channel_count-1 downto 0) of note_t;
    -- The default note (A)
    constant note_empty : note_t := x"00";
    
    -- The type used to describe a volume
    subtype volume_t is std_logic_vector(8 downto 0);
    -- This vector is used for interfacing with the mixer
    type volume_vector_t is array(mix_channel_count-1 downto 0) of volume_t;
    
    -- The type used to describe a volume for the envelope generator
    subtype env_volume_t is std_logic_vector(7 downto 0);
    -- This vector is used for interfacing with the mixer
    type env_volume_vector_t is array(mix_channel_count - 1 downto 0) of env_volume_t;
    -- The default volume (silence)
    constant env_volume_zero : env_volume_t := x"00";
    -- Convert an integer to an envelope volume
    function to_env_volume_t(x: integer) return env_volume_t;
    
    -- Bitmask to enable/disable channels in the mixer
    subtype add_mask_t is std_logic_vector(mix_channel_count-1 downto 0);
    -- The output type of the DAC
    subtype dac_out_t is std_logic;
    
    -- Set of variables for envelope generation
    type envelope_params_t is record
        ATTACK_TIME      : std_logic_vector(7 downto 0);       -- Attack time
        ATTACK_VOLUME    : env_volume_t;                       -- Peak volume
        DECAY_TIME       : std_logic_vector(7 downto 0);       -- Decay time
        RELEASE_TIME     : std_logic_vector(7 downto 0);       -- Release time
        ATTACK_INCREASE  : env_volume_t;                       -- Volume per attack step to add
        DECAY_DECREASE   : env_volume_t;                       -- Volume per decay step to subtract
        RELEASE_DECREASE : env_volume_t;                       -- Volume per release step to subtract
    end record;
    
    -- This vector is used for interfacing with the generated envelope generator
    type envelope_params_vector_t is array(mix_channel_count - 1 downto 0) of envelope_params_t;
    function default_envelope_params return envelope_params_t;
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
    
    function default_envelope_params return envelope_params_t is
        variable p: envelope_params_t;
    begin
        p.ATTACK_TIME      := x"01";
        p.RELEASE_TIME     := x"01";
        p.DECAY_TIME       := x"01";
        p.ATTACK_INCREASE  := to_env_volume_t(1);
        p.DECAY_DECREASE   := to_env_volume_t(1);
        p.RELEASE_DECREASE := to_env_volume_t(1);
        p.ATTACK_VOLUME    := to_env_volume_t(255);
        return p;
    end default_envelope_params;
end typedefs;
