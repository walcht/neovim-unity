# About

Ready-to-use Neovim configured for game development using Unity3D engine. This
intended to be both, a ready-to-use Neovim package and a guide on how to get Neovim
working with Unity3D.

## Installation

This Installtion guide targets __Linux distributions__. A guide on how to
properly set this for Windows is yet to be provided.

#### Installing Dependencies
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

#### Neovim Setup

1. If you already have a Neovim configuration, make sure to do a backup:

```shell
backup
```
2. 

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

1. safasfsafsa

Why?

- Unity still relies on old .Net Framework assemblies. On Linux, it seems
like the only way to get these assemblies is through mono (thus that is 
the main reason why it is included as a dependency). Csharp-ls fails to
properly locate these 

## Usage

## Demos

## TODO

1. Change root directory to Assets folder.
2. Fix msbuild metadata diagnostics working (or find a way to ignore it)
3. Provide a set of default keymaps as a PDF 'cheat sheet' (please remember
that this assumes users with 0 Neovim experience)

## Configuration

In order to be able to further customize this according to your needs, you
have to first understand the file structure

### File Structure

[nvr_repo]: https://github.com/mhinz/neovim-remote
[dotnet_installation]: https://github.com/dotnet/core/blob/main/linux.md
[mono_installation]: https://www.mono-project.com/download/stable/
[csharpls_installation]: https://github.com/razzmatazz/csharp-language-server
[lsp]: https://microsoft.github.io/language-server-protocol/
