----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.08.2017 13:54:42
-- Design Name: 
-- Module Name: soundgen_test - Behavioral
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
use work.components.all;
use work.soundgen.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity soundgen_test is
end soundgen_test;

architecture behav of soundgen_test is
type generators_t is array(4 downto 0) of wg_type_t;
constant generators: generators_t := (wg_SQUARE, wg_TRIANGLE, wg_SAW, wg_NOISE, wg_SINE);
type pcm_vector_t is array(generators'length - 1 downto 0) of pcm_data_t;

signal clk: std_logic;
signal ce: std_logic;
signal pcm: pcm_vector_t;
signal note_sig: note_t;
signal volume: volume_t;
begin
    soundgen_loop : for i in 0 to generators'length - 1 generate
        soundgen_x : waveformGen generic map (
            wg_type => generators(i)
        )
        port map (
            clk => clk,
            ce => ce,
            pcm_out => pcm(i),
            note => note_sig,
            volume => volume,
            reset => '0'
        );
    end generate soundgen_loop;
    
    process
    begin
        clk <= '0'; --100mhz
        ce <= '0';
        wait for 5 ns;
        clk <= '1'; --100mhz
        ce <= '1';
        wait for 5 ns;
    end process;
    
    process
    variable vol: integer := 256;
    begin
        wait for 200ns;
        
        wait until clk = '0';
        note_sig <= std_logic_vector(to_unsigned(69, 8));
        volume <= std_logic_vector(to_unsigned(vol, 9));
        
        for i in 0 to 1000 loop
            vol := vol - 1;
            if vol <= 0 then
                vol := 256;
            end if;
            
            report "vol: " & integer'image(vol)
                severity note;
            
            volume <= std_logic_vector(to_unsigned(vol, 9));
            wait until clk = '1';
            wait until clk = '0';
        end loop;
        
        wait;
    end process;
end behav;
