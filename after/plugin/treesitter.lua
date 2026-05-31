-- nvim-treesitter MAIN branch API (Neovim 0.12+).
-- master-branch `require('nvim-treesitter.configs').setup{}` no longer exists.

local ts = require('nvim-treesitter')

-- Parsers to keep installed. install() is async and a no-op if already present.
-- templ is bundled in main (no custom parser config needed).
-- markdown + markdown_inline are required by render-markdown.nvim.
ts.install({
    'javascript', 'typescript', 'tsx', 'c', 'lua', 'rust', 'go', 'gomod',
    'python', 'templ', 'markdown', 'markdown_inline', 'bash', 'json', 'yaml',
    'vimdoc',
})

-- Highlighting is NOT automatic on main: start it per buffer on FileType.
-- Injections (e.g. markdown -> markdown_inline) work once highlight is on.
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('lupi_treesitter', { clear = true }),
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if lang and vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
        end
    end,
})
