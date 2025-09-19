# Cross-Platform Makefile for RISC-V CPU Simulation
# Supports both Linux (riscv32-unknown-elf-gcc) and macOS (riscv64-unknown-elf-gcc)
# This Makefile automates the process of building and simulating a RISC-V CPU.

# Variables and Paths
TARGET = firmware
VMLINUX = obj/${TARGET}.elf
VMEM = bin/${TARGET}.img
VMLINUX_DIR = ${dir ${VMLINUX}}
VMEM_DIR = ${dir ${VMEM}}

# Auto-detect operating system
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    OS = Linux
    DETECTED_OS = "Linux"
endif
ifeq ($(UNAME_S),Darwin)
    OS = macOS
    DETECTED_OS = "macOS"
endif

# Auto-detect RISC-V toolchain
# Priority: riscv32 > riscv64
RISCV32_CC := $(shell which riscv32-unknown-elf-gcc 2>/dev/null)
RISCV64_CC := $(shell which riscv64-unknown-elf-gcc 2>/dev/null)

ifneq ($(RISCV32_CC),)
    # riscv32 toolchain found (preferred)
    RISCV_PREFIX = riscv32-unknown-elf
    RISCV_CC = riscv32-unknown-elf-gcc
    RISCV_OBJCOPY = riscv32-unknown-elf-objcopy
    RISCV_OBJDUMP = riscv32-unknown-elf-objdump
    ARCH_FLAGS = 
    TOOLCHAIN_MSG = "Using 32-bit toolchain: $(RISCV_PREFIX)"
else ifneq ($(RISCV64_CC),)
    # riscv64 toolchain found, configure for 32-bit target
    RISCV_PREFIX = riscv64-unknown-elf
    RISCV_CC = riscv64-unknown-elf-gcc
    RISCV_OBJCOPY = riscv64-unknown-elf-objcopy
    RISCV_OBJDUMP = riscv64-unknown-elf-objdump
    ARCH_FLAGS = -march=rv32i -mabi=ilp32
    TOOLCHAIN_MSG = "Using 64-bit toolchain with 32-bit target: $(RISCV_PREFIX)"
else
    # No toolchain found
    RISCV_CC = echo "ERROR: No RISC-V toolchain found. Please install riscv32-unknown-elf-gcc or riscv64-unknown-elf-gcc" && false
    RISCV_OBJCOPY = false
    RISCV_OBJDUMP = false
    ARCH_FLAGS = 
    TOOLCHAIN_MSG = "No RISC-V toolchain found!"
endif

# Sources
FIRMWARE_ASM = firmware/start.s
FIRMWARE_C = firmware/main.c
LINKER_SCRIPT = firmware/link.ld
VERILOG_SOURCES = src/cpu.v src/alu.v src/register_file.v src/memory.v
VERILOG_SOURCES_PIPELINED = src/cpu_pipelined.v src/alu.v src/register_file_pipelined.v src/memory_pipelined.v


# Verilator configuration
VERILATOR = verilator
VERILATOR_FLAGS = -Wall --cc --exe --trace --trace-structs -O2
TOP_MODULE = cpu
TOP_MODULE_PIPELINED = cpu_pipelined
CPP_SOURCES = top.cpp
CPP_SOURCES_PIPELINED = top_pipelined.cpp

# Platform-specific settings
ifeq ($(OS),macOS)
    # macOS specific settings
    DD_FLAGS = 2>/dev/null || true
else
    # Linux specific settings  
    DD_FLAGS = 2>/dev/null
endif

# Default target
all: info sim.vcd sim_pipelined.vcd

# Single-cycle CPU (original)
single-cycle: info sim.vcd

# Pipelined CPU
pipelined: info sim_pipelined.vcd

# Display system information
info:
	@echo "=================================================="
	@echo "RISC-V CPU Simulation Build System"
	@echo "=================================================="
	@echo "Detected OS: $(DETECTED_OS)"
	@echo $(TOOLCHAIN_MSG)
	@echo "Target: $(TARGET)"
	@echo "=================================================="

# Check if toolchain is available
check-toolchain:
	@echo "Checking RISC-V toolchain..."
ifneq ($(RISCV32_CC),)
	@echo "Found riscv32-unknown-elf-gcc: $(RISCV32_CC)"
	@$(RISCV_CC) --version | head -1
else ifneq ($(RISCV64_CC),)
	@echo "Found riscv64-unknown-elf-gcc: $(RISCV64_CC)"
	@echo "Will use flags: $(ARCH_FLAGS)"
	@$(RISCV_CC) --version | head -1
else
	@echo "No RISC-V toolchain found!"
	@echo ""
	@echo "Installation instructions:"
	@echo "Linux (Ubuntu/Debian):"
	@echo "   sudo apt-get install gcc-riscv64-unknown-elf"
	@echo ""
	@echo "macOS (Homebrew):"
	@echo "   brew tap riscv-software-src/riscv"
	@echo "   brew install riscv-tools"
	@echo ""
	@exit 1
endif

# Build the firmware
${VMLINUX}: ${FIRMWARE_ASM} ${FIRMWARE_C} ${LINKER_SCRIPT}
	@echo "Building firmware for $(DETECTED_OS)..."
	@mkdir -p ${VMLINUX_DIR}
	$(RISCV_CC) $(ARCH_FLAGS) ${FIRMWARE_ASM} ${FIRMWARE_C} \
		-nostdlib -T ${LINKER_SCRIPT} -o ${VMLINUX}
	$(RISCV_OBJDUMP) -D ${VMLINUX} > ${VMLINUX}.lst
	@echo "Firmware built successfully!"
	@echo "Assembly listing: ${VMLINUX}.lst"

# Generate memory image in hex format for Verilog $readmemh
${VMEM}: ${VMLINUX}
	@echo "Generating memory image in hex format..."
	@mkdir -p ${VMEM_DIR}
	$(RISCV_OBJCOPY) -O binary ${VMLINUX} ${VMEM_DIR}/tmp.bin
	
	# Convert binary to hex format for Verilog $readmemh
	hexdump -v -e '1/4 "%08x" "\n"' ${VMEM_DIR}/tmp.bin > ${VMEM}
	
	# Pad with zeros to 2048 words (8KB)
	@word_count=$$(wc -w < ${VMEM}); \
	remaining=$$((2048 - word_count)); \
	if [ $$remaining -gt 0 ]; then \
		for i in $$(seq 1 $$remaining); do echo "00000000" >> ${VMEM}; done; \
	fi
	
	@echo "Memory image generated: ${VMEM}"
	@echo "Size: $$(wc -l < ${VMEM}) words"
	@echo "First few instructions:"
	@head -4 ${VMEM}

# View generated assembly
view-asm: ${VMLINUX}
	@echo "Generated Assembly Code:"
	@echo "=========================="
	@cat ${VMLINUX}.lst | head -30
	@echo "=========================="
	@echo "Memory Image (first 8 words):"
	@head -8 ${VMEM}


# make -C sim -f Vcpu.mk: This command changes the directory to sim and runs the Makefile Vcpu.mk, which is generated by Verilator. It compiles the C++ testbench and links it with the Verilog design files
# Compile Verilator simulator for single-cycle CPU
sim/Vcpu: ${VMEM} $(VERILOG_SOURCES) $(CPP_SOURCES)
	@echo "Compiling Verilator simulator for single-cycle CPU..."
	$(VERILATOR) $(VERILATOR_FLAGS) $(CPP_SOURCES) \
		--top-module $(TOP_MODULE) \
		--Mdir sim \
		$(VERILOG_SOURCES)
	make -C sim -f Vcpu.mk
	@echo "Single-cycle Verilator simulator compiled!"

# Compile Verilator simulator for pipelined CPU
sim_pipelined/Vcpu_pipelined: $(VERILOG_SOURCES_PIPELINED) $(CPP_SOURCES_PIPELINED)
	@echo "Compiling Verilator simulator for pipelined CPU..."
	$(VERILATOR) $(VERILATOR_FLAGS) $(CPP_SOURCES_PIPELINED) \
		--top-module $(TOP_MODULE_PIPELINED) \
		--Mdir sim_pipelined \
		$(VERILOG_SOURCES_PIPELINED)
	make -C sim_pipelined -f Vcpu_pipelined.mk
	@echo "Pipelined Verilator simulator compiled!"

# Run single-cycle simulation
sim.vcd: sim/Vcpu
	@echo "Running single-cycle simulation..."
	sim/Vcpu
	@echo "Single-cycle simulation complete! Waveform: sim.vcd"

# Run pipelined simulation
sim_pipelined.vcd: sim_pipelined/Vcpu_pipelined
	@echo "Running pipelined simulation..."
	sim_pipelined/Vcpu_pipelined
	@echo "Pipelined simulation complete! Waveform: sim_pipelined.vcd"

# Test with iverilog (quick test without Verilator)
test-cpu: ${VMEM}
	@echo "Testing single-cycle CPU module..."
	cd src && iverilog -g2012 cpu.v alu.v register_file.v memory.v testbench/tb_cpu.v && vvp a.out && rm a.out
	@echo "Single-cycle CPU test complete!"

test-cpu-pipelined:
	@echo "Testing pipelined CPU module..."
	cd src && iverilog -g2012 cpu_pipelined.v alu.v register_file_pipelined.v memory_pipelined.v testbench/tb_cpu_pipelined.v && vvp a.out && rm a.out
	@echo "Pipelined CPU test complete!"

# Test individual modules
test-alu:
	@echo "Testing ALU module..."
	cd src && iverilog -g2012 alu.v testbench/tb_alu.v && vvp a.out && rm a.out
	@echo "ALU test complete!"

test-regfile:
	@echo "Testing register file module..."
	cd src && iverilog -g2012 register_file.v testbench/tb_register_file.v && vvp a.out && rm a.out
	@echo "Register file test complete!"

test-memory:
	@echo "Testing memory module..."
	@mkdir -p bin
	@echo "00000000" > bin/firmware.img
	cd src && iverilog -g2012 memory.v testbench/tb_memory.v && vvp a.out && rm a.out
	@echo "Memory test complete!"

# Test all modules
test-modules: test-cpu test-alu test-regfile test-memory test-cpu-pipelined
	@echo "All module tests complete!"


# Open waveform viewer for single-cycle
wave: sim.vcd
	@echo "Opening single-cycle waveform viewer..."
ifeq ($(OS),macOS)
	@if command -v gtkwave >/dev/null 2>&1; then \
		gtkwave sim.vcd; \
	else \
		echo "Install GTKWave: brew install --cask gtkwave"; \
	fi
else
	@if command -v gtkwave >/dev/null 2>&1; then \
		gtkwave sim.vcd; \
	else \
		echo "Install GTKWave: sudo apt-get install gtkwave"; \
	fi
endif

# Open waveform viewer for pipelined
wave-pipelined: sim_pipelined.vcd
	@echo "Opening pipelined waveform viewer..."
ifeq ($(OS),macOS)
	@if command -v gtkwave >/dev/null 2>&1; then \
		gtkwave sim_pipelined.vcd; \
	else \
		echo "Install GTKWave: brew install --cask gtkwave"; \
	fi
else
	@if command -v gtkwave >/dev/null 2>&1; then \
		gtkwave sim_pipelined.vcd; \
	else \
		echo "Install GTKWave: sudo apt-get install gtkwave"; \
	fi
endif

# Open both waveforms
wave-both: sim.vcd sim_pipelined.vcd
	@echo "Opening both waveforms..."
ifeq ($(OS),macOS)
	@if command -v gtkwave >/dev/null 2>&1; then \
		gtkwave sim.vcd & \
		gtkwave sim_pipelined.vcd & \
	else \
		echo "Install GTKWave: brew install --cask gtkwave"; \
	fi
else
	@if command -v gtkwave >/dev/null 2>&1; then \
		gtkwave sim.vcd & \
		gtkwave sim_pipelined.vcd & \
	else \
		echo "Install GTKWave: sudo apt-get install gtkwave"; \
	fi
endif

# Clean up generated files
clean:
	@echo "Cleaning up..."
	rm -rf obj/ bin/ sim/ sim_pipelined/ *.vcd *.log 
	@echo "Clean complete!"

# Install help for missing toolchain
install-help:
	@echo "=================================================="
	@echo "RISC-V Toolchain Installation Guide"
	@echo "=================================================="
	@echo ""
	@echo "Current OS: $(DETECTED_OS)"
	@echo ""
ifeq ($(OS),Linux)
	@echo "Linux Installation Options:"
	@echo ""
	@echo "Option 1 - Ubuntu/Debian (recommended):"
	@echo "  sudo apt-get update"
	@echo "  sudo apt-get install gcc-riscv64-unknown-elf"
	@echo ""
	@echo "Option 2 - Build from source:"
	@echo "  git clone https://github.com/riscv/riscv-gnu-toolchain"
	@echo "  cd riscv-gnu-toolchain"
	@echo "  ./configure --prefix=$$HOME/riscv --with-arch=rv32gc"
	@echo "  make"
else
	@echo "macOS Installation Options:"
	@echo ""
	@echo "Option 1 - Homebrew (recommended):"
	@echo "  brew tap riscv-software-src/riscv" 
	@echo "  brew install riscv-tools"
	@echo ""
	@echo "Option 2 - Pre-built binaries:"
	@echo "  curl -L -O https://github.com/sifive/freedom-tools/releases/download/v2020.12.0-Toolchain.Only/riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-apple-darwin.tar.gz"
	@echo "  tar -xzf riscv64-unknown-elf-toolchain-*.tar.gz"
	@echo "  export PATH=\"\$$PWD/riscv64-unknown-elf-toolchain-*/bin:\$$PATH\""
endif
	@echo ""
	@echo "After installation, run: make check-toolchain"
	@echo "=================================================="

# Show available targets
help:
	@echo "=================================================="
	@echo "Available Make Targets"
	@echo "=================================================="
	@echo "Build targets:"
	@echo "  all              - Build both single-cycle and pipelined CPU"
	@echo "  single-cycle     - Build single-cycle CPU only"
	@echo "  pipelined        - Build pipelined CPU only"
	@echo "  obj/firmware.elf - Build firmware ELF file"
	@echo "  bin/firmware.img - Generate memory image"
	@echo "  sim/Vcpu         - Compile Verilator simulator for single-cycle CPU"
	@echo "  sim_pipelined/Vcpu_pipelined - Compile Verilator simulator for pipelined CPU"
	@echo ""
	@echo "Quick Test targets only with iverilog:"
	@echo "  test-modules     - Testing all modules..."
	@echo "  test-cpu         - Testing single-cycle CPU module..."
	@echo "  test-cpu-pipelined - Testing pipelined CPU module..."
	@echo "  test-alu         - Testing ALU module..."
	@echo "  test-regfile     - Testing register file module..."
	@echo "  test-memory      - Testing memory module..."
	@echo ""
	@echo "Info targets:"
	@echo "  info             - Show system information" 
	@echo "  check-toolchain  - Check RISC-V toolchain"
	@echo "  view-asm         - View generated assembly"
	@echo "  wave             - Open waveform viewer for single-cycle CPU"
	@echo "  wave-pipelined   - Open waveform viewer for pipelined CPU"
	@echo "  wave-both        - Open both waveform viewer"
	@echo ""
	@echo "Utility targets:"
	@echo "  clean            - Remove generated files"
	@echo "  install-help     - Show toolchain installation guide"
	@echo "  help             - Show this help"
	@echo "=================================================="

# Phony targets
.PHONY: all single-cycle pipelined clean wave wave-pipelined wave-both \
        info check-toolchain view-asm install-help help \
        test-cpu test-cpu-pipelined test-alu test-regfile test-memory test-all 
        