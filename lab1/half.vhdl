library ieee;
  use ieee.std_logic_1164.all;

-- The basic interface for the half adder

entity half_adder is
  port (
    a     : in    std_logic;
    b     : in    std_logic;
    sum   : out   std_logic;
    carry : out   std_logic
  );
end entity half_adder;

-- implementation of the half adder

architecture half_adder_arch of half_adder is

begin

  sum   <= a xor b;
  carry <= a and b;

end architecture half_adder_arch;
