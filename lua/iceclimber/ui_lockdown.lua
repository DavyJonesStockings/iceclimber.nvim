local M = {}

local saved = {}

function M.enable(win)
  saved.diagnostic = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(false)

  saved.updatetime = vim.o.updatetime
  vim.o.updatetime = 10000

  saved.win = win
  saved.wrap = vim.wo[win].wrap
  vim.wo[win].wrap = false
end

function M.disable()
  print("ui_lockdown.disable called, restoring wrap to:", saved.wrap, "for win:", saved.win) -- temp debug
  vim.diagnostic.enable(saved.diagnostic)
  vim.o.updatetime = saved.updatetime

  if saved.win and vim.api.nvim_win_is_valid(saved.win) then vim.wo[saved.win].wrap = saved.wrap end
end

return M
