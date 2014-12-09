library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timediff_t is
    port(
        clk_i           : in std_logic;
        reset_i         : in std_logic;
        piezos_i        : in std_logic_vector(3 downto 0);
        timing_select_i : in std_logic_vector(1 downto 0);
        timing_o        : out std_logic_vector(31 downto 0);
        timings_ready_o : out std_logic);
end timediff_t;

architecture behavioral of timediff_t is
    component piezo_in_t is
        generic(
            clk_in_freq : integer := 50000000);
        port(
            clk_i       : in std_logic;
            piezo_i     : in std_logic;
            out_o       : out std_logic);
    end component;

    type lv_arr_32_t is array(natural range <>) of std_logic_vector(31 downto 0);
    constant num_piezos : integer := 4;
    signal clk_edges : std_logic_vector(31 downto 0) := (others => '0');
    signal first_idx : unsigned(1 downto 0);
    signal timings : lv_arr_32_t(num_piezos - 1 downto 0);
    signal triggers : std_logic_vector(3 downto 0);
    signal triggers_remember : std_logic_vector(3 downto 0);

begin
    gen_inputs:
    for i in 0 to num_piezos - 1 generate
        piezo_in : piezo_in_t
        port map(
            clk_i => clk_i,
            piezo_i => piezos_i(i),
            out_o => triggers(i));
    end generate;

    out_mux : process (timing_select_i)
    begin
        case timing_select_i is
            when "00" => timing_o <= timings(0);
            when "01" => timing_o <= timings(1);
            when "10" => timing_o <= timings(2);
            when "11" => timing_o <= timings(3);
            when others => timing_o <= (others => '0');
        end case;
    end process;

    clk_count : process(clk_i) -- TODO
    begin
        if rising_edge(clk_i) then
            clk_edges <= std_logic_vector(unsigned(clk_edges) + 1);
        end if;
    end process;

    trig_enable : process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            triggers_remember <= "0000";
        elsif rising_edge(clk_i) then
            triggers_remember <= triggers_remember or triggers;
        end if;
    end process;

    time_rec_0 : process(triggers(0))
    begin
        if rising_edge(triggers(0)) then
            if triggers_remember = "0000" then
                clk_edges_first <= clk_edges;
            end if;

            timings(0) <= std_logic_vector(unsigned(clk_edges) - unsigned(timings(first_idx)));
        end if;
    end process;

    time_rec_1 : process(triggers(1))
    begin
        if rising_edge(triggers(1)) then
            if triggers_remember = "0000" then
                clk_edges_first <= clk_edges;
            end if;

            timings(1) <= std_logic_vector(unsigned(clk_edges) - unsigned(timings(first_idx)));
        end if;
    end process;

    time_rec_2 : process(triggers(2))
    begin
        if rising_edge(triggers(2)) then
            if triggers_remember = "0000" then
                clk_edges_first <= clk_edges;
            end if;

            timings(2) <= std_logic_vector(unsigned(clk_edges) - unsigned(timings(first_idx)));
        end if;
    end process;

    time_rec_3 : process(triggers(3))
    begin
        if rising_edge(triggers(3)) then
            if triggers_remember = "0000" then
                clk_edges_first <= clk_edges;
            end if;

            timings(3) <= std_logic_vector(unsigned(clk_edges) - unsigned(timings(first_idx)));
        end if;
    end process;

    triggers_state : process(triggers_remember)
    begin
        case triggers_remember is
            when "1111" =>
                timings_ready_o <= '1';

            --when "0001" or "0010" or "0100" or "1000" =>
                -- First measure

            when others =>
                timings_ready_o <= '0';
        end case;
    end process;

end behavioral;
