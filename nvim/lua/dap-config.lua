-- Debug Adapter Protocol (DAP) configuration
local dap = require("dap")
local dapui = require("dapui")

-- GDB adapter configuration
dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "-i", "dap" },
}

-- C/C++ configurations
dap.configurations.cpp = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = false,
	},
}

dap.configurations.c = dap.configurations.cpp

require('dap-python').setup('python') -- use current python env

dap.configurations.python = {
	{
		type = 'python',
		request = 'launch',
		name = 'Launch file',
		program = '${file}', -- dap work on current file
		pythonPath = function()
			-- check if is under virualenv
			local venv_path = os.getenv('VIRTUAL_ENV')
			if venv_path then
				return venv_path .. '/bin/python'
			end
			-- if not try to activate .venv under cwd
			if vim.fn.isdirectory(vim.fn.getcwd() .. '/.venv') == 1 then
				return vim.fn.getcwd() .. '/.venv/bin/python'
			end
			-- otherwise use system default python
			return '/usr/bin/python'
		end,
	},
}

-- DAP UI setup
dapui.setup()

-- Open DAP UI automatically
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- Function to close nvim-tree when debugging starts, and reopen when debugging being terminated or exited
dap.listeners.after.event_initialized["close_nvim_tree"] = function()
	vim.cmd("NvimTreeClose")
end
dap.listeners.before.event_terminated["reopen_nvim_tree"] = function()
	vim.cmd("NvimTreeOpen")
	-- Switch focus back to the file buffer
	vim.cmd("wincmd p")
end
dap.listeners.before.event_exited["reopen_nvim_tree"] = function()
	vim.cmd("NvimTreeOpen")
	-- Switch focus back to the file buffer
	vim.cmd("wincmd p")
end

-- Key mappings for DAP
vim.api.nvim_set_keymap("n", "<Leader>db", ":DapToggleBreakpoint<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>dc", ":DapContinue<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>dn", ":DapStepOver<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>di", ":DapStepInto<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>do", ":DapStepOut<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>dt", ":DapTerminate<CR>", { noremap = true })

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })
