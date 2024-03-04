include("processor.jl")
include("core.jl")
include("execute_instructions.jl")
include("utility.jl")
include("execution_stage.jl")

function run(processor::Processor, variable_address::Dict{String, Int},index::Int) 
    while !processor.cores[index].write_back_last_instruction
        processor.clock += 1
        WB_stage(processor, processor.cores[index], processor.memory, variable_address)
        MEM_stage(processor, processor.cores[index], processor.memory, variable_address)
        EX_stage(processor, processor.cores[index], processor.memory, variable_address)
        ID_RF_stage(processor, processor.cores[index], processor.memory, variable_address)
        IF_stage(processor, processor.cores[index], processor.memory, variable_address)
    end
end

function WB_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    instruction = core.instruction_after_MEM
    if instruction != "uninitialised"
        println("Write Back at clock cycle: ", processor.clock)
        instruction_type = core.temp_register_instruction_type
        writeback_stage(instruction, instruction_type, core, memory, variable_address)
        core.write_back_last_instruction = true
    end
end

function writeback_stage(instruction::String, instruction_type::String, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if instruction_type == "R_type_instructions"
        core.registers[core.rd_temp_register] = core.EX_temp_register
    elseif instruction_type == "I_type_instructions"
        if instruction[1:3] == "li "
            core.registers[core.rd_temp_register] = core.immediate_temp_register
        elseif instruction[1:3] == "mv "
            core.registers[core.rd_temp_register] = core.registers[core.rs1_temp_register]
        elseif instruction[1:3] == "jr "
            core.pc = core.registers[core.rd_temp_register]
        else
            core.registers[core.rd_temp_register] = core.EX_temp_register
        end
    end
    
end

function MEM_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    memory = processor.memory
    core.instruction_after_MEM = instruction = core.instruction_after_EX
    instruction_type = core.temp_register_instruction_type
    if instruction != "uninitialised"
        println("Memory Access at clock cycle: ", processor.clock)
        core.MEM_temp_register = address = core.EX_temp_register

        core.write_back_last_instruction = false
    end
end

function EX_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    core.instruction_after_EX = instruction = core.instruction_after_ID_RF
    if instruction != "uninitialised"
        println("Execution at clock cycle: ", processor.clock)
        instruction_type = core.temp_register_instruction_type
        core.EX_temp_register = execute_stage(instruction, instruction_type, core, memory, variable_address)
        core.write_back_last_instruction = false
    end
end

function ID_RF_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    core.instruction_after_ID_RF = core.instruction_after_IF

    if core.instruction_after_IF != "uninitialised"
        println("Instruction Decoded at clock cycle: ", processor.clock)

        instruction = core.instruction_after_IF
        instruction = replace_registers(instruction)
        parts = split(instruction, " ")
        parts = remove_empty_strings(parts)
        opcode = parts[1]
        instruction_type = nothing
        foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
        if !isnothing(instruction_type)

            if instruction_type == "R_type_instructions"
                core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                core.rs1_temp_register = parse(Int, parts[3][2:end]) + 1
                core.rs2_temp_register = parse(Int, parts[4][2:end]) + 1

            elseif instruction_type == "I_type_instructions"
                if opcode == "li"
                    core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                    core.rs1_temp_register = 0 + 1
                    core.immediate_temp_register = parse(Int, parts[3])
                elseif opcode == "mv"
                    core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                    core.rs1_temp_register = parse(Int, parts[3][2:end]) + 1
                    core.immediate_temp_register = 0
                elseif opcode == "jr"
                    core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                    code.rs1_temp_register = 0 + 1
                    core.immediate_temp_register = 0
                else
                    core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                    core.rs1_temp_register = parse(Int, parts[3][2:end]) + 1
                    core.immediate_temp_register = parse(Int, parts[4])
                end

            elseif instruction_type == "Load_type_instructions"
                core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                core.immediate_temp_register = parse(Int, parts[3])
                core.rs1_temp_register = parse(Int, parts[4][2:end]) + 1

            elseif instruction_type == "S_type_instructions"
                core.rs2_temp_register = parse(Int, parts[2][2:end]) + 1
                core.immediate_temp_register = parse(Int, parts[3])
                core.rs1_temp_register = parse(Int, parts[4][2:end]) + 1

            elseif instruction_type == "SB_type_instructions"
                core.rs1_temp_register = parse(Int, parts[2][2:end]) + 1
                core.rs2_temp_register = parse(Int, parts[3][2:end]) + 1
                core.label_temp_register = parts[4]
                
            elseif instruction_type == "U_type_instructions"
                core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                core.immediate_temp_register = parse(Int, parts[3])

            elseif instruction_type == "UJ_type_instructions"
                if opcode == "j"
                    core.rd_temp_register = 0
                    core.label_temp_register = parts[2]
                else
                    core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                    core.label_temp_register = parts[3]
                end

            end
        end
        core.write_back_last_instruction = false
        core.rd_temp_register = core.rd_temp_register
        core.instruction_after_ID_RF = instruction
        core.temp_register_instruction_type = instruction_type
    end


    # core.ID_RF_temp_register = instruction
    # core.temp_register_instruction_type = instruction_type
    # core.instruction_after_ID_RF = instruction
end

function IF_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if core.pc > length(core.program)
        core.instruction_after_IF = "uninitialised"
        return
    else
        println("Instruction Fetch at clock cycle: ", processor.clock)
        instruction = core.program[core.pc]
        core.write_back_last_instruction = false
        core.pc += 1
        core.instruction_after_IF = instruction
    end
    # core.IF_temp_register = instruction
end