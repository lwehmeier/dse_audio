#! /usr/bin/env python3

import sys;

def main():
    # the period times in clock enable cycles for the notes c, d, e, f, g, a, b
    periods = [183, 173, 163, 154, 146, 137, 130, 122, 116, 109, 103, 97]

    # generate vhdl code for a LUT containing the sine indices for all listed periods
    #  > the sine lut ranges from 0 to 511 entries
    print ("library IEEE;")
    print ("use IEEE.STD_LOGIC_1164.ALL;")
    print ("use work.typedefs.all;")
    print ("use IEEE.NUMERIC_STD.ALL;")
    print ("")
    print ("package soundgen_sine_lut is")
    print ("    subtype sample_rate_t is unsigned(sample_rate'length - 1 downto 0);")

    # generate indices for each period for the sine lut
    for period in periods:
        print ("")
        print ("    type sample_rate_{}_t is array(0 to {}) of sample_rate_t;".format(period, period))
        print ("    constant lut_{}: sample_rate_{}_t := ({});".format(
            period,
            period,
            ",".join(
                "to_unsigned({},sample_rate_t'length)".format((511 * i) // period) for i in range(0, period + 1)
            )
        ))

    print ("")
    print ("    function counter_over_period(counter: sample_rate_t; period: sample_rate_t) return sample_rate_t;")
    print ("end package soundgen_sine_lut;")
    print ("")
    print ("package body soundgen_sine_lut is")
    print ("    function counter_over_period(counter: sample_rate_t; period: sample_rate_t) return sample_rate_t is")
    print ("    begin")
    print ("        case to_integer(period) is")

    # generate convenience function to map periods to sine indices
    for period in periods:
        print ("            when {} => return lut_{}(to_integer(counter));".format(period, period))

    print ("            when others => return to_unsigned(0, sample_rate_t'length);")
    print ("        end case;")
    print ("    end counter_over_period;")
    print ("end package body soundgen_sine_lut;")
    print ("")

main()
