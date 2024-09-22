# Navigation Links

## Key Bindings
- **Go back from link `Ctrl-o`**: 
  - Takes you back to your previous cursor position. 
  - This acts as a "go back" function after jumping to a different location (e.g., following a hyperlink or navigating to another file).

- **Go to link `Ctrl-i`**: 
  - Moves you forward to your next cursor position. 
  - This functions like a "go forward" option after you’ve gone back.

---

# Buffer Window Bindings

## Key Bindings
- **Maximize Height**: `Ctrl-_`
  - Maximizes the height of the current window, allowing it to fill the available vertical space.

- **Maximize Width**: `Ctrl-|`
  - Maximizes the width of the current window, enabling it to occupy the entire horizontal space.

# Vim API
- The **"Nvim API"** written in C for use in remote plugins and GUIs; see |api|.
These functions are accessed through `vim.api`.

- The **"Lua API"** written in and specifically for Lua. These are any other
functions accessible through `vim.*` not mentioned already; see |lua-stdlib|.

## vim command formats
- Vim commands can be represented in 2x ways, the first is cleaner:
```lua
vim.cmd.highlight({ "Error", "guibg=red" })
vim.cmd.highlight({ "link", "Warning", "Error" })

vim.cmd([[
  highlight Error guibg=red
  highlight link Warning Error
]])
```

# Funtion Wrapping: `function() end` in Lua

In Lua, `function() ... end` creates **anonymous functions**. These are useful for inline definitions, especially when passing functions as arguments (e.g., for Neovim key mappings).

```lua
vim.keymap.set('n', '<Leader>x', function() print("Hello, World!") end)
```

