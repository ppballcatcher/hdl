library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_test is
end pwm_test;

architecture behavior of pwm_test is
    component pwm_t
        generic(
            clk_in_freq     : integer := 50000000; -- input clock frequency
            pwm_out_freq    : integer := 50; -- frequency of the PWM output
            bits_resolution : integer := 32); -- resolution of 'duty_in'
        port(
            clk_in          : in std_logic; -- input clock
            duty_in         : in std_logic_vector(bits_resolution - 1 downto 0); -- duty cycle
            duty_latch_in   : in std_logic; -- when high latches in duty new cycle on 'duty_in'
            pwm_out         : out std_logic); -- PWM output signal
    end component;

   signal clk_in         : std_logic;
   signal duty_latch_in  : std_logic;
   signal duty_in        : std_logic_vector(31 downto 0);
   signal pwm_out        : std_logic;

   constant clk_in_period : time := 20 ns;

begin
    uut: pwm_t
    port map (
        clk_in => clk_in,
        duty_in => duty_in,
        duty_latch_in => duty_latch_in,
        pwm_out => pwm_out);

    clk_in_process : process
    begin
        clk_in <= '0';
        wait for clk_in_period/2;
        clk_in <= '1';
        wait for clk_in_period/2;
    end process;

    set_duty : process
    begin
        wait for clk_in_period;

        duty_in <= "01111111"; -- 50%
        duty_latch_in <= '1';
        wait for clk_in_period;
        duty_latch_in <= '0';
        wait for 100 ms;

        duty_in <= "00011111"; -- 12.5%
        duty_latch_in <= '1';
        wait for clk_in_period;
        duty_latch_in <= '0';
        wait for 100 ms;

        duty_in <= "10101011"; -- ~67%
        duty_latch_in <= '1';
        wait for clk_in_period;
        duty_latch_in <= '0';
        wait for 100 ms;

        duty_in <= "00111111"; -- 25%
        duty_latch_in <= '1';
        wait for clk_in_period;
        duty_latch_in <= '0';
        wait for 100 ms;

        duty_in <= "11111111"; -- 100%
        duty_latch_in <= '1';
        wait for clk_in_period;
        duty_latch_in <= '0';
        wait for 100 ms;

        duty_in <= "00000000"; -- 0%
        duty_latch_in <= '1';
        wait for clk_in_period;
        duty_latch_in <= '0';
        wait;
    end process;

end;
