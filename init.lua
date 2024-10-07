-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

-- empty setup using defaults

vim.cmd 'set expandtab'
vim.cmd 'set tabstop=2'
vim.cmd 'set softtabstop=2'
vim.cmd 'set shiftwidth=2'
vim.g.mapleader = ' '
vim.wo.number = true

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://githubd.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    'lazypath',
  }
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'nvim-tree/nvim-tree.lua', version = '*', lazy = false, dependencies = {
    'nvim-tree/nvim-web-devicons',
  } },
  {
    'stevearc/conform.nvim',
    opts = {},
  },
  {
    'akinsho/nvim-bufferline.lua',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup()
    end,
  },
  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
  },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
  },
  {
    'williamboman/mason-lspconfig.nvim',
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
  },
  {
    'L3MON4D3/LuaSnip',
  },
}
local opts = {}

require('lazy').setup(plugins, opts)

require('nvim-tree').setup {
  view = {
    width = 30,
    side = 'left',
  },
  renderer = {
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = { '.cache' },
  },
  git = {
    enable = true,
    ignore = false,
  },
}

require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    javascript = { 'prettier', 'prettierd', stop_after_frist = true },
  },
}
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})

local builtin = require 'telescope.builtin'

local config = require 'nvim-treesitter.configs'
config.setup {
  ensure_installed = { 'lua', 'javascript', 'html', 'vim', 'rust', 'typescript', 'python', 'json', 'vue', 'tsx', 'css', 'yaml' },
  highlight = { enabled = true, additional_vim_regex_highlighting = false },
  indent = { enabled = true },
}

-- LSP setup
local lspconfig = require 'lspconfig'
local cmp = require 'cmp'

-- Setup nvim-cmp.
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
}

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.tsserver.setup {
  capabilities = capabilities,
}

-- Optionally, configure diagnostics display
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
  },
}

require('catppuccin').setup()
vim.cmd.colorscheme 'catppuccin'

-- Set <C-n> to toggle Nvim Tree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Find files
vim.keymap.set('n', '<C-p>', builtin.find_files, { noremap = true, silent = true })

-- Live Grep
vim.keymap.set('n', '<C-f>', builtin.live_grep, { noremap = true, silent = true })

-- Buffers
vim.keymap.set('n', '<leader>fb', builtin.buffers, { noremap = true, silent = true })

-- Help Tags
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { noremap = true, silent = true })

-- Move to previous/next buffer
vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
