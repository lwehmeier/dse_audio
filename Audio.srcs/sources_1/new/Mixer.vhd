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
use IEEE.numeric_std.all;
--USE ieee.math_real.all;
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
--constant tree_depth : integer := INTEGER(CEIL(LOG2(REAL(mix_channel_count)))) -1;
--function tree_adder( data : mix_pcm_vector_t; num : unsigned(15 downto 0); depth : unsigned(7 downto 0)) return pcm_data_t is
--variable pcm_buffer : pcm_data_t;
--begin
--if depth = tree_depth then
--    pcm_buffer := data(to_integer(num))+data(to_integer(num)+1);
--else
--    pcm_buffer := tree_adder(data,num,depth+1)+tree_adder(data,num+to_unsigned(2**(tree_depth-to_integer(depth)),16),depth+1);
--end if;
--return pcm_buffer;
--end tree_adder;



begin 
process(clk)
    variable pcm_buffer : pcm_data_t := to_pcm_data_t(0);
begin
    if rising_edge(CLK)
    then
        if CE='1'
        then
            pcm_buffer:=to_pcm_data_t(0);
            for i in mix_channel_count -1 downto 0 loop
                if ADD_MASK(i) = '1' then
                    pcm_buffer := pcm_buffer+PCM_IN_VECT(i);
                end if;
            end loop;
            --pcm_buffer:=tree_adder(PCM_IN_VECT,to_unsigned(0,16),to_unsigned(0,8));
            PCM_OUT<=pcm_buffer;
        end if;
    end if;
end process;
end Behavioral;
