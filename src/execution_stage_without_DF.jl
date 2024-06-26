include("core.jl")
include("utility.jl")

function execute_stage_without_DF(instruction::String, instruction_type::String, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    # println(instruction, " ", instruction_type)
    # parts = split(instruction, " ")
    # parts = remove_empty_strings(parts)
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
    foreach(kv -> opcode in kv[2] && (instruction_type = kv[1]; return), opcode_dictionary)
    # println(instruction)

    if instruction_type == "R_type_instructions"
        if opcode == "ecall"
            core.EX_temp_register = execute_ECALL(core, memory, variable_address)
        else
            core.EX_temp_register = execute_R(core, memory, variable_address)
        end
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
    # parts = split(instruction, " ")
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
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
    # println(instruction)
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
    elseif opcode == "j"
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
        core.temp_register_string = core.instruction_after_IF
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] == core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            # println("hello")
            core.pc = core.pc
            core.instruction_after_IF = core.temp_register_string
            # println(core.instruction_after_IF)
        end
        return core.pc

    elseif opcode == "bne"
        temp_instruction = core.instruction_after_IF
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] != core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            # println(core.pc)
            core.pc = core.pc
            core.instruction_after_IF = temp_instruction
        end
        return core.pc

    elseif opcode == "blt"
        temp_instruction = core.instruction_after_IF
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] < core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
            core.instruction_after_IF = temp_instruction
        end
        return core.pc

    elseif opcode == "ble"
        temp_instruction = core.instruction_after_IF
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] <= core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
            core.instruction_after_IF = temp_instruction
        end
        return core.pc

    elseif opcode == "bge"
        temp_instruction = core.instruction_after_IF
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] >= core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
            core.instruction_after_IF = temp_instruction
        end
        return core.pc

    elseif opcode == "bltu"
        temp_instruction = core.instruction_after_IF
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] < core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
            core.instruction_after_IF = temp_instruction
        end
        return core.pc

    elseif opcode == "bgeu"
        temp_instruction = core.instruction_after_IF
        core.instruction_after_IF = "uninitialised"
        if core.registers[core.rs1_temp_register] >= core.registers[core.rs2_temp_register]
            core.pc = findfirst(x -> x == core.label_temp_register, core.program) + 1
            core.stall_at_EX = true
        else
            core.pc = core.pc
            core.instruction_after_IF = temp_instruction
        end
        return core.pc
    end
end

function execute_ECALL(core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    
    instruction = core.instruction_after_ID_RF
    # parts = split(instruction, " ")
    # opcode = parts[1]
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
    if opcode == "ecall"
        if core.registers[18] == 1
            print(core.registers[11])
        elseif core.registers[18] == 10
            println("\nProgram exited with code: 0")
            core.pc = length(core.program) + 1
        elseif core.registers[18] == 11
            print(Char(core.registers[11]))
        elseif core.registers[18] == 4
            temp_address = core.registers[11]
            temp_row, temp_col = get_row_col_from_address(temp_address)
            # println(temp_address)
            # println(temp_row, " ", temp_col)
            # temp_col = (core.registers[11] ) % 4
            # if temp_col == 0
            #     temp_col = 4
            # end
            # temp_row = (core.registers[11] - temp_col) ÷ 4 + 1
            counter = 0
            while memory[temp_row, temp_col] != 0
                #handle new line
                if Char(memory[temp_row, temp_col]) == '\\'
                    counter=1
                elseif counter ==1 && Char(memory[temp_row, temp_col]) == 'n'
                    println()
                    counter=2
                else
                    print(Char(memory[temp_row, temp_col]))
                    counter=2
                end
                temp_col += 1
                if temp_col > 4
                    temp_col = 1
                    temp_row += 1
                end
            end
        else
            println("Invalid ecall instruction for $(core.registers[18]) code.")
        end
    end
    return 0
end

function SIMD(instruction::String, core::Core1, memory::Array{Int,2}, variable_address::Dict{String,Int},counter::Int)
    dest = core.dest
    src1 = core.src1
    src2 = core.src2
    dest_temp=0
    src1_temp=0
    src2_temp=0
    parts, opcode = get_parts_and_opcode_from_instruction(instruction)
    if haskey(variable_address,dest)
        dest_temp = variable_address[dest]
    else
        dest_temp = -1
    end
    if haskey(variable_address,src1)
        src1_temp = variable_address[src1]
    else
        src1_temp = -1
    end
    if haskey(variable_address,src2)
        src2_temp = variable_address[src2]
    else
        src2_temp = -1
    end
    if dest_temp != -1 && src1_temp != -1 && src2_temp != -1
        while counter!=8
            dest_row, dest_col = get_row_col_from_address(dest_temp+counter*4)
            src1_row, src1_col = get_row_col_from_address(src1_temp+counter*4)
            src2_row, src2_col = get_row_col_from_address(src2_temp+counter*4)
            temp_var1 = load_word(memory, src1_row, src1_col)
            temp_var2 = load_word(memory, src2_row, src2_col)
            final_var = temp_var1 + temp_var2
            final_str = int_to_binary_32bits(final_var)
            store_word(final_str, memory, dest_row, dest_col)
            counter+=1
        end
    end
end