library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.typedefs.all;
use work.components.all;

entity uart_midi_test is
end uart_midi_test;

architecture Behavioral of uart_midi_test is

-- signal definitions
signal GCLK      : std_logic  := '0';
signal CE        : std_logic  := '0';
signal PCM_DATA  : pcm_data_t := to_pcm_data_t(0);
signal ENABLE    : std_logic  := '0';
signal DAC_OUT   : std_logic  := '0';
signal rx : std_logic := '1';
signal rxdata : std_logic_vector(7 downto 0);
signal note : std_logic_vector(7 downto 0);
signal volume : std_logic_vector(7 downto 0);
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
uart:    component UART_RX_CTRL 
                    port map (
                        CLK     => GCLK,
                        UART_RX => rx,
                        DATA => rxdata,
                        READ_DATA => open,
                        READ_DATA_PULSE => dready
                    );
uut:    component midi_parser 
        port map (
            CLK     => GCLK,
            rxData => rxdata,
            newData => dready,
            volume => volume,
            note => note
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


rx <= '0';--send note on ch 0, start bit; LSB FIRST!!!
wait for 200us; 
rx <= '0'; --0000
wait for 416us; 
rx <= '1'; --1
wait for 104us; 
rx <= '0'; --00
wait for 208us; 
rx <= '1'; --1
wait for 104us; 
rx <= '1'; --stop bit
wait for 150us;

wait for 500us;

rx <= '0';--send pitch 64
wait for 250us; 
rx <= '0'; --0000
wait for 416us; 
rx <= '0';
wait for 104us; 
rx <= '1';
wait for 104us; 
rx <= '0';
wait for 104us; 
rx <= '1'; --stop bit
wait for 150us;


wait for 500us;


rx <= '0';--send velocity 64
wait for 250us; 
rx <= '0'; --0000
wait for 416us; 
rx <= '0';
wait for 104us; 
rx <= '1';
wait for 104us; 
rx <= '0';
wait for 104us; 
rx <= '1'; --stop bit
wait for 150us;

wait for 2500us;

rx <= '0';--send note off ch 0, start bit; LSB FIRST!!!
wait for 200us; 
rx <= '0'; --0000
wait for 416us; 
rx <= '0'; --0
wait for 104us; 
rx <= '0'; --00
wait for 208us; 
rx <= '1'; --1
wait for 104us; 
rx <= '1'; --stop bit
wait for 150us;

wait for 500us;

rx <= '0';--send pitch 64
wait for 250us; 
rx <= '0'; --0000
wait for 416us; 
rx <= '0';
wait for 104us; 
rx <= '1';
wait for 104us; 
rx <= '0';
wait for 104us; 
rx <= '1'; --stop bit
wait for 150us;


wait for 500us;


rx <= '0';--send velocity 64
wait for 250us; 
rx <= '0'; --0000
wait for 416us; 
rx <= '0';
wait for 104us; 
rx <= '1';
wait for 104us; 
rx <= '0';
wait for 104us; 
rx <= '1'; --stop bit
wait for 150us;



wait until CE = '0';
wait until CE = '1';
wait for 1000ms;
end process;

end Behavioral;
