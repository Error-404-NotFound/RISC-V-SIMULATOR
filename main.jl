include("processor.jl")
include("parser.jl")
include("memory.jl")
include("utility.jl")

file_path = "./test.asm"

text_program_first, data_program_first = parse_assembly_code(file_path)
labels, chunks = parse_data_section(join(data_program_first, "\n"))
println(labels)
println(chunks)

function main()
    sim = processor_Init()
    sim.cores[1].program = text_program_first
    # run(sim)
    # for i in 1:length(sim.cores)
    #     println(sim.cores[i].registers)
    # end
    # print(sim.memory[2,2])
    # println(sim.memory[1,2])
    # show_memory(sim)
end

main()