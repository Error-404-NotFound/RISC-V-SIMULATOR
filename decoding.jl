include("core.jl")
include("utility.jl")
include("execute_decoded_functions.jl")

opcode_code_type = Dict(
    "0110011" => "R_type_instrucion",
    "0010011" => "I_type_instrucion",
    "0100011" => "S_type_instrucion",
    "1100011" => "SB_type_instrucion",
    "0110111" => "U_type_instrucion",
    "1101111" => "J_type_instrucion",
    "0000011" => "Load_instrucion",
)

func3_S = Dict(
    "000" => "sb",
    "001" => "sh",
    "010" => "sw"
)

func3_SB = Dict(
    "000" => "beq",
    "001" => "bne",
    "100" => "blt",
    "101" => "bge",
    "110" => "bltu",
    "111" => "bgeu"
)

func3_U = Dict(
    "000" => "lui",
    "001" => "auipc"
)

func3_J = Dict(
    "000" => "jal"
)

function decode_and_execute(core::Core1, memory::Array{Int,2})
    binary_string = ""
    for i in 4:-1:1
        binary_string *= int_to_binary_8bits(memory[core.pc, i])
    end
    # binary_string = reverse(binary_string)
    # println(binary_string)
    opcode = binary_string[26:32]
    # println(opcode)

    if opcode_code_type[opcode] == "R_type_instrucion"
        rd = binary_to_int(binary_string[21:25]) + 1
        func3 = binary_string[18:20]
        rs1 = binary_to_int(binary_string[13:17]) + 1
        rs2 = binary_to_int(binary_string[8:12]) + 1
        func7 = binary_string[1:7]
        execute_R_type(core, func3, func7, rd, rs1, rs2)

    elseif opcode_code_type[opcode] == "I_type_instrucion"
        rd = binary_to_int(binary_string[21:25]) + 1
        func3 = binary_string[18:20]
        rs1 = binary_to_int(binary_string[13:17]) + 1
        imm = binary_to_int(binary_string[1:12])
        execute_I_type(core, func3, rd, rs1, imm)

    elseif opcode_code_type[opcode] == "S_type_instrucion"
        func3 = binary_string[18:20]
        rs1 = binary_to_int(binary_string[13:17]) + 1
        rs2 = binary_to_int(binary_string[8:12]) + 1
        imm = binary_to_int(binary_string[1:7]*binary_string[20:25])
        execute_S_type(core, func3, rs1, rs2, imm)

    elseif opcode_code_type[opcode] == "SB_type_instrucion" 
        println("SB_type_instrucion")
        func3 = binary_string[18:20]
        println(func3)
        rs1 = binary_to_int(binary_string[13:17]) + 1
        println(rs1)
        rs2 = binary_to_int(binary_string[8:12]) + 1
        println(rs2)
        imm = binary_to_int(binary_string[25]*binary_string[2:7]*binary_string[21:24]*"0")
        imm = imm ÷ 4
        execute_SB_type(core, func3, rs1, rs2, imm)
    
    elseif opcode_code_type[opcode] == "U_type_instrucion"
        rd = binary_to_int(binary_string[21:25]) + 1
        func3 = binary_string[18:20]
        imm = binary_to_int(binary_string[1:20]*"0"*"0")
        execute_U_type(core, func3, rd, imm)
    

    elseif opcode_code_type[opcode] == "J_type_instrucion"
        rd = binary_to_int(binary_string[21:25]) + 1
        imm = binary_to_int(binary_string[1]*binary_string[12:19]*binary_string[20]*binary_string[21:30]*"0")
        execute_J_type(core, rd, imm)

    elseif opcode_code_type[opcode] == "Load_instrucion"
        rd = binary_to_int(binary_string[21:25]) + 1
        func3 = binary_string[18:20]
        rs1 = binary_to_int(binary_string[13:17]) + 1
        imm = binary_to_int(binary_string[1:12])
        execute_Load_type(core, func3, rd, rs1, imm)
    end

    core.pc += 1
end
