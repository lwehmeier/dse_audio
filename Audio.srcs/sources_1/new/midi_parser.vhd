library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.typedefs.all;

entity midi_parser is
    Port ( rxData : in STD_LOGIC_VECTOR (7 downto 0);
           newData : in STD_LOGIC;
           note : out note_vector_t;
           volume : out env_volume_vector_t;
           note_ready : out STD_LOGIC_VECTOR (mix_channel_count-1 downto 0);
           envelope_params : out envelope_params_vector_t;
           clk : in STD_LOGIC);
    type state_t is (STATE_CMD,STATE_BYTE1, STATE_BYTE2);  
    type command_t is (CMD_NOTE_ON, CMD_NOTE_OFF, CMD_CUSTOM, CMD_INVALID);
end midi_parser;

architecture Behavioral of midi_parser is
signal cstate : state_t := STATE_CMD;
signal first_data : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0,8));

signal current_CMD : command_t := CMD_INVALID;
signal currentChannel : unsigned(2 downto 0);

begin

statemachine : process (CLK)
begin
    if rising_edge(clk) then
        note_ready <= (others => '0');
        if newData = '1' then
            case cstate is
                when STATE_CMD => 
                    currentChannel <= unsigned(rxData(2 downto 0));
                    case rxData(7 downto 4) is
                        when x"8" => 
                            current_CMD <= CMD_NOTE_OFF;
                            cstate <= STATE_BYTE1;
                        when x"9" =>
                            current_CMD <= CMD_NOTE_ON;
                            cstate <= STATE_BYTE1;
                        when x"A" =>
                            current_CMD <= CMD_CUSTOM;
                            cstate <= STATE_BYTE1;
                        when others =>
                            current_CMD <= CMD_INVALID;
                            cstate <= STATE_CMD;
                    end case;
            
                when STATE_BYTE1 =>
                    cstate<=STATE_BYTE2;
                    first_data <= rxData;
                    

                when STATE_BYTE2 =>
                    cstate<=STATE_CMD;
                    case current_CMD is
                        when CMD_NOTE_ON => 
                            note(to_integer(currentChannel)) <= '0' & first_data(6 downto 0);
                            volume(to_integer(currentChannel)) <= rxData(6 downto 0) & '0';
                            note_ready(to_integer(currentChannel)) <= '1';
                        when CMD_NOTE_OFF =>
                            note(to_integer(currentChannel)) <= note_empty;
                            note_ready(to_integer(currentChannel)) <= '1';
                            -- we need to keep the volume i think
                        when CMD_CUSTOM => 
                            case first_data(2 downto 0) is
                                when x"0" =>
                                    -- Parameter 0 is attack time
                                    envelope_params(to_integer(currentChannel)).ATTACK_TIME <= rxData(6 downto 0) & '0';
                                when x"1" =>
                                    -- Parameter 1 is attack increase
                                    envelope_params(to_integer(currentChannel)).ATTACK_INCREASE <= rxData(6 downto 0) & '0';
                                when x"2" =>
                                    -- Parameter 2 is attack peak level
                                    envelope_params(to_integer(currentChannel)).ATTACK_VOLUME <= rxData(6 downto 0) & '0';
                                when x"3" =>
                                    -- Parameter 3 is decay time
                                    envelope_params(to_integer(currentChannel)).DECAY_TIME <= rxData(6 downto 0) & '0';
                                when x"4" =>
                                    -- Parameter 4 is decay decrease
                                    envelope_params(to_integer(currentChannel)).DECAY_DECREASE <= rxData(6 downto 0) & '0';
                                when x"5" =>
                                    -- Parameter 5 is release time
                                    envelope_params(to_integer(currentChannel)).RELEASE_TIME <= rxData(6 downto 0) & '0';
                                when x"6" =>
                                    -- Parameter 6 is release decrease
                                    envelope_params(to_integer(currentChannel)).RELEASE_DECREASE <= rxData(6 downto 0) & '0';
                                when others => null; -- Parameter 7 is n/a
                            end case;
                        when others => null;
                    end case;
                when others => cstate <= STATE_CMD;
            end case;
        end if;
    end if;
end process;
end Behavioral;
