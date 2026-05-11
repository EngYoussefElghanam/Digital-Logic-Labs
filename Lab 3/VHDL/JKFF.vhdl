library ieee;
use ieee.std_logic_1164.all;

entity jk_flipflop is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        J   : in  std_logic;
        K   : in  std_logic;
        Q   : out std_logic
    );
end entity;

architecture behavioral of jk_flipflop is
    signal q_internal : std_logic := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then
            q_internal <= '0';

        elsif rising_edge(clk) then
            q_internal <= (J and (not q_internal)) or
                          ((not K) and q_internal);
        end if;
    end process;

    Q <= q_internal;

end architecture;