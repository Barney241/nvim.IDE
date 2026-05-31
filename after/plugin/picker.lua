-- Pickers via snacks.picker (replaced telescope). Keymaps preserved.
local pick = Snacks.picker

vim.keymap.set('n', '<leader>pf', function() pick.files() end)
vim.keymap.set('n', '<leader>pfh', function() pick.files({ hidden = true }) end)
vim.keymap.set('n', '<leader>f', function() pick.git_files() end)
vim.keymap.set('n', '<leader>st', function()
    pick.grep({ search = vim.fn.input("Grep > "), live = false })
end)
vim.keymap.set('n', '<leader>ps', function() pick.grep() end)
vim.keymap.set('n', '<leader>psh', function() pick.grep({ hidden = true }) end)
vim.keymap.set('n', '<leader>b', function() pick.buffers() end)
