vim.keymap.set("n", "<leader>p", vim.cmd.Ex)

vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Moving pg up/down or forward/backward in search will keep cursor centered.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("i", "kj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")

-- swap keys for goto begin/end of line:
vim.keymap.set("n", "0", "$")
vim.keymap.set("n", "$", "0")
vim.keymap.set("v", "0", "$")
vim.keymap.set("v", "$", "0")

-- Clear hightlight on search by pressing <Esc> in normal mode. 
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

