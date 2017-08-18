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
           clk : in STD_LOGIC);
    type state_t is (STATE_CMD,STATE_BYTE1, STATE_BYTE2);  
end midi_parser;

architecture Behavioral of midi_parser is
signal cstate : state_t := STATE_CMD;
signal parsedPitch : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0,8));
signal parsedVelocity : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0,8));
signal noteOff : std_logic := '0';
signal currentChannel : unsigned(2 downto 0);
signal note_ready_int : STD_LOGIC_VECTOR(mix_channel_count-1 downto 0) := std_logic_vector(to_unsigned(0, mix_channel_count));
begin

statemachine : process (CLK)
begin
    if rising_edge(clk) and newData='1' then
        case cstate is
            when STATE_CMD => 
                    note_ready_int(to_integer(currentChannel)) <= '0';
                    currentChannel <= unsigned(rxData(2 downto 0));
                    if rxData(7 downto 4) = "1001" then
                        cstate <= STATE_BYTE1;
                        noteOff<='0';
                    elsif rxData(7 downto 4) = "1000" then
                        cstate <= STATE_BYTE1;
                        noteOff<='1';
                    end if;
                
                when STATE_BYTE1 =>
                    cstate<=STATE_BYTE2;
                    --parsedPitch<=note_empty; we need to keep the last note on note off.
                    --otherwise the mixer will overflow
                    if noteOff='0' then
                        if rxData(7) = '0' then
                            parsedPitch(6 downto 0) <= rxData(6 downto 0);
                        end if;
                    end if;
                    

                when STATE_BYTE2 =>
                    cstate<=STATE_CMD;
                    parsedVelocity<=x"00";
                    if noteOff='0' then
                        if rxData(7) = '0' then
                            parsedVelocity(7 downto 1) <= rxData(6 downto 0);
                            volume(to_integer(currentChannel))(7 downto 1) <= rxData(6 downto 0);
                        end if;
                    else
                        volume(to_integer(currentChannel)) <= env_volume_zero;
                    end if;
                    note(to_integer(currentChannel)) <= parsedPitch;
                    note_ready_int(to_integer(currentChannel)) <= '1';
                
                when others => cstate <= STATE_CMD;
        end case;
    end if;
end process;
note_ready <= note_ready_int;
end Behavioral;
