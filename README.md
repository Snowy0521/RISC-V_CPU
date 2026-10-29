# RISC-V 5-Stage Pipelined CPU

A from-scratch RISC-V CPU implementation in Verilog (integer subset of RV32I, see [Known Limitations](#known-limitations)), featuring both a single-cycle baseline and a 5-stage pipelined core with hazard handling. Simulated with Verilator, Icarus Verilog and Questa, and able to run C/assembly firmware compiled with the RISC-V GNU toolchain.

## Overview

This project implements the classic 5-stage RISC-V pipeline (IF → ID → EX → MEM → WB) alongside a single-cycle reference implementation, to compare correctness and performance (CPI) between the two microarchitectures.

- **ISA**: subset of the RV32I base integer instruction set (see [Known Limitations](#known-limitations))
- **HDL**: Verilog-2001 / SystemVerilog constructs (`.v`)
- **Simulation**: [Verilator](https://www.veripool.org/verilator/) (waveform-generating C++ testbench) and [Icarus Verilog](http://iverilog.icarus.com/) (fast self-checking unit tests); all testbenches also compile and pass in Questa
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

### Run in Questa

```bash
vlib work
vlog -sv src/alu.v src/memory_pipelined.v src/register_file_pipelined.v src/cpu_pipelined.v tb/tb_cpu_pipelined.v
vsim -c tb_cpu_pipelined -do "run -all; quit -f"
```

## Verification (Current State)

Correctness is currently verified with **directed, self-checking Verilog testbenches** (`tb/`): each testbench pre-loads an instruction sequence, runs it to completion, and checks register/memory state against expected values, reporting a pass/fail summary. Coverage includes:

- The implemented ALU/ALU-immediate operations (`ADD`/`SUB`/`AND`/`OR`, immediate forms)
- Load/store operations, including memory boundary cases
- Branch taken/not-taken and jump (`JAL`/`JALR`) control flow, including checks that the instructions after a taken branch/jump are not executed
- Pipeline-specific hazard scenarios: EX/MEM forwarding, MEM/WB forwarding, load-use stalling, store-data forwarding, branch/jump flush

This gives functional confidence but is not yet a scalable or industrial-grade verification methodology (no constrained-random stimulus, no independent reference model, no functional coverage).

### Bugs Found in Design Review (Fixed)

A later review of the pipelined core with a verification mindset found two bugs that the original directed tests passed over, because they never checked the affected state:

- **Taken branch did not squash the instruction behind it.** Branches resolve in MEM, but the flush only cleared IF/ID and ID/EX, so the instruction in EX still retired (including stores). A wrong-path `JAL`/`JALR` in EX could also override the older branch's PC redirect. Fixed by turning EX/MEM into a bubble on a taken branch and giving the MEM-stage branch priority in PC selection. The original test had the skipped instruction (`x14`) in its program but never checked it.
- **Store data was not forwarded.** `sw` wrote the un-forwarded `rs2`, so a store right after the instruction producing its data stored a stale value. The original store test placed the producer far away from the store.

Both are now covered in `tb/tb_cpu_pipelined.v` (Test Case 7 `x14`, Test Case 11).

### Known Limitations

The design implements an integer subset of RV32I:

- **Not implemented**: `LUI`, `AUIPC`, shifts (`SLL`/`SRL`/`SRA` and immediate forms), `XOR`/`XORI` (funct3 `100` decodes as NOR), `SLTU`/`SLTIU`, `BLTU`/`BGEU`, byte/halfword loads and stores, `FENCE`, `ECALL`/`EBREAK`, CSRs, exceptions and interrupts. There is no illegal-instruction detection: unsupported ALU encodings silently compute AND and write back.
- **Incorrect semantics**: `SLT`/`SLTI` compare unsigned; `BLT`/`BGE` use the sign bit of the subtraction, which is wrong on signed overflow; `ADDI` with immediate bits [11:5] = `0100000` (e.g. `addi x1, x0, 1024`) is decoded as `SUB`.
- **Performance**: branches resolve in MEM (3-cycle penalty); the load-use check also compares the `rs2` field of I-type instructions, causing some unnecessary stalls.

## Roadmap

- **UVM verification environment**: reusable UVM agents (clock/reset, instruction loading, retirement monitor), constrained-random instruction generation, and a reference-model scoreboard for self-checking (replacing hand-computed expected values)
-  **Functional coverage**: opcode/funct3/funct7 space, hazard types, branch outcomes, immediate boundary values
-  **Formal verification**: SVA-based assertions for pipeline invariants (stall/flush mutual exclusivity, forwarding-mux legality, PC control-flow correctness)
-  Automated regression flow with pass/fail aggregation across directed + random test suites

## License

Personal / educational project. No license specified yet.
