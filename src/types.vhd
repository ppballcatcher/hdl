library ieee;
use ieee.std_logic_1164.all;

package types is
    type lv_arr_32_t is array(natural range <>) of std_logic_vector(31 downto 0);
    type lv_arr_2_t is array(natural range <>) of std_logic_vector(1 downto 0);
end types;

package body types is
end types;
