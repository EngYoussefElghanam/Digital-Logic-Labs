library ieee;
  use ieee.std_logic_1164.all;

entity full_adder is
  port (
    a    : in    std_logic;
    b    : in    std_logic;
    cin  : in    std_logic;
    sum  : out   std_logic;
    cout : out   std_logic
  );
end entity full_adder;

architecture full_adder_arch of full_adder is

  -- Component declaration for Half Adder
  -- this is the building block we will use to construct the full Equivalent to #include <file.h> but done manually
  component half_adder is
    port (
      a     : in    std_logic;
      b     : in    std_logic;
      sum   : out   std_logic;
      carry : out   std_logic
    );
  end component half_adder;

  -- Internal signals for intermediate values
  signal temp_sum : std_logic;
  signal carry1   : std_logic;
  signal carry2   : std_logic;

-- implementation

begin

  -- First Half Adder: A + B
  ha1 : component half_adder
    -- this port map is vhdl way to connect inputs and outputs like logisim's one
    port map (
      a     => a,
      b     => b,
      sum   => temp_sum,
      carry => carry1
    );

  -- Second Half Adder: temp_sum + Cin
  ha2 : component half_adder
    port map (
      a     => temp_sum,
      b     => cin,
      sum   => sum,
      carry => carry2
    );

  -- Final carry out
  cout <= carry1 or carry2;

end architecture full_adder_arch;
