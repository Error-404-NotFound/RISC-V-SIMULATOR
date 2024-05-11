# Description: A simple 2-core processor simulator

include("processor.jl")
include("parser.jl")
include("utility.jl")
include("encoding.jl")
include("data_memory.jl")
# include("DF.jl")
include("stages_without_data_forwarding.jl")
include("stages_with_data_forwarding.jl")

file_path1 = "./test1.asm"
file_path2 = "./test2.asm"


function main()
    sim = processor_Init()
    initial_address_first = 1
    data_initial_address = size(sim.memory, 1) ÷ 2 + 1
    text_program_first, data_program_first = parse_assembly_code(file_path1)
    variable_name_first, data_seg_chunk_first = parse_data_section(join(data_program_first, "\n"))
    sim.cores[1].program = text_program_first 
    variable_address_first, data_initial_address_first=store_data_in_memory(sim.cores[1], sim.memory, data_seg_chunk_first, variable_name_first, data_initial_address)
    initial_address_first=encode_text_and_store_in_memory(sim.cores[1], sim.memory, initial_address_first,variable_address_first)
    if initial_address_first < (size(sim.memory, 1) ÷ 4)
        initial_address_first = size(sim.memory, 1) ÷ 4 + 1
    end


    if data_initial_address_first > 3 * (size(sim.memory, 1) ÷ 4)
        println("Data segment for 1 is too large")
    end
    initial_address_second = (size(sim.memory, 1) ÷ 4) + 1
    data_initial_address_second = 3 * (size(sim.memory, 1) ÷ 4) + 1
    text_program_second, data_program_second = parse_assembly_code(file_path2)
    variable_name_second, data_seg_chunk_second = parse_data_section(join(data_program_second, "\n"))
    sim.cores[2].program = text_program_second
    variable_address_second, data_initial_address_second=store_data_in_memory(sim.cores[2], sim.memory, data_seg_chunk_second, variable_name_second, data_initial_address_second)
    initial_address_second=encode_text_and_store_in_memory(sim.cores[2], sim.memory, initial_address_second,variable_address_second)
    if data_initial_address_second > size(sim.memory, 1)
        println("Data segment for 2 is too large")
    end

    # show_memory(sim)
    sim.cores[1].pc=1
    sim.cores[2].pc=1

    # println()
    # println("To see the memory sections of the cores, run the execution and scroll down. \nThe whole memory is 1024 x 4 bytes ie 4kB. \nSince the whole memory is very big, only parts of memory is shown here.\n")
    # println(".text segment of core 1 is from 1 to 256, \n.text segment of core 2 is from 257 to 512, \n.data segment of core 1 is from 513 to 768, \n.data segment of core 2 is from 769 to 1024.\n")
    # println("To see complete memory, go to main.jl and change the range of show_memory_range function. \nFor example, to see the whole memory, change the range to show_memory_range(sim, 1, 1024).")
    # println()

    println("Enter the choice for the execution of core: ")
    println("1. For UNPIPELINED execution")
    println("2. For PIPELINED execution without data forwarding")
    println("3. For PIPELINED execution with data forwarding")
    user_input = readline()
    # user_number = parse(Int, user_input)

    if user_input == "1"
        sim.cores[1].pc=1
        sim.cores[2].pc=1
        println()
        println("Output of the program-1: ")
        run(sim,variable_address_first, 1)
        println()
        println("Output of the program-2: ")
        run(sim,variable_address_second, 2)
        println()
        
    elseif user_input == "2"
        cache_switch=0
        println("Enter the choice for the execution of cache: ")
        println("1. For cache enabled")
        println("2. For cache disabled")
        cache_input = readline()
        if cache_input == "1"
            cache_switch=1
        elseif cache_input == "2"
            cache_switch=2
        else
            println("Invalid choice")
        end
        sim.cores[1].pc=1
        sim.cores[2].pc=1
        println("Output of the program-1: ")
        run_piped_wo_df(sim,variable_address_first, 1, 1, cache_switch)
        println()
        println("Total number of clocks: $(sim.clock)")
        println("Total number of instructions executed: $(sim.cores[1].instruction_count)")
        println("Total number of stalls: $(sim.cores[1].stall_count)")
        println("Instructions per clock (IPC): $(sim.cores[1].instruction_count / sim.clock)")
        println("Clock per instruction (CPI): $(sim.clock / sim.cores[1].instruction_count)")
        println("Stalls per instruction (SPI): $(sim.cores[1].stall_count / sim.cores[1].instruction_count)")
        println()
        sim.clock=0
        println("Output of the program-2: ")
        run_piped_wo_df(sim,variable_address_second, 2, 257, cache_switch)
        println()
        println("Total number of clocks: $(sim.clock)")
        println("Total number of instructions executed: $(sim.cores[2].instruction_count)")
        println("Total number of stalls: $(sim.cores[2].stall_count)")
        println("Instructions per clock (IPC): $(sim.cores[2].instruction_count / sim.clock)")
        println("Clock per instruction (CPI): $(sim.clock / sim.cores[2].instruction_count)")
        println("Stalls per instruction (SPI): $(sim.cores[2].stall_count / sim.cores[2].instruction_count)")
        println()
        
    elseif user_input == "3"
        sim.cores[1].pc=1
        sim.cores[2].pc=1

        println("Output of the program-1: ")
        run_piped_w_df(sim,variable_address_first, 1)
        println()
        println("Total number of clocks: $(sim.clock)")
        println("Total number of instructions executed: $(sim.cores[1].instruction_count)")
        println("Total number of stalls: $(sim.cores[1].stall_count)")
        println("Instructions per clock (IPC): $(sim.cores[1].instruction_count / (sim.clock))")
        println("Clock per instruction (CPI): $(sim.clock / sim.cores[1].instruction_count)")
        println("Stalls per instruction (SPI): $(sim.cores[1].stall_count / sim.cores[1].instruction_count)")
        println()
        sim.clock=0
        println("Output of the program-2: ")
        run_piped_w_df(sim,variable_address_second, 2)
        println()
        println("Total number of clocks: $(sim.clock)")
        println("Total number of instructions executed: $(sim.cores[2].instruction_count)")
        println("Total number of stalls: $(sim.cores[2].stall_count)")
        println("Instructions per clock (IPC): $(sim.cores[2].instruction_count / sim.clock)")
        println("Clock per instruction (CPI): $(sim.clock / sim.cores[2].instruction_count)")
        println("Stalls per instruction (SPI): $(sim.cores[2].stall_count / sim.cores[2].instruction_count)")
        println()

    else
        println("Invalid choice")

    end

    # println("Sections of Memory:")
    # println()
    # println(".text segment for core 1:(1-150)")
    # show_memory_range(sim, 1, 150)
    # println()
    # println(".text segment for core 2:(257-407)")
    # show_memory_range(sim, 257, 457)
    # println()
    # println(".data segment for core 1:(513-662)")
    # show_memory_range(sim, 513, 662)
    # println()
    # println(".data segment for core 2:(769-918)")
    # show_memory_range(sim, 769, 918)
    # println()

    println("Cache Information:")
    println("Cache access count: $(sim.access)")
    println("Hits: $(sim.hits + sim.hits_2)")
    println("Hit Rate: $(sim.hits / sim.access)")
    println("Misses: $(sim.misses + sim.misses_2)")
    println("Miss Rate: $(sim.misses / sim.access)")
    println()

    # println()
    # println("Cache Memory:")
    # for i in sim.cache.number_of_sets
    #     for j in sim.cache.associativity
    #         println("Set $i Block $j: $(sim.cache.memory[i].cache_set[j].block)")
    #     end
    #     # println("Set $i: $(sim.cache.memory[i].cache_set)") 
    # end

    println("Registers:")
    for i in 1:length(sim.cores)
        println("Core $i Registers: $(sim.cores[i].registers)")
    end
    println()
end

main()
