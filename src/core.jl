mutable struct Core1
    registers::Array{Int,1}
    pc::Int
    program::Vector{String}
    function Core1(id::Int)
        this = new()
        this.registers = fill(0, 32)
        this.pc = 1
        this.program = []
        
        this.IF_temp_register = 0
        this.instruction_after_IF = "uninitialised"

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

        return this
    end

    IF_temp_register::Int
    instruction_after_IF::String

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
end

function core_Init(id::Int)
    return Core1(id)
end
