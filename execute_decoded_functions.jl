include("utility.jl")

func3_R = Dict(
    "000" => "add",
    "001" => "sll",
    "010" => "slt",
    "011" => "sltu",
    "100" => "xor",
    "101" => "srl",
    "110" => "or",
    "111" => "and"
)

func3_I = Dict(
    "000" => "addi",
    "001" => "slli",
    "010" => "slti",
    "011" => "sltiu",
    "100" => "xori",
    "101" => "srli",
    "110" => "ori",
    "111" => "andi"
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


function execute_R_type(core::Core1, func3::AbstractString, func7::AbstractString, rd::Int, rs1::Int, rs2::Int)
    if func3_R[func3] == "add"
        if func7 == "0000000"
            core.registers[rd] = core.registers[rs1] + core.registers[rs2]
        elseif func7 == "0100000"
            core.registers[rd] = core.registers[rs1] - core.registers[rs2]
        end
    elseif func3_R[func3] == "sll"
        core.registers[rd] = core.registers[rs1] << core.registers[rs2]
    elseif func3_R[func3] == "slt"
        core.registers[rd] = core.registers[rs1] < core.registers[rs2]
    elseif func3_R[func3] == "sltu"
        core.registers[rd] = core.registers[rs1] < core.registers[rs2]
    elseif func3_R[func3] == "xor"
        core.registers[rd] = core.registers[rs1] ⊻ core.registers[rs2]
    elseif func3_R[func3] == "srl"
        if func7 == "0000000"
            core.registers[rd] = core.registers[rs1] >>> core.registers[rs2]
        elseif func7 == "0100000"
            core.registers[rd] = core.registers[rs1] >> core.registers[rs2]
        end
    elseif func3_R[func3] == "or"
        core.registers[rd] = core.registers[rs1] | core.registers[rs2]
    elseif func3_R[func3] == "and"
        core.registers[rd] = core.registers[rs1] & core.registers[rs2]
    end
end

function execute_I_type(core::Core1, func3::AbstractString, rd::Int, rs1::Int, imm::Int)
    if func3_I[func3] == "addi"
        core.registers[rd] = core.registers[rs1] + imm
    elseif func3_I[func3] == "slti"
        core.registers[rd] = core.registers[rs1] < imm
    elseif func3_I[func3] == "sltiu"
        core.registers[rd] = core.registers[rs1] < imm
    elseif func3_I[func3] == "xori"
        core.registers[rd] = core.registers[rs1] ⊻ imm
    elseif func3_I[func3] == "ori"
        core.registers[rd] = core.registers[rs1] | imm
    elseif func3_I[func3] == "andi"
        core.registers[rd] = core.registers[rs1] & imm
    elseif func3_I[func3] == "slli"
        imm = int_to_binary_12bits(imm)
        imm = binary_to_int(imm[8:12])
        core.registers[rd] = core.registers[rs1] << imm
    elseif func3_I[func3] == "srli"
        imm = int_to_binary_12bits(imm)
        if imm[2] == '0'    #logical shift
            shamt = binary_to_int(imm[8:12])
            core.registers[rd] = core.registers[rs1] >>> shamt
        elseif imm[2] == "1"    #arithmetic shift
            shamt = binary_to_int(imm[8:12])
            core.registers[rd] = core.registers[rs1] >> shamt
        end
    end
end


function execute_S_type(core::Core1, func3::AbstractString, rs1::Int, rs2::Int, imm::Int)
    if func3 == "000"
        core.registers[rs2] = core.registers[rs1] + imm
    elseif func3 == "001"
        core.registers[rs2] = core.registers[rs1] | imm
    elseif func3 == "010"
        core.registers[rs2] = core.registers[rs1] & imm
    elseif func3 == "100"
        imm = int_to_binary_12bits(imm)
        imm = binary_to_int(imm[8:12])
        core.registers[rs2] = core.registers[rs1] + imm
    end
end

function execute_SB_type(core::Core1, func3::AbstractString, rs1::Int, rs2::Int, imm::Int)
    if func3 == "000"
        if core.registers[rs1] == core.registers[rs2]
            core.pc += imm
        end
    elseif func3 == "001"
        if core.registers[rs1] != core.registers[rs2]
            core.pc += imm
        end
    elseif func3 == "100"
        if core.registers[rs1] < core.registers[rs2]
            core.pc += imm
        end
    elseif func3 == "101"
        if core.registers[rs1] >= core.registers[rs2]
            core.pc += imm
        end
    end
end

function execute_U_type(core::Core1, func3::AbstractString, rd::Int, imm::Int)
    if func3 == "000"
        core.registers[rd] = imm << 12
    elseif func3 == "001"
        core.registers[rd] = core.registers[rd] + imm << 12
    end
end

function execute_J_type(core::Core1, rd::Int, imm::Int)
    core.registers[rd] = core.pc + 4
    core.pc += imm
end
