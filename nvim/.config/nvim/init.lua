-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.shell = '/bin/bash'
vim.o.completeopt = "menu,menuone,noselect"
vim.o.mouse = 'a'
vim.o.termguicolors = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.tabstop = 4
vim.cmd('set clipboard=unnamed,unnamedplus')

-- search
vim.o.smartcase = true
vim.o.ignorecase = true

-- Permanent undo
vim.o.undofile = true
vim.bo.undofile = true

-- diagnostics
vim.diagnostic.config({ virtual_lines = true, severity_sort = true })

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "folke/tokyonight.nvim",
            lazy = false,    -- make sure we load this during startup if it is your main colorscheme
            priority = 1000, -- make sure to load this before all the other start plugins
            config = function()
                -- load the colorscheme here
                vim.cmd([[colorscheme tokyonight]])
            end,
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                vim.api.nvim_create_autocmd('LspAttach', {
                    callback = function(args)
                        local client_id = args.data.client_id
                        local client = assert(vim.lsp.get_client_by_id(client_id))
                        if client.server_capabilities.inlayHintProvider then
                            vim.lsp.inlay_hint.enable(true, { client_id = client_id })
                        end
                    end,
                })

                vim.lsp.config('lua_ls', {
                    -- Server-specific settings. See `:help lsp-quickstart`
                    settings = {
                        Lua = {
                            runtime = {
                                -- Neovim uses LuaJIT
                                version = "LuaJIT",
                            },

                            diagnostics = {
                                -- Get rid of "undefined global 'vim'"
                                globals = { "vim", "Snacks" },
                            },

                            workspace = {
                                -- Make the server aware of Neovim runtime files
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                        },
                    },
                })
                vim.lsp.config('clangd', {
                    cmd = {
                        "clangd",
                        "--header-insertion=never",
                        "--query-driver=**",
                        "--background-index",
                        "--clang-tidy",
                        "--function-arg-placeholders=1",
                        "--completion-style=detailed",
                        "-j",
                        "16",
                        "--pch-storage=memory",
                    },
                })
                vim.lsp.enable('clangd')
                local servers = { "ty", "yamlls", "bashls", "neocmake", "dockerls", "lua_ls", "clangd", "vtsls" }
                for _, lsp in ipairs(servers) do
                    vim.lsp.enable(lsp)
                end
                vim.lsp.config('rust-analyzer', {
                    settings = {
                        ['rust-analyzer'] = {
                            check = {
                                overrideCommand = {
                                    "make",
                                    "-j16",
                                    "LLVM=1",
                                    "ARCH=arm64",
                                    "CLIPPY=1",
                                    "KRUSTFLAGS=--error-format=json",
                                },
                            },
                            checkOnSave = true
                        }
                    }
                })
            end,
            keys = {
                { "<leader>lf", function() vim.lsp.buf.format() end,      desc = "Format buffer" },
                { "gd",         function() vim.lsp.buf.definition() end,  desc = "Goto Definition" },
                { "gD",         function() vim.lsp.buf.declaration() end, desc = "Goto Declaration" },
            },
            lazy = false
        },
        {
            'saghen/blink.cmp',
            dependencies = { 'rafamadriz/friendly-snippets' },
            version = '1.*',
            ---@module 'blink.cmp'
            opts = {
                keymap = { preset = 'super-tab' },
                -- Default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, due to `opts_extend`
                sources = {
                    default = { 'lsp', 'path', 'snippets', 'buffer' },
                },
                signature = { enabled = true }
            },
            opts_extend = { "sources.default" }
        },
        { 'p00f/clangd_extensions.nvim' },
        {
            'mrcjkb/rustaceanvim',
            version = '^7', -- Recommended
            lazy = false,   -- This plugin is already lazy
        },
        {
            "folke/snacks.nvim",
            ---@type snacks.Config
            opts = {
                picker = {
                    -- your picker configuration comes here
                    -- or leave it empty to use the default settings
                    -- refer to the configuration section below
                }
            },
            keys = {
                -- Top Pickers & Explorer
                { "<leader><space>", function() Snacks.picker.smart() end,           desc = "Smart Find Files" },
                { "<leader>,",       function() Snacks.picker.buffers() end,         desc = "Buffers" },
                { "<leader>/",       function() Snacks.picker.grep() end,            desc = "Grep" },
                { "<leader>:",       function() Snacks.picker.command_history() end, desc = "Command History" },
                -- find
                { "<leader>ff",      function() Snacks.picker.files() end,           desc = "Find Files" },
                -- git
                { "<leader>gb",      function() Snacks.picker.git_branches() end,    desc = "Git Branches" },
                { "<leader>gl",      function() Snacks.picker.git_log() end,         desc = "Git Log" },
                { "<leader>gL",      function() Snacks.picker.git_log_line() end,    desc = "Git Log Line" },
                { "<leader>gs",      function() Snacks.picker.git_status() end,      desc = "Git Status" },
                { "<leader>gS",      function() Snacks.picker.git_stash() end,       desc = "Git Stash" },
                { "<leader>gd",      function() Snacks.picker.git_diff() end,        desc = "Git Diff (Hunks)" },
                { "<leader>gf",      function() Snacks.picker.git_log_file() end,    desc = "Git Log File" },
                { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,     desc = "LSP Symbols" },
            },
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons', 'linrongbin16/lsp-progress.nvim' },
            opts = {

            },
            config = function()
                require("lsp-progress").setup({
                    client_format = function(client_name, spinner, series_messages)
                        if #series_messages == 0 then
                            return nil
                        end
                        return {
                            name = client_name,
                            body = spinner .. " " .. table.concat(series_messages, ", "),
                        }
                    end,
                    format = function(client_messages)
                        --- @param name string
                        --- @param msg string?
                        --- @return string
                        local function stringify(name, msg)
                            return msg and string.format("%s %s", name, msg) or name
                        end

                        local sign = "" -- nf-fa-gear \uf013
                        local lsp_clients = vim.lsp.get_clients()
                        local messages_map = {}
                        for _, climsg in ipairs(client_messages) do
                            messages_map[climsg.name] = climsg.body
                        end

                        if #lsp_clients > 0 then
                            table.sort(lsp_clients, function(a, b)
                                return a.name < b.name
                            end)
                            local builder = {}
                            for _, cli in ipairs(lsp_clients) do
                                if
                                    type(cli) == "table"
                                    and type(cli.name) == "string"
                                    and string.len(cli.name) > 0
                                then
                                    if messages_map[cli.name] then
                                        table.insert(
                                            builder,
                                            stringify(cli.name, messages_map[cli.name])
                                        )
                                    else
                                        table.insert(builder, stringify(cli.name))
                                    end
                                end
                            end
                            if #builder > 0 then
                                return sign .. " " .. table.concat(builder, ", ")
                            end
                        end
                        return ""
                    end,
                })
                require('lualine').setup({
                    options = {
                        theme = 'tokyonight',
                    },
                    sections = {
                        lualine_c = {
                            function()
                                -- invoke `progress` here.
                                return require('lsp-progress').progress()
                            end,
                            {
                                'filename',
                                newfile_status = true,
                                path = 1 -- relative path
                            }
                        }
                    }
                })
                -- listen lsp-progress event and refresh lualine
                vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
                vim.api.nvim_create_autocmd("User", {
                    group = "lualine_augroup",
                    pattern = "LspProgressStatusUpdated",
                    callback = require("lualine").refresh,
                })
            end
        },
        {
            'romgrk/barbar.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons', 'lewis6991/gitsigns.nvim' },
            config = function()
                -- keybinds
                vim.keymap.set("n", "<C-j>", "<cmd>BufferNext<cr>", { noremap = true })
                vim.keymap.set("n", "<C-k>", "<cmd>BufferPrevious<cr>", { noremap = true })
                vim.keymap.set("n", "<C-n>", "<cmd>BufferClose<cr>", { noremap = true })
            end
        },
        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            config = true,
            opts = {
                check_ts = true
            }
        },
        {
            "mason-org/mason.nvim",
        },
        {
            'nvim-treesitter/nvim-treesitter',
            lazy = false,
            build = ':TSUpdate',
            dependencies = { "Hdoc1509/gh-actions.nvim" },
            config = function()
                require("gh-actions.tree-sitter").setup()
                require('nvim-treesitter').install({ 'stable', 'unstable', 'gh_actions_expressions' })
            end
        },
        {
            "OXY2DEV/markview.nvim",
            lazy = false,
            dependencies = { "saghen/blink.cmp" },
        },
        {
            "kylechui/nvim-surround",
            version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
            event = "VeryLazy",
            opts = {}
        },
        {
            'fei6409/log-highlight.nvim',
            opts = {},
        },
        {
            'MagicDuck/grug-far.nvim',
            opts = {},
            lazy = false
        },
        {
            'stevearc/oil.nvim',
            ---@module 'oil'
            ---@type oil.SetupOpts
            opts = {},
            -- Optional dependencies
            dependencies = { { "nvim-mini/mini.icons", opts = {} } },
            lazy = false,
        },
        {
            'saecki/crates.nvim',
            tag = 'stable',
            opts = {}
        },
        {
            "NeogitOrg/neogit",
            lazy = true,
            dependencies = {
                "nvim-lua/plenary.nvim",  -- required
                "sindrets/diffview.nvim", -- optional - Diff integration
                "folke/snacks.nvim",      -- optional
            },
            cmd = "Neogit",
            keys = {
                { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
            }
        },
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {},
            keys = {
                {
                    "<leader>?",
                    function()
                        require("which-key").show({ global = false })
                    end,
                    desc = "Buffer Local Keymaps (which-key)",
                },
            },
        },
        {
            "jake-stewart/multicursor.nvim",
            branch = "1.0",
            config = function()
                local mc = require("multicursor-nvim")
                mc.setup()

                local set = vim.keymap.set

                -- Add or skip cursor above/below the main cursor.
                set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
                set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
                set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
                set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

                -- Add or skip adding a new cursor by matching word/selection
                set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end)
                set({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end)
                set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end)
                set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end)

                -- Add and remove cursors with control + left click.
                set("n", "<c-leftmouse>", mc.handleMouse)
                set("n", "<c-leftdrag>", mc.handleMouseDrag)
                set("n", "<c-leftrelease>", mc.handleMouseRelease)

                -- Disable and enable cursors.
                set({ "n", "x" }, "<c-q>", mc.toggleCursor)

                -- Mappings defined in a keymap layer only apply when there are
                -- multiple cursors. This lets you have overlapping mappings.
                mc.addKeymapLayer(function(layerSet)
                    -- Select a different cursor as the main one.
                    layerSet({ "n", "x" }, "<left>", mc.prevCursor)
                    layerSet({ "n", "x" }, "<right>", mc.nextCursor)

                    -- Delete the main cursor.
                    layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

                    -- Enable and clear cursors using escape.
                    layerSet("n", "<esc>", function()
                        if not mc.cursorsEnabled() then
                            mc.enableCursors()
                        else
                            mc.clearCursors()
                        end
                    end)
                end)

                -- Customize how cursors look.
                local hl = vim.api.nvim_set_hl
                hl(0, "MultiCursorCursor", { reverse = true })
                hl(0, "MultiCursorVisual", { link = "Visual" })
                hl(0, "MultiCursorSign", { link = "SignColumn" })
                hl(0, "MultiCursorMatchPreview", { link = "Search" })
                hl(0, "MultiCursorDisabledCursor", { reverse = true })
                hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
                hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
            end
        },
        {
            'numToStr/Comment.nvim',
            opts = {}
        }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
