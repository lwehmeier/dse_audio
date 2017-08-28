-- Martin Koppehel

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.typedefs.all;

-- This entity is a so called "digital-to-digital converter"
-- it is used to map a logic signal to a discrete PCM value.
entity DAC_DDC is
    Port ( INPUT : in STD_LOGIC; -- The digital input, which is a bitstream output from a delta-sigma converter
           -- Please note the input is negated.
           
           PCM_OUT : out pcm_data_t -- The pcm output, can take 2 values (min_val or max_val));
end DAC_DDC;

-- This simple implementation maps the input directly to two values. 
architecture Behavioral of DAC_DDC is
begin
PCM_OUT <= ((pcm_data_width-1) => INPUT, others => not INPUT); -- input is negated, so in 2s complement it matches the sign.
end Behavioral;
