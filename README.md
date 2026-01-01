# 5-Stage Pipelined RISC-V CPU

This repository contains a fully functional **5-stage pipelined RISC-V CPU** implemented in **SystemVerilog**.  
The processor supports a meaningful subset of the **RV32I** instruction set and includes essential microarchitectural features such as **data forwarding**, **hazard detection**, and **control hazard handling**.

---

## Overview

The processor is organized as a classic in-order, single-issue, five-stage pipeline:

1. **Instruction Fetch (IF)**  
2. **Instruction Decode and Register Fetch (ID)**  
3. **Execute / Address Calculation (EX)**  
4. **Memory Access (MEM)**  
5. **Write Back (WB)**  

Each stage is separated by pipeline registers, enabling concurrent execution of multiple instructions while maintaining correctness through hazard detection and resolution mechanisms.

---

## Features

### Pipeline Architecture

- Five-stage pipelined datapath:
  - **IF**: Program counter update and instruction fetch
  - **ID**: Instruction decode, register file access, and immediate generation
  - **EX**: ALU operations, branch comparison, and address calculation
  - **MEM**: Data memory access for load and store instructions
  - **WB**: Write-back of ALU or memory results to the register file

---

### Instruction Set Support (RV32I Subset)

The processor currently supports the following instructions:

- **R-type**
  - `add`, `sub`
  - `and`, `or`
  - `slt`
- **I-type**
  - `addi`
  - `andi`, `ori`, `xori`
  - `slti`
- **Memory access**
  - `lw`
  - `sw`
- **Control flow**
  - `beq`

---

### Hazard Handling

#### Data Hazards
- Full forwarding support to minimize pipeline stalls:
  - Forwarding from **EX/MEM** stage to **EX**
  - Forwarding from **MEM/WB** stage to **EX**

#### Load-Use Hazards
- Dedicated load-use hazard detection unit
- Automatically inserts a pipeline stall and bubble when a dependent instruction follows a load
- Correctly stalls the PC and IF/ID pipeline register while flushing ID/EX

---

## Microarchitecture Summary
- Register file reads occur in the ID stage
- ALU operations and branch comparisons occur in the EX stage
- Memory access is isolated to the MEM stage
- Write-back is performed in the WB stage

---

## Verification and Testing

- Simulated using **Icarus Verilog**
- Verification performed using:
  - Hand-written RISC-V assembly programs
  - Directed test cases targeting:
    - Data forwarding paths
    - Load-use hazards
    - Back-to-back dependent instructions

---

## Tools and Technologies

- **Hardware Description Language**: SystemVerilog
- **Simulation Tool**: Icarus Verilog
- **ISA**: RISC-V RV32I
- **Reference Architecture**: Harris & Harris pipelined datapath

---

## How to Run

```bash
iverilog -g2012 -o cpu tb/tb.sv *.sv
vvp cpu
gtkwave pipelined_cpu.vcd

## Acknowledgements

Digital Design and Computer Architecture – RISC-V Edition
David M. Harris, Sarah L. Harris

RISC-V Instruction Set Architecture Specification
