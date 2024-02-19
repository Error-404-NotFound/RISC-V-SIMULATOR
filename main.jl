include("sim.jl")
include("parser.jl")

file_path = "/home/aniket/Desktop/Project/RISC-V-SIMULATOR/test.asm"
program = []
try
    file = open(file_path, "r")
    for line in eachline(file)
        if !contains(line, "any")
            modified_line = replace(line, r"\b\d+\b" => x -> string(parse(Int, x)))
            push!(program, modified_line)            
        end
    end
    close(file)
    println(program)
catch err
    println("An error occurred: $err")
end

function main()
    sim = processor_Init()
    sim.cores[1].program = program
    run(sim)
    for i in 1:length(sim.cores)
        println(sim.cores[i].registers)
    end
    # println(sim.memory[1,2])
    show_memory(sim)
end

main()
