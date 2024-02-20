# Any["array: .word 10 20 30", "str: .string \"Hello\"", ""]

include("utility.jl")


function extract_literals(assembler::Vector{String})
    literals = Dict{String, Vector{Int}}()

    for line in assembler
        parts = split(line, ':')
        if length(parts) == 2
            variable_name = strip(parts[1])
            data_values = strip(parts[2])

            if occursin(".word", variable_name)
                values = parse.(Int, split(data_values))
                literals[variable_name] = values
            elseif occursin(".string", variable_name)
                # Extract string content between double quotes
                string_content = match(r"\"(.*)\"", data_values).captures[1]
                # Convert each character to its ASCII value and store in memory
                values = [Int(c) for c in string_content]
                literals[variable_name] = values
            end
        end
    end
    return literals
end
























# function parse_and_store_memory(assembly::Vector{String}, memory::Array{Int,2})
#     current_row = 1

#     for line in assembly
#         parts = split(line, ':')
#         if length(parts) == 2
#             variable_name = strip(parts[1])
#             data_values = strip(parts[2])

#             if occursin(".word", variable_name)
#                 values = parse.(Int, split(data_values))
#                 if current_row <= size(memory, 1)
#                     memory[current_row, 1:length(values)] .= values
#                     current_row += 1
#                 else
#                     println("Error: Insufficient memory rows for .word directive.")
#                 end
#             elseif occursin(".string", variable_name)
#                 # Extract string content between double quotes
#                 string_content = match(r"\"(.*)\"", data_values).captures[1]
#                 # Convert each character to its ASCII value and store in memory
#                 values = [Int(c) for c in string_content]

#                 if current_row <= size(memory, 1)
#                     memory[current_row, 1:length(values)] .= values
#                     current_row += 1
#                 else
#                     println("Error: Insufficient memory rows for .string directive.")
#                 end
#             end
#         end
#     end
# end

# # Example usage:
# assembly_code = ["array: .word 10 20 30", "str: .string \"Hello\"", ""]
# memory_array = zeros(Int, 1024, 4)
# parse_and_store_memory(assembly_code, memory_array)

# println(memory_array)





# function parse_and_store_memory(assembly::Vector{String})
#     memory = Dict{String, Vector{Int}}()

#     for line in assembly
#         parts = split(line, ':')
#         if length(parts) == 2
#             variable_name = strip(parts[1])
#             data_values = strip(parts[2])

#             if occursin(".word", variable_name)
#                 values = parse.(Int, split(data_values))
#                 memory[variable_name] = values
#             elseif occursin(".string", variable_name)
#                 # Extract string content between double quotes
#                 string_content = match(r"\"(.*)\"", data_values).captures[1]
#                 # Convert each character to its ASCII value and store in memory
#                 values = [Int(c) for c in string_content]
#                 memory[variable_name] = values
#             end
#         end
#     end

#     return memory
# end

# # Example usage:
# assembly_code = ["array: .word 10 20 30", "str: .string \"Hello\"", ""]
# memory_contents = parse_and_store_memory(assembly_code)

# println(memory_contents)
