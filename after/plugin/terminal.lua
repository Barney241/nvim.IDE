-- Terminals via snacks.terminal (replaced toggleterm). Keymaps preserved.
-- Two independent horizontal zsh terminals + one plain :term.
local term_opts = { win = { position = 'bottom' } }

vim.keymap.set('n', '<leader>oo', function()
    Snacks.terminal.toggle('zsh', vim.tbl_extend('force', term_opts, { env = { LUPI_TERM = '1' } }))
end, { silent = true })

vim.keymap.set('n', '<leader>ot', function()
    Snacks.terminal.toggle('zsh', vim.tbl_extend('force', term_opts, { env = { LUPI_TERM = '2' } }))
end, { silent = true })

vim.keymap.set('n', '<leader>oT', '<cmd>term<CR>', { silent = true })
