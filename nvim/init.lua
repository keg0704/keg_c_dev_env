-- --- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install packer if not installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  vim.cmd([[packadd packer.nvim]])
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- LSP and completion
  use 'neovim/nvim-lspconfig'    -- LSP configurations
  use 'williamboman/mason.nvim'  -- LSP manager
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/nvim-cmp'         -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'     -- LSP source for nvim-cmp
  use 'L3MON4D3/LuaSnip'         -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip' -- Snippet completion source for nvim-cmp

  -- Debugging
  use 'mfussenegger/nvim-dap' -- DAP client
  use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap', "nvim-neotest/nvim-nio" } }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter' -- Ensure this is loaded after nvim-treesitter
  }

  -- Telescope
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable('make') == 1 }

  -- Git plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- UI enhancements
  use 'navarasu/onedark.nvim'               -- Theme
  use 'nvim-lualine/lualine.nvim'           -- Statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Indentation guides

  -- Utility plugins
  use 'numToStr/Comment.nvim'       -- Commenting utility
  use 'tpope/vim-sleuth'            -- Automatically detect indentation
  use 'nvim-tree/nvim-tree.lua'     -- File explorer
  use 'nvim-tree/nvim-web-devicons' -- File icons

  -- null-ls: Additional LSP functionality
  use 'jose-elias-alvarez/null-ls.nvim'

  -- Additional plugins...

  -- Sync plugins if it's the first time Packer is loaded
  if is_bootstrap then
    require('packer').sync()
  end
end)

-- Only load other configurations after plugin sync completes
if not is_bootstrap then
  -- Load configuration files
  require('settings')          -- Basic Vim settings
  require('keymaps')           -- Key mappings
  require('lsp-config')        -- LSP configuration
  require('dap-config')        -- DAP configuration
  require('treesitter-config') -- Treesitter configuration
  require('telescope-config')  -- Telescope configuration
  require('gitsigns-config')   -- Gitsigns configuration
  require('lualine-config')    -- Lualine configuration
  require('comment-config')    -- Comment.nvim configuration
  require('null-ls-config')    -- null-ls configuration
  require('nvim-cmp-config')   -- nvim-cmp configuration
  require('autocmds')          -- Autocommands
  require('ibl-config')        -- Indentation
  require('nvim-tree-config')  -- File Browser

  -- Highlight on yank
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })
end

-- Auto recompile packer when plugins.lua changes
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])
