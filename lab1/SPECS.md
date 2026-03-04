# 4-Bit Ripple Adder — Component Documentation

This document explains the two implemented VHDL modules in this folder: `half.vhdl` and `full_adder.vhdl`. It describes interfaces, behavior, and how the modules relate for building wider adders.

## Files
- `half.vhdl` — Half adder (1-bit)
- `full_adder.vhdl` — Full adder (1-bit) built from two half adders

---

## half.vhdl — Half Adder

### Purpose
Adds two 1-bit operands and produces a sum bit and a carry bit.

### Ports
- `a : in std_logic` — input bit A
- `b : in std_logic` — input bit B
- `sum : out std_logic` — A XOR B
- `carry : out std_logic` — A AND B

### Behavior
- Sum = A XOR B
- Carry = A AND B

### Truth table
| A | B | sum | carry |
|---|---|-----|-------|
| 0 | 0 |  0  |   0   |
| 0 | 1 |  1  |   0   |
| 1 | 0 |  1  |   0   |
| 1 | 1 |  0  |   1   |

---

## full_adder.vhdl — Full Adder (structural)

### Purpose
Adds A, B and carry-in (cin), producing sum and carry-out (cout). Implemented structurally by instantiating two half adders.

### Ports
- `a : in std_logic` — input bit A
- `b : in std_logic` — input bit B
- `cin : in std_logic` — carry-in
- `sum : out std_logic` — result bit
- `cout : out std_logic` — carry-out

### Internal signals (in the architecture)
- `temp_sum : std_logic` — sum output of first half adder (A + B)
- `carry1 : std_logic` — carry from first half adder
- `carry2 : std_logic` — carry from second half adder

### Structure & logic
1. HA1 computes `temp_sum` and `carry1` from `a` and `b`.
2. HA2 computes final `sum` and `carry2` from `temp_sum` and `cin`.
3. `cout` = `carry1 OR carry2`.

This implements:
- sum = (A XOR B) XOR Cin
- cout = (A AND B) OR ((A XOR B) AND Cin)

### Instantiation (as in `full_adder.vhdl`)
```vhdl
ha1 : component half_adder
  port map (
    a     => a,
    b     => b,
    sum   => temp_sum,
    carry => carry1
  );

ha2 : component half_adder
  port map (
    a     => temp_sum,
    b     => cin,
    sum   => sum,
    carry => carry2
  );

cout <= carry1 or carry2;
```

---

## Simulation / Testbench / Waveforms

- Testbenches are provided in this folder (e.g. `half_adder_tb.vhdl`, `full_adder_tb.vhdl`).
- Use the Makefile targets to build and run simulations:

  - Run full adder tests:
    ```
    make test_full
    ```
  - Produce VCD waveform and view:
    ```
    make wave_full
    make view_full
    ```
  - Or open the generated VCD directly:
    ```
    gtkwave build/full_adder.vcd
    ```

Notes:
- GTKWave lets you inspect inputs (`a`, `b`, `cin`) and outputs (`sum`, `cout`) and internal signals (`temp_sum`, `carry1`, `carry2`) to verify timing and correctness.

---

<!-- This is a hint for the people who will complete the work after me -->
## How this fits into a 4-bit ripple adder
- To create a 4-bit ripple adder, instantiate four copies of `full_adder` and chain their `cout` → next-stage `cin`. Optionally XOR the second operand bits with a `mode` bit for add/subtract functionality and set initial `cin` accordingly for two's complement subtraction.

Example chaining (conceptual):
```vhdl
FA0: full_adder port map (a=>A(0), b=>B(0), cin=>C0, sum=>S(0), cout=>C1);
FA1: full_adder port map (a=>A(1), b=>B(1), cin=>C1, sum=>S(1), cout=>C2);
...
```

---

## Troubleshooting tips
- If GTKWave appears empty, expand the signal tree and drag signals into the waveform pane, then use "Zoom Fit".
