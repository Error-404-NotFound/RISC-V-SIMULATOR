include("processor.jl")
include("core.jl")
# include("execute_instructions.jl")
include("utility.jl")
include("execution_stage_with_DF.jl")

function run_piped_w_df(processor::Processor, variable_address::Dict{String, Int},index::Int) 
    while !processor.cores[index].write_back_last_instruction
        processor.clock += 1
        if processor.cores[index].stall_in_present_clock_cycle
            # println("Stalled at clock cycle this: ", processor.clock)
            # processor.cores[index].stall_in_present_clock_cycle = false
            processor.cores[index].stall_count += 1
        end
        WB_stage_df(processor, processor.cores[index], processor.memory, variable_address)
        MEM_stage_df(processor, processor.cores[index], processor.memory, variable_address)
        EX_stage_df(processor, processor.cores[index], processor.memory, variable_address)
        ID_RF_stage_df(processor, processor.cores[index], processor.memory, variable_address)
        IF_stage_df(processor, processor.cores[index], processor.memory, variable_address)
    end
end


# Function to execute the instructions in the pipeline

# Function for the Write Back stage

function WB_stage_df(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    core.instruction_after_WB = instruction = core.instruction_after_MEM
    if instruction != "uninitialised"
        # println("Write Back at clock cycle: ", processor.clock)
        # println(instruction)
        parts, opcode = get_parts_and_opcode_from_instruction(instruction)
        if opcode == "j"
            rd = 0
            core.write_back_last_instruction = false
            # return
        elseif opcode == "ecall"
            rd = 1
        else
            rd = parse(Int, replace_registers(parts[2])[2:end]) + 1
        end
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
        # println(instruction)
        core.instruction_count += 1
        if opcode == "jr"
            core.instruction_count -= 1
        elseif opcode == "la"
            core.instruction_count += 1
            processor.clock += 2
        end
        core.write_back_last_instruction = true
        core.write_back_previous_last_instruction = true
    end
    core.registers[1] = 0
end

# Function for the Memory Access stage

function MEM_stage_df(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    memory = processor.memory
    core.instruction_after_MEM = instruction = core.instruction_after_EX
    if instruction != "uninitialised"
        # println("Memory Access at clock cycle: ", processor.clock)
        core.MEM_temp_register = address = core.EX_temp_register
        # println("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
        # println(address)
        parts, opcode = get_parts_and_opcode_from_instruction(instruction)
        instruction_type = nothing
        foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
        if instruction_type == "L_type_instructions"
            row, col = get_row_col_from_address(address)
            core.MEM_temp_register = load_word(memory, row, col)
        elseif instruction_type == "S_type_instructions"
            row, col = get_row_col_from_address(address)
            # println(row, " ", col)
            rs2 = parse(Int, parts[2][2:end]) + 1
            # println(rs2)
            # println(core.registers[rs2])
            binary_string = int_to_binary_32bits(core.registers[rs2])
            # println(binary_string)
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

# Function for the Execution stage
# Function for the Execution stage with data forwarding
function EX_stage_df(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if core.stall_in_present_clock_cycle || core.stall_at_EX
        core.instruction_after_EX = "uninitialised"
        return
    end

    core.instruction_after_EX = instruction = core.instruction_after_ID_RF
    
    if instruction != "uninitialised"
        instruction_type = core.temp_register_instruction_type
        parts, opcode = get_parts_and_opcode_from_instruction(instruction)
        # println("Execution at clock cycle: ", processor.clock)
        instruction_type = core.temp_register_instruction_type
        

        if (instruction_type == "R_type_instructions")
            rs1_value = core.registers[core.rs1_temp_register]
            rs2_value = core.registers[core.rs2_temp_register]
        elseif (instruction_type == "I_type_instructions")
            rs1_value = core.registers[core.rs1_temp_register]
        elseif (instruction_type == "J_type_instructions")
            rs1_value = core.registers[core.rs1_temp_register]
        end
            # rs2_value = core.immediate_temp_register
        # Check for data forwarding

        
        if core.rs1_temp_register == core.rd_temp_register_previous_instruction && core.rs1_temp_register!=-1
            core.registers[core.rs1_temp_register] = core.MEM_temp_register
            rs1_value = core.MEM_temp_register
        
        end
        
        if core.rs2_temp_register == core.rd_temp_register_previous_instruction && core.rs2_temp_register!=-1
            core.registers[core.rs2_temp_register] = core.MEM_temp_register
            rs2_value = core.MEM_temp_register
    
        end
        
        if core.rs1_temp_register == core.rd_temp_register && core.rs1_temp_register!=-1
            core.registers[core.rs1_temp_register] = core.EX_temp_register
            rs1_value = core.EX_temp_register
            end
        
        if core.rs2_temp_register == core.rd_temp_register && core.rs2_temp_register!=-1
            core.registers[core.rs2_temp_register] = core.EX_temp_register
            rs2_value = core.EX_temp_register
        end
        if opcode == "mul"
            core.stall_at_EX = true
            processor.clock += 3
        end
        # Call execute_stage with corrected arguments
        core.EX_temp_register = execute_stage_with_DF(instruction, instruction_type, core, memory, variable_address)
        core.write_back_last_instruction = false
    end
    core.registers[1] = 0
end

# Function for the Instruction Decode and Register Fetch stage

function ID_RF_stage_df(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if core.stall_in_present_clock_cycle
        return
    end
    
    core.instruction_after_ID_RF = instruction = core.instruction_after_IF

    if instruction != "uninitialised"
        # println("Instruction Decoded at clock cycle: ", processor.clock)
        # println(instruction)
        instruction = replace_registers(instruction)
        parts, opcode = get_parts_and_opcode_from_instruction(instruction)
        instruction_type = nothing
        foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
        if !isnothing(instruction_type)

            if instruction_type == "R_type_instructions"
                rd = parse(Int, parts[2][2:end]) + 1
                core.rs1_temp_register = parse(Int, parts[3][2:end]) + 1
                core.rs2_temp_register = parse(Int, parts[4][2:end]) + 1
                # println(core.rs1_temp_register, " ", core.rd_temp_register, " ", core.rd_temp_register_previous_instruction, " ", core.write_back_previous_last_instruction)
                # if core.rs2_temp_register == core.rd_temp_register || core.rs1_temp_register == core.rd_temp_register
                #     core.stall_in_next_clock_cycle = true
                # elseif core.rs1_temp_register == core.rd_temp_register_previous_instruction || core.rs2_temp_register == core.rd_temp_register_previous_instruction
                #     if !core.write_back_previous_last_instruction
                #         core.stall_at_EX = true
                #         core.stall_in_next_clock_cycle = true
                #     end
                # end

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
                # if core.rs1_temp_register == core.rd_temp_register
                #     core.stall_in_next_clock_cycle = true
                # elseif core.rs1_temp_register == core.rd_temp_register_previous_instruction
                #     if !core.write_back_previous_last_instruction
                #         core.stall_at_EX = true
                #         core.stall_in_next_clock_cycle = true
                #     end 
                # end

            elseif instruction_type == "L_type_instructions"
                rd = parse(Int, parts[2][2:end]) + 1
                core.immediate_temp_register = parse(Int, parts[3])
                core.rs1_temp_register = parse(Int, parts[4][2:end]) + 1
                if core.rs2_temp_register == core.rd_temp_register || core.rs1_temp_register == core.rd_temp_register
                    core.stall_in_next_clock_cycle = true
                elseif core.rs1_temp_register == core.rd_temp_register_previous_instruction || core.rs2_temp_register == core.rd_temp_register_previous_instruction
                    if !core.write_back_previous_last_instruction
                        core.stall_at_EX = true
                        core.stall_in_next_clock_cycle = true
                    end
                end

            elseif instruction_type == "S_type_instructions"
                core.rs2_temp_register = parse(Int, parts[2][2:end]) + 1
                core.immediate_temp_register = parse(Int, parts[3])
                core.rs1_temp_register = parse(Int, parts[4][2:end]) + 1
                # println("*****************************************************")
                # println(core.rs1_temp_register, " ", core.rs2_temp_register, " ", core.immediate_temp_register, " ", core.write_back_previous_last_instruction)
                rd = parse(Int, parts[2][2:end]) + 1
                # println(rd)
                if core.rs2_temp_register == core.rd_temp_register || core.rs1_temp_register == core.rd_temp_register
                    core.stall_in_next_clock_cycle = true
                elseif core.rs1_temp_register == core.rd_temp_register_previous_instruction || core.rs2_temp_register == core.rd_temp_register_previous_instruction
                    if !core.write_back_previous_last_instruction
                        core.stall_at_EX = true
                        core.stall_in_next_clock_cycle = true
                    end
                end

            elseif instruction_type == "SB_type_instructions"
                core.rs1_temp_register = parse(Int, parts[2][2:end]) + 1
                core.rs2_temp_register = parse(Int, parts[3][2:end]) + 1
                core.label_temp_register = parts[4]
                rd = parse(Int, parts[2][2:end]) + 1
                
            elseif instruction_type == "U_type_instructions"
                core.rd_temp_register = parse(Int, parts[2][2:end]) + 1
                core.immediate_temp_register = parse(Int, parts[3])

            elseif instruction_type == "UJ_type_instructions"
                if opcode == "j"
                    rd = 0
                    core.label_temp_register = parts[2]
                else
                    rd = parse(Int, parts[2][2:end]) + 1
                    core.label_temp_register = parts[3]
                end
                core.rd_temp_register_previous_instruction = core.rd_temp_register
                core.rd_temp_register = -1
                core.stall_at_jump_instruction = true
                return
            
            # elseif instruction_type == "ECALL"
            #     instruction = "add x0 x11 x18"
            #     # core.rs1_temp_register = -1
            #     # core.rs2_temp_register = -1
            #     # core.immediate_temp_register = 0
            #     # core.rd_temp_register_previous_instruction = core.rd_temp_register
            #     # core.rd_temp_register = -1
            #     # core.stall_at_jump_instruction = true
            #     # core.stall_at_EX = true
            #     # println("****************************")
            #     # println(core.rs1_temp_register, " ", core.rs2_temp_register, " ", core.immediate_temp_register, " ", core.rd_temp_register_previous_instruction, " ", core.rd_temp_register, " ", core.write_back_previous_last_instruction)

            #     if core.rs2_temp_register == 18 || core.rs1_temp_register == 11
            #         core.stall_in_next_clock_cycle = true
            #     elseif core.rs1_temp_register == 11 || core.rs2_temp_register == 18
            #         if !core.write_back_previous_last_instruction
            #             core.stall_at_EX = true
            #             core.stall_in_next_clock_cycle = true
            #         end
                # end
                # return
            end
        end

        if instruction_type == "SB_type_instructions"
            # println(core.rs1_temp_register)
            # println(core.rs2_temp_register)
            # println(core.rd_temp_register)
            # println(core.rd_temp_register_previous_instruction)
            # println(rd)
            if core.rs1_temp_register == core.rd_temp_register || rd == core.rd_temp_register || core.rs2_temp_register == core.rd_temp_register
                core.stall_in_next_clock_cycle = true
                core.write_back_last_instruction = false
                core.stall_at_IF = false
                core.rd_temp_register_previous_instruction = core.rd_temp_register
                core.rd_temp_register = rd
                core.instruction_after_ID_RF = instruction
                core.temp_register_instruction_type = instruction_type
                return
            end

            if core.rs1_temp_register == core.rd_temp_register_previous_instruction || rd == core.rd_temp_register_previous_instruction || core.rs2_temp_register == core.rd_temp_register_previous_instruction
                # println("hello")
                # println(core.write_back_previous_last_instruction)
                # println(core.write_back_last_instruction)
                if !core.write_back_previous_last_instruction
                    core.stall_at_IF = true
                    core.stall_at_EX = true
                    core.stall_in_next_clock_cycle = true
                end
                core.stall_at_IF = true
                # core.write_back_last_instruction = false
                return
            end

            if opcode == "beq"
                if core.registers[core.rs1_temp_register] == core.registers[core.rs2_temp_register]
                    temp_dest = findfirst(x -> x == core.label_temp_register, core.program)
                    if temp_dest-1 < core.pc
                        core.stall_at_IF = true
                        # core.stall_in_next_clock_cycle = true
                        if core.stall_at_EX && core.stall_in_next_clock_cycle
                            core.stall_at_EX = false
                            core.stall_in_next_clock_cycle = false
                        end
                    end
                end
            end

            if opcode == "bne"
                if core.registers[core.rs1_temp_register] != core.registers[core.rs2_temp_register]
                    temp_dest = findfirst(x -> x == core.label_temp_register, core.program)
                    if temp_dest-1 < core.pc
                        core.stall_at_IF = true
                        # core.stall_in_next_clock_cycle = true
                        if core.stall_at_EX && core.stall_in_next_clock_cycle
                            core.stall_at_EX = false
                            core.stall_in_next_clock_cycle = false
                        end
                    end
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

# Function for the Instruction Fetch stage

function IF_stage_df(processor::Processor, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})

    # if core.inside_EX || core.inside_MEM || core.inside_ID_RF
    #     core.write_back_last_instruction = false
    #     core.inside_EX = false
    #     core.inside_MEM = false
    #     core.inside_ID_RF = false
    # end

    # Stall Handling Logic for the IF stage

    if core.stall_at_jump_instruction
        core.stall_at_jump_instruction = false
        core.stall_count += 1
        # println("Stalled at clock cycle: ", processor.clock)
        core.instruction_after_IF = "uninitialised"
        return
    end

    if core.stall_at_IF
        core.instruction_after_IF = "uninitialised"
        core.stall_at_IF = false
        core.stall_count += 1
        # println("Stalled at clock cycle1: ", processor.clock)
        if core.stall_in_next_clock_cycle
            core.stall_in_present_clock_cycle = true
            core.stall_in_next_clock_cycle = false
        end
        core.write_back_last_instruction = false
        # println("--------------stall at IF----------------")
        return
    end

    if core.stall_at_EX
        if core.write_back_previous_last_instruction
            core.stall_at_EX = false
            core.stall_in_present_clock_cycle = false
            core.write_back_last_instruction = false
            # println("--------------stall at EX----------------")
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
        core.stall_in_present_clock_cycle = false
        core.write_back_last_instruction = false
        # println("------------------------------")
        return
    end
        
    if core.pc <= length(core.program)
        # println("Instruction Fetch at clock cycle: ", processor.clock)
        instruction = core.program[core.pc]
        # println(instruction)
        parts, opcode = get_parts_and_opcode_from_instruction(instruction)
        if opcode in opcodes
            if opcode == "ecall"
                instruction = "ecall x1 x10 x17"
            end
            core.instruction_after_IF = instruction
            # println(instruction)
            core.pc += 1
        else
            core.pc += 1
            core.stall_at_IF = true
            instruction = core.program[core.pc]
            # println(instruction)
            core.instruction_after_IF = instruction
            core.pc += 1
        end
        core.write_back_last_instruction = false
        # core.pc += 1
        # core.instruction_after_IF = instruction
        # println(core.instruction_after_IF)
    else
        core.instruction_after_IF = "uninitialised"
    end

    if core.stall_in_next_clock_cycle
        core.stall_in_present_clock_cycle = true
        core.stall_in_next_clock_cycle = false
    end
    core.registers[1] = 0
end