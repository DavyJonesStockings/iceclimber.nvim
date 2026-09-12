local M = {}

local job = nil -- vim.SystemObj handle

local config = require("iceclimber.config")

local log_path = vim.fn.stdpath("cache") .. "/iceclimber.log"
local data_dir = vim.fn.stdpath("data") .. "/iceclimber"
local bin_dir = data_dir .. "/bin"

local function binary_name()
  return "iceclimber"
end

function M.binary_path()
  if config.options.binary == "default" then
    return bin_dir .. "/" .. binary_name()
  else
    return config.options.binary
  end
end

local function append_log(line)
  local fd = io.open(log_path, "a")
  if fd then
    fd:write(os.date("%H%M%S") .. " " .. line .. "\n")
    fd.close(fd)
  end
end

vim.api.nvim_create_user_command("IceClimberLog", function()
  vim.cmd("tabnew " .. log_path)
end, {})

function M.start(on_ready, opts)
  if job ~= nil then
    vim.notify("iceclimber already running", vim.log.levels.WARN)
    return
  end

  opts = opts or {}

  local bin = M.binary_path()
  print(bin)
  if not require("iceclimber.install").installed() then
    vim.notify("Go binary not found; installing latest release now.")
    require("iceclimber.install").install_latest_release()
  end
  local cmd = { bin }
  if opts.debug then table.insert(cmd, "--debug_overlay=true") end

  job = vim.system(cmd, {
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
