-- lua/iceclimber/job.lua
local M = {}

local job = nil -- vim.SystemObj handle

local log_path = vim.fn.stdpath("cache") .. "/iceclimber.log"

local function append_log(line)
  local fd = io.open(log_path, "a")
  if fd then
    fd:write(os.date("%H%M%S") .. " " .. line .. "\n")
    fd.close(fd)
  end
end

local function plugin_root()
  local str = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(str, ":h:h:h") -- up from lua/iceclimber/job.lua
end

vim.api.nvim_create_user_command("IceClimberLog", function()
  vim.cmd("tabnew " .. log_path)
end, {})

function M.binary_path()
  local dev_path = plugin_root() .. "/../iceclimber" -- Go project root
  if vim.fn.executable(dev_path) == 1 then return dev_path end
  return "iceclimber" -- fall back to $PATH
end

function M.start(on_ready)
  if job ~= nil then
    vim.notify("iceclimber already running", vim.log.levels.WARN)
    return
  end

  local bin = M.binary_path()

  job = vim.system({ bin }, {
    stdout = function(err, data)
      if err then
        vim.schedule(function()
          vim.notify("iceclimber stdout error: " .. err, vim.log.levels.ERROR)
        end)
        return
      end
      if data then
        if data:find("ICECLIMBER_READY") then vim.schedule(on_ready) end
        append_log(data)
      end
    end,
    stderr = function(_, data)
      if data then append_log(data) end
    end,
  }, function(obj)
    vim.schedule(function()
      vim.notify("iceclimber exited: code " .. obj.code, vim.log.levels.INFO)
      job = nil
    end)
  end)
end

function M.stop()
  if job then
    job:kill(15) -- SIGTERM
    job = nil
  else
    vim.notify("iceclimber not running", vim.log.levels.WARN)
  end
end

function M.is_running()
  return job ~= nil
end

return M
