include("core.jl")

function execute_stage(instruction::String, instruction_type::String, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    # println(instruction, " ", instruction_type)
    parts = split(instruction, " ")
    parts = remove_empty_strings(parts)
    opcode = parts[1]
    foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
    # println(instruction)

    if instruction_type == "R_type_instructions"
        core.EX_temp_register = execute_R(core, memory, variable_address)
    elseif instruction_type == "I_type_instructions"
        core.EX_temp_register = execute_I(core, memory, variable_address)
    elseif instruction_type == "L_type_instructions"
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
    # println(core.registers[core.rs1_temp_register])
    # println(core.registers[core.rs2_temp_register])
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

function execute_Load(core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_ID_RF
    parts = split(instruction, " ")
    opcode = parts[1]
    if opcode == "lb"
        return memory[variable_address[parts[3]] + core.registers[core.rs1_temp_register]]
    elseif opcode == "lh"
        return memory[variable_address[parts[3]] + core.registers[core.rs1_temp_register]]
    elseif opcode == "lw"
        return memory[variable_address[parts[3]] + core.registers[core.rs1_temp_register]]
    elseif opcode == "lbu"
        return memory[variable_address[parts[3]] + core.registers[core.rs1_temp_register]]
    elseif opcode == "lhu"
        return memory[variable_address[parts[3]] + core.registers[core.rs1_temp_register]]
    end
    
end
