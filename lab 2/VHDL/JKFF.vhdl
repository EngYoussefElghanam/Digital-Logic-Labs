library ieee;
  use ieee.std_logic_1164.all;

-- JK flip-flop
-- Behavior table (evaluated on rising edge of clk):
--   J K | Next Q
--   0 0 | Hold current state
--   0 1 | Reset (Q <= '0')
--   1 0 | Set   (Q <= '1')
--   1 1 | Toggle (Q <= not Q)
--
-- This design also includes an asynchronous active-high reset input (rst).

entity jkff is
  port (
    clk   : in    std_logic; -- Clock input
    rst   : in    std_logic; -- Asynchronous reset, active high
    j     : in    std_logic; -- J control input
    k     : in    std_logic; -- K control input
    q     : out   std_logic; -- Main output
    q_bar : out   std_logic  -- Complementary output
  );
end entity jkff;

architecture rtl of jkff is

  signal q_reg : std_logic := '0';

begin

  -- Sequential process: reset first, then edge-triggered JK behavior.
  process (clk, rst) is
  begin

    if (rst = '1') then
      q_reg <= '0';
    elsif rising_edge(clk) then
      if ((j = '0') and (k = '0')) then
        -- Hold state
        q_reg <= q_reg;
      elsif ((j = '0') and (k = '1')) then
        -- Reset
        q_reg <= '0';
      elsif ((j = '1') and (k = '0')) then
        -- Set
        q_reg <= '1';
      elsif ((j = '1') and (k = '1')) then
        -- Toggle
        q_reg <= not q_reg;
      else
        -- Defensive fallback for non-'0'/'1' logic values.
        q_reg <= q_reg;
      end if;
    end if;

  end process;

  -- Combinational output mapping
  q     <= q_reg;
  q_bar <= not q_reg;

end architecture rtl;
