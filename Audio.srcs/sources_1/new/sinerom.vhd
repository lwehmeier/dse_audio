library ieee;
use ieee.std_logic_1164.all;

package sine_package is

  constant max_table_value: integer := 128;
  subtype table_value_type is integer range -127 to max_table_value;

  constant max_table_index: integer := 255;
  subtype table_index_type is integer range 0 to max_table_index;

  subtype sine_vector_type is std_logic_vector( 8 downto 0 );

  function get_table_value (table_index: table_index_type) return table_value_type;

end;

package body sine_package is

  function get_table_value (table_index: table_index_type) return table_value_type is
    variable table_value: table_value_type;
  begin
    case table_index is
      when 0 =>
        table_value := 1;
      when 1 =>
        table_value := 2;
      when 2 =>
        table_value := 4;
      when 3 =>
        table_value := 5;
      when 4 =>
        table_value := 7;
      when 5 =>
        table_value := 9;
      when 6 =>
        table_value := 10;
      when 7 =>
        table_value := 12;
      when 8 =>
        table_value := 13;
      when 9 =>
        table_value := 15;
      when 10 =>
        table_value := 16;
      when 11 =>
        table_value := 18;
      when 12 =>
        table_value := 20;
      when 13 =>
        table_value := 21;
      when 14 =>
        table_value := 23;
      when 15 =>
        table_value := 24;
      when 16 =>
        table_value := 26;
      when 17 =>
        table_value := 27;
      when 18 =>
        table_value := 29;
      when 19 =>
        table_value := 30;
      when 20 =>
        table_value := 32;
      when 21 =>
        table_value := 34;
      when 22 =>
        table_value := 35;
      when 23 =>
        table_value := 37;
      when 24 =>
        table_value := 38;
      when 25 =>
        table_value := 40;
      when 26 =>
        table_value := 41;
      when 27 =>
        table_value := 43;
      when 28 =>
        table_value := 44;
      when 29 =>
        table_value := 46;
      when 30 =>
        table_value := 47;
      when 31 =>
        table_value := 49;
      when 32 =>
        table_value := 51;
      when 33 =>
        table_value := 52;
      when 34 =>
        table_value := 54;
      when 35 =>
        table_value := 55;
      when 36 =>
        table_value := 57;
      when 37 =>
        table_value := 58;
      when 38 =>
        table_value := 60;
      when 39 =>
        table_value := 61;
      when 40 =>
        table_value := 63;
      when 41 =>
        table_value := 64;
      when 42 =>
        table_value := 66;
      when 43 =>
        table_value := 67;
      when 44 =>
        table_value := 69;
      when 45 =>
        table_value := 70;
      when 46 =>
        table_value := 72;
      when 47 =>
        table_value := 73;
      when 48 =>
        table_value := 75;
      when 49 =>
        table_value := 76;
      when 50 =>
        table_value := 78;
      when 51 =>
        table_value := 79;
      when 52 =>
        table_value := 81;
      when 53 =>
        table_value := 82;
      when 54 =>
        table_value := 84;
      when 55 =>
        table_value := 85;
      when 56 =>
        table_value := 87;
      when 57 =>
        table_value := 88;
      when 58 =>
        table_value := 90;
      when 59 =>
        table_value := 91;
      when 60 =>
        table_value := 93;
      when 61 =>
        table_value := 94;
      when 62 =>
        table_value := 95;
      when 63 =>
        table_value := 97;
      when 64 =>
        table_value := 98;
      when 65 =>
        table_value := 100;
      when 66 =>
        table_value := 101;
      when 67 =>
        table_value := 103;
      when 68 =>
        table_value := 104;
      when 69 =>
        table_value := 105;
      when 70 =>
        table_value := 107;
      when 71 =>
        table_value := 108;
      when 72 =>
        table_value := 110;
      when 73 =>
        table_value := 111;
      when 74 =>
        table_value := 113;
      when 75 =>
        table_value := 114;
      when 76 =>
        table_value := 115;
      when 77 =>
        table_value := 117;
      when 78 =>
        table_value := 118;
      when 79 =>
        table_value := 120;
      when 80 =>
        table_value := 121;
      when 81 =>
        table_value := 122;
      when 82 =>
        table_value := 124;
      when 83 =>
        table_value := 125;
      when 84 =>
        table_value := 126;
      when 85 =>
        table_value := 128;
      when 86 =>
        table_value := 129;
      when 87 =>
        table_value := 130;
      when 88 =>
        table_value := 132;
      when 89 =>
        table_value := 133;
      when 90 =>
        table_value := 134;
      when 91 =>
        table_value := 136;
      when 92 =>
        table_value := 137;
      when 93 =>
        table_value := 138;
      when 94 =>
        table_value := 140;
      when 95 =>
        table_value := 141;
      when 96 =>
        table_value := 142;
      when 97 =>
        table_value := 144;
      when 98 =>
        table_value := 145;
      when 99 =>
        table_value := 146;
      when 100 =>
        table_value := 147;
      when 101 =>
        table_value := 149;
      when 102 =>
        table_value := 150;
      when 103 =>
        table_value := 151;
      when 104 =>
        table_value := 153;
      when 105 =>
        table_value := 154;
      when 106 =>
        table_value := 155;
      when 107 =>
        table_value := 156;
      when 108 =>
        table_value := 158;
      when 109 =>
        table_value := 159;
      when 110 =>
        table_value := 160;
      when 111 =>
        table_value := 161;
      when 112 =>
        table_value := 162;
      when 113 =>
        table_value := 164;
      when 114 =>
        table_value := 165;
      when 115 =>
        table_value := 166;
      when 116 =>
        table_value := 167;
      when 117 =>
        table_value := 168;
      when 118 =>
        table_value := 170;
      when 119 =>
        table_value := 171;
      when 120 =>
        table_value := 172;
      when 121 =>
        table_value := 173;
      when 122 =>
        table_value := 174;
      when 123 =>
        table_value := 175;
      when 124 =>
        table_value := 176;
      when 125 =>
        table_value := 178;
      when 126 =>
        table_value := 179;
      when 127 =>
        table_value := 180;
      when 128 =>
        table_value := 181;
      when 129 =>
        table_value := 182;
      when 130 =>
        table_value := 183;
      when 131 =>
        table_value := 184;
      when 132 =>
        table_value := 185;
      when 133 =>
        table_value := 186;
      when 134 =>
        table_value := 187;
      when 135 =>
        table_value := 188;
      when 136 =>
        table_value := 189;
      when 137 =>
        table_value := 191;
      when 138 =>
        table_value := 192;
      when 139 =>
        table_value := 193;
      when 140 =>
        table_value := 194;
      when 141 =>
        table_value := 195;
      when 142 =>
        table_value := 196;
      when 143 =>
        table_value := 197;
      when 144 =>
        table_value := 198;
      when 145 =>
        table_value := 199;
      when 146 =>
        table_value := 200;
      when 147 =>
        table_value := 201;
      when 148 =>
        table_value := 202;
      when 149 =>
        table_value := 202;
      when 150 =>
        table_value := 203;
      when 151 =>
        table_value := 204;
      when 152 =>
        table_value := 205;
      when 153 =>
        table_value := 206;
      when 154 =>
        table_value := 207;
      when 155 =>
        table_value := 208;
      when 156 =>
        table_value := 209;
      when 157 =>
        table_value := 210;
      when 158 =>
        table_value := 211;
      when 159 =>
        table_value := 212;
      when 160 =>
        table_value := 212;
      when 161 =>
        table_value := 213;
      when 162 =>
        table_value := 214;
      when 163 =>
        table_value := 215;
      when 164 =>
        table_value := 216;
      when 165 =>
        table_value := 217;
      when 166 =>
        table_value := 218;
      when 167 =>
        table_value := 218;
      when 168 =>
        table_value := 219;
      when 169 =>
        table_value := 220;
      when 170 =>
        table_value := 221;
      when 171 =>
        table_value := 221;
      when 172 =>
        table_value := 222;
      when 173 =>
        table_value := 223;
      when 174 =>
        table_value := 224;
      when 175 =>
        table_value := 225;
      when 176 =>
        table_value := 225;
      when 177 =>
        table_value := 226;
      when 178 =>
        table_value := 227;
      when 179 =>
        table_value := 227;
      when 180 =>
        table_value := 228;
      when 181 =>
        table_value := 229;
      when 182 =>
        table_value := 230;
      when 183 =>
        table_value := 230;
      when 184 =>
        table_value := 231;
      when 185 =>
        table_value := 232;
      when 186 =>
        table_value := 232;
      when 187 =>
        table_value := 233;
      when 188 =>
        table_value := 233;
      when 189 =>
        table_value := 234;
      when 190 =>
        table_value := 235;
      when 191 =>
        table_value := 235;
      when 192 =>
        table_value := 236;
      when 193 =>
        table_value := 236;
      when 194 =>
        table_value := 237;
      when 195 =>
        table_value := 238;
      when 196 =>
        table_value := 238;
      when 197 =>
        table_value := 239;
      when 198 =>
        table_value := 239;
      when 199 =>
        table_value := 240;
      when 200 =>
        table_value := 240;
      when 201 =>
        table_value := 241;
      when 202 =>
        table_value := 241;
      when 203 =>
        table_value := 242;
      when 204 =>
        table_value := 242;
      when 205 =>
        table_value := 243;
      when 206 =>
        table_value := 243;
      when 207 =>
        table_value := 244;
      when 208 =>
        table_value := 244;
      when 209 =>
        table_value := 245;
      when 210 =>
        table_value := 245;
      when 211 =>
        table_value := 246;
      when 212 =>
        table_value := 246;
      when 213 =>
        table_value := 246;
      when 214 =>
        table_value := 247;
      when 215 =>
        table_value := 247;
      when 216 =>
        table_value := 248;
      when 217 =>
        table_value := 248;
      when 218 =>
        table_value := 248;
      when 219 =>
        table_value := 249;
      when 220 =>
        table_value := 249;
      when 221 =>
        table_value := 249;
      when 222 =>
        table_value := 250;
      when 223 =>
        table_value := 250;
      when 224 =>
        table_value := 250;
      when 225 =>
        table_value := 251;
      when 226 =>
        table_value := 251;
      when 227 =>
        table_value := 251;
      when 228 =>
        table_value := 251;
      when 229 =>
        table_value := 252;
      when 230 =>
        table_value := 252;
      when 231 =>
        table_value := 252;
      when 232 =>
        table_value := 252;
      when 233 =>
        table_value := 253;
      when 234 =>
        table_value := 253;
      when 235 =>
        table_value := 253;
      when 236 =>
        table_value := 253;
      when 237 =>
        table_value := 253;
      when 238 =>
        table_value := 254;
      when 239 =>
        table_value := 254;
      when 240 =>
        table_value := 254;
      when 241 =>
        table_value := 254;
      when 242 =>
        table_value := 254;
      when 243 =>
        table_value := 254;
      when 244 =>
        table_value := 254;
      when 245 =>
        table_value := 254;
      when 246 =>
        table_value := 255;
      when 247 =>
        table_value := 255;
      when 248 =>
        table_value := 255;
      when 249 =>
        table_value := 255;
      when 250 =>
        table_value := 255;
      when 251 =>
        table_value := 255;
      when 252 =>
        table_value := 255;
      when 253 =>
        table_value := 255;
      when 254 =>
        table_value := 255;
      when 255 =>
        table_value := 255;
    end case;
    return -127+table_value;
  end;

end;