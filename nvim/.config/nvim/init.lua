-- options
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
vim.cmd([[let mapleader="\<SPACE>"]])

-- search
vim.o.smartcase = true
vim.o.ignorecase = true

-- Permanent undo
vim.o.undofile = true
vim.bo.undofile = true

-- plugins
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
end

require('packer').startup(function(use)
    -- general
    use 'wbthomason/packer.nvim'
    use 'folke/tokyonight.nvim'
    use { 'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        requires = {
            'nvim-treesitter/playground',
            'RRethy/nvim-treesitter-endwise',
            'nvim-treesitter/nvim-treesitter-context',
            'nvim-treesitter/nvim-treesitter-textobjects'
        }
    }
    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" }
        },
        config = function()
            require("telescope").load_extension("refactoring")

            vim.api.nvim_set_keymap(
                "v",
                "<leader>rr",
                "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
                { noremap = true }
            )
        end
    }
    use({
        "folke/noice.nvim",
        event = "VimEnter",
        config = function()
            require("noice").setup()
        end,
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    })
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {}
        end
    }
    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        local term = vim.o.shell
        if vim.fn.executable('fish') then
            term = vim.fn.exepath('fish')
        end
        require("toggleterm").setup({
            open_mapping = [[<C-\>]],
            direction = 'float',
            shell = term,
            winbar = {
                enabled = true,
            }
        })
    end }
    use { 'ggandor/leap.nvim',
        config = function()
            require('leap').add_default_mappings()
        end
    }

    -- lsp
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'nvim-lua/lsp-status.nvim'
    use 'neovim/nvim-lspconfig'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('gitsigns').setup()
        end
    }
    use {
        'romgrk/barbar.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', 'lewis6991/gitsigns.nvim' },
        config = function()
            -- keybinds
            vim.keymap.set("n", "<C-j>", "<cmd>BufferNext<cr>", { noremap = true })
            vim.keymap.set("n", "<C-k>", "<cmd>BufferPrevious<cr>", { noremap = true })
            vim.keymap.set("n", "<C-m>", "<cmd>BufferClose<cr>", { noremap = true })
        end
    }
    use {
        'hoob3rt/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            local getServers = function()
                local ret = ""
                local servers = vim.lsp.get_active_clients({
                    bufnr = vim.api.nvim_get_current_buf()
                })
                for i, j in ipairs(servers) do
                    if i == 1 then
                        ret = "[" .. j.name
                    else
                        ret = ret .. '|' .. j.name
                    end
                end
                if ret ~= "" then
                    ret = ret .. "]"
                end
                return ret
            end
            require('lualine').setup {
                options = {
                    theme = 'tokyonight'
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { { 'branch', icon = '' }, 'diff', { 'diagnostics', sources = { 'nvim_diagnostic' } } },
                    lualine_c = {
                        getServers,
                        {
                            'filename',
                            newfile_status = true,
                            path = 1, -- relative path
                        }
                    },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                extensions = { 'quickfix', 'nvim-tree', 'toggleterm' }
            }
        end
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = {
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzy-native.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            { 'LinArcX/telescope-env.nvim' }
        },
        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    },
                    ["fzy_native"] = {
                        override_generic_sorter = true,
                        override_file_sorter = true,
                    }
                }
            }
            require('telescope').load_extension('fzy_native')
            require("telescope").load_extension("ui-select")
            require('telescope').load_extension('env')
        end
    }
    use 'nvim-telescope/telescope-dap.nvim'
    use 'lambdalisue/gina.vim'
    use 'mboughaba/i3config.vim'
    use {
        'kyazdani42/nvim-tree.lua',
        requires = "kyazdani42/nvim-web-devicons",
    }
    use 'tjdevries/train.nvim'
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
                plugins = {
                    presets = {
                        -- disable since which-key doesn't respect timeout
                        -- when operater+num is entered
                        operators = false,
                    },
                }
            }
        end
    }
    use {
        "folke/lsp-trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {}
        end
    }
    use "folke/neodev.nvim"
    use { 'danymat/neogen',
        config = function()
            require('neogen').setup {}
        end,
        requires = "nvim-treesitter/nvim-treesitter",
    }
    use 'mfussenegger/nvim-dap'
    use { "norcalli/nvim-colorizer.lua",
        config = function()
            require 'colorizer'.setup()
        end
    }
    use { 'winston0410/range-highlight.nvim',
        requires = "winston0410/cmd-parser.nvim",
        config = function()
            require 'range-highlight'.setup {}
        end
    }
    use { 'simrat39/rust-tools.nvim' }
    use { "ellisonleao/glow.nvim", run = "GlowInstall" }
    use 'sindrets/diffview.nvim'
    use {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    }
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "windwp/nvim-autopairs",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "onsails/lspkind.nvim"
        },
        config = function()
            local cmp = require('cmp')
            local compare = require('cmp.config.compare')
            local luasnip = require('luasnip')
            -- supertab mapping from https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = "crates" },
                }, {
                    { name = 'buffer', keyword_length = 3 },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        if vim.tbl_contains({ 'path' }, entry.source.name) then
                            local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                            if icon then
                                vim_item.kind = icon
                                vim_item.kind_hl_group = hl_group
                                return vim_item
                            end
                        end
                        return require('lspkind').cmp_format({ with_text = false })(entry, vim_item)
                    end
                },
                sorting = {
                    comparators = {
                        compare.offset,
                        compare.exact,
                        compare.recently_used,
                        require("clangd_extensions.cmp_scores"),
                        compare.locality,
                        compare.kind,
                        compare.sort_text,
                        compare.length,
                        compare.order,
                    },
                },
            })
            cmp.setup.cmdline('/', {
                sources = cmp.config.sources({
                    { name = 'nvim_lsp_document_symbol' }
                }, {
                    { name = 'buffer' }
                })
            })
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
            require('nvim-autopairs').setup({
                disable_filetype = { "TelescopePrompt", "vim" },
                check_ts = true,
                ts_config = {
                    lua = { 'string' }, -- it will not add a pair on that treesitter node
                    javascript = { 'template_string' },
                    java = false, -- don't check treesitter on java
                },
                enable_moveright = false,
            })
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on('confirm_done',
                cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

        end
    }
    use { 'stevearc/dressing.nvim',
        config = function()
            require('dressing').setup({
                select = {
                    enabled = false
                }
            })
        end
    }
    use { 'p00f/clangd_extensions.nvim' }
    use 'b0o/schemastore.nvim'
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)

-- syntax and colors
vim.cmd [[colorscheme tokyonight-moon]]

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
    end,
})

require 'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    },
    incremental_selection = {
        enable = true,
    },
    keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
    },
    playground = {
        enable = true,
        persist_queries = true,
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
    },
    endwise = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = true,
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        lsp_interop = {
            enable = true,
            border = 'none',
            peek_definition_code = {
                ["<leader>df"] = "@function.outer",
                ["<leader>dF"] = "@class.outer",
            },
        },
    },
}

require 'treesitter-context'.setup {
    patterns = {
        c = {
            'struct',
            'enum'
        },
        cpp = {
            'struct',
            'enum'
        }
    }
}

-- nvim-tree
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { noremap = true })

-- telescope
local builtin = require('telescope.builtin')
local wk = require("which-key")
wk.register({
    f = {
        name = "find",
        f = { builtin.find_files, "Files" },
        g = { builtin.live_grep, "Live Grep" },
        b = { builtin.buffers, "Buffers" },
        h = { builtin.help_tags, "Help Tags" },
        s = { builtin.lsp_document_symbols, "LSPDocSym" },
        a = { builtin.lsp_workspace_symbols, "LspWorkSym" },
    },
}, { prefix = "<leader>" })

-- lsp
require("mason").setup()
require("mason-lspconfig").setup()

local nvim_lsp = require('lspconfig')
local rt = require("rust-tools")
local lsp_status = require('lsp-status')
lsp_status.config {
    diagnostics = false
}
lsp_status.register_progress()

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

wk.register({
    d = {
        name = "diag",
        e = { vim.diagnostic.open_float, "open" },
        q = { vim.diagnostic.setloclist, "setloclist" },
    },
}, { prefix = "<leader>" })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", builtin.lsp_definitions, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", builtin.lsp_implementations, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<space>D", builtin.lsp_type_definitions, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", builtin.lsp_references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

    -- Hover actions
    vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
    -- Code action groups
    vim.keymap.set("n", "<Leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })

    if client.server_capabilities.documentRangeFormattingProvider then
        vim.keymap.set("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
        })
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = 'lsp_document_highlight',
        })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()
    lsp_status.on_attach(client)
end

require("neodev").setup({})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

local servers = { "pyright", "yamlls", "bashls", "cmake", "dockerls", "lua_ls", "clangd", "gopls"}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end
require('lspconfig').jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
        },
    },
}

rt.setup {
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                },
            }
        },
    },
}

