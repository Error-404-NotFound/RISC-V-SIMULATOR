mutable struct Core1
    registers::Array{Int, 1}
    pc::Int
    program::Array{String, 1}
end

function core_Init()
    registers = fill(0,32)
    pc = 1
    program = []
    return Core1(registers, pc, program)
end

function execute(core::Core1, memory)
    parts = split(core.program[core.pc], " ")
    opcode = parts[1]
    println(opcode)
    if opcode == "add"
        rd = parse(Int, parts[2][2:end])+1
        rs1 = parse(Int, parts[3][2:end])+1
        rs2 = parse(Int, parts[4][2:end])+1
        core.registers[rd] = core.registers[rs1] + core.registers[rs2]
    elseif opcode == "ld"
        # rd = parse(Int, parts[2][2:end])+1
        # location = parse(Int, parts[3])+1
        # core.registers[rd] = memory[location]
    end
    core.pc += 1
end

mutable struct Processor
    memory::Array{Int, 1}
    clock::Int
    cores::Array{Core1, 1}
end

function processor_Init()
    memory = fill(0,4096)
    clock = 0
    cores = [core_Init(), core_Init()]
    return Processor(memory, clock, cores)
end

function run(processor::Processor)
    while processor.clock < maximum([length(core.program) for core in processor.cores])
        for i in 1:2
            if processor.clock < length(processor.cores[i].program)
                execute(processor.cores[i], processor.memory)
            end
        end
        processor.clock += 1
    end    
end

sim = processor_Init()
# sim.cores = [Core1([0 for _ in 1:32], 0, []), Core1([0 for _ in 1:32], 0, [])]
sim.cores[1].registers[2] = 8
sim.memory[6] = 18
for i in 1:length(sim.cores)
    println(sim.cores[i].registers)
end
sim.cores[1].program = ["add x1 x2 x3"]
sim.cores[2].program = ["add x1 x2 x3"]
run(sim)
for i in 1:length(sim.cores)
    println(sim.cores[i].registers)
end

