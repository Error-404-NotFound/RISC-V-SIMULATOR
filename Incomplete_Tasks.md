# Incomplete Tasks

## Phase-1:
No incomplete Tasks in Phase-1.

## Phase-2:
- Decoding of instructions not working. So implemented directly taking the instructions without converting them to binary string of 32-bits. Still the implementation of encoding can be seen in the memory if the commented code is removed.
- There is some issue with Data Forwarding case. The number of stalls are not appropriate as required.
- Latency is not implemented for Data Forwarding case but working for Data Non-Forwarding case.
- The ecall instruction is not implemented for Data Forwarding case.

## Phase-3:
- Data incorporation in the cache is not been implemented. Only Instructions are being pushed in the cache.
- Cache can work only in case of Pipelining and not in case of unpipelined execution.
