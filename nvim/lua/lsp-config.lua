-- LSP settings
local status_ok, nvim_lsp = pcall(require, "lspconfig")
if not status_ok then
  -- Plugin not found, return early to avoid errors
  return
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- LSP servers configuration, add 'lua_ls' to auto-install
local servers = { "lua_ls" }

-- Mason setup
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = servers, -- Ensure the Lua language server is installed
}

-- Callback function when LSP server attaches to buffer
local on_attach = function(client, bufnr)
  -- Key mappings for LSP
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
end

-- Setup LSP servers
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Special configuration for lua_ls
nvim_lsp.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- For ARM version of clangd, specify the path if needed
nvim_lsp.clangd.setup {
  cmd = { "/usr/bin/clangd" }, -- Adjust path if necessary
  on_attach = on_attach,
  capabilities = capabilities,
}
