include("processor.jl")
include("core.jl")
include("execute_instructions.jl")
include("utility.jl")
include("execution_stage.jl")

function run(processor::Processor, variable_address::Dict{String, Int},index::Int) 
    while !processor.cores[index].write_back_last_instruction
        processor.clock += 1
        if processor.cores[index].is_stalled
            println("Stalled at clock cycle: ", processor.clock)
            processor.cores[index].number_of_stalls += 1
        end
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
        parts = split(instruction, " ")
        parts = remove_empty_strings(parts)
        opcode = parts[1]
        core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
        instruction_type = nothing
        foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
        if !isnothing(instruction_type)
            if instruction_type == "R_type_instructions"
                core.registers[core.rd_temp_register] = core.MEM_temp_register
            elseif instruction_type == "I_type_instructions"
                core.registers[core.rd_temp_register] = core.MEM_temp_register
            elseif instruction_type == "Load_type_instructions"
                core.registers[core.rd_temp_register] = core.MEM_temp_register
            elseif instruction_type == "S_type_instructions"
                core.registers[core.rd_temp_register] = core.MEM_temp_register
            elseif instruction_type == "SB_type_instructions"
                core.registers[core.rd_temp_register] = core.MEM_temp_register
            elseif instruction_type == "U_type_instructions"
                core.registers[core.rd_temp_register] = core.MEM_temp_register
            elseif instruction_type == "UJ_type_instructions"
                core.registers[core.rd_temp_register] = core.MEM_temp_register
            end
        end
        core.write_back_last_instruction = true
    end
end

function MEM_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    memory = processor.memory
    core.instruction_after_MEM = instruction = core.instruction_after_EX
    instruction_type = core.temp_register_instruction_type
    if instruction != "uninitialised"
        println("Memory Access at clock cycle: ", processor.clock)
        core.MEM_temp_register = address = core.EX_temp_register
        parts = split(instruction, " ")
        parts = remove_empty_strings(parts)
        opcode = parts[1]
        instruction_type = nothing
        foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
        if !isnothing(instruction_type)
            if instruction_type == "L_type_instructions"
                core.MEM_temp_register = memory[address]
            elseif instruction_type == "S_type_instructions"
                memory[address] = core.rs1_temp_register
                core.MEM_temp_register = core.rs1_temp_register
            end
        end

        core.write_back_last_instruction = false
    end
end

function EX_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if core.is_stalled
        core.instruction_after_EX = "uninitialised"
        return
    end
    core.instruction_after_EX = instruction = core.instruction_after_ID_RF
    if instruction != "uninitialised"
        println("Execution at clock cycle: ", processor.clock)
        instruction_type = core.temp_register_instruction_type
        core.EX_temp_register = execute_stage(instruction, instruction_type, core, memory, variable_address)
        core.write_back_last_instruction = false
    end
end

function ID_RF_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if core.is_stalled
        return
    end
    
    core.instruction_after_ID_RF = instruction = core.instruction_after_IF

    if instruction != "uninitialised"
        println("Instruction Decoded at clock cycle: ", processor.clock)

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
                    core.immediate_temp_register = parse(Int, parts[3])
                elseif opcode == "mv"
                    core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                    core.rs1_temp_register = parse(Int, parts[3][2:end]) + 1
                    core.immediate_temp_register = 0
                elseif opcode == "jr"
                    core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                    core.immediate_temp_register = 0
                else
                    core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                    core.rs1_temp_register = parse(Int, parts[3][2:end]) + 1
                    core.immediate_temp_register = parse(Int, parts[4])
                end

            elseif instruction_type == "L_type_instructions"
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
        # po
    
        # core.rs1_back2 = core.rs1_back1
        # core.rs2_back2 = core.rs2_back1
        # core.rs1_back1 = core.rs1_temp_register
        # core.rs2_back1 = core.rs2_temp_register
        if core.rs1_temp_register == core.rd_back1 || core.rs2_temp_register == core.rd_back1 || core.rs1_temp_register == core.rd_back2 || core.rs2_temp_register == core.rd_back2
            core.is_stalled = true
        end
        core.rd_back2 = core.rd_back1
        core.rd_back1 = core.rd_temp_register
        

        core.write_back_last_instruction = false
        core.rd_temp_register = core.rd_temp_register
        core.temp_register_instruction_type = instruction_type
    end
end

function IF_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if core.is_stalled
        if core.write_back_last_instruction
            core.is_stalled = false
            core.write_back_last_instruction = false
        end
        return
    end
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
    if core.is_stalled_next_cycle
        core.is_stalled = true
        core.is_stalled_next_cycle = false
    end
end