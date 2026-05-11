--------------------------------------------------------------------------------
-- Alexandria University - Faculty of Engineering
-- Computer and Systems Engineering Department
-- CSE 132: Digital Systems Design - Spring 2025
-- Lab 3: Sequential Circuit with Moore Output
--------------------------------------------------------------------------------
-- Description:
--   Moore-type sequential circuit that outputs Z=1 iff:
--   - Total number of 1's received is divisible by 4, AND
--   - Total number of 0's received is odd
--
-- Author: Student Solution
-- Date: May 2025
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sequential_circuit_moore is
    Port (
        X   : in  STD_LOGIC;  -- Input signal
        Clk : in  STD_LOGIC;  -- Clock signal (events on rising edge)
        Z   : out STD_LOGIC   -- Moore output (depends only on state)
    );
end sequential_circuit_moore;

architecture Behavioral of sequential_circuit_moore is
    
    -- State encoding: 3 bits representing (ones_count_mod4, zeros_count_mod2)
    -- ones_count_mod4 uses 2 bits: "00"=0, "01"=1, "10"=2, "11"=3
    -- zeros_count_mod2 uses 1 bit: '0'=even, '1'=odd
    
    type state_type is (
        S_0_EVEN,  -- 0 ones mod 4, even zeros -> Z=0
        S_0_ODD,   -- 0 ones mod 4, odd zeros  -> Z=1
        S_1_EVEN,  -- 1 one mod 4,  even zeros -> Z=0
        S_1_ODD,   -- 1 one mod 4,  odd zeros  -> Z=0
        S_2_EVEN,  -- 2 ones mod 4, even zeros -> Z=0
        S_2_ODD,   -- 2 ones mod 4, odd zeros  -> Z=0
        S_3_EVEN,  -- 3 ones mod 4, even zeros -> Z=0
        S_3_ODD    -- 3 ones mod 4, odd zeros  -> Z=0
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
    
    -- Next State Logic: Determines next state based on current state and input X
    next_state_logic: process(current_state, X)
    begin
        case current_state is
            
            when S_0_EVEN =>  -- 0 ones (mod 4), even zeros
                if X = '0' then
                    next_state <= S_0_ODD;   -- Still 0 ones, now odd zeros
                else
                    next_state <= S_1_EVEN;  -- Now 1 one, still even zeros
                end if;
            
            when S_0_ODD =>   -- 0 ones (mod 4), odd zeros
                if X = '0' then
                    next_state <= S_0_EVEN;  -- Still 0 ones, now even zeros
                else
                    next_state <= S_1_ODD;   -- Now 1 one, still odd zeros
                end if;
            
            when S_1_EVEN =>  -- 1 one (mod 4), even zeros
                if X = '0' then
                    next_state <= S_1_ODD;   -- Still 1 one, now odd zeros
                else
                    next_state <= S_2_EVEN;  -- Now 2 ones, still even zeros
                end if;
            
            when S_1_ODD =>   -- 1 one (mod 4), odd zeros
                if X = '0' then
                    next_state <= S_1_EVEN;  -- Still 1 one, now even zeros
                else
                    next_state <= S_2_ODD;   -- Now 2 ones, still odd zeros
                end if;
            
            when S_2_EVEN =>  -- 2 ones (mod 4), even zeros
                if X = '0' then
                    next_state <= S_2_ODD;   -- Still 2 ones, now odd zeros
                else
                    next_state <= S_3_EVEN;  -- Now 3 ones, still even zeros
                end if;
            
            when S_2_ODD =>   -- 2 ones (mod 4), odd zeros
                if X = '0' then
                    next_state <= S_2_EVEN;  -- Still 2 ones, now even zeros
                else
                    next_state <= S_3_ODD;   -- Now 3 ones, still odd zeros
                end if;
            
            when S_3_EVEN =>  -- 3 ones (mod 4), even zeros
                if X = '0' then
                    next_state <= S_3_ODD;   -- Still 3 ones, now odd zeros
                else
                    next_state <= S_0_EVEN;  -- Now 0 ones (4 mod 4), still even zeros
                end if;
            
            when S_3_ODD =>   -- 3 ones (mod 4), odd zeros
                if X = '0' then
                    next_state <= S_3_EVEN;  -- Still 3 ones, now even zeros
                else
                    next_state <= S_0_ODD;   -- Now 0 ones (4 mod 4), still odd zeros
                end if;
            
            when others =>
                next_state <= S_0_EVEN;
                
        end case;
    end process;
    
    -- Output Logic (Moore): Output depends ONLY on current state
    output_logic: process(current_state)
    begin
        case current_state is
            when S_0_ODD =>
                Z <= '1';  -- Only state where Z=1 (0 ones mod 4, odd zeros)
            when others =>
                Z <= '0';  -- All other states output 0
        end case;
    end process;
    
end Behavioral;
