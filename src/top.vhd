library ieee;
use ieee.std_logic_1164.all;

entity top is
    port(
        clk : in std_logic;
        leds : out std_logic_vector(7 downto 0);
        btns : in std_logic_vector(3 downto 0));
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

    signal fit : std_logic;

begin
    leds <= fit & not fit & "000000";

    mcs_0 : microblaze_mcs_v1_4
    port map(
        Clk => clk,
        Reset => btns(0),
        UART_Rx => '0',
        UART_Tx => open,
        FIT1_Toggle => fit,
        PIT1_interrupt => open,
        PIT1_Toggle => open,
        GPO1 => open,
        GPI1 => (others => '0'),
        GPI1_interrupt => open,
        inTC_interrupt => (others => '0'),
        inTC_IRQ => open
    );

end behavioral;

