````md
# 4-Bit Ripple Adder/Subtractor Using Full Adders

## Overview
This design implements a **4-bit ripple adder/subtractor** using **four 1-bit full adders** connected in cascade.  
It can perform both operations using a single control signal called `mode`.

- `mode = '0'` → **Addition** (`A + B`)
- `mode = '1'` → **Subtraction** (`A - B`)

The subtraction is done using **2’s complement**:

\[
A - B = A + B' + 1
\]

---

## Main Idea
To make the same circuit perform both addition and subtraction:

1. Each bit of `B` is XORed with `mode`
   - If `mode = 0`, then `B xor 0 = B` → normal addition
   - If `mode = 1`, then `B xor 1 = \overline{B}` → invert `B` for subtraction

2. The initial carry input is set to `mode`
   - If `mode = 0`, initial carry = `0`
   - If `mode = 1`, initial carry = `1`

So the circuit performs:
- **Addition:** `A + B`
- **Subtraction:** `A + not(B) + 1`

---

## Internal Signals
- `bx(3 downto 0)`  
  Stores the modified version of input `B`

- `c(4 downto 0)`  
  Stores the carry chain between the four full adders

---

## Implementation
### 1. Modify input `B`
Each bit of `B` is XORed with `mode`:

```vhdl
bx(0) <= b(0) xor mode;
bx(1) <= b(1) xor mode;
bx(2) <= b(2) xor mode;
bx(3) <= b(3) xor mode;
````

This allows the circuit to either pass `B` unchanged or invert it.

---

### 2. Set the initial carry

```vhdl
c(0) <= mode;
```

This provides the extra `+1` required in 2’s complement subtraction.

---

### 3. Cascade four full adders

Each full adder handles one bit:

* `fa0` handles bit 0
* `fa1` handles bit 1
* `fa2` handles bit 2
* `fa3` handles bit 3

The carry output of each stage is connected to the carry input of the next stage.
This is why it is called a **ripple** adder/subtractor.

---

### 4. Final outputs

* `result(3 downto 0)` gives the 4-bit answer
* `cout` is the final carry out
* `overflow` detects signed overflow

```vhdl
cout <= c(4);
overflow <= c(3) xor c(4);
```

---

## Overflow Detection

Overflow is detected using:

```vhdl
overflow <= c(3) xor c(4);
```

Where:

* `c(3)` = carry into the most significant bit
* `c(4)` = carry out of the most significant bit

If these two carries are different, then **signed overflow** occurred.

---

## Why It Is Called Ripple Adder

The carry signal moves from one full adder to the next:

* first adder produces carry
* second adder uses it
* third adder uses the next carry
* fourth adder uses the next carry

So the carry **ripples** through the circuit from LSB to MSB.

---

## Summary

This 4-bit ripple adder/subtractor is built from four full adders and uses a control signal `mode` to select between addition and subtraction.
By XORing `B` with `mode` and setting the first carry input equal to `mode`, the circuit can perform:

* `A + B` when `mode = 0`
* `A - B` when `mode = 1`

This is a simple and modular implementation of arithmetic operations in VHDL.