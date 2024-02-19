# This file contains the execute function for each instruction
# The execute function takes a core and memory as input and modifies the core
# The core is modified by the execute function to simulate the instruction execution
# The run function is the main function that simulates the processor
# The run function calls the execute function to simulate the instruction execution
# The main function is the entry point of the program
# The main function creates a processor and runs the simulation

include("core.jl")
using .Core_Module


function execute(core::Core_Module.Core1, memory::Array{Int,2})
    parts = split(core.program[core.pc], " ")
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
        shift_bits = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] << shift_bits
    
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
        shift_bits = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] >>> shift_bits

    elseif opcode == "sra"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        shift_bits = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] >> shift_bits

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
        shift_bits = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] << shift_bits

    elseif opcode == "srli"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        shift_bits = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] >>> shift_bits

    elseif opcode == "srai"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        shift_bits = parse(Int, parts[4])
        core.registers[rd] = core.registers[rs1] >> shift_bits

    elseif opcode == "lb"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = memory[core.registers[rs1] + imm, 1]

    elseif opcode == "lh"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = memory[core.registers[rs1] + imm, 1]

    elseif opcode == "lw"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = memory[core.registers[rs1] + imm, 1]

    elseif opcode == "lbu"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = memory[core.registers[rs1] + imm, 1]

    elseif opcode == "lhu"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = memory[core.registers[rs1] + imm, 1]


    elseif opcode == "sb"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        memory[core.registers[rs1] + imm, 1] = core.registers[rs2]

    elseif opcode == "sh"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        memory[core.registers[rs1] + imm, 1] = core.registers[rs2]

    elseif opcode == "sw"
        rs1 = parse(Int, parts[2][2:end]) + 1
        rs2 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        memory[core.registers[rs1] + imm, 1] = core.registers[rs2]
    

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
        rs1 = parse(Int, parts[2][2:end])
        core.pc = core.registers[rs1]

    elseif opcode == "jalr"
        rd = parse(Int, parts[2][2:end]) + 1
        rs1 = parse(Int, parts[3][2:end]) + 1
        imm = parse(Int, parts[4])
        core.registers[rd] = core.pc + 1
        core.pc = core.registers[rs1] + imm

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

    end
    core.pc += 1
end