library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity even_odd_counter_jk is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        x       : in  std_logic;                      
        count_q : out std_logic_vector(3 downto 0)
    );
end entity even_odd_counter_jk;

architecture structural of even_odd_counter_jk is

    component jkff is
        port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            j     : in  std_logic;
            k     : in  std_logic;
            q     : out std_logic;
            q_bar : out std_logic
        );
    end component;

    signal q0, q1, q2, q3 : std_logic;

    signal q      : std_logic_vector(3 downto 0);
    signal D : std_logic_vector(3 downto 0);

    signal j0, k0 : std_logic;
    signal j1, k1 : std_logic;
    signal j2, k2 : std_logic;
    signal j3, k3 : std_logic;

    signal q0_bar, q1_bar, q2_bar, q3_bar : std_logic;

begin

    q <= q3 & q2 & q1 & q0;

    D <= std_logic_vector(unsigned(q) + "0010") when q(0) = x 
         else std_logic_vector(unsigned(q) + "0001");


    j0 <= (not q0) and D(0);
    k0 <= q0 and (not D(0));

    j1 <= (not q1) and D(1);
    k1 <= q1 and (not D(1));

    j2 <= (not q2) and D(2);
    k2 <= q2 and (not D(2));

    j3 <= (not q3) and D(3);
    k3 <= q3 and (not D(3));

    ff0: jkff port map (clk, rst, j0, k0, q0, q0_bar);
    ff1: jkff port map (clk, rst, j1, k1, q1, q1_bar);
    ff2: jkff port map (clk, rst, j2, k2, q2, q2_bar);
    ff3: jkff port map (clk, rst, j3, k3, q3, q3_bar);

    count_q <= q;

end architecture structural;