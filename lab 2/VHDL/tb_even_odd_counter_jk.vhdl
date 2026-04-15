library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_even_odd_counter_jk is
end entity;

architecture sim of tb_even_odd_counter_jk is

    signal clk   : std_logic := '0';
    signal rst   : std_logic;
    signal x     : std_logic;
    signal count : std_logic_vector(3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    component even_odd_counter_jk is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            x       : in  std_logic;
            count_q : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    DUT: even_odd_counter_jk
        port map (
            clk     => clk,
            rst     => rst,
            x       => x,
            count_q => count
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Verification process
    verification: process
        variable old_count : unsigned(3 downto 0);
    begin
        -- Reset the counter
        rst <= '1';
        x   <= '0';
        wait for CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;      -- now count = 0

        report "=== Testing with x = '0' ===" severity note;

        -- Test x = '0'
        x <= '0';
        for i in 0 to 7 loop
            old_count := unsigned(count);
            wait until rising_edge(clk);
            wait for 1 ns;        -- let signals settle
            if old_count(0) = '0' then
                assert unsigned(count) = old_count + 2
                    report "Error (x=0): " & integer'image(to_integer(old_count)) &
                           " -> " & integer'image(to_integer(unsigned(count))) &
                           " expected +2" severity error;
            else
                assert unsigned(count) = old_count + 1
                    report "Error (x=0): " & integer'image(to_integer(old_count)) &
                           " -> " & integer'image(to_integer(unsigned(count))) &
                           " expected +1" severity error;
            end if;
        end loop;

        report "=== Testing with x = '1' ===" severity note;

        -- Test x = '1'
        x <= '1';
        for i in 0 to 7 loop
            old_count := unsigned(count);
            wait until rising_edge(clk);
            wait for 1 ns;
            if old_count(0) = '1' then
                assert unsigned(count) = old_count + 2
                    report "Error (x=1): " & integer'image(to_integer(old_count)) &
                           " -> " & integer'image(to_integer(unsigned(count))) &
                           " expected +2" severity error;
            else
                assert unsigned(count) = old_count + 1
                    report "Error (x=1): " & integer'image(to_integer(old_count)) &
                           " -> " & integer'image(to_integer(unsigned(count))) &
                           " expected +1" severity error;
            end if;
        end loop;

        report "=== Test completed successfully ===" severity note;
        wait;
    end process;

end architecture;