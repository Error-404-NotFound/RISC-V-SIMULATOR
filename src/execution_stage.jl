include("core.jl")

function execute_stage(instruction::String, instruction_type::String, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})

    if instruction_type == "R_type_instructions"
        core.EX_temp_register = execute_R(core, memory, variable_address)
    elseif instruction_type == "I_type_instructions"
        core.EX_temp_register = execute_I(core, memory, variable_address)
    elseif instruction_type == "Load_type_instructions"
        core.EX_temp_register = execute_Load(core, memory, variable_address)
    elseif instruction_type == "S_type_instructions"
        core.EX_temp_register = execute_S(core, memory, variable_address)
    elseif instruction_type == "SB_type_instructions"
        core.EX_temp_register = execute_SB(core, memory, variable_address)
    elseif instruction_type == "U_type_instructions"
        core.EX_temp_register = execute_U(core, memory, variable_address)
    elseif instruction_type == "UJ_type_instructions"
        core.EX_temp_register = execute_UJ(core, memory, variable_address)
    end


end

function execute_R(core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_ID_RF
    parts = split(instruction, " ")
    opcode = parts[1]
    if opcode == "add"
        return core.registers[core.rs1_temp_register] + core.registers[core.rs2_temp_register]
    elseif opcode == "sub"
        return core.registers[core.rs1_temp_register] - core.registers[core.rs2_temp_register]
    elseif opcode == "sll"
        return core.registers[core.rs1_temp_register] << core.registers[core.rs2_temp_register]
    elseif opcode == "slt"
        return core.registers[core.rs1_temp_register] < core.registers[core.rs2_temp_register] ? 1 : 0
    elseif opcode == "sltu"
        return core.registers[core.rs1_temp_register] < core.registers[core.rs2_temp_register] ? 1 : 0
    elseif opcode == "xor"
        return core.registers[core.rs1_temp_register] ⊻ core.registers[core.rs2_temp_register]
    elseif opcode == "srl"
        return core.registers[core.rs1_temp_register] >>> core.registers[core.rs2_temp_register]
    elseif opcode == "sra"
        return core.registers[core.rs1_temp_register] >> core.registers[core.rs2_temp_register]
    elseif opcode == "or"
        return core.registers[core.rs1_temp_register] | core.registers[core.rs2_temp_register]
    elseif opcode == "and"
        return core.registers[core.rs1_temp_register] & core.registers[core.rs2_temp_register]
    elseif opcode == "mul"
        return core.registers[core.rs1_temp_register] * core.registers[core.rs2_temp_register]
    end
    
end

function execute_I(core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_ID_RF
    parts = split(instruction, " ")
    opcode = parts[1]
    if opcode == "addi"
        return core.registers[core.rs1_temp_register] + core.immediate_temp_register
    elseif opcode == "slti"
        return core.registers[core.rs1_temp_register] < core.immediate_temp_register ? 1 : 0
    elseif opcode == "sltiu"
        return core.registers[core.rs1_temp_register] < core.immediate_temp_register ? 1 : 0
    elseif opcode == "xori"
        return core.registers[core.rs1_temp_register] ⊻ core.immediate_temp_register
    elseif opcode == "ori"
        return core.registers[core.rs1_temp_register] | core.immediate_temp_register
    elseif opcode == "andi"
        return core.registers[core.rs1_temp_register] & core.immediate_temp_register
    elseif opcode == "slli"
        return core.registers[core.rs1_temp_register] << core.immediate_temp_register   
    elseif opcode == "srli"
        return core.registers[core.rs1_temp_register] >>> core.immediate_temp_register
    elseif opcode == "srai"
        return core.registers[core.rs1_temp_register] >> core.immediate_temp_register
    elseif opcode == "muli"
        return core.registers[core.rs1_temp_register] * core.immediate_temp_register
    elseif opcode == "li"
        return core.immediate_temp_register
    elseif opcode == "mv"
        return core.registers[core.rs1_temp_register]
    end
    
end

