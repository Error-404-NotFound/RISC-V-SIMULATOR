# This file contains the execute function for each instruction
# The execute function takes a core and memory as input and modifies the core
# The core is modified by the execute function to simulate the instruction execution
# The run function is the main function that simulates the processor
# The run function calls the execute function to simulate the instruction execution
# The main function is the entry point of the program
# The main function creates a processor and runs the simulation

include("utility.jl")
include("core.jl")
# using .Core_Module

function execute(core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    core.program[core.pc] = replace_registers(core.program[core.pc])
    parts = split(core.program[core.pc], " ")
    parts = remove_empty_strings(parts)
    opcode = parts[1]


    if opcode == "add"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] + core.registers[rs2]
    
    elseif opcode == "sub"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] - core.registers[rs2]

    elseif opcode == "sll"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] << core.registers[rs2]
    
    elseif opcode == "slt"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] < core.registers[rs2] ? 1 : 0

    elseif opcode == "sltu"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] < core.registers[rs2] ? 1 : 0

    elseif opcode == "xor"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] ⊻ core.registers[rs2]

    elseif opcode == "srl"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] >>> core.registers[rs2]

    elseif opcode == "sra"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] >> core.registers[rs2]

    elseif opcode == "or"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] | core.registers[rs2]

    elseif opcode == "and"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] & core.registers[rs2]

    elseif opcode == "mul"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        rs2 = parse(Int, parts[4][2:end]) + 1
        core.registers[rd] = core.registers[rs1] * core.registers[rs2]

    

    elseif opcode == "addi"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] + imm

    elseif opcode == "slti"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] < imm ? 1 : 0

    elseif opcode == "sltiu"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] < imm ? 1 : 0

    elseif opcode == "xori"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] ⊻ imm

    elseif opcode == "ori"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] | imm

    elseif opcode == "andi"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] & imm

    elseif opcode == "slli"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        shamt = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] << shamt

    elseif opcode == "srli"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        shamt = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] >>> shamt

    elseif opcode == "srai"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        shamt = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] >> shamt

    elseif opcode == "muli"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] * imm

    
    # lb rd offset(rs1)
    # lb rd offset rs1
    elseif opcode == "lb"
        rd = parse(Int, parts[2][2:end]) + 1
        offset = parse(Int, parts[3])
        rs1 = parse(Int, parts[4][2:end]) + 1
        # temp_col = (core.registers[rs1] + offset) % 4
        # if temp_col == 0
        #     temp_col = 4
        # end
        # temp_row = (core.registers[rs1] - temp_col + offset) ÷ 4 + 1
        # binary_string = int_to_binary_32bits(core.registers[rs1])
        address = core.registers[rs1] + offset
        temp_row,temp_col = get_row_col_from_address(address)
        core.registers[rd] = load_one_byte(memory, temp_row, temp_col)

    # lh rd offset(rs1)
    # lh rd offset rs1
    elseif opcode == "lh"
        rd = parse(Int, parts[2][2:end]) + 1
        offset = parse(Int, parts[3])
        rs1 = parse(Int, parts[4][2:end]) + 1
        # temp_col = (core.registers[rs1] + offset) % 4
        # if temp_col == 0
        #     temp_col = 4
        # end
        # temp_row = (core.registers[rs1] - temp_col + offset) ÷ 4 + 1
        # binary_string = int_to_binary_32bits(core.registers[rs1])
        address = core.registers[rs1] + offset
        temp_row,temp_col = get_row_col_from_address(address)
        core.registers[rd] = load_half_word(memory, temp_row, temp_col)

    # lw rd offset(rs1)
    # lw rd offset rs1
    elseif opcode == "lw"
        rd = parse(Int, parts[2][2:end]) + 1
        offset = parse(Int, parts[3])
        rs1 = parse(Int, parts[4][2:end]) + 1
        address = core.registers[rs1] + offset
        temp_row,temp_col = get_row_col_from_address(address)
        # temp_col = (core.registers[rs1] + offset) % 4 + 1
        # # if temp_col == 0
        # #     temp_col = 4
        # # end
        # temp_row = (core.registers[rs1] - temp_col + offset + 1) ÷ 4 + 1
        # binary_string = int_to_binary_32bits(core.registers[rs1])
        core.registers[rd] = load_word(memory, temp_row, temp_col)
        
    # lbu rd offset(rs1)
    # lbu rd offset rs1
    elseif opcode == "lbu"
        rd = parse(Int, parts[2][2:end]) + 1
        offset = parse(Int, parts[3])
        rs1 = parse(Int, parts[4][2:end]) + 1
        # temp_col = (core.registers[rs1] + offset) % 4
        # if temp_col == 0
        #     temp_col = 4
        # end
        # temp_row = (core.registers[rs1] - temp_col + offset) ÷ 4 + 1
        # binary_string = int_to_binary_32bits(core.registers[rs1])
        address = core.registers[rs1] + offset
        temp_row,temp_col = get_row_col_from_address(address)
        core.registers[rd] = load_one_byte(memory, temp_row, temp_col)

    # lhu rd offset(rs1)
    # lhu rd offset rs1
    elseif opcode == "lhu"
        rd = parse(Int, parts[2][2:end]) + 1
        offset = parse(Int, parts[3])
        rs1 = parse(Int, parts[4][2:end]) + 1
        # temp_col = (core.registers[rs1] + offset) % 4
        # if temp_col == 0
        #     temp_col = 4
        # end
        # temp_row = (core.registers[rs1] - temp_col + offset) ÷ 4 + 1
        # binary_string = int_to_binary_32bits(core.registers[rs1])
        address = core.registers[rs1] + offset
        temp_row,temp_col = get_row_col_from_address(address)
        core.registers[rd] = load_half_word(memory, temp_row, temp_col)

    # la rd label
    elseif opcode == "la"
        rd = parse(Int, parts[2][2:end]) + 1
        label = parts[3]
        #find the label in the variable_address dictionary
        if haskey(variable_address, label)
            value = variable_address[label]
            # temp_col = value % 4
            # if temp_col == 0
            #     temp_col = 4
            # end
            # temp_row=(value-temp_col)÷4 + 1 
            core.registers[rd] = value
        else
            println("Label $label not found in the dictionary.")
        end

    # sb rs2 offset(rs1)
    # sb rs2 offset rs1
    elseif opcode == "sb"
        rs2 = parse(Int, parts[2][2:end]) + 1
        offset = parse(Int, parts[3])
        rs1 = parse(Int, parts[4][2:end]) + 1
        # temp_col = (core.registers[rs1] + offset) % 4
        # if temp_col == 0
        #     temp_col = 4
        # end
        # temp_row = (core.registers[rs1] - temp_col + offset) ÷ 4 + 1
        address = core.registers[rs1] + offset
        temp_row,temp_col = get_row_col_from_address(address)
        binary_string = int_to_binary_bits_modified(core.registers[rs2],32)
        store_one_byte(binary_string, memory, temp_row, temp_col)

    # sh rs2 offset(rs1)
    # sh rs2 offset rs1
    elseif opcode == "sh"
        rs2 = parse(Int, parts[2][2:end]) + 1
        offset = parse(Int, parts[3])
        rs1 = parse(Int, parts[4][2:end]) + 1
        # temp_col = (core.registers[rs1] + offset) % 4
        # if temp_col == 0
        #     temp_col = 4
        # end
        # temp_row = (core.registers[rs1] - temp_col + offset) ÷ 4 + 1
        address = core.registers[rs1] + offset
        temp_row,temp_col = get_row_col_from_address(address)
        binary_string = int_to_binary_bits_modified(core.registers[rs2],32)
        store_half_word(binary_string, memory, temp_row, temp_col)

    # sw rs2 offset(rs1)
    # sw rs2 offset rs1
    elseif opcode == "sw"
        rs2 = parse(Int, parts[2][2:end]) + 1
        offset = parse(Int, parts[3])
        rs1 = parse(Int, parts[4][2:end]) + 1
        # temp_col = (core.registers[rs1] + offset) % 4
        # if temp_col == 0
        #     temp_col = 4
        # end
        # temp_row = (core.registers[rs1] - temp_col + offset) ÷ 4 + 1
        address = core.registers[rs1] + offset
        temp_row,temp_col = get_row_col_from_address(address)
        binary_string = int_to_binary_bits_modified(core.registers[rs2],32)
        store_word(binary_string, memory, temp_row, temp_col)


    elseif opcode == "beq"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        label = parts[4]
        if core.registers[rs1] == core.registers[rs2]
            core.pc = findfirst(x -> x == label, core.program)
        else
            core.pc = core.pc
        end

    elseif opcode == "bne"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        label = parts[4]
        if core.registers[rs1] != core.registers[rs2]
            core.pc = findfirst(x -> x == label, core.program)
        else
            core.pc = core.pc
        end

    elseif opcode == "blt"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        label = parts[4]
        if core.registers[rs1] < core.registers[rs2]
            core.pc = findfirst(x -> x == label, core.program)
        else
            core.pc = core.pc
        end

    elseif opcode == "ble"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        label = parts[4]
        if core.registers[rs1] <= core.registers[rs2]
            core.pc = findfirst(x -> x == label, core.program)
        else
            core.pc = core.pc
        end

    elseif opcode == "bge"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        label = parts[4]
        if core.registers[rs1] >= core.registers[rs2]
            core.pc = findfirst(x -> x == label, core.program)
        else
            core.pc = core.pc
        end

    elseif opcode == "bltu"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        label = parts[4]
        if core.registers[rs1] < core.registers[rs2]
            core.pc = findfirst(x -> x == label, core.program)
        else
            core.pc = core.pc
        end

    elseif opcode == "bgeu"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        label = parts[4]
        if core.registers[rs1] >= core.registers[rs2]
            core.pc = findfirst(x -> x == label, core.program)
        else
            core.pc = core.pc
        end

    
    elseif opcode == "jal"
        rd = parse(Int, parts[2][2:end]) + 1
        label = parts[3]
        core.registers[rd] = core.pc + 1
        core.pc = findfirst(x -> x == label, core.program)

    elseif opcode == "jr"
        rs1 = parse(Int, parts[2][2:end]) + 1
        core.pc = core.registers[rs1] - 1

    elseif opcode == "jalr"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = core.pc + 1
        core.pc = core.registers[rs1] + imm - 1

    elseif opcode == "j"
        label = parts[2]
        core.pc = findfirst(x -> x == label, core.program)

    
    elseif opcode == "mv"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        core.registers[rd] = core.registers[rs1]

    elseif opcode == "li"
        rd = parse(Int, parts[2][2:end]) + 1
        imm = parse(Int, parts[3])
        core.registers[rd] = imm

    elseif opcode == "ecall"
        if core.registers[18] == 10
            println("\nProgram exited with code 0")
            core.pc = length(core.program) + 1

        elseif core.registers[18] == 1
            print(core.registers[11])

        elseif core.registers[18] == 4
            temp_address = core.registers[11]
            temp_row, temp_col = get_row_col_from_address(temp_address)
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
        elseif core.registers[18] == 11
            print(Char(core.registers[11]))
        else
            println("Invalid ecall instruction.for $(core.registers[18]) code")
        end
    end
    core.pc += 1
end