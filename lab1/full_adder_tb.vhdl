library ieee;
  use ieee.std_logic_1164.all;

-- empty entity

entity full_adder_tb is
end entity full_adder_tb;

architecture testbench of full_adder_tb is

  -- Component declaration
  component full_adder is
    port (
      a    : in    std_logic;
      b    : in    std_logic;
      cin  : in    std_logic;
      sum  : out   std_logic;
      cout : out   std_logic
    );
  end component full_adder;

  -- Signals for testing
  signal test_a    : std_logic;
  signal test_b    : std_logic;
  signal test_cin  : std_logic;
  signal test_sum  : std_logic;
  signal test_cout : std_logic;

begin

  -- Instantiate the full adder
  -- dut is just a name and it doesn't affect the execution of the program
  dut : component full_adder
    port map (
      a    => test_a,
      b    => test_b,
      cin  => test_cin,
      sum  => test_sum,
      cout => test_cout
    );

  -- Test process
  process is
  begin

    -- Test case 1: 0 + 0 + 0 = 0, Cout = 0
    test_a   <= '0';
    test_b   <= '0';
    test_cin <= '0';
    wait for 10 ns;
    assert test_sum = '0' and test_cout = '0'
      report "Test 1 failed"
      severity error;

    -- Test case 2: 0 + 0 + 1 = 1, Cout = 0
    test_a   <= '0';
    test_b   <= '0';
    test_cin <= '1';
    wait for 10 ns;
    assert test_sum = '1' and test_cout = '0'
      report "Test 2 failed"
      severity error;

    -- Test case 3: 0 + 1 + 0 = 1, Cout = 0
    test_a   <= '0';
    test_b   <= '1';
    test_cin <= '0';
    wait for 10 ns;
    assert test_sum = '1' and test_cout = '0'
      report "Test 3 failed"
      severity error;

    -- Test case 4: 0 + 1 + 1 = 0, Cout = 1
    test_a   <= '0';
    test_b   <= '1';
    test_cin <= '1';
    wait for 10 ns;
    assert test_sum = '0' and test_cout = '1'
      report "Test 4 failed"
      severity error;

    -- Test case 5: 1 + 0 + 0 = 1, Cout = 0
    test_a   <= '1';
    test_b   <= '0';
    test_cin <= '0';
    wait for 10 ns;
    assert test_sum = '1' and test_cout = '0'
      report "Test 5 failed"
      severity error;

    -- Test case 6: 1 + 0 + 1 = 0, Cout = 1
    test_a   <= '1';
    test_b   <= '0';
    test_cin <= '1';
    wait for 10 ns;
    assert test_sum = '0' and test_cout = '1'
      report "Test 6 failed"
      severity error;

    -- Test case 7: 1 + 1 + 0 = 0, Cout = 1
    test_a   <= '1';
    test_b   <= '1';
    test_cin <= '0';
    wait for 10 ns;
    assert test_sum = '0' and test_cout = '1'
      report "Test 7 failed"
      severity error;

    -- Test case 8: 1 + 1 + 1 = 1, Cout = 1
    test_a   <= '1';
    test_b   <= '1';
    test_cin <= '1';
    wait for 10 ns;
    assert test_sum = '1' and test_cout = '1'
      report "Test 8 failed"
      severity error;

    report "All Full Adder tests passed!"
      severity note;
    wait;

  end process;

end architecture testbench;
