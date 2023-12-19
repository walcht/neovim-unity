# About

Ready-to-use Neovim configuration with the Unity engine. This project aims to be
both, a ready-to-use Neovim package and a guide on how to get Neovim
working with Unity.

If you already have your own Neovim configuration and want to know how to get
it working with Unity, you can easily follow this README as a guide on how to
do that.

<https://user-images.githubusercontent.com/89390465/232910870-bdddddd3-bc82-4376-a8f2-c315e0293faa.webm>

## Installation

This Installation guide targets **Linux distributions**. A guide on how to
properly set this for Windows(and MacOS) is yet to be provided.

This project has been tested with **Unity2020.3.XXXX LTS**. Any tests on other
Unity versions are extremely appreciated!

### Installing Dependencies

First of all make sure that you have installed **Neovim >= 0.8.0**. You can do
that by following this [guide][neovim_installation].

The below dependencies should be properly installed, please take a look at
respective links for an up-to-date installation instructions.

1.**[nvr][nvr_repo]**: Remotely control Neovim processes. Install using:

    ```bash
    pip3 install neovim-remote
    ```

1.**[wmctrl][wmctrl_installation]**: (optional) for focusing on Neovim
window instance. Install using:

        ```bash
        sudo apt install wmctrl
        ```

### Neovim Setup

1.If you already have a Neovim configuration you can ignore the following
steps and jump to [Configuring Unity Editor](#configuring-unity-editor).
If you want to use this configuration, make sure to do a backup:

        ```bash
        mv ~/.config/nvim ~/.config/nvim.bak
        mv ~/.local/share/nvim ~/.local/share/nvim.bak
        ```

1. Clone the repository

   git clone <https://github.com/walcht/neovim-unity> ~/.config/nvim

#### Installing Plugin Dependencies

Some plugins require external tools to be installed.

For a start, make sure the latest versions of these are installed:

1. Git
1. NPM

Type `:checkhealth` in a Neovim instance to check for missing dependencies.
Plugins with missing dependencies should be clearly identified and a simple
internet search with the dependency's name will yield the official installation
guide.

#### Configuring Unity Editor

1. In Unity, navigate to **`Edit > Preferences > External tools`**
2. In **`External Script Editor`** dropout, chose **`Browse...`**
3. Chose the the **`./script/unitynvim.sh`** shell script
4. Copy the following argument into **`External Script Editor Args`** field:

   +$(Line) $(File)

<details><summary>Why?</summary><br>
Usually when clicking on an error message in Unity's console, it directs
you towards the __file__ and the __position__ of the cause of that error.
To do that, Unity has to instantiate an editor server instance and provide it
with the file name, line and column. Now when opening another file, the same
editor server instance is used and the newly opened file will just appear
as a tab in the perviously instantiated editor server instance.
</details>

#### Important Step for Proper LSP Functionalities

For LSP to work properly _.csproj_ files have to be generated from the project
files. If you enter the command `:LspInfo` after opening a .cs file from a
Unity project, you might notice that the project's directory root wasn't
detected (see image below). The project directory has to be detected for
Omnisharp to work properly (Think of across-files go-to definitions and
references or classes defined in external modules like UnityEngine, UnityEditor
etc...).

![Unity Csharp Project Directory Root not Detected](https://private-user-images.githubusercontent.com/89390465/291637073-92de932c-7e6e-4110-9840-635d4bb33bdb.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTEiLCJleHAiOjE3MDMwMDE4MzAsIm5iZiI6MTcwMzAwMTUzMCwicGF0aCI6Ii84OTM5MDQ2NS8yOTE2MzcwNzMtOTJkZTkzMmMtN2U2ZS00MTEwLTk4NDAtNjM1ZDRiYjMzYmRiLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFJV05KWUFYNENTVkVINTNBJTJGMjAyMzEyMTklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjMxMjE5VDE1NTg1MFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWNiYWM2ZWIzOTA4OWI5NjMwZmU2ODM3ZjdkZDJmN2M1OGI1MWRmYjhhODA5YzYzMTBlMzM0MmIwYWQ5YjJjOTAmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.AbaXsEZmBl5eO1r_-O8WIrEHqyczbIslZvYGPb6KkxY)

Unity only allows to generate the _.csproj_ files when Visual Studio, Visual
Studio Code or JetBrains Rider is selected as an external editor (i.e. the
button **`Regenerate project files`** only appears when one of these external
editors is selected and doesn't for any other custom external editor like
Neovim). Moreover, the associated external editor has to be installed for that
option to show. That is, to properly use Neovim as an external editor you have
to install VSCode (or Visual Studio or JetBrains Rider) for proper LSP support.

![Unity Regenerate Project Files](https://private-user-images.githubusercontent.com/89390465/291628827-0a473a5f-f6f8-467f-832c-5cbf1588c692.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTEiLCJleHAiOjE3MDMwMDE4MzAsIm5iZiI6MTcwMzAwMTUzMCwicGF0aCI6Ii84OTM5MDQ2NS8yOTE2Mjg4MjctMGE0NzNhNWYtZjZmOC00NjdmLTgzMmMtNWNiZjE1ODhjNjkyLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFJV05KWUFYNENTVkVINTNBJTJGMjAyMzEyMTklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjMxMjE5VDE1NTg1MFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTRmMWJlMTQxODVjMTk3ZTgxZGJmNmJkNTE1NTg4YWFiMzI5MzdkYTFlMmEyYzg2MWZhMTAxMDFmNDE1Njc2NzcmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.3MxkRIg00cHtq5-jcbd6kIdEy3GgE12nbNf4c-BbWs0)

Furthermore, for the option of the chosen editor from the supported external
editors to show, you have to make sure that its integration package is
installed. To do so, Go to `Window > Package Manager` and make sure it is
included in `Engineering` Feature (See picture below). If it is not there, then
it needs to be installed.

![Unity VSCode Integration](https://private-user-images.githubusercontent.com/89390465/291627920-235a6f2f-be80-42b2-a4d2-75f904005ae0.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTEiLCJleHAiOjE3MDMwMDE4MzAsIm5iZiI6MTcwMzAwMTUzMCwicGF0aCI6Ii84OTM5MDQ2NS8yOTE2Mjc5MjAtMjM1YTZmMmYtYmU4MC00MmIyLWE0ZDItNzVmOTA0MDA1YWUwLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFJV05KWUFYNENTVkVINTNBJTJGMjAyMzEyMTklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjMxMjE5VDE1NTg1MFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWM4NzcwMzQ4MzQ1NTcwZGQ4NTc2NzFlYjZkNmQ0ZmVlOWFmYmZlMTM3ZjI0OGQzMTc2ZTlkMDNkNDEyYzE2ZTQmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.tl-ctOq3DSkFBSY81dfVwNZ-bOScBVD05Z359IZcCdE)

This is the second biggest limitation of using Neovim as an external editor for
Unity, the first being the current absence of Unity debugging support.
We're trying to surpass these limitations using some hacks.

Fortunately, **this process has to be done only once per Unity Project**. To the
best of our knowledge, there is no need to regenerate project _.csproj_ files
after the creation\addition of a new Csharp script.

#### Is Everything Working Fine?

Make sure to run `:checkhealth` to check if installed plugins are working properly.
If any issues are encountered then it is, most probably, related to some plugin
dependencies that are not (or not properly) installed.

## TODO

1. [ ] Add debugger support for C# (CRUCIAL)
       This is a hard-to-add feature, since Unity only provides debugging support
       for a set of Editors including VSCode and Visual Studio.
1. [ ] Add omnisharp-roslyn language server restart keymap (CRUCIAL)
1. [ ] Windows support (CRUCIAL)
1. [ ] Provide a set of default keymaps as a PDF 'cheat sheet' (IMPORTANT)
1. [ ] MacOS support (IMPORTANT)
1. [ ] Add XML comments highlighting (OPTIONAL)
1. [ ] Add GitHub pages support (OPTIONAL)
1. [ ] Add support for other programming languages

## (Known) Limitations

- No Unity debugging support. Still questionable whether this could be solved.

- External editor (either Visual Studio, Visual Studio Code or JetBrains Rider)
  is needed to generate Unity project _.csproj_ files which are necessary for
  proper LSP Functionalities (see previous section
  **Important Step for Proper LSP Functionalities**).

- When opening a file for the first time, Omnisharp LSP may take a while
  to start thus a bit of patience is needed.

## FAQ

- Q. Why not use csharp-ls?
- A. Serious problems on Ubuntu 22.04 (failures to detect .NET framework 4.7.X
  assemblies, metadata warnings, etc...).

      ---

- Q. Why the headache? Why not just use Visual Studio?
- A. Some people find a great joy in using Neovim. Some other people use it for
  all their programming tasks thus it would be inefficient for them to transition
  to Visual Studio or VSCode just for Unity programming.

      ---

- Q. Why when opening a .cs script, nvim opens multiple empty buffers?
- A. **Make sure that the name of your Unity project does not contain any white
  spaces**.

      ---

- Q. Syntax highlighting doesn't seem to work. What should I do?
- A. When opening Neovim for the first time, for some reason Treesitter does
  not work (will be fixed). Just open another script and it should work.

      ---

- Q. Why does LSP take so long to provide completion at the start of Neovim?
- A. That's Omnisharp reading your whole project for proper LSP setup. A little
  bit of patience at the start is needed.

      ---

- Q. LSP stopped working, help!
- A. Restart Omnisharp by entering `:LspRestart omnisharp` (a restart keymap
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
[wmctrl_installation]: https://linux.die.net/man/1/wmctrl
