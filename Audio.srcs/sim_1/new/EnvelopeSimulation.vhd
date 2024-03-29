-- Martin Koppehel

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.typedefs.all;
use work.components.all;

-- Test bench for the envelope volume generator

entity EnvTest is
end EnvTest;

architecture Behavioral of EnvTest is

-- signal definitions
signal GCLK       : std_logic  := '0'; -- System clock
signal CE         : std_logic  := '0'; -- Sample rate
signal ENABLE     : std_logic  := '0'; -- Timer enable signal
signal NOTE_READY : std_logic  := '0'; -- Signal to indicate that a note signal is ready and can be sampled
signal NOTE       : note_t     := note_empty; -- The note which should be played
signal SUSTAIN_V  : volume_t   := volume_zero; -- The volume the note should be played
signal ATTACK_V   : volume_t   := volume_zero; -- The attack volume
signal ATTACK_T   : std_logic_vector(7 downto 0) := x"00"; -- Attack time
signal DECAY_T    : std_logic_vector(7 downto 0) := x"00"; -- Decay time 
signal RELEASE_T  : std_logic_vector(7 downto 0) := x"00"; -- Release time
signal ATTACK_S   : volume_t := to_volume_t(2); -- Attack step, used to generate more steep ramps
signal DECAY_S    : volume_t := to_volume_t(1); -- Decay step, used to generate more steep ramps
signal RELEASE_S  : volume_t := to_volume_t(1); -- Release step, used to generate more steep ramps
signal NOTE_OUT   : note_t     := note_empty; -- Note output of the envelope generator 
signal VOL_OUT    : volume_t   := volume_zero; -- Volume output of the envelope generator

-- Please note that this test bench isn't working anymore, it needs to be adapted using the new env_params_t structure

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

uut:    component Envelope 
        port map (
             CLK    => GCLK,
             SR     => CE,
             NOTE   => NOTE_READY,
             RESET  => '0',
             
             NOTE_IN        => NOTE,
             SUSTAIN_VOLUME => SUSTAIN_V,
             ATTACK_TIME    => ATTACK_T,
             ATTACK_VOLUME  => ATTACK_V,
             DECAY_TIME     => DECAY_T,
             RELEASE_TIME   => RELEASE_T,
             ATTACK_INCREASE  => ATTACK_S,
             DECAY_DECREASE   => DECAY_S,
             RELEASE_DECREASE => RELEASE_S,
             
             VOL_OUT  => VOL_OUT,
             NOTE_OUT => NOTE_OUT 
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
wait for 100us; -- wait for the boot time
wait until GCLK='0';
ENABLE <= '1'; -- enable the CE 
SUSTAIN_V <= to_volume_t(127);
ATTACK_V <= to_volume_t(255);
ATTACK_T <= "00000001";
DECAY_T <= "00000000";
RELEASE_T <= "00000000";

wait until CE='1';
wait until CE='0';
wait until GCLK='0';
NOTE <= std_logic_vector(to_unsigned(70, 8));
NOTE_READY <= '1';
wait until GCLK='1';
wait until GCLK='0';
NOTE_READY <= '0';

wait for 100ms;
wait until GCLK='0';
NOTE <= note_empty;
NOTE_READY <= '1';
wait until GCLK='1';
wait until GCLK='0';
NOTE_READY <= '0';
wait for 30ms;

assert 1=0
    report "finished"
    severity failure;

end process;

end Behavioral;
