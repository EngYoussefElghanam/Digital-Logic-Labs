library ieee;
use ieee.std_logic_1164.all;

entity ripple_adder_subtractor_4bit is
  port (
    a        : in std_logic_vector(3 downto 0);
    b        : in std_logic_vector(3 downto 0);
    mode     : in std_logic; -- 0 = add, 1 = subtract
    result   : out std_logic_vector(3 downto 0);
    cout     : out std_logic;
    overflow : out std_logic
  );
end entity ripple_adder_subtractor_4bit;

architecture structural of ripple_adder_subtractor_4bit is

  component full_adder is
    port (
      a    : in std_logic;
      b    : in std_logic;
      cin  : in std_logic;
      sum  : out std_logic;
      cout : out std_logic
    );
  end component;

  signal bx : std_logic_vector(3 downto 0);
  signal c  : std_logic_vector(4 downto 0);

begin

  -- If mode = 0 => bx = b
  -- If mode = 1 => bx = not b
  bx(0) <= b(0) xor mode;
  bx(1) <= b(1) xor mode;
  bx(2) <= b(2) xor mode;
  bx(3) <= b(3) xor mode;

  -- Initial carry:
  -- 0 for addition
  -- 1 for subtraction
  c(0) <= mode;

  fa0 : full_adder
  port map
  (
    a    => a(0),
    b    => bx(0),
    cin  => c(0),
    sum  => result(0),
    cout => c(1)
  );

  fa1 : full_adder
  port map
  (
    a    => a(1),
    b    => bx(1),
    cin  => c(1),
    sum  => result(1),
    cout => c(2)
  );

  fa2 : full_adder
  port map
  (
    a    => a(2),
    b    => bx(2),
    cin  => c(2),
    sum  => result(2),
    cout => c(3)
  );

  fa3 : full_adder
  port map
  (
    a    => a(3),
    b    => bx(3),
    cin  => c(3),
    sum  => result(3),
    cout => c(4)
  );

  cout <= c(4);

  -- Signed overflow detection
  overflow <= c(3) xor c(4);

end architecture structural;