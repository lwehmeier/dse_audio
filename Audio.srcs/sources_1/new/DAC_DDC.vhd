library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.typedefs.all;

entity DAC_DDC is
    Port ( INPUT : in STD_LOGIC;
           PCM_OUT : out pcm_data_t);
end DAC_DDC;

architecture Behavioral of DAC_DDC is
signal TMP : std_logic_vector(pcm_data_width-1 downto 0);
begin
PCM_OUT <= ((pcm_data_width-1) => INPUT, others => not INPUT); -- input is negated, so assuming 2s complement it matches the sign.
end Behavioral;
