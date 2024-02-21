include("utility.jl")

function parse_data_section(data_section::AbstractString)
    labels = []
    chunks = []

    # Split the data section by semicolon to separate labels
    sections = split(data_section, '\n')  # Change ';' to '\n' to split by lines
    for section in sections
        section = strip(section)
        if isempty(section) || startswith(section, '#')
            continue
        end
        # Split each section by whitespaces
        parts = split(section)
        
        # If there's a label, store it separately
        label = parts[1]
        if endswith(label, ':')
            push!(labels, chop(label, tail=1))
            parts = parts[2:end]
        end
        
        # Store the remaining parts as chunks
        for part in parts
            push!(chunks, part)
        end
    end

    return labels, chunks
end

function extract_data(chunks::Vector{Any})
    labels = []
    values = []

    i = 1
    while i <= length(chunks)
        if chunks[i] == ".word"
            if i+1 <= length(chunks)
                # No need to parse variable name, directly parse the value
                value = parse(Int, chunks[i+1])  # Convert the value to an integer
                push!(values, value)
                i += 2
            else
                error("Invalid usage of .word directive: $(chunks[i])")
            end
        elseif chunks[i] == ".string"
            # No need to parse variable name, directly join the string value
            value = join(chunks[i+1:end])
            value = sanitize(value)
            push!(values, value)
            i = length(chunks) + 1  # exit loop after processing .string directive
        elseif endswith(chunks[i], ':')  # Check if it's a label
            # If it's a label, store it
            push!(labels, chop(chunks[i], tail=1))
            i += 1
        else
            error("Unsupported directive: $(chunks[i])")
        end
    end

    return labels, values
end

# Example usage
data_section = """
array: .word 1
string_array: .string "Hello, world!"
"""

labels, chunks = parse_data_section(data_section)
println("Labels:", labels)
println("Chunks:", chunks)

labels, values = extract_data(chunks)
println("Values:", values)
