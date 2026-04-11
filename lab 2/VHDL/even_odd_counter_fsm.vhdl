-- this file is extra and shouldn't be needed for the assignment just for invalid case handling

library ieee;
  use ieee.std_logic_1164.all;

-- 4-bit Even/Odd Synchronous Counter (FSM version)
--
-- Input X selects which sequence is followed on each rising clock edge:
--   X = '0' -> even sequence: 0000, 0010, 0100, ..., 1110, 0000, ...
--   X = '1' -> odd  sequence: 0001, 0011, 0101, ..., 1111, 0001, ...
-- Any X value other than '0' or '1' is intentionally undefined.
--
-- This is written as an explicit Moore state machine to make state-diagram
-- rendering straightforward in tools such as TeroHDL.

entity even_odd_counter_fsm is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;  -- Synchronous active-high reset
    x       : in    std_logic;
    count_q : out   std_logic_vector(3 downto 0)
  );
end entity even_odd_counter_fsm;

architecture rtl of even_odd_counter_fsm is

  -- One state per 4-bit value.

  type state_t is (
    s0, s1, s2, s3,
    s4, s5, s6, s7,
    s8, s9, s10, s11,
    s12, s13, s14, s15
  );

  signal state, next_state : state_t;

begin

  -- State register (synchronous reset).
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
  process (state, x) is
  begin

    case state is

      when s0 =>

        if (x = '0') then
          next_state <= s2;
        elsif (x = '1') then
          next_state <= s1;
        end if;

      when s1 =>

        if (x = '0') then
          next_state <= s2;
        elsif (x = '1') then
          next_state <= s3;
        end if;

      when s2 =>

        if (x = '0') then
          next_state <= s4;
        elsif (x = '1') then
          next_state <= s3;
        end if;

      when s3 =>

        if (x = '0') then
          next_state <= s4;
        elsif (x = '1') then
          next_state <= s5;
        end if;

      when s4 =>

        if (x = '0') then
          next_state <= s6;
        elsif (x = '1') then
          next_state <= s5;
        end if;

      when s5 =>

        if (x = '0') then
          next_state <= s6;
        elsif (x = '1') then
          next_state <= s7;
        end if;

      when s6 =>

        if (x = '0') then
          next_state <= s8;
        elsif (x = '1') then
          next_state <= s7;
        end if;

      when s7 =>

        if (x = '0') then
          next_state <= s8;
        elsif (x = '1') then
          next_state <= s9;
        end if;

      when s8 =>

        if (x = '0') then
          next_state <= s10;
        elsif (x = '1') then
          next_state <= s9;
        end if;

      when s9 =>

        if (x = '0') then
          next_state <= s10;
        elsif (x = '1') then
          next_state <= s11;
        end if;

      when s10 =>

        if (x = '0') then
          next_state <= s12;
        elsif (x = '1') then
          next_state <= s11;
        end if;

      when s11 =>

        if (x = '0') then
          next_state <= s12;
        elsif (x = '1') then
          next_state <= s13;
        end if;

      when s12 =>

        if (x = '0') then
          next_state <= s14;
        elsif (x = '1') then
          next_state <= s13;
        end if;

      when s13 =>

        if (x = '0') then
          next_state <= s14;
        elsif (x = '1') then
          next_state <= s15;
        end if;

      when s14 =>

        if (x = '0') then
          next_state <= s0;
        elsif (x = '1') then
          next_state <= s15;
        end if;

      when s15 =>

        if (x = '0') then
          next_state <= s0;
        elsif (x = '1') then
          next_state <= s1;
        end if;

    end case;

  end process;

  -- Output decode (Moore outputs).
  process (state) is
  begin

    case state is

      when s0 =>

        count_q <= "0000";

      when s1 =>

        count_q <= "0001";

      when s2 =>

        count_q <= "0010";

      when s3 =>

        count_q <= "0011";

      when s4 =>

        count_q <= "0100";

      when s5 =>

        count_q <= "0101";

      when s6 =>

        count_q <= "0110";

      when s7 =>

        count_q <= "0111";

      when s8 =>

        count_q <= "1000";

      when s9 =>

        count_q <= "1001";

      when s10 =>

        count_q <= "1010";

      when s11 =>

        count_q <= "1011";

      when s12 =>

        count_q <= "1100";

      when s13 =>

        count_q <= "1101";

      when s14 =>

        count_q <= "1110";

      when s15 =>

        count_q <= "1111";

    end case;

  end process;

end architecture rtl;
