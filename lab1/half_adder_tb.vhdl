library ieee;
  use ieee.std_logic_1164.all;

entity half_adder_tb is
end entity half_adder_tb;

architecture testbench of half_adder_tb is

  -- Component declaration
  component half_adder is
    port (
      a     : in    std_logic;
      b     : in    std_logic;
      sum   : out   std_logic;
      carry : out   std_logic
    );
  end component half_adder;

  -- Signals for testing | these are only like temp vars
  signal test_a     : std_logic;
  signal test_b     : std_logic;
  signal test_sum   : std_logic;
  signal test_carry : std_logic;

begin

  -- Instantiate the half adder
  -- dut device under test
  dut : component half_adder
    port map (
      a     => test_a,
      b     => test_b,
      sum   => test_sum,
      carry => test_carry
    );

  -- Test process
  process is
  begin

    -- Test case 1: 0 + 0
    test_a <= '0';
    test_b <= '0';
    wait for 10 ns;
    assert test_sum = '0' and test_carry = '0'
      report "Test 1 failed"
      severity error;

    -- Test case 2: 0 + 1
    test_a <= '0';
    test_b <= '1';
    wait for 10 ns;
    assert test_sum = '1' and test_carry = '0'
      report "Test 2 failed"
      severity error;

    -- Test case 3: 1 + 0
    test_a <= '1';
    test_b <= '0';
    wait for 10 ns;
    assert test_sum = '1' and test_carry = '0'
      report "Test 3 failed"
      severity error;

    -- Test case 4: 1 + 1
    test_a <= '1';
    test_b <= '1';
    wait for 10 ns;
    assert test_sum = '0' and test_carry = '1'
      report "Test 4 failed"
      severity error;

    report "All tests passed!"
      severity note;
    wait;

  end process;

end architecture testbench;
