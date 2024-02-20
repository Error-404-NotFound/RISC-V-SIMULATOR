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

function sanitize(raw_line::AbstractString)::AbstractString
    modified_line = replace(raw_line, r"\b\d+\b" => x -> string(parse(Int, x)))
    modified_line = remove_parentheses(modified_line)
    modified_line = remove_comments(modified_line)
    modified_line = remove_commas(modified_line)
    modified_line = strip(modified_line)
    return modified_line
end

try
    file = open(file_path, "r")
    for line in eachline(file)
        if !contains(line, "any")
            modified_line = sanitize(line)
            push!(program, modified_line)            
        end
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
