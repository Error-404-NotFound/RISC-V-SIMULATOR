mutable struct CacheBlock
    block_size::Int64
    isValid::Bool
    isDirty::Bool
    isAccessed::Bool
    block::Array{String, 1}
    recent_access::Int64
    frequency::Int64
    function CacheBlock(block_size::Int64)
        this = new()
        this.block_size = block_size
        this.isValid = false
        this.isDirty = false
        this.isAccessed = false
        this.block = fill("", block_size+1)
        this.recent_access = 0
        this.frequency = 0
        return this
    end
end

function CacheBlock_Init(block_size::Int64)
    return CacheBlock(block_size)
end

mutable struct CacheSet
    associativity::Int64
    cache_set::Array{CacheBlock,1}
    function CacheSet(associativity::Int64, block_size::Int64)
        this = new()
        this.associativity = associativity
        this.cache_set = [CacheBlock_Init(block_size) for _ in 1:associativity]
        return this
    end
end

function CacheSet_Init(associativity::Int64, block_size::Int64)
    return CacheSet(associativity, block_size)
end

mutable struct Cache
    cache_size::Int64
    block_size::Int64
    associativity::Int64
    memory::Array{CacheSet, 1}
    number_of_blocks::Int64
    number_of_sets::Int64
    offset_bits::String
    index_bits::String
    tag_bits::String
    offset_bits_length::Int64
    index_bits_length::Int64
    tag_bits_length::Int64
    function Cache()
        this = new()
        this.cache_size = 128
        this.block_size = 16
        this.associativity = 1
        this.number_of_blocks = this.cache_size / this.block_size
        this.number_of_sets = this.number_of_blocks / this.associativity
        this.memory = [CacheSet_Init(this.associativity, this.block_size) for _ in 1:this.number_of_sets]
        this.offset_bits = ""
        this.index_bits = ""
        this.tag_bits = ""
        this.offset_bits_length = Int64(ceil(log2(this.block_size)))
        this.index_bits_length = Int64(ceil(log2(this.number_of_sets)))
        this.tag_bits_length = 32 - this.offset_bits_length - this.index_bits_length
        return this
    end
end