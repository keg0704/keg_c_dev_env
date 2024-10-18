local line_numbers_enabled = true
local lsp_diagnostics_enabled = true

vim.api.nvim_set_keymap('n', '<leader>z', ':ZenMode<CR>', { noremap = true, silent = true })

local function enable_every_thing()
	vim.cmd("IBLEnable")
	vim.cmd("set nu rnu")
	vim.diagnostic.enable()
end

function Toggle_helper_informations()
	vim.cmd("IBLToggle")

	-- mock nu rnu toggle
	if line_numbers_enabled then
		vim.cmd("set nonu nornu")
	else
		vim.cmd("set nu rnu")
	end
	line_numbers_enabled = not line_numbers_enabled

	-- mock diagnostic toggle
	if lsp_diagnostics_enabled then
		vim.diagnostic.disable()
	else
		vim.diagnostic.enable()
	end
	lsp_diagnostics_enabled = not lsp_diagnostics_enabled
end

require("zen-mode").setup {
	window = {
	},
	on_open = function()
		enable_every_thing()

		vim.api.nvim_buf_set_keymap(0, "n", "<leader>d", ":lua Toggle_helper_informations()<CR>",
			{ noremap = true, silent = true })
		print("Press <leader>d to toggle ibl and line numbers")
	end,
	on_close = function()
		enable_every_thing()
		vim.api.nvim_buf_del_keymap(0, "n", "<leader>d")
	end
}
