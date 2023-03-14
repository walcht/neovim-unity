# About

Ready-to-use Neovim configured for game development using Unity3D engine. This
intended to be both, a ready-to-use Neovim package and a guide on how to get Neovim
working with Unity3D.

## Installation

This Installtion guide targets __Linux distributions__. A guide on how to
properly set this for Windows is yet to be provided.

### Installing Dependencies
The below dependencies should be properly installed, please take a look at
respective links for up-to-date installation instructions.

1. __[nvr][nvr_repo]__: Remotely control Neovim processes -- Install using ```pip3
install neovim-remote```
2. __[dotnet][dotnet_installation]__: Necessary for csharp-language-server.
-- Install using ```sudo apt update && sudo apt install -y dotnet-sdk-7.0```
3. __[mono][mono_installation]__: Essential for .Net 4.7.x Assemblies used by
the Unity engine
4. __[csharp-ls][csharpls_installation]__: Csharp language server protocol for
autocomplection, static analyz(if the term LSP is new to you, read 
__[this][lsp]__) -- Install using: ```dotnet tool install --global csharp-ls```

### Neovim Setup

1. If you already have a Neovim configuration, you can ignore the following
steps and jump to Configuring Unity Editor. Or if you want to use this
configuration, make sure to do a backup:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

2. Clone the repository

```bash
git clone https://github.com/walcht/neovim-unity ~/.config/nvim
```


#### Installing Plugin Dependencies

- Make the __```setup.sh```__ executable and execute it

```bash
cd .scripts/
chmod +x .setup.sh
.setup.sh
```

Why?

- Since there are quite a few plugin dependencies that need to be installed, I
thought that putting everything in a script is much easier than having the user
go through all of the plugin dependencies.

#### Installing CoC Extensions

- Make the __```coc_setup.sh```__ executable and execute it. This will install
essential coc-extensions.

```bash
cd .scripts/
chmod +x .coc_setup.sh
.coc_setup.sh
```

Why?

- Actually the user should manually figure which extensions suits them best.
But for the impatient, a set of predefined extensions could be installed
using the above script.


#### Configuring Unity Editor

1. In Unity, navigate to __```Edit > Preferences > External tools```__
2. In __```External Script Editor```__ dropout, chose __```Browse...```__
3. Chose the the __```./unity/neovim_unity.sh```__ shell script
4. Copy the following argument into __```External Script Editor Args```__ field:

```bash
+$(Line) $(File)
```

- Why?
  - Usually when clicking on a an error message in Unity console, it directs
    you towards the __file__ and the __position__ of the cause of that error.
    To do that, unity has to instantiate an editor server instance, provide it
    with file name, line and column. Now when opening another file, the same
    editor server instance is used and the newly opened file will just appear
    as a tab in the editor.

#### Potential Issues

If csharp-ls complains about not finding .Net Framework 4.7.X files, then do
the following:

1. Add __```FrameworkPathOverride=/etc/mono/4.5```__ at the end of  
__```/etc/environment```__
2. Reboot!

Why?

- Unity still relies on old .Net Framework assemblies. On Linux, it seems
like the only way to get these assemblies is through __mono__ (thus the main
reason why it is included as a dependency). Csharp-ls fails to properly locate
these. Thus by permanently setting ```FrameworkPathOverride``` environment
variable to __mono__'s .Net Framework assemblies, csharp-ls is _hopefully_
going to work just fine.

#### Is Everything Working Fine?

Make sure to run ```:checkhealth``` to check if plugins are working properly.
If any issues are encountered then it most probably is related to some plugin
dependencies that are not\not properly installed.

## Used Plugins

This project is nothing more than boilerplate code for setting plugins. The
below plugins are used:

- coc-nvim:
- nvim-tree

## Usage

## Demos

## TODO

1. Fix msbuild metadata diagnostics working (or find a way to ignore it)
1. Change root directory to Assets folder
1. Focuses on Neovim window after opening a file in Unity
1. Provide a set of default keymaps as a PDF 'cheat sheet' (please remember
that this assumes users with 0 Neovim experience)
1. Drop coc.nvim and find a better way to integrate native LSP
1. Windows support
1. MacOS support
1. Add debugger support

## Limitations

- When opening a cs script for the first time, numerous metadata diagnostic
warnings are shown. These should be ignored since no actual effect has been
observed yet (read this __[issue][metadata_issue]__).
- Saving an edited file won't automatically trigger Unity to recompile project
files. You should do that manually (Project window > right click > Refresh)
- Development environment won't be as rich as on Visual Studio (in terms of
features provided) for really obvious reasons.

## File Structure

In order to be able to further customize this according to your needs, you
have to first understand the file structure

[nvr_repo]: https://github.com/mhinz/neovim-remote
[dotnet_installation]: https://github.com/dotnet/core/blob/main/linux.md
[mono_installation]: https://www.mono-project.com/download/stable/
[csharpls_installation]: https://github.com/razzmatazz/csharp-language-server
[lsp]: https://microsoft.github.io/language-server-protocol/
[metadata_issue]: https://github.com/dotnet/format/issues/56

## Feedback

This project was done by a very inexperienced Neovim user. If anything can be
enhanced then please open a PR!
I really enjoy using Neovim and I find it a bit sad that there are no
properly updated guides on how to set it up with Unity3D development
environment.

## License

This project is available under
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
. See LICENSE.txt file for more info.
