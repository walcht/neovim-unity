# About

Ready-to-use Neovim configuration with the Unity engine. This intends to be
both, a ready-to-use Neovim package and a guide on how to get Neovim
working with Unity.

If you already have your own Neovim configuration and want to know how to get
it working with Unity, you can easily follow this README as a guide on how to
do that.

<https://user-images.githubusercontent.com/89390465/232910870-bdddddd3-bc82-4376-a8f2-c315e0293faa.webm>

## Installation

This Installation guide targets __Linux distributions__. A guide on how to
properly set this for Windows(and MacOS) is yet to be provided.

This project has been tested with __Unity2020.3.XXXX LTS__. Everything seems
to be working perfectly fine. Any tests on other Unity versions are extremely
appreciated!

### Installing Dependencies

First of all make sure that you have installed __Neovim >= 0.8.0__. You can do
that by following this [guide][neovim_installation].

The below dependencies should be properly installed, please take a look at
respective links for up-to-date installation instructions.

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

Some plugins require external tools to be installed. The following table
associates each plugin with its dependencies.

You can install these dependencies one-by-one or you can execute
the ```./scripts/plugin_dependencies.sh``` script.

| Plugin            | Dependencies(s)                   |
|-------------------|-----------------------------------|
|||

#### Configuring Unity Editor

1. In Unity, navigate to __```Edit > Preferences > External tools```__
2. In __```External Script Editor```__ dropout, chose __```Browse...```__
3. Chose the the __```./script/unitynvim.sh```__ shell script
4. Copy the following argument into __```External Script Editor Args```__ field:

    ```bash
    +$(Line) $(File)
    ```

<details><summary>Why?</summary><br>
Usually when clicking on a an error message in Unity console, it directs
you towards the <b>file</b> and the <b>position</b> of the cause of that error.
To do that, Unity has to instantiate an editor server instance, provide it
with file name, line and column. Now when opening another file, the same
editor server instance is used and the newly opened file will just appear
as a tab in the perviously instantiated editor server instance.
</details>

#### Is Everything Working Fine?

Make sure to run ```:checkhealth``` to check if plugins are working properly.
If any issues are encountered then it most probably is related to some plugin
dependencies that are not\not properly installed.

## TODO

1. Add debugger support (CRUCIAL!)
1. Add omnisharp-roslyn language server restart keymap (CRUCIAL!)
1. Provide a set of default keymaps as a PDF 'cheat sheet' (IMPORTANT)
1. Windows support (IMPORTANT)
1. MacOS support (IMPORTANT)
1. Improve this README file (IMPORTANT)
1. Add XML comments highlighting (OPTIONAL)
1. Add GitHub pages support (OPTIONAL)

## (Known) Limitations

+ Omnisharp language server may take a while to start. Thus a bit of patience
opening a file for the first time is needed.
+ Development environment won't be as rich as on Visual Studio (in terms of
features provided). But you get a much more consistent development environment
if you do a lot of programming outside gamedev.

## FAQ

+ Q. Why not use csharp-ls?
+ A. I have tried. I have really tried, but the amount of problems that I got
was simply not worth it (failures to detect .NET framework 4.7.X assemblies,
metadata warnings, etc...).

    ---

+ Q. Why the headache? Why not just use Visual Studio?
+ A. I do a lot of programming outside Unity and I'm used to using Neovim
for all my programming tasks. Thus it is much easier for me to stick to Neovim.
And you get to learn tons of new stuff when no one is holding your hand like a
baby ;)

    ---

+ Q. Why when opening a .cs script, nvim opens multiple empty buffers?
+ A. __Make sure that the name of your Unity project does not contain any white
spaces__.

    ---

+ Q. Syntax highlighting doesn't seem to work. What should I do?
+ A. When Neovim for the first time, for some reason Treesitter does
not work (will be fixed). Just open another script and it should work.

    ---

+ Q. Why does LSP take so long to provided completion at the start of Neovim?
+ A. That's Omnisharp reading your whole project for proper LSP setup. A little
bit of patience is needed.

    ---

+ Q. LSP stopped working, help!
+ A. Restart Omnisharp by entering ```:LspRestart omnisharp``` (a restart keymap
will be added)

## Feedback

This project was done by an inexperienced Neovim user. If anything can be
enhanced then please open a PR (I really do appreciate it)!
I really enjoy using Neovim and I find it a bit sad that there are no
properly updated guides on how to set it up with Unity development
environment.

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
See LICENSE.txt file for more info.

[neovim_installation]: https://github.com/neovim/neovim/tags
[nvr_repo]: https://github.com/mhinz/neovim-remote
[mono_installation]: https://www.mono-project.com/download/stable/
[wmctrl_installation]: https://linux.die.net/man/1/wmctrl
