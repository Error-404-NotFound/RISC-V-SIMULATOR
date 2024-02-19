function remove_commas(input_string::AbstractString)::AbstractString
    return replace(input_string, "," => " ")
end

function remove_comments(input_string::AbstractString)::AbstractString
    return replace(input_string, r"#.*" => "")
end

function add_spaces(input_string::AbstractString)::AbstractString
    return replace(input_string, r"(\w)([x\d])" => s"\1 \2")
end

function parse_instruction(input_string::AbstractString)::Vector{String}
    function parse_assembly_sections(assembly_code::AbstractString)::Dict{String, AbstractString}
        sections = Dict{String, AbstractString}()
        
        # Regular expression to match .text and .data sections in assembly code
        section_pattern = r"\.text\s*:(.*?)(?=(\.data|$))"
        
        # Find all matches using regular expression
        for match in eachmatch(section_pattern, assembly_code, ignorecase=true)
            section_name = ".text"
            section_content = strip(match.captures[1])
            sections[section_name] = section_content
        end
        
        # Reset regex for .data section
        section_pattern = r"\.data\s*:(.*?)(?=(\.text|$))"
        
        # Find all matches using regular expression
        for match in eachmatch(section_pattern, assembly_code, ignorecase=true)
            section_name = ".data"
            section_content = strip(match.captures[1])
            sections[section_name] = section_content
        end
        
        return sections
    end
end