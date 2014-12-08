library ieee;
use ieee.std_logic_1164.all;

entity piezo_in_test is
end piezo_in_test;

architecture behavior of piezo_in_test is
    component piezo_in_t
        generic(
            clk_in_freq : integer := 50000000);
        port(
            clk_i       : in std_logic;
            piezo_i     : in std_logic;
            out_o       : out std_logic);
    end component;

    signal clk          : std_logic := '0';
    signal piezo        : std_logic := '0';
    signal outp         : std_logic := '0';

    constant clk_in_period : time := 20 ns;

begin
    uut: piezo_in_t
    port map(
        clk_i => clk,
        piezo_i => piezo,
        out_o => outp);

    clk_in_process : process
    begin
        clk <= '0';
        wait for clk_in_period/2;
        clk <= '1';
        wait for clk_in_period/2;
    end process;

    input : process
    begin
        wait for 100 us;
        piezo <= not piezo;
        wait for 10 us;
        piezo <= not piezo;
        wait for 10 us;
        piezo <= not piezo;
        wait for 10 us;
        piezo <= not piezo;
        wait for 10 us;
        piezo <= not piezo;
        
        piezo <= '0';

        wait for 1000 us;
        piezo <= not piezo;
        wait for 10 us;
        piezo <= not piezo;
        wait for 10 us;
        piezo <= not piezo;
        wait for 10 us;
        piezo <= not piezo;
        wait for 10 us;
        piezo <= not piezo;
    end process;
end;
