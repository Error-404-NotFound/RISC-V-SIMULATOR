include("core.jl")
include("utility.jl")

function execute_stage_with_DF(instruction::String, instruction_type::String, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    # println(instruction, " ", instruction_type)
    # parts = split(instruction, " ")
    # parts = remove_empty_strings(parts)
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
    foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
    # println(instruction)

    if instruction_type == "R_type_instructions"
        execute_R(core, memory, variable_address)
    elseif instruction_type == "I_type_instructions"
        execute_I(core, memory, variable_address)
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
    # parts = split(instruction, " ")
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
    if opcode == "add"
        # println(core.EX_temp_register)
        # println(core.EX_temp_register_previous_instruction)
        if core.data_dependency
            if core.rs1_dependency
                core.EX_temp_register = core.registers[core.rs2_temp_register] + core.data_forwarding_rs1
            elseif core.rs2_dependency
                core.EX_temp_register = core.registers[core.rs1_temp_register] + core.data_forwarding_rs2
            elseif core.rs1_dependency && core.rs2_dependency
                core.EX_temp_register = core.data_forwarding_rs1 + core.data_forwarding_rs2
            end
        end
        return core.EX_temp_register = core.registers[core.rs1_temp_register] + core.registers[core.rs2_temp_register]

        # return core.registers[core.rs1_temp_register] + core.registers[core.rs2_temp_register]
        # return core.registers[core.rs1_temp_register] + core.registers[core.rs2_temp_register]
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
    # parts = split(instruction, " ")
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
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
    elseif opcode == "jr"
        core.pc = core.registers[core.rd_temp_register]
        # core.stall_at_EX = true
        return core.pc
    end
    
end

function execute_Load(core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_ID_RF
    # parts = split(instruction, " ")
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
    if opcode == "lb"
        return core.registers[core.rs1_temp_register] + core.immediate_temp_register
    elseif opcode == "lh"
        return core.registers[core.rs1_temp_register] + core.immediate_temp_register
    elseif opcode == "lw"
        return core.registers[core.rs1_temp_register] + core.immediate_temp_register
    elseif opcode == "lbu"
        return core.registers[core.rs1_temp_register] + core.immediate_temp_register
    elseif opcode == "lhu"
        return core.registers[core.rs1_temp_register] + core.immediate_temp_register
    end
end

function execute_S(core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_ID_RF
    # parts = split(instruction, " ")
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
    if opcode == "sb"
        return core.registers[core.rs1_temp_register] + core.immediate_temp_register
    elseif opcode == "sh"
        return core.registers[core.rs1_temp_register] + core.immediate_temp_register
    elseif opcode == "sw"
        return core.registers[core.rs1_temp_register] + core.immediate_temp_register
    end
end

function execute_UJ(core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_ID_RF
    # parts = split(instruction, " ")
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
    if opcode == "jal"
        temp_pc = core.pc
        core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
        core.stall_at_EX = true
        return temp_pc
    elseif opcode == "la"
        if haskey(variable_address, core.label_temp_register)
            return variable_address[core.label_temp_register]
        else
            return -1
        end
    end
end

function execute_SB(core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_ID_RF
    # parts = split(instruction, " ")
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
    if opcode == "beq"
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] == core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
        end

    elseif opcode == "bne"
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] != core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            println(core.pc)
            core.pc = core.pc
        end

    elseif opcode == "blt"
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] < core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
        end

    elseif opcode == "ble"
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] <= core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
        end

    elseif opcode == "bge"
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] >= core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
        end

    elseif opcode == "bltu"
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] < core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
        end

    elseif opcode == "bgeu"
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] >= core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
        end
    end
end