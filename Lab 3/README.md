# Synchronous Sequential Circuit Design: Mealy and Moore Machines

[cite_start]This repository contains the design, analysis, and implementation details for two synchronous sequential circuits that detect specific patterns in a bitstream. [cite: 2, 10]

## Problem Statement
[cite_start]The objective is to design a synchronous sequential circuit that processes a single input bit **X** at every positive edge of the clock. [cite: 3, 8, 11, 16] The output **Z=1** if and only if both of the following conditions are met:
1. [cite_start]The total number of received **1's is divisible by 4**. [cite: 6, 14]
2. [cite_start]The total number of received **0's is odd**. [cite: 7, 15]

## Design Specifications
* [cite_start]**Input**: Single bit **X**. [cite: 3, 11]
* [cite_start]**Output**: Single bit **Z** (Supports both Mealy and Moore models). [cite: 4, 12]
* [cite_start]**Hardware Target**: Implementation using **JK Flip-Flops**. [cite: 17, 23, 52]
* [cite_start]**Update Logic**: Positive clock edge triggered. [cite: 8, 16, 20]

## State Machines
[cite_start]The system uses three flip-flops ($Q_2, Q_1, Q_0$) to track 8 distinct states representing the combination of 1's (mod 4) and 0's parity. [cite: 23, 52]

### 1. Moore Machine
[cite_start]The output depends solely on the current state. [cite: 12]
* [cite_start]**Output Equation**: $Z = Q_2 \text{ AND } (NOT\ Q_1) \text{ AND } (NOT\ Q_0)$ [cite: 44]

### 2. Mealy Machine
[cite_start]The output depends on both the current state and the current input. [cite: 4]
* [cite_start]**Output Equation**: $Z = ((NOT\ Q_2) \text{ AND } (NOT\ Q_1) \text{ AND } (NOT\ Q_0) \text{ AND } (NOT\ X)) \text{ OR } (Q_2 \text{ AND } Q_1 \text{ AND } Q_0 \text{ AND } X)$ [cite: 47, 48]

## Implementation Logic
[cite_start]Derived via Karnaugh Maps (K-maps), the excitation equations for the JK flip-flops are as follows: [cite: 24, 27, 30, 33, 36, 39]

| Flip-Flop | J Input Equation | K Input Equation |
| :--- | :--- | :--- |
| **FF2** | [cite_start]$(NOT\ Q_2) \text{ AND } (NOT\ X)$ [cite: 26] | [cite_start]$Q_2 \text{ AND } (NOT\ X)$ [cite: 29] |
| **FF1** | [cite_start]$(NOT\ Q_1) \text{ AND } Q_0 \text{ AND } X$ [cite: 32] | [cite_start]$Q_1 \text{ AND } Q_0 \text{ AND } X$ [cite: 35] |
| **FF0** | [cite_start]$(NOT\ Q_0) \text{ AND } X$ [cite: 38] | [cite_start]$Q_0 \text{ AND } X$ [cite: 41] |

## Files in this Repository
* [cite_start]**JKFF.vhdl**: VHDL behavioral description of the JK Flip-Flop component. [cite: 17]
* [cite_start]**Transition Tables**: Excel/PDF tables mapping present states to next states for both Mealy and Moore models. [cite: 22, 51]
* [cite_start]**State Tables**: Tabular FSM representations. [cite: 49, 53]
* [cite_start]**K-Maps**: Logical simplifications for excitation and output logic. [cite: 24]
* **State Graphs**: Visual diagrams showing state transitions and outputs.