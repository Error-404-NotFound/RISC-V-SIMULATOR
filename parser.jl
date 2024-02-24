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
    println(text_program)
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
       

        # If there's a label, store it separately
        label = parts[1]
        if endswith(label, ':')
            push!(labels, chop(label, tail=1))
            push!(chunks, chop(label, tail=1))
        end
        # Match .string with or without space and extract string content
        match_result = match(r"\.string\s*(\"[^\"]*\")", section)
        if match_result !== nothing
            string_content = match_result.captures[1]
            push!(chunks, ".string")
            string_content = replace(string_content, r"\"" => "")
            push!(chunks, string_content)
            continue
        end
        
        #Match .word with spaces or with commmas in between numbers for any number of spaces or commas and store the as different chunks even if there are spaces between the numbers
        # match_result = match(r"\.word\s*((\d+\s*,?\s*)+)", section)
        match_result = match(r"\.word\s*((-?\d+\s*,?\s*)+)", section)
        if match_result !== nothing
            word_content = match_result.captures[1]
            word_content = replace(word_content, r"," => " ")
            word_content = split(word_content)
            push!(chunks, ".word")
            for word in word_content
                push!(chunks, word)
            end
            continue
        end

        

    end
    return labels, chunks
end
