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
        -- TODO: Maybe add a lookup table to have exponential time steps
        NOTE_IN          : in note_t;                         -- Note Input
        SUSTAIN_VOLUME   : in volume_t;                       -- Sustain volume
        ATTACK_TIME      : in std_logic_vector(7 downto 0);   -- Attack time
        ATTACK_VOLUME    : in volume_t;                       -- Peak volume
        DECAY_TIME       : in std_logic_vector(7 downto 0);   -- Decay time
        RELEASE_TIME     : in std_logic_vector(7 downto 0);   -- Release time
        ATTACK_INCREASE  : in volume_t;                       -- Volume per attack step to add
        DECAY_DECREASE   : in volume_t;                       -- Volume per decay step to subtract
        RELEASE_DECREASE : in volume_t;                       -- Volume per release step to subtract
        
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

signal TIMESTEP : STD_LOGIC := '0';
signal INCREASE : STD_LOGIC := '0';
signal TS_RESET : STD_LOGIC := '0';
signal TS_TOP_VAL : STD_LOGIC_VECTOR(7 downto 0);

signal CURRENT_NOTE : note_t := note_empty;
signal CURRENT_SUSTAIN_VOLUME : volume_t := volume_zero;
signal CURRENT_VOLUME : volume_t := volume_zero;
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
                TS_TOP_VAL <= ATTACK_TIME;
            when DECAY => 
                TS_TOP_VAL <= DECAY_TIME;
            when RELEASE =>
                TS_TOP_VAL <= RELEASE_TIME;
            when others =>
                TS_TOP_VAL <= "11111111"; -- maximum top value for idle and sustain
        end case;
    end if;
end process;

STATE_DECODE : process (CLK)
begin
    if rising_edge(CLK) then
        if NOTE = '1' and NOTE_IN /= CURRENT_NOTE then
            -- a new note should be sampled and the sampled note is NOT equal to the note we are currently processing
            if NOTE_IN = note_empty then
                if RELEASE_TIME = x"00" or RELEASE_DECREASE = x"00" then -- no release was configured, so skip the release state entirely
                    NEXT_STATE <= IDLE;
                    CURRENT_NOTE <= note_empty;
                    CURRENT_VOLUME <= volume_zero;
                else 
                    NEXT_STATE <= RELEASE; -- we already have a note, which was released, so enter the release phase.
                end if;
            else
                -- sample note and sustain volume
                CURRENT_NOTE <= NOTE_IN;
                CURRENT_SUSTAIN_VOLUME <= SUSTAIN_VOLUME;
                
                -- perform some special treatment to no attack and no decay 
                if ATTACK_TIME = x"00" or ATTACK_INCREASE = x"00" then
                    if DECAY_TIME = x"00" or DECAY_DECREASE = x"00" then
                        NEXT_STATE <= SUSTAIN; -- no attack and no decay, so skip both states, go to sustain
                        CURRENT_VOLUME <= SUSTAIN_VOLUME;
                    else
                        NEXT_STATE <= DECAY; -- no attack, so skip attack state, go to decay, set attack_volume as initial volume
                        CURRENT_VOLUME <= ATTACK_VOLUME;
                    end if;
                else
                    NEXT_STATE <= ATTACK;  -- attack and decay were configured, so begin at volume zero and go to attack state
                    CURRENT_VOLUME <= volume_zero;
                end if;
            end if;
        elsif INCREASE = '1' then
            case CURRENT_STATE is
                when ATTACK =>
                    --do an addition with saturation logic
                    if unsigned('0' & CURRENT_VOLUME) + unsigned('0' & ATTACK_INCREASE) >= unsigned('0' & ATTACK_VOLUME) then
                        if DECAY_TIME = x"00" or DECAY_DECREASE = x"00" then
                            NEXT_STATE <= SUSTAIN;
                            CURRENT_VOLUME <= CURRENT_SUSTAIN_VOLUME;
                        else
                            NEXT_STATE <= DECAY; -- change state to decay
                            CURRENT_VOLUME <= ATTACK_VOLUME; -- saturated volume
                        end if;
                    else
                      CURRENT_VOLUME <= std_logic_vector(unsigned(CURRENT_VOLUME) + unsigned(ATTACK_INCREASE));
                      -- increase the volume by the volume given in ATTACK_INCREASE
                    end if;
                when DECAY =>
                    if signed('0' & CURRENT_VOLUME) - signed('0' & DECAY_DECREASE) <= signed('0' & CURRENT_SUSTAIN_VOLUME) then
                        NEXT_STATE <= SUSTAIN;
                        CURRENT_VOLUME <= CURRENT_SUSTAIN_VOLUME;
                    else
                        CURRENT_VOLUME <= std_logic_vector(unsigned(CURRENT_VOLUME) - unsigned(DECAY_DECREASE));
                    end if;
                when RELEASE =>
                    if signed('0' & CURRENT_VOLUME) - signed('0' & RELEASE_DECREASE) <= signed('0' & volume_zero) then
                        NEXT_STATE <= IDLE;
                        CURRENT_NOTE <= note_empty;
                        CURRENT_VOLUME <= volume_zero;
                    else
                        CURRENT_VOLUME <= std_logic_vector(unsigned(CURRENT_VOLUME) - unsigned(RELEASE_DECREASE));
                    end if;
                when others => null; -- on sustain and idle, nothing should happen
            end case;
        end if;
    end if; 
end process;

VOL_OUT <= CURRENT_VOLUME;
NOTE_OUT <= CURRENT_NOTE;
end Behavioral;
