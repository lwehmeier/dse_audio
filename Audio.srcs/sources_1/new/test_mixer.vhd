----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.08.2017 11:49:14
-- Design Name: 
-- Module Name: test_mixer - Behavioral
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
use work.components.all;
use work.typedefs.all;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_mixer is
--  Port ( );
end test_mixer;

architecture bhv of test_mixer is

  -- input
  signal pcm_out   : pcm_data_t;
  signal pcm_in   : mix_pcm_vector_t;
  signal mask_in   : add_mask_t;
  signal clk_in   : std_logic := '0';
  signal ce_in   : std_logic := '0';
  signal reset_in : std_logic := '0';

begin
dut : Mixer port map (PCM_IN_VECT => pcm_in,PCM_OUT=>pcm_data_t,reset=>reset_in,CLK=>clk_in,CE=>ce_in, ADD_MASK=>mask_in);
process
begin
    clk_in   <= '0'; --100mhz
    wait for 5 ns;
    clk_in   <= '1'; --100mhz
    wait for 5 ns;
end process;

process
begin
    wait for 10ns;
    wait on clk_in;
    pcm_in(0)<=to_signed(30,16);
    pcm_in(1)<=to_signed(20,16);
    pcm_in(2)<=to_signed(10,16);
    pcm_in(3)<=to_signed(5,16);
    wait for 6ns;
    wait on clk_in;
        pcm_in(0)<=to_signed(30,16);
        pcm_in(1)<=to_signed(20,16);
        pcm_in(2)<=to_signed(10,16);
        pcm_in(3)<=to_signed(5,16);
     wait ;
end process;
end architecture;
