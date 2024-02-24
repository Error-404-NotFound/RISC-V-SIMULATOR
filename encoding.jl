include("core.jl")
include("utility.jl")

# using .Core_Module


opcodes = ["add", "sub", "sll", "slt", "sltu", "xor", "srl", "sra", "or", "and", "li", "addi", "slti", "sltiu", "xori", "ori", "andi", "slli", "srli", "srai", "lb", "lh", "lw", "lbu", "lhu", "sb", "sh", "sw", "beq", "bne", "blt", "bge", "bltu", "bgeu", "lui", "auipc", "jal", "j", "jalr","ecall","jr"]
#write a function to give the total no. of non opcodes till the given index in the program
function handle_non_opcodes(core::Core1, index::Int)
    count=0
    for i in 1:index
        parts = split(core.program[i], " ")
        if parts[1] in opcodes
            continue
        else
            count+=1
        end
    end
    return count
end



function encode_text_and_store_in_memory(core::Core1, memory::Array{Int,2}, initial_address::Int)
    core.pc =  memory_address = initial_address
    while(core.pc-initial_address+1 <= length(core.program))
        parts = split(core.program[core.pc-initial_address+1], " ")

        R_type_instrucion = "0110011"
        I_type_instrucion = "0010011"
        S_type_instrucion = "0100011"
        SB_type_instrucion = "1100011"
        U_type_instrucion = "0110111"
        J_type_instrucion = "1101111"
        Load_instrucion = "0000011"
        JALR_instrucion = "1100111"

        opcode = parts[1]

        if opcode == "add"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            rs2 = parse(Int, parts[4][2:end])
            binary_string = "0000000" * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "000" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "sub"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            rs2 = parse(Int, parts[4][2:end])
            binary_string = "0100000" * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "000" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "sll"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            shamt = parse(Int, parts[4])
            binary_string = "0000000" * int_to_binary_5bits(shamt) * int_to_binary_5bits(rs1) * "001" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "slt"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            rs2 = parse(Int, parts[4][2:end])
            binary_string = "0000000" * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "010" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "sltu"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            rs2 = parse(Int, parts[4][2:end])
            binary_string = "0000000" * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "011" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "xor"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            rs2 = parse(Int, parts[4][2:end])
            binary_string = "0000000" * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "100" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "srl"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            shamt = parse(Int, parts[4])
            binary_string = "0000000" * int_to_binary_5bits(shamt) * int_to_binary_5bits(rs1) * "101" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "sra"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            shamt = parse(Int, parts[4])
            binary_string = "0100000" * int_to_binary_5bits(shamt) * int_to_binary_5bits(rs1) * "101" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "or"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            rs2 = parse(Int, parts[4][2:end])
            binary_string = "0000000" * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "110" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "and"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            rs2 = parse(Int, parts[4][2:end])
            binary_string = "0000000" * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "111" * int_to_binary_5bits(rd) * R_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "li"
            rd = parse(Int, parts[2][2:end])
            imm = parse(Int, parts[3])
            binary_string = int_to_binary_12bits(imm) * "00000" * "000" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "addi"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "000" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "slti"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "010" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "sltiu"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "011" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "xori"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "100" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "ori"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "110" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "andi"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "111" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "slli"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            shamt = parse(Int, parts[4])
            binary_string = "0000000" * int_to_binary_5bits(shamt) * int_to_binary_5bits(rs1) * "001" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "srli"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            shamt = parse(Int, parts[4])
            binary_string = "0000000" * int_to_binary_5bits(shamt) * int_to_binary_5bits(rs1) * "101" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "srai"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            shamt = parse(Int, parts[4])
            binary_string = "0100000" * int_to_binary_5bits(shamt) * int_to_binary_5bits(rs1) * "101" * int_to_binary_5bits(rd) * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "lb"
            rd = parse(Int, parts[2][2:end])
            imm = parse(Int, parts[3])
            rs1 = parse(Int, parts[4][2:end])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "000" * int_to_binary_5bits(rd) * Load_instrucion
            store_word(binary_string, memory, memory_address, 1)
            
        elseif opcode == "lh"
            rd = parse(Int, parts[2][2:end])
            imm = parse(Int, parts[3])
            rs1 = parse(Int, parts[4][2:end])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "001" * int_to_binary_5bits(rd) * Load_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "lw"
            rd = parse(Int, parts[2][2:end])
            imm = parse(Int, parts[3])
            rs1 = parse(Int, parts[4][2:end])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "010" * int_to_binary_5bits(rd) * Load_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "lbu"
            rd = parse(Int, parts[2][2:end])
            imm = parse(Int, parts[3])
            rs1 = parse(Int, parts[4][2:end])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "100" * int_to_binary_5bits(rd) * Load_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "lhu"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "101" * int_to_binary_5bits(rd) * Load_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "sb"
            rs2 = parse(Int, parts[2][2:end])
            imm = parse(Int, parts[3])
            rs1 = parse(Int, parts[4][2:end])
            bin_temp = int_to_binary_12bits(imm)
            binary_string = bin_temp[1:7] * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "000" * bin_temp[8:12] * S_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "sh"
            rs2 = parse(Int, parts[2][2:end])
            imm = parse(Int, parts[3])
            rs1 = parse(Int, parts[4][2:end])
            bin_temp = int_to_binary_12bits(imm)
            binary_string = bin_temp[1:7] * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "001" * bin_temp[8:12] * S_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "sw"
            rs2 = parse(Int, parts[2][2:end])
            imm = parse(Int, parts[3])
            rs1 = parse(Int, parts[4][2:end])
            bin_temp = int_to_binary_12bits(imm)
            binary_string = bin_temp[1:7] * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "010" * bin_temp[8:12] * S_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "beq"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parts[4]
            temp = findfirst(x -> x == imm, core.program)
            temp2=handle_non_opcodes(core, temp-1)
            final_temp=temp-temp2
            offset = (final_temp - core.pc) * 4
            offset = offset >> 1
            bin_temp = int_to_binary_12bits(offset)
            binary_string = string(bin_temp[1]) * bin_temp[3:8] * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "000" * bin_temp[9:12] * string(bin_temp[2]) * SB_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

            
        elseif opcode == "bne"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parts[4]
            temp = findfirst(x -> x == imm, core.program)
            temp2=handle_non_opcodes(core, temp-1)
            final_temp=temp-temp2
            offset = (final_temp - core.pc) * 4
            offset = offset >> 1
            bin_temp = int_to_binary_12bits(offset)
            binary_string = string(bin_temp[1]) * bin_temp[3:8] * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "001" * bin_temp[9:12] * string(bin_temp[2]) * SB_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "blt"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parts[4]
            temp = findfirst(x -> x == imm, core.program)
            temp2=handle_non_opcodes(core, temp-1)
            final_temp=temp-temp2
            offset = (final_temp - core.pc) * 4
            offset = offset >> 1
            bin_temp = int_to_binary_12bits(offset)
            binary_string = string(bin_temp[1]) * bin_temp[3:8] * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "100" * bin_temp[9:12] * string(bin_temp[2]) * SB_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "bge"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parts[4]
            temp = findfirst(x -> x == imm, core.program)
            temp2=handle_non_opcodes(core, temp-1)
            final_temp=temp-temp2
            offset = (final_temp - core.pc) * 4
            offset = offset >> 1
            bin_temp = int_to_binary_12bits(offset)
            binary_string = string(bin_temp[1]) * bin_temp[3:8] * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "101" * bin_temp[9:12] * string(bin_temp[2]) * SB_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "bltu"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parts[4]
            temp = findfirst(x -> x == imm, core.program)
            temp2=handle_non_opcodes(core, temp-1)
            final_temp=temp-temp2
            offset = (final_temp - core.pc) * 4
            offset = offset >> 1
            bin_temp = int_to_binary_12bits(offset)
            binary_string = string(bin_temp[1]) * bin_temp[3:8] * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "110" * bin_temp[9:12] * string(bin_temp[2]) * SB_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "bgeu"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parts[4]
            temp = findfirst(x -> x == imm, core.program)
            temp2=handle_non_opcodes(core, temp-1)
            final_temp=temp-temp2
            offset = (final_temp - core.pc) * 4
            offset = offset >> 1
            bin_temp = int_to_binary_12bits(offset)
            binary_string = string(bin_temp[1]) * bin_temp[3:8] * int_to_binary_5bits(rs2) * int_to_binary_5bits(rs1) * "111" * bin_temp[9:12] * string(bin_temp[2]) * SB_type_instrucion
            store_word(binary_string, memory, memory_address, 1)


        elseif opcode == "jal"
            rd = parse(Int, parts[2][2:end])
            imm = parts[3]
            temp = findfirst(x -> x == imm, core.program)
            temp2=handle_non_opcodes(core, temp-1)
            final_temp=temp-temp2
            offset = (final_temp - core.pc) * 4
            offset = offset >> 1
            bin_temp =int_to_binary_20bits(offset)
            binary_string = string(bin_temp[1]) * bin_temp[11:20] * string(bin_temp[10]) * bin_temp[2:9] * int_to_binary_5bits(rd) * J_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode == "j"
            imm = parts[2]
            temp = findfirst(x -> x == imm, core.program)
            temp2=handle_non_opcodes(core, temp-1)
            final_temp=temp-temp2
            offset = (final_temp - core.pc) * 4
            offset = offset >> 1
            bin_temp = int_to_binary_20bits(offset)
            binary_string = string(bin_temp[1]) * bin_temp[11:20] * string(bin_temp[10]) * bin_temp[2:9] * "00000" * J_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode== "jalr"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "000" * int_to_binary_5bits(rd) * JALR_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode== "jr"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            binary_string = int_to_binary_12bits(imm) * int_to_binary_5bits(rs1) * "000" * "00000" * JALR_type_instrucion
            store_word(binary_string, memory, memory_address, 1)

        elseif opcode== "ecall"
            binary_string = "000000000000" * "00000" * "000" * "00000" * I_type_instrucion
            store_word(binary_string, memory, memory_address, 1)
        else 
            # println("$opcode")
            memory_address -= 1
        end
        memory_address += 1
        
        core.pc += 1
    end
    initial_address = core.pc
    
    return initial_address
end
