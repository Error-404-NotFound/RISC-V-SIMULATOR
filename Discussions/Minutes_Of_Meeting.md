# 11-05-2024
Final Reviews and Final Commits and along with that, some Minor Bugs Resolved.

# 10-05-2024
The L1 cache is separated for each of the 2 cores. Also some more features like control flow of the simulation like implementating 2 separate L1 cache or single L1 cache are added. Along with that, starting the implementation of SIMD instruction. SIMD instructions are added in its initial phase and very basic implemetation is simulated.

# 09-05-2024
Successfully implemented the data in the cache along with the instructions. Started the initial phase of separation of L1 cache each for both the separate cores. 

# 08-05-2024
Found some bugs in the code and resolved them. Started incorporating the data in the cache along with the instructions.

# 10-04-2024
Tried for data incorporation in the cache but could not able to do so. So decided to continue with instruction in cache only. Latency for retrieving a miss block has also been handeled ie 100 clock cycles for miss in case if it retrieves from MM and 1 clock cycle for retrieving through cache.

# 09-04-2024
The two replacement poilicies:  LRU and LFU are working properly along with their respective miss and hit rates being calculated. Started Implementation of adding data into cache.

# 06-04-2024
Cache simulation working with adding of new blocks along with the proper identifiaction of sets and tag bits(Only for intructions).

# 03-04-2024
Started Implementation of Phase-3 with selection of replacement policies and some modififactions.

# 10-03-2024
Data non forwarding pipeline working succesfully, and latency also for non forwarding(mul instruction) working succesfully. Data Forwarding is inaccurate and is logically incomplete.

# 09-03-2024
Data forwarding of R and I instructions working succesfully. Branch prediction working and completed.

# 08-03-2024
Started implementation data forwarding and instructions such as load and store as well as jump for non forwarding were handled perfectly. Branch prediction initiated and was working succesfully.

# 06-03-2024
Pipelining in it's initial phases working, especially pipelining for data non forwarding case.

# 05-03-2024
Debugging of pipelining.

# 04-03-2024
Distribution in stages, i.e., IF,ID/RF, EX, MEM, WB started, pipelining was in it's initial stages.

# 03-03-2024
Started Implementation of Phase-2.

# 25-02-2024
Tried to switch on julia based libraries/frameworks such as genie but due to less documentation avaialable, it could not be implemented, aliasing of registers working and release of phase-1 complete.

# 24-02-2024
Unwanted programs removed,Dual Core working succesfully, tried to implement an GUI with different modules of python and thereby integrating julia with python programs, but libraries such as Streamlit and Dash are not compatible with PyJulia and other asm files added.

# 23-02-2024
Worked on decoding, la insruction added, Bubble Sort program working and minor bugs fixed.

# 22-02-2024
Worked upon encoding of instructions, branch, jump and thus looping working properly, negative number parsing fixed,decoding of simple instructions working, branch and jump instructions decode not working properly, so switched on just execution of opcodes rather than pipelining and minor bugs fixed.

# 21-02-2024
Parser updated , sanitization done and .data section can handle arrays.

# 20-02-2024
Parser working, .data and .text sections handled correctly, load and store instructions working properly and memory table added.

# 19-02-2024
Initial simulation of the program working along with simple instructions such add working along with File Handling.

# 18-02-2024
Finalise the idea and started working on implemen




