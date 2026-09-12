local M = {}

M.config = {}

function M.setup(opts)
  require("iceclimber.config").setup(opts)
  require("iceclimber.install").ensure()
end

function M.start(opts)
  local win = vim.api.nvim_get_current_win()
  require("iceclimber.ui_lockdown").enable(win)

  local events = require("iceclimber.events")

  local function on_command(cmd)
    require("iceclimber.commands").dispatch(cmd)
  end

  local function on_state(state)
    require("iceclimber.socket").send(state)
  end

  local function on_connect()
    require("iceclimber.socket").send({
      type = events.event.hello,
      pid = vim.fn.getpid(),
    })
    require("iceclimber.watcher").start(on_state)
  end

  local function on_ready()
    require("iceclimber.socket").connect("127.0.0.1", 4545, on_connect, on_command)
  end

  require("iceclimber.job").start(on_ready, opts)
end

function M.stop()
  require("iceclimber.job").stop()
  require("iceclimber.ui_lockdown").disable()
end

return M
