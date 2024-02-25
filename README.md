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
    <li><a href="#features">Features</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

There are many great README templates available on GitHub; however, I didn't find one that really suited my needs so I created this enhanced one. I want to create a README template so amazing that it'll be the last one you ever need -- I think this is it.

Here's why:
* Your time should be focused on creating something amazing. A project that solves a problem and helps others
* You shouldn't be doing the same tasks over and over like creating a README from scratch
* You should implement DRY principles to the rest of your life :smile:

Of course, no one template will serve all projects since your needs may be different. So I'll be adding more in the near future. You may also suggest changes by forking this repo and creating a pull request or opening an issue. Thanks to all the people have contributed to expanding this template!

Use the `BLANK_README.md` to get started.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

This section should list any major frameworks/libraries used to bootstrap your project. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.

* [![Next][Next.js]][Next-url]
* [![React][React.js]][React-url]
* [![Vue][Vue.js]][Vue-url]
* [![Angular][Angular.io]][Angular-url]
* [![Svelte][Svelte.dev]][Svelte-url]
* [![Laravel][Laravel.com]][Laravel-url]
* [![Bootstrap][Bootstrap.com]][Bootstrap-url]
* [![JQuery][JQuery.com]][JQuery-url]

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

* Output-1:
Program-1 is find number of 1's and 0's in a number.
Program-2 is valentine.asm

[![Output-1][output_screenshot_1]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/o1.png)

* Output-2:
Program-1 is Addition and Subtraction of 2 numbers.
Program-2 is empty.

[![Output-2][output_screenshot_2]](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/o2.png)

_For more examples, please refer to the [Assembly_Programs](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/tree/main/Assembly_Programs)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Features

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

See the [project report (Phase 1)](https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/issues) for a full list of proposed features (and known issues).

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
* [RISC-V Manual](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf)
* [Univerity of California's RISC-V Instruction Format](https://inst.eecs.berkeley.edu/~cs61c/resources/su18_lec/Lecture7.pdf)
* [GitHub Pages](https://pages.github.com)


<p align="right">(<a href="#readme-top">back to top</a>)</p>



[output_screenshot_1]: https://github.com/Error-404-NotFound/RISC-V-SIMULATOR/blob/main/Assets/o1.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 