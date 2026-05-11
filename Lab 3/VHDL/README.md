# CSE 132 Digital Systems Design - Lab 3

# Sequential Circuit with Moore and Mealy Outputs

**Alexandria University - Faculty of Engineering**  
**Computer and Systems Engineering Department**  
**Spring 2025**

---

## Table of Contents

1. [Problem Statement](#problem-statement)
2. [Solution Overview](#solution-overview)
3. [State Machine Design](#state-machine-design)
4. [Moore Model Implementation](#moore-model-implementation)
5. [Mealy Model Implementation](#mealy-model-implementation)
6. [Moore vs Mealy Comparison](#moore-vs-mealy-comparison)
7. [Code Structure](#code-structure)
8. [How to Compile and Simulate](#how-to-compile-and-simulate)
9. [Testing Strategy](#testing-strategy)
10. [Design Decisions](#design-decisions)

---

## Problem Statement

Design a **sequential circuit** with:

- **Input:** X (single bit)
- **Output:** Z (single bit, Moore-type initially, Mealy-type for bonus)
- **Clock:** Clk (events on rising edge)

**Output Condition:**

```
Z = 1  if and only if:
  - Total number of 1's received is divisible by 4  AND
  - Total number of 0's received is an odd number
```

**Example Sequences:**

| Input Sequence | Total 1's | Total 0's | Ones mod 4 | Zeros parity | Z   |
| -------------- | --------- | --------- | ---------- | ------------ | --- |
| 0              | 0         | 1         | 0          | odd          | 1 ✓ |
| 0, 1           | 1         | 1         | 1          | odd          | 0   |
| 0, 1, 0        | 1         | 2         | 1          | even         | 0   |
| 1, 1, 1, 1, 0  | 4         | 1         | 0          | odd          | 1 ✓ |

---

## Solution Overview

### State Tracking Requirements

To determine when Z=1, we must track:

1. **Count of 1's modulo 4** (4 possible values: 0, 1, 2, 3)
2. **Count of 0's modulo 2** (2 possible values: 0=even, 1=odd)

### Total States Required

- Total states = 4 × 2 = **8 states**

### State Encoding

Each state represents: `(ones_count_mod_4, zeros_count_mod_2)`

| State Name  | Ones mod 4 | Zeros parity | Z (Moore) |
| ----------- | ---------- | ------------ | --------- |
| S_0_EVEN    | 0          | even         | 0         |
| **S_0_ODD** | **0**      | **odd**      | **1** ✓   |
| S_1_EVEN    | 1          | even         | 0         |
| S_1_ODD     | 1          | odd          | 0         |
| S_2_EVEN    | 2          | even         | 0         |
| S_2_ODD     | 2          | odd          | 0         |
| S_3_EVEN    | 3          | even         | 0         |
| S_3_ODD     | 3          | odd          | 0         |

**Note:** Only **S_0_ODD** produces Z=1 in Moore model.

---

## State Machine Design

### State Transition Table

| Current State | X=0      | X=1      | Z (Moore) |
| ------------- | -------- | -------- | --------- |
| S_0_EVEN      | S_0_ODD  | S_1_EVEN | 0         |
| **S_0_ODD**   | S_0_EVEN | S_1_ODD  | **1**     |
| S_1_EVEN      | S_1_ODD  | S_2_EVEN | 0         |
| S_1_ODD       | S_1_EVEN | S_2_ODD  | 0         |
| S_2_EVEN      | S_2_ODD  | S_3_EVEN | 0         |
| S_2_ODD       | S_2_EVEN | S_3_ODD  | 0         |
| S_3_EVEN      | S_3_ODD  | S_0_EVEN | 0         |
| S_3_ODD       | S_3_EVEN | S_0_ODD  | 0         |

### Transition Logic Explanation

**When X=0 (receiving a zero):**

- Ones count stays the same
- Zeros count toggles parity (even ↔ odd)
- State transitions vertically (within same ones_count group)

**When X=1 (receiving a one):**

- Ones count increments (mod 4): 0→1→2→3→0
- Zeros count stays the same parity
- State transitions to next ones_count group (wraps after 3)

**Example Trace:**

```
Initial: S_0_EVEN (0 ones, 0 zeros)
Input 0: S_0_ODD  (0 ones, 1 zero)  → Z=1 ✓
Input 1: S_1_ODD  (1 one,  1 zero)  → Z=0
Input 1: S_2_ODD  (2 ones, 1 zero)  → Z=0
Input 1: S_3_ODD  (3 ones, 1 zero)  → Z=0
Input 1: S_0_ODD  (4 ones, 1 zero)  → Z=1 ✓ (4 mod 4 = 0)
```

### State Diagram (Textual Representation)

```
         X=0              X=0              X=0              X=0
S_0_EVEN ←→ S_0_ODD  S_1_EVEN ←→ S_1_ODD  S_2_EVEN ←→ S_2_ODD  S_3_EVEN ←→ S_3_ODD
   |           |         |           |         |           |         |           |
   |X=1        |X=1      |X=1        |X=1      |X=1        |X=1      |X=1        |X=1
   ↓           ↓         ↓           ↓         ↓           ↓         ↓           ↓
S_1_EVEN    S_1_ODD  S_2_EVEN    S_2_ODD  S_3_EVEN    S_3_ODD  S_0_EVEN    S_0_ODD
                                                                              (Z=1)
```

---

## Moore Model Implementation

### Architecture Overview

The Moore model consists of three main processes:

1. **State Register** (Sequential Logic)
   - Updates current state on rising clock edge
   - Implements the state memory

2. **Next State Logic** (Combinational Logic)
   - Determines next state based on current state and input X
   - Implements the state transition table

3. **Output Logic** (Combinational Logic)
   - Determines output Z based ONLY on current state
   - **Key characteristic:** Output is synchronized with clock

### Key Code Sections

#### State Type Definition

```vhdl
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
```

#### State Register Process

```vhdl
state_register: process(Clk)
begin
    if rising_edge(Clk) then
        current_state <= next_state;
    end if;
end process;
```

**Explanation:**

- Executes only on rising edge of clock
- Transfers next_state to current_state
- This is the only sequential (clocked) element

#### Next State Logic Process

```vhdl
next_state_logic: process(current_state, X)
begin
    case current_state is
        when S_0_EVEN =>
            if X = '0' then
                next_state <= S_0_ODD;   -- Zeros become odd
            else
                next_state <= S_1_EVEN;  -- Ones increment
            end if;
        -- ... (similar for all 8 states)
    end case;
end process;
```

**Explanation:**

- Pure combinational logic (no clock dependency)
- Sensitivity list includes current_state and X
- Implements the complete state transition table

#### Output Logic Process

```vhdl
output_logic: process(current_state)
begin
    case current_state is
        when S_0_ODD =>
            Z <= '1';  -- ONLY state that outputs 1
        when others =>
            Z <= '0';
    end case;
end process;
```

**Explanation:**

- **Critical:** Depends ONLY on current_state, not on input X
- This is what makes it a Moore machine
- Output changes only when state changes (at clock edge)

---

## Mealy Model Implementation

### Key Difference from Moore

In **Mealy** model:

- Output depends on **both current state AND current input**
- Output can change **immediately** when input changes (before clock edge)
- This gives **one clock cycle faster response** but can be more prone to glitches

### Architecture Overview

The Mealy model has only two main sections:

1. **State Register** (Sequential Logic)
   - Same as Moore model
   - Updates state on clock edge

2. **Combined Next State and Output Logic** (Combinational Logic)
   - Determines next state AND output in same process
   - Output depends on what the next state will be

### Key Code Section

#### Combined Mealy Logic

```vhdl
mealy_logic: process(current_state, X)
begin
    Z <= '0';  -- Default output

    case current_state is
        when S_0_EVEN =>
            if X = '0' then
                next_state <= S_0_ODD;
                Z <= '1';  -- Output 1 because NEXT state will be S_0_ODD
            else
                next_state <= S_1_EVEN;
                Z <= '0';
            end if;

        when S_3_ODD =>
            if X = '0' then
                next_state <= S_3_EVEN;
                Z <= '0';
            else
                next_state <= S_0_ODD;
                Z <= '1';  -- Output 1 because NEXT state will be S_0_ODD
            end if;
        -- ... (similar for other states)
    end case;
end process;
```

**Explanation:**

- Sensitivity list includes **both** current_state and X
- Output Z is set based on where we're going (next state)
- If next state would satisfy the condition, output 1 immediately
- This means Z can change as soon as X changes, without waiting for clock

---

## Moore vs Mealy Comparison

### Timing Behavior Comparison

**Scenario:** Current state is S_3_ODD (3 ones mod 4, odd zeros)  
Input X changes to '1' (will create 4 ones mod 4, odd zeros → Z=1 condition)

```
Time:     t0        t1       t2       t3       t4
Clock:    __|‾‾|____|‾‾|____|‾‾|____|‾‾|____|‾‾|
X:        _____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
                ↑
Moore Z:  ______________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
                         ↑ (changes at clock edge)

Mealy Z:  _______|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
                 ↑ (changes immediately with X)
```

**Key Observation:** Mealy responds ONE CLOCK CYCLE EARLIER!

### Functional Comparison Table

| Aspect                | Moore Model            | Mealy Model                   |
| --------------------- | ---------------------- | ----------------------------- |
| **Output depends on** | Current state only     | Current state AND input       |
| **Output changes**    | At clock edge only     | Immediately with input        |
| **Response time**     | Slower (1 extra cycle) | Faster (immediate)            |
| **Glitches**          | Less prone             | More prone (input can glitch) |
| **Output stability**  | Very stable            | Can be unstable               |
| **Timing analysis**   | Simpler                | More complex                  |
| **Number of states**  | May need more          | Often can use fewer           |
| **Code complexity**   | Slightly simpler       | Slightly more complex         |

### When to Use Each

**Use Moore when:**

- Output stability is critical
- Glitch-free operation required
- Synchronous system design preferred
- Timing analysis must be simple
- **Example:** Control signals, enable signals, system state indicators

**Use Mealy when:**

- Fast response time is critical (one cycle matters)
- State reduction is beneficial
- Input-dependent output is natural
- **Example:** Communication protocols, data path control

---

## Code Structure

### Project Directory Layout

```
CSE132_Lab3/
├── moore/
│   └── sequential_circuit_moore.vhd       # Moore model implementation
├── mealy/
│   └── sequential_circuit_mealy.vhd       # Mealy model implementation
├── testbenches/
│   ├── tb_sequential_circuit_moore.vhd    # Moore testbench
│   ├── tb_sequential_circuit_mealy.vhd    # Mealy testbench
│   └── tb_moore_mealy_comparison.vhd      # Side-by-side comparison
├── docs/
└── README.md                               # This file
```

### File Descriptions

1. **sequential_circuit_moore.vhd**
   - Entity: `sequential_circuit_moore`
   - Ports: X (input), Clk (input), Z (output)
   - Architecture: Three-process Moore FSM

2. **sequential_circuit_mealy.vhd**
   - Entity: `sequential_circuit_mealy`
   - Ports: X (input), Clk (input), Z (output)
   - Architecture: Two-process Mealy FSM

3. **tb_sequential_circuit_moore.vhd**
   - Tests Moore model with various sequences
   - Verifies output against expected values
   - Includes detailed reporting

4. **tb_sequential_circuit_mealy.vhd**
   - Tests Mealy model with same sequences
   - Demonstrates early response characteristic
   - Shows timing differences

5. **tb_moore_mealy_comparison.vhd**
   - Runs both models simultaneously
   - Same input sequence to both
   - Direct timing comparison
   - **Use this for bonus comparison!**

---

## How to Compile and Simulate

### Using GHDL (Free, Open Source)

#### 1. Compile the Design Files

```bash
# Compile Moore model
ghdl -a moore/sequential_circuit_moore.vhd

# Compile Mealy model
ghdl -a mealy/sequential_circuit_mealy.vhd
```

#### 2. Compile the Testbenches

```bash
# Compile Moore testbench
ghdl -a testbenches/tb_sequential_circuit_moore.vhd

# Compile Mealy testbench
ghdl -a testbenches/tb_sequential_circuit_mealy.vhd

# Compile comparison testbench
ghdl -a testbenches/tb_moore_mealy_comparison.vhd
```

#### 3. Elaborate and Run

```bash
# Run Moore testbench
ghdl -e tb_sequential_circuit_moore
ghdl -r tb_sequential_circuit_moore --wave=moore_output.ghw

# Run Mealy testbench
ghdl -e tb_sequential_circuit_mealy
ghdl -r tb_sequential_circuit_mealy --wave=mealy_output.ghw

# Run comparison testbench (RECOMMENDED for bonus)
ghdl -e tb_moore_mealy_comparison
ghdl -r tb_moore_mealy_comparison --wave=comparison.ghw
```

#### 4. View Waveforms

```bash
# Using GTKWave (free waveform viewer)
gtkwave comparison.ghw
```

### Using ModelSim / Vivado

```tcl
# Create project and add files
vlib work
vmap work work

# Compile all files
vcom moore/sequential_circuit_moore.vhd
vcom mealy/sequential_circuit_mealy.vhd
vcom testbenches/tb_sequential_circuit_moore.vhd
vcom testbenches/tb_sequential_circuit_mealy.vhd
vcom testbenches/tb_moore_mealy_comparison.vhd

# Simulate Moore model
vsim tb_sequential_circuit_moore
add wave *
run -all

# Simulate comparison (for bonus)
vsim tb_moore_mealy_comparison
add wave *
run -all
```

---

## Testing Strategy

### Test Coverage

The testbenches cover:

1. **Basic Functionality**
   - Verify Z=1 when condition is met
   - Verify Z=0 when condition is not met

2. **Edge Cases**
   - Initial state (0 ones, 0 zeros)
   - Wrapping of ones counter (3 → 0 when receiving 1)
   - Toggling of zeros parity

3. **Extended Sequences**
   - Long alternating patterns
   - Consecutive same inputs
   - Random sequences

4. **Timing Verification** (comparison testbench)
   - Moore output changes at clock edge
   - Mealy output changes immediately with input
   - Both produce functionally correct outputs

### Expected Output Patterns

**For input sequence: 0**

- ones=0 (mod 4 = 0 ✓), zeros=1 (odd ✓)
- **Moore:** Z goes to 1 AFTER clock edge
- **Mealy:** Z goes to 1 IMMEDIATELY when X=0

**For input sequence: 0, 1, 1, 1, 1, 0**

- After 0: ones=0, zeros=1 → Z=1
- After 1: ones=1, zeros=1 → Z=0
- After 1: ones=2, zeros=1 → Z=0
- After 1: ones=3, zeros=1 → Z=0
- After 1: ones=4, zeros=1 → Z=0 (zeros even now... wait, no!)

Actually let me recalculate:

- Input 0: ones=0, zeros=1 → Z=1 ✓
- Input 1: ones=1, zeros=1 → Z=0
- Input 1: ones=2, zeros=1 → Z=0
- Input 1: ones=3, zeros=1 → Z=0
- Input 1: ones=4 (mod 4=0), zeros=1 (still odd) → Z=1 ✓
- Input 0: ones=4, zeros=2 (even now) → Z=0

---

## Design Decisions

### 1. State Encoding Choice

**Decision:** Used enumerated types instead of binary encoding

**Rationale:**

- More readable and maintainable code
- VHDL synthesizer handles encoding optimization
- Easier to debug and verify
- State names clearly indicate their meaning

**Alternative:** Could use 3-bit binary encoding:

```vhdl
-- bit 2-1: ones_count_mod_4 (00, 01, 10, 11)
-- bit 0:   zeros_parity (0=even, 1=odd)
```

But this sacrifices readability for no significant benefit in this design.

### 2. Process Structure

**Moore Model: Three Processes**

```vhdl
1. state_register   (sequential)
2. next_state_logic (combinational)
3. output_logic     (combinational)
```

**Rationale:**

- Clear separation of concerns
- Follows standard FSM template
- Easy to understand and modify
- Matches textbook examples

**Alternative:** Could combine next_state and output logic into one process, but separation is clearer.

**Mealy Model: Two Processes**

```vhdl
1. state_register (sequential)
2. mealy_logic    (combinational - both next state and output)
```

**Rationale:**

- Output must be computed alongside next state
- Natural to combine since output depends on transition
- Still maintains clean separation between sequential and combinational

### 3. Output Logic Implementation

**Moore:** Simple case statement on current_state

```vhdl
when S_0_ODD => Z <= '1';
when others  => Z <= '0';
```

**Mealy:** Integrated into state transition logic

```vhdl
if X = '0' then
    next_state <= S_0_ODD;
    Z <= '1';  -- Because we're going to the "1" state
else
    next_state <= S_1_EVEN;
    Z <= '0';
end if;
```

**Rationale:**

- Mealy output must "look ahead" to next state
- More efficient to compute both in same process
- Avoids redundant case analysis

### 4. Reset Strategy

**Decision:** No explicit reset signal

**Rationale:**

- Problem statement doesn't specify reset behavior
- VHDL signal initialization (`:= S_0_EVEN`) handles power-on state
- Simulation testbenches work fine without explicit reset
- Simplifies interface

**Note:** In real hardware, consider adding asynchronous or synchronous reset:

```vhdl
if rst = '1' then
    current_state <= S_0_EVEN;
elsif rising_edge(Clk) then
    current_state <= next_state;
end if;
```

### 5. Testbench Organization

**Decision:** Three separate testbenches

**Rationale:**

1. **Individual testbenches** (moore, mealy)
   - Thorough testing of each model
   - Detailed reporting
   - Easy to debug issues

2. **Comparison testbench**
   - Perfect for bonus requirement
   - Shows timing differences clearly
   - Demonstrates functional equivalence

**Alternative:** Could have one testbench with generic, but separate files are clearer.

---

## Verification Results

### Expected Waveform Characteristics

**Moore Model Waveform:**

```
Clk:  __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|
X:    ____0___1___0___1___0_______
Z:    0___0___1___0___0___0______
         ↑   ↑   ↑   ↑   ↑
         All changes align with clock rising edge
```

**Mealy Model Waveform:**

```
Clk:  __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|
X:    ____0___1___0___1___0_______
Z:    ___1__0___0___0___0________
      ↑  ↑  ↑   ↑   ↑   ↑
      Changes happen immediately when X changes!
```

**Key Observation:**

- Moore Z changes are **synchronized** with clock
- Mealy Z changes are **asynchronous** (with X)

---

## Conclusion

This lab demonstrates:

1. **Sequential circuit design** using finite state machines
2. **Difference between Moore and Mealy** models in both concept and implementation
3. **VHDL coding** for synchronous digital systems
4. **Testbench development** and verification techniques

### Skills Demonstrated

- State machine analysis and design
- VHDL process modeling (sequential vs combinational)
- Understanding of timing and synchronization
- Testbench development
- Waveform analysis

### Learning Outcomes

- Moore outputs are stable and synchronized (good for control)
- Mealy outputs are faster but can glitch (good for data paths)
- Both can implement same functionality with different timing
- Proper VHDL coding style and documentation

---

## Additional Resources

1. **VHDL Tutorial:** https://www.nandland.com/vhdl/tutorials/
2. **FSM Design Guide:** Look up "Finite State Machine Design" in your textbook
3. **GHDL Documentation:** http://ghdl.free.fr/
4. **GTKWave Tutorial:** http://gtkwave.sourceforge.net/

---

## Contact

For questions or clarifications about this lab solution
