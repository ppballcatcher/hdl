library ieee;
use ieee.std_logic_1164.all;

entity top is
    port(
        clk : in std_logic;
        leds : out std_logic_vector(1 downto 0);
        btns : in std_logic_vector(0 downto 0);
        UART_RX : in std_logic;
        UART_TX : out std_logic;
        PIEZO : in std_logic_vector(3 downto 0));
end top;

architecture behavioral of top is
    component microblaze_mcs_v1_4
        port(
            Clk : in std_logic;
            Reset : in std_logic;
            UART_Rx : in std_logic;
            UART_Tx : out std_logic;
            FIT1_Toggle : out std_logic;
            PIT1_interrupt : out std_logic;
            PIT1_Toggle : out std_logic;
            GPO1 : out std_logic_vector(31 downto 0);
            GPI1 : in std_logic_vector(31 downto 0);
            GPI1_interrupt : out std_logic;
            inTC_interrupt : in std_logic_vector(1 downto 0);
            inTC_IRQ : out std_logic);
    end component;

    component timediff_t is
        port(
            clk_i : in std_logic;
            piezos_i : in std_logic_vector(3 downto 0);
            timing_select_i : in std_logic_vector(1 downto 0);
            timing_o : out std_logic_vector(31 downto 0);
            timings_ready_o : out std_logic);
    end component;

    signal fit : std_logic;
    signal timing : std_logic_vector(31 downto 0);

begin
    leds <= fit & not fit;

    mcs_0 : microblaze_mcs_v1_4
    port map(
        Clk => clk,
        Reset => btns(0),
        UART_Rx => UART_RX,
        UART_Tx => UART_TX,
        FIT1_Toggle => fit,
        PIT1_interrupt => open,
        PIT1_Toggle => open,
        GPO1 => open,
        GPI1 => timing,
        GPI1_interrupt => open,
        inTC_interrupt => (others => '0'),
        inTC_IRQ => open
    );

    timediff_0 : timediff_t
    port map(
        clk_i => clk,
        piezos_i => piezos,
        timing_select_i => '0', -- TODO
        timing_o => timing,
        timings_ready_o => open); -- TODO

end behavioral;

