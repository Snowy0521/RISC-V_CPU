module cpu(
    input clk,
    input reset
);
    // Internal signals
    // PC signals
    logic [31:0] pc; // Program counter
    logic [31:0] pc_plus4; // PC + 4 for next instruction fetch
    logic [31:0] pc_branch; // Branch target address
    logic [31:0] pc_next; // Next program counter
    
    // Instruction memory signals 
    logic [31:0] instruction; // Current instruction
    
    // Register file signals
    logic        reg_write_enable; // Register write enable, control signal
    logic [4:0]  rs1_addr, rs2_addr, rd_addr; // Register addresses
    logic [31:0] rs1_data, rs2_data, rd_data; // Register file data

    // ALU signals
    logic [31:0] alu_a; // ALU first operand
    logic [31:0] alu_b; // ALU second operand
    logic [3:0]  alu_control; // ALU control signal
    logic [31:0] alu_result; // ALU result
    logic        alu_zero; // ALU zero flag
    
    // Data memory signals
    logic        mem_read_enable; // Data memory read enable, control signal 
    logic        mem_write_enable; // Data memory write enable, control signal
    logic [31:0] mem_rdata; // Data memory read Data

    // Control signals
    logic         branch;  // Branch signal
    logic         mem_to_reg; // Memory to register signal (0: ALU result, 1: Memory data)
    logic  [1:0]  alu_op; // ALU operation type
    logic         alu_src; // ALU source select (0: register, 1: immediate)
    logic  [31:0] imm; // Immediate value
    logic  [6:0]  opcode; // Instruction opcode
    logic  [2:0]  funct3; // Instruction funct3
    logic  [6:0]  funct7; // Instruction funct7

    // Instantiate the instruction memory
    memory instruction_memory(
        .clk(clk),
        .mem_read(1'b1), // Instruction memory is read-only
        .mem_write(1'b0), // No write operation for instruction memory
        .addr(pc),
        .wdata(32'b0), // No write data for instruction memory
        .rdata(instruction) // Read instruction
    );

    // Instantiate the register file
    register_file reg_file(
        .clk(clk),
        .we(reg_write_enable), // Write enable signal
        .raddr1(rs1_addr), // Read address 1
        .raddr2(rs2_addr), // Read address 2
        .waddr(rd_addr), // Write address
        .wdata(rd_data), // Write data
        .rdata1(rs1_data), // Read data 1
        .rdata2(rs2_data)  // Read data 2
    );

    // Multiplexor for ALU second operand
    assign alu_a = rs1_data;
    assign alu_b = alu_src ? imm : rs2_data;

    // Instantiate the ALU
    alu alu_unit(
        .a(alu_a),
        .b(alu_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(alu_zero)
    );

    // Instantiate the data memory
    memory data_memory(
        .clk(clk),
        .mem_read(mem_read_enable), // Memory read enable
        .mem_write(mem_write_enable), // Memory write enable
        .addr(alu_result), // Memory address (from ALU result)
        .wdata(rs2_data), // Memory write data (from rs2)
        .rdata(mem_rdata) // Memory read data
    );

    // parameter for opcodes
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
    assign funct7   = instruction[31:25]; // funct7
    assign rs2_addr = instruction[24:20]; // rs2 address
    assign rs1_addr = instruction[19:15]; // rs1 address
    assign funct3   = instruction[14:12]; // funct3
    assign rd_addr  = instruction[11:7]; // rd address
    assign opcode   = instruction[6:0]; // opcode
    

    // immediate extraction
    always_comb begin
        case (opcode) // opcode
            OPCODE_LOAD:   imm = {{21{instruction[31]}}, instruction[30:20]}; // I-immediate value for load instructions (I-type)
            OPCODE_STORE:  imm = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]}; // S-immediate value for store instructions (S-type)
            OPCODE_ARITH:  imm = {{21{instruction[31]}}, instruction[30:20]}; // I-immediate value for arithmetic instructions (I-type)
            OPCODE_BRANCH: imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-immediate value for branch instructions (B-type)
            OPCODE_JAL:    imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-immediate value for JAL (J-type)
            OPCODE_JALR:   imm = {{21{instruction[31]}}, instruction[30:20]}; // I-immediate value for JALR (I-type)
            OPCODE_LUI:    imm = {instruction[31:12], 12'b0}; // immediate value for LUI (U-type)
            OPCODE_AUIPC:  imm = {instruction[31:12], 12'b0}; // immediate value for AUIPC (U-type)
            default: imm = 32'b0; // Default case
        endcase
    end

    // ALU control logic
    always_comb begin
        case (alu_op)
            2'b00: alu_control = 4'b0010; // ADD for load/store
            2'b01: alu_control = 4'b0110; // SUB for branch
            2'b10: begin // R-type or I-type arithmetic
                case (funct3)
                    3'b000: alu_control = (funct7 == 7'b0100000) ? 4'b0110 : 4'b0010; // SUB or ADD
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

    // Control logic
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
            OPCODE_LOAD: begin
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write_enable = 1'b1;
                mem_read_enable = 1'b1;
                mem_write_enable = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00; // ADD operation
            end 
            OPCODE_STORE: begin
                alu_src = 1'b1;
                mem_to_reg = 1'bx; // Don't care
                reg_write_enable = 1'b0;
                mem_read_enable = 1'b0;
                mem_write_enable = 1'b1;
                branch = 1'b0;
                alu_op = 2'b00; // ADD operation
            end
            OPCODE_ARITH: begin
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write_enable = 1'b1;
                mem_read_enable = 1'b0;
                mem_write_enable = 1'b0;
                branch = 1'b0;
                alu_op = 2'b10; // R-type or I-type arithmetic
            end 
            OPCODE_BRANCH: begin
                alu_src = 1'b0;
                mem_to_reg = 1'bx; // Don't care
                reg_write_enable = 1'b0;
                mem_read_enable = 1'b0;
                mem_write_enable = 1'b0;
                branch = 1'b1;
                alu_op = 2'b01; // SUB operation
            end
            OPCODE_R_TYPE: begin
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write_enable = 1'b1;
                mem_read_enable = 1'b0;
                mem_write_enable = 1'b0;
                branch = 1'b0;
                alu_op = 2'b10; // R-type arithmetic
            end
            OPCODE_JAL: begin
                alu_src = 1'bx; // Don't care
                mem_to_reg = 1'b0;
                reg_write_enable = 1'b1;
                mem_read_enable = 1'b0;
                mem_write_enable = 1'b0;
                branch = 1'bx; // Don't care
                alu_op = 2'bxx;
            end
            OPCODE_JALR: begin
                alu_src = 1'bx; // Don't care
                mem_to_reg = 1'b0;
                reg_write_enable = 1'b1;
                mem_read_enable = 1'b0;
                mem_write_enable = 1'b0;
                branch = 1'bx; // Don't care
                alu_op = 2'bxx;
            end
            default: begin
                // Default case: do nothing
            end
        endcase
    end 

    // Multiplexor for memory or ALU result to write back to register
    always_comb begin
        case (opcode)
            OPCODE_JAL, OPCODE_JALR: rd_data = pc_plus4; // For JAL and JALR, write PC + 4 to rd
            default: rd_data = mem_to_reg ? mem_rdata : alu_result;
        endcase
    end

    // Add more branch conditions
    logic branch_taken;
    always_comb begin
        branch_taken = 1'b0;
        if (branch) begin
            case (funct3)
                3'b000: branch_taken = alu_zero;  // BEQ: branch if equal (zero flag set)
                3'b001: branch_taken = ~alu_zero; // BNE: branch if not equal (zero flag clear)
                3'b100: branch_taken = alu_result[31]; // BLT: branch if less than 
                3'b101: branch_taken = alu_zero | ~alu_result[31]; // BGE: branch if greater or equal 
                default: branch_taken = 1'b0;
            endcase
        end 
    end 

    // PC logic
    assign pc_branch = pc + imm;
    assign pc_plus4 = pc + 32'd4;

    always_comb begin 
        case (opcode)
            OPCODE_JAL: pc_next = pc_branch; // JAL
            OPCODE_JALR: pc_next = (rs1_data + imm) & ~32'b1; // JALR
            default: pc_next = branch_taken ? pc_branch : pc_plus4; // Branch or next instruction
        endcase
    end   
    // PC register
    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 32'b0; // Reset PC to 0
        end else begin
            pc <= pc_next; // Update PC
        end
    end


endmodule 
