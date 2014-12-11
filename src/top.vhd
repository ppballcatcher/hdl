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
        piezos : in std_logic_vector(3 downto 0);
		PWM_SERVO_O : out std_logic);
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

    constant pwm_resolution : integer := 10;

    component pwm_t is
        generic(
            clk_in_freq     : integer := 50000000; -- input clock frequency
            pwm_out_freq    : integer := 50; -- frequency of the PWM output
            bits_resolution : integer := pwm_resolution); -- resolution of 'duty_in'
        port(
            clk_in          : in std_logic; -- input clock
            duty_in         : in std_logic_vector(pwm_resolution - 1 downto 0); -- duty cycle
            duty_latch_in   : in std_logic; -- when high latches in duty new cycle on 'duty_in'
            pwm_out         : out std_logic); -- PWM output signal
    end component;

	-- PWM
    signal servo_duty_in       : std_logic_vector(31 downto 0); -- duty cycle
    signal servo_duty_latch_in : std_logic; -- when high latches in duty new cycle on 'duty_in'

    signal fit : std_logic;
    signal timings_reset : std_logic_vector(31 downto 0);
    signal timings_ready : std_logic;
    signal intc_isr : std_logic_vector(1 downto 0);
    signal timings : lv_arr_32_t(3 downto 0);

begin
    leds <= fit & not fit & timings_ready & timings_reset(0);
    intc_isr <= timings_ready & btns(1);
	servo_duty_latch_in <= '1';

    servo : pwm_t
    port map (
        clk_in => clk,
        duty_in => servo_duty_in(pwm_resolution - 1 downto 0),
        duty_latch_in => servo_duty_latch_in,
        pwm_out => PWM_SERVO_O);

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
        GPO2 => servo_duty_in,
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

