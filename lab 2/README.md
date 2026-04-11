# Lab 2 Summary

This README documents what is currently implemented in Lab 2, what has not been completed yet, and the assumptions used in the FSM designs.

## Assumption Used In This Lab

For the counter designs, we assume valid states and valid control values.

- For split counters:
  - even_counter_fsm uses only even states.
  - odd_counter_fsm uses only odd states.
- For the combined counter:
  - x is assumed to be either '0' or '1'.
  - Other x values are intentionally undefined.

## Folder Contents

- CSE_132_Digital_Lab_2.pdf
  - Main lab handout/specification.
- VHDL/
  - VHDL source files and testbench.
- images and pdfs/
  - Supporting diagrams and generated documents.
- spreadsheets/
  - Supporting tables/calculations.

## VHDL Files And Current Status

### 1) JK Flip-Flop

File: VHDL/JKFF.vhdl

Status: Completed

Implemented:
- Edge-triggered JK flip-flop.
- Asynchronous active-high reset.
- Full JK behavior on rising edge:
  - J=0, K=0 -> hold
  - J=0, K=1 -> reset
  - J=1, K=0 -> set
  - J=1, K=1 -> toggle
- Complementary output q_bar.

Notes:
- Includes defensive handling for non-binary logic values on j/k.

### 2) JK Flip-Flop Testbench

File: VHDL/JKFF_tb.vhdl

Status: Completed (basic functional coverage)

Implemented:
- Clock generation.
- Reset pulse.
- Directed tests for set, reset, hold, and toggle behavior.

What is still not done:
- Automatic self-checking with assert statements.
- Waveform dump setup notes in this file.
- Corner-case tests for unknown logic values.

### 3) Combined Even/Odd Counter FSM (single file)

File: VHDL/even_odd_counter_fsm.vhdl

Status: Implemented but marked as extra

Implemented:
- 16-state Moore FSM (s0..s15).
- x selects path:
  - x='0' follows even progression.
  - x='1' follows odd progression.
- Output decode for all 16 values.

Notes:
- This file is kept as an extra/reference implementation.
- It is not required if you use the split even/odd files below.

### 4) Even Counter FSM (split design)

File: VHDL/even_counter_fsm.vhdl

Status: Completed

Implemented:
- Dedicated even-state FSM only:
  s0 -> s2 -> s4 -> s6 -> s8 -> s10 -> s12 -> s14 -> s0
- Moore output decode for even values only.
- Synchronous active-high reset to s0.

Design intent:
- No odd-state handling.
- No mixed-mode transitions.

### 5) Odd Counter FSM (split design)

File: VHDL/odd_counter_fsm.vhdl

Status: Completed

Implemented:
- Dedicated odd-state FSM only:
  s1 -> s3 -> s5 -> s7 -> s9 -> s11 -> s13 -> s15 -> s1
- Moore output decode for odd values only.
- Synchronous active-high reset to s1.

Design intent:
- No even-state handling.
- No mixed-mode transitions.

## What Has Been Done

- JK flip-flop entity/architecture completed.
- JK flip-flop testbench created and runs basic directed stimulus.
- Even/odd counter explored in two approaches:
  - Single-file combined FSM.
  - Two-file split FSM (even and odd), which is cleaner for state-graph visualization.
- **Valid-state assumption was made**.
