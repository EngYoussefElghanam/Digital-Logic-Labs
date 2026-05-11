--------------------------------------------------------------------------------
-- Testbench for Moore Model Sequential Circuit
-- CSE 132: Digital Systems Design - Lab 3
--------------------------------------------------------------------------------
-- This testbench verifies the Moore model implementation by:
-- 1. Testing multiple input sequences
-- 2. Checking output Z against expected values
-- 3. Verifying that Z=1 only when: (ones_count mod 4 = 0) AND (zeros_count is odd)
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sequential_circuit_moore is
end tb_sequential_circuit_moore;

architecture Behavioral of tb_sequential_circuit_moore is
    
    -- Component Declaration
    component sequential_circuit_moore
        Port (
            X   : in  STD_LOGIC;
            Clk : in  STD_LOGIC;
            Z   : out STD_LOGIC
        );
    end component;
    
    -- Testbench signals
    signal X_tb   : STD_LOGIC := '0';
    signal Clk_tb : STD_LOGIC := '0';
    signal Z_tb   : STD_LOGIC;
    
    -- Clock period
    constant CLK_PERIOD : time := 10 ns;
    
    -- Counters for verification
    signal ones_count : integer := 0;
    signal zeros_count : integer := 0;
    signal expected_Z : STD_LOGIC;
    
begin
    
    -- Instantiate the Unit Under Test (UUT)
    uut: sequential_circuit_moore
        Port map (
            X   => X_tb,
            Clk => Clk_tb,
            Z   => Z_tb
        );
    
    -- Clock generation process
    clk_process: process
    begin
        Clk_tb <= '0';
        wait for CLK_PERIOD/2;
        Clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Calculate expected output
    expected_output: process(ones_count, zeros_count)
    begin
        if (ones_count mod 4 = 0) and (zeros_count mod 2 = 1) then
            expected_Z <= '1';
        else
            expected_Z <= '0';
        end if;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
        
        report "========================================";
        report "Starting Moore Model Testbench";
        report "========================================";
        report "";
        
        -- Wait for initial state stabilization
        wait for CLK_PERIOD * 2;
        
        -- Test Sequence 1: Simple alternating pattern
        report "TEST 1: Alternating 0-1 pattern";
        report "Input sequence: 0, 1, 0, 1, 0, 1, 0, 1";
        report "Expected Z=1 after input 0 (1st), giving: 0 ones, 1 zero (odd)";
        
        -- Input 0 (zeros=1, ones=0) -> should give Z=1 on next cycle
        X_tb <= '0';
        wait for CLK_PERIOD;
        zeros_count <= zeros_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb) &
               ", Expected=" & std_logic'image(expected_Z);
        
        -- Input 1 (zeros=1, ones=1) -> Z=0
        X_tb <= '1';
        wait for CLK_PERIOD;
        ones_count <= ones_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb) &
               ", Expected=" & std_logic'image(expected_Z);
        
        -- Input 0 (zeros=2, ones=1) -> Z=0
        X_tb <= '0';
        wait for CLK_PERIOD;
        zeros_count <= zeros_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb) &
               ", Expected=" & std_logic'image(expected_Z);
        
        -- Input 1 (zeros=2, ones=2) -> Z=0
        X_tb <= '1';
        wait for CLK_PERIOD;
        ones_count <= ones_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb) &
               ", Expected=" & std_logic'image(expected_Z);
        
        -- Input 0 (zeros=3, ones=2) -> Z=0
        X_tb <= '0';
        wait for CLK_PERIOD;
        zeros_count <= zeros_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb) &
               ", Expected=" & std_logic'image(expected_Z);
        
        -- Input 1 (zeros=3, ones=3) -> Z=0
        X_tb <= '1';
        wait for CLK_PERIOD;
        ones_count <= ones_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb) &
               ", Expected=" & std_logic'image(expected_Z);
        
        -- Input 0 (zeros=4, ones=3) -> Z=0
        X_tb <= '0';
        wait for CLK_PERIOD;
        zeros_count <= zeros_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb) &
               ", Expected=" & std_logic'image(expected_Z);
        
        -- Input 1 (zeros=4, ones=4) -> Z=0 (even zeros)
        X_tb <= '1';
        wait for CLK_PERIOD;
        ones_count <= ones_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb) &
               ", Expected=" & std_logic'image(expected_Z);
        
        report "";
        report "----------------------------------------";
        report "TEST 2: Getting to Z=1 state again";
        report "Need: 4 ones (or 8, 12...) and odd zeros";
        report "Currently: 4 ones, 4 zeros (even)";
        report "Input one more 0 to make zeros odd";
        
        -- Input 0 (zeros=5, ones=4) -> Z=1!
        X_tb <= '0';
        wait for CLK_PERIOD;
        zeros_count <= zeros_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb) &
               ", Expected=" & std_logic'image(expected_Z);
        
        report "";
        report "----------------------------------------";
        report "TEST 3: Continuous ones to reach next Z=1";
        report "Need to get from 4 ones to 8 ones (4 more)";
        report "But zeros must stay odd (currently 5=odd)";
        
        -- Input four 1's
        for i in 1 to 4 loop
            X_tb <= '1';
            wait for CLK_PERIOD;
            ones_count <= ones_count + 1;
            report "After clock: ones=" & integer'image(ones_count) & 
                   ", zeros=" & integer'image(zeros_count) & 
                   ", Z=" & std_logic'image(Z_tb) &
                   ", Expected=" & std_logic'image(expected_Z);
        end loop;
        
        report "";
        report "----------------------------------------";
        report "TEST 4: Random sequence verification";
        
        -- Reset counters for new test
        ones_count <= 0;
        zeros_count <= 0;
        wait for CLK_PERIOD;
        
        -- Sequence: 1,1,0,1,0,0,1
        X_tb <= '1'; wait for CLK_PERIOD; ones_count <= ones_count + 1;
        report "X=1: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count) & ", Z=" & std_logic'image(Z_tb);
        
        X_tb <= '1'; wait for CLK_PERIOD; ones_count <= ones_count + 1;
        report "X=1: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count) & ", Z=" & std_logic'image(Z_tb);
        
        X_tb <= '0'; wait for CLK_PERIOD; zeros_count <= zeros_count + 1;
        report "X=0: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count) & ", Z=" & std_logic'image(Z_tb);
        
        X_tb <= '1'; wait for CLK_PERIOD; ones_count <= ones_count + 1;
        report "X=1: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count) & ", Z=" & std_logic'image(Z_tb);
        
        X_tb <= '0'; wait for CLK_PERIOD; zeros_count <= zeros_count + 1;
        report "X=0: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count) & ", Z=" & std_logic'image(Z_tb);
        
        X_tb <= '0'; wait for CLK_PERIOD; zeros_count <= zeros_count + 1;
        report "X=0: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count) & ", Z=" & std_logic'image(Z_tb);
        
        X_tb <= '1'; wait for CLK_PERIOD; ones_count <= ones_count + 1;
        report "X=1: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count) & ", Z=" & std_logic'image(Z_tb);
        
        report "";
        report "========================================";
        report "Moore Model Testbench Complete";
        report "========================================";
        report "Review the waveform and reports above";
        report "Verify Z=1 only when (ones mod 4 = 0) AND (zeros is odd)";
        
        wait;
    end process;
    
end Behavioral;
