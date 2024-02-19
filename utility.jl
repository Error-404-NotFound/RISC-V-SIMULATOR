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

#use without 0x to  convert to int
function hex_to_int(x::AbstractString)::Int
    return parse(Int, x, base=16)
end

#use without 0x to  convert to uint
function hex_to_uint(x::AbstractString)::UInt
    return parse(UInt, x, base=16)
end

