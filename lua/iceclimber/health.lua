-- lua/iceclimber/health.lua
local M = {}

function M.check()
  vim.health.start("iceclimber.nvim")
  if vim.fn.has("nvim-0.12") == 1 then
    vim.health.ok("Neovim version OK")
  else
    vim.health.error("Needs Neovim >= 0.12")
  end
end

return M -- <-- this line
