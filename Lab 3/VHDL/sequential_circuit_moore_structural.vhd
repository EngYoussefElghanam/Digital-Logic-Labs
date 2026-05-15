library ieee;

use ieee.std_logic_1164.all;


entity moore_structural is
  port (
    X   : in std_logic;
    Clk : in std_logic;
    Z   : out std_logic
  );

end moore_structural;

architecture Structural of moore_structural is

  -- Component declaration for the JK Flip-Flop your friends already wrote
  component jk_flipflop
    port (
      clk : in std_logic;
      rst : in std_logic;
      J   : in std_logic;
      K   : in std_logic;
      Q   : out std_logic
    );
  end component;

  -- Internal signals for the current state (Flip-Flop outputs)
  signal Q0, Q1, Q2 : std_logic;

  -- Internal signals for the next state logic (Flip-Flop inputs)
  signal J0, K0, J1, K1, J2, K2 : std_logic;

  -- The JK flip-flop component requires a reset, but the interface 
  -- doesn't provide one. We tie it to '0' so it doesn't stay stuck in reset.
  signal rst_tie : std_logic := '0';

begin
  
  -- ==========================================
  -- Next State Logic (From K-Maps)
  -- ==========================================

  -- Flip-Flop 2 (Q2)
  J2 <= not X; -- [cite: 3]
  K2 <= not X; -- [cite: 6]

  -- Flip-Flop 1 (Q1)
  J1 <= Q0 and X; -- [cite: 9]
  K1 <= Q0 and X; -- [cite: 12]

  -- Flip-Flop 0 (Q0)
  J0 <= X; -- [cite: 15]
  K0 <= X; -- [cite: 18]

  -- ==========================================
  -- Output Logic (Moore Model)
  -- ==========================================
  Z <= Q2 and (not Q1) and (not Q0); -- [cite: 21]

  -- ==========================================
  -- Component Instantiations
  -- ==========================================

  -- Instantiate Flip-Flop 2
  FF2 : jk_flipflop PORT
  map(
  clk => Clk,
  rst => rst_tie,
  J   => J2,
  K   => K2,
  Q   => Q2
  );

  -- Instantiate Flip-Flop 1
  FF1 : jk_flipflop PORT
  map(
  clk => Clk,
  rst => rst_tie,
  J   => J1,
  K   => K1,
  Q   => Q1
  );

  -- Instantiate Flip-Flop 0
  FF0 : jk_flipflop PORT
  map(
  clk => Clk,
  rst => rst_tie,
  J   => J0,
  K   => K0,
  Q   => Q0
  );

end Structural;
