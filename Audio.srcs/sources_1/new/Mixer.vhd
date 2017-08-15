----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.08.2017 17:30:46
-- Design Name: 
-- Module Name: Mixer - Behavioral
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

entity Mixer is
    Port ( PCM_IN_VECT : in mix_pcm_vector_t;
           PCM_OUT : out pcm_data_t;
           reset : in STD_LOGIC;
           CLK : in STD_LOGIC;
           CE : in STD_LOGIC;
           ADD_MASK : in add_mask_t);
end Mixer;

architecture Behavioral of Mixer is

begin
    PCM_OUT <= "0000000000000000";
end Behavioral;
