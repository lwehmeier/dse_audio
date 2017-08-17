#! /usr/bin/env python3

import sys;

def main():
    periods = [183, 173, 163, 154, 146, 137, 130, 122, 116, 109, 103, 97]
    pcm_min = -32768
    pcm_max = 32767

    print ("library IEEE;")
    print ("use IEEE.STD_LOGIC_1164.ALL;")
    print ("use work.typedefs.all;")
    print ("use IEEE.NUMERIC_STD.ALL;")
    print ("")
    print ("package soundgen_saw_lut is")
    print ("    subtype sample_rate_t is unsigned(sample_rate'length - 1 downto 0);")

    for period in periods:
        print ("")
        print ("    type pcm_data_{}_t is array(0 to {}) of pcm_data_t;".format(period, period))
        print ("    constant lut_{}: pcm_data_{}_t := ({});".format(
            period,
            period,
            ",".join(
                "to_signed({},pcm_data_t'length)".format(pcm_min + (pcm_max - pcm_min) * i // period) for i in range(0, period + 1)
            )
        ))

    print ("")
    print ("    function counter_over_period(counter: sample_rate_t; period: sample_rate_t) return pcm_data_t;")
    print ("end package soundgen_saw_lut;")
    print ("")
    print ("package body soundgen_saw_lut is")
    print ("    function counter_over_period(counter: sample_rate_t; period: sample_rate_t) return pcm_data_t is")
    print ("    begin")
    print ("        case to_integer(period) is")

    for period in periods:    
        print ("            when {} => return lut_{}(to_integer(counter));".format(period, period))
    
    print ("            when others => return to_signed(0, pcm_data_t'length);")
    print ("        end case;")
    print ("    end counter_over_period;")
    print ("end package body soundgen_saw_lut;")
    print ("")

main()

