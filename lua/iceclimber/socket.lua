local M = {}
local client = nil
local on_command = nil

function M.connect(host, port, on_connect, on_command_cb)
  on_command = on_command_cb
  client = vim.uv.new_tcp()
  if not client then
    vim.notify("failed to initialize tcp socket", vim.log.levels.ERROR)
    return
  end
  client:connect(host, port, function(err)
    if err then
      vim.schedule(function()
        vim.notify("iceclimber: TCP connect failed: " .. err, vim.log.levels.ERROR)
      end)
      return
    end
    client:read_start(function(read_err, data)
      if read_err then return end
      if data then
        for line in data:gmatch("[^\n]+") do
          local ok, decoded = pcall(vim.json.decode, line)
          if ok and on_command then
            vim.schedule(function()
              on_command(decoded)
            end)
          end
        end
      else
        vim.schedule(function()
          require("iceclimber").stop()
        end)
      end
    end)
    vim.schedule(on_connect)
  end)
end

function M.send(tbl)
  if not client then return end
  local ok, encoded = pcall(vim.json.encode, tbl)
  if not ok then return end
  client:write(encoded .. "\n")
end

function M.close()
  if client then
    client:close()
    client = nil
  end
end

return M
