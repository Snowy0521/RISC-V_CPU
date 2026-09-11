# RISC-V 5-Stage Pipelined CPU

A from-scratch RISC-V (RV32I) CPU implementation in Verilog, featuring both a single-cycle baseline and a 5-stage pipelined core with full hazard handling. Simulated with Verilator and Icarus Verilog, and able to run C/assembly firmware compiled with the RISC-V GNU toolchain.

## Overview

This project implements the classic 5-stage RISC-V pipeline (IF → ID → EX → MEM → WB) alongside a single-cycle reference implementation, to compare correctness and performance (CPI) between the two microarchitectures.

- **ISA**: RV32I base integer instruction set
- **HDL**: Verilog-2001 / SystemVerilog constructs (`.v`)
- **Simulation**: [Verilator](https://www.veripool.org/verilator/) (waveform-generating C++ testbench) and [Icarus Verilog](http://iverilog.icarus.com/) (fast self-checking unit tests)
- **Toolchain**: `riscv32-unknown-elf-gcc` / `riscv64-unknown-elf-gcc` for compiling firmware

## Features

- Single-cycle RV32I CPU (`src/cpu.v`)
-  5-stage pipelined RV32I CPU (`src/cpu_pipelined.v`)
  -  EX/MEM and MEM/WB data forwarding (RAW hazard resolution)
  -  Load-use hazard detection with pipeline stalling
  -  Control-hazard flushing for branches (`BEQ`/`BNE`/...) and jumps (`JAL`/`JALR`)
-  Modular datapath: ALU, register file, instruction/data memory
-  Verilator-based C++ simulation harness with VCD waveform dumps
-  Firmware build flow: C/assembly → ELF → memory image (`$readmemh` format)
-  Self-checking directed Verilog testbenches (module-level and full-CPU)


## Getting Started

### Prerequisites

- `verilator`, `iverilog`
- `riscv32-unknown-elf-gcc` (preferred) or `riscv64-unknown-elf-gcc`
- `gtkwave` (optional, for waveform viewing)

### Build & Simulate

```bash
make all              # Build firmware + run both single-cycle and pipelined simulations
make single-cycle      # Single-cycle CPU only
make pipelined         # Pipelined CPU only
make wave-both         # Open both waveforms in GTKWave
```

### Run Unit Tests (Icarus Verilog)

```bash
make test-modules      # ALU, register file, memory, single-cycle CPU, pipelined CPU
make test-cpu-pipelined
```

See `make help` for the full list of targets.

## Verification (Current State)

Correctness is currently verified with **directed, self-checking Verilog testbenches** (`src/testbench/`): each testbench pre-loads an instruction sequence, runs it to completion, and checks register/memory state against expected values, reporting a pass/fail summary. Coverage includes:

- All base ALU/ALU-immediate operations
- Load/store operations, including memory boundary cases
- Branch taken/not-taken and jump (`JAL`/`JALR`) control flow
- Pipeline-specific hazard scenarios: EX/MEM forwarding, MEM/WB forwarding, load-use stalling, branch/jump flush

This gives functional confidence but is not yet a scalable or industrial-grade verification methodology (no constrained-random stimulus, no independent reference model, no functional coverage).

## Roadmap

- **UVM verification environment**: reusable UVM agents (clock/reset, instruction loading, retirement monitor), constrained-random instruction generation, and a reference-model scoreboard for self-checking (replacing hand-computed expected values)
-  **Functional coverage**: opcode/funct3/funct7 space, hazard types, branch outcomes, immediate boundary values
-  **Formal verification**: SVA-based assertions for pipeline invariants (stall/flush mutual exclusivity, forwarding-mux legality, PC control-flow correctness)
-  Automated regression flow with pass/fail aggregation across directed + random test suites

## License

Personal / educational project. No license specified yet.
