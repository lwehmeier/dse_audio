-- Martin Koppehel

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.typedefs.all;
use work.components.all;

entity Envelope is
    
    Port (
        -- Clock sources 
        CLK     : in STD_LOGIC;  -- System Clock
        SR      : in STD_LOGIC;  -- Sample Rate
        NOTE    : in STD_LOGIC;  -- New note can be sampled
        RESET   : in STD_LOGIC;  -- Reset the state machine, synchronous to system clock
        
        -- Tone related
        -- the resolution for times is 2.66ms per step
        NOTE_IN          : in note_t;                         -- Note Input
        SUSTAIN_VOLUME   : in env_volume_t;                   -- Sustain volume
        PARAMS           : in envelope_params_t;              -- Ramp shape information, can be changed during runtime
        
        -- Output volume
        VOL_OUT  : out volume_t;   -- Volume Output
        NOTE_OUT : out note_t     -- Note Output, used to "hold" the note for the release time.  
    );
end Envelope;

-- Morphs the volume to create a ramp.
-- Stage 1: Attack  - output volume ranges from zero to ATTACK_VOLUME in ATTACK_TIME*TIMESTEP
-- Stage 2: Decay   - output volume will range from ATTACK_VOLUME to SUSTAIN_VOLUME in DECAY_TIME*TIMESTEP
-- Stage 3: Sustain - output volume will stay constant while NOTE_IN remains constant.
-- Stage 4: Release - output volume will decay to zero in RELEASE_TIME*TIMESTEP

architecture Behavioral of Envelope is
-- FSM definitions
type envelope_state_t is (IDLE, ATTACK, DECAY, SUSTAIN, RELEASE);
signal CURRENT_STATE : envelope_state_t := IDLE;
signal NEXT_STATE : envelope_state_t := IDLE;

-- This signal is '1' every clock cycle when a timestep should be performed
signal TIMESTEP : STD_LOGIC := '0';
-- This signal is '1' every clock cycle when the ramp value should be updated
signal INCREASE : STD_LOGIC := '0';
-- This signal should be set to '1' when the user wants to reset the timers
signal TS_RESET : STD_LOGIC := '0';
-- The maximum value the INCREASE_TIMER should have, this is set by the state logic according to the current state.
signal TS_TOP_VAL : STD_LOGIC_VECTOR(7 downto 0);

-- The note at the output
signal CURRENT_NOTE : note_t := note_empty;
-- The sampled volume, this needs to be cached because once the key is released, this value is needed again
signal CURRENT_SUSTAIN_VOLUME : env_volume_t := env_volume_zero;
-- The volume at the output
signal CURRENT_VOLUME : env_volume_t := env_volume_zero;
begin
-- Timestep generation
TIMER_TB :  CEGEN48k 
            generic map (
                BIT_WIDTH => 5
            ) 
            port map (
                GCLK => CLK, 
                ENABLE => SR, 
                TOP_VAL => "00011", -- 48khz / 4 -> 12khz
                RESET => TS_RESET,
                OUTPUT => TIMESTEP
            );
TIMER_TS :  CEGEN48k
            generic map (
                BIT_WIDTH => 8
            )
            port map (
                GCLK => CLK,
                ENABLE => TIMESTEP,
                RESET => TS_RESET,
                TOP_VAL => TS_TOP_VAL,
                OUTPUT => INCREASE
            );

-- FSM state transition process
-- This process checks whether a state transition should be performed
-- and updates the state 
STATE_TRANSITION : process (CLK) 
begin 
      if rising_edge(CLK) then 
            if (RESET = '1') then 
                CURRENT_STATE <= IDLE; 
            elsif CURRENT_STATE = NEXT_STATE then
                CURRENT_STATE <= NEXT_STATE;
                TS_RESET <= '0';
            else
                CURRENT_STATE <= NEXT_STATE;
                TS_RESET <= '1';  -- reset the timestep and increase timers on transition change
            end if; 
      end if; 
end process; 

-- this process sets up the timer top values to generate INCREASE events according to the current state
TIMER_MGMT : process (CLK)
begin
    if rising_edge(CLK) then
        case NEXT_STATE is -- use next state to prevent one cycle delay and therefore desync
            when ATTACK =>
                TS_TOP_VAL <= PARAMS.ATTACK_TIME;
            when DECAY => 
                TS_TOP_VAL <= PARAMS.DECAY_TIME;
            when RELEASE =>
                TS_TOP_VAL <= PARAMS.RELEASE_TIME;
            when others =>
                TS_TOP_VAL <= "11111111"; -- maximum top value for idle and sustain
        end case;
    end if;
end process;

-- This process generates the ramp based on the env_params_t structure this entity has as input
STATE_DECODE : process (CLK)
begin
    if rising_edge(CLK) then
        if NOTE = '1' and NOTE_IN /= CURRENT_NOTE then
            -- a new note should be sampled and the sampled note is NOT equal to the note we are currently processing
            if NOTE_IN = note_empty then
                if PARAMS.RELEASE_TIME = x"00" or PARAMS.RELEASE_DECREASE = x"00" then -- no release was configured, so skip the release state entirely
                    NEXT_STATE <= IDLE;
                    CURRENT_NOTE <= note_empty;
                    CURRENT_VOLUME <= env_volume_zero;
                else 
                    NEXT_STATE <= RELEASE; -- we already have a note, which was released, so enter the release phase.
                end if;
            else
                -- sample note and sustain volume
                CURRENT_NOTE <= NOTE_IN;
                CURRENT_SUSTAIN_VOLUME <= SUSTAIN_VOLUME;
                
                -- perform some special treatment to no attack and no decay 
                if PARAMS.ATTACK_TIME = x"00" or PARAMS.ATTACK_INCREASE = x"00" then
                    if PARAMS.DECAY_TIME = x"00" or PARAMS.DECAY_DECREASE = x"00" then
                        NEXT_STATE <= SUSTAIN; -- no attack and no decay, so skip both states, go to sustain
                        CURRENT_VOLUME <= SUSTAIN_VOLUME;
                    else
                        NEXT_STATE <= DECAY; -- no attack, so skip attack state, go to decay, set attack_volume as initial volume
                        CURRENT_VOLUME <= PARAMS.ATTACK_VOLUME;
                    end if;
                else
                    NEXT_STATE <= ATTACK;  -- attack and decay were configured, so begin at volume zero and go to attack state
                    CURRENT_VOLUME <= env_volume_zero;
                end if;
            end if;
        elsif INCREASE = '1' then
            case CURRENT_STATE is
                when ATTACK =>
                    --do an addition with saturation logic
                    if unsigned('0' & CURRENT_VOLUME) + unsigned('0' & PARAMS.ATTACK_INCREASE) >= unsigned('0' & PARAMS.ATTACK_VOLUME) then
                        if PARAMS.DECAY_TIME = x"00" or PARAMS.DECAY_DECREASE = x"00" then
                            NEXT_STATE <= SUSTAIN;
                            CURRENT_VOLUME <= CURRENT_SUSTAIN_VOLUME;
                        else
                            NEXT_STATE <= DECAY; -- change state to decay
                            CURRENT_VOLUME <= PARAMS.ATTACK_VOLUME; -- saturated volume
                        end if;
                    else
                      CURRENT_VOLUME <= std_logic_vector(unsigned(CURRENT_VOLUME) + unsigned(PARAMS.ATTACK_INCREASE));
                      -- increase the volume by the volume given in ATTACK_INCREASE
                    end if;
                when DECAY =>
                    -- do a subtraction with saturation logic
                    if signed('0' & CURRENT_VOLUME) - signed('0' & PARAMS.DECAY_DECREASE) <= signed('0' & CURRENT_SUSTAIN_VOLUME) then
                        NEXT_STATE <= SUSTAIN;
                        CURRENT_VOLUME <= CURRENT_SUSTAIN_VOLUME;
                    else
                        CURRENT_VOLUME <= std_logic_vector(unsigned(CURRENT_VOLUME) - unsigned(PARAMS.DECAY_DECREASE));
                    end if;
                when RELEASE =>
                    if signed('0' & CURRENT_VOLUME) - signed('0' & PARAMS.RELEASE_DECREASE) <= signed('0' & env_volume_zero) then
                        NEXT_STATE <= IDLE;
                        CURRENT_NOTE <= note_empty;
                        CURRENT_VOLUME <= env_volume_zero;
                    else
                        CURRENT_VOLUME <= std_logic_vector(unsigned(CURRENT_VOLUME) - unsigned(PARAMS.RELEASE_DECREASE));
                    end if;
                when others => null; -- on sustain and idle, nothing should happen
            end case;
        end if;
    end if; 
end process;

-- Outputs 
VOL_OUT <= '0' & CURRENT_VOLUME;
NOTE_OUT <= CURRENT_NOTE;
end Behavioral;
