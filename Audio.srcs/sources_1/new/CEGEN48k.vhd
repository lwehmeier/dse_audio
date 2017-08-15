----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.08.2017 16:58:39
-- Design Name: 
-- Module Name: CEGEN48k - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CEGEN48k is
    Port ( gclk : in STD_LOGIC;
           output : out STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end CEGEN48k;

architecture Behavioral of CEGEN48k is

begin
    output <= '0';
end Behavioral;
