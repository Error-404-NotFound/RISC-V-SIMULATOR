alias = Dict(
    "zero" => "x0",
    "ra" => "x1",
    "sp" => "x2",
    "gp" => "x3",
    "tp" => "x4",
    "t0" => "x5",
    "t1" => "x6",
    "t2" => "x7",
    "s0" => "x8",
    "s1" => "x9",
    "a0" => "x10",
    "a1" => "x11",
    "a2" => "x12",
    "a3" => "x13",
    "a4" => "x14",
    "a5" => "x15",
    "a6" => "x16",
    "a7" => "x17",
    "s2" => "x18",
    "s3" => "x19",
    "s4" => "x20",
    "s5" => "x21",
    "s6" => "x22",
    "s7" => "x23",
    "s8" => "x24",
    "s9" => "x25",
    "s10" => "x26",
    "s11" => "x27",
    "t3" => "x28",
    "t4" => "x29",
    "t5" => "x30",
    "t6" => "x31",
)

opcode_dictionary = Dict(
    "R_type_instructions" => ["add", "sub", "sll", "slt", "sltu", "xor", "srl", "sra", "or", "and", "mul"],
    "I_type_instructions" => ["addi", "slti", "sltiu", "xori", "ori", "andi", "slli", "srli", "srai", "muli", "jalr", "jr", "li", "mv"],
    "S_type_instructions" => ["sb", "sh", "sw"],
    "L_type_instructions" => ["lb", "lh", "lw", "lbu", "lhu"],
    "SB_type_instructions" => ["beq", "bne", "blt", "ble", "bge", "bltu", "bgeu"],
    "U_type_instructions" => ["lui", "auipc"],
    "UJ_type_instructions" => ["jal", "la", "j"],
)

opcodes = ["add", "sub", "sll", "slt", "sltu", "xor", "srl", "sra", "or", "and", "mul", "addi", "slti", "sltiu", "xori", "ori", "andi", "slli", "srli", "srai", "muli", "jalr", "jr", "li", "mv", "sb", "sh", "sw", "lb", "lh", "lw", "lbu", "lhu", "beq", "bne", "blt", "ble", "bge", "bltu", "bgeu", "lui", "auipc", "jal", "la", "j"]

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

#function to remove the empty strings from the parts
function remove_empty_strings(parts)
    return filter(x -> !isempty(x), parts)
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

#function to replace the register names with their respective values in the instruction
function replace_registers(instruction)
    for (key, value) in alias
        instruction = replace(instruction, key => value)
    end
    return instruction
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

function int_to_binary_bits_modified(num::Int, num_bits::Int)::AbstractString
    if num >= 0
        binary = bitstring(UInt32(num))               # Convert to binary
        binary = binary[32-num_bits+1:end]            # Remove '0b' prefix
    else
        # For negative numbers, compute the two's complement
        positive_num = 2^num_bits + num
        binary = bitstring(UInt32(positive_num))      # Convert to binary
        binary = binary[32-num_bits+1:end]            # Remove '0b' prefix
    end
    return binary
end

function binary_to_int_modified(binary::AbstractString)::Int
         # For negative numbers, compute the two's complement
        positive_num = 2^length(binary) - parse(Int, binary, base=2)
        return -positive_num 
end

function get_row_col_from_address(address::Int)
    if address == 0
        return 1, 1
    end
    temp_col = address % 4
    if temp_col == 0
        temp_col = 4
    end
    temp_row = (address - temp_col) ÷ 4 + 1
    return temp_row, temp_col
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
        memory[row, col+1] = parse(UInt8, binary_string[17:24], base=2)
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

function load_word(memory::Array{Int,2}, row::Int, col::Int) 
    # if length(binary_string) != 32
    #     println("Error: Binary string length is not 32 bits.")
    #     return
    # end
    if col == 1
        temp_value = memory[row, col] + memory[row, col+1]*256 + memory[row, col+2]*65536 + memory[row, col+3]*16777216
    elseif col == 2
        temp_value = memory[row, col] + memory[row, col+1]*256 + memory[row, col+2]*65536 + memory[row+1, col-1]*16777216
    elseif col == 3
        temp_value = memory[row, col] + memory[row, col+1]*256 + memory[row+1, col-2]*65536 + memory[row+1, col-1]*16777216
    elseif col == 4
        temp_value = memory[row, col] + memory[row+1, col-3]*256 + memory[row+1, col-2]*65536 + memory[row+1, col-1]*16777216
    end
    if temp_value > 2147483647
        temp_value -= 4294967296
    end
    return temp_value
end

function load_half_word(memory::Array{Int,2}, row::Int, col::Int)
    # if length(binary_string) != 32
    #     println("Error: Binary string length is not 32 bits.")
    #     return
    # end
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

function load_one_byte(memory::Array{Int,2}, row::Int, col::Int)
    # if length(binary_string) != 32
    #     println("Error: Binary string length is not 32 bits.")
    #     return
    # end
    return memory[row, col]
end

function get_parts_and_opcode_from_instruction(instruction::String)
    parts = split(instruction, " ")
    parts = remove_empty_strings(parts)
    return parts, parts[1]
end

# function branch_prediction_1Bit_NT(core::Core1, instruction::String, instruction_type::String, rd::Int)
#     if instruction_type == "SB_type_instructions"
#         parts, opcode = get_parts_and_opcode_from_instruction(instruction)
#         # println(core.rs1_temp_register)
#         # println(core.rs2_temp_register)
#         # println(core.rd_temp_register)
#         # println(core.rd_temp_register_previous_instruction)
#         # println(rd)
#         if core.rs1_temp_register == core.rd_temp_register || rd == core.rd_temp_register || core.rs2_temp_register == core.rd_temp_register
#             core.stall_in_next_clock_cycle = true
#             core.write_back_last_instruction = false
#             core.stall_at_IF = false
#             core.rd_temp_register_previous_instruction = core.rd_temp_register
#             core.rd_temp_register = rd
#             core.instruction_after_ID_RF = instruction
#             core.temp_register_instruction_type = instruction_type
#             return
#         end

#         if core.rs1_temp_register == core.rd_temp_register_previous_instruction || rd == core.rd_temp_register_previous_instruction || core.rs2_temp_register == core.rd_temp_register_previous_instruction
#             if !core.write_back_previous_last_instruction
#                 core.stall_at_IF = true
#                 core.stall_at_EX = true
#                 core.stall_in_next_clock_cycle = true
#             end
#             core.stall_at_IF = true
#             return
#         end

#         if opcode == "beq"
#             if core.registers[core.rs1_temp_register] == core.registers[core.rs2_temp_register]
#                 temp_dest = findfirst(x -> x == core.label_temp_register, core.program)
#                 if temp_dest-1 < core.pc
#                     core.stall_at_IF = true
#                     # core.stall_in_next_clock_cycle = true
#                     if core.stall_at_EX && core.stall_in_next_clock_cycle
#                         core.stall_at_EX = false
#                         core.stall_in_next_clock_cycle = false
#                     end
#                 end
#             end
#         end

#         if opcode == "bne"
#             if core.registers[core.rs1_temp_register] != core.registers[core.rs2_temp_register]
#                 temp_dest = findfirst(x -> x == core.label_temp_register, core.program)
#                 if temp_dest-1 < core.pc
#                     core.stall_at_IF = true
#                     # core.stall_in_next_clock_cycle = true
#                     if core.stall_at_EX && core.stall_in_next_clock_cycle
#                         core.stall_at_EX = false
#                         core.stall_in_next_clock_cycle = false
#                     end
#                 end
#             end
#         end

#         if opcode == "blt"
#             if core.registers[core.rs1_temp_register] < core.registers[core.rs2_temp_register]
#                 temp_dest = findfirst(x -> x == core.label_temp_register, core.program)
#                 if temp_dest-1 < core.pc
#                     core.stall_at_IF = true
#                     # core.stall_in_next_clock_cycle = true
#                     if core.stall_at_EX && core.stall_in_next_clock_cycle
#                         core.stall_at_EX = false
#                         core.stall_in_next_clock_cycle = false
#                     end
#                 end
#             end
#         end

#         if opcode == "ble"
#             if core.registers[core.rs1_temp_register] <= core.registers[core.rs2_temp_register]
#                 temp_dest = findfirst(x -> x == core.label_temp_register, core.program)
#                 if temp_dest-1 < core.pc
#                     core.stall_at_IF = true
#                     # core.stall_in_next_clock_cycle = true
#                     if core.stall_at_EX && core.stall_in_next_clock_cycle
#                         core.stall_at_EX = false
#                         core.stall_in_next_clock_cycle = false
#                     end
#                 end
#             end
#         end

#         if opcode == "bge"
#             if core.registers[core.rs1_temp_register] >= core.registers[core.rs2_temp_register]
#                 temp_dest = findfirst(x -> x == core.label_temp_register, core.program)
#                 if temp_dest-1 < core.pc
#                     core.stall_at_IF = true
#                     # core.stall_in_next_clock_cycle = true
#                     if core.stall_at_EX && core.stall_in_next_clock_cycle
#                         core.stall_at_EX = false
#                         core.stall_in_next_clock_cycle = false
#                     end
#                 end
#             end
#         end

#         if opcode == "bltu"
#             if core.registers[core.rs1_temp_register] < core.registers[core.rs2_temp_register]
#                 temp_dest = findfirst(x -> x == core.label_temp_register, core.program)
#                 if temp_dest-1 < core.pc
#                     core.stall_at_IF = true
#                     # core.stall_in_next_clock_cycle = true
#                     if core.stall_at_EX && core.stall_in_next_clock_cycle
#                         core.stall_at_EX = false
#                         core.stall_in_next_clock_cycle = false
#                     end
#                 end
#             end
#         end

#         if opcode == "bgeu"
#             if core.registers[core.rs1_temp_register] >= core.registers[core.rs2_temp_register]
#                 temp_dest = findfirst(x -> x == core.label_temp_register, core.program)
#                 if temp_dest-1 < core.pc
#                     core.stall_at_IF = true
#                     # core.stall_in_next_clock_cycle = true
#                     if core.stall_at_EX && core.stall_in_next_clock_cycle
#                         core.stall_at_EX = false
#                         core.stall_in_next_clock_cycle = false
#                     end
#                 end
#             end
#         end
#     end
# end


#   # Extract string content between double quotes
#                 string_content = match(r"\"(.*)\"", part).captures[1]
#                 # Convert each character to its ASCII value and store in memory
#                 values = [Int(c) for c in string_content]
#                 push!(chunks, values)