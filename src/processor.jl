include("execute_instructions.jl")
include("core.jl")
include("utility.jl")
include("decoding.jl")
include("cache.jl")


function core_Init(id::Int)
    return Core1(id)
end

mutable struct Processor
    memory::Array{Int,2}
    clock::Int
    cores::Array{Core1,1}
    cache::Cache
    main_memory_latency::Int64
    cache_latency::Int64
    hits::Int64
    misses::Int64
    access::Int64
    function Processor()
        this = new()
        this.memory = zeros(Int, 1024, 4)
        this.clock = 0
        this.cores = [core_Init(1), core_Init(2)]
        this.cache = Cache()
        this.main_memory_latency = 100
        this.cache_latency = 1
        this.hits = 0
        this.misses = 0
        this.access = 0
        return this
    end
    # function Processor()
    #     this = new()
    #     this.memory = zeros(UInt8, 1024, 4)
    #     this.clock = 0
    #     this.cores = [core_Init(1), core_Init(2)]
    #     return this
    # end
end

function processor_Init()
    return Processor()
end

# function run(processor::Processor, variable_address::Dict{String, Int}, variable_address2::Dict{String, Int})
#     while processor.clock < 1000
#         for i in 1:2
#             if processor.clock < 1000 && processor.cores[i].pc <= length(processor.cores[i].program)
#                 execute(processor.cores[i], processor.memory, variable_address, variable_address2)
#                 if processor.cores[i].pc > length(processor.cores[i].program)
#                     println("Core $i has finished executing.")
#                     break
#                 end
#             end
#         end
#         processor.clock += 1
#     end
# end

function run(processor::Processor, variable_address::Dict{String, Int},index::Int) 
    while processor.cores[index].pc <= length(processor.cores[index].program)
        execute(processor.cores[index], processor.memory, variable_address)
    end 
end

function show_memory_range(processor::Processor, start_row::Int, end_row::Int)
    println("Hex Table Processor Memory:")
    for rows in reverse(start_row:end_row)
        print("$rows: \t")
        for cols in 1:size(processor.memory, 2)
            print("0x$(int_to_hex(processor.memory[rows, cols]))\t")
        end
        println()
        if rows == (start_row + end_row) ÷ 2 + 1
            println()
            println("------------------------------------------")
            println()
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


function address_present_in_cache(cache::Cache, address::Int64)
    address = int_to_binary_32bits(address)
    cache.offset_bits = address[end-cache.offset_bits_length+1:end]
    cache.index_bits = address[end-cache.offset_bits_length-cache.index_bits_length+1:end-cache.offset_bits_length]
    cache.tag_bits = address[1:end-cache.offset_bits_length-cache.index_bits_length]
    set_number = binary_to_int(cache.index_bits)
    # tag = binary_to_int(cache.tag_bits)
    index = findfirst([block.block[1] == cache.tag_bits for block in cache.memory[set_number+1].cache_set])
    if index !== nothing
        old_recent_access = cache.memory[set_number+1].cache_set[index].recent_access
        cache.memory[set_number+1].cache_set[index].recent_access = 0
        for i in 1:cache.associativity
            if cache.memory[set_number+1].cache_set[i].recent_access < old_recent_access && cache.memory[set_number+1].cache_set[i].isValid
                cache.memory[set_number+1].cache_set[i].recent_access += 1
            end
        end
        cache.memory[set_number+1].cache_set[index].frequency += 0
        # println("Block present addresss = ",cache.tag_bits," ",cache.index_bits," ",cache.offset_bits)
        return cache.memory[set_number+1].cache_set[index].block[binary_to_int(cache.offset_bits)+2]
    else
        # println("Block not present addresss = ",cache.tag_bits," ",cache.index_bits," ",cache.offset_bits)
        return nothing
    end
end


function retrieve_block_from_MM(cache::Cache, memory::Array{Int,2}, address::Int64)
    block = CacheBlock_Init(cache.number_of_blocks)
    address = int_to_binary_32bits(address)
    zeros = repeat("0", cache.offset_bits_length)
    block_lower_bound = binary_to_int(address[1:end-cache.offset_bits_length]*zeros)
    block_upper_bound = block_lower_bound + cache.number_of_blocks - 1
    # println("address = ",address," block_lower_bound = ",block_lower_bound," block_upper_bound = ",block_upper_bound)
    block.block[1] = cache.tag_bits
    for byte_address in block_lower_bound:block_upper_bound
        # block.block[byte_address-block_lower_bound+2] = int_to_hex(memory[byte_address ÷ 4 + 1, byte_address % 4 + 1])
        # int_to_hex(memory[byte_address ÷ 4 + 1, byte_address % 4 + 1])
        block.block[(byte_address%cache.number_of_blocks)+2] = int_to_binary_8bits(get_byte_from_memory(memory, byte_address+1))
    end
    return block
end


function set_block_in_cache(cache::Cache, address::Int64, memory::Array{Int,2})
    block = retrieve_block_from_MM(cache, memory, address)
    set_number = binary_to_int(cache.index_bits)
    LRU_cache_replacement_policy(cache, block, set_number)
    # LFU_cache_replacement_policy(cache, block, set_number)
    return block.block
end


function LRU_cache_replacement_policy(cache::Cache, block::CacheBlock, set_number::Int64)
    # println("*******************LRU Cache Replacement Policy*******************")
    # println("New Block = ",block)
    new_block = deepcopy(block)
    block_set = cache.memory[set_number+1].cache_set
    index = nothing
    for (block_index, block) in enumerate(block_set)
        if !block.isValid
            index = block_index
            new_block.isValid = true
            cache.memory[set_number+1].cache_set[index] = deepcopy(new_block)
            break
        end
    end

    if index === nothing
        recent_access_value = [block.recent_access for block in block_set]
        max_recent_access_value = argmax(recent_access_value)
        new_block.isValid = true
        cache.memory[set_number+1].cache_set[max_recent_access_value] = deepcopy(new_block)
    end

    for block in block_set
        if block.isValid
            block.recent_access += 1
            # println("^^^^^^^^^^^^^^^^^^^^^^^")
            # println(block.block[1])
        end 
    end

    # println("\nset number = ",set_number)
    # for i in 1:cache.associativity
    #     println("Block = ",cache.memory[set_number+1].cache_set[i])
    # end
    # address = int_to_binary_32bits(address)
    # cache.offset_bits = address[end-cache.offset_bits_length+1:end]
    # cache.index_bits = address[end-cache.offset_bits_length-cache.index_bits_length+1:end-cache.offset_bits_length]
    # cache.tag_bits = address[1:end-cache.offset_bits_length-cache.index_bits_length]
    # set_number = binary_to_int(cache.index_bits)
    # tag = binary_to_int(cache.tag_bits)
    # index = findfirst([block.block[1] == "" for block in cache.memory[set_number+1].cache_set])
    # if index !== nothing
    #     cache.memory[set_number+1].cache_set[index].block = set_block_in_cache(cache, address, memory).block
    #     cache.memory[set_number+1].cache_set[index].tag = cache.tag_bits
    #     cache.memory[set_number+1].cache_set[index].isValid = true
    #     cache.memory[set_number+1].cache_set[index].isDirty = false
    #     cache.memory[set_number+1].cache_set[index].recent_access = 0
    #     for i in 1:cache.associativity
    #         if i != index && cache.memory[set_number+1].cache_set[i].isValid
    #             cache.memory[set_number+1].cache_set[i].recent_access += 1
    #         end
    #     end
    # else
    #     index = findfirst([block.recent_access == cache.associativity-1 for block in cache.memory[set_number+1].cache_set])
    #     if index !== nothing
    #         if cache.memory[set_number+1].cache_set[index].isDirty
    #             # write_back_to_MM(cache.memory[set_number+1].cache_set[index].block, cache.memory[set_number+1].cache_set[index].tag, cache.index_bits, cache.offset_bits, memory)
    #         end
    #         cache.memory[set_number+1].cache_set[index].block = set_block_in_cache(cache, address, memory).block
    #         cache.memory[set_number+1].cache_set[index].tag = cache.tag_bits
    #         cache.memory[set_number+1].cache_set[index].isValid = true
    #         cache.memory[set_number+1].cache_set[index].isDirty = false
    #         cache.memory[set_number+1].cache_set[index].recent_access = 0
    #         for i in 1:cache.associativity
    #             if i != index && cache.memory[set_number+1].cache_set[i].isValid
    #                 cache.memory[set_number+1].cache_set[i].recent_access += 1
    #             end
    #         end
    #     end    
    # end
    # println("*******************Cache Replacement Policy*******************")
end

function LFU_cache_replacement_policy(cache::Cache, block::CacheBlock, set_number::Int64)
    # println("*******************LFU Cache Replacement Policy*******************")

    # println("New Block = ",block)
    new_block = deepcopy(block)
    block_set = cache.memory[set_number+1].cache_set
    index = nothing
    for (block_index, block) in enumerate(block_set) 
        if !block.isValid
            index = block_index
            new_block.isValid = true
            new_block.isAccessed = true
            cache.memory[set_number+1].cache_set[index] = deepcopy(new_block)
            break
        end
    end

    if index === nothing
        frequency_value = [block.frequency for block in block_set]
        min_frequency_value = argmin(frequency_value)
        new_block.isValid = true
        new_block.isAccessed = true
        cache.memory[set_number+1].cache_set[min_frequency_value] = deepcopy(new_block)
    end

    for block in block_set
        if block.isValid && block.isAccessed
            block.frequency += 1
            block.isAccessed = false
        end
    end

    # println("\nset number = ",set_number)
    # for i in 1:cache.associativity
    #     println("Block = ",cache.memory[set_number+1].cache_set[i])
    # end

    # if set_number == 0
    #     set_number = 1
    #     for i in 1:cache.associativity 
    #         println("Block = ",cache.memory[set_number+1].cache_set[i])
    #     end
    # end


    # println("*******************Cache Replacement Policy*******************")
end