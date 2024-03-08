include("processor.jl")
include("core.jl")
include("execute_instructions.jl")
include("utility.jl")
include("execution_stage.jl")

function run(processor::Processor, variable_address::Dict{String, Int},index::Int) 
    while !processor.cores[index].write_back_last_instruction
        processor.clock += 1
        if processor.cores[index].stall_in_present_clock_cycle
            println("Stalled at clock cycle: ", processor.clock)
            # processor.cores[index].stall_in_present_clock_cycle = false
            processor.cores[index].stall_count += 1
        end
        WB_stage(processor, processor.cores[index], processor.memory, variable_address)
        MEM_stage(processor, processor.cores[index], processor.memory, variable_address)
        EX_stage(processor, processor.cores[index], processor.memory, variable_address)
        ID_RF_stage(processor, processor.cores[index], processor.memory, variable_address)
        IF_stage(processor, processor.cores[index], processor.memory, variable_address)
    end
end


# Function to execute the instructions in the pipeline

# Function for the Write Back stage

function WB_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    core.instruction_after_WB = instruction = core.instruction_after_MEM
    if instruction != "uninitialised"
        println("Write Back at clock cycle: ", processor.clock)
        parts, opcode = get_parts_and_opcode_from_instruction(instruction)
        rd = parse(Int, replace_registers(parts[2])[2:end]) + 1
        instruction_type = nothing
        foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
        if instruction_type == "R_type_instructions"
            core.registers[rd] = core.MEM_temp_register
        elseif instruction_type == "I_type_instructions"
            core.registers[rd] = core.MEM_temp_register
        elseif instruction_type == "L_type_instructions"
            core.registers[rd] = core.MEM_temp_register
        elseif opcode == "jal" || opcode == "la"
            core.registers[rd] = core.MEM_temp_register
        end
        core.instruction_count += 1
        core.write_back_last_instruction = true
        core.write_back_previous_last_instruction = true
    end
    core.registers[1] = 0
end

# Function for the Memory Access stage

function MEM_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    memory = processor.memory
    core.instruction_after_MEM = instruction = core.instruction_after_EX
    if instruction != "uninitialised"
        println("Memory Access at clock cycle: ", processor.clock)
        core.MEM_temp_register = address = core.EX_temp_register
        parts, opcode = get_parts_and_opcode_from_instruction(instruction)
        instruction_type = nothing
        foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
        if instruction_type == "L_type_instructions"
            row, col = get_row_col_from_address(address)
            core.MEM_temp_register = load_word(memory, row, col)
        elseif instruction_type == "S_type_instructions"
            row, col = get_row_col_from_address(address)
            rs2 = parse(Int, parts[2][2:end]) + 1
            binary_string = int_to_binary_bits_modified(core.registers[rs2], 32)
            store_word(binary_string, memory, row, col)
        elseif opcode == "jal" || opcode == "la"
            core.MEM_temp_register = address 
        end
        core.write_back_last_instruction = false
        if core.write_back_previous_last_instruction
            return
        end
        if core.instruction_after_WB != "uninitialised"
            core.write_back_previous_last_instruction = true
        else
            core.write_back_previous_last_instruction = false
        end
    end
    core.registers[1] = 0
end


# Function for the Execution stage with data forwarding
function EX_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if core.stall_in_present_clock_cycle || core.stall_at_EX
        core.instruction_after_EX = "uninitialised"
        return
    end

    core.instruction_after_EX = instruction = core.instruction_after_ID_RF
    
    if instruction != "uninitialised"
        println("Execution at clock cycle: ", processor.clock)
        instruction_type = core.temp_register_instruction_type
        
        # Check for data forwarding
        rs1_value = core.registers[core.rs1_temp_register]
        rs2_value = core.registers[core.rs2_temp_register]
        
        if core.rs1_temp_register == core.rd_temp_register_previous_instruction
            core.registers[core.rs1_temp_register] = core.MEM_temp_register
            rs1_value = core.MEM_temp_register
            println("rs1: ",rs1_value)
            println("rs2: ",rs2_value)
        end
        
        if core.rs2_temp_register == core.rd_temp_register_previous_instruction
            core.registers[core.rs2_temp_register] = core.MEM_temp_register
            rs2_value = core.MEM_temp_register
            println("rs1: ",rs1_value)
            println("rs2: ",rs2_value)
        end
        
        if core.rs1_temp_register == core.rd_temp_register
            core.registers[core.rs1_temp_register] = core.EX_temp_register
            rs1_value = core.EX_temp_register
            println("rs1: ",rs1_value)
            println("rs2: ",rs2_value)
        end
        
        if core.rs2_temp_register == core.rd_temp_register
            core.registers[core.rs2_temp_register] = core.EX_temp_register
            rs2_value = core.EX_temp_register
            println("rs1: ",rs1_value)
            println("rs2: ",rs2_value)
        end
        
        # Call execute_stage with corrected arguments
        core.EX_temp_register = execute_stage(instruction, instruction_type, core, memory, variable_address)
        core.write_back_last_instruction = false
    end
    core.registers[1] = 0
end


# Function for the Instruction Decode and Register Fetch stage with data forwarding
function ID_RF_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if core.stall_in_present_clock_cycle
        return
    end
    
    core.instruction_after_ID_RF = instruction = core.instruction_after_IF

    if instruction != "uninitialised"
        println("Instruction Decoded at clock cycle: ", processor.clock)

        instruction = replace_registers(instruction)
        parts, opcode = get_parts_and_opcode_from_instruction(instruction)
        instruction_type = nothing
        foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
        if !isnothing(instruction_type)

            if instruction_type == "R_type_instructions"
                rd = parse(Int, parts[2][2:end]) + 1
                core.rs1_temp_register = parse(Int, parts[3][2:end]) + 1
                core.rs2_temp_register = parse(Int, parts[4][2:end]) + 1
                
            elseif instruction_type == "I_type_instructions"
                if opcode == "li"
                    core.rs1_temp_register = 0 + 1
                    rd = parse(Int, parts[2][2:end]) + 1
                    core.immediate_temp_register = core.rs2_temp_register = parse(Int, parts[3])
                elseif opcode == "mv"
                    rd = parse(Int, parts[2][2:end]) + 1
                    core.rs1_temp_register = parse(Int, parts[3][2:end]) + 1
                    core.immediate_temp_register = 0
                elseif opcode == "jr"
                    core.rs1_temp_register = 0 + 1
                    rd = parse(Int, parts[2][2:end]) + 1
                    core.immediate_temp_register = 0
                else
                    rd = parse(Int, parts[2][2:end]) + 1
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
        
        core.write_back_last_instruction = false
        core.rd_temp_register_previous_instruction = core.rd_temp_register
        core.rd_temp_register = rd
        core.instruction_after_ID_RF = instruction
        core.temp_register_instruction_type = instruction_type
    end
    core.registers[1] = 0
end

function IF_stage(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})

    # Stall Handling Logic for the IF stage

    if core.stall_at_jump_instruction
        core.stall_at_jump_instruction = false
        core.stall_count += 1
        core.instruction_after_IF = "uninitialised"
        return
    end

    if core.stall_at_IF
        core.instruction_after_IF = "uninitialised"
        core.stall_at_IF = false
        core.stall_count += 1
        if core.stall_in_next_clock_cycle
            core.stall_in_present_clock_cycle = true
            core.stall_in_next_clock_cycle = false
        end
        return
    end

    if core.stall_at_EX
        if core.write_back_previous_last_instruction
            core.stall_at_EX = false
            core.stall_in_present_clock_cycle = false
            return
        end
    end

    if core.stall_in_present_clock_cycle
        if core.write_back_last_instruction
            core.stall_in_present_clock_cycle = false
            core.write_back_last_instruction = false
            core.write_back_previous_last_instruction = true
        else
            core.stall_in_present_clock_cycle = true
        end
        return
    end
        
    if core.pc <= length(core.program)
        println("Instruction Fetch at clock cycle: ", processor.clock)
        instruction = core.program[core.pc]
        core.write_back_last_instruction = false
        core.pc += 1
        core.instruction_after_IF = instruction
    else
        core.instruction_after_IF = "uninitialised"
    end

    if core.stall_in_next_clock_cycle
        core.stall_in_present_clock_cycle = true
        core.stall_in_next_clock_cycle = false
    end
    core.registers[1] = 0
end