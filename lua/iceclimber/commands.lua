local M = {}

local handlers = {
  scroll_left = function(cmd)
    vim.cmd("normal! " .. (cmd.count or 1) .. "zh")
  end,
  scroll_right = function(cmd)
    vim.cmd("normal! " .. (cmd.count or 1) .. "zl")
  end,
  cursor_move = function(cmd)
    vim.api.nvim_win_set_cursor(0, { cmd.line, cmd.col })
  end,
  goodbye = function(_)
    require("iceclimber").stop()
  end,
}

function M.dispatch(cmd)
  local handler = handlers[cmd.type]
  if handler then
    handler(cmd)
  else
    vim.notify("iceclimber: unknown command type " .. tostring(cmd.type), vim.log.levels.WARN)
  end
end

return M
