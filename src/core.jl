mutable struct Core1
    registers::Array{Int,1}
    pc::Int
    program::Vector{String}
    function Core1(id::Int)
        this = new()
        this.registers = fill(0, 32)
        this.pc = 1
        this.program = []
        
        this.number_of_stalls = 0
        this.is_stalled = false
        this.is_stalled_next_cycle = false

        this.IF_temp_register = 0
        this.instruction_after_IF = "uninitialised"

        this.rs1_back1 = -1
        this.rs1_back2 = -1
        this.rs2_back1 = -1
        this.rs2_back2 = -1
        this.rd_back1 = -1
        this.rd_back2 = -1
        this.rs1_temp_register = 0
        this.rs2_temp_register = 0
        this.rd_temp_register = 0
        this.immediate_temp_register = 0
        this.label_temp_register = "uninitialised"
        this.ID_RF_temp_register = 0
        this.instruction_after_ID_RF = "uninitialised"

        this.EX_temp_register = 0
        this.instruction_after_EX = "uninitialised"

        this.MEM_temp_register = 0
        this.instruction_after_MEM = "uninitialised"

        this.WB_temp_register = 0
        this.instruction_after_WB = "uninitialised"
        this.write_back_last_instruction = false

        this.temp_register_instruction_type = "uninitialised"
        return this
    end

    number_of_stalls::Int
    is_stalled::Bool
    is_stalled_next_cycle::Bool

    IF_temp_register::Int
    instruction_after_IF::String

    rs1_back1::Int
    rs1_back2::Int
    rs2_back1::Int
    rs2_back2::Int
    rd_back1::Int
    rd_back2::Int
    rs1_temp_register::Int
    rs2_temp_register::Int
    rd_temp_register::Int
    immediate_temp_register::Int
    label_temp_register::String
    ID_RF_temp_register::Int
    instruction_after_ID_RF::String

    EX_temp_register::Int
    instruction_after_EX::String

    MEM_temp_register::Int
    instruction_after_MEM::String
    
    WB_temp_register::Int
    instruction_after_WB::String
    write_back_last_instruction::Bool

    temp_register_instruction_type::String
end

function core_Init(id::Int)
    return Core1(id)
end
