# 4-bit_ripple_test_benches.md

## Overview

This document explains the **testbench for the 4-bit ripple adder/subtractor** (`4-bit_ripple.vhdl`) and how it operates in simulation using GHDL and GTKWave. The testbench is in `ripple_tb.vhdl`.

The **purpose** of the testbench:

- Verify correct **addition** and **subtraction** for a 4-bit ripple adder/subtractor.
- Catch errors using `assert` statements.
- Produce a **waveform** for easy visual verification.

---

## 1. Testbench Structure

### Entity

```
entity ripple_adder_tb is
end entity ripple_adder_tb;
```
The testbench does not have inputs or outputs — it’s a self-contained simulation entity.

The entity name must match the file name (without `.vhdl`) for GHDL.

### Architecture
```
architecture testbench of ripple_adder_tb is
```
Contains all **signals, component declarations**, and the **test process**.

### Component Declaration
```
component ripple_adder_subtractor_4bit is
  port (
    a        : in  std_logic_vector(3 downto 0);
    b        : in  std_logic_vector(3 downto 0);
    mode     : in  std_logic;
    result   : out std_logic_vector(3 downto 0);
    cout     : out std_logic;
    overflow : out std_logic
  );
end component;
```
Declares the **Device Under Test (DUT)**.

### Signals
```
signal test_a        : std_logic_vector(3 downto 0);
signal test_b        : std_logic_vector(3 downto 0);
signal test_mode     : std_logic;
signal test_result   : std_logic_vector(3 downto 0);
signal test_cout     : std_logic;
signal test_overflow : std_logic;
```

* `test_a`, `test_b`: 4-bit input vectors.

* `test_mode`: `'0'` for addition, `'1'` for subtraction.

* `test_result`: 4-bit output of the adder/subtractor.

* `test_cout`: carry out (used in addition/subtraction).

* `test_overflow`: detects signed overflow.

Signals are initialized to avoid undefined values.

### DUT Instantiation
```
dut : component ripple_adder_subtractor_4bit
  port map (
    a        => test_a,
    b        => test_b,
    mode     => test_mode,
    result   => test_result,
    cout     => test_cout,
    overflow => test_overflow
  );
```
## 2. Test Process

* Sequential process applies **input vectors**, waits 20 ns per test, and checks outputs with `assert`.

* `wait;` at the end keeps the waveform visible.

### Test Cases

**1. Addition** (`mode = 0`)

* `0001 + 0001 = 0010`

* `0011 + 0010 = 0101`

* `0111 + 0001 = 1000`

* `1111 + 0001 = 0000` (carry `'1'`)

**2. Subtraction** (`mode = 1`)

* `0101 - 0011 = 0010`

* `0100 - 0100 = 0000`

* `0011 - 0101 = 1110 (negative in 2’s complement)`

* `1000 - 0001 = 0111`

* Each test waits 20 ns to allow signal propagation.

## 3. Assertions
```
assert test_result = "0010"
  report "Addition Test 1 failed"
  severity error;
```
* Automatically verifies outputs.

* Errors are printed in the terminal if a test fails.

* Correct simulation passes all assertions and prints:
```
All Ripple Adder/Subtractor tests passed!
```
## 4. Waveform Diagram (ASCII)
```
Time(ns)   0    20    40    60    80    100   120   140
---------------------------------------------------------
test_a     0000 0001 0010 0011 0100 0101 0110 0111
test_b     0000 0001 0001 0010 0010 0011 0011 0100
mode       0    0    0    0    1    1    1    1
---------------------------------------------------------
result     0000 0010 0011 0101 0011 0010 0001 0000
cout       0    0    0    0    0    0    1    1
overflow   0    0    0    0    0    0    0    1
```
* `test_a` and `test_b` change every 20 ns.

* `mode` indicates **addition (0)** or **subtraction (1)**.

* `result`, `cout`, `overflow` show expected outputs.

## 5. Running in GHDL and GTKWave
```
make test_ripple     # run all test cases
make wave_ripple     # generate VCD waveform
make view_ripple     # open waveform in GTKWave
```
* Waveform shows signals: `test_a`, `test_b`, `test_mode`, `test_result`, `test_cout`, `test_overflow`.

## 6. Summary

* Sequential testbench verifies addition and subtraction.

* Assertions catch incorrect results automatically.

* Waveform provides **visual verification** of the 4-bit ripple adder/subtractor behavior.

* ASCII diagram gives a **quick overview** of expected signal transitions.
