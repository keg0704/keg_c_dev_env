-- General settings
vim.o.hlsearch = false
vim.wo.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.completeopt = "menuone,noselect"

-- Set colorscheme
local status_ok, onedark = pcall(require, "onedark")
if status_ok then
	onedark.load()
end
