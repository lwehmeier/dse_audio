----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.08.2017 17:02:01
-- Design Name: 
-- Module Name: waveformGen - Behavioral
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
use work.typedefs.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity waveformGen is
Generic (
    wg_type : wg_type_t := wg_SINE
);
    Port ( CLK : in STD_LOGIC;
           CE : in STD_LOGIC;
           PCM_OUT : out pcm_data_t;
           NOTE : in note_t;
           VOLUME : in volume_t;
           RESET : in STD_LOGIC);
end waveformGen;

architecture Behavioral of waveformGen is

begin
    PCM_OUT <= "0000000000000000";
end Behavioral;
