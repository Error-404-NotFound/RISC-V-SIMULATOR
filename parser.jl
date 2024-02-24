include("utility.jl")

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
            if instruction in ["add", "sub", "and", "or", "xor", "lw", "sw", "beq", "bne", "jal", "jr", "j", "li", "addi", "subi", "andi", "ori", "xori", "lui", "slti", "sltiu", "sll", "srl", "sra", "sllv", "srlv", "srav", "slt", "sltu","ecall"]
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

function convert_iostream_to_string(io::IO)
    seekstart(io)  
    str = read(io, String)
    return str
end

function parse_assembly_code(file_path::String)
    text_program = []
    data_program = []
    
    
    try
        flag = true
        file = open(file_path, "r")
        str  = convert_iostream_to_string(file)
        if !check_assembly_structure(str) || !check_assembly_content(str)
            flag = false
        end
        close(file)
    
        if (flag==false)
            println("Invalid Assembly File")
        
        else
            text_flag=false
            data_flag=false
            file = open(file_path, "r")
            for line in eachline(file)
                if !contains(line, "any") && text_flag==true
                    modified_line = sanitize(line)  
                else
                    modified_line = line
                end
                if occursin(r"\.text", line)
                    text_flag=true
                    data_flag=false
                end
                if occursin(r"\.data", line)
                    data_flag=true
                    text_flag=false
                end
                if(text_flag==true && !occursin(r"\.text",line) && !occursin(r"\.data",line) && line!=".end" )
                    push!(text_program, modified_line)  
                end
                if(data_flag==true && !occursin(r"\.data",line) && !occursin(r"\.text",line) && line!=".end" && text_flag==false)
                    push!(data_program, modified_line)  
                end
            end
            close(file)
            
        end
    catch err
        println("An error occurred: $err")
    end
    text_program = remove_empty_strings(text_program)
    data_program = remove_empty_strings(data_program)
    # println(data_program)
    # println(text_program)
    return text_program, data_program
end


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
        # println(parts)

        parts2= split(section, '\"')

        # println("splite :",parts2[2])

        # If there's a label, store it separately
        label = parts[1]
        if endswith(label, ':')
            push!(labels, chop(label, tail=1))
            push!(chunks, chop(label, tail=1))
            # Remove the label from the parts list
            parts = parts[2:end]
        end
        
        # Check if the remaining parts contain a directive
        if length(parts) >= 1
            directive = parts[1]
            if directive == ".string" && length(parts) >= 2
                push!(chunks, directive)
                string_content = join(parts[2:end], " ")
                string_content = replace(string_content, r"\"" => "")
                push!(chunks, parts2[2])
                continue
            elseif directive == ".word" && length(parts) >= 2
                push!(chunks, directive)
                word_content = join(parts[2:end], " ")
                word_content = replace(word_content, r"," => " ")
                word_content = split(word_content)
                for word in word_content
                    push!(chunks, word)
                end
                continue
            end
        end
        
        # If no directive is found, check for other possible formats
        
        # Match .string or .word with optional whitespace between label and directive
        match_string = match(r"^([^:]+):\s*\.string\s*(\"[^\"]*\")", section)
        match_word = match(r"^([^:]+):\s*\.word\s*((-?\d+\s*,?\s*)+)", section)
        
        if match_string !== nothing
            label = match_string.captures[1]
            string_content = match_string.captures[2]
            push!(labels, label)
            push!(chunks, label)
            push!(chunks, ".string")
            string_content = replace(string_content, r"\"" => "")
            push!(chunks, string_content)
            continue
        elseif match_word !== nothing
            label = match_word.captures[1]
            word_content = match_word.captures[2]
            push!(labels, label)
            push!(chunks, label)
            push!(chunks, ".word")
            word_content = replace(word_content, r"," => " ")
            word_content = split(word_content)
            for word in word_content
                push!(chunks, word)
            end
            continue
        end

    end
    return labels, chunks
end
