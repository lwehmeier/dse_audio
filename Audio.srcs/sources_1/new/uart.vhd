----------------------------------------------------------------------------
--	UART_RX_CTRL.vhd -- Simple UART RX controller
----------------------------------------------------------------------------
-- Author:  Marshall Wingerson 
--          Copyright 2014 Digilent, Inc.
----------------------------------------------------------------------------
-- This component may be used to transfer data over a UART device. It will
-- receive a byte of serial data and transmit it over an 8-bit bus. The 
-- serialized data has to have the following characteristics:
--   *9600 Baud Rate
--   *8 data bits, LSB first
--   *1 stop bit
--   *no parity
--         				
-- Port Descriptions:
--    UART_RX - This signal should be routed to the appropriate RX pin of 
--              the external UART device.
--        CLK - A 100 MHz clock is expected.
--       DATA - The parallel data to be sent. Must be valid the clock cycle
--              that SEND has gone high.
--  READ_DATA - Signal flag indicating when data is ready to be read.
--
----------------------------------------------------------------------------
-- Revision History:
--  07/14/2014(MarshallW): Created using Xilinx Tools 14.7
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity UART_RX_CTRL is
    Port ( UART_RX : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           DATA : out  STD_LOGIC_VECTOR (7 downto 0);
                      READ_DATA : out  STD_LOGIC := '0';
                      READ_DATA_PULSE : out  STD_LOGIC := '0'
			  );
end UART_RX_CTRL;

architecture Behavioral of UART_RX_CTRL is

type RX_STATE_TYPE is (READY, DELAY, GET_BIT, READ_BIT);

constant BIT_TMR_MAX : std_logic_vector(13 downto 0) := std_logic_vector(to_unsigned(10239,14)); --10416 = (round(100MHz / 9600)) - 1; 10050
constant DELAY_COUNTER_MAX : std_logic_vector(13 downto 0) := std_logic_vector(to_unsigned(5250,14)); --"11011001000000";  -- 13888 = ((BIT_TMR_MAX/3) + BIT_TMR_MAX )aiming for bit
constant BIT_INDEX_MAX : natural := 8;

--flag to indicate to move from the delay RXState to the next state
signal DELAY_DONE : std_logic := '0';
signal DELAY_COUNTER : std_logic_vector(13 downto 0) := (others => '0');

--flad to indicate that it is time to read the next bit
signal GET_BIT_DONE : std_logic := '0';
signal GET_BIT_COUNTER : std_logic_vector(13 downto 0) := (others => '0');

signal RX_STATE : RX_STATE_TYPE	:= READY;

signal BIT_INDEX : natural := 0;

signal RX_DATA : std_logic_vector(7 downto 0) := (others => '0');
signal RX_BIT : std_logic := '0';
signal drLastState : std_logic := '0';
signal drSig : std_logic := '0';

begin

readPulseProcess : process (CLK)
begin
    if rising_edge(clk) then
        if drLastState=drSig then
            READ_DATA_PULSE<='0';
        elsif drSig='1' then
            drLastState<='1';
            READ_DATA_PULSE<='1';
        else --drSig changed to 0
            drLastState<='0';
            READ_DATA_PULSE<='0';
        end if;
    end if;
end process;
--receiving state machine
rx_state_process : process (CLK)
begin
	if(rising_edge(CLK)) then
		case RX_STATE is	--waiting for data state
			when READY =>
				if(UART_RX = '0') then
					RX_STATE <= DELAY;
					BIT_INDEX <= 0;
				end if;
				
			when DELAY => 	--delaying for the start bit and 1/3 of the first bit
				if(DELAY_DONE = '1') then
					RX_STATE <= GET_BIT;
				else
					RX_STATE <= Delay;
				end if;

			when GET_BIT =>	--wait for the next bit to be in place
				if(GET_BIT_DONE = '1') then
					RX_STATE <= READ_BIT;
				else
					RX_STATE <= GET_BIT;
					READ_DATA <= '0'; --data is not valid anymore
					drSig <= '0';
				end if;

			when READ_BIT =>	--read bit
				if(BIT_INDEX = BIT_INDEX_MAX) then
					RX_STATE <= READY;
					drSig <= '1';
					READ_DATA <= '1';	--data is valid so read!
				else
					BIT_INDEX <= BIT_INDEX +1;
					RX_STATE <= GET_BIT;
				end if;
			end case;
	end if;
end process;

--read the bit for BIT_INDEX
READ_BIT_PROCESS : process (CLK)
begin
	if(rising_edge(CLK)) then
		if(RX_STATE = READ_BIT and BIT_INDEX < BIT_INDEX_MAX) then
			RX_DATA(BIT_INDEX) <= UART_RX;
		end if;
	end if;
end process;

--timer for the DELAY_DONE signal
DELAY_DONE_PROCESS : process (CLK)
begin
	if(rising_edge(CLK)) then
		if(RX_STATE = DELAY) then
			if(DELAY_COUNTER = DELAY_COUNTER_MAX) then
				DELAY_DONE <= '1';
			else
				DELAY_COUNTER <= DELAY_COUNTER + 1;
				DELAY_DONE <= '0';
			end if;
		else
			DELAY_DONE <= '0';
			DELAY_COUNTER <= (OTHERS => '0');
		end if;
	end if;
end process;

--timer for the GET_BIT_DONE signal
GET_BIT_DELAY_PROCESS : process(CLK)
begin
	if(rising_edge(CLK)) then
		if(RX_STATE = GET_BIT) then
			if(GET_BIT_COUNTER = BIT_TMR_MAX) then
				GET_BIT_DONE <= '1';
			else
				GET_BIT_COUNTER <= GET_BIT_COUNTER + 1;
				GET_BIT_DONE <= '0';
			end if;
		else
			GET_BIT_DONE <= '0';
			GET_BIT_COUNTER <= (OTHERS => '0');
		end if;
	end if;	
end process;

DATA <= RX_DATA;

end Behavioral;
