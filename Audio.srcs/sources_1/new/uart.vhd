----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.08.2017 17:44:36
-- Design Name: 
-- Module Name: uart - Behavioral
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
use work.components.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart is
    Port ( DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           CE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           EVENT_OUT : out STD_LOGIC;
           RESET : in STD_LOGIC);
end uart;

architecture Behavioral of uart is
signal rxCntr : unsigned(4 downto 0) := to_unsigned(0,5);

begin


end Behavioral;
