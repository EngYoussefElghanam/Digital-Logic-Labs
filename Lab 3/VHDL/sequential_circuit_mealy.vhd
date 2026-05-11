--------------------------------------------------------------------------------
-- Alexandria University - Faculty of Engineering
-- Computer and Systems Engineering Department
-- CSE 132: Digital Systems Design - Spring 2025
-- Lab 3: Sequential Circuit with Mealy Output (BONUS)
--------------------------------------------------------------------------------
-- Description:
--   Mealy-type sequential circuit that outputs Z=1 iff:
--   - Total number of 1's received is divisible by 4, AND
--   - Total number of 0's received is odd
--
-- Key Difference from Moore:
--   In Mealy model, output depends on BOTH current state AND current input
--   This means output can change before the clock edge (combinational)
--
-- Author: Student Solution
-- Date: May 2025
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sequential_circuit_mealy is
    Port (
        X   : in  STD_LOGIC;  -- Input signal
        Clk : in  STD_LOGIC;  -- Clock signal (state changes on rising edge)
        Z   : out STD_LOGIC   -- Mealy output (depends on state AND input)
    );
end sequential_circuit_mealy;

architecture Behavioral of sequential_circuit_mealy is
    
    -- Same state encoding as Moore model
    -- We track: (ones_count_mod4, zeros_count_mod2)
    
    type state_type is (
        S_0_EVEN,  -- 0 ones mod 4, even zeros
        S_0_ODD,   -- 0 ones mod 4, odd zeros
        S_1_EVEN,  -- 1 one mod 4,  even zeros
        S_1_ODD,   -- 1 one mod 4,  odd zeros
        S_2_EVEN,  -- 2 ones mod 4, even zeros
        S_2_ODD,   -- 2 ones mod 4, odd zeros
        S_3_EVEN,  -- 3 ones mod 4, even zeros
        S_3_ODD    -- 3 ones mod 4, odd zeros
    );
    
    signal current_state, next_state : state_type := S_0_EVEN;
    
begin
    
    -- State Register: Updates state on rising edge of clock
    state_register: process(Clk)
    begin
        if rising_edge(Clk) then
            current_state <= next_state;
        end if;
    end process;
    
    -- Combined Next State and Output Logic (Mealy)
    -- Output is determined by looking at what the next state WILL BE
    mealy_logic: process(current_state, X)
    begin
        -- Default output
        Z <= '0';
        
        case current_state is
            
            when S_0_EVEN =>  -- 0 ones (mod 4), even zeros
                if X = '0' then
                    next_state <= S_0_ODD;   -- Going to state with odd zeros
                    Z <= '1';                -- Output 1 because we'll be in S_0_ODD
                else
                    next_state <= S_1_EVEN;
                    Z <= '0';
                end if;
            
            when S_0_ODD =>   -- 0 ones (mod 4), odd zeros
                if X = '0' then
                    next_state <= S_0_EVEN;  -- Going back to even zeros
                    Z <= '0';
                else
                    next_state <= S_1_ODD;
                    Z <= '0';
                end if;
            
            when S_1_EVEN =>  -- 1 one (mod 4), even zeros
                if X = '0' then
                    next_state <= S_1_ODD;
                    Z <= '0';
                else
                    next_state <= S_2_EVEN;
                    Z <= '0';
                end if;
            
            when S_1_ODD =>   -- 1 one (mod 4), odd zeros
                if X = '0' then
                    next_state <= S_1_EVEN;
                    Z <= '0';
                else
                    next_state <= S_2_ODD;
                    Z <= '0';
                end if;
            
            when S_2_EVEN =>  -- 2 ones (mod 4), even zeros
                if X = '0' then
                    next_state <= S_2_ODD;
                    Z <= '0';
                else
                    next_state <= S_3_EVEN;
                    Z <= '0';
                end if;
            
            when S_2_ODD =>   -- 2 ones (mod 4), odd zeros
                if X = '0' then
                    next_state <= S_2_EVEN;
                    Z <= '0';
                else
                    next_state <= S_3_ODD;
                    Z <= '0';
                end if;
            
            when S_3_EVEN =>  -- 3 ones (mod 4), even zeros
                if X = '0' then
                    next_state <= S_3_ODD;
                    Z <= '0';
                else
                    next_state <= S_0_EVEN;  -- Wrapping back to 0 ones (4 mod 4)
                    Z <= '0';
                end if;
            
            when S_3_ODD =>   -- 3 ones (mod 4), odd zeros
                if X = '0' then
                    next_state <= S_3_EVEN;
                    Z <= '0';
                else
                    next_state <= S_0_ODD;   -- Wrapping to 0 ones, keeping odd zeros
                    Z <= '1';                -- Output 1 because we'll be in S_0_ODD
                end if;
            
            when others =>
                next_state <= S_0_EVEN;
                Z <= '0';
                
        end case;
    end process;
    
end Behavioral;
