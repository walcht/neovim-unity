# About

Ready-to-use Neovim configuration with the Unity engine. This intends to be
both, a ready-to-use Neovim package and a guide on how to get Neovim
working with Unity.

If you already have your own Neovim configuration and want to know how to get
it working with Unity, you can easily follow this README as a guide on how to
do that.

https://user-images.githubusercontent.com/89390465/232910870-bdddddd3-bc82-4376-a8f2-c315e0293faa.webm

## Installation

This Installation guide targets __Linux distributions__. A guide on how to
properly set this for Windows(and MacOS) is yet to be provided.

### Installing Dependencies

The below dependencies should be properly installed, please take a look at
respective links for up-to-date installation instructions.

1. __[nvr][nvr_repo]__: Remotely control Neovim processes. Install using:

    ```bash
    pip3 install neovim-remote
    ```

2. __[mono][mono_installation]__: Essential for omnisharp-mono.
Check __[official installation guide][mono_installation]__.

3. __[wmctrl][wmctrl_installation]__: (optional) for focusing on Neovim
window instance. Install using:

    ```bash
    sudo apt install wmctrl
    ```

### Neovim Setup

1. If you already have a Neovim configuration you can ignore the following
steps and jump to [Configuring Unity Editor][#configuring_unity_edito].
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
3. Chose the the __```./script/neovim_unity.sh```__ shell script
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
as a tab in the editor.
</details>

#### Is Everything Working Fine?

Make sure to run ```:checkhealth``` to check if plugins are working properly.
If any issues are encountered then it most probably is related to some plugin
dependencies that are not\not properly installed.

## Usage

## Demos

## TODO

1. Improve nvim-tree
    + change root directory through rec search for scripts, assets, etc...
    + ignore .meta files (and other unnecessary files)
1. Focuse on Neovim terminal window after opening a file in Unity
1. Provide a set of default keymaps as a PDF 'cheat sheet' (please remember
that this assumes users with 0 Neovim experience thus we want a fast 
get-to-work approach)
1. Add omnisharp-roslyn language server restart keymap (believe me, this is crucial)
1. Add XML comments highlighting
1. Add debugger support
1. Windows support (IMPORTANT!)
1. MacOS support
1. Improve this README file
1. Add GitHub pages support

## (Known) Limitations
- Omnisharp language server may take a while to start. Thus a bit of patience
opening a file for the first time is needed.
- Saving an edited file won't automatically trigger Unity to recompile project
files. You should do that manually (Project window > right click > Refresh)
- When opening a file, the Neovim window won't be focused on automatically.
- Development environment won't be as rich as on Visual Studio (in terms of
features provided).

## FAQ

- Q. Why not use csharp-ls?
- A. I have tried. I have really tried, but the amount of problems that I got 
was simply not worth it (failures to detect .NET framework 4.7.X assemblies,
metadata warnings, etc...).

    ---

- Q. Why the headache? Why not just use Visual Studio?
- A. I do a lot of programming outside Unity and I'm used to using Neovim
for all my programming tasks. Thus it is much easier for me to stick to Neovim.

    ---

## Feedback

This project was done by a very inexperienced Neovim user. If anything can be
enhanced then please open a PR!
I really enjoy using Neovim and I find it a bit sad that there are no
properly updated guides on how to set it up with Unity development
environment.

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
See LICENSE.txt file for more info.

[nvr_repo]: https://github.com/mhinz/neovim-remote
[dotnet_installation]: https://github.com/dotnet/core/blob/main/linux.md
[mono_installation]: https://www.mono-project.com/download/stable/
[csharpls_installation]: https://github.com/razzmatazz/csharp-language-server
[lsp]: https://microsoft.github.io/language-server-protocol/
[metadata_issue]: https://github.com/dotnet/format/issues/56
[wmctrl_installation]: https://linux.die.net/man/1/wmctrl
