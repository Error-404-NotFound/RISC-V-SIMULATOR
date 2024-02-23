include("core.jl")
include("utility.jl")

function store_data_in_memory(core::Core1, memory::Array{Int64,2}, data_seg_chunk::Vector{Any}, variable_name::Vector{Any}, data_initial_address::Int64)
    #dictionary to store the address of the variables
    variable_address = Dict{String, Int64}()
    temp_col = 1
    temp_row = data_initial_address
    for i in 1:length(data_seg_chunk)
        if data_seg_chunk[i] == ".string"
            variable_value = data_seg_chunk[i-1]
            temp_address = (temp_row-1) * 4 + temp_col
            #store in dictionary
            push!(variable_address, variable_value => temp_address)

            current_string = data_seg_chunk[i+1]
            # println(current_string)
            for j in eachindex(current_string)
                store_one_byte(int_to_binary_32bits(Int(current_string[j])), memory, temp_row, temp_col)
                temp_col += 1
                if temp_col > 4
                    temp_col = 1
                    temp_row += 1
                end
                # println(current_string[j])
                # println(Int(current_string[j]))
            end
            # terminate the string with a null character
            store_one_byte(int_to_binary_32bits(0), memory, temp_row, temp_col)
            temp_col += 1
            if temp_col > 4
                temp_col = 1
                temp_row += 1
            end
        end

        if data_seg_chunk[i] == ".word"
            #store in dictionary
            push!(variable_address, data_seg_chunk[i-1] => (temp_row-1) * 4 + temp_col)
            i += 1
            # store the word in memory untill the end of the word
            while i <= length(data_seg_chunk)
                #terminate if the next element is not a number without using regex
                if occursin(r"\D", data_seg_chunk[i])
                    break
                end
                
                store_word(int_to_binary_32bits(parse(Int, data_seg_chunk[i])), memory, temp_row, temp_col)
                temp_col += 4
                if temp_col > 4
                    temp_col %= 4
                    temp_row += 1
                end
                i += 1
            end
        end
    end
    data_initial_address = temp_row
    return variable_address, data_initial_address
end