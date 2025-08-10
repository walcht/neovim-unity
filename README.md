# About

> [!NOTE]
> This project is **not affiliated with Unity Technologies**.

![Showcase of Unity Neovim IDE-like editor with LSP support and diagnostics][showcase_0]

Debugging is also supported:

![Showcase of Unity Neovim IDE-like editor's debugging support][showcase_1]

Ready-to-use Neovim configuration with the Unity engine. This repository is 
a single README file that provides instructions on how to setup Neovim for
Unity game engine development tasks. This project aims to provide both, a
ready-to-use Neovim package and a guide on how to get Neovim
working with Unity all while relying on permissive licenses for thirdy party
tools/plugins providers (i.e., no Microsoft licenses that forces telemetry)

If you already have your own Neovim configuration and want to know how to get
it working with Unity, you can easily follow this README as a guide on how to
do that.

## Target Readers/Users

It is assumed that readers of this guide have a basic knowledge of IDE concepts,
Neovim, and Lua (and to very little extent C#). In case the reader is new to
concepts like LSP (language server protocol) and DAP (debug adapter protocol),
there are collapsed sections under the name `New to X?` describing the concepts
very briefly but clearly enough to get started with incorporating them into your
Neovim configuration.

## Installation

This Installation guide targets **Linux distributions**. A guide on how to
properly set this for Windows(and MacOS) is yet to be provided.

This project has been tested with **Unity6000.1 LTS**. Any tests on other
Unity versions are extremely appreciated!

### Neovim Setup

First of all make sure that you have installed **Neovim >= 0.11**. You can do
that by following this [guide][neovim_installation].

1. If you already have a Neovim configuration, you can ignore the following
steps and jump to [Installing Dependencies](#installing-dependencies). It is
best however to take a look into how the C# LSP and Unity debugging are
configured in [**CGNvim**][cgnvim] to avoid annoying pitfalls.

If you want to use the configuration proposed by this project, make sure to do
a backup of your own configuration (assuming you have one):

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

1. Then clone the [**CGNvim**][cgnvim] repository (Neovim configuration for general
purpose computer graphics development):

```bash
git clone https://github.com/walcht/CGNvim.git ~/.config/nvim
```

### Installing Dependencies

For C# Language Server Protocol (LSP) support, you have to:

1. globally install **.NET SDK >= 9.0**. It can be installed from the following
official source:
**[.NET SDK installation guide][dotnet_sdk_installation_guide]**

1. download the Roslyn Language Server as a NuGet package from:
    1. on Linux: [Roslyn LS Linux][roslyn_lsp_linux]
    1. on Windows: [Roslyn LS Windows][roslyn_lsp_windows]
    1. on MacOS: [Roslyn LS MacOS][roslyn_lsp_macos]

2. extract it (NugGets are ZIP archives) at some location of your choice
(that we hereafter refer to as **<roslyn_ls_path>**):

3. open the Roslyn LSP configuration file (or your custom Neovim's Roslyn LS
configuration file) using some text editor:

```bash
nvim ~/.config/nvim/lua/cgnvim/lsps/roslyn_ls.lua
```

and change the `cmd` path to where you extracted/installed the Roslyn LSP:

```lua
  cmd = {
    'dotnet',
    '<roslyn_ls_path>/Microsoft.CodeAnalysis.LanguageServer.dll',
    '--logLevel', -- this property is required by the server
    'Information',
    '--extensionLogDirectory', -- this property is required by the server
    fs.joinpath(uv.os_tmpdir(), 'roslyn_ls/logs'),
    '--stdio',  -- adjust accordingly in case you want to communicate with the
                -- LSP via TCP
  },
```

where `<roslyn_ls_path>` has to be the folder you extracted the Roslyn LSP NuGet
package to.

Note: you might have heard of Omnisharp as another C# LSP, **avoid using it** as
it is being(?) discontinued and has major memory leakage issues.

#### Configuring Unity Editor

Roslyn LSP (and all(?) other C# LSPs) works by analyzing the generated solution
(.sln) and .csproj files from the provided C# project(s)/solution(s). These
project files have to be initially generated then updated whenever a C# script
is updated or a new C# script is created.

Essentially, some Unity plugin has to automatically handle this. The same plugin
should also be able to instantiate a Neovim instance (in case one is not already
instantiated) and communicate with it (e.g., when clicking on a Unity Console
Log error, the plugin has to open the corresponding file at the appropriate
location).

This is exactly how Visual Studio (also VSCode and Rider) is integrated for
Unity development tasks. The plugin in this case is installed by default (check
Package Manager for the officially supported **Visual Studio Editor** plugin).

In the case of Neovim, the custom plugin **com.walcht.ide.neovim** has to be
installed for proper Neovim support. In the Unity Editor, in the top menu bar
navigate to:

Window -> Package Management -> Package Manager
-> navigate to plus sign on top left -> Install package from git URL...

then enter:
```
https://github.com/walcht/com.walcht.ide.neovim.git
```
and click on install.

Now when navigating to: `Edit -> Preferences -> External Tools` you should
see `Neovim` in the drop down options.

To automatically open Neovim when clicking on files/console warnings or errors,
navigate to:

`Edit -> Preferences -> External Tools` then Set "External Script Editor" to
Neovim.

Adjust which packages to generate the .csproj files for (you will only get LSP
functionalities for those selected packages and you might - not verified - get
worse performance the more the selected):

![Unity's external tools menu][com_walcht_ide_neovim]

Now try to open a C# script from you project and keep an eye on the
notifications that might pop-up.

#### Optional Dependencies

The below dependencies can be installed for a better development experience,
please take a look at the respective links for an up-to-date installation
instructions.

- **[wmctrl][wmctrl_installation]**: (optional) for focusing on Neovim
window instance on Linux. On Debian-based distros, install using:

```bash
sudo apt-get install wmctrl
```

- **[xclip][xclip_repo]**: (optional) for adding clipboard support
for Neovim on Linux. On Debian-based distros, install using:

```bash
sudo apt-get install xclip
```

#### Installing Plugin Dependencies

Some plugins require external tools to be installed.

For a start, make sure the latest versions of these are installed:

1. Git
2. (optional) NPM
3. (optional) Python >= 3.9

Type `:checkhealth` in a Neovim instance to check for missing dependencies.
Plugins with missing dependencies should be clearly identified and a simple
internet search with the dependency's name will yield the official installation
guide.

#### Important Step for Proper LSP Functionalities

For LSP to work properly *.csproj* files have to be generated from the project
files. If you enter the command `:LspInfo` after opening a .cs file from a
Unity project, you might notice that the project's directory root wasn't
detected (see image below). The project directory has to be detected for
Omnisharp to work properly (Think of across-files go-to definitions and
references or classes defined in external modules like UnityEngine, UnityEditor
etc.).

#### Is Everything Working Fine?

Getting a C# LSP (in this case Roslyn LS) to work properly for a Unity project
can be frustrating.

To debug LSP issues, make sure that the C# LSP is active by entering the command
`:LspInfo` and checking the output. Do also check the LSP logs using the command
`:LspLog` (important to note that a lot of LSP *errors* and *warnings* can be
safely ignored).

Make sure to run `:checkhealth` to check if installed plugins are working
properly. If any issues are encountered then it is, most probably, related to
some plugin dependencies that are not (or not properly) installed.

## Unity Debugger Support

<details>
<summary>New to the concept of Debug Adapter Protocols (DAP)?</summary>

### Debug Adapter Protocols

TODO

</details>

The Mono debug adapter for Unity [VSCode Unity Debug][depracated_unity_debug]
is no longer supported and is deprecated, therefore a fork of the project is
created at [Unity-DAP][unity_dap] to provide an up-to-date debug adapter for Unity
(without any VSCode dependencies).


To add debugging support for Unity, you have to:

1. install [**Mono**][mono]

2. install the [Unity debug adapter][unity_dap] by cloning the repo and building it from source:

     ```bash
     git clone https://github.com/walcht/unity-dap.git
     cd unity-dap
     dotnet build unity-debug-adapter/unity-debug-adapter.csproj --configuration=Release
     ```

3. Assuming you are using the [CGNvim][cgnvim] Neovim configuration, navigate
to `~/.config/nvim/lua/cgnvim/daps/unity.lua` and change the `unity-debug-adapter.exe`
path (also optionally change `mono` path in case it is not in PATH):

     ```lua
     -- adjust mono path - do not use Unity's integrated MonoBleedingEdge
     command = "mono",
     -- adjust unity-debug-adapter.exe path
     args = {
       "<path-to-unity-debug-adapter.exe>",
       "--log-level=none",  -- optional log level argument: tace | debug | info | warn | error | critical | none
       -- "--log-file=<path-to-log-file>",  -- optional path to log file (logs to stderr in case this is not provided)
     },
     ```

 4. If you are debugging a Unity editor instance, make sure Unity is set to `Mode: Debug`
 and if you are debugging a Unity player instance, then make sure that it is debuggable
 (check the settings on how to do that).

 5. Open a C# script, set some breakpoints and continue (<F5> key or by `:DapContinue`)

 4. The Unity DAP connects to the Unity Mono debugger via a TCP socket, therefore
 you have to provide an IP address and a port. On Linux, you can figure the debugging
 port of a Unity editor instance by checking the output of:

     ```bash
     ss -tlp | grep 'Unity'
     ```

     which yields an output like this:

     ```
     LISTEN 0      16         127.0.0.1:56365       0.0.0.0:*    users:(("UnityShaderComp",pid=306581,fd=128),("Unity",pid=306365,fd=128))
     LISTEN 0      16         127.0.0.1:56451       0.0.0.0:*    users:(("UnityShaderComp",pid=322591,fd=47),("Unity",pid=322451,fd=47))  
     LISTEN 0      16         127.0.0.1:56457       0.0.0.0:*    users:(("UnityShaderComp",pid=322609,fd=47),("Unity",pid=322457,fd=47))
     ```

     the debugging IP is 127.0.0.1 and the port is 56365.
     (ideally the list of endpoints to connect to should be listed automatically - will be implemented in the near future)

 In case you are not using the CGNvim Neovim configuration,
 just copy its [DAP configuration for Unity][cgnvim_unity_dap]
 and adapt it to your configuration.

> [!NOTE]
> [Unity-DAP][unity_dap] only supports debugging applications built using the scripting backend `Mono`
> (i.e., IL2CPP debugging is not supported). Read the caution below in case debugging
> IL2CPP-built applications is a necessity for you.

Alternatively, if you want to bebug IL2CPP-built apps then the new official extension
for VSCode, albeit closed-source, provides a `UnityDebugAdapter.dll` and a `UnityAttachProbe.dll`
which \**can be used* to list multiple instances with which the DAP client could be attached.

> [!CAUTION]
> You will be in breach of the license terms for the extension if you use it for
Neovim development. To quote the [license terms][stupid_license]:
>
> > (a) Use with In-Scope Products and Services. You may install and use the
> > Software only with Microsoft Visual Studio Code, vscode.dev, GitHub
> > Codespaces (“Codespaces”) from GitHub, Inc. (“GitHub”), and successor
> > Microsoft, GitHub, and other Microsoft affiliates’ products and services
> > (collectively, the “In-Scope Products and Services”).

For this reason, I started a project to provide an up-to-date debug
adapter under an MIT license.

## TODO

- [ ] Windows support (CRUCIAL)
- [ ] Provide a set of default keymaps as a PDF 'cheat sheet' (IMPORTANT)
- [ ] MacOS support (IMPORTANT)
- [ ] Add XML comments highlighting (OPTIONAL)
- [ ] Add GitHub pages support (OPTIONAL)

## FAQ

- Q. Why not use omnisharp or csharp-ls?
- A. Roslyn LS is the *new* officially suporrted LSP for C#. Omnisharp is not
  well maintained, can be exteremely slow and unresponsive, and has a potential
  memory leak issue. CSharp-LS on the other hand is a hacky LSP (as per the
  description in its repository) and is not officially supported.

---

- Q. Why the headache? Why not just use Visual Studio/VSCode?
- A. Some people find great joy in using Neovim. Some other people use it for
  all their programming tasks thus it would be inefficient for them to
  transition to Visual Studio or VSCode just for Unity programming. Also,
  Neovim consumes less resources and you get more control into how much
  you want it to act as an IDE.

---

- Q. Why when opening a .cs script, nvim opens multiple empty buffers?
- A. **Make sure that the name of your Unity project does not contain any white
  spaces**.

---

- Q. Syntax highlighting doesn't seem to work. What should I do?
- A. Check whether Treesitter (syntax highlighting plugin) is working properly.

---

- Q. Why does LSP take so long (e.g., couple of seconds) to provide completion
  at the start of Neovim?
- A. The language server has to read your whole project (or part of it - depending on
  the LSP settings) for proper LSP setup. A little bit of patience at the start is needed.
  As instructed in the beginning of this guide, **just avoid using Omnisharp -
  it has numerous issues including severe memory leakage problems**.

---

- Q. LSP stopped working/does not work, help!
- A. Check LSP log by entering `:LspInfo` and solve issues accordingly.

## Feedback

The objective for this guide and its related projects is to provide a rich
Neovim development experience for the Unity game engine. Any feedback is more
than welcome (especially regarding C# LSP details).

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
See LICENSE.txt file for more info.

[neovim_installation]: https://github.com/neovim/neovim/tags
[wmctrl_installation]: https://linux.die.net/man/1/wmctrl
[xclip_repo]: https://github.com/astrand/xclip
[dotnet_sdk_installation_guide]: https://learn.microsoft.com/en-us/dotnet/core/install/
[roslyn_lsp_linux]: https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.linux-x64/overview
[roslyn_lsp_windows]: https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.win-x64/overview
[roslyn_lsp_macos]: https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.osx-x64/overview
[com_walcht_ide_neovim]: https://private-user-images.githubusercontent.com/89390465/469834041-8b59b404-da9d-4aba-8906-6987f235f5ca.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTM1Mjg2NTQsIm5iZiI6MTc1MzUyODM1NCwicGF0aCI6Ii84OTM5MDQ2NS80Njk4MzQwNDEtOGI1OWI0MDQtZGE5ZC00YWJhLTg5MDYtNjk4N2YyMzVmNWNhLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA3MjYlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNzI2VDExMTIzNFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTc1ZjhjYjhlOGVjMGJiMzg1ODFmODAzOTY0ODRlN2UzYWVmOGM3ODA5NThhOWMwYzZjNTAzYWZjOTIyNmQyZWQmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.W44-36Eupe9Sojor7iDoPeOMxhLwMynWbeEgQIBv4BE
[depracated_unity_debug]: https://github.com/Unity-Technologies/vscode-unity-debug
[stupid_license]: https://marketplace.visualstudio.com/items/VisualStudioToolsForUnity.vstuc/license
[unity_dap]: https://github.com/walcht/unity-dap
[showcase_0]: https://raw.githubusercontent.com/walcht/walcht/refs/heads/master/images/neovim-unity-showcase-0.png
[cgnvim]: https://github.com/walcht/CGNvim
[cgnvim_unity_dap]: https://github.com/walcht/CGNvim/blob/master/lua/cgnvim/daps/unity.lua
[showcase_1]: https://raw.githubusercontent.com/walcht/walcht/refs/heads/master/images/neovim-unity-showcase-1.png
[mono]: https://www.mono-project.com/download/stable/
