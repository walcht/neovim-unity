# About

> [!NOTE]
> This project is **not affiliated with Unity Technologies**.

![Showcase of Unity Neovim IDE-like editor with LSP support and diagnostics][showcase_0]

Debugging is also supported:

![Showcase of Unity Neovim IDE-like editor's debugging support][showcase_1]

<details><summary>Showcase video on Windows 10</summary>
https://github.com/user-attachments/assets/9990fb30-dcee-45ee-91fe-05a13b36b160
</details>

Ready-to-use Neovim configuration with the Unity engine. This repository is 
a single README file that provides instructions on how to setup Neovim for Unity
game engine development tasks on both Windows 10/11 and Linux. This project aims
to provide both, a ready-to-use Neovim package and a guide on how to get Neovim
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

First of all make sure that you have installed **Neovim >= 0.11**. You can do
that by following the instructions below (or this [guide][neovim_installation])
for your respective OS/distribution:

<details><summary>Ubuntu</summary>

```shell
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```

</details>

<details><summary>Debian</summary>

```shell
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```

</details>

<details><summary>Fedora Install Steps</summary>

```shell
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim
```

</details>

<details><summary>Arch</summary>

```shell
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
```

</details>

<details><summary>Windows</summary>

There are a couple of ways you can install NeoVim on Windows 10/11, either:

1. Download the `nvim-win64.msi` executable from the [latest official release
   page][nvim-release-page] and execute it.

Or, you can use a package manager for Windows and download it from there
(note however that this was problematic for me due to an obscure issue -
see [#13]):

1. install [chocolatey](https://chocolatey.org/install)
either follow the instructions on the page or use winget,
run in cmd as **admin**:
    ```shell
    winget install --accept-source-agreements chocolatey.chocolatey
    ```

2. install all requirements using choco, exit the previous cmd and
open a new one so that choco path is set, and run in cmd as **admin**:
    ```shell
    choco install -y neovim git ripgrep wget fd unzip gzip mingw make
    ```

</details>

This project has been tested with **Unity6000.1 LTS**. Any tests on other
Unity versions are extremely appreciated!

### Installing Dependencies

For C# Language Server Protocol (LSP) support, you have to:

1. download the Roslyn Language Server as a NuGet package from:
    1. on Linux: [Roslyn LS Linux][roslyn_lsp_linux]
    1. on Windows: [Roslyn LS Windows][roslyn_lsp_windows]
    1. on MacOS: [Roslyn LS MacOS][roslyn_lsp_macos]

1. extract it (NugGets are simply ZIP archives) at some location of your choice
(that we hereafter refer to as **<roslyn_ls_path>**)

1. make sure to globally install **.NET SDK >= 9.0** (or whichever minimum
version required by the Roslyn LS you have just installed). It can be installed
from the following official source:
**[.NET SDK installation guide][dotnet_sdk_installation_guide]**

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

<img width="521" height="258" alt="neovim-unity-ide-external-tools" src="https://github.com/user-attachments/assets/37020f12-b918-409a-88c7-d82a2e97576a" />

Now try to open a C# script from you project and keep an eye on the
notifications that might pop-up.

### Neovim Configuration Setup

If you are new to Neovim and you just want to get started with using it
for Unity development then you can directly use the proposed **CGNvim**
Neovim configuration for computer graphics development.

<details><summary>use proposed CGNvim configuration</summary>

1. If you already have your own Neovim configuration then make sure to do a
backup before proceeding:

    ```bash
    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    ```

1. Then clone the [**CGNvim**][cgnvim] repository (Neovim configuration
for general purpose computer graphics development):

    ```bash
    git clone https://github.com/walcht/CGNvim.git ~/.config/nvim
    ```

1. open the Roslyn LS configuration file (or your custom Neovim's Roslyn LS
configuration file) using some text editor:

    ```bash
    nvim ~/.config/nvim/lua/cgnvim/lsps/roslyn_ls.lua
    ```

   and change the `cmd` path to where you extracted/installed the Roslyn LSP
   (remember that **<roslyn_ls_path>** is a placeholder to where you have installed
   Roslyn LS):

    ```lua
    cmd = {
      "dotnet",
      -- <roslyn-ls-path> is a placeholder for the path to the Roslyn LS dir
      "<roslyn-ls-path>/Microsoft.CodeAnalysis.LanguageServer.dll",
      "--logLevel=Error", -- Critical|Debug|Error|Information|None|Trace|Warning
      "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
      "--stdio",
    }
    ```

1. Run `nvim` on anything so that you trigger the installation of dependencies
then run `:checkhealth` and solve potential issues (some dependencies may
require, for instance, Python3 and you may not have it on your system, etc).

</details>

<details><summary>adjust your own Neovim configuration</summary>

- It is assumed that you know Lua (at least the basics) and know how to configure
your Neovim setup (also very basic stuff - nothing advanced). The following
steps will not make any organizational assumptions and it is assumed that you
are able to take the following snippets and integrate them within your own
Neovim configuration.

1. We will make use of Neovim's core LSP functionalities and
no external dependencies - no plugins, no nvim-config, just plain Neovim. Copy
the following Lua script somewhere into your configuration (e.g., in your
config's `init`) and make sure to update **<roslyn_ls_path>** to the path of
your installed Roslyn LS:

    ```lua
    --- This will be called on LS initialization to request Roslyn to open the
    --- provided solution
    ---
    ---@param client vim.lsp.Client
    ---@param target string
    ---
    ---@return nil
    local function on_init_sln(client, target)
      vim.notify("Initializing: " .. target, vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      client:notify("solution/open", {
        solution = vim.uri_from_fname(target),
      })
    end
    
    --- This will be called on LS initialization to request Roslyn to open the
    --- provided project (usually when no solution (.sln) file was found this is
    --- used as a fallback).
    ---
    ---@param client vim.lsp.Client LSP client (this neovim instance)
    ---@param project_files string[] set of project files (.csproj) that will be
    ---requested to be opened by Roslyn LS
    ---
    ---@return nil
    local function on_init_project(client, project_files)
      vim.notify("Initializing: projects", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      client:notify("project/open", {
        projects = vim.tbl_map(function(file)
          return vim.uri_from_fname(file)
        end, project_files),
      })
    end
    
    --- Tries to find the solution/project root directory using the provided buffer
    --- id. This is done by trying to look up the directories until finding a one
    --- that contains a .sln file. If that fails, this looks instead for the first
    --- .csproj file it encounters.
    ---
    ---@param bufnr integer
    ---@param cb function
    local function project_root_dir_discovery(bufnr, cb)
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      -- don't try to find sln or csproj for files from libraries outside of the
      -- project
      if not bufname:match("^" .. vim.fs.joinpath("/tmp/MetadataAsSource/")) then
        -- try find '.sln' file (which resides in root dir)
        -- TODO: add support for .slnx and .slnf discovery
        local root_dir = vim.fs.root(bufnr, function(fname, _)
          return fname:match("%.sln$") ~= nil
        end)
    
        -- in case no '.sln' file was found then look for the first '.csproj' file
        if not root_dir then
          root_dir = vim.fs.root(bufnr, function(fname, _)
            return fname:match("%.csproj$") ~= nil
          end)
        end
    
        -- TODO: add Unity project root discovery heuristic in case the first opened C#
        -- script is directly part of the project (e.g., opening a file from Library)
        -- TODO: add user-input method for entering the project root manually
    
        if root_dir then
          cb(root_dir)
        else
          vim.notify(
            "[C# LSP] failed to find root directory - LS support is disabled",
            vim.log.levels.ERROR
          )
        end
      end
    end
    
    --- set Roslyn LS handlers. Each handler corresponds to a notification that
    --- might be sent by Roslyn LS - you can get the set of Roslyn LSP method names
    --- from: https://github.com/dotnet/roslyn/tree/main/src/LanguageServer/Protocol
    ---
    ---@type table<string, function>
    local roslyn_handlers = {
    
      -- once Roslyn LS has finished initializing the project, we request
      -- diagnostics for the current opened buffers
      ["workspace/projectInitializationComplete"] = function(_, _, ctx)
        vim.notify("Roslyn project initialization complete", vim.log.levels.INFO)
    
        local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
        local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
        for _, buf in ipairs(buffers) do
          client:request(vim.lsp.protocol.Methods.textDocument_diagnostic, {
            textDocument = vim.lsp.util.make_text_document_params(buf),
          }, nil, buf)
        end
      end,
    
      -- this means that `dotnet restore` has to be ran on the project/solution
      -- we can do that manually or, better, request the Roslyn LS instance to do it
      -- for us using the "workspace/_roslyn_restore" request which invokes the
      -- `dotnet restore <PATH-TO-SLN>` cmd
      ["workspace/_roslyn_projectNeedsRestore"] = function(_, result, ctx)
        local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    
        ---@diagnostic disable-next-line: param-type-mismatch
        client:request("workspace/_roslyn_restore", result, function(err, response)
          if err then
            vim.notify(err.message, vim.log.levels.ERROR)
          end
          if response then
            local log_lvl = vim.log.levels.INFO
            local t = {}
            for _, v in ipairs(response) do
              t[#t + 1] = v.message
              -- an error could be reported in the message string, if found then
              -- change the log level accordingly
              if string.find(v.message, "error%s*MSB%d%d%d%d") then
                log_lvl = vim.log.levels.WARN
              end
            end
            -- TODO: improve dotnet restore notification message
            -- bombard the user with a shitton of `dotnet restore` messages - this
            -- is actually better than remaining silent since this is only expected
            -- to run once
            vim.notify(table.concat(t, "\n"), log_lvl)
          end
        end)
    
        return vim.NIL
      end,
    
      -- Razor stuff that we do not care about
      ["razor/provideDynamicFileInfo"] = function(_, _, _)
        vim.notify(
          "Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim",
          vim.log.levels.WARN
        )
      end,
    }
    
    ---@type vim.lsp.ClientConfig
    local roslyn_ls_config = {
      name = "roslyn_ls",
      offset_encoding = "utf-8",
      cmd = {
        "dotnet",
        -- <roslyn-ls-path> is a placeholder for the path to the Roslyn LS directory
        "<roslyn_ls_path>/Microsoft.CodeAnalysis.LanguageServer.dll",
        "--logLevel=Error", -- Critical|Debug|Error|Information|None|Trace|Warning
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio",
      },
      filetypes = { "cs" },
      handlers = roslyn_handlers,
      ---@diagnostic disable-next-line: assign-type-mismatch
      root_dir = project_root_dir_discovery,
      on_init = {
        function(client)
          local root_dir = client.config.root_dir
    
          -- try load first solution we find
          for entry, type in vim.fs.dir(root_dir) do
            if type == "file" and vim.endswith(entry, ".sln") then
              on_init_sln(client, vim.fs.joinpath(root_dir, entry))
              return
            end
          end
    
          -- if no solution is found then load project
          local project_found = false
          for entry, type in vim.fs.dir(root_dir) do
            if type == "file" and vim.endswith(entry, ".csproj") then
              on_init_project(client, { vim.fs.joinpath(root_dir, entry) })
              project_found = true
            end
          end
    
          if not project_found then
            vim.notify(
              "[C# LSP] no solution/.csproj files were found",
              vim.log.levels.ERROR
            )
          end
        end,
      },
      capabilities = {
        -- HACK: Doesn't show any diagnostics if we do not set this to true
        textDocument = {
          diagnostic = {
            dynamicRegistration = true,
          },
        },
      },
      -- Roslyn-LS-specific settings
      settings = {
        ["csharp|background_analysis"] = {
          dotnet_analyzer_diagnostics_scope = "fullSolution",
          dotnet_compiler_diagnostics_scope = "fullSolution",
        },
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|symbol_search"] = {
          dotnet_search_reference_assemblies = true,
        },
        ["csharp|completion"] = {
          dotnet_show_name_completion_suggestions = true,
          dotnet_show_completion_items_from_unimported_namespaces = true,
          dotnet_provide_regex_completions = true,
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    }
    
    -- then add Roslyn LS to core Neovim LSP and enable it
    vim.lsp.config("roslyn_ls", roslyn_ls_config)
    vim.lsp.enable("roslyn_ls")
    ```

1. then to setup the DAP configuration for Unity usage (only Mono backend is
supported), see: [Unity Debugger Support](#Unity-Debugger-Support0)

</details>

#### Important Step for Proper LSP Functionalities

For LSP to work properly *.csproj* files have to be generated from the project
files. If you enter the command `:checkhealth vim.lsp` (or `:LspInfo` if you are
using CGNvim) after opening a .cs file from a Unity project, you might notice
that the project's directory root wasn't detected (see image below). The project
directory has to be detected for Omnisharp to work properly (Think of
across-files go-to definitions and references or classes defined in external
modules like UnityEngine, UnityEditor etc.).

#### Is Everything Working Fine?

Getting a C# LSP (in this case Roslyn LS) to work properly for a Unity project
can be frustrating.

To debug LSP issues, make sure that the C# LSP is active by entering the command
`:checkhealth vim.lsp` (or `:LspInfo` if you use CGNvim) and checking the
output. Do also check the LSP logs (using the cmd `:LspLog` if you use CGNvim)
(important to note that a lot of LSP *errors* and *warnings* can be safely
ignored).

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

> [!NOTE]
> [Unity-DAP][unity_dap] has NOT been yet tested on Windows 10/11 platforms. Testing
> and, potentially, support will be added shortly.

To add debugging support for Unity, you have to:

1. install [**Mono**][mono] (do NOT use Unity's integrated Mono to build this -
I have tested it and it does NOT work)

1. install the [Unity debug adapter][unity_dap] by cloning the repo and building it from source:

     ```bash
     git clone --recurse-submodules https://github.com/walcht/unity-dap.git
     cd unity-dap
     dotnet build unity-debug-adapter/unity-debug-adapter.csproj --configuration=Release
     ```

1. depending on which Neovim configuration you are using, adjust your
[nvim-dap][nvim-dap] configuration by entering the path to your just-installed
Unity debug adapter:

   <details><summary>use proposed CGNvim configuration</summary>
   Assuming you are using the [CGNvim][cgnvim] Neovim configuration, navigate
   to `~/.config/nvim/lua/cgnvim/daps/unity.lua` and change the
   `unity-debug-adapter.exe` path (also optionally change `mono` path in case it is
   not in PATH):

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

   </details>
    
   <details><summary>adjust your own Neovim configuration</summary>
   To setup Unity DA for your own Neovim configuration, make sure that you have
   [nvim-dap][nvim-dap] Neovim plugin installed and copy the following Lua script
   somewhere into your configuration (e.g., in your config's `init`) and make
   sure to update **<unity_debug_adapter_exe>** to the path of your
   just-installed Unity DA (also optionally change `mono` path in case it is not
   in PATH):
   
     ```lua
     local dap = require("dap")
     
     dap.adapters.unity = function(clbk, config)
       -- options passed to unity-debug-adapter.exe
     
       -- when connecting to a running Unity Editor, the TCP address of the listening
       -- connection is localhost
       -- on Linux, use: ss -tlp | grep 'Unity' to find the debugger connection
       vim.ui.input(
         { prompt = "address [127.0.0.1]: ", default = "127.0.0.1" },
         function(result)
           config.address = result
         end
       )
       -- then prompt the user for which port the DA should connect to
       vim.ui.input({ prompt = "port: " }, function(result)
         config.port = tonumber(result)
       end)
       clbk({
         type = "executable",
         -- adjust mono path - do NOT use Unity's integrated MonoBleedingEdge
         command = "mono",
         -- adjust unity-debug-adapter.exe path
         args = {
           -- get and install Unity debug adapter from:
           -- https://github.com/walcht/unity-dap
           -- then adjust the following path to where the installed executable is
           "<unity_debug_adapter_exe_path>",
           -- optional log level argument: trace | debug | info | warn | error | critical | none
           "--log-level=error",
           -- optional path to log file (logs to stderr in case this is not provided)
           -- "--log-file=<path_to_log_file_txt>",
         },
       })
     end
     
     -- make sure NOT to override other C# DAP configurations
     if dap.configurations.cs == nil then
       dap.configurations.cs = {}
     end
     
     table.insert(dap.configurations.cs, {
       name = "Unity Editor/Player Instance [Mono]",
       type = "unity",
       request = "attach",
     })
     ```

   </details>

1. if you are debugging a Unity editor instance, make sure Unity is set to
`Mode: Debug` and if you are debugging a Unity player instance, then make sure
that it is debuggable (check the settings on how to do that).

1. open a C# script, set some breakpoints and continue (<F5> key or by
entering the cmd `:DapContinue`)

1. the Unity DA connects to the Unity Mono debugger via a TCP socket, therefore
you have to provide an IP address and a port. On Linux, you can figure the
debugging port of a Unity editor instance by checking the output of:

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
    (ideally the list of endpoints to connect to should be listed automatically
    - will be implemented in the near future)

> [!NOTE]
> [Unity-DAP][unity_dap] only supports debugging applications built using the
> scripting backend `Mono` (i.e., IL2CPP debugging is not supported). Read the
> caution below in case debugging IL2CPP-built applications is a necessity for 
> you.

Alternatively, if you want to bebug IL2CPP-built apps then the new official
extension for VSCode, albeit closed-source, provides a `UnityDebugAdapter.dll`
and a `UnityAttachProbe.dll` which \**can be used* to list multiple instances
with which the DAP client could be attached.

> [!CAUTION]
> You will be in breach of the license terms for the extension if you use it for
Neovim development. To quote the [license terms][stupid_license]:
>
> > (a) Use with In-Scope Products and Services. You may install and use the
> > Software only with Microsoft Visual Studio Code, vscode.dev, GitHub
> > Codespaces (“Codespaces”) from GitHub, Inc. (“GitHub”), and successor
> > Microsoft, GitHub, and other Microsoft affiliates’ products and services
> > (collectively, the “In-Scope Products and Services”).

For this reason, I started the [Unity DA][unity-dap] project to provide an
up-to-date debug adapter under a permissive license.

## TODO

- [ ] MacOS support (IMPORTANT)
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

MIT License. See LICENSE.txt file for more info.

[showcase_0]: https://github.com/user-attachments/assets/daf91384-798c-4515-8b99-09bc49361b8c
[showcase_1]: https://github.com/user-attachments/assets/b0212c86-516f-45cf-87be-fc6dee90c08f
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
[cgnvim]: https://github.com/walcht/CGNvim
[cgnvim_unity_dap]: https://github.com/walcht/CGNvim/blob/master/lua/cgnvim/daps/unity.lua
[mono]: https://www.mono-project.com/download/stable/
[nvim-release-page]: https://github.com/neovim/neovim/blob/master/INSTALL.md
[#13]: https://github.com/walcht/neovim-unity/issues/13
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
