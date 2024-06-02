vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.scrolloff = 8 

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

-- Sync clipboard between OS and Neovim.
-- See `:h 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.cmd.colorscheme "catppuccin"
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
