library ieee;
use ieee.std_logic_1164.all;
use work.typedefs.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package sine_package is
  constant max_table_value: integer := 32767;
  subtype table_value_type is integer range 0 to max_table_value;

  constant max_table_index: integer := 127;
  subtype table_index_type is integer range 0 to max_table_index;

  subtype sine_vector_type is std_logic_vector( 15 downto 0 );

  function get_table_value (table_index: table_index_type) return table_value_type;
  function sin(i: table_index_type) return pcm_data_t;
end;

package body sine_package is

  function sin(i: table_index_type) return pcm_data_t is
    variable value: pcm_data_t;
  begin
    if i >= 0 and i < 128 then
        value := to_signed(get_table_value(i), pcm_data_t'length);
    elsif i >= 128 and i < 256 then
        value := to_signed(get_table_value(127 - (i - 128)), pcm_data_t'length);
    elsif i >= 256 and i < 384 then
        value := to_signed(-get_table_value(i - 256), pcm_data_t'length);
    else
        value := to_signed(-get_table_value(127 - (i - 384)), pcm_data_t'length);
    end if;
    return value;
  end;

  function get_table_value (table_index: table_index_type) return table_value_type is
    variable table_value: table_value_type;
  begin
    case table_index is
      when 0 =>
        table_value := 201;
      when 1 =>
        table_value := 603;
      when 2 =>
        table_value := 1005;
      when 3 =>
        table_value := 1407;
      when 4 =>
        table_value := 1809;
      when 5 =>
        table_value := 2210;
      when 6 =>
        table_value := 2611;
      when 7 =>
        table_value := 3012;
      when 8 =>
        table_value := 3412;
      when 9 =>
        table_value := 3811;
      when 10 =>
        table_value := 4210;
      when 11 =>
        table_value := 4609;
      when 12 =>
        table_value := 5007;
      when 13 =>
        table_value := 5404;
      when 14 =>
        table_value := 5800;
      when 15 =>
        table_value := 6195;
      when 16 =>
        table_value := 6590;
      when 17 =>
        table_value := 6983;
      when 18 =>
        table_value := 7375;
      when 19 =>
        table_value := 7767;
      when 20 =>
        table_value := 8157;
      when 21 =>
        table_value := 8545;
      when 22 =>
        table_value := 8933;
      when 23 =>
        table_value := 9319;
      when 24 =>
        table_value := 9704;
      when 25 =>
        table_value := 10087;
      when 26 =>
        table_value := 10469;
      when 27 =>
        table_value := 10849;
      when 28 =>
        table_value := 11228;
      when 29 =>
        table_value := 11605;
      when 30 =>
        table_value := 11980;
      when 31 =>
        table_value := 12353;
      when 32 =>
        table_value := 12725;
      when 33 =>
        table_value := 13094;
      when 34 =>
        table_value := 13462;
      when 35 =>
        table_value := 13828;
      when 36 =>
        table_value := 14191;
      when 37 =>
        table_value := 14553;
      when 38 =>
        table_value := 14912;
      when 39 =>
        table_value := 15269;
      when 40 =>
        table_value := 15623;
      when 41 =>
        table_value := 15976;
      when 42 =>
        table_value := 16325;
      when 43 =>
        table_value := 16673;
      when 44 =>
        table_value := 17018;
      when 45 =>
        table_value := 17360;
      when 46 =>
        table_value := 17700;
      when 47 =>
        table_value := 18037;
      when 48 =>
        table_value := 18371;
      when 49 =>
        table_value := 18703;
      when 50 =>
        table_value := 19032;
      when 51 =>
        table_value := 19357;
      when 52 =>
        table_value := 19680;
      when 53 =>
        table_value := 20000;
      when 54 =>
        table_value := 20317;
      when 55 =>
        table_value := 20631;
      when 56 =>
        table_value := 20942;
      when 57 =>
        table_value := 21250;
      when 58 =>
        table_value := 21554;
      when 59 =>
        table_value := 21856;
      when 60 =>
        table_value := 22154;
      when 61 =>
        table_value := 22448;
      when 62 =>
        table_value := 22739;
      when 63 =>
        table_value := 23027;
      when 64 =>
        table_value := 23311;
      when 65 =>
        table_value := 23592;
      when 66 =>
        table_value := 23870;
      when 67 =>
        table_value := 24143;
      when 68 =>
        table_value := 24413;
      when 69 =>
        table_value := 24680;
      when 70 =>
        table_value := 24942;
      when 71 =>
        table_value := 25201;
      when 72 =>
        table_value := 25456;
      when 73 =>
        table_value := 25708;
      when 74 =>
        table_value := 25955;
      when 75 =>
        table_value := 26198;
      when 76 =>
        table_value := 26438;
      when 77 =>
        table_value := 26674;
      when 78 =>
        table_value := 26905;
      when 79 =>
        table_value := 27133;
      when 80 =>
        table_value := 27356;
      when 81 =>
        table_value := 27575;
      when 82 =>
        table_value := 27790;
      when 83 =>
        table_value := 28001;
      when 84 =>
        table_value := 28208;
      when 85 =>
        table_value := 28411;
      when 86 =>
        table_value := 28609;
      when 87 =>
        table_value := 28803;
      when 88 =>
        table_value := 28992;
      when 89 =>
        table_value := 29177;
      when 90 =>
        table_value := 29358;
      when 91 =>
        table_value := 29534;
      when 92 =>
        table_value := 29706;
      when 93 =>
        table_value := 29874;
      when 94 =>
        table_value := 30037;
      when 95 =>
        table_value := 30195;
      when 96 =>
        table_value := 30349;
      when 97 =>
        table_value := 30498;
      when 98 =>
        table_value := 30643;
      when 99 =>
        table_value := 30783;
      when 100 =>
        table_value := 30919;
      when 101 =>
        table_value := 31050;
      when 102 =>
        table_value := 31176;
      when 103 =>
        table_value := 31297;
      when 104 =>
        table_value := 31414;
      when 105 =>
        table_value := 31526;
      when 106 =>
        table_value := 31633;
      when 107 =>
        table_value := 31736;
      when 108 =>
        table_value := 31833;
      when 109 =>
        table_value := 31926;
      when 110 =>
        table_value := 32014;
      when 111 =>
        table_value := 32098;
      when 112 =>
        table_value := 32176;
      when 113 =>
        table_value := 32250;
      when 114 =>
        table_value := 32318;
      when 115 =>
        table_value := 32382;
      when 116 =>
        table_value := 32441;
      when 117 =>
        table_value := 32495;
      when 118 =>
        table_value := 32545;
      when 119 =>
        table_value := 32589;
      when 120 =>
        table_value := 32628;
      when 121 =>
        table_value := 32663;
      when 122 =>
        table_value := 32692;
      when 123 =>
        table_value := 32717;
      when 124 =>
        table_value := 32737;
      when 125 =>
        table_value := 32752;
      when 126 =>
        table_value := 32761;
      when 127 =>
        table_value := 32766;
    end case;
    return table_value;
  end;

end;
