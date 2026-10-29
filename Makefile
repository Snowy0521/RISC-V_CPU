# Cross-Platform Makefile for RISC-V CPU Simulation
# Supports both Linux (riscv32-unknown-elf-gcc) and macOS (riscv64-unknown-elf-gcc)
# This Makefile automates the process of building and simulating a RISC-V CPU.

# Variables and Paths
# All generated files go under BUILD_DIR. Simulations run with BUILD_DIR as the working
# directory, so the RTL's relative $readmemh("bin/firmware.img") and the VCD outputs land there too.
BUILD_DIR = build
TARGET = firmware
VMLINUX = ${BUILD_DIR}/obj/${TARGET}.elf
VMEM = ${BUILD_DIR}/bin/${TARGET}.img
VMLINUX_DIR = ${dir ${VMLINUX}}
VMEM_DIR = ${dir ${VMEM}}

# Auto-detect operating system
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    OS = Linux
    GTKWAVE_HINT = sudo apt-get install gtkwave
endif
ifeq ($(UNAME_S),Darwin)
    OS = macOS
    GTKWAVE_HINT = brew install --cask gtkwave
endif

# The CPU only implements RV32I, so pin the ISA regardless of toolchain defaults
ARCH_FLAGS = -march=rv32i -mabi=ilp32

# Auto-detect RISC-V toolchain
# Priority: riscv32 > riscv64
RISCV32_CC := $(shell which riscv32-unknown-elf-gcc 2>/dev/null)
RISCV64_CC := $(shell which riscv64-unknown-elf-gcc 2>/dev/null)

ifneq ($(RISCV32_CC),)
    # riscv32 toolchain found (preferred)
    RISCV_PREFIX = riscv32-unknown-elf
    TOOLCHAIN_MSG = "Using 32-bit toolchain: $(RISCV_PREFIX)"
else ifneq ($(RISCV64_CC),)
    # riscv64 toolchain found, configure for 32-bit target
    RISCV_PREFIX = riscv64-unknown-elf
    TOOLCHAIN_MSG = "Using 64-bit toolchain with 32-bit target: $(RISCV_PREFIX)"
endif

ifneq ($(RISCV_PREFIX),)
    RISCV_CC = $(RISCV_PREFIX)-gcc
    RISCV_OBJCOPY = $(RISCV_PREFIX)-objcopy
    RISCV_OBJDUMP = $(RISCV_PREFIX)-objdump
else
    # No toolchain found
    RISCV_CC = echo "ERROR: No RISC-V toolchain found. Please install riscv32-unknown-elf-gcc or riscv64-unknown-elf-gcc" && false
    RISCV_OBJCOPY = false
    RISCV_OBJDUMP = false
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

# Generated simulators and waveforms
SIM = ${BUILD_DIR}/sim/Vcpu
SIM_PIPELINED = ${BUILD_DIR}/sim_pipelined/Vcpu_pipelined
WAVE = ${BUILD_DIR}/sim.vcd
WAVE_PIPELINED = ${BUILD_DIR}/sim_pipelined.vcd

# Default target
all: info $(WAVE) $(WAVE_PIPELINED)

# Single-cycle CPU (original)
single-cycle: info $(WAVE)

# Pipelined CPU
pipelined: info $(WAVE_PIPELINED)

# Display system information
info:
	@echo "=================================================="
	@echo "RISC-V CPU Simulation Build System"
	@echo "=================================================="
	@echo "Detected OS: $(OS)"
	@echo $(TOOLCHAIN_MSG)
	@echo "Target: $(TARGET)"
	@echo "=================================================="

# Check if toolchain is available
check-toolchain:
	@echo "Checking RISC-V toolchain..."
ifneq ($(RISCV_PREFIX),)
	@echo "Found $(RISCV_CC): $(shell which $(RISCV_CC))"
	@echo "Will use flags: $(ARCH_FLAGS)"
	@$(RISCV_CC) --version | head -1
else
	@echo "No RISC-V toolchain found!"
	@$(MAKE) --no-print-directory install-help
	@exit 1
endif

# Build the firmware
${VMLINUX}: ${FIRMWARE_ASM} ${FIRMWARE_C} ${LINKER_SCRIPT}
	@echo "Building firmware for $(OS)..."
	@mkdir -p ${VMLINUX_DIR}
	$(RISCV_CC) $(ARCH_FLAGS) ${FIRMWARE_ASM} ${FIRMWARE_C} \
		-nostdlib -T ${LINKER_SCRIPT} -o ${VMLINUX}
	$(RISCV_OBJDUMP) -D ${VMLINUX} > ${VMLINUX}.lst
	@echo "Firmware built successfully!"
	@echo "Assembly listing: ${VMLINUX}.lst"

# Generate memory image in hex format for Verilog $readmemh,
# padded with zeros to 2048 words (8KB)
${VMEM}: ${VMLINUX}
	@echo "Generating memory image in hex format..."
	@mkdir -p ${VMEM_DIR}
	$(RISCV_OBJCOPY) -O binary ${VMLINUX} ${VMEM_DIR}tmp.bin
	hexdump -v -e '1/4 "%08x" "\n"' ${VMEM_DIR}tmp.bin > ${VMEM}
	@rm -f ${VMEM_DIR}tmp.bin
	@word_count=$$(wc -l < ${VMEM}); \
	remaining=$$((2048 - word_count)); \
	if [ $$remaining -gt 0 ]; then \
		for i in $$(seq 1 $$remaining); do echo "00000000" >> ${VMEM}; done; \
	fi
	@echo "Memory image generated: ${VMEM}"
	@echo "Size: $$(wc -l < ${VMEM}) words"
	@echo "First few instructions:"
	@head -4 ${VMEM}

# View generated assembly
view-asm: ${VMEM}
	@echo "Generated Assembly Code:"
	@echo "=========================="
	@head -30 ${VMLINUX}.lst
	@echo "=========================="
	@echo "Memory Image (first 8 words):"
	@head -8 ${VMEM}


# Verilator generates Vcpu.mk, which compiles the C++ testbench and links it with the Verilog design
# Compile Verilator simulator for single-cycle CPU
$(SIM): ${VMEM} $(VERILOG_SOURCES) $(CPP_SOURCES)
	@echo "Compiling Verilator simulator for single-cycle CPU..."
	$(VERILATOR) $(VERILATOR_FLAGS) $(CPP_SOURCES) \
		--top-module $(TOP_MODULE) \
		--Mdir ${BUILD_DIR}/sim \
		$(VERILOG_SOURCES)
	$(MAKE) -C ${BUILD_DIR}/sim -f Vcpu.mk
	@echo "Single-cycle Verilator simulator compiled!"

# Compile Verilator simulator for pipelined CPU
$(SIM_PIPELINED): ${VMEM} $(VERILOG_SOURCES_PIPELINED) $(CPP_SOURCES_PIPELINED)
	@echo "Compiling Verilator simulator for pipelined CPU..."
	$(VERILATOR) $(VERILATOR_FLAGS) $(CPP_SOURCES_PIPELINED) \
		--top-module $(TOP_MODULE_PIPELINED) \
		--Mdir ${BUILD_DIR}/sim_pipelined \
		$(VERILOG_SOURCES_PIPELINED)
	$(MAKE) -C ${BUILD_DIR}/sim_pipelined -f Vcpu_pipelined.mk
	@echo "Pipelined Verilator simulator compiled!"

# Run single-cycle simulation
$(WAVE): $(SIM)
	@echo "Running single-cycle simulation..."
	cd ${BUILD_DIR} && sim/Vcpu
	@echo "Single-cycle simulation complete! Waveform: $(WAVE)"

# Run pipelined simulation
$(WAVE_PIPELINED): $(SIM_PIPELINED)
	@echo "Running pipelined simulation..."
	cd ${BUILD_DIR} && sim_pipelined/Vcpu_pipelined
	@echo "Pipelined simulation complete! Waveform: $(WAVE_PIPELINED)"

# Test with iverilog (quick test without Verilator)
# Extra vvp plusargs, e.g. `make test-cpu-pipelined PLUSARGS="+events +vcd"`
PLUSARGS ?=

# Compile with iverilog into BUILD_DIR/<name>.vvp and run it from BUILD_DIR
# $(1) = testbench name, $(2) = sources
define run_iverilog
	@mkdir -p ${BUILD_DIR}
	iverilog -g2012 -o ${BUILD_DIR}/$(1).vvp $(2) tb/$(1).v
	cd ${BUILD_DIR} && vvp $(1).vvp $(PLUSARGS)
endef

test-cpu: ${VMEM}
	@echo "Testing single-cycle CPU module..."
	$(call run_iverilog,tb_cpu,$(VERILOG_SOURCES))
	@echo "Single-cycle CPU test complete!"

test-cpu-pipelined: ${VMEM}
	@echo "Testing pipelined CPU module..."
	$(call run_iverilog,tb_cpu_pipelined,$(VERILOG_SOURCES_PIPELINED))
	@echo "Pipelined CPU test complete!"

# Test individual modules
test-alu:
	@echo "Testing ALU module..."
	$(call run_iverilog,tb_alu,src/alu.v)
	@echo "ALU test complete!"

test-regfile:
	@echo "Testing register file module..."
	$(call run_iverilog,tb_register_file,src/register_file.v)
	@echo "Register file test complete!"

test-memory: ${VMEM}
	@echo "Testing memory module..."
	$(call run_iverilog,tb_memory,src/memory.v)
	@echo "Memory test complete!"

# Test all modules
test-modules: test-cpu test-alu test-regfile test-memory test-cpu-pipelined
	@echo "All module tests complete!"


# Open waveform viewer for single-cycle
wave: $(WAVE)
	@echo "Opening single-cycle waveform viewer..."
	@if command -v gtkwave >/dev/null 2>&1; then \
		gtkwave $(WAVE); \
	else \
		echo "Install GTKWave: $(GTKWAVE_HINT)"; \
	fi

# Open waveform viewer for pipelined
wave-pipelined: $(WAVE_PIPELINED)
	@echo "Opening pipelined waveform viewer..."
	@if command -v gtkwave >/dev/null 2>&1; then \
		gtkwave $(WAVE_PIPELINED); \
	else \
		echo "Install GTKWave: $(GTKWAVE_HINT)"; \
	fi

# Open both waveforms
wave-both: $(WAVE) $(WAVE_PIPELINED)
	@echo "Opening both waveforms..."
	@if command -v gtkwave >/dev/null 2>&1; then \
		gtkwave $(WAVE) & \
		gtkwave $(WAVE_PIPELINED) & \
	else \
		echo "Install GTKWave: $(GTKWAVE_HINT)"; \
	fi

# Clean up generated files
clean:
	@echo "Cleaning up..."
	rm -rf ${BUILD_DIR}
	@echo "Clean complete!"

# Install help for missing toolchain
install-help:
	@echo "=================================================="
	@echo "RISC-V Toolchain Installation Guide"
	@echo "=================================================="
	@echo ""
	@echo "Current OS: $(OS)"
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
	@echo "  $(VMLINUX) - Build firmware ELF file"
	@echo "  $(VMEM) - Generate memory image"
	@echo "  $(SIM)   - Compile Verilator simulator for single-cycle CPU"
	@echo "  $(SIM_PIPELINED) - Compile Verilator simulator for pipelined CPU"
	@echo "  (all outputs go to $(BUILD_DIR)/)"
	@echo ""
	@echo "Quick Test targets only with iverilog:"
	@echo "  test-modules     - Testing all modules..."
	@echo "  test-cpu         - Testing single-cycle CPU module..."
	@echo "  test-cpu-pipelined - Testing pipelined CPU module..."
	@echo "                     PLUSARGS=\"+events +trace +vcd\" for hazard log / full trace / waveform"
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
	@echo "  clean            - Remove $(BUILD_DIR)/"
	@echo "  install-help     - Show toolchain installation guide"
	@echo "  help             - Show this help"
	@echo "=================================================="

# Phony targets
.PHONY: all single-cycle pipelined clean wave wave-pipelined wave-both \
        info check-toolchain view-asm install-help help \
        test-cpu test-cpu-pipelined test-alu test-regfile test-memory test-modules
