# Synchronous Sequential Circuit Design: Mealy and Moore Machines

This repository contains the design, analysis, and implementation details for two synchronous sequential circuits that detect specific patterns in a bitstream.

## Problem Statement
The objective is to design a synchronous sequential circuit that processes a single input bit **X** at every positive edge of the clock. The output **Z=1** if and only if both of the following conditions are met:
1. The total number of received **1's is divisible by 4**.
2. The total number of received **0's is odd**.

## Design Specifications
* **Input**: Single bit **X**.
* **Output**: Single bit **Z** (Supports both Mealy and Moore models).
* **Hardware Target**: Implementation using **JK Flip-Flops**.
* **Update Logic**: Positive clock edge triggered.

## State Machines
The system uses three flip-flops ($Q_2, Q_1, Q_0$) to track 8 distinct states representing the combination of 1's (mod 4) and 0's parity.

### 1. Moore Machine
The output depends solely on the current state.
* **Output Equation**: $Z = Q_2 \text{ AND } (NOT\ Q_1) \text{ AND } (NOT\ Q_0)$

### 2. Mealy Machine
The output depends on both the current state and the current input.
* **Output Equation**: $Z = ((NOT\ Q_2) \text{ AND } (NOT\ Q_1) \text{ AND } (NOT\ Q_0) \text{ AND } (NOT\ X)) \text{ OR } (Q_2 \text{ AND } Q_1 \text{ AND } Q_0 \text{ AND } X)$

## Implementation Logic
Derived via Karnaugh Maps (K-maps), the excitation equations for the JK flip-flops are as follows:

| Flip-Flop | J Input Equation | K Input Equation |
| :--- | :--- | :--- |
| **FF2** | $(NOT\ X)$ | $(NOT\ X)$ |
| **FF1** | $Q_0 \text{ AND } X$ | $Q_0 \text{ AND } X$ |
| **FF0** | $X$ | $X$ |

## Files in this Repository
* **JKFF.vhdl**: VHDL behavioral description of the JK Flip-Flop component.
* **Transition Tables**: Detailed mapping of present states to next states and JK excitation values.
* **State Tables**: Tabular FSM representations for Mealy and Moore models.
* **K-Maps**: Logical simplifications for all flip-flop inputs and outputs.
* **State Graphs**: Visual diagrams showing state transitions and outputs.
