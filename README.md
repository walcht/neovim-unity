# About

Ready-to-use Neovim configuration with the Unity engine. This project aims to be
both, a ready-to-use Neovim package and a guide on how to get Neovim
working with Unity.

If you already have your own Neovim configuration and want to know how to get
it working with Unity, you can easily follow this README as a guide on how to
do that.

<https://user-images.githubusercontent.com/89390465/232910870-bdddddd3-bc82-4376-a8f2-c315e0293faa.webm>

## Installation

This Installation guide targets __Linux distributions__. A guide on how to
properly set this for Windows(and MacOS) is yet to be provided.

This project has been tested with __Unity2020.3.XXXX LTS__. Any tests on other
Unity versions are extremely appreciated!

### Installing Dependencies

First of all make sure that you have installed __Neovim >= 0.8.0__. You can do
that by following this [guide][neovim_installation].

The below dependencies should be properly installed, please take a look at
respective links for an up-to-date installation instructions.

1. __[nvr][nvr_repo]__: Remotely control Neovim processes. Install using:

    ```bash
    pip3 install neovim-remote
    ```

1. __[mono][mono_installation]__: Essential for omnisharp-mono.
Check __[official installation guide][mono_installation]__.

1. __[wmctrl][wmctrl_installation]__: (optional) for focusing on Neovim
window instance. Install using:

    ```bash
    sudo apt install wmctrl
    ```

### Neovim Setup

1. If you already have a Neovim configuration you can ignore the following
steps and jump to [Configuring Unity Editor](#configuring-unity-editor).
If you want to use this configuration, make sure to do a backup:

    ```bash
    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    ```

1. Clone the repository

    ```bash
    git clone https://github.com/walcht/neovim-unity ~/.config/nvim
    ```

#### Installing Plugin Dependencies

Some plugins require external tools to be installed.

For a start, make sure the latest versions of these are installed:

1. Git
1. npm

Type ```:checkhealth``` in a Neovim instance to check for missing dependencies.
Plugins with missing dependencies should be clearly identified and a simple
internet search with the dependency's name will yield the official installation
guide.

#### Configuring Unity Editor

1. In Unity, navigate to __```Edit > Preferences > External tools```__
2. In __```External Script Editor```__ dropout, chose __```Browse...```__
3. Chose the the __```./script/unitynvim.sh```__ shell script
4. Copy the following argument into __```External Script Editor Args```__ field:

    ```bash
    +$(Line) $(File)
    ```

<details><summary>Why?</summary><br>
Usually when clicking on an error message in Unity's console, it directs
you towards the __file__ and the __position__ of the cause of that error.
To do that, Unity has to instantiate an editor server instance and provide it
with the file name, line and column. Now when opening another file, the same
editor server instance is used and the newly opened file will just appear
as a tab in the perviously instantiated editor server instance.
</details>

#### Is Everything Working Fine?

Make sure to run ```:checkhealth``` to check if installed plugins are working properly.
If any issues are encountered then it is, most probably, related to some plugin
dependencies that are not (or not properly) installed.

## TODO

1. [] Add debugger support for C# (CRUCIAL)
1. [] Add omnisharp-roslyn language server restart keymap (CRUCIAL)
1. [] Windows support (CRUCIAL)
1. [] Provide a set of default keymaps as a PDF 'cheat sheet' (IMPORTANT)
1. [] MacOS support (IMPORTANT)
1. [] Add XML comments highlighting (OPTIONAL)
1. [] Add GitHub pages support (OPTIONAL)
1. [] Add support for other programming languages

## (Known) Limitations

+ When opening a file for the first, Omnisharp language server may take a while
to start thus a bit of patience is needed.

## FAQ

+ Q. Why not use csharp-ls?
+ A. Serious problems on Ubuntu 22.04 (failures to detect .NET framework 4.7.X
assemblies, metadata warnings, etc...).

    ---

+ Q. Why the headache? Why not just use Visual Studio?
+ A. Some people find a great joy in using Neovim. Some other people use it for
all their programming tasks thus it would be inefficient for them to transition
to Visual Studio or VSCode just for Unity programming.

    ---

+ Q. Why when opening a .cs script, nvim opens multiple empty buffers?
+ A. __Make sure that the name of your Unity project does not contain any white
spaces__.

    ---

+ Q. Syntax highlighting doesn't seem to work. What should I do?
+ A. When opening Neovim for the first time, for some reason Treesitter does
not work (will be fixed). Just open another script and it should work.

    ---

+ Q. Why does LSP take so long to provide completion at the start of Neovim?
+ A. That's Omnisharp reading your whole project for proper LSP setup. A little
bit of patience at the start is needed.

    ---

+ Q. LSP stopped working, help!
+ A. Restart Omnisharp by entering ```:LspRestart omnisharp``` (a restart keymap
will be added)

## Feedback

I really enjoy using Neovim and I find it a bit sad that there are no
properly updated guides on how to set it up with Unity for a proper, fast
and efficient development environment.

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
See LICENSE.txt file for more info.

[neovim_installation]: https://github.com/neovim/neovim/tags
[nvr_repo]: https://github.com/mhinz/neovim-remote
[mono_installation]: https://www.mono-project.com/download/stable/
[wmctrl_installation]: https://linux.die.net/man/1/wmctrl
