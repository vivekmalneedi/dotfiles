-- options
vim.o.shell = '/bin/bash'
vim.o.completeopt = "menuone,noselect"
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
vim.o.hidden = true
vim.cmd('set clipboard=unnamed,unnamedplus')
vim.cmd([[let mapleader="\<SPACE>"]])

-- search
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.ignorecase = true

-- Permanent undo
vim.o.undofile = true
vim.bo.undofile = true

-- highlighted yank
vim.cmd('au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}')

-- plugins
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'packadd packer.nvim'
end

require('packer').startup(function(use)
    -- general
    use 'wbthomason/packer.nvim'
    use 'mhartington/oceanic-next'
    use 'bluz71/vim-nightfly-guicolors'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/playground'
    use 'windwp/nvim-autopairs'

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
                    lualine_a = { {'mode', upper = true} },
                    lualine_b = { {'branch', icon = ''} },
                    lualine_c = { {'filename', file_status = true}, GetLspMessages },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location', {'diagnostics', sources = {'nvim_lsp'}}},
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
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
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
        "blackCauldron7/surround.nvim",
        config = function()
            require "surround".setup {}
        end
    }
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
    use "folke/lua-dev.nvim"
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
    use {'simrat39/rust-tools.nvim',
        config = function()
            require('rust-tools').setup{}
        end
    }
    use {"ellisonleao/glow.nvim", run = "GlowInstall"}
    use 'sindrets/diffview.nvim'
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require'cmp'
            local types = require('cmp.types')
            cmp.setup({
                preselect = types.cmp.PreselectMode.None,
                mapping = {
                    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' }
                }
            })
        end
    }
end)

-- syntax and colors
vim.cmd('colorscheme nightfly')

require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
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

-- dap
--[[ require('telescope').load_extension('dap')
local dap = require('dap')
dap.adapters.lldb = {
type = 'executable',
command = 'lldb-vscode',
name = "lldb"
}


dap.configurations.cpp = {
{
name = "Launch",
type = "lldb",
request = "launch",
program = function()
return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end,
cwd = '${workspaceFolder}',
stopOnEntry = false,
args = {},
runInTerminal = false,
},
}

require('dap.ext.vscode').load_launchjs()

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp ]]

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

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
            ]], false)
    end
    lsp_status.on_attach(client)
    require'lsp_signature'.on_attach({
        bind = true,
        handler_opts = {
            border = "single"
        }
    })
end

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

local servers = { "pyright", "jsonls", "yamlls", "bashls", "cmake", "dockerls"}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

local clangd_capabilities = vim.tbl_deep_extend(
  'force',
  capabilities,
  {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  }
)
nvim_lsp.clangd.setup({
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
    on_attach = on_attach,
    capabilities = clangd_capabilities
})

local luadev = require("lua-dev").setup({
    lspconfig = {
        cmd = {"lua-language-server"}
    },
})
nvim_lsp.sumneko_lua.setup(luadev)

local util = require 'lspconfig/util'
local root_pattern = util.root_pattern("veridian.yml", ".git")
local configs = require'lspconfig/configs'
configs.veridian = {
    default_config = {
        cmd = {"veridian"};
        filetypes = {"systemverilog", "verilog"};
        root_dir = function(fname)
            local filename = util.path.is_absolute(fname) and fname
                or util.path.join(vim.loop.cwd(), fname)
            return root_pattern(filename) or util.path.dirname(filename)
        end;
        settings = {};
    };
}
nvim_lsp.veridian.setup{on_attach = on_attach}
