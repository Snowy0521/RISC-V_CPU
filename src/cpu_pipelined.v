module cpu_pipelined(
    input clk,
    input reset
);
    // ==================================== Pipeline Registers ====================================
    // IF/ID Pipeline Register
    logic [31:0] if_id_pc;
    logic [31:0] if_id_instruction;
    logic [31:0] if_id_pc_plus4; 

    // ID/EX Pipeline Register
    logic [31:0] id_ex_pc;
    logic [31:0] id_ex_rs1_data;
    logic [31:0] id_ex_rs2_data;    
    logic [31:0] id_ex_imm;
    logic [31:0] id_ex_pc_plus4;

    logic        id_ex_alu_src;
    logic        id_ex_mem_to_reg;
    logic        id_ex_mem_read_enable;
    logic        id_ex_mem_write_enable;
    logic  [1:0] id_ex_alu_op;
    logic        id_ex_branch;
    logic  [2:0] id_ex_funct3;
    logic        id_ex_funct7_bit5; // For distinguishing ADD/SUB
    logic  [6:0] id_ex_opcode;
    logic  [4:0] id_ex_rs1_addr; 
    logic  [4:0] id_ex_rs2_addr; 
    logic  [4:0] id_ex_rd_addr;
    logic        id_ex_reg_write_enable;

    // EX/MEM Pipeline Register
    logic [31:0] ex_mem_pc_branch;
    logic [31:0] ex_mem_alu_result;
    logic [31:0] ex_mem_rs2_data; // For store instruction
    logic [31:0] ex_mem_pc_plus4;

    logic        ex_mem_zero;
    logic        ex_mem_branch;
    logic        ex_mem_mem_read_enable;
    logic        ex_mem_mem_write_enable;
    logic        ex_mem_mem_to_reg;
    logic [6:0]  ex_mem_opcode;
    logic [4:0]  ex_mem_rd_addr;
    logic        ex_mem_reg_write_enable;

    // MEM/WB Pipeline Register
    logic [31:0] mem_wb_alu_result;
    logic [31:0] mem_wb_mem_rdata;
    logic [6:0]  mem_wb_opcode;
    logic        mem_wb_mem_to_reg;
    logic [4:0]  mem_wb_rd_addr;
    logic        mem_wb_reg_write_enable;
    logic [31:0] mem_wb_pc_plus4;

    // ==================================== IF Stage ====================================
    logic [31:0] pc; // Program counter
    logic [31:0] pc_plus4; // PC + 4 for next instruction fetch
    logic [31:0] pc_next; // Next program counter
    logic        pc_src; // PC source select for branch
    logic [31:0] instruction; // Current instruction
    logic        branch_taken_predicted; // Branch prediction signal
    logic        branch_taken_actual; // Actual branch taken signal
    logic        flush; // Flush signal 

    // Instantiate the adder for PC + 4
    adder_pc4 adder_pc4_init(
        .pc(pc),
        .pc_next(pc_plus4)
    );

    assign pc_src = ex_mem_branch & ex_mem_zero;
    assign branch_taken_actual = pc_src;
    assign branch_taken_predicted = 1'b0; // Always predict not taken
    assign flush = branch_taken_actual & ~branch_taken_predicted;

    // PC logic
    always_comb begin
        if (flush) begin
            pc_next = ex_mem_pc_branch;
        end else if (stall) begin
            pc_next = pc; // Hold the PC value during stall
        end else begin
            pc_next = pc_plus4; // Default: PC + 4
        end 
    end

    // JAL and JALR override
    always_comb begin 
        case(ex_mem_opcode)
            OPCODE_JAL:
                pc_next = ex_mem_pc_branch;
            OPCODE_JALR:
                pc_next = ex_mem_alu_result & ~1; // Ensure the least significant bit
            default: ; // Do nothing
        endcase
    end 

    // PC update
    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 32'b0; // Reset PC to 0
        end else begin
            pc <= pc_next; // Update PC
        end
    end

    // Instantiate the instruction memory
    memory instruction_memory(
        .clk(clk),
        .mem_read(1'b1), // Instruction memory is read-only
        .mem_write(1'b0), // No write operation for instruction memory
        .addr(pc),
        .wdata(32'b0), // No write data for instruction memory
        .rdata(instruction) // Read instruction
    );

    // IF/ID Pipeline Register Update
    always_ff @(posedge clk) begin
        if (reset || flush) begin
            if_id_pc <= 32'b0;
            if_id_instruction <= 32'b0;
            if_id_pc_plus4 <= 32'b0;
        end else if (!stall) begin
            if_id_pc <= pc;
            if_id_instruction <= instruction;
            if_id_pc_plus4 <= pc_plus4;
        end
        // If stall, hold the values (do not update)
    end 

    // ==================================== ID Stage ====================================

    logic [4:0]  rs1_addr, rs2_addr, rd_addr; // Register addresses
    logic [31:0] rs1_data, rs2_data; // Register file data
    logic [31:0] imm; // Immediate values
    logic [6:0]  opcode;
    logic [2:0]  funct3;
    logic        funct7_bit5;  

    // Control signals
    logic        alu_src; // ALU source 2 select (0: register, 1: immediate)
    logic        mem_to_reg; // Memory to register signal (0: ALU result, 1: Memory data)
    logic        reg_write_enable; // Register write enable, control signal
    logic        mem_read_enable; // Data memory read enable, control signal
    logic        mem_write_enable; // Data memory write enable, control signal
    logic        branch;  // Branch signal
    logic  [1:0] alu_op; // ALU operation type
    

    // Parameter for opcodes
    parameter OPCODE_LOAD   = 7'b0000011; // Load instructions
    parameter OPCODE_STORE  = 7'b0100011; // Store instructions
    parameter OPCODE_ARITH  = 7'b0010011; // Arithmetic instructions
    parameter OPCODE_BRANCH = 7'b1100011; // Branch instructions
    parameter OPCODE_JAL    = 7'b1101111; // JAL instruction
    parameter OPCODE_JALR   = 7'b1100111; // JALR instruction
    parameter OPCODE_LUI    = 7'b0110111; // Less Immediate Upper Immediate
    parameter OPCODE_AUIPC  = 7'b0010111; // Add Upper Immediate to pc_jalr
    parameter OPCODE_R_TYPE = 7'b0110011; // R-type instructions

    // Instruction decode 
    assign opcode = if_id_instruction[6:0];
    assign rd_addr = if_id_instruction[11:7];
    assign funct3 = if_id_instruction[14:12];
    assign rs1_addr = if_id_instruction[19:15];
    assign rs2_addr = if_id_instruction[24:20];
    assign funct7_bit5 = if_id_instruction[30]; // funct7[5] for distinguishing ADD/SUB

    // Immediate generation (I-type, S-type, B-type, U-type, J-type)
    always_comb begin
        case (opcode)
            OPCODE_LOAD, OPCODE_ARITH, OPCODE_JALR: // I-type (load, arithmetic, JALR)
                imm = {{21{if_id_instruction[31]}}, if_id_instruction[30:20]};
            OPCODE_STORE: // S-type (store)
                imm = {{21{if_id_instruction[31]}}, if_id_instruction[30:25], if_id_instruction[11:7]};
            OPCODE_BRANCH: // B-type (branch)
                imm = {{20{if_id_instruction[31]}}, if_id_instruction[7], if_id_instruction[30:25], if_id_instruction[11:8], 1'b0};
            OPCODE_LUI, OPCODE_AUIPC: // U-type (LUI, AUIPC)
                imm = {if_id_instruction[31:12], 12'b0};
            OPCODE_JAL: // J-type (JAL)
                imm = {{12{if_id_instruction[31]}}, if_id_instruction[19:12], if_id_instruction[20], if_id_instruction[30:21], 1'b0};
            default:
                imm = 32'b0;
        endcase
    end 

    // Control unit
    always_comb begin
        // Default values
        alu_src = 1'b0;
        mem_to_reg = 1'b0;
        reg_write_enable = 1'b0;
        mem_read_enable = 1'b0;
        mem_write_enable = 1'b0;
        branch = 1'b0;
        alu_op = 2'b00;

        case(opcode)
            OPCODE_LOAD: begin // Load instructions
                alu_src = 1'b1; // Immediate
                mem_to_reg = 1'b1; // Memory data to register
                reg_write_enable = 1'b1; // Enable register write
                mem_read_enable = 1'b1; // Enable memory read
                //mem_write_enable = 1'b0; // Disable memory write
                //branch = 1'b0; // No branch
                alu_op = 2'b00; // ADD operation
            end
            OPCODE_STORE: begin // Store instructions
                alu_src = 1'b1; // Immediate
                //mem_to_reg = 1'bx; // Don't care
                //reg_write_enable = 1'b0; // Disable register write
                //mem_read_enable = 1'b0; // Disable memory read
                mem_write_enable = 1'b1; // Enable memory write
                //branch = 1'b0; // No branch
                alu_op = 2'b00; // ADD operation
            end
            OPCODE_ARITH: begin // I-type arithmetic instructions
                alu_src = 1'b1; // Immediate
                //mem_to_reg = 1'b0; // ALU result to register
                reg_write_enable = 1'b1; // Enable register write
                //mem_read_enable = 1'b0; // Disable memory read
                //mem_write_enable = 1'b0; // Disable memory write
                //branch = 1'b0; // No branch
                alu_op = 2'b10; // R-type arithmetic
            end
            OPCODE_R_TYPE: begin // R-type arithmetic instructions
                //alu_src = 1'b0; // Register
                //mem_to_reg = 1'b0; // ALU result to register
                reg_write_enable = 1'b1; // Enable register write
                //mem_read_enable = 1'b0; // Disable memory read
                //mem_write_enable = 1'b0; // Disable memory write
                //branch = 1'b0; // No branch
                alu_op = 2'b10; // R-type arithmetic
            end
            OPCODE_BRANCH: begin // Branch instructions
                //alu_src = 1'b0; // Register
                //mem_to_reg = 1'bx; // Don't care
                //reg_write_enable = 1'b0; // Disable register write
                //mem_read_enable = 1'b0; // Disable memory read
                //mem_write_enable = 1'b0; // Disable memory Write
                branch = 1'b1; // Enable branch
                alu_op = 2'b01; // SUB operation
            end 
            OPCODE_JAL: begin // JAL instruction
                //alu_src = 1'bx; // Don't care
                //mem_to_reg = 1'b0; // register Rd = PC + 4
                reg_write_enable = 1'b1; // Enable register write
                //mem_read_enable = 1'b0; // Disable memory read
                //mem_write_enable = 1'b0; // Disable memory write
                //branch = 1'bx; // Don't care
                //alu_op = 2'bxx; // Don't care
            end
            OPCODE_JALR: begin // JALR instruction
                alu_src = 1'b1; // Immediate
                //mem_to_reg = 1'b0; // register Rd = PC + 4
                reg_write_enable = 1'b1; // Enable register write
                //mem_read_enable = 1'b0; // Disable memory read
                //mem_write_enable = 1'b0; // Disable memory write
                //branch = 1'bx; // No branch
                alu_op = 2'b00; // ADD operation
            end
            default: begin 
            end
        endcase
    end 


    // Instantiate the register file
    register_file register_file_init(
        .clk(clk),
        .we(mem_wb_reg_write_enable), // Write enable from WB stage
        .raddr1(rs1_addr),
        .raddr2(rs2_addr),
        .waddr(mem_wb_rd_addr), 
        .wdata(rd_data_wb), // Data to write back to register
        .rdata1(rs1_data),
        .rdata2(rs2_data)
    );

    // ID/EX Pipeline Register Update
    always_ff @(posedge clk) begin
        if (reset || stall || flush) begin
            id_ex_pc <= 32'b0;
            id_ex_rs1_data <= 32'b0;
            id_ex_rs2_data <= 32'b0;
            id_ex_imm <= 32'b0;
            id_ex_rs1_addr <= 5'b0;
            id_ex_rs2_addr <= 5'b0;
            id_ex_rd_addr <= 5'b0;
            id_ex_pc_plus4 <= 32'b0;

            // Control signals reset
            id_ex_alu_src <= 1'b0;
            id_ex_mem_to_reg <= 1'b0;
            id_ex_mem_read_enable <= 1'b0;
            id_ex_mem_write_enable <= 1'b0;
            id_ex_alu_op <= 2'b00;
            id_ex_branch <= 1'b0;
            id_ex_funct3 <= 3'b000;
            id_ex_funct7_bit5 <= 1'b0;
            id_ex_opcode <= 7'b0000000;
            id_ex_reg_write_enable <= 1'b0;
        end else begin
            id_ex_pc <= if_id_pc;
            id_ex_rs1_data <= rs1_data;
            id_ex_rs2_data <= rs2_data;
            id_ex_imm <= imm;
            id_ex_rs1_addr <= rs1_addr;
            id_ex_rs2_addr <= rs2_addr;
            id_ex_rd_addr <= rd_addr;
            id_ex_pc_plus4 <= if_id_pc_plus4;
            id_ex_funct3 <= funct3;
            id_ex_funct7_bit5 <= funct7_bit5;
            id_ex_opcode <= opcode;

            // Control signals update
            id_ex_alu_src <= alu_src;
            id_ex_mem_to_reg <= mem_to_reg;
            id_ex_mem_read_enable <= mem_read_enable;
            id_ex_mem_write_enable <= mem_write_enable;
            id_ex_alu_op <= alu_op;
            id_ex_branch <= branch;
            id_ex_reg_write_enable <= reg_write_enable;
        end
    end 

    // -------------------------------- Hazard Detection Unit --------------------------------
    logic stall; // Stall signal
    assign stall = id_ex_mem_read_enable && 
                   ((id_ex_rd_addr == rs1_addr) || (id_ex_rd_addr == rs2_addr)) && (id_ex_rd_addr != 0);

    // ==================================== EX Stage ====================================
    logic [31:0] alu_a, alu_b; // ALU inputs 
    assign alu_a = alu_a_fwd; // After forwarding
    assign alu_b = id_ex_alu_src ? id_ex_imm : alu_b_fwd; // After forwarding

    logic [3:0]  alu_control; // ALU control signal
    logic [31:0] alu_result; // ALU result
    logic        alu_zero; // ALU zero flag

    logic [31:0] pc_branch; // Branch target address

    // ALU control logic
    always_comb begin
        case (id_ex_alu_op)
            2'b00: alu_control = 4'b0010; // ADD for load/store
            2'b01: alu_control = 4'b0110; // SUB for branch
            2'b10: begin // R-type or I-type arithmetic
                case (id_ex_funct3)
                    3'b000: alu_control = id_ex_funct7_bit5 ? 4'b0110 : 4'b0010; // ADD/SUB    
                    3'b111: alu_control = 4'b0000; // AND
                    3'b110: alu_control = 4'b0001; // OR
                    3'b010: alu_control = 4'b0111; // SLT
                    3'b100: alu_control = 4'b1100; // NOR
                    default: alu_control = 4'b0000; // Default case
                endcase
            end 
            default: alu_control = 4'b0000; // Default case
        endcase
    end

    // Instantiate the ALU
    alu alu_inst(
        .a(alu_a),
        .b(alu_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(alu_zero)
    );

    // Instantiate the adder for branch target address
    adder_pc_imm adder_pc_imm_inst(
        .pc(id_ex_pc),
        .imm(id_ex_imm),
        .pc_next(pc_branch)
    );

    // EX/MEM Pipeline Register Update
    always_ff @(posedge clk) begin
        if (reset) begin
            ex_mem_pc_branch <= 32'b0;
            ex_mem_alu_result <= 32'b0;
            ex_mem_rs2_data <= 32'b0;
            ex_mem_zero <= 1'b0;
            ex_mem_rd_addr <= 5'b0;
            ex_mem_pc_plus4 <= 32'b0;
            
            ex_mem_branch <= 1'b0;
            ex_mem_mem_read_enable <= 1'b0;
            ex_mem_mem_write_enable <= 1'b0;
            ex_mem_mem_to_reg <= 1'b0;
            ex_mem_opcode <= 7'b0000000;
            ex_mem_reg_write_enable <= 1'b0;
        end else begin
            ex_mem_pc_branch <= pc_branch;
            ex_mem_alu_result <= alu_result;
            ex_mem_rs2_data <= id_ex_rs2_data;
            ex_mem_zero <= alu_zero;
            ex_mem_rd_addr <= id_ex_rd_addr;
            ex_mem_pc_plus4 <= id_ex_pc_plus4;

            ex_mem_branch <= id_ex_branch;
            ex_mem_mem_read_enable <= id_ex_mem_read_enable;
            ex_mem_mem_write_enable <= id_ex_mem_write_enable;
            ex_mem_mem_to_reg <= id_ex_mem_to_reg;
            ex_mem_opcode <= id_ex_opcode;
            ex_mem_reg_write_enable <= id_ex_reg_write_enable;
        end
    end 

    // -------------------------------- Forwarding Unit --------------------------------
    logic [1:0] forward_a, forward_b; // Forwarding control signals
    logic [31:0] alu_a_fwd, alu_b_fwd; // Forwarded ALU inputs

    // Forwarding logic for ALU operand A
    always_comb begin 
        if (ex_mem_reg_write_enable && (ex_mem_rd_addr != 0) && (ex_mem_rd_addr == id_ex_rs1_addr)) begin 
            forward_a = 2'b10; // Forward from EX/MEM
        end else if (mem_wb_reg_write_enable && (mem_wb_rd_addr != 0) && (mem_wb_rd_addr == id_ex_rs1_addr) && 
        !(ex_mem_reg_write_enable && (ex_mem_rd_addr != 0) && (ex_mem_rd_addr == id_ex_rs1_addr))) begin 
            forward_a = 2'b01; // Forward from MEM/WB
        end else begin 
            forward_a = 2'b00; // No forwarding
        end
    end

    // Forwarding logic for ALU operand B
    always_comb begin 
        if (ex_mem_reg_write_enable && (ex_mem_rd_addr != 0) && (ex_mem_rd_addr == id_ex_rs2_addr)) begin 
            forward_b = 2'b10; // Forward from EX/MEM
        end else if (mem_wb_reg_write_enable && (mem_wb_rd_addr != 0) && (mem_wb_rd_addr == id_ex_rs2_addr) && 
        !(ex_mem_reg_write_enable && (ex_mem_rd_addr != 0) && (ex_mem_rd_addr == id_ex_rs2_addr))) begin 
            forward_b = 2'b01; // Forward from MEM/WB
        end else begin 
            forward_b = 2'b00; // No forwarding
        end
    end

    // Mux for ALU operand A
    always_comb begin
        case (forward_a)
            2'b00: alu_a_fwd = id_ex_rs1_data; // No forwarding
            2'b01: alu_a_fwd = rd_data_wb; // Forward from MEM/WB
            2'b10: alu_a_fwd = ex_mem_alu_result; // Forward from EX/MEM
            default: alu_a_fwd = id_ex_rs1_data; // Default case
        endcase
    end

    // Mux for ALU operand B
    always_comb begin
        case (forward_b)
            2'b00: alu_b_fwd = id_ex_rs2_data; // No forwarding
            2'b01: alu_b_fwd = rd_data_wb; // Forward from MEM/WB
            2'b10: alu_b_fwd = ex_mem_alu_result; // Forward from EX/MEM
            default: alu_b_fwd = id_ex_rs2_data; // Default case
        endcase
    end

    // ==================================== MEM Stage ====================================
    logic [31:0] mem_rdata; // Data read from memory

    // Instantiate the data memory
    memory data_memory(
        .clk(clk),
        .mem_read(ex_mem_mem_read_enable),
        .mem_write(ex_mem_mem_write_enable),
        .addr(ex_mem_alu_result),
        .wdata(ex_mem_rs2_data),
        .rdata(mem_rdata)
    );

    // MEM/WB Pipeline Register Update
    always_ff @(posedge clk) begin
        if (reset) begin
            mem_wb_alu_result <= 32'b0;
            mem_wb_mem_rdata <= 32'b0;
            mem_wb_opcode <= 7'b0000000;
            mem_wb_mem_to_reg <= 1'b0;
            mem_wb_rd_addr <= 5'b0;
            mem_wb_reg_write_enable <= 1'b0;
            mem_wb_pc_plus4 <= 1'b0;
        end else begin
            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_mem_rdata <= mem_rdata;
            mem_wb_opcode <= ex_mem_opcode;
            mem_wb_mem_to_reg <= ex_mem_mem_to_reg;
            mem_wb_rd_addr <= ex_mem_rd_addr;
            mem_wb_reg_write_enable <= ex_mem_reg_write_enable;
            mem_wb_pc_plus4 <= ex_mem_pc_plus4;
        end
    end

    // ==================================== WB Stage ====================================
    logic [31:0] rd_data_wb; // Data to write back to register
    always_comb begin
        case (mem_wb_opcode)
            OPCODE_JAL, OPCODE_JALR: rd_data_wb = mem_wb_pc_plus4; // For JAL and JALR, write PC + 4 to rd
            default: rd_data_wb = mem_wb_mem_to_reg ? mem_wb_mem_rdata : mem_wb_alu_result;
        endcase
    end
    

endmodule