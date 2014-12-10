library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;

entity piezotime_t is
    port (
        clk           : in std_logic;
        reset         : in std_logic; -- active high
        piezos        : in std_logic_vector(3 downto 0);
        timings       : out lv_arr_32_t(3 downto 0);
        timings_ready : out std_logic);
end piezotime_t;

architecture behavioral of piezotime_t is
    component c_sr_latch_t is
        port (
            clk : in std_logic;
            S   : in std_logic;
            R   : in std_logic;
            Q   : out std_logic;
            QN  : out std_logic);
    end component;

    signal clk_edges : std_logic_vector(31 downto 0);
    --signal trig_in : std_logic_vector(3 downto 0);
    signal triggered : std_logic_vector(3 downto 0);
    signal saved : std_logic_vector(3 downto 0);
    --signal time_start : std_logic_vector(32 downto 0);
    signal timings_raw : lv_arr_32_t(3 downto 0);

begin
    gen_input_latches:
    for i in 0 to 3 generate
        latch_in : c_sr_latch_t
        port map (
            clk => clk,
            S => piezos(i),
            R => reset,
            Q => triggered(i),
            QN => open);
    end generate;

    clk_count:
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                clk_edges <= (others => '0');
            else
                clk_edges <= std_logic_vector(unsigned(clk_edges) + 1);
            end if;
        end if;
    end process;

    time_rec:
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                saved <= "0000";
            else
                for i in 0 to 3 loop
                    if triggered(i) = '1' and saved(i) = '0' then
                        timings_raw(i) <= clk_edges;
                        saved(i) <= '1';
                    end if;
                end loop;
            end if;
        end if;
    end process;

    timings_ready <= '1' when saved = "1111" else '0';

end behavioral;
