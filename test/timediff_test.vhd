library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timediff_test is
end timediff_test;

architecture behavior of timediff_test is
    component timediff_t
        port(
            clk_i           : in std_logic;
            reset_i         : in std_logic;
            piezos_i        : in std_logic_vector(3 downto 0);
            timing_select_i : in std_logic_vector(1 downto 0);
            timing_o        : out std_logic_vector(31 downto 0);
            timings_ready_o : out std_logic);
    end component;

    signal clk : std_logic;
    signal piezos : std_logic_vector(3 downto 0) := (others => '0');
    constant clk_in_period : time := 20 ns;

begin
    uut: timediff_t
    port map(
        clk_i => clk,
        reset_i => '0',
        piezos_i => piezos,
        timing_select_i => (others => '0'),
        timing_o => open,
        timings_ready_o => open);

    clk_in_process : process
    begin
        clk <= '0';
        wait for clk_in_period/2;
        clk <= '1';
        wait for clk_in_period/2;
    end process;

    input : process
    begin
        for i in 0 to 3 loop
            wait for 150 ns;
            piezos(i) <= not piezos(i);
        end loop;
    end process;
end;
