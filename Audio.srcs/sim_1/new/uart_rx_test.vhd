library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.typedefs.all;
use work.components.all;

entity uart_test is
end uart_test;

architecture Behavioral of uart_test is

-- signal definitions
signal GCLK      : std_logic  := '0';
signal CE        : std_logic  := '0';
signal PCM_DATA  : pcm_data_t := to_pcm_data_t(0);
signal ENABLE    : std_logic  := '0';
signal DAC_OUT   : std_logic  := '0';
signal rx : std_logic := '1';
signal rxdata : std_logic_vector(7 downto 0);
signal dready : std_logic;

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

uut:    component UART_RX_CTRL 
        port map (
            CLK     => GCLK,
            UART_RX => rx,
            DATA => rxdata,
            READ_DATA => dready
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
wait for 200ns; -- wait for the boot time
wait until GCLK='0';
ENABLE <= '1'; -- enable the CE 

rx <= '0';
wait for 936us; --100us : bit duration
--rx <= '1';
--wait for 250us;
--rx<='0';
--wait for 300us;
rx<='1';
wait until CE = '0';
wait until CE = '1';
wait for 1000ms;
end process;

end Behavioral;
