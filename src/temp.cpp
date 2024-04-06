#include <iostream>
#include <vector>
#include <cmath>
#include <cassert>
#include<cstdint>

struct CacheBlock {
  uint64_t tag;
  // ideally I should have allocated 64bytes of memory data[]
  bool valid;
};

class CacheSimulator {
  private:
    std::vector<CacheBlock> cache;
    unsigned int cacheSize;
    unsigned int blockSize;
    unsigned int numBlocks;

    std::pair<uint64_t, uint64_t> splitAddress(uint64_t address) 
    {
      // variable address if for byte
      int num_bits_offset = std::log2(blockSize);
      address = address >> num_bits_offset;
      uint64_t index = address & ((1 << numBlocks) - 1);
      uint64_t tag = address >> std::log2(numBlocks);
      return std::make_pair(tag, index);
    }

  public:
    CacheSimulator(unsigned int _cacheSize, unsigned int _blockSize)
      : cacheSize(_cacheSize), blockSize(_blockSize) {
        
        assert (cacheSize % blockSize == 0);
        numBlocks = cacheSize / blockSize;
        cache.resize(numBlocks);
        for (auto b : cache) {
          b.valid = false;
        }
      }

    bool access (uint64_t address) {
      // split the address: |---------tag --------------| --index---| --offset---|
      auto a = splitAddress(address);
      uint64_t index = a.second;
      uint64_t tag = a.first;

      if (cache[index].tag == tag && cache[index].valid == true) {
        return true;
      }
      else {
        cache[index].tag = tag;
        cache[index].valid = true;
        return false;
      }
    }
};

int main()
{
  CacheSimulator sim(32678, 64);
  uint64_t accesses = 0;
  uint64_t hits = 0;
  uint64_t addresses[] = {1024, 32, 0, 2048};
  for (uint64_t add : addresses) {
    bool hit = sim.access(add);
    std::cout << "address: " << add << " is a " << hit << std::endl;
    if (hit) hits++;
    accesses++;
  }

  double hit_rate = (double)hits / accesses;
  return 0;
}