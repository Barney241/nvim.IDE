-- lazy.nvim plugin manager (migrated from packer)
-- NOTE: leader keys are set in lupi.remap, required before this file.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Dashboard banner: clean ANSI-shadow NVIM logo (box-drawing, alignment-safe).
local dashboard_header = table.concat({
    "",
    "███╗   ██╗ ██╗   ██╗ ██╗ ███╗   ███╗",
    "████╗  ██║ ██║   ██║ ██║ ████╗ ████║",
    "██╔██╗ ██║ ██║   ██║ ██║ ██╔████╔██║",
    "██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
    "██║ ╚████║  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
    "",
}, "\n")

require("lazy").setup({
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        config = function()
            require("rose-pine").setup({
                dark_variant = 'main',
                disable_background = true,
                disable_float_background = true,
            })
        end,
    },

    -- main branch: the rewrite required for Neovim 0.12+ (master is locked to
    -- 0.11). Needs tree-sitter CLI + C compiler. Does not support lazy-loading.
    -- Config (parser install + highlight) lives in after/plugin/treesitter.lua.
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
    },

    'nvim-lua/plenary.nvim',

    'mfussenegger/nvim-jdtls',

    'mbbill/undotree',
    'nvim-lualine/lualine.nvim', -- Fancier statusline

    -- LSP stack (formerly bundled under lsp-zero, now native:
    -- see after/plugin/lsp.lua using vim.lsp.config/enable directly).
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    -- Lua dev: completion/types for the Neovim API when editing config.
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },

    -- Completion engine (replaced the nvim-cmp + cmp-* stack).
    -- Config lives in after/plugin/lsp.lua. NOTE (nix): we use the Lua fuzzy
    -- matcher to avoid the prebuilt Rust binary, which won't run on NixOS.
    {
        'saghen/blink.cmp',
        -- blink v2 split its core into blink.lib (required).
        dependencies = { 'saghen/blink.lib', 'L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets' },
    },

    'stevearc/conform.nvim',

    {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        dependencies = { 'rafamadriz/friendly-snippets' },
    },

    'nvim-tree/nvim-web-devicons',

    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    },
    'navarasu/onedark.nvim',
    {
        'RRethy/vim-illuminate',
        config = function()
            -- Drop the `treesitter` provider: nvim-treesitter master branch's
            -- locals.lua uses a TSNode API broken on nvim 0.12.
            require('illuminate').configure({
                providers = { 'lsp', 'regex' },
            })
        end,
    },
    {
        'windwp/nvim-autopairs',
        config = function() require("nvim-autopairs").setup {} end,
    },
    {
        'ahmedkhalf/project.nvim',
        config = function()
            require("project_nvim").setup {
                ignore_lsp = { "sumneko_lua", "terraformls" },
                detection_methods = { "pattern", "lsp" },
            }
        end,
    },

    -- Keymap discovery popup.
    { 'folke/which-key.nvim', event = 'VeryLazy', opts = {} },

    'eandrju/cellular-automaton.nvim',
    'mfussenegger/nvim-dap',
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    },
    'jay-babu/mason-null-ls.nvim',
    'nvimtools/none-ls.nvim',
    {
        'aserowy/tmux.nvim',
        config = function()
            return require("tmux").setup({
                redirect_to_clipboard = true,
            })
        end,
    },
    'ray-x/go.nvim',
    'ray-x/guihua.lua',
    'robertbasic/vim-hugo-helper',
    'mbledkowski/neuleetcode.vim',
    'smithbm2316/centerpad.nvim',

    -- templ parser is bundled in nvim-treesitter main (`:TSInstall templ`),
    -- so the standalone tree-sitter-templ plugin is no longer needed.

    {
        'akinsho/flutter-tools.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- vim.ui.select is handled by snacks.input/picker now (was dressing).
        },
    },

    'mfussenegger/nvim-lint',

    -- snacks: picker (was telescope), explorer (was nvim-tree), dashboard
    -- (was alpha), terminal (was toggleterm), input (was dressing), plus extras.
    {
        'folke/snacks.nvim',
        config = function()
            require("snacks").setup({
                bigfile = { enabled = true },
                indent = { enabled = true },
                input = { enabled = true },
                notifier = { enabled = true },
                quickfile = { enabled = true },
                scope = { enabled = true },
                words = { enabled = true },
                picker = { enabled = true },
                explorer = { enabled = true },
                dashboard = {
                    enabled = true,
                    preset = {
                        header = dashboard_header,
                        keys = {
                            { icon = " ", key = "f", desc = "Find File", action = function() Snacks.picker.files() end },
                            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                            { icon = " ", key = "p", desc = "Projects", action = function() Snacks.picker.projects() end },
                            { icon = " ", key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
                            { icon = " ", key = "t", desc = "Find Text", action = function() Snacks.picker.grep() end },
                            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                        },
                    },
                    -- Centered layout with dynamic, live-updating sections.
                    sections = {
                        { section = "header" },
                        { section = "keys", gap = 1, padding = 1 },
                        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                        { section = "startup" },
                    },
                },
            })
        end,
    },

    {
        'coder/claudecode.nvim',
        dependencies = { 'folke/snacks.nvim' },
    },

    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        ft = { 'markdown', 'codecompanion' },
        config = function()
            require('render-markdown').setup({})
        end,
    },
}, {
    -- lazy.nvim options
    install = { colorscheme = { 'rose-pine', 'habamax' } },
    checker = { enabled = false },
})
