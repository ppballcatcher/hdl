
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity top is
    port (
        clk : in std_logic;
        leds : out std_logic_vector(7 downto 0);
        btns : in std_logic_vector(3 downto 0)
        );
        
end top;

architecture Behavioral of top is
    COMPONENT microblaze_mcs_v1_4
      PORT (
        Clk : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        UART_Rx : IN STD_LOGIC;
        UART_Tx : OUT STD_LOGIC;
        FIT1_Toggle : OUT STD_LOGIC;
        PIT1_Interrupt : OUT STD_LOGIC;
        PIT1_Toggle : OUT STD_LOGIC;
        GPO1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        GPI1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        GPI1_Interrupt : OUT STD_LOGIC;
        INTC_Interrupt : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        INTC_IRQ : OUT STD_LOGIC
      );
    END COMPONENT;
    
    signal fit : std_logic;
   
begin
--    leds(7 downto 2) <= ;
    
--      leds(0) <= fit;
    leds <= fit & not fit & "000000";

    mcs_0 : microblaze_mcs_v1_4
      PORT MAP (
        Clk => clk,
        Reset => btns(0),
        UART_Rx => '0',
        UART_Tx => open,
        FIT1_Toggle => fit,
        PIT1_Interrupt => open,
        PIT1_Toggle => open,
        GPO1 => open,
        GPI1 => (others => '0'),
        GPI1_Interrupt => open,
        INTC_Interrupt => (others => '0'),
        INTC_IRQ => open
      );

end Behavioral;

