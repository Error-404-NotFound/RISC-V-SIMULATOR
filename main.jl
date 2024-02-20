include("sim.jl")
include("parser.jl")
include("utility.jl")

file_path = "./test.asm"
program = []

function convert_iostream_to_string(io::IO)
    seekstart(io)  
    str = read(io, String)
    return str
end

try
    file = open(file_path, "r")
    
    for line in eachline(file)
        if !contains(line, "any")
            modified_line = replace(line, r"\b\d+\b" => x -> string(parse(Int, x)))
            modified_line = remove_parentheses(modified_line)
            modified_line = remove_comments(modified_line)
            modified_line = remove_commas(modified_line)
            push!(program, modified_line)            
        end
    end

    str  = convert_iostream_to_string(file)
    if !check_assembly_structure(str) && !check_assembly_content(str)
        println("Error: Assembly code has incorrect structure or content.")
    end
  
    close(file)
    println(program)
catch err
    println("An error occurred: $err")
end

function main()
    sim = processor_Init()
    sim.cores[1].program = program
    run(sim)
    for i in 1:length(sim.cores)
        println(sim.cores[i].registers)
    end
    print(sim.memory[2,2])
    # println(sim.memory[1,2])
    # show_memory(sim)
end

main()
