# RISC-V-SIMULATOR

Team 5: Johri Aniket Manish (CS22B028) and Viramgama Jaimin Piyush (CS22B051)

> A dual-core processor simulator based on the lines of Ripes for RISC V Architecture and is able to simulate a multi-core environment also.

<a name="readme-top"></a>

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/) [![PRs welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg)](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/issues) [![code with hearth by Aniket](https://img.shields.io/badge/%3C%2F%3E%20with%20%E2%99%A5%20by-Johri_Aniket_Manish-ff1414.svg)](https://github.com/Error-404-NotFound) [![code with hearth by Jaimin](https://img.shields.io/badge/%3C%2F%3E%20with%20%E2%99%A5%20by-Virangama_Jaimin_Piyush-ff1414.svg)](https://github.com/i-apex)



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#features">Features</a></li>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#features implemented">Features Implemented</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project


RISC-V is an open standard instruction set architecture (ISA) based on established reduced instruction set computing (RISC) principles. It offers a modular and extensible architecture suitable for a wide range of applications, from embedded systems to high-performance computing.

This project focuses on implementing a simulator for the RISC-V ISA, allowing users to execute RISC-V assembly language programs and observe their behavior. The simulator provides functionalities such as instruction encoding and decoding, register file emulation, memory management, and program execution control.

### Features

#### Phase-1

* Instruction Encoding and Decoding: Decode RISC-V assembly instructions to understand their semantics and execute them accordingly.(Currently it is in operational phase for few instructions only)
* Program Execution Control: Control the execution flow of RISC-V programs, including branching, jumping, and handling interrupts.
* Register File: Simulate the register file specified in the RISC-V architecture to store and manipulate data during program execution.
* Memory Management: Manage memory access operations, including loading and storing data from/to memory.

#### Phase-2
* Distribution of stages: The program workfow has been divided into the subsequent stages, i.e., IF,ID/RF, EX, MEM, WB
* Pipelining: Pipelining of the stages for both: with and without Data Forwarding
* Banch Prediction: A Static Branch Predictor of 1-bit has been implemented for the prediction of branches.
* User Input: The user can choose from the 3 modes, wiz., Unpipelined Implementation, Pipelined with data forwarding, Pipelined without data forwarding.
* Latency of instructions: Instructions such as "mul" will have a latency of 3 in EX stage, which is handled.
* (Note): The ecall statements as well as stall count for Data Forwarding case is inaccurate, so please note it.

#### Phase-3
* Simulation of a Cache: A simple cache with predefined size, number of blocks and associativity has been implemented.
* Implementation of Replacement Policies: Replacement Policies such as LRU(Least Recently Used) and LFU(Least Frequently Used) have been implemented.
* Calculation of Misses and Hits: The corresponding Misses and Hits by the cache corresonding to the policies have been calculated.
* Incorporation of Instructions and Data: The cache is designed to handle both instructions as well as the data corresponding to all memory accesses  in the program.

#### Phase-4
* Incorporation of Data in cache: Along with instructions data part is also being  stored in the cache.
* Sepration of caches for each core: L1 cache can be seperated for each core as per user requirement.
* Integration of vector Instructions: Vector addition as per SIMD protocol is being supported.
  

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

The major tools and languages used are: 

* [<img src="https://leportella.com/assets/img/cover/julia_thumb@2x.jpg" width="100px" height="80px">](https://julialang.org/)
* [<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/RISC-V-logo.svg/2560px-RISC-V-logo.svg.png" width="200px" height="80px">](https://riscv.org/)
* [<img src="https://www.seekhogyan.com/wp-content/uploads/2023/03/1_m0H6-tUbW6grMlezlb52yw.png" width="150px" height="80px">](https://www.python.org/)
* [<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Jupyter_logo.svg/1767px-Jupyter_logo.svg.png" width="80px" height="80px">](https://jupyter.org/)



<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

To run the simulator, you have to set up the project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

To run the simulation, Julia REPL should be installed in the system.
The version of Julia used is julia version 1.10.1 working on Ubuntu 23.10

For Linux: Run the following commands in the terminal.
* Method 1:
  ```bash
  sudo snap install julia --classic
  ```
* Method 2:
  ```bash
  sudo apt-get install julia
  ```
* Method 3:
  ```bash
  curl -fsSL https://install.julialang.org | sh
  ```

  Once Julia is installed, check the version.
  ```bash
  julia --version # julia version 1.10.1
  ```

### Installation

After installing Julia, follow these steps to run the simulator.

1. Clone the repo
   ```bash
   git clone https://github.com/Error-404-NotFound/RISC-V-SIMULATOR.git
   ```
2. Go the the folder src.
   ```bash
   cd RISC-V-SIMULATOR/src/
   ```
3. Run the main.jl 
   ```bash
   julia main.jl
   ```
4. To change the file, open main.jl and change the file path as
   ```julia
   file_path1 = "../Assembly_Programs/<file_name_1>.asm"
   file_path2 = "../Assembly_Programs/<file_name_2>.asm"
   ```

You will be able to see the output of the simulation.


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Some of the examples are shown below.
(Note: All these files are available in Assembly_Programs)

### Phase-1
1. Output-1:
    - Program-1 is Bubble Sort.
    - Program-2 is Selection Sort.

[![Output-1][output_screenshot_1]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Phase_1_op.png)

2. Output-2:
    - Program-1 is find number of 1's and 0's in a number.
    - Program-2 is valentine.asm

[![Output-2][output_screenshot_2]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/o1.png)

3. Output-3:
    - Program-1 is Addition and Subtraction of 2 numbers.
    - Program-2 is empty.

[![Output-3][output_screenshot_3]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/o2.png)

4. Output-4:
    - Snippet of Registers.
  
[![Output-4][output_screenshot_4]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/1.png)

5. Output-5:
    - Snippet of Memory (.data segment of one of the program shown)
  
[![Output-5][output_screenshot_5]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/2.png)

_For more examples, please refer to the [Assembly_Programs](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/tree/main/Assembly_Programs)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Phase-2

1. Output-1:
    - Unpipelining case for Bubble Sort and Valentine code (same as implemented in Phase-1).

[![Output-6][output_screenshot_6]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/unpipelined.png)

2. Output-2:
    - Pipelining with data non-forwarding case for Bubble Sort and Valentine code.

[![Output-7][output_screenshot_7]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelining_wo_df.png)

3. Output-3:
    - Pipelining with data forwarding case for Bubble Sort and Valentine code.

[![Output-8][output_screenshot_8]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelinig_w_df.png)

4. Output-4:
    - User input to choose the type of implementation of execution of program.
  
[![Output-9][output_screenshot_9]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/UserInput.png)

### Phase-3 and Phase-4

1. Output-1:
    - Output when cache is disabled.

[![Output-10][output_screenshot_10]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelining_with_cache_disabled.png)

2. Output-2:
    - Pipelining having same L1 cache for both the cores.

[![Output-11][output_screenshot_11]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelining_having_sameL1_cache_for_both_cores.png)

3. Output-3:
    - Pipelining with different L1 caches for each core.

[![Output-12][output_screenshot_12]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelining_with_cache_diff_L1_cache_for_both_cores.png)

3. Output-4:
    - Implementationf Vector instructions.

[![Output-13][output_screenshot_13]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/SIMD_output_memory.png)

<!-- ROADMAP -->
## Features Implemented

### Phase-1

- [x] Developed using Julia language.
- [x] Supports atleast 4kB of Memory.
- [x] Very similar to RISC V Ripes Simulator.
- [x] Two Assembly files can be run, one in each core. Bubble Sort and Selection Sort on each core.
- [x] New Instruction mul added to multiply two number.
- [x] Register can be declared in both ways ie using alias or x\<register_number\>
For eg: li a0 1 or li x10 1
- [x] Output format:
      - Small segments of memory.
      (Note: To see complete memory, go to main.jl and change the range of show_memory_range() function. For example, to see the whole memory, change the range to show_memory_range(sim, 1, 1024).)
      - Output of program-1:
      - Output of program-2:
      - Contents of Registers.
- [x] Other .asm files added for reference.
- [ ] Encoding And Decoding of Instructions.
- [ ] GUI interface.
### Phase-2
- [x] Distribution into stages, i.e., IF,ID/RF, EX, MEM,WB
- [x] Pipelining of the Stages with and without Data Dorwarding
- [x] Application of Static 1-bit Branch Predictor 
### Phase-3
- [x] Supports a Cache with 64 Bytes memeory 
- [x] implementation of various replacement policies(LRU and LFU)
- [x] Supports both Instructions in cache
- [x] Latencies for retrieving a block from the memory to cache has been implemented.
- [ ] Supports Data in cache.
### Phase-4
- [x] Supports a Data in the cache
- [x] Sepration of caches for each core
- [x] Vector Instructions Support
- [ ] GUI Implementation
<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.md` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments


* [Julia Documentation](https://docs.julialang.org/en/v1/)
* [Ripes Simulator](https://ripes.me/)
* [RISC-V Manual](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf)
* [Univerity of California's RISC-V Instruction Format](https://inst.eecs.berkeley.edu/~cs61c/resources/su18_lec/Lecture7.pdf)
* [Cache Reference](https://en.wikipedia.org/wiki/Cache_(computing))
* [GitHub Pages](https://pages.github.com)


<p align="right">(<a href="#readme-top">back to top</a>)</p>


[output_screenshot_1]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Phase_1_op.png
[output_screenshot_2]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/o1.png
[output_screenshot_3]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/o2.png
[output_screenshot_4]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/1.png
[output_screenshot_5]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/2.png
[output_screenshot_6]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/unpipelined.png
[output_screenshot_7]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelining_wo_df.png
[output_screenshot_8]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelinig_w_df.png
[output_screenshot_9]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/UserInput.png
[output_screenshot_10]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelining_with_cache_disabled.png
[output_screenshot_11]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelining_having_sameL1_cache_for_both_cores.png
[output_screenshot_12]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Pipelining_with_cache_diff_L1_cache_for_both_cores.png
[output_screenshot_13]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/SIMD_output_memory.png
