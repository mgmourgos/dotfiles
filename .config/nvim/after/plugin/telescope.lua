local builtin = require('telescope.builtin')
-- Search for all files
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- Search only for files in the current git repo
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- Search all files for a string
vim.keymap.set('n', '<leader>fs', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
