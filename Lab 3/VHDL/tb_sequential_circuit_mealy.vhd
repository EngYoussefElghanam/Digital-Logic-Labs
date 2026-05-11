--------------------------------------------------------------------------------
-- Testbench for Mealy Model Sequential Circuit
-- CSE 132: Digital Systems Design - Lab 3 (BONUS)
--------------------------------------------------------------------------------
-- This testbench verifies the Mealy model implementation
-- Key Difference: In Mealy, output can change BEFORE the clock edge
--                 when input X changes (combinational)
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sequential_circuit_mealy is
end tb_sequential_circuit_mealy;

architecture Behavioral of tb_sequential_circuit_mealy is
    
    -- Component Declaration
    component sequential_circuit_mealy
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
    
begin
    
    -- Instantiate the Unit Under Test (UUT)
    uut: sequential_circuit_mealy
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
    
    -- Stimulus process
    stim_proc: process
    begin
        
        report "========================================";
        report "Starting Mealy Model Testbench";
        report "========================================";
        report "NOTE: In Mealy model, Z can change BEFORE clock edge";
        report "      when input X changes (combinational logic)";
        report "";
        
        -- Wait for initial state stabilization
        wait for CLK_PERIOD * 2;
        
        report "TEST 1: Same sequence as Moore test";
        report "Compare timing differences between Moore and Mealy";
        report "Input sequence: 0, 1, 0, 1, 0, 1, 0, 1";
        report "";
        
        -- Input 0 (zeros will become 1, ones=0)
        X_tb <= '0';
        wait for 1 ns;  -- Small delay to see combinational output change
        report "X changed to 0, Z (before clock)=" & std_logic'image(Z_tb) & " [Mealy: Z changes immediately]";
        wait for CLK_PERIOD - 1 ns;
        zeros_count <= zeros_count + 1;
        report "After clock edge: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb);
        report "";
        
        -- Input 1 (zeros=1, ones will become 1)
        X_tb <= '1';
        wait for 1 ns;
        report "X changed to 1, Z (before clock)=" & std_logic'image(Z_tb);
        wait for CLK_PERIOD - 1 ns;
        ones_count <= ones_count + 1;
        report "After clock edge: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb);
        report "";
        
        -- Continue with more inputs
        for i in 1 to 6 loop
            X_tb <= '0';
            wait for 1 ns;
            report "X changed to 0, Z (before clock)=" & std_logic'image(Z_tb);
            wait for CLK_PERIOD - 1 ns;
            zeros_count <= zeros_count + 1;
            report "After clock: ones=" & integer'image(ones_count) & 
                   ", zeros=" & integer'image(zeros_count) & 
                   ", Z=" & std_logic'image(Z_tb);
            report "";
            
            X_tb <= '1';
            wait for 1 ns;
            report "X changed to 1, Z (before clock)=" & std_logic'image(Z_tb);
            wait for CLK_PERIOD - 1 ns;
            ones_count <= ones_count + 1;
            report "After clock: ones=" & integer'image(ones_count) & 
                   ", zeros=" & integer'image(zeros_count) & 
                   ", Z=" & std_logic'image(Z_tb);
            report "";
        end loop;
        
        report "========================================";
        report "TEST 2: Demonstrating Mealy early response";
        report "========================================";
        report "";
        
        -- Reset for clearer demonstration
        ones_count <= 0;
        zeros_count <= 0;
        wait for CLK_PERIOD * 2;
        
        report "Fresh start: ones=0, zeros=0";
        report "Input sequence: 1,1,1,1,0";
        report "After 4 ones: ones=4 (divisible by 4), zeros=0 (even)";
        report "When X becomes 0: zeros will become 1 (odd)";
        report "MEALY: Z=1 appears IMMEDIATELY when X=0";
        report "MOORE: Z=1 appears AFTER the clock edge";
        report "";
        
        -- Input four 1's
        for i in 1 to 4 loop
            X_tb <= '1';
            wait for CLK_PERIOD;
            ones_count <= ones_count + 1;
            report "Input 1, After clock: ones=" & integer'image(ones_count) & 
                   ", zeros=" & integer'image(zeros_count) & 
                   ", Z=" & std_logic'image(Z_tb);
        end loop;
        
        report "";
        report "Now inputting 0 - WATCH Z:";
        X_tb <= '0';
        wait for 1 ns;
        report ">>> MEALY: Z=" & std_logic'image(Z_tb) & " (IMMEDIATELY after X change!)";
        wait for CLK_PERIOD - 1 ns;
        zeros_count <= zeros_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & 
               ", Z=" & std_logic'image(Z_tb);
        report "";
        
        report "========================================";
        report "TEST 3: Another Mealy demonstration";
        report "========================================";
        report "Current: ones=4, zeros=1 (Z should be 1)";
        report "Input 1 to get ones=5, zeros=1";
        report "Then input 1,1,1 to get ones=8, zeros=1";
        report "At ones=8, zeros=1: should satisfy Z=1 again";
        report "";
        
        -- Already at ones=4, zeros=1
        X_tb <= '1';
        wait for 1 ns;
        report "X=1, Z (before clock)=" & std_logic'image(Z_tb);
        wait for CLK_PERIOD - 1 ns;
        ones_count <= ones_count + 1;
        report "After clock: ones=" & integer'image(ones_count) & 
               ", zeros=" & integer'image(zeros_count) & ", Z=" & std_logic'image(Z_tb);
        
        -- Three more 1's to reach 8 ones
        for i in 1 to 3 loop
            X_tb <= '1';
            wait for 1 ns;
            report "X=1, Z (before clock)=" & std_logic'image(Z_tb);
            wait for CLK_PERIOD - 1 ns;
            ones_count <= ones_count + 1;
            report "After clock: ones=" & integer'image(ones_count) & 
                   ", zeros=" & integer'image(zeros_count) & ", Z=" & std_logic'image(Z_tb);
        end loop;
        
        report "";
        report "========================================";
        report "Mealy Model Testbench Complete";
        report "========================================";
        report "Key observations:";
        report "1. Mealy output responds IMMEDIATELY to input changes";
        report "2. Moore output changes only AFTER clock edges";
        report "3. Same functional behavior, different timing";
        report "";
        
        wait;
    end process;
    
end Behavioral;
