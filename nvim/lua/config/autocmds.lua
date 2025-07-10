-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Disable line numbers in terminal buffers
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = augroup("disable_term_numbers"),
  callback = function()
    vim.cmd("setlocal nonumber norelativenumber")
  end,
})
