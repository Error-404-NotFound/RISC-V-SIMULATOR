include("processor.jl")
include("parser.jl")
include("memory.jl")
include("utility.jl")
include("encoding.jl")

file_path1 = "./test1.asm"
file_path2 = "./test2.asm"

initial_address = 1

function main()
    sim = processor_Init()
    text_program_first, data_program_first = parse_assembly_code(file_path1)
    variable_name, data_seg_chunck = parse_data_section(join(data_program_first, "\n"))
    sim.cores[1].program = text_program_first
    encode_text_and_store_in_memory(sim.cores[1], sim.memory, initial_address)

    show_memory(sim)
    # sim.cores[1].pc=1
    run(sim)
    for i in 1:length(sim.cores)
        println(sim.cores[i].registers)
    end
    # print(sim.memory[2,2])
    # println(sim.memory[1,2])
    # show_memory(sim)
end

main()