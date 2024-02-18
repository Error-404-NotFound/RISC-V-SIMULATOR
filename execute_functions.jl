# This file contains the execute function for each instruction
# The execute function takes a core and memory as input and modifies the core
# The core is modified by the execute function to simulate the instruction execution
# The run function is the main function that simulates the processor
# The run function calls the execute function to simulate the instruction execution
# The main function is the entry point of the program
# The main function creates a processor and runs the simulation

module ExecuteFunctions

export execute
    function execute(instruction::String, registers::Array{Int,1}, memory::Array{Int,1})
        parts = split(instruction, " ")
        opcode = parts[1]
        if opcode == "add"
            rd = parse(Int, parts[2][2:end]) + 1
            rs1 = parse(Int, parts[3][2:end]) + 1
            rs2 = parse(Int, parts[4][2:end]) + 1
            registers[rd] = registers[rs1] + registers[rs2]
        elseif opcode == "sub"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            rs2 = parse(Int, parts[4][2:end])
            registers[rd] = registers[rs1] - registers[rs2]
        elseif opcode == "addi"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            registers[rd] = registers[rs1] + imm
        elseif opcode == "mv"
            rd = parse(Int, parts[2][2:end])
            rs1 = parse(Int, parts[3][2:end])
            registers[rd] = registers[rs1]
        elseif opcode == "ld"
            rd = parse(Int, parts[2][2:end]) + 1
            location = parse(Int, parts[3]) + 1
            registers[rd] = memory[location]
        elseif opcode == "st"
            rs1 = parse(Int, parts[2][2:end]) + 1
            location = parse(Int, parts[3]) + 1
            memory[location] = registers[rs1]
        elseif opcode == "beq"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            if registers[rs1] == registers[rs2]
                registers[32] = registers[32] + imm
            end
        elseif opcode == "bne"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            if registers[rs1] != registers[rs2]
                registers[32] = registers[32] + imm
            end
        elseif opcode == "beqz"
            rs1 = parse(Int, parts[2][2:end])
            imm = parse(Int, parts[3])
            if registers[rs1] == 0
                registers[32] = registers[32] + imm
            end
        elseif opcode == "blt"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            if registers[rs1] < registers[rs2]
                registers[32] = registers[32] + imm
            end
        elseif opcode == "bge"
            rs1 = parse(Int, parts[2][2:end])
            rs2 = parse(Int, parts[3][2:end])
            imm = parse(Int, parts[4])
            if registers[rs1] >= registers[rs2]
                registers[32] = registers[32] + imm
            end
        elseif opcode == "jal"
            rd = parse(Int, parts[2][2:end])
            registers[rd] = registers[32]
            registers[32] = registers[32] + 1
        elseif opcode == "jr"
            rs1 = parse(Int, parts[2][2:end])
            registers[32] = registers[rs1]
        
        end
    end
end