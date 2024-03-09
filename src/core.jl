mutable struct Core1
    registers::Array{Int,1}
    pc::Int
    program::Vector{String}
    function Core1(id::Int)
        this = new()
        this.registers = fill(0, 32)
        this.pc = 1
        this.program = []
        
        # Stall tracking registers
        this.stall_count = 0
        this.stall_in_present_clock_cycle = false
        this.stall_at_IF = false
        this.stall_at_ID_RF = false
        this.stall_at_EX = false
        this.stall_at_MEM = false
        this.stall_at_WB = false
        this.stall_in_next_clock_cycle = false
        this.stall_at_jump_instruction = false

        # Instruction tracking registers
        this.instruction_count = 0

        # 1-bit Branch Prediction (Branch tracking registers)
        this.branch_count = 0
        this.branch_misprediction_count = 0
        this.branch_prediction_accuracy = 0.0
        this.branch_prediction_accuracy_count = 0
        this.branch_prediction_accuracy_sum = 0
        this.branch_prediction = 0

        # Pipeline registers

        # IF stage registers
        this.IF_temp_register = 0
        this.instruction_after_IF = "uninitialised"

        # ID_RF stage registers
        this.opcode_register = "uninitialised"
        this.rs1_temp_register = -1
        this.rs2_temp_register = -1
        this.rd_temp_register = -1
        this.rd_temp_register_previous_instruction = -1
        this.immediate_temp_register = 0
        this.label_temp_register = "uninitialised"
        this.ID_RF_temp_register = 0
        this.instruction_after_ID_RF = "uninitialised"
        this.temp_register = "uninitialised"

        # EX stage registers
        this.EX_temp_register = 0
        this.EX_temp_register_previous_instruction = 0
        this.instruction_after_EX = "uninitialised"

        # MEM stage registers
        this.MEM_temp_register = 0
        this.instruction_after_MEM = "uninitialised"

        # WB stage registers
        this.WB_temp_register = 0
        this.instruction_after_WB = "uninitialised"
        this.write_back_last_instruction = false
        this.write_back_previous_last_instruction = false

        # Instruction type tracking registers
        this.temp_register_instruction_type = "uninitialised"

        # Temp registers
        this.temp_register_string = "uninitialised"
        this.temp_register_int = 0
        this.temp_register_bool = false

        # Data forwarding registers
        this.data_forwarding_rs1 = 0
        this.data_forwarding_rs2 = 0
        this.data_dependency = false
        this.rs1_dependency = false
        this.rs2_dependency = false
        
        return this
    end

    # Stall tracking registers
    stall_count::Int
    stall_in_present_clock_cycle::Bool
    stall_at_IF::Bool
    stall_at_ID_RF::Bool
    stall_at_EX::Bool
    stall_at_MEM::Bool
    stall_at_WB::Bool
    stall_in_next_clock_cycle::Bool
    stall_at_jump_instruction::Bool

    # Instruction tracking registers
    instruction_count::Int

    # 1-bit Branch Prediction (Branch tracking registers)
    branch_count::Int
    branch_misprediction_count::Int
    branch_prediction_accuracy::Float64
    branch_prediction_accuracy_count::Int
    branch_prediction_accuracy_sum::Int
    branch_prediction::Int

    # Pipeline registers

    # IF stage registers
    IF_temp_register::Int
    instruction_after_IF::String

    # ID_RF stage registers
    opcode_register::String
    rs1_temp_register::Int
    rs2_temp_register::Int
    rd_temp_register::Int
    rd_temp_register_previous_instruction::Int
    immediate_temp_register::Int
    label_temp_register::String
    ID_RF_temp_register::Int
    instruction_after_ID_RF::String
    temp_register::String

    # EX stage registers
    EX_temp_register::Int
    EX_temp_register_previous_instruction::Int
    instruction_after_EX::String

    # MEM stage registers
    MEM_temp_register::Int
    instruction_after_MEM::String
    
    # WB stage registers
    WB_temp_register::Int
    instruction_after_WB::String
    write_back_last_instruction::Bool
    write_back_previous_last_instruction::Bool

    # Instruction type tracking registers
    temp_register_instruction_type::String

    # Temp registers
    temp_register_string::String
    temp_register_int::Int
    temp_register_bool::Bool

    # Data forwarding registers
    data_forwarding_rs1::Int
    data_forwarding_rs2::Int
    data_dependency::Bool
    rs1_dependency::Bool
    rs2_dependency::Bool
end

function core_Init(id::Int)
    return Core1(id)
end
