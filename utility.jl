function remove_commas(input_string::AbstractString)::AbstractString
    return replace(input_string, "," => " ")
end

function remove_comments(input_string::AbstractString)::AbstractString
    return replace(input_string, r"#.*" => "")
end

function remove_parentheses(input_string::AbstractString)::AbstractString
    return replace(input_string, r"[()]" => " ")
end

function add_spaces(input_string::AbstractString)::AbstractString
    return replace(input_string, r"(\w)([x\d])" => s"\1 \2")
end

function remove_quotes_from_string(input_string::AbstractString)::AbstractString
    return replace(input_string, r"\"" => "")
end


function remove_colon(input_string::AbstractString)::AbstractString
    return replace(input_string, r":" => "")
end

function remove_empty_strings(strings::Vector{Any})
    return filter(x -> !isempty(x), strings)
end

function sanitize(raw_line::AbstractString)::AbstractString
    modified_line = replace(raw_line, r"\b\d+\b" => x -> string(parse(Int, x)))
    modified_line = remove_parentheses(modified_line)
    modified_line = remove_comments(modified_line)
    modified_line = remove_commas(modified_line)
    modified_line = remove_quotes_from_string(modified_line)
    modified_line = remove_colon(modified_line)
    modified_line = strip(modified_line)
    return modified_line
end

function int_to_hex(x::Int)
    return lpad(string(x, base=16), 2, "0")
end

function uint_to_hex_(x::UInt)
    return lpad(string(x, base=16), 2, "0")
end

function binary_to_int(binary_str::AbstractString)::Int
    return parse(Int, binary_str, base=2)
end

function binary_to_uint(binary_str::AbstractString)::UInt
    return parse(UInt, binary_str, base=2)
end

function int_to_binary(x::Int)::AbstractString
    return string(x, base=2)
end

function uint_to_binary(x::UInt)::AbstractString
    return string(x, base=2)
end

function int_to_binary_5bits(x::Int)::AbstractString
    return lpad(string(x, base=2), 5, "0")
end

function int_to_binary_8bits(x::Int)::AbstractString
    return lpad(string(x, base=2), 8, "0")
end

function int_to_binary_12bits(x::Int)::AbstractString
    return lpad(string(x, base=2), 12, "0")
end

function int_to_binary_20bits(x::Int)::AbstractString
    return lpad(string(x, base=2), 20, "0")
end

function int_to_binary_32bits(x::Int)::AbstractString
    return lpad(string(x, base=2), 32, "0")
end

function uint_to_binary_32bits(x::UInt)::AbstractString
    return lpad(string(x, base=2), 32, "0")
end

#use without 0x to  convert to int
function hex_to_int(x::AbstractString)::Int
    return parse(Int, x, base=16)
end

#use without 0x to  convert to uint
function hex_to_uint(x::AbstractString)::UInt
    return parse(UInt, x, base=16)
end

function hex_to_32binary(x::AbstractString)::AbstractString
    return lpad(string(hex_to_int(x), base=2), 32, "0")
end

function store_word(binary_string::AbstractString, memory::Array{Int,2}, row::Int, col::Int)
    if length(binary_string) != 32
        println("Error: Binary string length is not 32 bits.")
        return
    end
    if col == 1
        memory[row, col] = parse(UInt8, binary_string[25:32], base=2)
        memory[row, col+1] = parse(UInt8, binary_string[17:24], base=2)
        memory[row, col+2] = parse(UInt8, binary_string[9:16], base=2)
        memory[row, col+3] = parse(UInt8, binary_string[1:8], base=2)
    elseif col == 2
        memory[row+1, col-1] = parse(UInt8, binary_string[1:8], base=2)
        memory[row, col] = parse(UInt8, binary_string[25:32], base=2)
        memory[row, col+1] = parse(UInt8, binary_string[17:25], base=2)
        memory[row, col+2] = parse(UInt8, binary_string[9:16], base=2)
    elseif col == 3
        memory[row+1, col-2] = parse(UInt8, binary_string[9:16], base=2)
        memory[row+1, col-1] = parse(UInt8, binary_string[1:8], base=2)
        memory[row, col] = parse(UInt8, binary_string[25:32], base=2)
        memory[row, col+1] = parse(UInt8, binary_string[17:24], base=2)
    elseif col == 4
        memory[row+1, col-3] = parse(UInt8, binary_string[17:24], base=2)
        memory[row+1, col-2] = parse(UInt8, binary_string[9:16], base=2)
        memory[row+1, col-1] = parse(UInt8, binary_string[1:8], base=2)
        memory[row, col] = parse(UInt8, binary_string[25:32], base=2)
    end
end

function store_half_word(binary_string::AbstractString, memory::Array{Int,2}, row::Int, col::Int)
    if length(binary_string) != 32
        println("Error: Binary string length is not 32 bits.")
        return
    end
    if col == 1
        memory[row, col] = parse(UInt8, binary_string[25:32], base=2)
        memory[row, col+1] = parse(UInt8, binary_string[17:24], base=2)
    elseif col == 2
        memory[row, col] = parse(UInt8, binary_string[25:32], base=2)
        memory[row, col+1] = parse(UInt8, binary_string[17:24], base=2)
    elseif col == 3
        memory[row, col] = parse(UInt8, binary_string[25:32], base=2)
        memory[row, col+1] = parse(UInt8, binary_string[17:24], base=2)
    elseif col === 4
        memory[row+1, col-3] = parse(UInt8, binary_string[17:24], base=2)
        memory[row, col] = parse(UInt8, binary_string[25:32], base=2)
    end
end

function store_one_byte(binary_string::AbstractString, memory::Array{Int,2}, row::Int, col::Int)
    if length(binary_string) != 32
        println("Error: Binary string length is not 32 bits.")
        return
    end
    memory[row, col] = parse(UInt8, binary_string[25:32], base=2)
end

function load_word(binary_string::AbstractString, memory::Array{Int,2}, row::Int, col::Int) 
    if length(binary_string) != 32
        println("Error: Binary string length is not 32 bits.")
        return
    end
    if col == 1
        return memory[row, col] + memory[row, col+1]*256 + memory[row, col+2]*65536 + memory[row, col+3]*16777216
    elseif col == 2
        return memory[row, col] + memory[row, col+1]*256 + memory[row, col+2]*65536 + memory[row+1, col-1]*16777216
    elseif col == 3
        return memory[row, col] + memory[row, col+1]*256 + memory[row+1, col-2]*65536 + memory[row+1, col-1]*16777216
    elseif col == 4
        return memory[row, col] + memory[row+1, col-3]*256 + memory[row+1, col-2]*65536 + memory[row+1, col-1]*16777216
    end
end

function load_half_word(binary_string::AbstractString, memory::Array{Int,2}, row::Int, col::Int)
    if length(binary_string) != 32
        println("Error: Binary string length is not 32 bits.")
        return
    end
    if col == 1
        return memory[row, col] + memory[row, col+1]*256
    elseif col == 2
        return memory[row, col] + memory[row, col+1]*256
    elseif col == 3
        return memory[row, col] + memory[row, col+1]*256
    elseif col == 4
        return memory[row, col] + memory[row+1, col-3]*256
    end
end

function load_one_byte(binary_string::AbstractString, memory::Array{Int,2}, row::Int, col::Int)
    if length(binary_string) != 32
        println("Error: Binary string length is not 32 bits.")
        return
    end
    return memory[row, col]
end


#   # Extract string content between double quotes
#                 string_content = match(r"\"(.*)\"", part).captures[1]
#                 # Convert each character to its ASCII value and store in memory
#                 values = [Int(c) for c in string_content]
#                 push!(chunks, values)