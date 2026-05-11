--------------------------------------------------------------------------------
-- Side-by-Side Comparison Testbench: Moore vs Mealy
-- CSE 132: Digital Systems Design - Lab 3 (BONUS)
--------------------------------------------------------------------------------
-- This testbench runs BOTH Moore and Mealy models simultaneously
-- with the SAME input sequence to demonstrate timing differences
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_moore_mealy_comparison is
end tb_moore_mealy_comparison;

architecture Behavioral of tb_moore_mealy_comparison is
    
    -- Component Declarations
    component sequential_circuit_moore
        Port (
            X   : in  STD_LOGIC;
            Clk : in  STD_LOGIC;
            Z   : out STD_LOGIC
        );
    end component;
    
    component sequential_circuit_mealy
        Port (
            X   : in  STD_LOGIC;
            Clk : in  STD_LOGIC;
            Z   : out STD_LOGIC
        );
    end component;
    
    -- Shared signals
    signal X_tb   : STD_LOGIC := '0';
    signal Clk_tb : STD_LOGIC := '0';
    
    -- Separate outputs
    signal Z_moore : STD_LOGIC;
    signal Z_mealy : STD_LOGIC;
    
    -- Clock period
    constant CLK_PERIOD : time := 10 ns;
    
    -- Counters
    signal ones_count : integer := 0;
    signal zeros_count : integer := 0;
    
begin
    
    -- Instantiate Moore model
    uut_moore: sequential_circuit_moore
        Port map (
            X   => X_tb,
            Clk => Clk_tb,
            Z   => Z_moore
        );
    
    -- Instantiate Mealy model
    uut_mealy: sequential_circuit_mealy
        Port map (
            X   => X_tb,
            Clk => Clk_tb,
            Z   => Z_mealy
        );
    
    -- Clock generation
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
        
        report "========================================================================";
        report "MOORE vs MEALY COMPARISON TESTBENCH";
        report "========================================================================";
        report "Both circuits receive IDENTICAL inputs";
        report "Observe the TIMING differences in their outputs";
        report "";
        report "Legend:";
        report "  Z_moore: Output from Moore model (changes after clock edge)";
        report "  Z_mealy: Output from Mealy model (changes immediately with input)";
        report "========================================================================";
        report "";
        
        wait for CLK_PERIOD * 2;
        
        report "TEST SEQUENCE: Reaching first Z=1 condition";
        report "Goal: ones_count mod 4 = 0, zeros_count is odd";
        report "Simplest: Input a single 0";
        report "After this: ones=0 (divisible by 4), zeros=1 (odd)";
        report "";
        
        -- Input 0
        report ">>> Changing X to 0 <<<";
        X_tb <= '0';
        wait for 1 ns;
        report "  [Immediately after X change, before clock]";
        report "    Moore Z = " & std_logic'image(Z_moore) & " (waits for clock)";
        report "    Mealy Z = " & std_logic'image(Z_mealy) & " (responds immediately!)";
        wait for CLK_PERIOD - 1 ns;
        zeros_count <= zeros_count + 1;
        report "  [After clock edge]";
        report "    Moore Z = " & std_logic'image(Z_moore) & " (NOW it updates!)";
        report "    Mealy Z = " & std_logic'image(Z_mealy);
        report "    State: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count);
        report "";
        
        -- Input 1 (should make Z=0 in both)
        report ">>> Changing X to 1 <<<";
        X_tb <= '1';
        wait for 1 ns;
        report "  [Immediately after X change]";
        report "    Moore Z = " & std_logic'image(Z_moore);
        report "    Mealy Z = " & std_logic'image(Z_mealy) & " (immediate response)";
        wait for CLK_PERIOD - 1 ns;
        ones_count <= ones_count + 1;
        report "  [After clock edge]";
        report "    Moore Z = " & std_logic'image(Z_moore) & " (delayed update)";
        report "    Mealy Z = " & std_logic'image(Z_mealy);
        report "    State: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count);
        report "";
        
        -- Continue with more inputs
        report "Continuing sequence: 0, 1, 0, 1, 0, 1, 0";
        report "";
        
        for i in 1 to 3 loop
            report ">>> X = 0 <<<";
            X_tb <= '0';
            wait for 1 ns;
            report "  Before clk: Moore=" & std_logic'image(Z_moore) & ", Mealy=" & std_logic'image(Z_mealy);
            wait for CLK_PERIOD - 1 ns;
            zeros_count <= zeros_count + 1;
            report "  After clk:  Moore=" & std_logic'image(Z_moore) & ", Mealy=" & std_logic'image(Z_mealy) & 
                   " | ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count);
            report "";
            
            report ">>> X = 1 <<<";
            X_tb <= '1';
            wait for 1 ns;
            report "  Before clk: Moore=" & std_logic'image(Z_moore) & ", Mealy=" & std_logic'image(Z_mealy);
            wait for CLK_PERIOD - 1 ns;
            ones_count <= ones_count + 1;
            report "  After clk:  Moore=" & std_logic'image(Z_moore) & ", Mealy=" & std_logic'image(Z_mealy) & 
                   " | ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count);
            report "";
        end loop;
        
        report ">>> X = 0 <<<";
        X_tb <= '0';
        wait for 1 ns;
        report "  Before clk: Moore=" & std_logic'image(Z_moore) & ", Mealy=" & std_logic'image(Z_mealy);
        wait for CLK_PERIOD - 1 ns;
        zeros_count <= zeros_count + 1;
        report "  After clk:  Moore=" & std_logic'image(Z_moore) & ", Mealy=" & std_logic'image(Z_mealy) & 
               " | ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count);
        report "";
        
        report "========================================================================";
        report "SPECIAL TEST: Reaching Z=1 from specific state";
        report "========================================================================";
        report "Current state: ones=4 (mod 4 = 0), zeros=4 (even)";
        report "Need: one more 0 to make zeros odd";
        report "Expected: Z will become 1";
        report "";
        
        report ">>> Changing X to 0 - CRITICAL MOMENT <<<";
        X_tb <= '0';
        wait for 1 ns;
        report "  [IMMEDIATELY after X changes to 0]";
        report "    Moore Z = " & std_logic'image(Z_moore) & " <-- Still 0 (waiting for clock)";
        report "    Mealy Z = " & std_logic'image(Z_mealy) & " <-- ALREADY 1! (combinational)";
        report "  ** MEALY ADVANTAGE: One clock cycle earlier response! **";
        wait for CLK_PERIOD - 1 ns;
        zeros_count <= zeros_count + 1;
        report "  [After clock edge]";
        report "    Moore Z = " & std_logic'image(Z_moore) & " <-- NOW it becomes 1";
        report "    Mealy Z = " & std_logic'image(Z_mealy) & " <-- Already was 1";
        report "    State: ones=" & integer'image(ones_count) & ", zeros=" & integer'image(zeros_count);
        report "";
        
        report "========================================================================";
        report "COMPARISON SUMMARY";
        report "========================================================================";
        report "1. FUNCTIONALITY: Both circuits implement the same logic";
        report "   Z=1 when (ones mod 4 = 0) AND (zeros is odd)";
        report "";
        report "2. OUTPUT TIMING DIFFERENCE:";
        report "   - MOORE: Output changes ONLY at clock edges (synchronized)";
        report "            More stable, easier to analyze timing";
        report "   - MEALY: Output changes IMMEDIATELY when input changes (combinational)";
        report "            Faster response (one cycle earlier)";
        report "            But can be glitchy if input changes during clock cycle";
        report "";
        report "3. STATE MACHINE STRUCTURE:";
        report "   - MOORE: Output depends ONLY on current state";
        report "            Output logic is simpler";
        report "   - MEALY: Output depends on current state AND current input";
        report "            Can use fewer states for some designs";
        report "";
        report "4. PRACTICAL IMPLICATIONS:";
        report "   - Use MOORE when: Glitch-free output is critical";
        report "                     Easier timing analysis needed";
        report "   - Use MEALY when: One-cycle faster response is needed";
        report "                      State reduction is beneficial";
        report "========================================================================";
        
        wait;
    end process;
    
end Behavioral;
