include("processor.jl")
include("core.jl")
include("execute_instructions.jl")
include("utility.jl")
include("execution_stage.jl")

function run(processor::Processor, variable_address::Dict{String, Int},index::Int) 
    while processor.cores[index].pc <= length(processor.cores[index].program)
        IF_stage(processor, processor.cores[index], processor.memory, variable_address)
        ID_RF_stage(processor, processor.cores[index], processor.memory, variable_address)
        EX_stage(processor, processor.cores[index], processor.memory, variable_address)
        # MEM_stage(processor, processor.cores[index], processor.memory, variable_address)
        # WB_stage(processor, processor.cores[index], processor.memory, variable_address)
    end
end

function IF_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if core.pc > length(core.program)
        return
    end
    instruction = core.program[core.pc]
    core.pc += 1
    # core.IF_temp_register = instruction
    core.instruction_after_IF = instruction
    processor.clock += 1
end

function ID_RF_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_IF
    instruction = replace_registers(instruction)
    parts = split(instruction, " ")
    parts = remove_empty_strings(parts)
    opcode = parts[1]
    instruction_type = nothing
    foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
    if !isnothing(instruction_type)

        if instruction_type == "R_type_instructions"
            core.rd_temp_register = parse(Int, parts[2][2:end])
            core.rs1_temp_register = parse(Int, parts[3][2:end])
            core.rs2_temp_register = parse(Int, parts[4][2:end])

        elseif instruction_type == "I_type_instructions"
            if opcode == "li"
                core.rd_temp_register = parse(Int, parts[2][2:end])
                core.rs1_temp_register = 0
                core.immediate_temp_register = parse(Int, parts[3])
            elseif opcode == "mv"
                core.rd_temp_register = parse(Int, parts[2][2:end])
                core.rs1_temp_register = parse(Int, parts[3][2:end])
                core.immediate_temp_register = 0
            elseif opcode == "jr"
                core.rd_temp_register = parse(Int, parts[2][2:end])
                code.rs1_temp_register = 0
                core.immediate_temp_register = 0
            end
            core.rd_temp_register = parse(Int, parts[2][2:end])
            core.rs1_temp_register = parse(Int, parts[3][2:end])
            core.immediate_temp_register = parse(Int, parts[4])

        elseif instruction_type == "Load_type_instructions"
            core.rd_temp_register = parse(Int, parts[2][2:end])
            core.rs1_temp_register = parse(Int, parts[3][2:end])
            core.immediate_temp_register = parse(Int, parts[4])

        elseif instruction_type == "S_type_instructions"
            core.rs2_temp_register = parse(Int, parts[2][2:end])
            core.immediate_temp_register = parse(Int, parts[3])
            core.rs1_temp_register = parse(Int, parts[4][2:end])

        elseif instruction_type == "SB_type_instructions"
            core.rs1_temp_register = parse(Int, parts[2][2:end])
            core.rs2_temp_register = parse(Int, parts[3][2:end])
            core.label_temp_register = parts[4]
            
        elseif instruction_type == "U_type_instructions"
            core.rd_temp_register = parse(Int, parts[2][2:end])
            core.immediate_temp_register = parse(Int, parts[3])

        elseif instruction_type == "UJ_type_instructions"
            if opcode == "j"
                core.rd_temp_register = 0
                core.label_temp_register = parts[2]
            end
            core.rd_temp_register = parse(Int, parts[2][2:end])
            core.label_temp_register = parts[3]

        end
    end

    # core.ID_RF_temp_register = instruction
    core.instruction_after_ID_RF = instruction
    processor.clock += 1
end

function EX_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_ID_RF
    instruction = replace_registers(instruction)
    parts = split(instruction, " ")
    parts = remove_empty_strings(parts)


    core.instruction_after_EX = instruction
    processor.clock += 1
    
end

function execute(this::Core1, instruction::String)
    return instruction
end

function memory(this::Core1, instruction::String)
    return instruction
end

function writeback(this::Core1, instruction::String)
    return instruction
end

function run(this::Core1)
    while true
        instruction = fetch(this)
        if instruction == "HALT"
            break
        end
        instruction = decode(this, instruction)
        instruction = execute(this, instruction)
        instruction = memory(this, instruction)
        instruction = writeback(this, instruction)
    end
end