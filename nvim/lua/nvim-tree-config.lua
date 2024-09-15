require("nvim-tree").setup()

-- open nvim-tree on start up
local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open()
end

-- Automatically open nvim-tree and move focus to the file window
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Open nvim-tree
    require("nvim-tree.api").tree.open()
    -- Move cursor to the file window
    vim.cmd("wincmd l")
  end
})
