library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_t is
    generic(
        constant clk_in_freq     : integer := 50000000; -- input clock frequency
        constant pwm_out_freq    : integer := 50; -- frequency of the PWM output
        constant bits_resolution : integer := 8); -- resolution of 'duty_in'
    port(
        clk_in          : in std_logic; -- input clock
        duty_in         : in std_logic_vector(bits_resolution - 1 downto 0); -- duty cycle
        duty_latch_in   : in std_logic; -- when high latches in duty new cycle on 'duty_in'
        pwm_out         : out std_logic); -- PWM output signal
end pwm_t;

architecture behavioral of pwm_t is
    constant period_num_clocks : integer := clk_in_freq/pwm_out_freq;
    signal duty_clocks       : integer range 0 to period_num_clocks := 0;
    signal count             : integer range 0 to period_num_clocks := 0;

begin
    process(clk_in)
    begin
        if (rising_edge(clk_in)) then
            if (duty_latch_in = '1') then
                -- map 'duty_in' from [0; 2^bits_resolution] -> [0; period_num_clocks]
                duty_clocks <= to_integer(unsigned(duty_in)) * period_num_clocks / (2**bits_resolution);
            end if;

            count <= count + 1;

            if (count = duty_clocks) then
                pwm_out <= '0';
            end if;

            if (count = period_num_clocks) then
                pwm_out <= '1';
                count <= 0;
            end if;
        end if;
    end process;

end behavioral;
