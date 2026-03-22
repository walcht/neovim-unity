# About

> [!Note]
> This project is **not affiliated with Unity Technologies**.
>
> This project is only supported for **Unity 2019.4 or later**.

This is a guide alongside a set of projects on how to setup **Neovim >= 0.11** for Unity
development tasks on both Linux and Windows (and, to some degree, WSL2 under Windows).
By the end of this you should have an *IDE* like experience without any propretiary
tools/third party libraries. All 3rd party utilities are licensed under the permissive
MIT License.

This guide includes steps on:
 - how to trigger Neovim to open (or autofocus if already opened) from Unity on
   file click or debug console clicks using [com.walcht.ide.neovim][com_walcht_ide_neovim]
   Unity package (this is by far the most important component of the project).
 - how to setup the language server (hereafter LS or LSP) using [Roslyn LS][roslyn]
 - how to setup the LSP on Windows while having Neovim run on WSL2 using [LSP TCP socket adapter][lsp-ip-socket-adapter]
 (using WSL2 on Windows is still not fully tested)
 - how to setup the debug adapter (hereafter DA) using [Unity DAP][unity_dap]
 - how to add the official [Microsoft.Unity.Analyzers][unity-analyzers] Roslyn analyzer
 (and other analyzers)

On Windows 10 using Windows Terminal:

<img width="2560" height="1440" alt="image" src="https://github.com/user-attachments/assets/673262d6-8b6a-4622-9427-ddc22ced93a8" />


Debugging is also supported (screenshot on Ubuntu):

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

>
> This project only supports **Unity >= 2019.4 LTS**.

This project is constantly tested against the following Unity versions and
platforms (*Ok here means that everything is runnings well, from LSP to the Debugger.*):

| Unity                     | OS                    | Status (\*Notes)         |
| ------------------------- | --------------------- |------------------------- |
| Unity 6000.4 LTS          | Ubuntu 24.04          | OK                       |
| Unity 6000.3 LTS          | Windows 10            | OK                       |
| Unity 2022.3 LTS          | Windows 10            | OK                       |
| Unity 2022.3 LTS          | Ubuntu 24.04          | OK                       |
| Unity 2020.3 LTS          | Windows 10            | OK (\*might get issues with the settings menu - bug with Unity's UIToolkit)   |
| Unity 2019.4 LTS          | Windows 10            | OK                       |

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

1. Or if you want to use WSL2 (Windows Subsystem for Linux), you can follow
   the installation guide for your installed Linux distribution and then make
   sure to read [Setting Neovim in WSL with Unity Projects in Windows](#Setting-Neovim-in-WSL-with-Unity-Projects-in-Windows).

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

**After completion, restart Unity** (just to be safe - for some reason, for
some Unity versions, not doing this may result in `Neovim <version>` not
showing up in the External Tools menu).

Now when navigating to: `Edit -> Preferences -> External Tools` you should
see `Neovim` in the drop down options (if you don't then you have to
explicitly enter your nvim executable path in `Neovim -> Settings`).

To automatically open Neovim when clicking on files/console warnings or errors,
navigate to:

`Edit -> Preferences -> External Tools` then Set "External Script Editor" to
Neovim.

All the plugin's settings are accessible via the top menu option:
`Neovim -> Settings`:

<img width="1368" height="877" alt="image" src="https://github.com/user-attachments/assets/6d9140ae-c2e5-4cc5-a6f2-86c2cc745745" />

Adjust which packages to generate the .csproj files for (you will only get LSP
functionalities for those selected packages and you might - not verified - get
worse performance the more the selected. I usually just tick them all):

<img width="949" height="183" alt="image" src="https://github.com/user-attachments/assets/429eb60d-d276-4df0-b4a7-5ea571280f87" />

Now try to open a C# script from you project and keep an eye on the
notifications that might pop-up.

For detailed explanation of all the settings, see [com.walcht.ide.neovim][com_walcht_ide_neovim].

### Neovim Configuration Setup

If you are new to Neovim and you just want to get started with using it
for Unity development then you can directly use the proposed **CGNvim**
Neovim configuration for computer graphics development:

<details><summary>use proposed CGNvim configuration</summary>

CGNvim has an auto-generated keymaps [cheatsheet PDF][cgnvim-cheatsheet] that makes it easy
to rapidly look for keymaps:

![cgnvim-cheatsheet](https://github.com/user-attachments/assets/3f8291ec-b9e1-4ebb-ad72-0766b757af8a)

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
      -- "<roslyn_ls_path>/Microsoft.CodeAnalysis.LanguageServer.exe",
      -- <roslyn-ls-path> is a placeholder for the path to the Roslyn LS dir
      "dotnet", -- on Windows, you can simply directly call the executable
      "<roslyn_ls_path>/Microsoft.CodeAnalysis.LanguageServer.dll",

      -- Critical|Debug|Error|Information|None|Trace|Warning
      "--logLevel=" .. lsp_log_lvl_to_roslyn_log_lvl[vim.lsp.log.get_level()],

      -- here we supply same log path as the one used by current LSP client
      -- (hence why we use - somewhat - the same log level)
      "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),

      "--stdio",
    }
    ```

1. Run `nvim` on anything so that you trigger the installation of dependencies
then run `:checkhealth` and solve potential issues (some dependencies may
require, for instance, Python3 and you may not have it on your system, etc).

</details></br>

If you are familiar with configuring Neovim (i.e., some basic knowledge about
Lua and Neovim plugin setup) then you are advised to integrate the following config:

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
your installed Roslyn LS (**this version is largely based on
[CGNvim's Roslyn LS config][cgnvim_roslyn_ls] - you are advised to refer
to that version as this one may not be up-to-date**):

    ```lua
    --------------------------------------------------------------------------------
    -- NEOVIM UNITY GLOBALS
    --------------------------------------------------------------------------------
    
    -- these globals are set by Neovim Unity plugin: com.walcht.ide.neovim upon the
    -- instantiation of a Neovim server instance. These are set to themselves
    -- because they are expected to be set via "nvim --cmd '<var> = <value>'" and
    -- we want to keep LuaLS happy.
    
    ---@type string? this is only set in case of Unity projects
    _G.nvim_unity_curr_unity_project_root_dir = nil
    
    ---@type string? an optional user-supplid project root. If this is set, then
    ---any opened C# files will always use this as their LS root dir (regardless
    ---of whether it actually is).
    _G.nvim_unity_user_supplied_project_root_dir =
      _G.nvim_unity_user_supplied_project_root_dir
    
    ---@type boolean if true, textDocument/diagnostic requests completion times for
    ---initially opened buffers are logged and notified.
    _G.nvim_unity_benchmark_roslyn_ls = _G.nvim_unity_benchmark_roslyn_ls or false
    
    ---@type "openFiles" | "fullSolution" | "none"
    _G.nvim_unity_analyzer_diagnostic_scope = _G.nvim_unity_analyzer_diagnostic_scope
      or "openFiles"
    
    ---@type "openFiles" | "fullSolution" | "none"
    _G.nvim_unity_compiler_diagnostic_scope = _G.nvim_unity_compiler_diagnostic_scope
      or "openFiles"
    
    --------------------------------------------------------------------------------
    -- ROSLYN LS BENCHMARKING
    --------------------------------------------------------------------------------
    
    ---@type integer solution/project initialization start time in ms
    local start_time
    
    local function log_benchmarking_settings()
      local benchmark_settings = {
        ---@diagnostic disable-next-line: undefined-field
        ["os"] = vim.loop.os_uname().sysname,
        ["dotnet_analyzer_diagnostics_scope"] = _G.nvim_unity_analyzer_diagnostic_scope,
        ["dotnet_compiler_diagnostics_scope"] = _G.nvim_unity_compiler_diagnostic_scope,
      }
      local indent = vim.bo.expandtab and (" "):rep(vim.o.shiftwidth) or "\t"
      local stringified = vim.json.encode(benchmark_settings, { indent = indent })
      local msg = "[benchmark] started textDocument/diagnostic with settings: "
        .. stringified
      vim.notify(msg, vim.log.levels.INFO)
      vim.lsp.log.error(msg)
    end
    
    --------------------------------------------------------------------------------
    -- MISC SHIT
    --------------------------------------------------------------------------------
    
    local fs = vim.fs
    
    -- current solution target (can be a solution file .sln(x) or a C# file for
    -- single-file projects).
    local sln_target = nil
    
    --------------------------------------------------------------------------------
    -- INITIALIZATION CALLBACKS
    --------------------------------------------------------------------------------
    
    --- This will be called on LS initialization to request Roslyn to open the
    --- provided solution
    ---
    ---@param client vim.lsp.Client
    ---@param target string absolute path to .sln[x] solution file or a single C#
    ---document in case of single-file projects.
    ---
    ---@return nil
    local function on_init_sln(client, target)
      vim.notify("Initializing: solution" .. target, vim.log.levels.INFO)
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
    ---@param project_files string[] set of absolute paths to project files
    ---(.csproj) that will be requested to be opened by Roslyn LS.
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
    --- that contains a .sln(x) file. If that fails, this looks instead for the
    --- first .csproj file it encounters. Finally, if that also fails, the absolute
    --- path to this buffer is sent for single-file C# project LSP functionality.
    ---
    ---@param bufnr integer
    ---@param on_dir fun(root_dir?:string)
    ---
    ---@return nil
    local function project_root_dir_discovery(bufnr, on_dir)
      -- if there is a user-supplied project root, then simply use it.
      if _G.nvim_unity_user_supplied_project_root_dir then
        vim.notify(
          "[C# LS] using user-supplied Unity project root dir: "
            .. _G.nvim_unity_user_supplied_project_root_dir,
          vim.log.levels.INFO
        )
        on_dir(_G.nvim_unity_user_supplied_project_root_dir)
        return
      end
    
      -- otherwise, we check if this C# file is part of a Unity project
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local root_dir = nil
      for dir in vim.fs.parents(bufname) do
        if vim.fn.isdirectory(vim.fs.joinpath(dir, "/Assets")) then
          root_dir = dir
          break
        end
      end
    
      -- this means this is part of a Unity project
      if root_dir then
        -- if there is already a currently running Unity LS session
        if _G.nvim_unity_curr_unity_project_root_dir then
          -- is the Unity session the same?
          if _G.nvim_unity_curr_unity_project_root_dir == root_dir then
            on_dir(root_dir)
            return
          -- only a single client + Roslyn LS is created/maintained
          -- throughout the whole session (as to why: performance reasons. Running
          -- a LS + client for a Unity project is usually very resource intensive).
          else
            vim.notify(
              string.format(
                "[C# LSP] you have opened a C# file that belong to different Unity "
                  .. "project (%s) than the one currently in use (%s). LS support "
                  .. "for this buffer is disabled.",
                root_dir,
                _G.nvim_unity_curr_unity_project_root_dir
              ),
              vim.log.levels.WARN
            )
            return
          end
        -- otherwise, this is the first time we instantiate this Unity session
        else
          _G.nvim_unity_curr_unity_project_root_dir = root_dir
          on_dir(root_dir)
          return
        end
      end
    
      -- at this point we are not dealing with C# file that belongs to Unity project
      -- and nor has the user manually supplied a project root
    
      -- try find '.sln[xf]' file (which resides in root dir)
      root_dir = vim.fs.root(bufnr, function(fname, _)
        return fname:match("%.sln[x]?$") ~= nil
      end)
    
      -- in case no '.sln[xf]' file was found then look for the first '.csproj'
      if not root_dir then
        root_dir = vim.fs.root(bufnr, function(fname, _)
          return fname:match("%.csproj$") ~= nil
        end)
      end
    
      if root_dir then
        -- this means that we have found a root (either from .sln[xf] or .csproj)
        on_dir(root_dir)
      else
        -- this means that we have NOT found a root - use single-file mode
        on_dir(bufname)
        vim.notify(
          "[C# LSP] failed to find root directory - LS is running in "
            .. "single-file mode.",
          vim.log.levels.WARN
        )
      end
    
      vim.notify(
        "[C# LSP] failed to find root directory - LS is disabled for this buffer.",
        vim.log.levels.WARN
      )
    end
    
    --- set Roslyn LS handlers. Each handler corresponds to a request that might be
    --- sent by Roslyn LS - you can get the set of Roslyn LSP method names from:
    --- https://github.com/dotnet/roslyn/tree/main/src/LanguageServer/Protocol
    ---
    ---@type table<string, function>?
    local roslyn_handlers = {
      -- once Roslyn LS has finished initializing the project, we request
      -- diagnostics for the current opened buffers
      ["workspace/projectInitializationComplete"] = function(_, _, ctx)
        vim.notify("Roslyn project initialization complete", vim.log.levels.INFO)
    
        local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
        local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
        local method = vim.lsp.protocol.Methods.textDocument_diagnostic
    
        if _G.nvim_unity_benchmark_roslyn_ls then
          local msg = string.format(
            "[benchmark] textDocument/diagnostics request completion "
              .. "time for %i buffers",
            #buffers
          )
          -- it's set to error because any lower level and the log simply gets
          -- full of nonsense logs...
          vim.notify(msg, vim.log.levels.INFO)
          vim.lsp.log.error(msg)
        end
    
        for _, buf in ipairs(buffers) do
          --- @type lsp.Handler Response |lsp-handler| for this method.
          local handler = nil
    
          if _G.nvim_unity_benchmark_roslyn_ls then
            handler = function(_err, _res, _ctx)
              -- call the default handler
              (client.handlers[method] or vim.lsp.handlers[method])(
                _err,
                _res,
                _ctx
              )
              ---@diagnostic disable-next-line: undefined-field
              local secs, ms = vim.uv.gettimeofday()
              local diff = (secs + ms * 0.001 * 0.001) - start_time
              local msg = string.format(
                "[benchmark] textDocument/diagnostics request for bufnr %i done in: %.3fs",
                _ctx.bufnr,
                diff
              )
              vim.notify(msg, vim.log.levels.INFO)
              -- it's set to error because any lower level and the log simply gets
              -- full of nonsense logs...
              vim.lsp.log.error(msg)
            end -- end handler
          end
    
          local success = client:request(method, {
            textDocument = vim.lsp.util.make_text_document_params(buf),
          }, handler, buf)
    
          if not success then
            vim.notify(
              string.format(
                "failed to send request to Roslyn LS for textDocument_diagnostic "
                  .. "for buf: %s",
                vim.api.nvim_buf_get_name(buf)
              ),
              vim.log.levels.ERROR
            )
          end
        end -- end for buf
      end,
    
      -- This is only kept for backwards compatibility and is no longer needed for
      -- latest Roslyn versions: https://github.com/dotnet/roslyn/pull/81233
      --
      -- this means that `dotnet restore` has to be ran on the project/solution
      -- we can do that manually or, better, request the Roslyn LS instance to do it
      -- for us using the "workspace/_roslyn_restore" request which invokes the
      -- `dotnet restore <PATH-TO-SLN>` cmd
      ["workspace/_roslyn_projectNeedsRestore"] = function(_, result, ctx)
        local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    
        -- request the Roslyn LS to run dotnet restore (better than doing it
        -- ourselves).
        ---@diagnostic disable-next-line: param-type-mismatch
        client:request("workspace/_roslyn_restore", result, function(err, response)
          if err then
            vim.notify(err.message, vim.log.levels.ERROR)
            vim.lsp.log.error(err.message)
          end
          local no_errors = true
          if response then
            for _, v in ipairs(response) do
              -- an error could be reported in the message string, if found log it
              if string.find(v.message, "error%s*MSB%d%d%d%d") then
                vim.lsp.log.warn(v.message)
                vim.notify(v.message, vim.log.levels.WARN)
                no_errors = false
              end
            end
          end
          if no_errors then
            vim.notify("dotnet restore completed successfully", vim.log.levels.INFO)
          else
            vim.notify(
              "dotnet restore completed with errors - see LSP log",
              vim.log.levels.WARN
            )
          end
        end)
    
        return vim.NIL
      end,
    
      ["workspace/_roslyn_projectHasUnresolvedDependencies"] = function()
        if sln_target ~= nil then
          vim.notify(
            string.format(
              "Detected missing dependencies. Run `dotnet restore %s` command.",
              sln_target
            ),
            vim.log.levels.ERROR
          )
          return vim.NIL
        end
        vim.notify(
          "Detected missing dependencies. Run `dotnet restore` command.",
          vim.log.levels.ERROR
        )
      end,
    
      -- Razor stuff that we do not care about
      ["razor/provideDynamicFileInfo"] = function(_, _, _)
        vim.notify(
          "Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim",
          vim.log.levels.WARN
        )
      end,
    }
    
    -- Roslyn-LS-specific settings
    local roslyn_ls_specific_settings = {
      ["csharp|background_analysis"] = {
        -- Option to turn configure background analysis scope for the current
        -- user. Note: setting this to "fullSolution" may result in significant
        -- performance degradation, see: https://github.com/dotnet/vscode-csharp/issues/8145#issuecomment-2784568100
        ---@type "openFiles" | "fullSolution" | "none"
        dotnet_analyzer_diagnostics_scope = _G.nvim_unity_analyzer_diagnostic_scope,
    
        -- Option to configure compiler diagnostics scope for the current user.
        -- Note: setting this to "fullSolution" may result in significant
        -- performance degradation, see: https://github.com/dotnet/vscode-csharp/issues/8145#issuecomment-2784568100
        ---@type "openFiles" | "fullSolution" | "none"
        dotnet_compiler_diagnostics_scope = _G.nvim_unity_compiler_diagnostic_scope,
      },
      ["csharp|inlay_hints"] = {
        ---@type boolean
        dotnet_enable_inlay_hints_for_parameters = true,
        ---@type boolean
        dotnet_enable_inlay_hints_for_literal_parameters = true,
        ---@type boolean
        dotnet_enable_inlay_hints_for_indexer_parameters = true,
        ---@type boolean
        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
        ---@type boolean
        dotnet_enable_inlay_hints_for_other_parameters = true,
        ---@type boolean
        dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
        ---@type boolean
        dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        ---@type boolean
        dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
        ---@type boolean
        csharp_enable_inlay_hints_for_types = true,
        ---@type boolean
        csharp_enable_inlay_hints_for_implicit_variable_types = true,
        ---@type boolean
        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
        ---@type boolean
        csharp_enable_inlay_hints_for_implicit_object_creation = true,
        ---@type boolean
        csharp_enable_inlay_hints_for_collection_expressions = true,
      },
      ["csharp|symbol_search"] = {
        ---@type boolean
        dotnet_search_reference_assemblies = true,
      },
      ["csharp|completion"] = {
        ---@type boolean
        dotnet_show_name_completion_suggestions = true,
        ---@type boolean
        dotnet_provide_regex_completions = true,
    
        -- Whether to show completion items from namespaces that are not imported.
        -- For example, if this is set to true, and you don't have the namespace
        -- `System.Net.Sockets` imported, then when you type "Sock" you will not
        -- get completion for `Socket` or other items in that namespace.
        ---@type boolean
        dotnet_show_completion_items_from_unimported_namespaces = false,
    
        ---@type boolean
        dotnet_trigger_completion_in_argument_lists = true,
      },
      ["csharp|code_lens"] = {
        ---@type boolean
        dotnet_enable_references_code_lens = true,
        ---@type boolean
        dotnet_enable_tests_code_lens = true,
      },
      ["csharp|projects"] = {
        -- A folder to log binlogs to when running design-time builds.
        ---@type string?
        dotnet_binary_log_path = nil,
        -- Whether or not automatic nuget restore is enabled.
        ---@type boolean
        dotnet_enable_automatic_restore = true,
        -- Whether to use the new 'dotnet run app.cs' (file-based programs)
        -- experience.
        ---@type boolean
        dotnet_enable_file_based_programs = true,
        -- Whether to use the new 'dotnet run app.cs' (file-based programs)
        -- experience in files where the editor is unable to determine with
        -- certainty whether the file is a file-based program.
        ---@type boolean
        dotnet_enable_file_based_programs_when_ambiguous = true,
      },
      ["csharp|navigation"] = {
        ---@type boolean
        dotnet_navigate_to_decompiled_sources = true,
        ---@type boolean
        dotnet_navigate_to_source_link_and_embedded_sources = true,
      },
      ["csharp|highlighting"] = {
        ---@type boolean
        dotnet_highlight_related_json_components = true,
        ---@type boolean
        dotnet_highlight_related_regex_components = true,
      },
    }
    
    local lsp_log_lvl_to_roslyn_log_lvl = {
      [vim.log.levels.OFF] = "None",
      [vim.log.levels.TRACE] = "Trace",
      [vim.log.levels.DEBUG] = "Debug",
      [vim.log.levels.INFO] = "Information",
      [vim.log.levels.WARN] = "Warning",
      [vim.log.levels.ERROR] = "Error",
    }
    
    ---@type lsp.ClientCapabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.diagnostic.dynamicRegistration = true
    
    ---@type vim.lsp.Config
    local roslyn_ls_config = {
      name = "roslyn_ls",
      offset_encoding = "utf-8",
      cmd = {
        -- on Windows, you can simply directly call the executable:
        --  "<roslyn_ls_path>/Microsoft.CodeAnalysis.LanguageServer.exe",
        --  <roslyn-ls-path> is a placeholder for the path to the Roslyn LS dir
        "dotnet",
        "<roslyn_ls_path>/Microsoft.CodeAnalysis.LanguageServer.dll",
    
        -- Critical|Debug|Error|Information|None|Trace|Warning
        "--logLevel=" .. lsp_log_lvl_to_roslyn_log_lvl[vim.lsp.log.get_level()],
    
        -- here we supply same log path as the one used by current LSP client
        -- (hence why we use - somewhat - the same log level)
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
    
        "--stdio",
      },
      filetypes = { "cs" },
      handlers = roslyn_handlers,
      root_dir = project_root_dir_discovery,
      on_init = {
        function(client)
          local root_dir = client.config.root_dir
    
          if _G.nvim_unity_benchmark_roslyn_ls then
            -- vim.lsp.log.set_level(vim.log.levels.INFO)
            ---@diagnostic disable-next-line: undefined-field
            local seconds, microsecond = vim.uv.gettimeofday()
            start_time = seconds + microsecond * 0.001 * 0.001
            log_benchmarking_settings()
          end
    
          -- try load first solution we find
          for entry, type in fs.dir(root_dir) do
            if
              type == "file"
              and (vim.endswith(entry, ".sln") or vim.endswith(entry, ".slnx"))
            then
              on_init_sln(client, fs.joinpath(root_dir, entry))
              sln_target = entry
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
      capabilities = capabilities,
      settings = roslyn_ls_specific_settings,
      -- Roslyn LS is quite resource intensive... We want to be 100% sure that it
      -- is closed and not orphaned (e.g., if nvim crashes).
      detached = false,
    }
    
    -- then add Roslyn LS to core Neovim LSP and enable it
    vim.lsp.config("roslyn_ls", roslyn_ls_config)
    vim.lsp.enable("roslyn_ls")
    ```

1. then to setup the DAP configuration for Unity usage (only Mono backend is
supported), see: [Unity Debugger Support](#Unity-Debugger-Support)

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

### Setting up the Microsoft.Unity.Analyzers Roslyn Analyzer (optional)

If you want the language server to suppress irrelevant warnings (such as:
`the Start()/Upate() is not used`, etc) and provide useful Unity-development
diagnostics (e.g., tag comparison warnings and other performance-related
diagnostics) then:

  1. download the analyzer from [here][unity-analyzer-releases]
  (to play it safe - download an older version - e.g., v1.19.0)
  
  1. extract it to some location `<unity-analyzer-path>` (again, nuget packages
     are simply Zips)

  1. navigate to `Neovim -> Settings` then enter the path to the just-extracted
     `Microsoft.Unity.Analyzers.dll` (or click on `Browse` and select it) then
     click `Apply`:

     <img width="948" height="144" alt="image" src="https://github.com/user-attachments/assets/b46ac97d-6571-4a48-a28d-ebbc578d55dd" />

  1. you should now see something like this in the autogenerated `.csproj`
     files:

     ```xml
     <ItemGroup>
        <!-- other analyzers ... -->
        <Analyzer Include="path-to-Microsoft.Unity.Analyzers.dll" />
        <!-- other analyzers ... -->
     </ItemGroup>
     ```

## Unity Debugger Support

<details>
<summary>New to the concept of Debug Adapter Protocols (DAP)?</summary>

### Debug Adapter Protocols

```
                    Translates `requests` from nvim (which are DAP conformant)
                    to Mono.Debugger-sepecific requests.
                    Translates Mono.Debugger-specific
                    responses to DAP-conformant `responses`.
                    Writes logs to s_LogFile or stderr              Locally running Unity Editor (which always uses Mono). Or
                              |                                     a local/remote running Unity Player instance using Mono
                              |                                                 backend (with debugging enabled)
                              |                                                             |
    +------+            +-----------+                  +--------------------+ <  - - - - -  +
    | Nvim |----------- | UNITY DAP | ---------------- |       UNITY        |
    +------+     ^      +-----------+        ^         |   (Mono.Debugger)  |
                 |                           |         +--------------------+
                 |                           |
         via stdin and stdout                + via a TCP/IP socket (ip:port)
         (_outputStream and inputStream)
```

You can read the excellent overview on DAPs here:
https://github.com/microsoft/debug-adapter-protocol/blob/main/overview.md

</details>


The Mono debug adapter for Unity [VSCode Unity Debug][depracated_unity_debug]
is no longer supported and is deprecated, therefore a fork of the project is
created at [Unity-DAP][unity_dap] to provide an up-to-date debug adapter for Unity
(without any VSCode dependencies nor any weird licenses).

To add debugging support for Unity, you have to:

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
      -- adjust unity-debug-adapter.exe path (don't forget to `chmod +x` it)
      command = "<path-to-unity-debug-adapter.exe>",
      args = {
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
   just-installed Unity DA:
   
     ```lua
     local dap = require("dap")
     
     dap.adapters.unity = function(clbk, config)
       -- options passed to unity-debug-adapter.exe
     
       -- when connecting to a running Unity Editor, the TCP address of the listening
       -- connection is localhost (i.e., 127.0.0.1).
       vim.ui.input(
         { prompt = "address [127.0.0.1]: ", default = "127.0.0.1" },
         function(result)
           config.address = result
         end
       )
       -- then prompt the user for which port the DA should connect to
       -- to get the port for a Unity Editor, search for this line
       -- "" at:
       --   on Linux: 
       vim.ui.input({ prompt = "port: " }, function(result)
         config.port = tonumber(result)
       end)
       clbk({
         type = "executable",
         -- adjust unity-debug-adapter.exe path (don't forget to `chmod +x` it)
         -- get and install Unity debug adapter from:
         -- https://github.com/walcht/unity-dap
         command = "<path-to-unity-debug-adapter.exe>",
         args = {
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

1. depending on whether you want to debug a Unity Editor or a Unity Player
   instance:
   
   - if you are debugging a Unity Editor instance, make sure Unity is set to
     `Mode: Debug` and make sure you see this symbol:

     <img width="343" height="136" alt="image" src="https://github.com/user-attachments/assets/a494063a-55b3-45f2-a02d-e370e385ad82" />
     
   - if you are debugging a Unity Player instance, then make sure that it is debuggable
     (check the build settings on how to do that):
     
     <img width="444" height="181" alt="image" src="https://github.com/user-attachments/assets/8a361746-08f8-47ac-909a-a21756735550" />

1. open a C# script, set some breakpoints and continue (<F5> key or by
entering the cmd `:DapContinue`)

1. the Unity DA connects to the Unity Mono debugger via a TCP socket, therefore
you have to provide an IP address and a port. For the moment, you can
figure the Unity's debugger listening IP and PORT manually:

   - For a local Unity Editor instance:
   
     - IP: `127.0.0.1`
     
     - PORT: There are multiple methods to determine the port.
    
       Assuming you only have one single Unity Editor instance running, you can simply navigate to
       (the Neovim DAP configuration above automatically does this):
       
        - on Linux: `~/.config/unity3d/Editor.log`
        - on Windows: `%LOCALAPPDATA%\Unity\Editor\Editor.log`
    
       and look for the following line:
       `Using monoOptions --debugger-agent=transport=dt_socket,embedding=1,server=y,suspend=n,address=127.0.0.1:56900`
       
       <details><summary>More advanced methods to find IP:PORT of Unity Editor instance</summary>
        On Windows 10/11 you can figure the PID of the running Unity Editor instance using:
     
       ```powershell
       Get-Process -Name Unity | Where-Object {$_.mainWindowTitle} | Format-Table Id, Name, mainWindowtitle
       ```

       which outputs something like this:

       ```powershell
          Id Name  MainWindowTitle
          -- ----  ---------------
       15900 Unity ctvisualizer - desktop - Windows, Mac, Linux - Unity 6.3 LTS (6000.3.1f1) <Vulkan>
       ```

       which means the debugging port is 56900.
       Notice that in the above script the processes have to be filtered by those having a main title
       window because there are multiple Unity-named processes (i.e., background processes).
     
       On Linux, you can figure the debugging port of a Unity editor instance by checking the output of:

       ```bash
       ss -tlp | grep 'Unity'
       ```

       which yields an output like this:

       ```
       LISTEN 0      16         127.0.0.1:56365       0.0.0.0:*    users:(("UnityShaderComp",pid=306581,fd=128),("Unity",pid=306365,fd=128))
       LISTEN 0      16         127.0.0.1:56451       0.0.0.0:*    users:(("UnityShaderComp",pid=322591,fd=47),("Unity",pid=322451,fd=47))  
       LISTEN 0      16         127.0.0.1:56457       0.0.0.0:*    users:(("UnityShaderComp",pid=322609,fd=47),("Unity",pid=322457,fd=47))
       ```

       the debugging IP is 127.0.0.1 and the port is 56365 (usually the Unity process consuming the most resources is the Unity Editor instance one).
       
       Or you can compute the following formula for the port: `56000 + <UNITY-EDITOR-PID> % 1000`
       
       </details>

   - For a local Unity Player instance:
   
     - IP: `127.0.0.1` (or remote machine IP in case it is not running locally)
     
     - PORT: there are multiple ways to determine the listening debugger:
     
       - The easiest way is to enable the `Wait For Managed Debugger` in your build settings:

         <img width="444" height="181" alt="image" src="https://github.com/user-attachments/assets/8a361746-08f8-47ac-909a-a21756735550" />

         This will cause the showup of the following popup upon the launch of your built Unity application:

         <img width="396" height="150" alt="image" src="https://github.com/user-attachments/assets/e348b4b6-535e-41b0-b1c3-c611da4c0e6a" />
         
       <details><summary>Other methods to find IP:PORT of a Unity Player instance</summary>
        - The other method is to navigate to:

         - on Linux: `~/.config/unity3d/CompanyName/ProductName/Player.log`
         - on Windows: `%USERPROFILE%\AppData\LocalLow\CompanyName\ProductName\Player.log`
         
         which should contain the following lines (at the very top):

         ```text
         Starting managed debugger on port 56846
         Using monoOptions --debugger-agent=transport=dt_socket,embedding=1,server=y,suspend=n,address=0.0.0.0:56846
         ```
       </details>
       
> [!NOTE]
> [Unity-DAP][unity_dap] only supports debugging applications built using the
> scripting backend `Mono` (i.e., IL2CPP debugging is not supported). Read the
> caution below in case debugging IL2CPP-built applications is a necessity for 
> you.

Alternatively, if you want to debug IL2CPP-built apps then the new official
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

For this reason, I started the [Unity DA][unity_dap] project to provide an
up-to-date debug adapter under a permissive license.

## Setting Neovim in WSL with Unity Projects in Windows

If you want to use Neovim within WSL2 (Windows Subsystem for Linux) and *connect*
it with Unity projects under Windows then you have to:

  1. open WSL2 and run (`<windows-host-ip>` now refers to the outputed IP):
     
     ```bash
     ip route show | grep -i default | awk '{ print $3}'
     ```
     
     Why? For a program running on WSL2 (a whole different machine - somewhat) to
     communicate with a program running on Windows host, you have to get its IP.
     Read this official guide for details: [Accessing network applications with WSL][windows-wsl].
     
  1. adjust the Roslyn LS's config's `cmd` as such:
     
     ```lua
     local roslyn_ls_config = {
      -- ...
      cmd = vim.lsp.rpc.connect(<windows-host-ip>, <port>),
      -- ...
      }
     ```

     `<port>` can be any available port: example: `56777`.
     What this does is to tell the Neovim LSP client to connect to an LS
     via the IP socket `<windows-host-ip>:<port>` (does not matter where
     the other LS is running - as long as its socket endpoint is reachable).

  1. install and build the [LSP IP Socket Adapter][lsp-ip-socket-adapter] (or just
     get the DLL directly from the [release page][lspadapter-releases]) and run as such:

     ```PowerShell
     LSPTCPSocketAdapter.exe <windows-host-ip> <port> dotnet "<roslyn-ls-path> --logLevel=Error --extensionLogDirectory=log --stdio" --mount=/mnt/c
     ```

  1. now run Neovim on a valid C# file/project (i.e., a project with generated csproj files)
     and you should see LSP support.

     Why install an additional program, this is already too complicated? (you may
     ask) - Well, as the time of writing this, Roslyn LS does NOT provided a sockets
     IP communication mechanism and one can only communicate with it via its stdin/stdout
     or pipes (which do not work with WSL2). This is where this adapter comes in handy,
     what it does is simply this:

     ```
       Neovim LSP Client ----- LSP IP Socket Adapter ------- Roslyn LS
                         |            |                  |
             + - - - - - +            |                  + - - - +
             |              forward msgs from  both ends           |
     communication via      and adjust Neovim LSP client    communication via
     IP socket:             URIs to  valid Windows  URIs      stdin/stdout
     <windows-host-ip>:<port>
     ```

You might think of running the Roslyn LS within WSL2 (i.e., install it on WSL2 and
run it on some Unity project that was generated/configured on Windows under some
mounted location - usually `/mnt/c`). **There are many issues with such approach,
including:**

  1. It will simply not work - the UnityEngine DLLs are configured/built for Windows
     and the `.csproj` files contain Windows paths (i.e., not adjusted to the mount
     location of Windows under WSL). Even if you adjust the paths, it will still not
     work - you are simply running a program under an OS (Linux) telling it to
     understand the structure of another project under a completely different OS
     (Windows).

  1. Even if this somehow works (which again, it will not) - the performance will be
     extremely bad because Roslyn LS has to access a lot of files (hundreds to thousands)
     and Windows file access performance via WSL2 is simply bad.

For more details, see: [this issue][wsl-issue] and [this original issue][nvim-roslyn-wsl-issue].

## Known Limitations

- When you create a new C# from Neovim - you do not get LSP support for it. You have to
  focus on Unity window (to regenerate the `.csproj` files) and restart the language server.
  This is currently in the TODO list below.

- Currently when you do any change in Neovim of any relevant Unity project files (e.g.,
  C# script), Unity does not recompile changes until you focus on its Window. This is in
  the TODO list below and requires some IPC communication mechanism between the Unity
  Neovim.IDE pluging and the running Neovim server instance.

- Debugging is only limited to Mono scripting backends (no debugging support for IL2CPP).
  Currently, I am not planning to adding support for this due to the huge workload this
  requires (I do not even know if it is possible). Feel free to contribute if you know
  how to do it.

- You have to figure out (through trial and error) the Unity debugger's port it is
  listening on for you to be able to attach the DAP to Unity's debugger. Automated
  script for figuring this out is currently being worked on.

## TODO

- [ ] Automate WSL setup (automatic windows host IP discovery, automatic random
      port assignment, automatic LSP adapter startup, etc.) (**IMPORTANT**)
- [ ] Auto Unity debugger listening port discovery (**CRUCIAL**) (this is being done but is
      much trickier that initially thought)
- [ ] MacOS support (**IMPORTANT**) (needs a MacOS tester/contributor)
- [ ] Add metrics/benchmarking integration tests for LSP on some Unity projects (**CRUCIAL**)
- [ ] Add GitHub workflow for auto TOC generation for this README (OPTIONAL)
- [ ] Add GitHub workflow for link checks for this README (OPTIONAL)
- [ ] Add GitHub pages support (OPTIONAL)

## FAQ

- Q. Why not use omnisharp or csharp-ls?
- A. Roslyn LS is the *new* officially suporrted LSP for C#. Omnisharp is not
  well maintained, can be exteremely slow and unresponsive, and has a potential
  memory leak issue. CSharp-LS on the other hand is a hacky LSP (as per the
  description in its repository) and is not officially supported.

---

- Q. Why the headache? Why not just use Visual Studio/VSCode?
- A0. The VSCode plugin for C# development is closed source and strictly forbids
  its usage for non-Microsoft products.
- A1. This project allows you to use Neovim (an IDE-ish experience) within WSL2
  with proper LSP support. As far as I know, no other IDE/text editor provides
  this funtionality.
- A2. Some people find great joy in using Neovim. Some other people use it for
  all their programming tasks thus it would be inefficient for them to
  transition to Visual Studio or VSCode just for Unity programming. Also,
  Neovim consumes less resources and you get more control into how much
  you want it to act as an IDE.

---

- Q. Syntax highlighting doesn't seem to work. What should I do?
- A. Check whether Treesitter (syntax highlighting plugin) is working properly.

---

- Q. Why does LSP take so long (e.g., couple of seconds) to provide completion
  at the start of Neovim?
- A1. You can instruct Roslyn LS to provide diagnostics for the whole project
  (deteriorates the performance) or only for opened files. Play with these
  settings.
- A1. The language server has to read your whole project (or part of it - depending on
  the LSP settings) for proper LSP setup. A little bit of patience at the start is needed.
- A2. As instructed in the beginning of this guide, **just avoid using Omnisharp -
  it has numerous issues including severe memory leakage problems**.

---

- Q. LSP stopped working/does not work, help!
- A0. Check LSP log by entering `:LspInfo` and solve issues accordingly.
- A1. Is the root directory correctly provided/discovered? (this root dir
  should be for Unity projects the folder which contains the Asset/ folder).
- A2. 

---

- Q. **LSP is partially working (e.g., no UnityEngine.InputSystem LSP support, or no
  LSP support for some imported modules).** What is the issue here?
- A. Are you using the [Microsoft.Unity.Analyzers][unity-analyzer] dll? If so, disable
  it and try again. Using the wrong version of a Roslyn analyzer can silently screw up
  the language server - make sure to test with different versions, or only use supported
  ones.

---

- Q. I do not see Neovim in the External Script Editor dropdown, what should I do?
- A0. Make sure that Neovim is on PATH under the name `nvim`. On Linux, make sure that
  `nvim` is appended to PATH for non-interactive shells - E.g., append PATH in `~/.profile`
  and NOT in `~/.bashrc`.
- A1. Explicitly provide the path to your nvim executable in `Neovim -> Settings`.
- A2. Try to re-import the whole Unity project (this happened to me once and re-importing
  somehow fixed it).


## Feedback

The objective for this guide and its related projects is to provide a rich
Neovim development experience for the Unity game engine. Any feedback is more
than welcome (especially regarding C# LSP details).

## References

There a lot of other resources/projects that can help you in improving your Unity Neovim
development experience:

- [roslyn.nvim][roslyn_nvim]: a well-maintained Roslyn LSP plugin for neovim (I advise you
  to use this rather than setting up your own Roslyn LS Lua config - it will save you a lot
  of headache).
- [lspconfig's Roslyn LS setup][roslyn_lspconfig]: a single .lua file for setting up Roslyn
  LS. I advise you to use the plugin [roslyn.nvim][roslyn_nvim] which provides a lot of
  additional features.
- [unity-ping.nvim][unity_ping]: sync active buffer to Unity Editor Project window
  (ping/select asset).
- [nvim-unity][nvim_unity]: Use Neovim as the default code editor for Unity — with .csproj
  generation, OmniSharp support and LSP-ready workflow.

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
[com_walcht_ide_neovim]: https://github.com/walcht/com.walcht.ide.neovim.git
[depracated_unity_debug]: https://github.com/Unity-Technologies/vscode-unity-debug
[stupid_license]: https://marketplace.visualstudio.com/items/VisualStudioToolsForUnity.vstuc/license
[unity_dap]: https://github.com/walcht/unity-dap
[cgnvim]: https://github.com/walcht/CGNvim
[cgnvim_unity_dap]: https://github.com/walcht/CGNvim/blob/master/lua/cgnvim/daps/unity.lua
[mono]: https://www.mono-project.com/download/stable/
[nvim-release-page]: https://github.com/neovim/neovim/blob/master/INSTALL.md
[#13]: https://github.com/walcht/neovim-unity/issues/13
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
[windows-wsl]: https://learn.microsoft.com/en-us/windows/wsl/networking
[nvim-roslyn-wsl-issue]: https://github.com/seblyng/roslyn.nvim/issues/266
[lspadapter-releases]: https://github.com/walcht/LSP-TCP-socket-adapter/releases
[lsp-ip-socket-adapter]: https://github.com/walcht/LSP-TCP-socket-adapter
[unity-analyzer-releases]: https://www.nuget.org/packages/Microsoft.Unity.Analyzers/1.19.0
[wsl-issue]: https://github.com/walcht/neovim-unity/issues/21
[roslyn]: https://github.com/dotnet/roslyn
[unity-analyzers]: https://github.com/microsoft/Microsoft.Unity.Analyzers
[cgnvim-cheatsheet]: https://github.com/walcht/CGNvim/releases
[unity-listening-debugger-port]: https://github.com/walcht/unity-listening-debug-port
[roslyn_nvim]: https://github.com/seblyng/roslyn.nvim
[roslyn_lspconfig]: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/roslyn_ls.lua
[unity_ping]: https://github.com/Rival/unity-ping.nvim
[nvim_unity]: https://github.com/apyra/nvim-unity
[cgnvim_roslyn_ls]: https://github.com/walcht/CGNvim/blob/master/lua/cgnvim/lsps/roslyn_ls.lua
