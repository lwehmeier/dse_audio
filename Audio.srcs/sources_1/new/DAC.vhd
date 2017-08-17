library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.typedefs.all;
use work.components.all;

entity DAC is
    Port ( CLK : in STD_LOGIC;
           CE : in STD_LOGIC;
           PCM_IN : in pcm_data_t;
           DAC_OUT : out dac_out_t);
end DAC;

architecture DeltaSigmaDAC of DAC is
signal PCM_SOURCE : pcm_data_t := to_pcm_data_t(0);
signal PCM_DDC_OUT : pcm_data_t := to_pcm_data_t(0);
signal ACCUMULATOR : pcm_data_t := to_pcm_data_t(0);

begin
-- combinatorical mapper from digital output (accumulator sign bit) back to PCM data to get the "error" of the output.
DDC : DAC_DDC port map(INPUT => ACCUMULATOR(pcm_data_width-1), PCM_OUT => PCM_DDC_OUT);

-- simple sample and hold process for the PCM input data
PCM_INPUT : process (CLK)
begin
    if rising_edge(CLK) and CE='1' then
        PCM_SOURCE <= PCM_IN;
    end if;
end process;

-- accumulation process, calculates the error of the input and accumulates the errors
ACCUM_PROC : process (CLK)
begin
    if rising_edge(CLK) then
        ACCUMULATOR <= (PCM_SOURCE - PCM_DDC_OUT) + ACCUMULATOR;
    end if;
end process;

-- DAC output
DAC_OUT <= not ACCUMULATOR(pcm_data_width-1);
end DeltaSigmaDAC;

architecture PWMDAC of DAC is
constant OUTPUT_BW : integer := 11;
signal TIMER_VAL : signed(OUTPUT_BW-1 downto 0) := to_signed(-1024, OUTPUT_BW);
signal CUR_SAMPLE : signed(OUTPUT_BW-1 downto 0) := to_signed(0, OUTPUT_BW);

begin

-- timer value evaluation
OUTPUT_PROC : process (CLK)
begin
    if rising_edge(CLK) then
        if CE = '1' then
            CUR_SAMPLE <= PCM_IN(pcm_data_width - 1 downto pcm_data_width - OUTPUT_BW);
            TIMER_VAL <= to_signed(-1024, OUTPUT_BW);
        else
            TIMER_VAL <= TIMER_VAL + to_signed(1, OUTPUT_BW);
        end if;
        
        if CUR_SAMPLE > TIMER_VAL then
            DAC_OUT <= '1';
        else
            DAC_OUT <= '0';
        end if;
    end if;
end process;
end PWMDAC;