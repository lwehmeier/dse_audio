library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.typedefs.all;
use IEEE.NUMERIC_STD.ALL;

package soundgen_triangle_lut is
    subtype sample_rate_t is unsigned(sample_rate'length - 1 downto 0);

    type pcm_data_183_max_t is array(0 to 46) of pcm_data_t;
    constant lut_183_max: pcm_data_183_max_t := (to_signed(0,pcm_data_t'length),to_signed(712,pcm_data_t'length),to_signed(1424,pcm_data_t'length),to_signed(2136,pcm_data_t'length),to_signed(2849,pcm_data_t'length),to_signed(3561,pcm_data_t'length),to_signed(4273,pcm_data_t'length),to_signed(4986,pcm_data_t'length),to_signed(5698,pcm_data_t'length),to_signed(6410,pcm_data_t'length),to_signed(7123,pcm_data_t'length),to_signed(7835,pcm_data_t'length),to_signed(8547,pcm_data_t'length),to_signed(9260,pcm_data_t'length),to_signed(9972,pcm_data_t'length),to_signed(10684,pcm_data_t'length),to_signed(11397,pcm_data_t'length),to_signed(12109,pcm_data_t'length),to_signed(12821,pcm_data_t'length),to_signed(13534,pcm_data_t'length),to_signed(14246,pcm_data_t'length),to_signed(14958,pcm_data_t'length),to_signed(15671,pcm_data_t'length),to_signed(16383,pcm_data_t'length),to_signed(17095,pcm_data_t'length),to_signed(17808,pcm_data_t'length),to_signed(18520,pcm_data_t'length),to_signed(19232,pcm_data_t'length),to_signed(19945,pcm_data_t'length),to_signed(20657,pcm_data_t'length),to_signed(21369,pcm_data_t'length),to_signed(22082,pcm_data_t'length),to_signed(22794,pcm_data_t'length),to_signed(23506,pcm_data_t'length),to_signed(24219,pcm_data_t'length),to_signed(24931,pcm_data_t'length),to_signed(25643,pcm_data_t'length),to_signed(26356,pcm_data_t'length),to_signed(27068,pcm_data_t'length),to_signed(27780,pcm_data_t'length),to_signed(28493,pcm_data_t'length),to_signed(29205,pcm_data_t'length),to_signed(29917,pcm_data_t'length),to_signed(30630,pcm_data_t'length),to_signed(31342,pcm_data_t'length),to_signed(32054,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_183_min_t is array(0 to 46) of pcm_data_t;
    constant lut_183_min: pcm_data_183_min_t := (to_signed(0,pcm_data_t'length),to_signed(712,pcm_data_t'length),to_signed(1424,pcm_data_t'length),to_signed(2137,pcm_data_t'length),to_signed(2849,pcm_data_t'length),to_signed(3561,pcm_data_t'length),to_signed(4274,pcm_data_t'length),to_signed(4986,pcm_data_t'length),to_signed(5698,pcm_data_t'length),to_signed(6411,pcm_data_t'length),to_signed(7123,pcm_data_t'length),to_signed(7835,pcm_data_t'length),to_signed(8548,pcm_data_t'length),to_signed(9260,pcm_data_t'length),to_signed(9972,pcm_data_t'length),to_signed(10685,pcm_data_t'length),to_signed(11397,pcm_data_t'length),to_signed(12109,pcm_data_t'length),to_signed(12822,pcm_data_t'length),to_signed(13534,pcm_data_t'length),to_signed(14246,pcm_data_t'length),to_signed(14959,pcm_data_t'length),to_signed(15671,pcm_data_t'length),to_signed(16384,pcm_data_t'length),to_signed(17096,pcm_data_t'length),to_signed(17808,pcm_data_t'length),to_signed(18521,pcm_data_t'length),to_signed(19233,pcm_data_t'length),to_signed(19945,pcm_data_t'length),to_signed(20658,pcm_data_t'length),to_signed(21370,pcm_data_t'length),to_signed(22082,pcm_data_t'length),to_signed(22795,pcm_data_t'length),to_signed(23507,pcm_data_t'length),to_signed(24219,pcm_data_t'length),to_signed(24932,pcm_data_t'length),to_signed(25644,pcm_data_t'length),to_signed(26356,pcm_data_t'length),to_signed(27069,pcm_data_t'length),to_signed(27781,pcm_data_t'length),to_signed(28493,pcm_data_t'length),to_signed(29206,pcm_data_t'length),to_signed(29918,pcm_data_t'length),to_signed(30630,pcm_data_t'length),to_signed(31343,pcm_data_t'length),to_signed(32055,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_173_max_t is array(0 to 44) of pcm_data_t;
    constant lut_173_max: pcm_data_173_max_t := (to_signed(0,pcm_data_t'length),to_signed(744,pcm_data_t'length),to_signed(1489,pcm_data_t'length),to_signed(2234,pcm_data_t'length),to_signed(2978,pcm_data_t'length),to_signed(3723,pcm_data_t'length),to_signed(4468,pcm_data_t'length),to_signed(5212,pcm_data_t'length),to_signed(5957,pcm_data_t'length),to_signed(6702,pcm_data_t'length),to_signed(7447,pcm_data_t'length),to_signed(8191,pcm_data_t'length),to_signed(8936,pcm_data_t'length),to_signed(9681,pcm_data_t'length),to_signed(10425,pcm_data_t'length),to_signed(11170,pcm_data_t'length),to_signed(11915,pcm_data_t'length),to_signed(12659,pcm_data_t'length),to_signed(13404,pcm_data_t'length),to_signed(14149,pcm_data_t'length),to_signed(14894,pcm_data_t'length),to_signed(15638,pcm_data_t'length),to_signed(16383,pcm_data_t'length),to_signed(17128,pcm_data_t'length),to_signed(17872,pcm_data_t'length),to_signed(18617,pcm_data_t'length),to_signed(19362,pcm_data_t'length),to_signed(20107,pcm_data_t'length),to_signed(20851,pcm_data_t'length),to_signed(21596,pcm_data_t'length),to_signed(22341,pcm_data_t'length),to_signed(23085,pcm_data_t'length),to_signed(23830,pcm_data_t'length),to_signed(24575,pcm_data_t'length),to_signed(25319,pcm_data_t'length),to_signed(26064,pcm_data_t'length),to_signed(26809,pcm_data_t'length),to_signed(27554,pcm_data_t'length),to_signed(28298,pcm_data_t'length),to_signed(29043,pcm_data_t'length),to_signed(29788,pcm_data_t'length),to_signed(30532,pcm_data_t'length),to_signed(31277,pcm_data_t'length),to_signed(32022,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_173_min_t is array(0 to 44) of pcm_data_t;
    constant lut_173_min: pcm_data_173_min_t := (to_signed(0,pcm_data_t'length),to_signed(744,pcm_data_t'length),to_signed(1489,pcm_data_t'length),to_signed(2234,pcm_data_t'length),to_signed(2978,pcm_data_t'length),to_signed(3723,pcm_data_t'length),to_signed(4468,pcm_data_t'length),to_signed(5213,pcm_data_t'length),to_signed(5957,pcm_data_t'length),to_signed(6702,pcm_data_t'length),to_signed(7447,pcm_data_t'length),to_signed(8192,pcm_data_t'length),to_signed(8936,pcm_data_t'length),to_signed(9681,pcm_data_t'length),to_signed(10426,pcm_data_t'length),to_signed(11170,pcm_data_t'length),to_signed(11915,pcm_data_t'length),to_signed(12660,pcm_data_t'length),to_signed(13405,pcm_data_t'length),to_signed(14149,pcm_data_t'length),to_signed(14894,pcm_data_t'length),to_signed(15639,pcm_data_t'length),to_signed(16384,pcm_data_t'length),to_signed(17128,pcm_data_t'length),to_signed(17873,pcm_data_t'length),to_signed(18618,pcm_data_t'length),to_signed(19362,pcm_data_t'length),to_signed(20107,pcm_data_t'length),to_signed(20852,pcm_data_t'length),to_signed(21597,pcm_data_t'length),to_signed(22341,pcm_data_t'length),to_signed(23086,pcm_data_t'length),to_signed(23831,pcm_data_t'length),to_signed(24576,pcm_data_t'length),to_signed(25320,pcm_data_t'length),to_signed(26065,pcm_data_t'length),to_signed(26810,pcm_data_t'length),to_signed(27554,pcm_data_t'length),to_signed(28299,pcm_data_t'length),to_signed(29044,pcm_data_t'length),to_signed(29789,pcm_data_t'length),to_signed(30533,pcm_data_t'length),to_signed(31278,pcm_data_t'length),to_signed(32023,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_163_max_t is array(0 to 41) of pcm_data_t;
    constant lut_163_max: pcm_data_163_max_t := (to_signed(0,pcm_data_t'length),to_signed(799,pcm_data_t'length),to_signed(1598,pcm_data_t'length),to_signed(2397,pcm_data_t'length),to_signed(3196,pcm_data_t'length),to_signed(3995,pcm_data_t'length),to_signed(4795,pcm_data_t'length),to_signed(5594,pcm_data_t'length),to_signed(6393,pcm_data_t'length),to_signed(7192,pcm_data_t'length),to_signed(7991,pcm_data_t'length),to_signed(8791,pcm_data_t'length),to_signed(9590,pcm_data_t'length),to_signed(10389,pcm_data_t'length),to_signed(11188,pcm_data_t'length),to_signed(11987,pcm_data_t'length),to_signed(12787,pcm_data_t'length),to_signed(13586,pcm_data_t'length),to_signed(14385,pcm_data_t'length),to_signed(15184,pcm_data_t'length),to_signed(15983,pcm_data_t'length),to_signed(16783,pcm_data_t'length),to_signed(17582,pcm_data_t'length),to_signed(18381,pcm_data_t'length),to_signed(19180,pcm_data_t'length),to_signed(19979,pcm_data_t'length),to_signed(20779,pcm_data_t'length),to_signed(21578,pcm_data_t'length),to_signed(22377,pcm_data_t'length),to_signed(23176,pcm_data_t'length),to_signed(23975,pcm_data_t'length),to_signed(24775,pcm_data_t'length),to_signed(25574,pcm_data_t'length),to_signed(26373,pcm_data_t'length),to_signed(27172,pcm_data_t'length),to_signed(27971,pcm_data_t'length),to_signed(28771,pcm_data_t'length),to_signed(29570,pcm_data_t'length),to_signed(30369,pcm_data_t'length),to_signed(31168,pcm_data_t'length),to_signed(31967,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_163_min_t is array(0 to 41) of pcm_data_t;
    constant lut_163_min: pcm_data_163_min_t := (to_signed(0,pcm_data_t'length),to_signed(799,pcm_data_t'length),to_signed(1598,pcm_data_t'length),to_signed(2397,pcm_data_t'length),to_signed(3196,pcm_data_t'length),to_signed(3996,pcm_data_t'length),to_signed(4795,pcm_data_t'length),to_signed(5594,pcm_data_t'length),to_signed(6393,pcm_data_t'length),to_signed(7192,pcm_data_t'length),to_signed(7992,pcm_data_t'length),to_signed(8791,pcm_data_t'length),to_signed(9590,pcm_data_t'length),to_signed(10389,pcm_data_t'length),to_signed(11189,pcm_data_t'length),to_signed(11988,pcm_data_t'length),to_signed(12787,pcm_data_t'length),to_signed(13586,pcm_data_t'length),to_signed(14385,pcm_data_t'length),to_signed(15185,pcm_data_t'length),to_signed(15984,pcm_data_t'length),to_signed(16783,pcm_data_t'length),to_signed(17582,pcm_data_t'length),to_signed(18382,pcm_data_t'length),to_signed(19181,pcm_data_t'length),to_signed(19980,pcm_data_t'length),to_signed(20779,pcm_data_t'length),to_signed(21578,pcm_data_t'length),to_signed(22378,pcm_data_t'length),to_signed(23177,pcm_data_t'length),to_signed(23976,pcm_data_t'length),to_signed(24775,pcm_data_t'length),to_signed(25575,pcm_data_t'length),to_signed(26374,pcm_data_t'length),to_signed(27173,pcm_data_t'length),to_signed(27972,pcm_data_t'length),to_signed(28771,pcm_data_t'length),to_signed(29571,pcm_data_t'length),to_signed(30370,pcm_data_t'length),to_signed(31169,pcm_data_t'length),to_signed(31968,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_154_max_t is array(0 to 39) of pcm_data_t;
    constant lut_154_max: pcm_data_154_max_t := (to_signed(0,pcm_data_t'length),to_signed(840,pcm_data_t'length),to_signed(1680,pcm_data_t'length),to_signed(2520,pcm_data_t'length),to_signed(3360,pcm_data_t'length),to_signed(4200,pcm_data_t'length),to_signed(5041,pcm_data_t'length),to_signed(5881,pcm_data_t'length),to_signed(6721,pcm_data_t'length),to_signed(7561,pcm_data_t'length),to_signed(8401,pcm_data_t'length),to_signed(9241,pcm_data_t'length),to_signed(10082,pcm_data_t'length),to_signed(10922,pcm_data_t'length),to_signed(11762,pcm_data_t'length),to_signed(12602,pcm_data_t'length),to_signed(13442,pcm_data_t'length),to_signed(14283,pcm_data_t'length),to_signed(15123,pcm_data_t'length),to_signed(15963,pcm_data_t'length),to_signed(16803,pcm_data_t'length),to_signed(17643,pcm_data_t'length),to_signed(18483,pcm_data_t'length),to_signed(19324,pcm_data_t'length),to_signed(20164,pcm_data_t'length),to_signed(21004,pcm_data_t'length),to_signed(21844,pcm_data_t'length),to_signed(22684,pcm_data_t'length),to_signed(23525,pcm_data_t'length),to_signed(24365,pcm_data_t'length),to_signed(25205,pcm_data_t'length),to_signed(26045,pcm_data_t'length),to_signed(26885,pcm_data_t'length),to_signed(27725,pcm_data_t'length),to_signed(28566,pcm_data_t'length),to_signed(29406,pcm_data_t'length),to_signed(30246,pcm_data_t'length),to_signed(31086,pcm_data_t'length),to_signed(31926,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_154_min_t is array(0 to 39) of pcm_data_t;
    constant lut_154_min: pcm_data_154_min_t := (to_signed(0,pcm_data_t'length),to_signed(840,pcm_data_t'length),to_signed(1680,pcm_data_t'length),to_signed(2520,pcm_data_t'length),to_signed(3360,pcm_data_t'length),to_signed(4201,pcm_data_t'length),to_signed(5041,pcm_data_t'length),to_signed(5881,pcm_data_t'length),to_signed(6721,pcm_data_t'length),to_signed(7561,pcm_data_t'length),to_signed(8402,pcm_data_t'length),to_signed(9242,pcm_data_t'length),to_signed(10082,pcm_data_t'length),to_signed(10922,pcm_data_t'length),to_signed(11762,pcm_data_t'length),to_signed(12603,pcm_data_t'length),to_signed(13443,pcm_data_t'length),to_signed(14283,pcm_data_t'length),to_signed(15123,pcm_data_t'length),to_signed(15963,pcm_data_t'length),to_signed(16804,pcm_data_t'length),to_signed(17644,pcm_data_t'length),to_signed(18484,pcm_data_t'length),to_signed(19324,pcm_data_t'length),to_signed(20164,pcm_data_t'length),to_signed(21005,pcm_data_t'length),to_signed(21845,pcm_data_t'length),to_signed(22685,pcm_data_t'length),to_signed(23525,pcm_data_t'length),to_signed(24365,pcm_data_t'length),to_signed(25206,pcm_data_t'length),to_signed(26046,pcm_data_t'length),to_signed(26886,pcm_data_t'length),to_signed(27726,pcm_data_t'length),to_signed(28566,pcm_data_t'length),to_signed(29407,pcm_data_t'length),to_signed(30247,pcm_data_t'length),to_signed(31087,pcm_data_t'length),to_signed(31927,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_146_max_t is array(0 to 37) of pcm_data_t;
    constant lut_146_max: pcm_data_146_max_t := (to_signed(0,pcm_data_t'length),to_signed(885,pcm_data_t'length),to_signed(1771,pcm_data_t'length),to_signed(2656,pcm_data_t'length),to_signed(3542,pcm_data_t'length),to_signed(4427,pcm_data_t'length),to_signed(5313,pcm_data_t'length),to_signed(6199,pcm_data_t'length),to_signed(7084,pcm_data_t'length),to_signed(7970,pcm_data_t'length),to_signed(8855,pcm_data_t'length),to_signed(9741,pcm_data_t'length),to_signed(10627,pcm_data_t'length),to_signed(11512,pcm_data_t'length),to_signed(12398,pcm_data_t'length),to_signed(13283,pcm_data_t'length),to_signed(14169,pcm_data_t'length),to_signed(15055,pcm_data_t'length),to_signed(15940,pcm_data_t'length),to_signed(16826,pcm_data_t'length),to_signed(17711,pcm_data_t'length),to_signed(18597,pcm_data_t'length),to_signed(19483,pcm_data_t'length),to_signed(20368,pcm_data_t'length),to_signed(21254,pcm_data_t'length),to_signed(22139,pcm_data_t'length),to_signed(23025,pcm_data_t'length),to_signed(23911,pcm_data_t'length),to_signed(24796,pcm_data_t'length),to_signed(25682,pcm_data_t'length),to_signed(26567,pcm_data_t'length),to_signed(27453,pcm_data_t'length),to_signed(28339,pcm_data_t'length),to_signed(29224,pcm_data_t'length),to_signed(30110,pcm_data_t'length),to_signed(30995,pcm_data_t'length),to_signed(31881,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_146_min_t is array(0 to 37) of pcm_data_t;
    constant lut_146_min: pcm_data_146_min_t := (to_signed(0,pcm_data_t'length),to_signed(885,pcm_data_t'length),to_signed(1771,pcm_data_t'length),to_signed(2656,pcm_data_t'length),to_signed(3542,pcm_data_t'length),to_signed(4428,pcm_data_t'length),to_signed(5313,pcm_data_t'length),to_signed(6199,pcm_data_t'length),to_signed(7084,pcm_data_t'length),to_signed(7970,pcm_data_t'length),to_signed(8856,pcm_data_t'length),to_signed(9741,pcm_data_t'length),to_signed(10627,pcm_data_t'length),to_signed(11513,pcm_data_t'length),to_signed(12398,pcm_data_t'length),to_signed(13284,pcm_data_t'length),to_signed(14169,pcm_data_t'length),to_signed(15055,pcm_data_t'length),to_signed(15941,pcm_data_t'length),to_signed(16826,pcm_data_t'length),to_signed(17712,pcm_data_t'length),to_signed(18598,pcm_data_t'length),to_signed(19483,pcm_data_t'length),to_signed(20369,pcm_data_t'length),to_signed(21254,pcm_data_t'length),to_signed(22140,pcm_data_t'length),to_signed(23026,pcm_data_t'length),to_signed(23911,pcm_data_t'length),to_signed(24797,pcm_data_t'length),to_signed(25683,pcm_data_t'length),to_signed(26568,pcm_data_t'length),to_signed(27454,pcm_data_t'length),to_signed(28339,pcm_data_t'length),to_signed(29225,pcm_data_t'length),to_signed(30111,pcm_data_t'length),to_signed(30996,pcm_data_t'length),to_signed(31882,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_137_max_t is array(0 to 35) of pcm_data_t;
    constant lut_137_max: pcm_data_137_max_t := (to_signed(0,pcm_data_t'length),to_signed(936,pcm_data_t'length),to_signed(1872,pcm_data_t'length),to_signed(2808,pcm_data_t'length),to_signed(3744,pcm_data_t'length),to_signed(4681,pcm_data_t'length),to_signed(5617,pcm_data_t'length),to_signed(6553,pcm_data_t'length),to_signed(7489,pcm_data_t'length),to_signed(8425,pcm_data_t'length),to_signed(9362,pcm_data_t'length),to_signed(10298,pcm_data_t'length),to_signed(11234,pcm_data_t'length),to_signed(12170,pcm_data_t'length),to_signed(13106,pcm_data_t'length),to_signed(14043,pcm_data_t'length),to_signed(14979,pcm_data_t'length),to_signed(15915,pcm_data_t'length),to_signed(16851,pcm_data_t'length),to_signed(17787,pcm_data_t'length),to_signed(18724,pcm_data_t'length),to_signed(19660,pcm_data_t'length),to_signed(20596,pcm_data_t'length),to_signed(21532,pcm_data_t'length),to_signed(22468,pcm_data_t'length),to_signed(23405,pcm_data_t'length),to_signed(24341,pcm_data_t'length),to_signed(25277,pcm_data_t'length),to_signed(26213,pcm_data_t'length),to_signed(27149,pcm_data_t'length),to_signed(28086,pcm_data_t'length),to_signed(29022,pcm_data_t'length),to_signed(29958,pcm_data_t'length),to_signed(30894,pcm_data_t'length),to_signed(31830,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_137_min_t is array(0 to 35) of pcm_data_t;
    constant lut_137_min: pcm_data_137_min_t := (to_signed(0,pcm_data_t'length),to_signed(936,pcm_data_t'length),to_signed(1872,pcm_data_t'length),to_signed(2808,pcm_data_t'length),to_signed(3744,pcm_data_t'length),to_signed(4681,pcm_data_t'length),to_signed(5617,pcm_data_t'length),to_signed(6553,pcm_data_t'length),to_signed(7489,pcm_data_t'length),to_signed(8426,pcm_data_t'length),to_signed(9362,pcm_data_t'length),to_signed(10298,pcm_data_t'length),to_signed(11234,pcm_data_t'length),to_signed(12170,pcm_data_t'length),to_signed(13107,pcm_data_t'length),to_signed(14043,pcm_data_t'length),to_signed(14979,pcm_data_t'length),to_signed(15915,pcm_data_t'length),to_signed(16852,pcm_data_t'length),to_signed(17788,pcm_data_t'length),to_signed(18724,pcm_data_t'length),to_signed(19660,pcm_data_t'length),to_signed(20597,pcm_data_t'length),to_signed(21533,pcm_data_t'length),to_signed(22469,pcm_data_t'length),to_signed(23405,pcm_data_t'length),to_signed(24341,pcm_data_t'length),to_signed(25278,pcm_data_t'length),to_signed(26214,pcm_data_t'length),to_signed(27150,pcm_data_t'length),to_signed(28086,pcm_data_t'length),to_signed(29023,pcm_data_t'length),to_signed(29959,pcm_data_t'length),to_signed(30895,pcm_data_t'length),to_signed(31831,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_130_max_t is array(0 to 33) of pcm_data_t;
    constant lut_130_max: pcm_data_130_max_t := (to_signed(0,pcm_data_t'length),to_signed(992,pcm_data_t'length),to_signed(1985,pcm_data_t'length),to_signed(2978,pcm_data_t'length),to_signed(3971,pcm_data_t'length),to_signed(4964,pcm_data_t'length),to_signed(5957,pcm_data_t'length),to_signed(6950,pcm_data_t'length),to_signed(7943,pcm_data_t'length),to_signed(8936,pcm_data_t'length),to_signed(9929,pcm_data_t'length),to_signed(10922,pcm_data_t'length),to_signed(11915,pcm_data_t'length),to_signed(12908,pcm_data_t'length),to_signed(13901,pcm_data_t'length),to_signed(14894,pcm_data_t'length),to_signed(15887,pcm_data_t'length),to_signed(16879,pcm_data_t'length),to_signed(17872,pcm_data_t'length),to_signed(18865,pcm_data_t'length),to_signed(19858,pcm_data_t'length),to_signed(20851,pcm_data_t'length),to_signed(21844,pcm_data_t'length),to_signed(22837,pcm_data_t'length),to_signed(23830,pcm_data_t'length),to_signed(24823,pcm_data_t'length),to_signed(25816,pcm_data_t'length),to_signed(26809,pcm_data_t'length),to_signed(27802,pcm_data_t'length),to_signed(28795,pcm_data_t'length),to_signed(29788,pcm_data_t'length),to_signed(30781,pcm_data_t'length),to_signed(31774,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_130_min_t is array(0 to 33) of pcm_data_t;
    constant lut_130_min: pcm_data_130_min_t := (to_signed(0,pcm_data_t'length),to_signed(992,pcm_data_t'length),to_signed(1985,pcm_data_t'length),to_signed(2978,pcm_data_t'length),to_signed(3971,pcm_data_t'length),to_signed(4964,pcm_data_t'length),to_signed(5957,pcm_data_t'length),to_signed(6950,pcm_data_t'length),to_signed(7943,pcm_data_t'length),to_signed(8936,pcm_data_t'length),to_signed(9929,pcm_data_t'length),to_signed(10922,pcm_data_t'length),to_signed(11915,pcm_data_t'length),to_signed(12908,pcm_data_t'length),to_signed(13901,pcm_data_t'length),to_signed(14894,pcm_data_t'length),to_signed(15887,pcm_data_t'length),to_signed(16880,pcm_data_t'length),to_signed(17873,pcm_data_t'length),to_signed(18866,pcm_data_t'length),to_signed(19859,pcm_data_t'length),to_signed(20852,pcm_data_t'length),to_signed(21845,pcm_data_t'length),to_signed(22838,pcm_data_t'length),to_signed(23831,pcm_data_t'length),to_signed(24824,pcm_data_t'length),to_signed(25817,pcm_data_t'length),to_signed(26810,pcm_data_t'length),to_signed(27803,pcm_data_t'length),to_signed(28796,pcm_data_t'length),to_signed(29789,pcm_data_t'length),to_signed(30782,pcm_data_t'length),to_signed(31775,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_122_max_t is array(0 to 31) of pcm_data_t;
    constant lut_122_max: pcm_data_122_max_t := (to_signed(0,pcm_data_t'length),to_signed(1057,pcm_data_t'length),to_signed(2114,pcm_data_t'length),to_signed(3171,pcm_data_t'length),to_signed(4228,pcm_data_t'length),to_signed(5285,pcm_data_t'length),to_signed(6342,pcm_data_t'length),to_signed(7399,pcm_data_t'length),to_signed(8456,pcm_data_t'length),to_signed(9513,pcm_data_t'length),to_signed(10570,pcm_data_t'length),to_signed(11627,pcm_data_t'length),to_signed(12684,pcm_data_t'length),to_signed(13741,pcm_data_t'length),to_signed(14798,pcm_data_t'length),to_signed(15855,pcm_data_t'length),to_signed(16912,pcm_data_t'length),to_signed(17969,pcm_data_t'length),to_signed(19026,pcm_data_t'length),to_signed(20083,pcm_data_t'length),to_signed(21140,pcm_data_t'length),to_signed(22197,pcm_data_t'length),to_signed(23254,pcm_data_t'length),to_signed(24311,pcm_data_t'length),to_signed(25368,pcm_data_t'length),to_signed(26425,pcm_data_t'length),to_signed(27482,pcm_data_t'length),to_signed(28539,pcm_data_t'length),to_signed(29596,pcm_data_t'length),to_signed(30653,pcm_data_t'length),to_signed(31710,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_122_min_t is array(0 to 31) of pcm_data_t;
    constant lut_122_min: pcm_data_122_min_t := (to_signed(0,pcm_data_t'length),to_signed(1057,pcm_data_t'length),to_signed(2114,pcm_data_t'length),to_signed(3171,pcm_data_t'length),to_signed(4228,pcm_data_t'length),to_signed(5285,pcm_data_t'length),to_signed(6342,pcm_data_t'length),to_signed(7399,pcm_data_t'length),to_signed(8456,pcm_data_t'length),to_signed(9513,pcm_data_t'length),to_signed(10570,pcm_data_t'length),to_signed(11627,pcm_data_t'length),to_signed(12684,pcm_data_t'length),to_signed(13741,pcm_data_t'length),to_signed(14798,pcm_data_t'length),to_signed(15855,pcm_data_t'length),to_signed(16912,pcm_data_t'length),to_signed(17969,pcm_data_t'length),to_signed(19026,pcm_data_t'length),to_signed(20083,pcm_data_t'length),to_signed(21140,pcm_data_t'length),to_signed(22197,pcm_data_t'length),to_signed(23254,pcm_data_t'length),to_signed(24311,pcm_data_t'length),to_signed(25368,pcm_data_t'length),to_signed(26425,pcm_data_t'length),to_signed(27482,pcm_data_t'length),to_signed(28539,pcm_data_t'length),to_signed(29596,pcm_data_t'length),to_signed(30653,pcm_data_t'length),to_signed(31710,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_116_max_t is array(0 to 30) of pcm_data_t;
    constant lut_116_max: pcm_data_116_max_t := (to_signed(0,pcm_data_t'length),to_signed(1092,pcm_data_t'length),to_signed(2184,pcm_data_t'length),to_signed(3276,pcm_data_t'length),to_signed(4368,pcm_data_t'length),to_signed(5461,pcm_data_t'length),to_signed(6553,pcm_data_t'length),to_signed(7645,pcm_data_t'length),to_signed(8737,pcm_data_t'length),to_signed(9830,pcm_data_t'length),to_signed(10922,pcm_data_t'length),to_signed(12014,pcm_data_t'length),to_signed(13106,pcm_data_t'length),to_signed(14199,pcm_data_t'length),to_signed(15291,pcm_data_t'length),to_signed(16383,pcm_data_t'length),to_signed(17475,pcm_data_t'length),to_signed(18567,pcm_data_t'length),to_signed(19660,pcm_data_t'length),to_signed(20752,pcm_data_t'length),to_signed(21844,pcm_data_t'length),to_signed(22936,pcm_data_t'length),to_signed(24029,pcm_data_t'length),to_signed(25121,pcm_data_t'length),to_signed(26213,pcm_data_t'length),to_signed(27305,pcm_data_t'length),to_signed(28398,pcm_data_t'length),to_signed(29490,pcm_data_t'length),to_signed(30582,pcm_data_t'length),to_signed(31674,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_116_min_t is array(0 to 30) of pcm_data_t;
    constant lut_116_min: pcm_data_116_min_t := (to_signed(0,pcm_data_t'length),to_signed(1092,pcm_data_t'length),to_signed(2184,pcm_data_t'length),to_signed(3276,pcm_data_t'length),to_signed(4369,pcm_data_t'length),to_signed(5461,pcm_data_t'length),to_signed(6553,pcm_data_t'length),to_signed(7645,pcm_data_t'length),to_signed(8738,pcm_data_t'length),to_signed(9830,pcm_data_t'length),to_signed(10922,pcm_data_t'length),to_signed(12014,pcm_data_t'length),to_signed(13107,pcm_data_t'length),to_signed(14199,pcm_data_t'length),to_signed(15291,pcm_data_t'length),to_signed(16384,pcm_data_t'length),to_signed(17476,pcm_data_t'length),to_signed(18568,pcm_data_t'length),to_signed(19660,pcm_data_t'length),to_signed(20753,pcm_data_t'length),to_signed(21845,pcm_data_t'length),to_signed(22937,pcm_data_t'length),to_signed(24029,pcm_data_t'length),to_signed(25122,pcm_data_t'length),to_signed(26214,pcm_data_t'length),to_signed(27306,pcm_data_t'length),to_signed(28398,pcm_data_t'length),to_signed(29491,pcm_data_t'length),to_signed(30583,pcm_data_t'length),to_signed(31675,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_109_max_t is array(0 to 28) of pcm_data_t;
    constant lut_109_max: pcm_data_109_max_t := (to_signed(0,pcm_data_t'length),to_signed(1170,pcm_data_t'length),to_signed(2340,pcm_data_t'length),to_signed(3510,pcm_data_t'length),to_signed(4681,pcm_data_t'length),to_signed(5851,pcm_data_t'length),to_signed(7021,pcm_data_t'length),to_signed(8191,pcm_data_t'length),to_signed(9362,pcm_data_t'length),to_signed(10532,pcm_data_t'length),to_signed(11702,pcm_data_t'length),to_signed(12872,pcm_data_t'length),to_signed(14043,pcm_data_t'length),to_signed(15213,pcm_data_t'length),to_signed(16383,pcm_data_t'length),to_signed(17553,pcm_data_t'length),to_signed(18724,pcm_data_t'length),to_signed(19894,pcm_data_t'length),to_signed(21064,pcm_data_t'length),to_signed(22234,pcm_data_t'length),to_signed(23405,pcm_data_t'length),to_signed(24575,pcm_data_t'length),to_signed(25745,pcm_data_t'length),to_signed(26915,pcm_data_t'length),to_signed(28086,pcm_data_t'length),to_signed(29256,pcm_data_t'length),to_signed(30426,pcm_data_t'length),to_signed(31596,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_109_min_t is array(0 to 28) of pcm_data_t;
    constant lut_109_min: pcm_data_109_min_t := (to_signed(0,pcm_data_t'length),to_signed(1170,pcm_data_t'length),to_signed(2340,pcm_data_t'length),to_signed(3510,pcm_data_t'length),to_signed(4681,pcm_data_t'length),to_signed(5851,pcm_data_t'length),to_signed(7021,pcm_data_t'length),to_signed(8192,pcm_data_t'length),to_signed(9362,pcm_data_t'length),to_signed(10532,pcm_data_t'length),to_signed(11702,pcm_data_t'length),to_signed(12873,pcm_data_t'length),to_signed(14043,pcm_data_t'length),to_signed(15213,pcm_data_t'length),to_signed(16384,pcm_data_t'length),to_signed(17554,pcm_data_t'length),to_signed(18724,pcm_data_t'length),to_signed(19894,pcm_data_t'length),to_signed(21065,pcm_data_t'length),to_signed(22235,pcm_data_t'length),to_signed(23405,pcm_data_t'length),to_signed(24576,pcm_data_t'length),to_signed(25746,pcm_data_t'length),to_signed(26916,pcm_data_t'length),to_signed(28086,pcm_data_t'length),to_signed(29257,pcm_data_t'length),to_signed(30427,pcm_data_t'length),to_signed(31597,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_103_max_t is array(0 to 26) of pcm_data_t;
    constant lut_103_max: pcm_data_103_max_t := (to_signed(0,pcm_data_t'length),to_signed(1260,pcm_data_t'length),to_signed(2520,pcm_data_t'length),to_signed(3780,pcm_data_t'length),to_signed(5041,pcm_data_t'length),to_signed(6301,pcm_data_t'length),to_signed(7561,pcm_data_t'length),to_signed(8821,pcm_data_t'length),to_signed(10082,pcm_data_t'length),to_signed(11342,pcm_data_t'length),to_signed(12602,pcm_data_t'length),to_signed(13862,pcm_data_t'length),to_signed(15123,pcm_data_t'length),to_signed(16383,pcm_data_t'length),to_signed(17643,pcm_data_t'length),to_signed(18904,pcm_data_t'length),to_signed(20164,pcm_data_t'length),to_signed(21424,pcm_data_t'length),to_signed(22684,pcm_data_t'length),to_signed(23945,pcm_data_t'length),to_signed(25205,pcm_data_t'length),to_signed(26465,pcm_data_t'length),to_signed(27725,pcm_data_t'length),to_signed(28986,pcm_data_t'length),to_signed(30246,pcm_data_t'length),to_signed(31506,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_103_min_t is array(0 to 26) of pcm_data_t;
    constant lut_103_min: pcm_data_103_min_t := (to_signed(0,pcm_data_t'length),to_signed(1260,pcm_data_t'length),to_signed(2520,pcm_data_t'length),to_signed(3780,pcm_data_t'length),to_signed(5041,pcm_data_t'length),to_signed(6301,pcm_data_t'length),to_signed(7561,pcm_data_t'length),to_signed(8822,pcm_data_t'length),to_signed(10082,pcm_data_t'length),to_signed(11342,pcm_data_t'length),to_signed(12603,pcm_data_t'length),to_signed(13863,pcm_data_t'length),to_signed(15123,pcm_data_t'length),to_signed(16384,pcm_data_t'length),to_signed(17644,pcm_data_t'length),to_signed(18904,pcm_data_t'length),to_signed(20164,pcm_data_t'length),to_signed(21425,pcm_data_t'length),to_signed(22685,pcm_data_t'length),to_signed(23945,pcm_data_t'length),to_signed(25206,pcm_data_t'length),to_signed(26466,pcm_data_t'length),to_signed(27726,pcm_data_t'length),to_signed(28987,pcm_data_t'length),to_signed(30247,pcm_data_t'length),to_signed(31507,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    type pcm_data_97_max_t is array(0 to 25) of pcm_data_t;
    constant lut_97_max: pcm_data_97_max_t := (to_signed(0,pcm_data_t'length),to_signed(1310,pcm_data_t'length),to_signed(2621,pcm_data_t'length),to_signed(3932,pcm_data_t'length),to_signed(5242,pcm_data_t'length),to_signed(6553,pcm_data_t'length),to_signed(7864,pcm_data_t'length),to_signed(9174,pcm_data_t'length),to_signed(10485,pcm_data_t'length),to_signed(11796,pcm_data_t'length),to_signed(13106,pcm_data_t'length),to_signed(14417,pcm_data_t'length),to_signed(15728,pcm_data_t'length),to_signed(17038,pcm_data_t'length),to_signed(18349,pcm_data_t'length),to_signed(19660,pcm_data_t'length),to_signed(20970,pcm_data_t'length),to_signed(22281,pcm_data_t'length),to_signed(23592,pcm_data_t'length),to_signed(24902,pcm_data_t'length),to_signed(26213,pcm_data_t'length),to_signed(27524,pcm_data_t'length),to_signed(28834,pcm_data_t'length),to_signed(30145,pcm_data_t'length),to_signed(31456,pcm_data_t'length),to_signed(32767,pcm_data_t'length));

    type pcm_data_97_min_t is array(0 to 25) of pcm_data_t;
    constant lut_97_min: pcm_data_97_min_t := (to_signed(0,pcm_data_t'length),to_signed(1310,pcm_data_t'length),to_signed(2621,pcm_data_t'length),to_signed(3932,pcm_data_t'length),to_signed(5242,pcm_data_t'length),to_signed(6553,pcm_data_t'length),to_signed(7864,pcm_data_t'length),to_signed(9175,pcm_data_t'length),to_signed(10485,pcm_data_t'length),to_signed(11796,pcm_data_t'length),to_signed(13107,pcm_data_t'length),to_signed(14417,pcm_data_t'length),to_signed(15728,pcm_data_t'length),to_signed(17039,pcm_data_t'length),to_signed(18350,pcm_data_t'length),to_signed(19660,pcm_data_t'length),to_signed(20971,pcm_data_t'length),to_signed(22282,pcm_data_t'length),to_signed(23592,pcm_data_t'length),to_signed(24903,pcm_data_t'length),to_signed(26214,pcm_data_t'length),to_signed(27525,pcm_data_t'length),to_signed(28835,pcm_data_t'length),to_signed(30146,pcm_data_t'length),to_signed(31457,pcm_data_t'length),to_signed(32768,pcm_data_t'length));

    function counter_over_period_max(counter: sample_rate_t; period: sample_rate_t) return pcm_data_t;
    function counter_over_period_min(counter: sample_rate_t; period: sample_rate_t) return pcm_data_t;
end package soundgen_triangle_lut;

package body soundgen_triangle_lut is
    function counter_over_period_max(counter: sample_rate_t; period: sample_rate_t) return pcm_data_t is
    begin
        case to_integer(period) is
            when 183 => return lut_183_max(to_integer(counter));
            when 173 => return lut_173_max(to_integer(counter));
            when 163 => return lut_163_max(to_integer(counter));
            when 154 => return lut_154_max(to_integer(counter));
            when 146 => return lut_146_max(to_integer(counter));
            when 137 => return lut_137_max(to_integer(counter));
            when 130 => return lut_130_max(to_integer(counter));
            when 122 => return lut_122_max(to_integer(counter));
            when 116 => return lut_116_max(to_integer(counter));
            when 109 => return lut_109_max(to_integer(counter));
            when 103 => return lut_103_max(to_integer(counter));
            when 97 => return lut_97_max(to_integer(counter));
            when others => return to_signed(0, pcm_data_t'length);
        end case;
    end counter_over_period_max;

    function counter_over_period_min(counter: sample_rate_t; period: sample_rate_t) return pcm_data_t is
    begin
        case to_integer(period) is
            when 183 => return lut_183_min(to_integer(counter));
            when 173 => return lut_173_min(to_integer(counter));
            when 163 => return lut_163_min(to_integer(counter));
            when 154 => return lut_154_min(to_integer(counter));
            when 146 => return lut_146_min(to_integer(counter));
            when 137 => return lut_137_min(to_integer(counter));
            when 130 => return lut_130_min(to_integer(counter));
            when 122 => return lut_122_min(to_integer(counter));
            when 116 => return lut_116_min(to_integer(counter));
            when 109 => return lut_109_min(to_integer(counter));
            when 103 => return lut_103_min(to_integer(counter));
            when 97 => return lut_97_min(to_integer(counter));
            when others => return to_signed(0, pcm_data_t'length);
        end case;
    end counter_over_period_min;
end package body soundgen_triangle_lut;