include("execute_instructions.jl")
include("core.jl")
include("utility.jl")
include("decoding.jl")


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

# function run(processor::Processor)
#     while processor.clock < 1000
#         for i in 1:2
#             if processor.clock < 1000 && processor.cores[i].pc <= length(processor.cores[i].program)
#                 execute(processor.cores[i], processor.memory)
#                 if processor.cores[i].pc > length(processor.cores[i].program)
#                     println("Core $i has finished executing.")
#                     break
#                 end
#             end
#         end
#         processor.clock += 1
#     end
# end

function run(processor::Processor, variable_address::Dict{String, Int}) 
    for i in 1:2
        while processor.cores[i].pc <= length(processor.cores[i].program)
            execute(processor.cores[i], processor.memory, variable_address)
        end
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
        if rows == size(processor.memory, 1) ÷ 2 + 1
            println()
        end
    end 
end