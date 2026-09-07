if vim.g.loaded_my_plugin then return end
vim.g.loaded_my_plugin = true

vim.api.nvim_create_user_command("IceClimberStart", function()
  require("iceclimber").start()
end, {})

vim.api.nvim_create_user_command("IceClimberStop", function()
  require("iceclimber").stop()
end, {})

vim.api.nvim_create_user_command("IceClimberResume", function()
  require("iceclimber.socket").send({ type = "resume_focus" })
end, {})

vim.api.nvim_create_user_command("IceClimberStatus", function()
  local running = require("iceclimber.job").is_running()
  vim.notify("iceclimber running: " .. tostring(running))
end, {})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("IceClimberCleanup", { clear = true }),
  callback = function()
    require("iceclimber.job").stop()
  end,
})
