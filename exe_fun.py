# Description: This file contains the execute function for the RISC-V simulator

def execute(instruction,registers,memory):
    parts = instruction.split()
    opcode = parts[0]
    if opcode == "add":
        rd = int(parts[1][1:])
        rs1 = int(parts[2][1:])
        rs2 = int(parts[3][1:])
        registers[rd] = registers[rs1] + registers[rs2]
    elif opcode == "ld":
        rd = int(parts[1][1:])
        location = int(parts[2])
        registers[rd] = memory[location]