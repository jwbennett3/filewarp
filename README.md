# FileWarp

FileWarp is a file explorer and navigation tool for Neovim that provides a modern, efficient way to browse and manage files in your project. It integrates seamlessly with Neovim's terminal functionality and offers both graphical and console-based navigation modes.

## Features

- Terminal-based file navigation with fzf integration
- Multi-panel support for file exploration
- Preview capabilities for files and directories
- Integration with Neovim's terminal and buffer systems
- Support for different navigation modes (normal, insert)
- Cross-platform compatibility through chroot container builds

## Installation

### Prerequisites
- Neovim 0.6+
- fzf
- bash

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/your-repo/filewarp.git
```

2. Add to your Neovim configuration:
```lua
local filewarp = require('filewarp')
filewarp.start()
```

## Usage

### Basic Navigation
- Open FileWarp with `filewarp` command in terminal or through Neovim
- Navigate using standard keyboard controls
- Select files to open them in your editor
- Use Preview feature for file content inspection

### Key Bindings
- `t` - Exit insert mode and return to normal mode
- `'` - Switch to command line mode 
- `!` - Execute commands from terminal
- `Ctrl-e`, `Ctrl-s` - Navigate through command history
- `Alt-e`, `Alt-i` - Move cursor in command line

## Configuration

FileWarp can be customized through the following options:

```lua
filewarp.start({
    panel = 'left',           -- Panel position (left/right)
    num_panes = 1,            -- Number of panes to display
    left_preview = 0,         -- Enable left preview
    right_preview = 0,        -- Enable right preview
    mypid = vim.fn.getpid(),  -- Process ID for session tracking
    curr_dir = vim.fn.getcwd(), -- Current directory 
    mode = 'normal',          -- Navigation mode (normal/insert)
    context = '',             -- Context identifier
    on_exit = ''              -- Action on exit
})
```

## Architecture

The project consists of:

- Bash scripts for terminal integration and navigation (`filewarp`, `filewarpWrap`)
- Lua modules for Neovim integration (`init.lua`, `lua-dev/filewarp/`)
- Terminal-based file explorer using fzf (`fzfnav2`)
- Build scripts for containerized deployment (`build-container.sh`)

## Build Process

FileWarp can be built as a chroot container for cross-platform compatibility:

```bash
./build-container.sh
```

This creates a portable environment with all dependencies needed for file browsing.

## Requirements

- Bash 4+
- fzf with terminal support
- Neovim with lua support
- Properly configured environment variables (FILE_WARP_TMP_PATH)

## License

This project is licensed under the MIT License.