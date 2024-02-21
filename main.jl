include("processor.jl")
include("parser.jl")
include("utility.jl")

file_path = "./test.asm"
text_program_first = []
data_program_first = []


function convert_iostream_to_string(io::IO)
    seekstart(io)  
    str = read(io, String)
    return str
end

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
        text_first_flag=false
        data_first_flag=false
        file = open(file_path, "r")
        for line in eachline(file)
            if !contains(line, "any") 
                modified_line = sanitize(line)  
            end
            if(line==".text")
                text_first_flag=true
                data_first_flag=false
            end
            if(line==".data")
                data_first_flag=true
                text_first_flag=false
            end
            if(text_first_flag==true && line!=".text" && line!=".data" && line!=".end" )
                push!(text_program_first, modified_line)  
            end
            if(data_first_flag==true && line!=".data" && line!=".text" && line!=".end" && text_first_flag==false)
                push!(data_program_first, modified_line)  
            end
        end
        close(file)
        println(data_program_first)
        println(text_program_first)
    end
catch err
    println("An error occurred: $err")
end

function main()
    sim = processor_Init()
    sim.cores[1].program = text_program_first
    run(sim)
    for i in 1:length(sim.cores)
        println(sim.cores[i].registers)
    end
    # print(sim.memory[2,2])
    # println(sim.memory[1,2])
    show_memory(sim)
end

main()