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

  -- Component declaration for the JK Flip-Flop
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

  -- Tied to '0' as per original design requirements
  signal rst_tie : std_logic := '0';

begin

  -- ==========================================
  -- Next State Logic (From K-Maps)
  -- ==========================================
  J2 <= not X; 
  K2 <= not X; 

  J1 <= Q0 and X; 
  K1 <= Q0 and X; 

  J0 <= X; 
  K0 <= X; 

  -- ==========================================
  -- Output Logic (Moore Model)
  -- ==========================================
  Z <= Q2 and (not Q1) and (not Q0); 

  -- ==========================================
  -- Component Instantiations (Fixed multi-line syntax)
  -- ==========================================

  -- Instantiate Flip-Flop 2
  FF2 : jk_flipflop port map (
    clk => Clk,
    rst => rst_tie,
    J   => J2,
    K   => K2,
    Q   => Q2
  );

  -- Instantiate Flip-Flop 1
  FF1 : jk_flipflop port map (
    clk => Clk,
    rst => rst_tie,
    J   => J1,
    K   => K1,
    Q   => Q1
  );

  -- Instantiate Flip-Flop 0
  FF0 : jk_flipflop port map (
    clk => Clk,
    rst => rst_tie,
    J   => J0,
    K   => K0,
    Q   => Q0
  );

end Structural;
