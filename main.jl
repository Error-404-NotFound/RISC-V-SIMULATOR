# Description: A simple 2-core processor simulator

include("processor.jl")
include("parser.jl")
include("memory.jl")
include("utility.jl")
include("encoding.jl")
include("data_memory.jl")

file_path1 = "./test1.asm"
file_path2 = "./test2.asm"


function main()
    initial_address = 1
    sim = processor_Init()
    data_initial_address = size(sim.memory, 1) ÷ 2 + 1
    text_program_first, data_program_first = parse_assembly_code(file_path1)
    variable_name, data_seg_chunk = parse_data_section(join(data_program_first, "\n"))
    sim.cores[1].program = text_program_first 
    # initial_address=encode_text_and_store_in_memory(sim.cores[1], sim.memory, initial_address)
    variable_address, data_initial_address=store_data_in_memory(sim.cores[1], sim.memory, data_seg_chunk, variable_name, data_initial_address)
    println(variable_address)

    # if initial_address < (size(sim.memory, 1) ÷ 4)
    #     initial_address = size(sim.memory, 1) ÷ 4 + 1
    # end
    # text_program_second, data_program_second = parse_assembly_code(file_path2)
    # variable_name, data_seg_chunk = parse_data_section(join(data_program_second, "\n"))
    # println(variable_name)
    # println(data_seg_chunk)
    # sim.cores[2].program = text_program_second
    # initial_address=encode_text_and_store_in_memory(sim.cores[2], sim.memory, initial_address)

    # show_memory(sim)
    sim.cores[1].pc=1
    run(sim,variable_address)
    for i in 1:length(sim.cores)
        println(sim.cores[i].registers)
    end
    # print(sim.memory[2,2])
    # println(sim.memory[1,2])
    show_memory(sim)
end

main()