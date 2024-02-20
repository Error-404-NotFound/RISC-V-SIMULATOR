function check_assembly_structure(assembly::String)::Bool
    lines = split(assembly, '\n')
    
    text_section_present = false
    data_section_present = false
    
    for line in lines
        parts = split(line)
        if isempty(parts)
            continue  # Skip empty lines
        end
        
        directive = parts[1]
        
        if directive == ".text"
            text_section_present = true
        elseif directive == ".data"
            data_section_present = true
        end
    end
    
    if text_section_present && data_section_present
        return true
    elseif text_section_present
        println("Error: .text section present but .data section is missing.")
        return false
    elseif data_section_present
        println("Error: .data section present but .text section is missing.")
        return false
    else
        return false
    end
    return false
end


function check_assembly_content(assembly::String)::Bool
    lines = split(assembly, '\n')
    
    text_section_contents = Set{String}()
    
    current_section = ""
    
    for line in lines
        parts = split(line)
        if isempty(parts)
            continue  # Skip empty lines
        end
        
        directive = parts[1]
        
        if directive == ".text"
            current_section = ".text"
        elseif directive == ".data"
            current_section = ".data"
        elseif current_section == ".text" && !startswith(directive, ".") && directive != ".word"
            # Check for specific instructions like 'add', 'sub', etc.
            instruction = parts[1]
            if instruction in ["add", "sub", "and", "or", "xor", "lw", "sw", "beq", "bne", "jal", "jr", "j", "li", "addi", "subi", "andi", "ori", "xori", "lui", "slti", "sltiu", "sll", "srl", "sra", "sllv", "srlv", "srav", "slt", "sltu",]
                push!(text_section_contents, join(parts[1:end], " "))
            end
        end
    end
    
    if isempty(text_section_contents)
        println("Error: No relevant instructions (add, sub, etc.) found in .text section.")
        return false
    else
        # println("Relevant instructions (add, sub, etc.) found in .text section: ", join(text_section_contents, ", "))
        return true
    end
end




# function check_assembly_content(assembly::String)::Bool
#     lines = split(assembly, '\n')
    
#     text_section_contents = Set{String}()
    
#     current_section = ""
    
#     for line in lines
#         parts = split(line)
#         if isempty(parts)
#             continue  # Skip empty lines
#         end
        
#         directive = parts[1]
        
#         if directive == ".text"
#             current_section = ".text"
#         elseif directive == ".data"
#             current_section = ".data"
#         elseif current_section == ".text" && !startswith(directive, ".") && directive != ".word"
#             # Check for specific instructions like 'add', 'sub', etc.
#             instruction = parts[1]
#             if instruction in ["add", "sub", "mul", "div", "and", "or", "xor"]
#                 push!(text_section_contents, join(parts[1:end], " "))
#             end
#         end
#     end
    
#     if isempty(text_section_contents)
#         println("Error: No relevant instructions (add, sub, etc.) found in .text section.")
#     else
#         println("Relevant instructions (add, sub, etc.) found in .text section: ", join(text_section_contents, ", "))
#     end
    
#     return !(isempty(text_section_contents))
# end



# function check_assembly_content(assembly::String)
#     lines = split(assembly, '\n')
    
#     text_section_contents = []
    
#     current_section = ""
    
#     for line in lines
#         parts = split(line)
#         if isempty(parts)
#             continue  # Skip empty lines
#         end
        
#         directive = parts[1]
#         println(directive)
#         if directive == ".text"
#             current_section = ".text"
#         elseif directive == ".data"
#             current_section = ".data"
#         elseif current_section == ".text" && !startswith(directive, ".") && directive != ".word"
#             # Check for specific instructions like 'add', 'sub', etc.
#             instruction = parts[1]
#             if instruction in ["add", "sub", "mul", "div", "and", "or", "xor"]
#                 push!(text_section_contents, join(parts[1:end], " "))
#             end
#         end
    
#         if isempty(text_section_contents)
#             println("Error: No relevant instructions (add, sub, etc.) found in .text section.")
#         else
#             println("Relevant instructions (add, sub, etc.) found in .text section: ", join(text_section_contents, ", "))
#         end
    
    
#     end
#     return !(isempty(text_section_contents))
# end







# Example assembly code
# assembly_code = """
# .data
#     .word 0x12345678
# .text
#     add x1, x2, x3
#     jal x1, 0x100
# """

# if check_assembly_structure(assembly_code)
#     println("Assembly code has correct structure.")
# else
#     println("Assembly code has incorrect structure.")
# end
# if check_assembly_content(assembly_code)
#     println("Assembly code has correct content.")
# else
#     println("Assembly code has incorrect content.")
# end


# function remove_commas(input_string::AbstractString)::AbstractString
#     return replace(input_string, "," => " ")
# end

# function remove_comments(input_string::AbstractString)::AbstractString
#     return replace(input_string, r"#.*" => "")
# end

# function add_spaces(input_string::AbstractString)::AbstractString
#     return replace(input_string, r"(\w)([x\d])" => s"\1 \2")
# end

# function parse_instruction(input_string::AbstractString)::Vector{String}
#     function parse_assembly_sections(assembly_code::AbstractString)::Dict{String, AbstractString}
#         sections = Dict{String, AbstractString}()
        
#         # Regular expression to match .text and .data sections in assembly code
#         section_pattern = r"\.text\s*:(.*?)(?=(\.data|$))"
        
#         # Find all matches using regular expression
#         for match in eachmatch(section_pattern, assembly_code, ignorecase=true)
#             section_name = ".text"
#             section_content = strip(match.captures[1])
#             sections[section_name] = section_content
#         end
        
#         # Reset regex for .data section
#         section_pattern = r"\.data\s*:(.*?)(?=(\.text|$))"
        
#         # Find all matches using regular expression
#         for match in eachmatch(section_pattern, assembly_code, ignorecase=true)
#             section_name = ".data"
#             section_content = strip(match.captures[1])
#             sections[section_name] = section_content
#         end
        
#         return sections
#     end
# end