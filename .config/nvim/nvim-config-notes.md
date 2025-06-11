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

# Neovim Autocommand Events: `'BufNewFile'` and `'BufRead'`

In Neovim, autocommands can be triggered by specific events. Two common events are:

- **`'BufNewFile'`**: 
  - This event is triggered when a new buffer (file) is created. 
  - It occurs before the buffer is opened for editing. 
  - Useful for setting options or performing actions specific to new files.

- **`'BufRead'`**: 
  - This event is triggered when an existing buffer (file) is opened.
  - It occurs after the buffer is loaded but before it is displayed.
  - Useful for setting options or performing actions specific to files being read.

## Example Usage
You can use these events to set specific configurations for different file types:

```lua
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.txt',
  command = 'setlocal number',  -- Example: Show line numbers for .txt files
})
```
# Created user commands

```lua
vim.api.nvim_create_user_command('Upper',
  function(opts)
    print(string.upper(opts.fargs[1]))  -- Converts the first argument to uppercase
  end,
  { nargs = 1 })  -- Requires one argument

vim.cmd.Upper('foo')  -- This will output: FOO
```

```lua
vim.api.nvim_create_user_command('SayHello',
  function(opts)
    local name = opts.fargs[1] or "World"  -- Get the first argument or default to "World"
    print("Hello, " .. name .. "!")
  end,
  { nargs = 1 })  -- Requires one argument
```

```lua
--- Example Usage
Here’s how you might use opts in a user command:

vim.api.nvim_create_user_command('SayHello',
  function(opts)
    local name = opts.fargs[1] or "World"  -- Get the first argument or default to "World"
    print("Hello, " .. name .. "!")
  end,
  { nargs = 1 })  -- Requires one argument
--- In this example, when you run :SayHello Alice, the function will output "Hello, Alice!". If you run :SayHello, it will default to "Hello, World!" because opts.fargs[1] is nil.
```

# Lua script for nvim
- **`vim.cmd`** : For running Vimscript commands.
- **`vim.g`** : For setting/getting global variables.
- **`vim.opt`** : For configuring Vim options in a Lua-friendly way.

# Indent text
- Use '>' or '<' to indent or unindent text.
