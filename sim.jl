mutable struct Core1
    registers::Vector{Int64}
    pc::Int64
    program::Vector{String}
end

function execute(core::Core1, memory::Vector{Int64})
    parts = split(core.program[core.pc])
    opcode = parts[1]
    println(opcode)
    if opcode == "add"
        rd = parse(Int64, parts[2][2:end])
        rs1 = parse(Int64, parts[3][2:end])
        rs2 = parse(Int64, parts[4][2:end])
        core.registers[rd] = core.registers[rs1] + core.registers[rs2]
    elseif opcode == "ld"
        rd = parse(Int64, parts[2][2:end])
        location = parse(Int64, parts[3])
        core.registers[rd] = memory[location]
    end
    core.pc += 1
end

mutable struct Processor
    memory::Vector{Int64}
    clock::Int64
    cores::Vector{Core1}
end

function run(processor::Processor)
    while processor.clock < maximum([length(core.program) for core in processor.cores])
        for i in 1:length(processor.cores)
            if processor.clock < length(processor.cores[i].program)
                execute(processor.cores[i], processor.memory)
            end
        end
        processor.clock += 1
    end
end

sim = Processor()
sim.cores = [Core1([0 for _ in 1:32], 0, []), Core1([0 for _ in 1:32], 0, [])]
sim.cores[1].registers[2] = 8
sim.memory[6] = 18
for i in 1:length(sim.cores)
    println(sim.cores[i].registers)
end
sim.cores[1].program = ["add x1 x2 x3", "ld x5 6"]
sim.cores[2].program = ["add x1 x2 x3", "ld x5 6"]
run(sim)
for i in 1:length(sim.cores)
    println(sim.cores[i].registers)
end
