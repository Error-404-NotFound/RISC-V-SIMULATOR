# Description: A simple 2-core processor simulator

include("execute_functions.jl")
include("core.jl")
include("utility.jl")


function core_Init()
    return Core1()
end

mutable struct Processor
    memory::Array{Int,2}
    clock::Int
    cores::Array{Core1,1}
    function Processor()
        this = new()
        this.memory = zeros(UInt8, 64, 4)
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
    while processor.clock < 1000
        for i in 1:2
            if processor.clock < 1000 && processor.cores[i].pc <= length(processor.cores[i].program)
                execute(processor.cores[i], processor.memory)
                if processor.cores[i].pc > length(processor.cores[i].program)
                    println("Core $i has finished executing.")
                    break
                end
            end
        end
        processor.clock += 1
    end
end



function show_memory(processor::Processor)
    println("Hex Table Processor Memory:")
    for rows in reverse(1:size(processor.memory, 1))
        print("$rows: \t")
        for cols in 1:size(processor.memory, 2)
            print("0x$(int_to_hex(processor.memory[rows, cols]))\t")
        end
        println()
    end 
end