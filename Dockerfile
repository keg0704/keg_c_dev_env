FROM ubuntu:latest AS prerequisites

RUN apt update
RUN apt upgrade -y
RUN apt install git -y
RUN apt install cmake -y
RUN apt install build-essential -y
RUN apt install unzip -y
RUN apt install wget -y
RUN apt install gettext -y

# neovim install from source
RUN git clone https://github.com/neovim/neovim.git \
&& cd /neovim \
&& make -j 8 install \
&& rm -rf /neovim

# FROM yourDesiredBaseImage
FROM ubuntu:latest

RUN apt update \
&& apt upgrade -y \
&& apt install git -y \
&& apt install python3 -y \
&& apt install python3-venv -y \
&& apt install clang-format -y \
&& apt install build-essential -y \
&& apt install unzip -y \
&& apt install gettext -y

COPY --from=prerequisites /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=prerequisites /usr/local/share/nvim /usr/local/share/nvim

RUN mkdir -p /root/.config/nvim
RUN echo -e "-- Install packer\n
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'\n
local is_bootstrap = false\n
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then\n
  is_bootstrap = true\n
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }\n
  vim.cmd [[packadd packer.nvim]]\n
end\n
\n
require('packer').startup(function(use)\n
  -- Package manager\n
  use 'wbthomason/packer.nvim'\n
\n
  use { -- LSP Configuration & Plugins\n
    'neovim/nvim-lspconfig',\n
    requires = {\n
      -- Automatically install LSPs to stdpath for neovim\n
      'williamboman/mason.nvim',\n
      'williamboman/mason-lspconfig.nvim',\n
\n
      -- Useful status updates for LSP\n
      'j-hui/fidget.nvim',\n
\n
      -- Additional lua configuration, makes nvim stuff amazing\n
      'folke/neodev.nvim',\n
    },\n
  }\n
\n
  use 'jose-elias-alvarez/null-ls.nvim'\n
\n
  use {\n
    "ThePrimeagen/refactoring.nvim",\n
    requires = {\n
      { "nvim-lua/plenary.nvim" },\n
      { "nvim-treesitter/nvim-treesitter" }\n
    }\n
  }\n
\n
  use { -- Autocompletion\n
    'hrsh7th/nvim-cmp',\n
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },\n
  }\n
\n
  use { -- Highlight, edit, and navigate code\n
    'nvim-treesitter/nvim-treesitter',\n
    run = function()\n
      pcall(require('nvim-treesitter.install').update { with_sync = true })\n
    end,\n
  }\n
\n
  use { -- Additional text objects via treesitter\n
    'nvim-treesitter/nvim-treesitter-textobjects',\n
    after = 'nvim-treesitter',\n
  }\n
\n
  -- Git related plugins\n
  use 'tpope/vim-fugitive'\n
  use 'tpope/vim-rhubarb'\n
  use 'lewis6991/gitsigns.nvim'\n
\n
  use 'navarasu/onedark.nvim' -- Theme inspired by Atom\n
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline\n
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines\n
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines\n
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically\n
\n
  -- Fuzzy Finder (files, lsp, etc)\n
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }\n
\n
  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available\n
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }\n
\n
  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua\n
  local has_plugins, plugins = pcall(require, 'custom.plugins')\n
  if has_plugins then\n
    plugins(use)\n
  end\n
\n
  if is_bootstrap then\n
    require('packer').sync()\n
  end\n
end)\n
\n
\n
-- When we are bootstrapping a configuration, it doesn't\n
-- make sense to execute the rest of the init.lua.\n
--\n
-- You'll need to restart nvim, and then it will work.\n
if is_bootstrap then\n
   print '=================================='\n
   print '    Plugins are being installed'\n
   print '    Wait until Packer completes,'\n
   print '       then restart nvim'\n
   print '=================================='\n
   return\n
end\n
\n
--\n
-- Automatically source and re-compile packer whenever you save this init.lua\n
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })\n
vim.api.nvim_create_autocmd('BufWritePost', {\n
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',\n
  group = packer_group,\n
  pattern = vim.fn.expand '$MYVIMRC',\n
})\n
\n
-- [[ Setting options ]]\n
-- See `:help vim.o`\n
\n
-- Set highlight on search\n
vim.o.hlsearch = false\n
\n
-- Make line numbers default\n
vim.wo.number = true\n
\n
-- Set relative numbers to true\n
vim.o.relativenumber = true\n
\n
-- Enable mouse mode\n
vim.o.mouse = 'a'\n
\n
-- Enable break indent\n
vim.o.breakindent = true\n
\n
-- Save undo history\n
vim.o.undofile = true\n
\n
-- Case insensitive searching UNLESS /C or capital in search\n
vim.o.ignorecase = true\n
vim.o.smartcase = true\n
\n
-- Decrease update time\n
vim.o.updatetime = 250\n
vim.wo.signcolumn = 'yes'\n
\n
-- Set colorscheme\n
vim.o.termguicolors = true\n
vim.cmd [[colorscheme onedark]]\n
\n
-- Set completeopt to have a better completion experience\n
vim.o.completeopt = 'menuone,noselect'\n
\n
-- [[ Basic Keymaps ]]\n
-- Set <space> as the leader key\n
-- See `:help mapleader`\n
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)\n
vim.g.mapleader = ' '\n
vim.g.maplocalleader = ' '\n
\n
-- Keymaps for better default experience\n
-- See `:help vim.keymap.set()`\n
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })\n
\n
-- Remap for dealing with word wrap\n
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })\n
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })\n
\n
-- [[ Highlight on yank ]]\n
-- See `:help vim.highlight.on_yank()`\n
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })\n
vim.api.nvim_create_autocmd('TextYankPost', {\n
  callback = function()\n
    vim.highlight.on_yank()\n
  end,\n
  group = highlight_group,\n
  pattern = '*',\n
})\n
\n
-- Set lualine as statusline\n
-- See `:help lualine.txt`\n
require('lualine').setup {\n
  options = {\n
    icons_enabled = false,\n
    theme = 'onedark',\n
    component_separators = '|',\n
    section_separators = '',\n
  },\n
}\n
\n
-- Enable Comment.nvim\n
require('Comment').setup()\n
\n
-- Enable `lukas-reineke/indent-blankline.nvim`\n
-- See `:help indent_blankline.txt`\n
require('indent_blankline').setup {\n
  char = '┊',\n
  show_trailing_blankline_indent = false,\n
}\n
\n
-- Gitsigns\n
-- See `:help gitsigns.txt`\n
require('gitsigns').setup {\n
  signs = {\n
    add = { text = '+' },\n
    change = { text = '~' },\n
    delete = { text = '_' },\n
    topdelete = { text = '‾' },\n
    changedelete = { text = '~' },\n
  },\n
}\n
\n
-- [[ Configure Telescope ]]\n
-- See `:help telescope` and `:help telescope.setup()`\n
require('telescope').setup {\n
  defaults = {\n
    mappings = {\n
      i = {\n
        ['<C-u>'] = false,\n
        ['<C-d>'] = false,\n
      },\n
    },\n
  },\n
}\n
\n
-- Enable telescope fzf native, if installed\n
pcall(require('telescope').load_extension, 'fzf')\n
\n
-- See `:help telescope.builtin`\n
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })\n
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })\n
vim.keymap.set('n', '<leader>/', function()\n
  -- You can pass additional configuration to telescope to change theme, layout, etc.\n
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {\n
    winblend = 10,\n
    previewer = false,\n
  })\n
end, { desc = '[/] Fuzzily search in current buffer]' })\n
\n
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })\n
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })\n
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })\n
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })\n
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })\n
\n
-- Diagnostic keymaps\n
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)\n
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)\n
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)\n
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)\n
\n
-- [[ Configure Treesitter ]]\n
-- See `:help nvim-treesitter`\n
require('nvim-treesitter.configs').setup {\n
  -- Add languages to be installed here that you want installed for treesitter\n
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help', 'vim' },\n
\n
  highlight = { enable = true, additional_vim_regex_highlighting = false, },\n
  indent = { enable = true, disable = { 'python' } },\n
  incremental_selection = {\n
    enable = true,\n
    keymaps = {\n
      init_selection = '<c-space>',\n
      node_incremental = '<c-space>',\n
      scope_incremental = '<c-s>',\n
      node_decremental = '<c-backspace>',\n
    },\n
  },\n
  textobjects = {\n
    select = {\n
      enable = true,\n
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim\n
      keymaps = {\n
        -- You can use the capture groups defined in textobjects.scm\n
        ['aa'] = '@parameter.outer',\n
        ['ia'] = '@parameter.inner',\n
        ['af'] = '@function.outer',\n
        ['if'] = '@function.inner',\n
        ['ac'] = '@class.outer',\n
        ['ic'] = '@class.inner',\n
      },\n
    },\n
    move = {\n
      enable = true,\n
      set_jumps = true, -- whether to set jumps in the jumplist\n
      goto_next_start = {\n
        [']m'] = '@function.outer',\n
        [']]'] = '@class.outer',\n
      },\n
      goto_next_end = {\n
        [']M'] = '@function.outer',\n
        [']['] = '@class.outer',\n
      },\n
      goto_previous_start = {\n
        ['[m'] = '@function.outer',\n
        ['[['] = '@class.outer',\n
      },\n
      goto_previous_end = {\n
        ['[M'] = '@function.outer',\n
        ['[]'] = '@class.outer',\n
      },\n
    },\n
    swap = {\n
      enable = true,\n
      swap_next = {\n
        ['<leader>a'] = '@parameter.inner',\n
      },\n
      swap_previous = {\n
        ['<leader>A'] = '@parameter.inner',\n
      },\n
    },\n
  },\n
}\n
\n
-- LSP settings.\n
--  This function gets run when an LSP connects to a particular buffer.\n
local on_attach = function(_, bufnr)\n
  -- NOTE: Remember that lua is a real programming language, and as such it is possible\n
  -- to define small helper and utility functions so you don't have to repeat yourself\n
  -- many times.\n
  --\n
  -- In this case, we create a function that lets us more easily define mappings specific\n
  -- for LSP related items. It sets the mode, buffer and description for us each time.\n
  local nmap = function(keys, func, desc)\n
    if desc then\n
      desc = 'LSP: ' .. desc\n
    end\n
\n
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })\n
  end\n
\n
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')\n
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')\n
\n
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')\n
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')\n
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')\n
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')\n
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')\n
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')\n
\n
  -- See `:help K` for why this keymap\n
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')\n
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')\n
\n
  -- Lesser used LSP functionality\n
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')\n
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')\n
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')\n
  nmap('<leader>wl', function()\n
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))\n
  end, '[W]orkspace [L]ist Folders')\n
\n
  -- Create a command `:Format` local to the LSP buffer\n
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)\n
    vim.lsp.buf.format()\n
  end, { desc = 'Format current buffer with LSP' })\n
end\n
\n
-- Enable the following language servers\n
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.\n
--\n
--  Add any additional override configuration in the following tables. They will be passed to\n
--  the `settings` field of the server config. You must look up that documentation yourself.\n
local servers = {\n
  -- clangd = {},\n
  -- gopls = {},\n
  -- pyright = {},\n
  -- rust_analyzer = {},\n
  -- tsserver = {},\n
\n
  sumneko_lua = {\n
    Lua = {\n
      workspace = { checkThirdParty = false },\n
      telemetry = { enable = false },\n
    },\n
  },\n
}\n
\n
-- Setup neovim lua configuration\n
require('neodev').setup()\n
--\n
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers\n
local capabilities = vim.lsp.protocol.make_client_capabilities()\n
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)\n
\n
-- Setup mason so it can manage external tooling\n
require('mason').setup()\n
\n
-- Ensure the servers above are installed\n
local mason_lspconfig = require 'mason-lspconfig'\n
\n
mason_lspconfig.setup {\n
  ensure_installed = vim.tbl_keys(servers),\n
}\n
\n
mason_lspconfig.setup_handlers {\n
  function(server_name)\n
    require('lspconfig')[server_name].setup {\n
      capabilities = capabilities,\n
      on_attach = on_attach,\n
      settings = servers[server_name],\n
    }\n
  end,\n
}\n
\n
-- Turn on lsp status information\n
require('fidget').setup()\n
\n
-- nvim-cmp setup\n
local cmp = require 'cmp'\n
local luasnip = require 'luasnip'\n
\n
cmp.setup {\n
  snippet = {\n
    expand = function(args)\n
      luasnip.lsp_expand(args.body)\n
    end,\n
  },\n
  mapping = cmp.mapping.preset.insert {\n
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),\n
    ['<C-f>'] = cmp.mapping.scroll_docs(4),\n
    ['<C-Space>'] = cmp.mapping.complete(),\n
    ['<CR>'] = cmp.mapping.confirm {\n
      behavior = cmp.ConfirmBehavior.Replace,\n
      select = true,\n
    },\n
    ['<Tab>'] = cmp.mapping(function(fallback)\n
      if cmp.visible() then\n
        cmp.select_next_item()\n
      elseif luasnip.expand_or_jumpable() then\n
        luasnip.expand_or_jump()\n
      else\n
        fallback()\n
      end\n
    end, { 'i', 's' }),\n
    ['<S-Tab>'] = cmp.mapping(function(fallback)\n
      if cmp.visible() then\n
        cmp.select_prev_item()\n
      elseif luasnip.jumpable(-1) then\n
        luasnip.jump(-1)\n
      else\n
        fallback()\n
      end\n
    end, { 'i', 's' }),\n
  },\n
  sources = {\n
    { name = 'nvim_lsp' },\n
    { name = 'luasnip' },\n
  },\n
}\n
\n
-- The line beneath this is called `modeline`. See `:help modeline`\n
-- vim: ts=2 sts=2 sw=2 et \n" >> /root/.config/nvim/init.lua
# COPY nvim /root/.config/nvim
