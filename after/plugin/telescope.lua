local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pfh', function()
  builtin.find_files {
    hidden = true,
  }
end)
vim.keymap.set('n', '<leader>f', builtin.git_files, {})
vim.keymap.set('n', '<leader>st', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
vim.keymap.set('n', '<leader>psh', function()
  builtin.live_grep {
    additional_args = function()
      return { "--hidden" }
    end
  }
end)
vim.keymap.set('n', '<leader>b', builtin.buffers, {})

require('telescope').load_extension('projects')
