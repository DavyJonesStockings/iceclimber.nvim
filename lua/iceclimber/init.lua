-- lua/my-plugin/init.lua
local M = {}

M.config = {
  greeting = "hello from iceclimber",
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.start()
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

  require("iceclimber.job").start(on_ready)
end

function M.stop()
  require("iceclimber.job").stop()
  require("iceclimber.ui_lockdown").disable()
end

function M.say_hello()
  vim.notify(M.config.greeting)
end

return M
