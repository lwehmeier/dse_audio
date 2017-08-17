----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.08.2017 17:16:30
-- Design Name: 
-- Module Name: Filter - Behavioral
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

entity Filter is
generic (
    filter_type : filter_type_t := filter_PASSTHROUGH
);
    Port ( PCM_IN : in pcm_data_t;
           PCM_OUT : out pcm_data_t;
           CLK : in STD_LOGIC;
           CE : in STD_LOGIC);
end Filter;

architecture Behavioral of Filter is

begin
    PCM_OUT <= PCM_IN;
end Behavioral;
