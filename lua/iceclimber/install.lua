local M = {}

local repo = "DavyJonesStockings/iceclimber"
local data_dir = vim.fn.stdpath("data") .. "/iceclimber"
local bin_dir = data_dir .. "/bin"

local function binary_name()
  return "iceclimber"
end

function M.binary_path()
  return bin_dir .. "/" .. binary_name()
end

function M.installed()
  return vim.uv.fs_stat(M.binary_path()) ~= nil
end

local function run(cmd)
  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    error(
      string.format(
        "iceclimber: command failed (%d): %s\n%s",
        result.code,
        table.concat(cmd, " "),
        result.stderr or ""
      )
    )
  end
  return result
end

local function fetch_latest_release()
  if vim.fn.executable("curl") == 0 then
    error("iceclimber: curl is required to install the binary")
  end

  local url = string.format("https://api.github.com/repos/%s/releases/latest", repo)
  local result = run({ "curl", "-fsSL", url })

  local ok, decoded = pcall(vim.json.decode, result.stdout)
  if not ok or not decoded then error("iceclimber: failed to parse GitHub release JSON") end
  return decoded
end

local function find_asset(release)
  for _, asset in ipairs(release.assets or {}) do
    local name = asset.name:lower()
    if name:find("iceclimber", 1, true) then return asset end
  end
  error(
    string.format(
      "iceclimber: no linux release asset found (found: %s)",
      table.concat(
        vim.tbl_map(function(a)
          return a.name
        end, release.assets or {}),
        ", "
      )
    )
  )
end

function M.install_latest_release()
  vim.notify("Installing iceclimber binary...")

  local ok, err = pcall(function()
    vim.fn.mkdir(bin_dir, "p")

    local release = fetch_latest_release()
    local asset = find_asset(release)

    run({ "curl", "-fsSL", "-o", M.binary_path(), asset.browser_download_url })
    vim.uv.fs_chmod(M.binary_path(), 493) -- 0755
  end)

  if not ok then
    vim.notify("iceclimber install failed: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end

  vim.notify("iceclimber installed successfully")
  return true
end

-- wrapper around install_latest that can be checked on startup
function M.ensure()
  if M.installed() then return true end

  M.install_latest_release()
end

return M
