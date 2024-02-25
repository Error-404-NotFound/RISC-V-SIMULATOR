# RISC-V-SIMULATOR

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

* Instruction Encoding and Decoding: Decode RISC-V assembly instructions to understand their semantics and execute them accordingly.(Currently it is in operational phase for few instructions only)
* Program Execution Control: Control the execution flow of RISC-V programs, including branching, jumping, and handling interrupts.
* Register File: Emulate the register file specified in the RISC-V architecture to store and manipulate data during program execution.
* Memory Management: Manage memory access operations, including loading and storing data from/to memory.


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

_For more examples, please refer to the [Assembly_Programs](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/tree/main/Assembly_Programs)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Features Implemented

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
* [GitHub Pages](https://pages.github.com)


<p align="right">(<a href="#readme-top">back to top</a>)</p>


[output_screenshot_1]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/Phase_1_op.png
[output_screenshot_2]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/o1.png
[output_screenshot_3]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/o2.png
