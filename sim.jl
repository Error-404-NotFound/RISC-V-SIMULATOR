# Description: A simple 2-core processor simulator

include("execute_functions.jl")
include("core.jl")


function core_Init()
    return Core1()
end

mutable struct Processor
    memory::Array{Int,2}
    clock::Int
    cores::Array{Core1,1}
    function Processor()
        this = new()
        this.memory = zeros(Int, 1024, 4)
        this.clock = 0
        this.cores = [core_Init(), core_Init()]
        return this
    end
end

function processor_Init()
    return Processor()
end

# function extract_labels(program::Vector{String})
#     labels = Dict{String, Int}()
#     address=0
#     for line in program
#         if occursin(":", line)
#             parts = split(line, ":")
#             label = strip(parts[1])
#             labels[label] = address
#         end
#         address += 1
#     end
#     return labels
# end

function run(processor::Processor)
    # labels = extract_labels(processor.cores[1].program)
    while processor.clock < maximum([length(core.program) for core in processor.cores])
        for i in 1:2
            if processor.clock < length(processor.cores[i].program)
                execute(processor.cores[i], processor.memory)
            end
        end
        processor.clock += 1
    end
end

function show_memory(processor::Processor)
    for i in 1:size(processor.memory, 1)
        println(processor.memory[i, :])
    end
end

function main()
    sim = Processor()
    sim.cores[1].registers[2+1] = 8
    sim.cores[1].registers[3+1] = 10
    sim.cores[1].registers[5+1] = 5
    sim.memory[1,2]=5
    # for i in 1:length(sim.cores)
    #     println(sim.cores[i].registers)
    # end

    sim.cores[1].program = ["add x1 x2 x3", 
                            "mv x5 x1",
                            "addi x1 x1 5",
                            "li x2 23",
                            "beq x1 x2 hello",
                            "li x3 100",
                            "hello",
                            "li x4 200",
                            # "st x1 5",
                            # "addi x2 x2 20",
                            # "beq x1 x2 loop",
                            ]
    # sim.cores[2].program = ["add x1 x2 x3", "ld x5 5"]
    run(sim)
    # println(sim.memory[5+1])
    for i in 1:length(sim.cores)
        println(sim.cores[i].registers)
    end
end

main()

