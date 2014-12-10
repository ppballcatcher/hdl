library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types.all;

entity top is
    port (
        clk : in std_logic;
        leds : out std_logic_vector(3 downto 0);
        btns : in std_logic_vector(1 downto 0);
        UART_RX : in std_logic;
        UART_TX : out std_logic;
        piezos : in std_logic_vector(3 downto 0));
end top;

architecture behavioral of top is
    component microblaze_mcs_v1_4
    port (
        Clk : in std_logic;
        Reset : in std_logic;
        UART_Rx : in std_logic;
        UART_Tx : out std_logic;
        FIT1_Toggle : out std_logic;
        PIT1_interrupt : out std_logic;
        PIT1_Toggle : out std_logic;
        GPO1 : out std_logic_vector(31 downto 0);
        GPO2 : out std_logic_vector(31 downto 0);
        GPI1 : in std_logic_vector(31 downto 0);
        GPI1_interrupt : out std_logic;
        GPI2 : in std_logic_vector(31 downto 0);
        GPI2_interrupt : out std_logic;
        GPI3 : in std_logic_vector(31 downto 0);
        GPI3_interrupt : out std_logic;
        GPI4 : in std_logic_vector(31 downto 0);
        GPI4_interrupt : out std_logic;
        inTC_interrupt : in std_logic_vector(1 downto 0);
        inTC_IRQ : out std_logic);
    end component;

    component piezotime_t is
    port (
        clk           : in std_logic;
        reset         : in std_logic; -- active high
        piezos        : in std_logic_vector(3 downto 0);
        timings       : out lv_arr_32_t(3 downto 0);
        timings_ready : out std_logic);
    end component;

    signal fit : std_logic;
    signal timings_reset : std_logic_vector(31 downto 0);
    signal timings_ready : std_logic;
    signal intc_isr : std_logic_vector(1 downto 0);
    signal timings : lv_arr_32_t(3 downto 0);

begin
    leds <= fit & not fit & timings_ready & timings_reset(0);
    intc_isr <= timings_ready & btns(1);

    mcs_0 : microblaze_mcs_v1_4
    port map (
        Clk => clk,
        Reset => btns(0),
        UART_Rx => UART_RX,
        UART_Tx => UART_TX,
        FIT1_Toggle => fit,
        PIT1_interrupt => open,
        PIT1_Toggle => open,
        GPO1 => timings_reset,
        GPO2 => open,
        GPI1 => timings(0),
        GPI1_Interrupt => open,
        GPI2 => timings(1),
        GPI2_Interrupt => open,
        GPI3 => timings(2),
        GPI3_Interrupt => open,
        GPI4 => timings(3),
        GPI4_Interrupt => open,
        inTC_interrupt => intc_isr,
        inTC_IRQ => open
    );

    piezotime_0 : piezotime_t
    port map (
        clk => clk,
        reset => timings_reset(0),
        piezos => piezos,
        timings => timings,
        timings_ready => timings_ready);

end behavioral;

