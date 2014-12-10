library ieee;
use ieee.std_logic_1164.all;

entity c_sr_latch_t is
    port (
        clk : in std_logic;
        S   : in std_logic;
        R   : in std_logic;
        Q   : out std_logic;
        QN  : out std_logic);
end c_sr_latch_t;

architecture arch of c_sr_latch_t is
    signal Qt  : std_logic := '0';
    signal QNt : std_logic := '0';

begin
    Q <= Qt;
    QN <= QNt;

    process (clk)
    begin
        if rising_edge(clk) then
            Qt <= R nor QNt;
            QNt <= S nor Qt;
        end if;
    end process;
end arch;
