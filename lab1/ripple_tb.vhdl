library ieee;
use ieee.std_logic_1164.all;

entity ripple_tb is
end entity ripple_tb;

architecture behavior of ripple_tb is

  component ripple_adder_subtractor_4bit
    port(
      a        : in  std_logic_vector(3 downto 0);
      b        : in  std_logic_vector(3 downto 0);
      mode     : in  std_logic;
      result   : out std_logic_vector(3 downto 0);
      cout     : out std_logic;
      overflow : out std_logic
    );
  end component;

  signal a        : std_logic_vector(3 downto 0);
  signal b        : std_logic_vector(3 downto 0);
  signal mode     : std_logic;
  signal result   : std_logic_vector(3 downto 0);
  signal cout     : std_logic;
  signal overflow : std_logic;

begin

  uut: ripple_adder_subtractor_4bit
    port map(
      a => a,
      b => b,
      mode => mode,
      result => result,
      cout => cout,
      overflow => overflow
    );

  stim_proc: process
  begin
  
  --addition test

  mode <= '0';

  a <= "0001"; b <= "0001"; -- 1 + 1 = 2
  wait for 10 ns;

  a <= "0011"; b <= "0010"; -- 3 + 2 = 5
  wait for 10 ns;

  a <= "0111"; b <= "0011"; -- 7 + 3 = 10
  wait for 10 ns;

  a <= "1111"; b <= "0001"; -- 15 + 1 = 0, cout = 1
  wait for 10 ns;

  a <= "1010"; b <= "0110"; -- 10 + 6 = 16 , cout = '1'
  wait for 10 ns;

  a <= "0111"; b <= "0001"; -- 7 + 1 , overflow = '1'
  wait for 10 ns;

  --subtraction test

  mode <= '1';

  a <= "0101"; b <= "0011";  -- 5 - 3 = 2
  wait for 10 ns;

  a <= "0100"; b <= "0100";  -- 4 - 4 = 0
  wait for 10 ns;

  a <= "0011"; b <= "0101";  -- 3 - 5 = -2
  wait for 10 ns;

  a <= "1000"; b <= "0001";  -- 8 - 1 = 7
  wait for 10 ns;

  a <= "0000"; b <= "0001";  -- 0 - 1 , cout = '0'
  wait for 10 ns;

  wait;

end process;

end architecture behavior;