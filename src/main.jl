# Description: A simple 2-core processor simulator

include("processor.jl")
include("parser.jl")
include("utility.jl")
include("encoding.jl")
include("data_memory.jl")

file_path1 = "./test1.asm"
file_path2 = "./test2.asm"


function main()
    sim = processor_Init()

    initial_address_first = 1
    data_initial_address = size(sim.memory, 1) ÷ 2 + 1
    text_program_first, data_program_first = parse_assembly_code(file_path1)
    variable_name_first, data_seg_chunk_first = parse_data_section(join(data_program_first, "\n"))
    sim.cores[1].program = text_program_first 
    # initial_address_first=encode_text_and_store_in_memory(sim.cores[1], sim.memory, initial_address_first)
    variable_address_first, data_initial_address_first=store_data_in_memory(sim.cores[1], sim.memory, data_seg_chunk_first, variable_name_first, data_initial_address)
    # if initial_address < (size(sim.memory, 1) ÷ 4)
    #     initial_address = size(sim.memory, 1) ÷ 4 + 1
    # end


    if data_initial_address_first > 3 * (size(sim.memory, 1) ÷ 4)
        println("Data segment for 1 is too large")
    end
    initial_address_second = (size(sim.memory, 1) ÷ 4) + 1
    data_initial_address_second = 3 * (size(sim.memory, 1) ÷ 4) + 1
    text_program_second, data_program_second = parse_assembly_code(file_path2)
    variable_name_second, data_seg_chunk_second = parse_data_section(join(data_program_second, "\n"))
    sim.cores[2].program = text_program_second
    # initial_address_second=encode_text_and_store_in_memory(sim.cores[2], sim.memory, initial_address_second)
    variable_address_second, data_initial_address_second=store_data_in_memory(sim.cores[2], sim.memory, data_seg_chunk_second, variable_name_second, data_initial_address_second)
    if data_initial_address_second > size(sim.memory, 1)
        println("Data segment for 2 is too large")
    end

    # show_memory(sim)
    sim.cores[1].pc=1
    sim.cores[2].pc=1

    println()

    println("Sections of Memory:")
    println()
    println(".text segment for core 1:(1-150)")
    show_memory_range(sim, 1, 150)
    println()
    println(".text segment for core 2:(257-407)")
    show_memory_range(sim, 257, 457)
    println()
    println(".data segment for core 1:(513-662)")
    show_memory_range(sim, 513, 662)
    println()
    println(".data segment for core 2:(769-918)")
    show_memory_range(sim, 769, 918)
    println()

    println()
    println("Scroll up to see the memory sections of the cores. \nThe whole memory is 1024 x 4 bytes ie 4kB. \nSince the whole memory is very big, only parts of memory is shown here.\n")
    println(".text segment of core 1 is from 1 to 256, \n.text segment of core 2 is from 257 to 512, \n.data segment of core 1 is from 513 to 768, \n.data segment of core 2 is from 769 to 1024.\n")
    println("To see complete memory, go to main.jl and change the range of show_memory_range function. \nFor example, to see the whole memory, change the range to show_memory_range(sim, 1, 1024).")
    println()

    println("Output of the program-1: ")
    run(sim,variable_address_first, 1)
    println()
    println("Output of the program-2: ")
    run(sim,variable_address_second, 2)
    println()

    println("Registers:")
    for i in 1:length(sim.cores)
        println("Core $i Registers: $(sim.cores[i].registers)")
    end
    println()
end

main()