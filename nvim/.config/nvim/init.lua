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
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
    -- general
    use 'wbthomason/packer.nvim'
    use 'bluz71/vim-nightfly-guicolors'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/playground'

    -- lsp
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
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function()
            -- keybinds
            vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>BufferNext<cr>", {noremap = true})
            vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>BufferPrevious<cr>", {noremap = true})
            vim.api.nvim_set_keymap("n", "<C-m>", "<cmd>BufferClose<cr>", {noremap = true})
            vim.cmd([[let bufferline = get(g:, 'bufferline', {})]])
            vim.cmd('let bufferline.auto_hide = v:true')
        end
    }
    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function()
            require('lualine').setup{
                options = {
                    theme = 'nightfly',
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {{'branch', icon = ''}, 'diff', {'diagnostics', sources = {'nvim_diagnostic'}} },
                    lualine_c = {'filename', GetLspMessages},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'},
                },
                inactive_sections = {
                    lualine_a = {  },
                    lualine_b = {  },
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {  },
                    lualine_z = {  }
                },
            }
        end
    }
    use 'b3nj5m1n/kommentary'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/popup.nvim'},
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzy-native.nvim'}
        },
        config = function()
            require('telescope').load_extension('fzy_native')
        end
    }
    use 'nvim-telescope/telescope-dap.nvim'
    use 'lambdalisue/gina.vim'
    use 'mboughaba/i3config.vim'
    use 'ntpeters/vim-better-whitespace'
    use {
        'kyazdani42/nvim-tree.lua',
        requires = "kyazdani42/nvim-web-devicons",
    }
    use 'tjdevries/train.nvim'
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {}
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
    use {'kkoomen/vim-doge', run = ':call doge#install()'}
    use 'ray-x/lsp_signature.nvim'
    use 'mfussenegger/nvim-dap'
    use {"norcalli/nvim-colorizer.lua",
        config = function()
            require'colorizer'.setup()
        end
    }
    use {'winston0410/range-highlight.nvim',
        requires = "winston0410/cmd-parser.nvim",
        config = function()
            require'range-highlight'.setup{}
        end
    }
    use {'simrat39/rust-tools.nvim'}
    use {"ellisonleao/glow.nvim", run = "GlowInstall"}
    use 'sindrets/diffview.nvim'
    use {
        'saecki/crates.nvim',
        tag = 'v0.1.0',
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
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "windwp/nvim-autopairs",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require('cmp')
            local types = require('cmp.types')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                preselect = types.cmp.PreselectMode.None,
                mapping = {
                    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = "crates" },
                })
            })
            cmp.setup.cmdline('/', {
                sources = {
                    { name = 'buffer' }
                }
            })
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                        { name = 'cmdline' }
                    })
            })
            require('nvim-autopairs').setup({
                disable_filetype = { "TelescopePrompt" , "vim" },
            })
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on( 'confirm_done',
                cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

        end
    }
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)

-- syntax and colors
vim.cmd('colorscheme nightfly')

require'nvim-treesitter.configs'.setup {
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
        lint_events = {"BufWrite", "CursorHold"},
    },
}

-- nvim-tree
vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", {noremap = true})

-- telescope
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fs", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fa", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", {noremap = true})

-- lsp
local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

    if client.server_capabilities.documentRangeFormattingProvider then
        vim.keymap.set("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    vim.api.nvim_create_augroup('lsp_document_highlight', {
        clear = false
    })
    vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = 'lsp_document_highlight',
    })
    if client.server_capabilities.documentHighlightProvider then
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

    lsp_status.on_attach(client)
end

require'lsp_signature'.setup({})
require("neodev").setup({})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

local servers = { "pyright", "jsonls", "yamlls", "bashls", "cmake", "dockerls", "sumneko_lua"}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

nvim_lsp.clangd.setup({
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
    on_attach = on_attach,
    capabilities = capabilities
})

require('rust-tools').setup{
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

local spinner_frames = { '⣷', '⣯', '⣟', '⡿', '⢿', '⣻', '⣾', '⣽'}
GetLspMessages = function()
    local buf_messages = lsp_status.messages()
    local msgs = {}
    local last
    for _, msg in ipairs(buf_messages) do
        local name = msg.name
        local client_name = '[' .. name .. ']'
        local contents
        if msg.progress then
            contents = msg.title
            if msg.message then contents = contents .. ' ' .. msg.message end

            if msg.percentage then contents = contents .. ' (' .. msg.percentage .. ')' end
            if msg.spinner then
                contents = spinner_frames[(msg.spinner % #spinner_frames) + 1] .. ' ' ..
                contents
            end
        elseif msg.status then
            contents = msg.content
            if msg.uri then
                local filename = vim.uri_to_fname(msg.uri)
                filename = vim.fn.fnamemodify(filename, ':~:.')
                local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
                if #filename > space then filename = vim.fn.pathshorten(filename) end

                contents = '(' .. filename .. ') ' .. contents
            end
        else
            contents = msg.content
        end

        table.insert(msgs, client_name .. ' ' .. contents)
        last = client_name .. ' ' .. contents
    end
    return last
end

