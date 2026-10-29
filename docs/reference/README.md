# Reference

## Computer Organization and Design (Patterson & Hennessy)

David A. Patterson, John L. Hennessy, *Computer Organization and Design: The Hardware/Software Interface*, Morgan Kaufmann.

The book exists in several ISA editions with the same structure; this project follows the **RISC-V Edition**:

| Edition | ISA used in the examples |
|---|---|
| RISC-V Edition | RV32I / RV64I |
| MIPS Edition (the classic version) | MIPS32 |
| ARM Edition | ARMv8 (AArch64) |

Chapter 4, *The Processor*, is the basis for this design:

| Book topic | Where it shows up here |
|---|---|
| Single-cycle datapath and control | `src/cpu.v` |
| ALU control (`ALUOp` 00 / 01 / 10, 4-bit ALU control codes 0000 AND, 0001 OR, 0010 ADD, 0110 SUB, 0111 SLT, 1100 NOR) | `src/alu.v`, ALU control in both CPUs |
| Pipelined datapath, pipeline registers IF/ID, ID/EX, EX/MEM, MEM/WB | `src/cpu_pipelined.v` |
| Data hazards: forwarding conditions, EX hazard before MEM hazard | Forwarding unit in `src/cpu_pipelined.v` |
| Load-use hazard detection and stalling | Hazard detection unit in `src/cpu_pipelined.v` |
| Control hazards: branch resolved in MEM, flush of the instructions behind it | Branch logic in `src/cpu_pipelined.v` (see README, Bugs Found in Design Review) |

The ALU's NOR operation and the 4-bit control codes come from the book's teaching ALU (they originate in the MIPS edition). RV32I itself has no NOR and needs XOR instead, which is one of the gaps listed under Known Limitations in the top-level README.


