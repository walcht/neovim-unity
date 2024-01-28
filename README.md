# Table of Content

This project is **not affiliated with Unity Technologies**.

<!--toc:start-->
- [Table of Content](#table-of-content)
  - [About](#about)
  - [Installation](#installation)
    - [Installing Dependencies](#installing-dependencies)
    - [Neovim Setup](#neovim-setup)
      - [Installing Plugin Dependencies](#installing-plugin-dependencies)
      - [Configuring Unity Editor](#configuring-unity-editor)
      - [Important Step for Proper LSP Functionalities](#important-step-for-proper-lsp-functionalities)
      - [Is Everything Working Fine?](#is-everything-working-fine)
  - [TODO](#todo)
  - [(Known) Limitations](#known-limitations)
  - [FAQ](#faq)
  - [Feedback](#feedback)
  - [License](#license)
<!--toc:end-->

## About

Ready-to-use Neovim configuration with the Unity engine. This project aims to be
both, a ready-to-use Neovim package and a guide on how to get Neovim
working with Unity.

If you already have your own Neovim configuration and want to know how to get
it working with Unity, you can easily follow this README as a guide on how to
do that.

![neovim-unity C# LSP, Trouble and Explorer image](https://user-images.githubusercontent.com/89390465/266743629-3c074ba8-7e19-4089-8b09-cae6263ffea1.png)

## Installation

This Installation guide targets **Linux distributions**. A guide on how to
properly set this for Windows(and MacOS) is yet to be provided.

This project has been tested with **Unity2020.3.XXXX LTS**. Any tests on other
Unity versions are extremely appreciated!

### Installing Dependencies

First of all make sure that you have installed **Neovim >= 0.8.0**. You can do
that by following this [guide][neovim_installation].

For C# Language Server Protocol (LSP) support,
**[Omnisharp](https://github.com/OmniSharp/omnisharp-roslyn)** is used.
Omnisharp requires **.NET SDK >= 6.0** to be globally installed. It can be
officially installed from here:

**[.NET SDK Linux installation guide](https://learn.microsoft.com/en-us/dotnet/core/install/linux)**

**NOTE**: Do not use **Omnisharp-mono** (notice the *-mono* part) on Linux
because for some reason it did not work and caused major slowdowns.

The below dependencies should be properly installed, please take a look at
the respective links for an up-to-date installation instructions.

- **[nvr][nvr_repo]**: Remotely control Neovim processes. Install using:

```bash
pip3 install neovim-remote
```

- **[wmctrl][wmctrl_installation]**: (optional) for focusing on Neovim
window instance. Install using:

```bash
sudo apt install wmctrl
```

- **[xclip][xclip_repo]**: (optional) for adding clipboard support
for Neovim on Linux distros:

```bash
sudo apt install xclip
```

### Neovim Setup

1. If you already have a Neovim configuration you can ignore the following
steps and jump to [Configuring Unity Editor](#configuring-unity-editor).
If you want to use this configuration, make sure to do a backup:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

1. Clone the repository:

```bash
git clone https://github.com/walcht/neovim-unity ~/.config/nvim
```

#### Installing Plugin Dependencies

Some plugins require external tools to be installed.

For a start, make sure the latest versions of these are installed:

1. Git
2. (optional) NPM

Type `:checkhealth` in a Neovim instance to check for missing dependencies.
Plugins with missing dependencies should be clearly identified and a simple
internet search with the dependency's name will yield the official installation
guide.

#### Configuring Unity Editor

1. In Unity, navigate to **`Edit > Preferences > External tools`**
2. In **`External Script Editor`** dropout, chose **`Browse...`**
3. Chose the the **`./script/unitynvim.sh`** shell script
4. Copy the following argument into **`External Script Editor Args`** field:

```bash
   +$(Line) $(File)
```

<details><summary>Why?</summary><br>
Usually when clicking on an error message in Unity's console, it directs
you towards the <b>file</b> and the <b>position</b> of the cause of that error.
To do that, Unity has to instantiate an editor server instance and provide it
with the file name, line and column. Now when opening another file, the same
editor server instance is used and the newly opened file will just appear
as a tab in the perviously instantiated editor server instance.
</details>

#### Important Step for Proper LSP Functionalities

For LSP to work properly *.csproj* files have to be generated from the project
files. If you enter the command `:LspInfo` after opening a .cs file from a
Unity project, you might notice that the project's directory root wasn't
detected (see image below). The project directory has to be detected for
Omnisharp to work properly (Think of across-files go-to definitions and
references or classes defined in external modules like UnityEngine, UnityEditor
etc.).

![Unity Csharp Project Directory Root not Detected](https://github.com/walcht/neovim-unity/assets/89390465/92de932c-7e6e-4110-9840-635d4bb33bdb)

Unity only allows to generate the *.csproj* files when Visual Studio, Visual
Studio Code or JetBrains Rider is selected as an external editor (i.e. the
button **`Regenerate project files`** only appears when one of these external
editors is selected and doesn't for any other custom external editor like
Neovim). **Luckily, We can trick Unity into thinking that VSCode is installed
by browsing to an empty ```code``` file (it does not have to be executable)**
(```code``` file in provided in ```scripts``` folder for convenience).

![Unity Regenerate Project Files](https://github.com/walcht/neovim-unity/assets/89390465/40edb52d-0ebf-4f2b-86b9-89f15fcb8ba5)

Furthermore, you have to make sure that Visual Studio Code Editor package is
installed (usually it is installed by default). To do so, Go to
`Window > Package Manager` and make sure it is included in `Engineering` Feature
(See picture below). If it is not there, then it needs to be installed.

![Unity VSCode Integration](https://github.com/walcht/neovim-unity/assets/89390465/235a6f2f-be80-42b2-a4d2-75f904005ae0)

This is the second biggest limitation of using Neovim as an external editor for
Unity, the first being the current absence of Unity debugging support.
We're trying to surpass these limitations using some hacks.

Unfortunately, **this process has to be done every time a new file is created**.
Not doing so will result in auto-completion not working for Unity-related Functionalities
(see the image below where auto-completion for .NET functionalities is working
while it is not for the UnityEngine module).

![New File with no UnityEngine Auto-completion](https://github.com/walcht/neovim-unity/assets/89390465/529fc3c8-87cc-466a-9562-957c499360d3)

#### Is Everything Working Fine?

Make sure to run `:checkhealth` to check if installed plugins are working properly.
If any issues are encountered then it is, most probably, related to some plugin
dependencies that are not (or not properly) installed.

## TODO

- [ ] Add debugger support for C# (CRUCIAL)
       This is a hard-to-add feature, since Unity only provides debugging support
       for a set of Editors including VSCode and Visual Studio.
- [X] Add omnisharp-roslyn language server restart keymap (CRUCIAL)
        **SPACE rl** (rl for Restart Server)
- [ ] Windows support (CRUCIAL)
- [ ] Provide a set of default keymaps as a PDF 'cheat sheet' (IMPORTANT)
- [ ] MacOS support (IMPORTANT)
- [ ] Add XML comments highlighting (OPTIONAL)
- [ ] Add GitHub pages support (OPTIONAL)
- [X] Add support for other programming languages
       Game developers aren't just tied to using C# so adding support for other
       languages is really appreciated.

## (Known) Limitations

- No Unity debugging support. Still questionable whether this could be solved.

- External editor (either Visual Studio, Visual Studio Code or JetBrains Rider)
  is needed to generate Unity project *.csproj* files which are necessary for
  proper LSP Functionalities (see previous section
  **Important Step for Proper LSP Functionalities**).

- When opening a file for the first time, Omnisharp LSP may take a while
  to start thus a bit of patience is needed.

- Omnisharp start-up may consume a lot of memory. This is a crucial issue that
we're currently working on solving.

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
[xclip_repo]: https://github.com/astrand/xclip
