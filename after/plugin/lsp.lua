-- Advertise blink.cmp completion capabilities to every server.
vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.enable('gopls')
vim.lsp.config('gopls', {
    settings = {
        gopls = {
            gofumpt = true
        }
    }
})
-- python lsp
vim.lsp.enable('pylsp')
vim.lsp.enable('ty')
vim.lsp.config('ty', {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { "ty.toml", "pyproject.toml", ".git" },
})

vim.lsp.enable('intelephense')
vim.lsp.config('intelephense', {
    cmd = {'intelephense', '--stdio'},
})

vim.lsp.enable('ts_ls')

vim.lsp.enable('zls')

vim.lsp.enable('nil_ls')
vim.lsp.config('nil_ls', {
  autostart = true,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

--haskell
vim.lsp.enable('hls')

-- lua (Neovim config dev; lazydev.nvim augments it with the vim.* API).
vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
        },
    },
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- Native replacement for lsp-zero's on_attach: run on every LspAttach.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lupi_lsp_attach', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "<leader>cd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "<leader>cD", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
        vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>cr", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
    end,
})


-- Completion: blink.cmp (replaced nvim-cmp + cmp-* + cmp_luasnip).
-- Keymaps preserved from the old nvim-cmp config:
--   <C-Space> open/toggle docs, <C-e> hide, <C-y>/<CR> accept,
--   <C-d>/<C-b> snippet jump fwd/back, <Tab>/<S-Tab> left unmapped.
require('blink.cmp').setup({
    enabled = function()
        return vim.bo[0].buftype ~= 'prompt'
    end,
    snippets = { preset = 'luasnip' },
    -- nix: use the Lua matcher so we don't need the prebuilt Rust binary.
    fuzzy = { implementation = 'lua' },
    keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-d>'] = { 'snippet_forward', 'fallback' },
        ['<C-b>'] = { 'snippet_backward', 'fallback' },
        -- <Tab>/<S-Tab> intentionally left unmapped (as before).
    },
    completion = {
        menu = { border = 'rounded' },
        documentation = { window = { border = 'rounded' } },
    },
    sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
            snippets = { min_keyword_length = 2 },
            buffer = { min_keyword_length = 3 },
        },
    },
})


local _diag_icons = ({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = ''
})


vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = _diag_icons.error,
            [vim.diagnostic.severity.WARN] = _diag_icons.warn,
            [vim.diagnostic.severity.HINT] = _diag_icons.hint,
            [vim.diagnostic.severity.INFO] = _diag_icons.info,
        },
    },
    underline = true,
    float = {
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})


-- See mason-null-ls.nvim's documentation for more details:
-- https://github.com/jay-babu/mason-null-ls.nvim#setup
require('mason-null-ls').setup({
    ensure_installed = { "jq" },
    automatic_installation = false, -- You can still set this to `true`
    handlers = {},
})

require('mason').setup({})
-- mason-lspconfig 2.x: `handlers`/`setup_handlers` removed. Servers are
-- configured/enabled directly via vim.lsp.enable()/vim.lsp.config() below.
require('mason-lspconfig').setup({
    -- lua_ls drives lazydev/config editing. Other servers (gopls, nil_ls, hls,
    -- intelephense, ...) are provided via nix; add them here to have mason
    -- manage them on a non-nix machine.
    ensure_installed = { 'lua_ls' },
})

-- Rust LSP setup
vim.lsp.enable('rust_analyzer')
vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                autoReload = true,
                features = "all",
                buildScripts = {
                    enable = true
                },
            },
            completion = {
                autoimport = {
                    enable = true,
                },
                postfix = {
                    enable = true,
                },
            },
            check = {
                features = "all",
            },
        }
    }
})
