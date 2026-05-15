library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity tb_moore_structural is
  -- Testbench entities are always empty
end tb_moore_structural;

architecture Behavioral of tb_moore_structural is

  -- 1. Component Declaration for the circuit we are testing
  component moore_structural
    port (
      X   : in std_logic;
      Clk : in std_logic;
      Z   : out std_logic
    );
  end component;

  -- 2. Testbench Signals to connect to the component
  signal X_tb   : std_logic := '0';
  signal Clk_tb : std_logic := '0';
  signal Z_tb   : std_logic;
  signal rst_tie : std_logic := '1'; -- Starts the system in reset
  

  -- 3. Clock period definition
  constant CLK_PERIOD : time := 10 ns;

  -- 4. Verification Counters (to prove the math to the TA)
  signal ones_count  : integer := 0;
  signal zeros_count : integer := 0;

begin

  -- ==========================================
  -- Instantiate the Structural Model (UUT)
  -- ==========================================
  UUT : moore_structural PORT
  map (
  X   => X_tb,
  Clk => Clk_tb,
  Z   => Z_tb
  );

  -- ==========================================
  -- Clock Generation Process
  -- ==========================================
  clk_process : process
  begin
    Clk_tb <= '0';
    wait for CLK_PERIOD/2;
    Clk_tb <= '1';
    wait for CLK_PERIOD/2;
  end process;

  -- ==========================================
  -- Stimulus & Verification Process
  -- ==========================================
  stimulus_process : process
  begin
    -- Wait for initial system stabilization
    rst_tie <= '1';   -- Activate reset
    X_tb    <= '0';   -- Default input
    wait for CLK_PERIOD;
    
    rst_tie <= '0';   -- Release reset
    wait for CLK_PERIOD;

    report "===========================================================";
    report " STARTING STRUCTURAL MOORE TESTBENCH";
    report " TARGET: Z=1 when (1s are divisible by 4) AND (0s are odd)";
    report "===========================================================";

    -- Test 1: Reach the first Z=1 state (0 ones, 1 zero)
    -- '0' ones is mathematically divisible by 4 (0 % 4 = 0).
    X_tb <= '0';
    wait for CLK_PERIOD;
    zeros_count <= zeros_count + 1;
    report "Input: 0 | Ones: " & integer'image(ones_count) & " | Zeros: " & integer'image(zeros_count + 1) & " -> Z=" & std_logic'image(Z_tb) & " (EXPECT 1)";

    -- Test 2: Input a 1. Z should drop to 0 because ones = 1 (not div by 4).
    X_tb <= '1';
    wait for CLK_PERIOD;
    ones_count <= ones_count + 1;
    report "Input: 1 | Ones: " & integer'image(ones_count + 1) & " | Zeros: " & integer'image(zeros_count) & " -> Z=" & std_logic'image(Z_tb) & " (EXPECT 0)";

    -- Test 3: Input three more 1s to reach 4 ones. 
    -- At this point: 4 ones (div by 4) and 1 zero (odd). Z should be 1 again.
    for i in 1 to 3 loop
      X_tb <= '1';
      wait for CLK_PERIOD;
      ones_count <= ones_count + 1;
    end loop;
    report "Input: 1x3 | Ones: " & integer'image(ones_count + 3) & " | Zeros: " & integer'image(zeros_count) & " -> Z=" & std_logic'image(Z_tb) & " (EXPECT 1)";

    -- Test 4: Input a 0. Zeros becomes 2 (even). Z should drop to 0.
    X_tb <= '0';
    wait for CLK_PERIOD;
    zeros_count <= zeros_count + 1;
    report "Input: 0 | Ones: " & integer'image(ones_count) & " | Zeros: " & integer'image(zeros_count + 1) & " -> Z=" & std_logic'image(Z_tb) & " (EXPECT 0)";

    -- Test 5: Input another 0. Zeros becomes 3 (odd). Z should be 1 again.
    X_tb <= '0';
    wait for CLK_PERIOD;
    zeros_count <= zeros_count + 1;
    report "Input: 0 | Ones: " & integer'image(ones_count) & " | Zeros: " & integer'image(zeros_count + 1) & " -> Z=" & std_logic'image(Z_tb) & " (EXPECT 1)";

    report "===========================================================";
    report " SIMULATION COMPLETE";
    report "===========================================================";

    -- End simulation safely
    wait;
  end process;

end Behavioral;
