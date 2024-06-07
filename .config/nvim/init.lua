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

vim.keymap.set("n", "<leader>p", vim.cmd.Ex)

-- Highlight a line and press ctrl+j/k to move them:
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Moving pg up/down or forward/backward in search will keep cursor centered.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remap ctrl-j/k to be the same as d/u
vim.keymap.set("n", "<C-j>", "<C-d>zz")
vim.keymap.set("n", "<C-k>", "<C-u>zz")

vim.keymap.set("i", "kj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")

-- Format the entire file
vim.keymap.set("n", "<leader>q", "<cmd>:lua vim.lsp.buf.format()<CR>")

-- Clear hightlight on search by pressing <Esc> in normal mode. 
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable autometic comment insertion",
  group = vim.api.nvim_create_augroup("AutoComment", {}),
  callback = function ()
    -- Disable auto commenting when opening a newline
    -- see ":h fo-table"
    vim.opt_local.formatoptions:remove({ "o", "r" })
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    -- "catppuccin/nvim",
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    init = function ()
      --vim.cmd.colorscheme "catppuccin-mocha"
      vim.cmd.colorscheme "kanagawa"
    end,
  },

  "ThePrimeagen/vim-be-good",

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 999,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      cmp.setup {
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-j>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-k>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-Space>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-y>'] = cmp.mapping.complete {},

        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
	ensure_installed = { "cpp", "c", "lua", "vim", "vimdoc", "javascript", "html" },
	sync_install = false,
	highlight = { enable = true },
	-- This indent broke newline indenting in .h files:
	-- indent = { enable = true },
      })
    end
  },

  -- TODO install ripgrep
  {
   'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  'tpope/vim-sleuth',
  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeoutlen = 500
    end,
    opts = {}
  },

  {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.surround').setup()
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup{
        sections = {
          lualine_a = {
            -- Show the relative filepath
            {'filename',
              path = 1
            }
          }
        }
      }
    end,
  },
  {
    'm4xshen/autoclose.nvim',
    config = function()
      require('autoclose').setup()
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require('gitsigns').setup{
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('next')
            end
          end, {desc = "Goto Next Hunk"})

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              gitsigns.nav_hunk('prev')
            end
          end, {desc = "Goto Prev Hunk"})

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk, {desc = "Stage Hunk"})
          map('n', '<leader>hr', gitsigns.reset_hunk, {desc = "Reset Hunk"})
          map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<leader>hS', gitsigns.stage_buffer, {desc = "Stage Buffer"})
          map('n', '<leader>hu', gitsigns.undo_stage_hunk, {desc = "Undo Stage Hunk"})
          map('n', '<leader>hR', gitsigns.reset_buffer, {desc = "Reset Buffer"})
          map('n', '<leader>hp', gitsigns.preview_hunk, {desc = "Preview Hunk"})
          map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end, {desc = "Blame line full"})
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame, {desc = "Toggle Current Line Blame"})
          map('n', '<leader>hd', gitsigns.diffthis, {desc = "Diffthis"})
          map('n', '<leader>hD', function() gitsigns.diffthis('~') end, {desc = "Diffthis ~"})
          map('n', '<leader>td', gitsigns.toggle_deleted, {desc = "Toggle Deleted"})

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end,
  },
}, opts)

local on_attach = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Disable the lsp semantic hightlighting which was sometimes overwriting the
  -- initial hightlighting done by treesitter.
  -- client.server_capabilities.semanticTokensProvider = nil

  -- Mappings.
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  --vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
  --
  vim.keymap.set('n', '<leader>o', "<cmd>:ClangdSwitchSourceHeader<CR>", { desc = "Toggle Header/Source"})
end

require'lspconfig'.clangd.setup{
  cmd = {
    "clangd",
    "--compile-commands-dir=/usr/local/google/home/mmourgos/chromium/src",
    "--background-index",
    --"--chrome-remote-index=true",
    "-log=verbose",
  },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  end,
  on_attach = on_attach,
}

-- Bind "Neovim LSP Pickers" using telescope funcions which seems better than the neovim lsp defaults.
  -- Bind reference finder to cover advanced cases like inheritance
vim.keymap.set('n', 'gl', "<cmd>:lua require'telescope.builtin'.lsp_implementations{}<CR>")
vim.keymap.set('n', 'gr', "<cmd>:lua require'telescope.builtin'.lsp_references{}<CR>")
vim.keymap.set('n', 'gd', "<cmd>:lua require'telescope.builtin'.lsp_definitions{}<CR>")
--vim.keymap.set("n", "", "<cmd>:lua vim.lsp.buf.format()<CR>")

local builtin = require('telescope.builtin')
-- Search for all files
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find All Files"})

-- Search only for files in the current git repo
-- vim.keymap.set('n', '<C-p>', builtin.git_files, {}, { desc = "Find in Repo"})
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "Find in Git Repo"})


-- Search all files for a string
vim.keymap.set('n', '<leader>fs', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }); end, { desc = "Search all files for string"})
