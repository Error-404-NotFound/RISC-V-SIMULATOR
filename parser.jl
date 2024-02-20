function check_assembly_structure(assembly::String)
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
        println("Assembly structure is well-structured.")
    elseif text_section_present
        println("Error: .data section is missing.")
    elseif data_section_present
        println("Error: .text section is missing.")
    else
        println("Error: Both .text and .data sections are missing.")
    end
end

function check_assembly_content(assembly::String)
    lines = split(assembly, '\n')
    
    text_section_contents = Set{String}()
    data_section_contents = Set{String}()
    
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
        elseif current_section == ".text"
            push!(text_section_contents, directive)
        elseif current_section == ".data" && parts[1] == ".word"
            push!(data_section_contents, parts[2])
        end
    end
    
    if isempty(text_section_contents)
        println("Error: No relevant instructions found in .text section.")
    else
        println("Relevant instructions found in .text section.")
    end
    
    if isempty(data_section_contents)
        println("Error: No relevant data entries found in .data section.")
    else
        println("Relevant data entries found in .data section.")
    end
end

# Example assembly code
assembly_code = """
.text
    add x1, x2, x3
    jal x1, 0x100
.data
    .word 0x12345678
"""

check_assembly_structure(assembly_code)
check_assembly_content(assembly_code)


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