-- General settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Enable line wrapping
vim.o.wrap = true
vim.o.showbreak = "↪ "
vim.o.textwidth = 80

-- Enable line wrapping
vim.o.wrap = true
vim.o.showbreak = "↪ "
vim.o.textwidth = 80

-- relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 20

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
-- vim.o.clipboard = ""
-- vim.opt.clipboard = "unnamedplus"

-- Unbind space in visual
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Unbind space in visual
-- vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ added keymaps for tmux-navigate]]
-- Set key mappings for navigation in Neovim
vim.api.nvim_set_keymap("n", "<M-h>", ':echo "Navigate Left"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-j>", ':echo "Navigate Down"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-k>", ':echo "Navigate Up"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-l>", ':echo "Navigate Right"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-\\>", ':echo "Navigate Back"<CR>', { noremap = true, silent = true })

-- [[ added keymaps ]]
-- Map <leader>xq to toggle the Trouble plugin with quickfix list
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })

-- Map - to open the parent directory using a plugin
vim.keymap.set("n", "-", "<CMD>lua require('mini.files').open()<CR>", { desc = "Open mini.files parent directory" })

-- Map - to open the parent directory using a plugin
vim.keymap.set("n", "+", "<CMD>Neotree toggle<CR>", { desc = "Open Neotree parent directory" })

-- Move selected lines in visual mode down one line and re-select the moved lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Move selected lines in visual mode up one line and re-select the moved lines
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join the current line with the next line, setting a mark at the original position for jumping back
vim.keymap.set("n", "J", "mzJ`z")

-- Scroll half-page down and center the cursor vertically
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Scroll half-page up and center the cursor vertically
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Jump to the next search result and center the cursor vertically
vim.keymap.set("n", "n", "nzzzv")

-- Jump to the previous search result and center the cursor vertically
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Map <leader>p to paste from the clipboard
vim.api.nvim_set_keymap("n", "<leader>p", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>p", '"+p', { noremap = true, silent = true })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- special delete
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- find under cursor and replace all in file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- markdown runnner
vim.keymap.set("n", "<leader>r", ":MarkdownRunner<CR>")
vim.keymap.set("n", "<leader>R", ":MarkdownRunnerInsert<CR>")

-- Telescope mapping
vim.keymap.set("n", "<leader>m", ":Telescope keymaps<CR>")
