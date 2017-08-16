----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.08.2017 11:34:23
-- Design Name: 
-- Module Name: midi_parser - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity midi_parser is
    Port ( rxData : in STD_LOGIC_VECTOR (7 downto 0);
           newData : in STD_LOGIC;
           note : out STD_LOGIC_VECTOR (7 downto 0);
           volume : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC);
    type state_t is (STATE_CMD,STATE_BYTE1, STATE_BYTE2);  
end midi_parser;

architecture Behavioral of midi_parser is
signal cstate : state_t := STATE_CMD;
signal parsedPitch : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0,8));
signal parsedVelocity : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0,8));
signal noteOff : std_logic := '0';
begin

statemachine : process (CLK)
begin
    if rising_edge(clk) and newData='1' then
        case cstate is
            when STATE_CMD => 
                if rxData(3 downto 0) = "0000" then --ch 0
                    if rxData(7 downto 4) = "1001" then
                        cstate <= STATE_BYTE1;
                        noteOff<='0';
                    elsif rxData(7 downto 4) = "1000" then
                        cstate <= STATE_BYTE1;
                        noteOff<='1';
                    end if;
                end if;
                
                when STATE_BYTE1 =>
                    cstate<=STATE_BYTE2;
                    parsedPitch<=std_logic_vector(to_unsigned(0,8));
                    if noteOff='0' then
                        if rxData(7) = '0' then
                            parsedPitch <= rxData;
                        end if;
                    end if;
                    

                when STATE_BYTE2 =>
                    cstate<=STATE_CMD;
                    parsedVelocity<=std_logic_vector(to_unsigned(0,8));
                    if noteOff='0' then
                        if rxData(7) = '0' then
                            parsedVelocity <= rxData;
                            volume <= rxData;
                        end if;
                    else
                        volume <=std_logic_vector(to_unsigned(0,8));
                    end if;
                    note <= parsedPitch;
                
                when others => cstate <= STATE_CMD;
        end case;
    end if;
end process;

end Behavioral;
