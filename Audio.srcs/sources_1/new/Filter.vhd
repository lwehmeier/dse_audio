library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.typedefs.all;



-- optional filter stage
-- current implementation: pass through dummy to allow for future extensions
-- adds 1 CE latency to sound generator pipeline
-- instantiated between waveform generators and mixer and between mixer and dac

entity Filter is
generic (
    filter_type : filter_type_t := filter_PASSTHROUGH
);
    Port ( PCM_IN : in pcm_data_t;
           PCM_OUT : out pcm_data_t;
           CLK : in STD_LOGIC;
           CE : in STD_LOGIC);
end Filter;

architecture Behavioral of Filter is
begin
    process (CLK)
    begin
        if rising_edge(CLK) and CE='1' then
            PCM_OUT <= PCM_IN;
        end if;
    end process;
end Behavioral;
