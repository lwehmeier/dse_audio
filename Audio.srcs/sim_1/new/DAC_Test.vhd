library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.typedefs.all;
use work.components.all;

entity DAC_Test is
end DAC_Test;

architecture Behavioral of DAC_Test is

-- signal definitions
signal GCLK      : std_logic  := '0';
signal CE        : std_logic  := '0';
signal PCM_DATA  : pcm_data_t := to_pcm_data_t(0);
signal ENABLE    : std_logic  := '0';
signal DAC_OUT   : std_logic  := '0';

begin
-- Instantiate components
CE_GEN: component CEGEN48k 
        generic map (
            BIT_WIDTH=>16
        ) 
        port map ( 
            GCLK    => GCLK,
            OUTPUT  => CE, 
            TOP_VAL => std_logic_vector(to_unsigned(2083,16)), -- about 48kHz
            ENABLE  => ENABLE, 
            RESET   => '0');

uut:    component DAC 
        port map (
            CLK     => GCLK,
            CE      => CE,
            PCM_IN  => PCM_DATA,
            DAC_OUT => DAC_OUT
        );

-- System clock generation
clk_process: process
begin
GCLK <= '0';
wait for 5 ns;
GCLK <= '1';
wait for 5 ns;
end process;

-- stimulus process
stim_proc: process
begin
wait for 1ms; -- wait for the boot time
wait until GCLK='0';
ENABLE <= '1'; -- enable the CE 
PCM_DATA <= to_pcm_data_t(0);

-- do a simple ramp to test the DAC output.
for i in 0 to 48000 loop
    wait until CE = '0';
    PCM_DATA <= PCM_DATA + 10;
    wait until CE = '1';
end loop;
wait until CE = '0';
wait until CE = '1';
end process;

end Behavioral;
