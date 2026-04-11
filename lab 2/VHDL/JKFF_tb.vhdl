library ieee;
  use ieee.std_logic_1164.all;

-- Testbench for JK flip-flop

entity jkff_tb is
-- Testbench has no ports
end entity jkff_tb;

architecture behavior of jkff_tb is

  -- Component Declaration for the Unit Under Test (UUT)
  component jkff is
    port (
      clk   : in    std_logic;
      rst   : in    std_logic;
      j     : in    std_logic;
      k     : in    std_logic;
      q     : out   std_logic;
      q_bar : out   std_logic
    );
  end component jkff;

  -- Inputs
  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal j   : std_logic := '0';
  signal k   : std_logic := '0';

  -- Outputs
  signal q     : std_logic;
  signal q_bar : std_logic;

  -- Clock period definition
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : component jkff
    port map (
      clk   => clk,
      rst   => rst,
      j     => j,
      k     => k,
      q     => q,
      q_bar => q_bar
    );

  -- Clock process definitions
  clk_process : process is
  begin

    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;

  end process clk_process;

  -- Stimulus process
  stim_proc : process is
  begin

    -- Hold reset state for 20 ns
    rst <= '1';
    wait for 20 ns;

    -- Release Reset
    rst <= '0';
    wait for 10 ns;

    -- Test 1: Set (J=1, K=0)
    j <= '1';
    k <= '0';
    wait for clk_period;

    -- Test 2: Hold (J=0, K=0) -> output should remain 1
    j <= '0';
    k <= '0';
    wait for clk_period;

    -- Test 3: Reset (J=0, K=1) -> output should become 0
    j <= '0';
    k <= '1';
    wait for clk_period;

    -- Test 4: Hold (J=0, K=0) -> output should remain 0
    j <= '0';
    k <= '0';
    wait for clk_period;

    -- Test 5: Toggle (J=1, K=1)
    j <= '1';
    k <= '1';
    wait for clk_period * 3; -- let it toggle for 3 clock cycles

    -- End simulation
    wait;

  end process stim_proc;

end architecture behavior;
