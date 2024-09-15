-- Debug Adapter Protocol (DAP) configuration
local dap = require('dap')
local dapui = require('dapui')

-- GDB adapter configuration
dap.adapters.gdb = {
  type = 'executable',
  command = 'gdb',
  args = { '-i', 'dap' },
}

-- C/C++ configurations
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'gdb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
  },
}

dap.configurations.c = dap.configurations.cpp

-- DAP UI setup
dapui.setup()

-- Open DAP UI automatically
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

-- Key mappings for DAP
vim.api.nvim_set_keymap('n', '<Leader>db', ':DapToggleBreakpoint<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>dc', ':DapContinue<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>dn', ':DapStepOver<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>di', ':DapStepInto<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>do', ':DapStepOut<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>dt', ':DapTerminate<CR>', { noremap = true })
