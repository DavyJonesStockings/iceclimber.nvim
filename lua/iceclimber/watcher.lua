local M = {}

local target_win = nil
local target_buf = nil
local events = require("iceclimber.events")

local function is_target_win(win)
  return win == target_win and vim.api.nvim_win_is_valid(win)
end

local function get_render_config(win)
  local wininfo = vim.fn.getwininfo(win)[1]
  return {
    gutter_left = wininfo and wininfo.textoff or 0,
  }
end

local function get_visible_state()
  local top = vim.fn.line("w0", target_win)
  local bot = vim.fn.line("w$", target_win)
  local raw_lines = vim.api.nvim_buf_get_lines(target_buf, top - 1, bot, false)
  local view = vim.api.nvim_win_call(target_win, vim.fn.winsaveview)

  local lines = {}
  for i, text in ipairs(raw_lines) do
    lines[i] = { text = text, width = vim.fn.strdisplaywidth(text) }
  end

  return {
    type = events.event.state,
    top = top,
    bot = bot,
    win_width = vim.api.nvim_win_get_width(target_win),
    win_height = vim.api.nvim_win_get_height(target_win),
    screen_cols = vim.o.columns,
    screen_rows = vim.o.lines,
    leftcol = view.leftcol,
    lines = lines,
    cursor = vim.api.nvim_win_get_cursor(target_win),
    config = get_render_config(target_win),
  }
end

function M.start(on_update)
  target_win = vim.api.nvim_get_current_win()
  target_buf = vim.api.nvim_get_current_buf()

  local group = vim.api.nvim_create_augroup("IceClimberWatcher", { clear = true })

  vim.api.nvim_create_autocmd({ "WinScrolled", "VimResized" }, {
    group = group,
    callback = function(args)
      if args.event == "WinScrolled" and tostring(target_win) ~= args.match then return end
      if is_target_win(target_win) then on_update(get_visible_state()) end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
    group = group,
    buffer = target_buf,
    callback = function()
      require("iceclimber").stop()
    end,
  })

  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = function()
      require("iceclimber.socket").send({ type = "resume_focus" })
    end,
  })

  vim.api.nvim_buf_attach(target_buf, false, {
    on_lines = function()
      vim.schedule(function()
        on_update(get_visible_state())
      end)
    end,
  })

  on_update(get_visible_state())
end

function M.stop()
  vim.api.nvim_clear_autocmds({ group = "IceClimberWatcher" })
end

return M
