library ieee;
  use ieee.std_logic_1164.all;

-- 4-bit Even Synchronous Counter (FSM version)
--
-- Counts only even numbers: 0000, 0010, 0100, ..., 1110, 0000...
--
-- Explicit Moore state machine for TerosHDL rendering.

entity even_counter_fsm is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;  -- Synchronous active-high reset
    count_q : out   std_logic_vector(3 downto 0)
  );
end entity even_counter_fsm;

architecture rtl of even_counter_fsm is

  -- Only even states are defined

  type state_t is (s0, s2, s4, s6, s8, s10, s12, s14);

  signal state, next_state : state_t;

begin

  -- State register (synchronous reset to s0).
  process (clk) is
  begin

    if rising_edge(clk) then
      if (rst = '1') then
        state <= s0;
      else
        state <= next_state;
      end if;
    end if;

  end process;

  -- Next-state logic.
  process (state) is
  begin

    case state is

      when s0 =>

        next_state <= s2;

      when s2 =>

        next_state <= s4;

      when s4 =>

        next_state <= s6;

      when s6 =>

        next_state <= s8;

      when s8 =>

        next_state <= s10;

      when s10 =>

        next_state <= s12;

      when s12 =>

        next_state <= s14;

      when s14 =>

        next_state <= s0;

    end case;

  end process;

  -- Output decode (Moore outputs).
  process (state) is
  begin

    case state is

      when s0 =>

        count_q <= "0000";

      when s2 =>

        count_q <= "0010";

      when s4 =>

        count_q <= "0100";

      when s6 =>

        count_q <= "0110";

      when s8 =>

        count_q <= "1000";

      when s10 =>

        count_q <= "1010";

      when s12 =>

        count_q <= "1100";

      when s14 =>

        count_q <= "1110";

    end case;

  end process;

end architecture rtl;
