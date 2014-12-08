library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity piezo_in_t is
    generic(
        clk_in_freq : integer := 50000000);
    port(
        clk_i       : in std_logic;
        piezo_i     : in std_logic;
        out_o       : out std_logic);
end piezo_in_t;

architecture behavioral of piezo_in_t is
    type state_t is (HOLD, RUN);
    signal state : state_t := HOLD;
    signal flipflops : std_logic_vector(1 downto 0) := (others => '0');
    signal trig : std_logic := '0';

begin
    trig <= flipflops(1);

    -- Synchronize input to system clock
    input_sync : process(clk_i)
    begin
        if rising_edge(clk_i) then
            flipflops(0) <= piezo_i;
            flipflops(1) <= flipflops(0);
        end if;
    end process;

    counter_oneshot : process(clk_i)
        constant count_max : integer := clk_in_freq; -- TODO review this
        variable count     : integer range 0 to count_max := 0;
    begin
        if rising_edge(clk_i) then
            case state is
                when HOLD =>
                    out_o <= '0';
                    count := 0;

                    if trig = '1' then
                        state <= RUN;
                    end if;

                when RUN =>
                    out_o <= '1';

                    if count = count_max then
                        state <= HOLD;
                    else
                        count := count + 1;
                    end if;

                when others =>
                    null;
            end case;
        end if;
    end process;

end behavioral;
