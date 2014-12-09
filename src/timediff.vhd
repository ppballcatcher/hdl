library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timediff_t is
    port(
        clk_i           : in std_logic;
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
    type lv_arr_2_t is array(natural range <>) of std_logic_vector(1 downto 0);
    constant num_piezos : integer := 4;
    signal clk_edges : std_logic_vector(31 downto 0) := (others => '0');
    signal timings : lv_arr_32_t(num_piezos - 1 downto 0);
    signal triggers : std_logic_vector(3 downto 0);
    signal flipflops : lv_arr_2_t(num_piezos - 1 downto 0);

begin

    -- Synchronize input to system clock
    input_sync : process(clk_i)
    begin
        for i in 0 to num_piezos - 1 loop
            if rising_edge(clk_i) then
                flipflops(i)(0) <= piezos_i(i);
                flipflops(i)(1) <= flipflops(i)(0);
            end if;
        end loop;
    end process;

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

    clk_count : process(clk_i) -- TODO handle overflow
    begin
        if rising_edge(clk_i) then
            clk_edges <= std_logic_vector(unsigned(clk_edges) + 1);
        end if;
    end process;

    time_rec : process(triggers)
        variable sample_count : integer range 0 to num_piezos := 0;
    begin
        for i in 0 to num_piezos - 1 loop
            if rising_edge(triggers(i)) then
                timings(i) <= clk_edges;
                sample_count := sample_count + 1;

                if sample_count = num_piezos - 1 then
                    sample_count := 0;
                    timings_ready_o <= '1'; -- TODO
                end if;
            end if;
        end loop;
    end process;

end behavioral;
