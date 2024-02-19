module Core_Module

export Core1, core_Init
    mutable struct Core1
        registers::Array{Int,1}
        pc::Int
        program::Vector{String}
        function Core1()
            this = new()
            this.registers = fill(0, 32)
            this.pc = 1
            this.program = []
            return this
        end
    end
    
    function core_Init()
        return Core1()
    end
end