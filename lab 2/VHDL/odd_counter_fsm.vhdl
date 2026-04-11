library ieee;
  use ieee.std_logic_1164.all;

-- 4-bit Odd Synchronous Counter (FSM version)
--
-- Counts only odd numbers: 0001, 0011, 0101, ..., 1111, 0001...
--
-- Explicit Moore state machine for TeroHDL rendering.

entity odd_counter_fsm is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;  -- Synchronous active-high reset
    count_q : out   std_logic_vector(3 downto 0)
  );
end entity odd_counter_fsm;

architecture rtl of odd_counter_fsm is

  -- Only odd states are defined

  type state_t is (s1, s3, s5, s7, s9, s11, s13, s15);

  signal state, next_state : state_t;

begin

  -- State register (synchronous reset to s1).
  process (clk) is
  begin

    if rising_edge(clk) then
      if (rst = '1') then
        state <= s1;
      else
        state <= next_state;
      end if;
    end if;

  end process;

  -- Next-state logic.
  process (state) is
  begin

    case state is

      when s1 =>

        next_state <= s3;

      when s3 =>

        next_state <= s5;

      when s5 =>

        next_state <= s7;

      when s7 =>

        next_state <= s9;

      when s9 =>

        next_state <= s11;

      when s11 =>

        next_state <= s13;

      when s13 =>

        next_state <= s15;

      when s15 =>

        next_state <= s1;

    end case;

  end process;

  -- Output decode (Moore outputs).
  process (state) is
  begin

    case state is

      when s1 =>

        count_q <= "0001";

      when s3 =>

        count_q <= "0011";

      when s5 =>

        count_q <= "0101";

      when s7 =>

        count_q <= "0111";

      when s9 =>

        count_q <= "1001";

      when s11 =>

        count_q <= "1011";

      when s13 =>

        count_q <= "1101";

      when s15 =>

        count_q <= "1111";

    end case;

  end process;

end architecture rtl;
