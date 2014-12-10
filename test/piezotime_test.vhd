library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;

entity piezotime_test is
end piezotime_test;

architecture behavior of piezotime_test is
    component piezotime_t is
    port (
        clk           : in std_logic;
        reset         : in std_logic; -- active high
        piezos        : in std_logic_vector(3 downto 0);
        timings       : out lv_arr_32_t(3 downto 0);
        timings_ready : out std_logic);
    end component;

    signal clk : std_logic;
    signal reset : std_logic := '1';
    signal piezos : std_logic_vector(3 downto 0) := (others => '0');
    signal timings_ready : std_logic := '0';
    signal timings : lv_arr_32_t(3 downto 0);
    constant clk_in_period : time := 20 ns;

begin
    uut: piezotime_t
    port map (
        clk => clk,
        reset => reset,
        piezos => piezos,
        timings => timings,
        timings_ready => timings_ready);

    clk_proc : process
    begin
        clk <= '0';
        wait for clk_in_period/2;
        clk <= '1';
        wait for clk_in_period/2;
    end process;

    input_proc : process
    begin
        for i in 0 to 3 loop
            wait for 170 ns;
            piezos(i) <= not piezos(i);
        end loop;
    end process;

    reset_proc : process
    begin
        reset <= '1';
        wait for 400 ns;
        reset <= '0';
        wait for 1000 ns;
        reset <= '1';
        wait for 400 ns;
        reset <= '0';
        wait;
    end process;

end;
