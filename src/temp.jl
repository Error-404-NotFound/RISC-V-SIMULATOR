function writeback_stage(instruction::String, instruction_type::String, core::Core1, memory::Array{Int,2}, variable_address::Dict{String, Int})
    if instruction_type == "R_type_instructions"
        core.registers[core.rd_temp_register] = core.EX_temp_register
    elseif instruction_type == "I_type_instructions"
        core.registers[core.rd_temp_register] = core.EX_temp_register
    elseif instruction_type == "Load_type_instructions"
        core.registers[core.rd_temp_register] = core.EX_temp_register
    elseif instruction_type == "S_type_instructions"
        memory[core.EX_temp_register] = core.registers[core.rs1_temp_register]
    elseif instruction_type == "SB_type_instructions"
        if core.EX_temp_register == 1
            core.pc = variable_address[core.label_temp_register]
        end
    elseif instruction_type == "U_type_instructions"
        core.registers[core.rd_temp_register] = core.EX_temp_register
    elseif instruction_type == "UJ_type_instructions"
        core.registers[core.rd_temp_register] = core.EX_temp_register
        if core.EX_temp_register == 1
            core.pc = variable_address[core.label_temp_register]
        end
    end
end