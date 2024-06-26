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
            temp_address = (temp_row-1) * 4 + temp_col - 1
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
            push!(variable_address, data_seg_chunk[i-1] => (temp_row-1) * 4 + temp_col - 1)
            i += 1
            # store the word in memory untill the end of the word
            while i <= length(data_seg_chunk) 
                if data_seg_chunk[i][1]>'a' && data_seg_chunk[i][1]<'z' || data_seg_chunk[i][1]>'A' && data_seg_chunk[i][1]<'Z'
                    break
                end
                temp_number = parse(Int, data_seg_chunk[i])
                
                #terminate the loop if the word is not a number
                # if isa(temp_number,Number) == false
                #     break
                # end
                
                #store the word in memory
                #convert the string to an integer and then to a 32-bit binary
                store_word(int_to_binary_bits_modified(temp_number,32), memory, temp_row, temp_col)
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